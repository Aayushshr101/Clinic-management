<%@ page session="true" import="java.util.*, model.User, dao.DoctorDAO, model.Doctor" %>
<%!
    // Java helper method for robust JavaScript string escaping
    // This method is defined once and can be called from scriptlets.
    private String escapeJsString(String str) {
        if (str == null) {
            return ""; // Return empty string for null
        }
        // Use a StringBuilder for efficient string manipulation
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            switch (c) {
                case '\\': sb.append("\\\\"); break;
                case '\'': sb.append("\\'");  break;
                case '"':  sb.append("\\\""); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                // Handle Unicode line/paragraph separators if necessary, though less common
                case '\u2028': sb.append("\\u2028"); break;
                case '\u2029': sb.append("\\u2029"); break;
                default:
                    // For other special characters, you might need more specific handling
                    // For basic names, this should be sufficient.
                    sb.append(c);
            }
        }
        return sb.toString();
    }
%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    DoctorDAO doctorDAO = new DoctorDAO();
    List<Doctor> doctors = doctorDAO.getAllDoctors();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - MediTrackPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Global box-sizing reset */
        * {
            box-sizing: border-box;
        }

        :root {
            --primary-color: #4a90e2;
            --primary-hover: #3a7bd5;
            --secondary-color: #6a5acd;
            --secondary-hover: #5a4fcf;
            --background-light: #f8f9fa;
            --text-dark: #212529;
            --text-medium: #495057;
            --text-light: #6c757d;
            --border-color: #ced4da;
            --success-bg: #d4edda;
            --success-text: #155724;
            --error-text: #dc3545;
            --card-bg: #ffffff;
            --card-border: #e0e0e0;
            --card-shadow: rgba(0, 0, 0, 0.05);
            --container-shadow: rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background-light);
            padding: 20px;
            color: var(--text-dark);
            line-height: 1.6;
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Align to top */
            min-height: 100vh;
        }

        .container {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 12px;
            max-width: 600px; /* Adjusted max-width for the form */
            width: 100%;
            box-shadow: 0 8px 20px var(--container-shadow);
            margin-top: 40px;
        }

        h2 {
            color: var(--primary-color);
            margin-bottom: 25px;
            font-size: 1.8rem;
            font-weight: 700;
            text-align: center;
        }

        h3 {
            color: var(--text-dark);
            margin-top: 30px;
            margin-bottom: 20px;
            font-size: 1.4rem;
            font-weight: 600;
            text-align: center;
        }

        .welcome-text {
            color: var(--text-medium);
            font-size: 1rem;
            text-align: center;
            margin-bottom: 30px;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--text-medium);
            margin-bottom: 8px;
            margin-top: 20px;
            font-size: 0.95rem;
        }

        select,
        input[type="text"],
        input[type="number"],
        input[type="email"],
        input[type="password"] {
            padding: 12px 15px;
            width: 100%;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-dark);
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-color: #fff;
        }

        select {
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23495057%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13.2-6.4H18.2c-5%200-9.3%201.8-13.2%206.4-3.9%204.6-5.9%2010.1-5.9%2016.1s2%2011.5%205.9%2016.1l128%20128c3.9%203.9%208.4%205.9%2013.2%205.9s9.3-2%2013.2-5.9l128-128c3.9-4.6%205.9-10.1%205.9-16.1s-2-11.5-5.9-16.1z%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 12px;
        }

        select:focus,
        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
        }

        .button {
            background-color: var(--primary-color);
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: 25px;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
            width: 100%;
            display: flex; /* Use flex for icon alignment */
            justify-content: center;
            align-items: center;
            text-align: center;
            text-decoration: none;
            gap: 8px; /* Space between icon and text */
        }

        .button:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(74, 144, 226, 0.3);
        }

        .button:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.2);
        }

        .back-button {
            background-color: var(--text-light);
            margin-bottom: 20px;
            margin-top: 0;
        }

        .back-button:hover {
            background-color: #5a6268;
        }

        .message {
            background-color: var(--success-bg);
            color: var(--success-text);
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 8px;
            border: 1px solid #c3e6cb;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message i {
            font-size: 1.2rem;
        }

        .link-btn {
            background-color: var(--secondary-color);
            color: white;
            text-align: center;
            padding: 12px;
            display: flex; /* Use flex for icon alignment */
            justify-content: center;
            align-items: center;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(106, 90, 205, 0.2);
            transition: background-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
            gap: 8px; /* Space between icon and text */
        }

        .link-btn:hover {
            background-color: var(--secondary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(106, 90, 205, 0.3);
        }

        .link-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(106, 90, 205, 0.2);
        }

        .profile-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .profile-link:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }

        #slotContainer {
            background-color: var(--background-light);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-top: 10px;
            min-height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-light);
            font-size: 0.9rem;
            text-align: center;
        }

        /* Section visibility styles with transition */
        .section-container {
            opacity: 0;
            max-height: 0;
            overflow: hidden;
            transition: opacity 0.5s ease-in-out, max-height 0.5s ease-in-out;
            pointer-events: none; /* Disable interaction when hidden */
        }

        .section-container.show {
            opacity: 1;
            max-height: 1000px; /* Sufficiently large value to show content */
            overflow: visible;
            pointer-events: auto; /* Enable interaction when shown */
        }

        /* Card styles for Department and Doctor selection */
        .card-grid {
            display: grid; /* Default display for card grids */
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); /* Responsive grid */
            gap: 20px; /* Space between cards */
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            box-shadow: 0 4px 15px var(--card-shadow);
            transition: all 0.2s ease-in-out;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 150px; /* Ensure consistent card height */
        }

        .card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.15);
            transform: translateY(-3px);
        }

        .card-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: block; /* Ensure icon is displayed */
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 5px;
            display: block; /* Ensure title is displayed */
            min-height: 1.5em; /* Ensure it takes space even if content is empty */
        }

        .card-subtitle {
            font-size: 0.9rem;
            color: var(--text-medium);
            display: block; /* Ensure subtitle is displayed */
        }

        .card-doctor-dept {
            font-size: 0.85rem;
            color: var(--text-light);
            margin-top: 5px;
            display: block; /* Ensure doctor department is displayed */
            min-height: 1em; /* Ensure it takes space even if content is empty */
        }

        /* Specific styling for disabled inputs in form */
        input[readonly][disabled] {
            background-color: var(--background-light);
            cursor: default;
            font-weight: 600;
            color: var(--primary-color);
            opacity: 1; /* Ensure it's not faded */
        }
        #selectedDepartmentDisplay[readonly][disabled] {
            font-weight: 500;
            color: var(--text-medium);
        }

        /* Form specific spacing */
        form > label:first-of-type {
            margin-top: 0; /* Remove extra top margin for first label in form */
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            .container {
                margin-top: 20px;
                padding: 20px;
            }
            .button, .link-btn {
                font-size: 1rem;
                padding: 12px 15px;
            }
            .card-grid {
                grid-template-columns: 1fr; /* Stack cards on small screens */
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="index.jsp" class="button back-button">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>

    <h2>MediTrackPro Dashboard</h2>
    <p class="welcome-text">Welcome, <%= user.getName() %>! Manage your health appointments with ease.</p>

    <%-- Message display --%>
    <%
        String msg = (String) session.getAttribute("msg");
        if (msg != null) {
    %>
        <div class="message">
            <i class="fas fa-check-circle"></i>
            <%= msg %>
        </div>
    <%
            session.removeAttribute("msg");
        }
    %>

    <!-- Main Appointment Flow Container -->
    <div id="appointmentFlowContainer" class="section-container show">
        <h3 id="flowTitle">Step 1: Choose a Department</h3>
        <p id="flowInstructions" class="welcome-text" style="margin-bottom: 30px;">
            Click on a department card below to see the doctors available in that specialty.
        </p>

        <!-- Department Selection Section -->
        <div id="departmentSelection" class="section-container show">
            <div class="card-grid">
                <%
                    Set<String> departments = new TreeSet<>();
                    for (Doctor d : doctors) {
                        if (d.getDepartmentName() != null) {
                            departments.add(d.getDepartmentName());
                        }
                    }
                    for (String dept : departments) {
                %>
                    <div class="card" data-department="<%= escapeJsString(dept) %>">
                        <i class="fas fa-hospital card-icon"></i>
                        <div class="card-title"><%= dept %></div>
                        <div class="card-subtitle">Click to view doctors</div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Doctor Selection Section (initially hidden) -->
        <div id="doctorSelection" class="section-container">
            <button id="backToDepartmentsBtn" class="button back-button">
                <i class="fas fa-arrow-left"></i> Back to Departments
            </button>
            <%
                Map<String, List<Doctor>> doctorsByDepartment = new HashMap<>();
                for (Doctor d : doctors) {
                    doctorsByDepartment.computeIfAbsent(d.getDepartmentName(), k -> new ArrayList<>()).add(d);
                }
                for (Map.Entry<String, List<Doctor>> entry : doctorsByDepartment.entrySet()) {
                    String deptName = entry.getKey();
                    List<Doctor> doctorsInDept = entry.getValue();
                    // The ID here is still cleaned, but JS will now use data-department-group for matching
                    String departmentGridId = "doctor-grid-" + escapeJsString(deptName).replaceAll("[^a-zA-Z0-9]", "");
            %>
                    <div id="<%= departmentGridId %>" class="card-grid" style="display: none;" data-department-group="<%= escapeJsString(deptName) %>">
                        <%
                            for (Doctor d : doctorsInDept) {
                        %>
                                <div class="card" data-doctor-id="<%= d.getId() %>" data-doctor-name="<%= escapeJsString(d.getName()) %>" data-department-name="<%= escapeJsString(d.getDepartmentName()) %>">
                                    <i class="fas fa-user-md card-icon"></i>
                                    <div class="card-title">
                                        <%= d.getName() %>
                                    </div>
                                    <div class="card-doctor-dept">
                                        <%= d.getDepartmentName() %>
                                    </div>
                                    <div class="card-subtitle">Click to book</div>
                                </div>
                        <%
                            }
                        %>
                    </div>
            <%
                }
            %>
        </div>

        <!-- Appointment Form Section (initially hidden) -->
        <div id="appointmentFormSection" class="section-container">
            <button id="backToDoctorsBtn" class="button back-button">
                <i class="fas fa-arrow-left"></i> Back to Doctors
            </button>
            <form action="<%= request.getContextPath() %>/bookAppointment" method="post" class="space-y-4">
                <input type="hidden" name="doctorId" id="formDoctorId">
                <input type="hidden" name="departmentName" id="formDepartmentName">

                <div>
                    <label for="selectedDoctorDisplay">You are booking with:</label>
                    <input type="text" id="selectedDoctorDisplay" readonly disabled>
                </div>

                <div>
                    <label for="selectedDepartmentDisplay">In Department:</label>
                    <input type="text" id="selectedDepartmentDisplay" readonly disabled>
                </div>

                <div>
                    <label for="slot">Select Available Time Slot</label>
                    <div id="slotContainer">
                        <p>Loading slots...</p>
                    </div>
                </div>

                <div>
                    <label for="fullName">Your Full Name</label>
                    <input type="text" name="fullName" id="fullName" required>
                </div>
                <div>
                    <label for="contact">Your Contact Number</label>
                    <input type="text" name="contact" id="contact" required>
                </div>
                <div>
                    <label for="age">Your Age</label>
                    <input type="number" name="age" id="age" min="1" max="120" required>
                </div>
                <div>
                    <label for="gender">Your Gender</label>
                    <select name="gender" id="gender" required>
                        <option value="">Select gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <button type="submit" class="button">
                    <i class="fas fa-calendar-check"></i>
                    Confirm & Book Appointment
                </button>
            </form>
        </div>
    </div>

    <a href="patientAppointments.jsp" class="link-btn">
        <i class="fas fa-history"></i>
        View My Appointments
    </a>
    <p><a href="<%= request.getContextPath() %>/view/profile.jsp" class="profile-link">My Profile</a></p>
</div>

<script>
    // allDoctorsData is still needed for the form pre-fill and potentially other JS logic
    const allDoctorsData = [
    <%
        boolean firstDoctor = true;
        for (Doctor d : doctors) {
            if (!firstDoctor) {
                out.print(",");
            }
            String doctorId = String.valueOf(d.getId());
            String doctorName = (d.getName() != null) ? d.getName() : "";
            String departmentName = (d.getDepartmentName() != null) ? d.getDepartmentName() : "";
            out.print("{ id: '" + escapeJsString(doctorId) + "', name: '" + escapeJsString(doctorName) + "', departmentName: '" + escapeJsString(departmentName) + "' }");
            firstDoctor = false;
        }
    %>
    ];
    console.log("allDoctorsData (from JSP):", allDoctorsData);

    document.addEventListener("DOMContentLoaded", function() {
        const appointmentFlowContainer = document.getElementById("appointmentFlowContainer");
        const flowTitle = document.getElementById("flowTitle");
        const flowInstructions = document.getElementById("flowInstructions");
        const departmentSelection = document.getElementById("departmentSelection");
        const doctorSelection = document.getElementById("doctorSelection");
        const backToDepartmentsBtn = document.getElementById("backToDepartmentsBtn");
        const appointmentFormSection = document.getElementById("appointmentFormSection");
        const backToDoctorsBtn = document.getElementById("backToDoctorsBtn");
        const formDoctorId = document.getElementById("formDoctorId");
        const formDepartmentName = document.getElementById("formDepartmentName");
        const selectedDoctorDisplay = document.getElementById("selectedDoctorDisplay");
        const selectedDepartmentDisplay = document.getElementById("selectedDepartmentDisplay");
        const slotContainer = document.getElementById("slotContainer");

        let currentSelectedDepartment = null;
        let currentSelectedDoctor = null;

        function showSection(sectionToShow) {
            const sections = [departmentSelection, doctorSelection, appointmentFormSection];
            sections.forEach(section => {
                if (section === sectionToShow) {
                    section.classList.add("show");
                } else {
                    section.classList.remove("show");
                }
            });
            // Ensure the main flow container is always shown when in any step
            appointmentFlowContainer.classList.add("show");
        }

        // Attach event listeners to statically rendered department cards
        document.querySelectorAll('#departmentSelection .card').forEach(card => {
            card.addEventListener('click', function() {
                currentSelectedDepartment = this.dataset.department;
                flowTitle.textContent = `Step 2: Select a Doctor in ${currentSelectedDepartment}`;
                flowInstructions.textContent = "Click on a doctor's card to proceed with booking an appointment with them.";

                // Hide all doctor card grids first
                document.querySelectorAll('#doctorSelection .card-grid').forEach(grid => {
                    grid.style.display = 'none';
                });

                // Find and show the relevant doctor card grid using data-attribute
                let foundDoctors = false;
                document.querySelectorAll('#doctorSelection .card-grid').forEach(grid => {
                    if (grid.dataset.departmentGroup === currentSelectedDepartment) {
                        grid.style.display = 'grid';
                        foundDoctors = true;
                    }
                });

                // If no doctors found for department, display a message
                const doctorSelectionContainer = document.querySelector('#doctorSelection');
                const existingNoDoctorsMessage = doctorSelectionContainer.querySelector('.no-doctors-message');
                if (existingNoDoctorsMessage) {
                    existingNoDoctorsMessage.remove(); // Remove any previous message
                }
                if (!foundDoctors) {
                    const noDoctorsMessage = document.createElement('p');
                    noDoctorsMessage.classList.add('no-doctors-message'); // Add a class to identify it
                    noDoctorsMessage.style.textAlign = 'center';
                    noDoctorsMessage.style.color = 'var(--text-light)';
                    noDoctorsMessage.textContent = 'No doctors found in this department.';
                    doctorSelectionContainer.appendChild(noDoctorsMessage);
                }

                showSection(doctorSelection);
            });
        });

        // Attach event listeners to statically rendered doctor cards
        document.querySelectorAll('#doctorSelection .card').forEach(card => {
            card.addEventListener('click', function() {
                const doctorId = this.dataset.doctorId;
                const doctorName = this.dataset.doctorName;
                const departmentName = this.dataset.departmentName;

                currentSelectedDoctor = { id: doctorId, name: doctorName, departmentName: departmentName };
                showAppointmentForm(doctorId, doctorName, departmentName);
                showSection(appointmentFormSection);
            });
        });

        // Back buttons
        backToDepartmentsBtn.addEventListener("click", function() {
            flowTitle.textContent = "Step 1: Choose a Department";
            flowInstructions.textContent = "Click on a department card below to see the doctors available in that specialty.";
            // Remove any "No doctors found" message when going back
            const existingNoDoctorsMessage = doctorSelection.querySelector('.no-doctors-message');
            if (existingNoDoctorsMessage) {
                existingNoDoctorsMessage.remove();
            }
            showSection(departmentSelection);
        });

        backToDoctorsBtn.addEventListener("click", function() {
            flowTitle.textContent = `Step 2: Select a Doctor in ${currentSelectedDepartment}`;
            flowInstructions.textContent = "Click on a doctor's card to proceed with booking an appointment with them.";
            showSection(doctorSelection);
        });

        function showAppointmentForm(doctorId, doctorName, departmentName) {
            flowTitle.textContent = "Step 3: Book Your Appointment";
            flowInstructions.textContent = `Please fill in your details to finalize the booking for ${doctorName} in ${departmentName}.`;
            formDoctorId.value = doctorId;
            formDepartmentName.value = departmentName;
            selectedDoctorDisplay.value = doctorName;
            selectedDepartmentDisplay.value = departmentName;

            slotContainer.innerHTML = "<p>Loading available time slots...</p>";
            fetch("<%=request.getContextPath()%>/getAvailableTimes?doctorId=" + doctorId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok ' + response.statusText);
                    }
                    return response.text();
                })
                .then(html => {
                    slotContainer.innerHTML = html;
                    if (slotContainer.innerHTML.trim() === "" || slotContainer.innerHTML.trim() === "<p>No available slots for this doctor.</p>") {
                        slotContainer.innerHTML = "<p style='color: var(--text-light);'>No available slots for this doctor.</p>";
                    }
                })
                .catch(error => {
                    console.error("Error loading slots:", error);
                    slotContainer.innerHTML = "<p style='color: var(--error-text);'>Failed to load slots. Please try again.</p>";
                });
        }

        // Initial state: show department selection
        showSection(departmentSelection);
    });
</script>
</body>
</html>
