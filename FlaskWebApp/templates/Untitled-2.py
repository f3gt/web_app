<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Production & Erection Entry</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(120deg, #fdfbfb 0%, #ebedee 100%);
            margin: 0;
            padding: 20px;
        }

        header {
            background-color: #1f2937;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: 60;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .tab {
            display: flex;
            justify-content: space-around;
            background-color: #f3f4f6;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .tab button {
            flex: 1;
            background-color: #e5e7eb;
            border: none;
            padding: 14px 20px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        .tab button:hover,
        .tab button.active {
            background-color: #3b82f6;
            color: white;
        }

      .tab button {
            background-color: #f1f1f1;
            float: left;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 8px 12px;       /* Reduced padding */
            transition: 0.3s;
            font-size: 14px;         /* Slightly smaller font */
            margin-right: 4px;       /* Small gap between tabs */
            border-radius: 6px 6px 0 0;
            min-width: 100px;        /* Set a minimum width */
        }
        .container {
        max-width: 1000px;       /* Limit width of form area */
        margin: 0 auto;         /* Center the form horizontally */
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }



        form {
            display: grid;
            gap: 15px;
        }

        label {
            font-weight: 600;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            width: 100%;
            font-size: 15px;
        }

        button[type="submit"] {
            background-color: #10b981;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #059669;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #f9fafb;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <header>
        Welcome Suraksha Employee
        {% if user %}
            <div>Hello, {{ user }}! <a href="/logout" style="color: #93c5fd; text-decoration: underline;">Logout</a></div>
        {% endif %}
    </header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Dashboard</a>
    <div class="ml-auto d-flex align-items-center">
        <span class="mr-3">Welcome, {{ user }}</span>
        <a href="{{ url_for('logout') }}" class="btn btn-outline-danger btn-sm">Logout</a>
    </div>
</nav>

    {% if message %}
        <script>alert("{{ message }}");</script>
    {% endif %}

    <script>
    function openSubTab(evt, subTabName) {
        const subTabs = document.getElementsByClassName("subtab-content");
        for (let i = 0; i < subTabs.length; i++) {
            subTabs[i].style.display = "none";
        }

        const subButtons = document.getElementsByClassName("subtablinks");
        for (let i = 0; i < subButtons.length; i++) {
            subButtons[i].classList.remove("active");
        }

        document.getElementById(subTabName).style.display = "block";
        document.getElementById("subtab-" + subTabName).classList.add("active");
    }

    function setTodayDate() {
        const today = new Date().toISOString().split('T')[0];
        ['hcs', 'pod', 'special', 'carousal', 'erect'].forEach(id => {
            const el = document.getElementById('entry_date_' + id);
            if (el) el.value = today;
        });
    }

    window.onload = function () {
        const activeTab = "{{ active_tab | default('Production') }}";
        document.getElementById("tab-" + activeTab).click();
        openSubTab(event, "HCS");
        setTodayDate();
    };
</script>


    <div class="tab">
        <button class="tablinks" onclick="openTab(event, 'Production')" id="tab-Production">Production</button>
        <button class="tablinks" onclick="openTab(event, 'Erection')" id="tab-Erection">Erection</button>
        <button class="tablinks" onclick="openTab(event, 'Retrieve')" id="tab-Retrieve">Retrieve</button>
        <button class="tablinks" onclick="openTab(event, 'Logistics')" id="tab-Logistics">Logistics</button>
    </div>

    <div id="Production" class="tab-content container">

    <div class="tab">
    {% if session['role'] in ['admin', 'HCS'] %}
        <button class="subtablinks" onclick="openSubTab(event, 'HCS')" id="subtab-HCS">HCS</button>
    {% endif %}
    {% if session['role'] in ['admin', 'CAROUSAL'] %}
        <button class="subtablinks" onclick="openSubTab(event, 'CAROUSAL')" id="subtab-CAROUSAL">CAROUSAL</button>
    {% endif %}
    {% if session['role'] in ['admin', 'SPECIAL'] %}
        <button class="subtablinks" onclick="openSubTab(event, 'SPECIAL')" id="subtab-SPECIAL">SPECIAL_MOULD</button>
    {% endif %}
    {% if session['role'] in ['admin', 'POD'] %}
        <button class="subtablinks" onclick="openSubTab(event, 'POD')" id="subtab-POD">POD</button>
    {% endif %}
    </div>

    <!-- Factory Sub Tabs -->
    <div class="tab">
        <button class="subtablinks" onclick="openSubTab(event, 'HCS')" id="subtab-HCS">HCS</button>
        <button class="subtablinks" onclick="openSubTab(event, 'CAROUSAL')" id="subtab-CAROUSAL">CAROUSAL</button>
        <button class="subtablinks" onclick="openSubTab(event, 'SPECIAL')" id="subtab-SPECIAL">SPECIAL_MOULD</button>
        <button class="subtablinks" onclick="openSubTab(event, 'POD')" id="subtab-POD">POD</button>
    </div>

    <!-- HCS Tab Form -->
    <div id="HCS" class="subtab-content" style="display: none;">
        <form action="/submit_production/hcs" method="post">
            <input type="hidden" name="factory" value="HCS">

           <input type="text" name="factory" value="HCS" readonly>


            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Quantity:</label>
            <input type="number" name="qty" required>

            <label>Volume:</label>
            <input type="number" name="volume" step="0.01" required>

            <label>Entry Date:</label>
            <input type="text" name="entry_date" id="entry_date_hcs" readonly>

            <label>Planned Date:</label>
            <input type="date" name="planned_date" required>

            <button type="submit">Submit HCS Production</button>
        </form>
    </div>

    <!-- Repeat this block for POD, SPECIAL, CAROUSAL -->

    <!-- POD Tab Form -->
    <div id="POD" class="subtab-content" style="display: none;">
            <form action="/submit_production/pod" method="post">
            <input type="hidden" name="factory" value="POD">

           <input type="text" name="factory" value="POD" readonly>


            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Quantity:</label>
            <input type="number" name="qty" required>

            <label>Volume:</label>
            <input type="number" name="volume" step="0.01" required>

            <label>Entry Date:</label>
            <input type="text" name="entry_date" id="entry_date_hcs" readonly>

            <label>Planned Date:</label>
            <input type="date" name="planned_date" required>

            <button type="submit">Submit POD Production</button>
        </form>
    </div>

    <!-- SPECIAL -->
    <div id="SPECIAL" class="subtab-content" style="display: none;">
        <form action="/submit_production/special" method="post">
            <input type="hidden" name="factory" value="SPECIAL">

           <input type="text" name="factory" value="SPECIAL" readonly>


            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Quantity:</label>
            <input type="number" name="qty" required>

            <label>Volume:</label>
            <input type="number" name="volume" step="0.01" required>

            <label>Entry Date:</label>
            <input type="text" name="entry_date" id="entry_date_hcs" readonly>

            <label>Planned Date:</label>
            <input type="date" name="planned_date" required>

            <button type="submit">Submit SPECIAL Production</button>
        </form>
    </div>

    <!-- CAROUSAL -->
    <div id="CAROUSAL" class="subtab-content" style="display: none;">
        <form action="/submit_production/carousal" method="post">
            <input type="hidden" name="factory" value="CAROUSAL">

           <input type="text" name="factory" value="CAROUSAL" readonly>


            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Quantity:</label>
            <input type="number" name="qty" required>

            <label>Volume:</label>
            <input type="number" name="volume" step="0.01" required>

            <label>Entry Date:</label>
            <input type="text" name="entry_date" id="entry_date_hcs" readonly>

            <label>Planned Date:</label>
            <input type="date" name="planned_date" required>

            <button type="submit">Submit CAROUSAL Production</button>
        </form>
    </div>
</div>

    <div id="Erection" class="tab-content container" style="display: none;">
        <form action="/submit_erection" method="post">
            <input type="hidden" name="active_tab" value="Erection">

            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Quantity:</label>
            <input type="number" name="qty" required>

            <label>Volume:</label>
            <input type="number" name="volume" step="0.01" required>

            <label>Entry Date:</label>
            <input type="text" name="entry_date" id="entry_date_erect" readonly>

            <label>Planned Date:</label>
            <input type="date" name="planned_date" required>

            <button type="submit">Submit Erection</button>
        </form>
    </div>

    <div id="Logistics" class="tab-content container" style="display: none;">
        <form action="/logistic" method="post">
            <input type="hidden" name="active_tab" value="Logistics">

            <label>Element:</label>
            <input type="text" name="element" required>

            <label>Element Type:</label>
            <input type="text" name="element_type" required>

            <label>Received Quantity:</label>
            <input type="number" name="qty" required>

            <label>Received Date:</label>
            <input type="date" name="recieved_date" required>

            <label>Production Date:</label>
            <input type="date" name="production_date" required>

            <label>Received By:</label>
            <input type="text" name="recieved_by" required>

            <button type="submit">Submit Logistics</button>
        </form>
    </div>

    <div id="Retrieve" class="tab-content container" style="display: none;">
        <form action="/retrieve" method="post">
            <input type="hidden" name="active_tab" value="Retrieve">

            <label>Start Date:</label>
            <input type="date" name="start_date" required>

            <label>End Date:</label>
            <input type="date" name="end_date" required>

            <button type="submit">Get Production Data</button>
        </form>

        {% if records %}
            <h3>Results:</h3>
            <table>
                <tr>
                    <th>Element</th>
                    <th>Element Type</th>
                    <th>Quantity</th>
                    <th>Volume</th>
                    <th>Planned Date</th>
                </tr>
                {% for row in records %}
                <tr>
                    <td>{{ row.Element }}</td>
                    <td>{{ row.ElementType }}</td>
                    <td>{{ row.Quantity }}</td>
                    <td>{{ row.Volume }}</td>
                    <td>{{ row.PlannedDate }}</td>
                </tr>
                {% endfor %}
            </table>

            <h3>Production Quantity Chart</h3>
            <canvas id="quantityChart" width="150" height="100"></canvas>
        {% endif %}
    </div>

    <script>
        function openTab(evt, tabName) {
            const tabs = document.getElementsByClassName("tab-content");
            for (let tab of tabs) tab.style.display = "none";

            const buttons = document.getElementsByClassName("tablinks");
            for (let btn of buttons) btn.classList.remove("active");

            document.getElementById(tabName).style.display = "block";
            document.getElementById("tab-" + tabName).classList.add("active");
        }

        function setTodayDate() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('entry_date_prod').value = today;
            document.getElementById('entry_date_erect').value = today;
        }

        window.onload = function () {
            const activeTab = "{{ active_tab | default('Production') }}";
            document.getElementById("tab-" + activeTab).click();
            setTodayDate();
        };
    </script>

    {% if records %}
    <script>
        const elements = {{ records | map(attribute='PlannedDate') | list | tojson }};
        const quantities = {{ records | map(attribute='Quantity') | list | tojson }};
        const ctx = document.getElementById('quantityChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: elements,
                datasets: [{
                    label: 'Quantity',
                    data: quantities,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: true } },
                scales: { y: { beginAtZero: true } }
            }
        });
    </script>
    {% endif %}
</body>
</html>
