/*
1.flask app to interact the webpage to the database
2.loging in with userid and password
3.once logged in based on the rights they are give acces to the tabs the can access
4.can push the production data to the database
5.using async onblur that is one element id entered and we leave the space
    it shows the balance quantity to be produce and if its already produced its passes a warning

*/


from flask import Flask, render_template, request, redirect, url_for, session, flash
from datetime import timedelta
import pyodbc


#### element extra check and warning




app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Use a secure, randomly generated key in production
app.permanent_session_lifetime = timedelta(minutes=30)

# SQL Server connection string
conn_str = 'DRIVER={SQL Server};SERVER=LT-AKSHAY-PRECA\\MSSQLSERVER01;DATABASE=prod_data;Trusted_Connection=yes;'

@app.route("/get_balance/<element_id>")
def get_balance(element_id):
    conn = pyodbc.connect(conn_str)

    cursor = conn.cursor()

    cursor.execute("""

                    SELECT element_id,COALESCE(sum(pending),0) pending FROM (
                            SELECT 
                                b.element_id,
                                SUM(b.per_building_total) AS per_building_total,
                                COALESCE(s.casted, 0) AS casted,
                                CASE 
                                    WHEN SUM(b.per_building_total) = 0 OR SUM(b.per_building_total) IS NULL THEN 0
                                    ELSE SUM(b.per_building_total) - COALESCE(s.casted, 0)
                                END AS pending
                            FROM silver.b15 b
                            LEFT JOIN (
                                -- total casted quantity per element
                                SELECT 
                                    element, 
                                    COALESCE(SUM(quantity), 0) AS casted
                                FROM (
                                    SELECT * FROM silver.carousal_fac
                                    UNION ALL
                                    SELECT * FROM silver.hcs_fac
                                    UNION ALL
                                    SELECT * FROM silver.special_fac
                                    UNION ALL
                                    SELECT * FROM silver.pod_fac
                                ) AS tot_casted
                                GROUP BY element
                            ) s ON b.element_id = s.element
                                    GROUP BY b.element_id,s.casted

                        ) gr
                        group by element_id,per_building_total,casted
                        having element_id = ?

                        """, (element_id,))
    row = cursor.fetchone()
    conn.close()

    if row:
        return {"pending": float(row.pending)}
    else:
        return {"pending": 0}


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()

        cursor.execute("SELECT userid, user_pass,Factory FROM bronze.user_tab WHERE userid = ?", (username,))
        row = cursor.fetchone()
        conn.close()

        if row and row.user_pass == password:
            session.permanent = True
            session["user"] = username
            session["role"] = row.Factory  # e.g., admin, HCS, POD etc.
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





@app.route('/submit_production/pod', methods=['POST'])
def submit_pod_production():
    if "user" not in session:
        return redirect(url_for("login"))

    # Role restriction
    if session["role"] not in ['Admin', 'POD']:
        return "Access Denied", 403

    # Get form data
    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    vol = request.form['volume']
    entry_date = request.form['entry_date']
    planned_date = request.form['planned_date']
    
    # Get from session
    factory = session.get("role", "Unknown")
    user_id = session.get("user", "Unknown")

    # DB insert
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.pod_fac
        (element_type, element, quantity, volume, data_in_date, prd_date, factory, userid)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (element_type, element, qty, vol, entry_date, planned_date, factory, user_id))

    conn.commit()
    conn.close()

    #flash("POD production data submitted successfully!", "success")
    #return redirect(url_for("dashboard"))
    return render_template("form.html", user=session["user"], message="Production data submitted successfully!", active_tab="Production")


