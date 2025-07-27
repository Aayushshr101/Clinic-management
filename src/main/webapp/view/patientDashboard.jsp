<%@ page session="true" import="java.util.*, model.User, dao.DoctorDAO, model.Doctor" %>
<%!
    private String escapeJsString(String str) {
        if (str == null) {
            return "";
        }
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
                case '\u2028': sb.append("\\u2028"); break;
                case '\u2029': sb.append("\\u2029"); break;
                default:
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
            margin: 0;
            padding: 0;
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
            background: linear-gradient(135deg, #4a90e2 0%, #6a5acd 100%);
            min-height: 100vh;
            padding: 20px;
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* Wide Dashboard Container */
        .dashboard-container {
            max-width: 1400px; /* Increased from 600px to 1400px */
            width: 100%;
            margin: 0 auto;
        }

        /* Header Section */
        .header {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .welcome-section h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .welcome-section p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        /* Step Navigation */
        .step-navigation {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .steps {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 30px;
            position: relative;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .steps::before {
            content: "";
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: #e2e3e5;
            z-index: 1;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            background: white;
            padding: 0 20px;
            flex: 1;
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e2e3e5;
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }

        .step.active .step-number {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .step.completed .step-number {
            background: var(--secondary-color);
            color: white;
        }

        .step-label {
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-light);
            text-align: center;
        }

        .step.active .step-label {
            color: var(--primary-color);
            font-weight: 600;
        }

        /* Main Content Container */
        .main-content {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            min-height: 500px; /* Ensure adequate height */
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 15px;
            text-align: center;
        }

        .section-subtitle {
            color: var(--text-light);
            margin-bottom: 40px;
            font-size: 1.1rem;
            text-align: center;
        }

        /* Content Sections */
        .section-container {
            opacity: 0;
            max-height: 0;
            overflow: hidden;
            transition: opacity 0.5s ease-in-out, max-height 0.5s ease-in-out;
            pointer-events: none;
        }

        .section-container.show {
            opacity: 1;
            max-height: 2000px;
            overflow: visible;
            pointer-events: auto;
        }

        /* Department Grid - Wide Layout */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* For departments, use 4 columns on large screens */
        #departmentSelection .card-grid {
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        /* For doctors, use 3 columns on large screens */
        #doctorSelection .card-grid {
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .card {
            background-color: var(--card-bg);
            border: 2px solid var(--card-border);
            border-radius: 12px;
            padding: 30px 25px;
            text-align: center;
            cursor: pointer;
            box-shadow: 0 4px 15px var(--card-shadow);
            transition: all 0.3s ease-in-out;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 180px;
        }

        .card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 8px 25px rgba(74, 144, 226, 0.2);
            transform: translateY(-5px);
        }

        .card-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: block;
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            display: block;
            min-height: 1.5em;
        }

        .card-subtitle {
            font-size: 1rem;
            color: var(--text-medium);
            display: block;
        }

        .card-doctor-dept {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-top: 8px;
            display: block;
            min-height: 1em;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px 24px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            text-decoration: none;
            font-family: inherit;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(74, 144, 226, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: var(--secondary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(106, 90, 205, 0.3);
        }

        .btn-secondary:hover {
            background: var(--secondary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(106, 90, 205, 0.4);
        }

        .back-button {
            background-color: var(--text-light);
            margin-bottom: 25px;
            margin-top: 0;
        }

        .back-button:hover {
            background-color: #5a6268;
        }

        /* Form Styling */
        .booking-form {
            max-width: 800px; /* Increased from 600px */
            margin: 0 auto;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 12px;
            margin-top: 30px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-medium);
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-dark);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background-color: white;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
        }

        input[readonly][disabled] {
            background-color: var(--background-light);
            cursor: default;
            font-weight: 600;
            color: var(--primary-color);
            opacity: 1;
        }

        #selectedDepartmentDisplay[readonly][disabled] {
            font-weight: 500;
            color: var(--text-medium);
        }

        #slotContainer {
            background-color: var(--background-light);
            padding: 20px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-top: 10px;
            min-height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-light);
            font-size: 1rem;
            text-align: center;
        }

        /* Message Box */
        .message {
            background-color: var(--success-bg);
            color: var(--success-text);
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            border: 1px solid #c3e6cb;
            font-size: 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message i {
            font-size: 1.2rem;
        }

        /* Quick Actions */
        .quick-actions {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .quick-actions h3 {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .link-btn {
            background-color: var(--secondary-color);
            color: white;
            text-align: center;
            padding: 14px 24px;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 4px 12px rgba(106, 90, 205, 0.2);
            transition: all 0.3s ease;
            gap: 8px;
        }

        .link-btn:hover {
            background-color: var(--secondary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(106, 90, 205, 0.3);
        }

        .profile-link {
            display: inline-block;
            margin-top: 15px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 1rem;
            transition: color 0.2s ease;
        }

        .profile-link:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .dashboard-container {
                max-width: 100%;
                padding: 0 15px;
            }
            
            #departmentSelection .card-grid,
            #doctorSelection .card-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .header,
            .step-navigation,
            .main-content,
            .quick-actions {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                text-align: center;
            }

            .steps {
                flex-direction: column;
                gap: 20px;
            }

            .steps::before {
                display: none;
            }

            .card-grid {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .booking-form {
                padding: 20px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <!-- Header -->
    <div class="header">
        <div class="welcome-section">
            <h1>Welcome, <%= user.getName() %>!</h1>
            <p>Manage your health appointments with ease</p>
        </div>
        <div class="header-actions">
            <a href="index.jsp" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>
    </div>

    <!-- Step Navigation -->
    <div class="step-navigation">
        <div class="steps">
            <div class="step active" id="step1">
                <div class="step-number">1</div>
                <div class="step-label">Choose Department</div>
            </div>
            <div class="step" id="step2">
                <div class="step-number">2</div>
                <div class="step-label">Select Doctor</div>
            </div>
            <div class="step" id="step3">
                <div class="step-number">3</div>
                <div class="step-label">Book Appointment</div>
            </div>
        </div>
    </div>

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

    <!-- Main Content -->
    <div class="main-content">
        <div id="appointmentFlowContainer" class="section-container show">
            <h2 id="flowTitle" class="section-title">Choose a Department</h2>
            <p id="flowInstructions" class="section-subtitle">
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

            <!-- Doctor Selection Section -->
            <div id="doctorSelection" class="section-container">
                <button id="backToDepartmentsBtn" class="btn back-button">
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

            <!-- Appointment Form Section -->
            <div id="appointmentFormSection" class="section-container">
                <button id="backToDoctorsBtn" class="btn back-button">
                    <i class="fas fa-arrow-left"></i> Back to Doctors
                </button>
                
                <div class="booking-form">
                    <form action="<%= request.getContextPath() %>/bookAppointment" method="post">
                        <input type="hidden" name="doctorId" id="formDoctorId">
                        <input type="hidden" name="departmentName" id="formDepartmentName">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="selectedDoctorDisplay">You are booking with:</label>
                                <input type="text" id="selectedDoctorDisplay" readonly disabled>
                            </div>
                            <div class="form-group">
                                <label for="selectedDepartmentDisplay">In Department:</label>
                                <input type="text" id="selectedDepartmentDisplay" readonly disabled>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="slot">Select Available Time Slot</label>
                            <div id="slotContainer">
                                <p>Loading slots...</p>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullName">Your Full Name</label>
                                <input type="text" name="fullName" id="fullName" required>
                            </div>
                            <div class="form-group">
                                <label for="contact">Your Contact Number</label>
                                <input type="text" name="contact" id="contact" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="age">Your Age</label>
                                <input type="number" name="age" id="age" min="1" max="120" required>
                            </div>
                            <div class="form-group">
                                <label for="gender">Your Gender</label>
                                <select name="gender" id="gender" required>
                                    <option value="">Select gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">
                            <i class="fas fa-calendar-check"></i>
                            Confirm & Book Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h3>Quick Actions</h3>
        <div class="action-buttons">
            <a href="patientAppointments.jsp" class="link-btn">
                <i class="fas fa-history"></i>
                View My Appointments
            </a>
            <a href="<%= request.getContextPath() %>/view/profile.jsp" class="link-btn">
                <i class="fas fa-user"></i>
                My Profile
            </a>
        </div>
    </div>
</div>

<script>
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

        // Step indicators
        const step1 = document.getElementById("step1");
        const step2 = document.getElementById("step2");
        const step3 = document.getElementById("step3");

        let currentSelectedDepartment = null;
        let currentSelectedDoctor = null;

        function updateSteps(activeStep) {
            [step1, step2, step3].forEach((step, index) => {
                step.classList.remove("active", "completed");
                if (index + 1 < activeStep) {
                    step.classList.add("completed");
                } else if (index + 1 === activeStep) {
                    step.classList.add("active");
                }
            });
        }

        function showSection(sectionToShow, stepNumber) {
            const sections = [departmentSelection, doctorSelection, appointmentFormSection];
            sections.forEach(section => {
                if (section === sectionToShow) {
                    section.classList.add("show");
                } else {
                    section.classList.remove("show");
                }
            });
            updateSteps(stepNumber);
            appointmentFlowContainer.classList.add("show");
        }

        // Department card event listeners
        document.querySelectorAll('#departmentSelection .card').forEach(card => {
            card.addEventListener('click', function() {
                currentSelectedDepartment = this.dataset.department;
                flowTitle.textContent = `Select a Doctor in ${currentSelectedDepartment}`;
                flowInstructions.textContent = "Click on a doctor's card to proceed with booking an appointment with them.";

                document.querySelectorAll('#doctorSelection .card-grid').forEach(grid => {
                    grid.style.display = 'none';
                });

                let foundDoctors = false;
                document.querySelectorAll('#doctorSelection .card-grid').forEach(grid => {
                    if (grid.dataset.departmentGroup === currentSelectedDepartment) {
                        grid.style.display = 'grid';
                        foundDoctors = true;
                    }
                });

                const doctorSelectionContainer = document.querySelector('#doctorSelection');
                const existingNoDoctorsMessage = doctorSelectionContainer.querySelector('.no-doctors-message');
                if (existingNoDoctorsMessage) {
                    existingNoDoctorsMessage.remove();
                }

                if (!foundDoctors) {
                    const noDoctorsMessage = document.createElement('p');
                    noDoctorsMessage.classList.add('no-doctors-message');
                    noDoctorsMessage.style.textAlign = 'center';
                    noDoctorsMessage.style.color = 'var(--text-light)';
                    noDoctorsMessage.textContent = 'No doctors found in this department.';
                    doctorSelectionContainer.appendChild(noDoctorsMessage);
                }

                showSection(doctorSelection, 2);
            });
        });

        // Doctor card event listeners
        document.querySelectorAll('#doctorSelection .card').forEach(card => {
            card.addEventListener('click', function() {
                const doctorId = this.dataset.doctorId;
                const doctorName = this.dataset.doctorName;
                const departmentName = this.dataset.departmentName;
                currentSelectedDoctor = { id: doctorId, name: doctorName, departmentName: departmentName };
                showAppointmentForm(doctorId, doctorName, departmentName);
                showSection(appointmentFormSection, 3);
            });
        });

        // Back buttons
        backToDepartmentsBtn.addEventListener("click", function() {
            flowTitle.textContent = "Choose a Department";
            flowInstructions.textContent = "Click on a department card below to see the doctors available in that specialty.";
            const existingNoDoctorsMessage = doctorSelection.querySelector('.no-doctors-message');
            if (existingNoDoctorsMessage) {
                existingNoDoctorsMessage.remove();
            }
            showSection(departmentSelection, 1);
        });

        backToDoctorsBtn.addEventListener("click", function() {
            flowTitle.textContent = `Select a Doctor in ${currentSelectedDepartment}`;
            flowInstructions.textContent = "Click on a doctor's card to proceed with booking an appointment with them.";
            showSection(doctorSelection, 2);
        });

        function showAppointmentForm(doctorId, doctorName, departmentName) {
            flowTitle.textContent = "Book Your Appointment";
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

        // Initial state
        showSection(departmentSelection, 1);
    });
</script>
</body>
</html>