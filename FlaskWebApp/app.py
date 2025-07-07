from flask import Flask, render_template, request, redirect, url_for, session, flash
from datetime import timedelta
import pyodbc

app = Flask(__name__)
app.secret_key = 'your_secret_key'
app.permanent_session_lifetime = timedelta(minutes=30)

# SQL Server connection string
conn_str = 'DRIVER={SQL Server};SERVER=LT-AKSHAY-PRECA\\MSSQLSERVER01;DATABASE=akshay;Trusted_Connection=yes;'


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()

        cursor.execute("SELECT EmployeeID, Password FROM EmpID_pass WHERE EmployeeID = ?", (username,))
        row = cursor.fetchone()
        conn.close()

        if row and row.Password == password:
            session.permanent = True
            session["user"] = username
            return redirect(url_for("dashboard"))
        else:
            flash("Invalid credentials", "error")
            return redirect(url_for("login"))

    return render_template("login.html")


@app.route("/dashboard")
def dashboard():
    if "user" in session:
        return render_template("form.html", user=session["user"], active_tab="Production")
    else:
        flash("You must log in to view this page", "error")
        return redirect(url_for("login"))


@app.route("/logout")
def logout():
    session.pop("user", None)
    flash("You have been logged out", "info")
    return redirect(url_for("login"))


@app.route('/submit_production', methods=['POST'])
def submit_production():
    if "user" not in session:
        return redirect(url_for("login"))

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    vol = request.form['volume']
    entry_date = request.form['entry_date']
    planned_date = request.form['planned_date']
    factory = request.form['factory']

    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO web_app_table 
        (Element, ElementType, Quantity, Volume, EntryDate, PlannedDate, Factory)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (element, element_type, qty, vol, entry_date, planned_date, factory))

    conn.commit()
    conn.close()

    return render_template("form.html", message="Production data submitted successfully!", active_tab="Production")


@app.route('/logistic', methods=['POST'])
def logistics():
    if "user" not in session:
        return redirect(url_for("login"))

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    recieved_date = request.form['recieved_date']
    production_date = request.form['production_date']
    recieved_by = request.form['recieved_by']

    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO Log_recieved_data 
        (Element, Type, [Recieved Quantity], [Production Date], [Recieved by], [Recieved Date])
        VALUES (?, ?, ?, ?, ?, ?)
    """, (element, element_type, qty, production_date, recieved_by, recieved_date))

    conn.commit()
    conn.close()

    return render_template("form.html", message="Logistics data saved successfully!", active_tab="Logistics")


@app.route('/retrieve', methods=['POST'])
def retrieve_data():
    if "user" not in session:
        return redirect(url_for("login"))

    startdate = request.form['start_date']
    enddate = request.form['end_date']

    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        SELECT 
            PlannedDate, 
            Element, 
            ElementType, 
            SUM(Quantity) AS Quantity, 
            SUM(Volume) AS Volume
        FROM web_app_table
        WHERE PlannedDate BETWEEN ? AND ?
        GROUP BY PlannedDate, Element, ElementType
    """, (startdate, enddate))

    rows = cursor.fetchall()
    columns = [column[0] for column in cursor.description]
    data = [dict(zip(columns, row)) for row in rows]

    conn.close()

    return render_template('form.html', records=data, message="Production data retrieved", active_tab="Retrieve")


if __name__ == '__main__':
    app.run(debug=True)