@app.route('/submit_production/carousal', methods=['POST'])
def submit_carousal_production():
    if "user" not in session:
        return redirect(url_for("login"))
    
        # Role restriction
    if session["role"] not in ['Admin', 'CAROUSAL']:
        return "Access Denied", 403

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    vol = request.form['volume']
    entry_date = request.form['entry_date']
    planned_date = request.form['planned_date']
    factory = request.form['factory']

        # Get from session
    #factory = session.get("role", "Unknown")
    user_id = session.get("user", "Unknown")

    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.carousal_fac
        (element_type, element, quantity, volume, data_in_date, prd_date, factory,userid)
        VALUES (?, ?, ?, ?, ?, ?, ?,?)
    """, (element_type, element, qty, vol, entry_date, planned_date, factory,user_id))

    conn.commit()
    conn.close()

    return render_template("form.html", user=session["user"], message="Production data submitted successfully!", active_tab="Production")

@app.route('/submit_production/hcs', methods=['POST'])
def submit_hcs_production():
    if "user" not in session:
        return redirect(url_for("login"))
    
        # Role restriction
    if session["role"] not in ['Admin', 'HCS']:
        return "Access Denied", 403

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    vol = request.form['volume']
    entry_date = request.form['entry_date']
    planned_date = request.form['planned_date']
    factory = request.form['factory']

       # Get from session
    #factory = session.get("role", "Unknown")
    user_id = session.get("user", "Unknown")

    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.hcs_fac
        (element_type, element, quantity, volume, data_in_date, prd_date, factory,userid)
        VALUES (?, ?, ?, ?, ?, ?, ?,?)
    """, (element_type, element, qty, vol, entry_date, planned_date, factory,user_id))

    conn.commit()
    conn.close()

    return render_template("form.html", user=session["user"], message="Production data submitted successfully!", active_tab="Production")

@app.route('/submit_production/special', methods=['POST'])
def submit_special_production():
    if "user" not in session:
        return redirect(url_for("login"))
    # Role restriction
    if session["role"] not in ['Admin', 'HCS']:
        return "Access Denied", 403

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    vol = request.form['volume']
    entry_date = request.form['entry_date']
    planned_date = request.form['planned_date']
    factory = request.form['factory']
    # USER_ID
    user_id = session.get("user","unknown")
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.special_fac
        (element_type, element, quantity, volume, prd_date, factory,userid)
        VALUES (?, ?, ?, ?, ?, ?, ?,?)
    """, (element_type, element, qty, vol, planned_date, factory,user_id))

    conn.commit()
    conn.close()

    return render_template("form.html", user=session["user"], message="Production data submitted successfully!", active_tab="Production")


@app.route('/logistic', methods=['POST'])
def logistics():
    if "user" not in session:
        return redirect(url_for("login"))
    # Role restriction
    if session["role"] not in ['Admin', 'recieve']:
        return "Access Denied", 403

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    recieved_date = request.form['recieved_date']
    production_date = request.form['production_date']
    recieved_by = request.form['recieved_by']

    user_id = session.get("user","unknown")
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.log_recieve 
        (element_type, element, quantity, recieve_date, prd_date,userid)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (element_type, element, qty, recieved_date, production_date,user_id))

    conn.commit()
    conn.close()

    return render_template("form.html", message="Logistics data saved successfully!", active_tab="Logistics")
##########################
@app.route('/issue', methods=['POST'])
def issue():
    if "user" not in session:
        return redirect(url_for("login"))
    # Role restriction
    if session["role"] not in ['Admin', 'issue']:
        return "Access Denied", 403

    element = request.form['element']
    element_type = request.form['element_type']
    qty = request.form['qty']
    recieved_date = request.form['recieved_date']
    production_date = request.form['production_date']
    recieved_by = request.form['issued_by']
    issue_date = request.form['issue_date']

    user_id = session.get("user","unknown")
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bronze.log_issue
        (element_type, element, quantity, recieve_date, prd_date,userid,issue_date)
        VALUES (?, ?, ?, ?, ?, ?,?)
    """, (element_type, element, qty, recieved_date, production_date,user_id,issue_date))

    conn.commit()
    conn.close()

    return render_template("form.html", message="issue data saved successfully!", active_tab="issue")

if __name__ == '__main__':
    app.run(debug=True)
