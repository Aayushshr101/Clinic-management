<%@ page import="java.util.*, model.Appointment, dao.AppointmentDAO, dao.DoctorDAO" %>
<%@ page session="true" %>
<%
    model.User user = (model.User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"doctor".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    AppointmentDAO dao = new AppointmentDAO();
    DoctorDAO docDao = new DoctorDAO();
    List<Appointment> appointments = dao.getAllAppointments();
    int doctorId = -1;
    if ("doctor".equalsIgnoreCase(user.getRole())) {
        doctorId = docDao.getDoctorIdByUserId(user.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - MediTrackPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Global box-sizing reset for this page */
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
            --border-color: #e0e0e0; /* Lighter border */
            --card-bg: #ffffff;
            --card-shadow: rgba(0, 0, 0, 0.03); /* Softer shadow */
            --container-shadow: rgba(0, 0, 0, 0.05); /* Softer container shadow */
        }

        body {
            font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            color: var(--text-dark);
            background-color: var(--background-light);
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Admin Header */
        .admin-header {
            background-color: var(--card-bg);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            border-bottom: 1px solid #e9ecef; /* Subtle bottom border */
        }

        .admin-header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
        }

        .admin-header .logout-link {
            font-size: 0.95rem;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
            padding: 0.5rem 1rem; /* Add padding for better click area */
            border-radius: 6px;
        }

        .admin-header .logout-link:hover {
            color: var(--primary-hover);
            text-decoration: underline;
            background-color: #e9f0f8; /* Light hover background */
        }

        /* Main Container */
        .container {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 12px;
            max-width: 1200px;
            margin: 30px auto;
            box-shadow: 0 6px 20px var(--container-shadow);
            border: 1px solid #e9ecef; /* Subtle border for the main container */
            flex-grow: 1; /* Allow container to grow and push footer down */
        }

        h1, h2 {
            color: var(--text-dark);
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        h2 {
            font-size: 1.8rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 0.8rem;
            margin-top: 2.5rem;
            color: #343a40; /* Slightly darker for section headings */
        }

        /* Section Styling */
        .section {
            margin-bottom: 30px;
            padding: 25px; /* Increased padding */
            background-color: #fdfdfd;
            border-radius: 8px;
            border: 1px solid #e9ecef; /* Consistent border */
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
        }

        /* Form Group Styling */
        .form-group {
            margin-bottom: 18px; /* Slightly increased margin */
            text-align: left;
        }

        .form-group label {
            display: block;
            font-size: 0.9rem; /* Slightly smaller label font */
            font-weight: 500;
            color: var(--text-medium);
            margin-bottom: 8px;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group input[type="time"],
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-medium);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background-color: var(--card-bg); /* Ensure white background for inputs */
        }

        /* Specific styling for time inputs */
        .form-group input[type="time"] {
            height: 44px; /* Standard height for form inputs */
            /* Native clock icon is usually handled by the browser */
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.25);
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.8rem 1.6rem; /* Slightly larger padding */
            font-size: 0.95rem; /* Slightly larger font */
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            text-decoration: none; /* Ensure no underline for anchor buttons */
            gap: 8px; /* Space for icons */
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color)); /* Blue to Purple */
            color: white;
            box-shadow: 0 3px 10px rgba(74, 144, 226, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
        }

        .btn-danger:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .btn-secondary {
            background-color: var(--text-light);
            color: white;
            box-shadow: 0 3px 10px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }

        /* Small button size for actions within tables */
        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.8rem;
            border-radius: 6px;
        }

        /* Add spacing and centering for buttons that might appear directly after a form group */
        .form-group + .btn,
        .form-group + button {
            margin-top: 15px;
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: fit-content;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            background-color: var(--card-bg);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px var(--card-shadow);
            border: 1px solid var(--border-color); /* Consistent border */
        }

        th, td {
            padding: 14px 15px; /* Slightly more padding */
            text-align: left;
            border-bottom: 1px solid #f1f1f1; /* Lighter border */
        }

        th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr:hover {
            background-color: var(--background-light); /* Lighter hover effect */
        }

        /* Specific table input/select styling */
        table .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.9rem;
            background-color: #ffffff;
            -webkit-appearance: none; /* Remove default select arrow */
            -moz-appearance: none;
            appearance: none;
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23495057%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13.2-6.4H18.2c-5%200-9.3%201.8-13.2%206.4-3.9%204.6-5.9%2010.1-5.9%2016.1s2%2011.5%205.9%2016.1l128%20128c3.9%203.9%208.4%205.9%2013.2%205.9s9.3-2%2013.2-5.9l128-128c3.9-4.6%205.9-10.1%205.9-16.1s-2-11.5-5.9-16.1z%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 8px center;
            background-size: 10px;
        }
        /* Fix for select dropdown arrow overlap */
        table select.form-control {
            padding-right: 28px; /* Increased right padding to make space for the arrow */
        }

        table button {
            padding: 8px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
            margin-right: 5px;
        }

        table a.btn-danger {
            /* Apply button styles to anchor tags used as buttons */
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        table a.btn-danger:hover {
            background-color: #c82333;
            transform: translateY(-1px); /* Subtle hover effect */
        }

        /* Action buttons side-by-side */
        .action-buttons-group {
            display: flex; /* Use flexbox for side-by-side */
            gap: 8px; /* Space between buttons */
            flex-wrap: wrap; /* Allow wrapping on smaller screens */
            justify-content: flex-start; /* Align to start */
            align-items: center;
        }

        .inline-form {
            display: flex; /* Make form a flex container too, for select/button alignment */
            align-items: center;
            margin: 0; /* Remove default form margin */
        }

        /* Clinic Overview List */
        .clinic-overview ul {
            list-style: none;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); /* Adjusted minmax */
            gap: 20px; /* Increased gap */
        }

        .clinic-overview li {
            background-color: #e9f0f8;
            padding: 20px; /* Increased padding */
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 500;
            color: #2d3748;
            display: flex;
            flex-direction: column; /* Stack content vertically */
            align-items: flex-start; /* Align text to start */
            gap: 5px; /* Smaller gap for stacked content */
            border: 1px solid #d0e0f0; /* Lighter border */
        }

        .clinic-overview li strong {
            font-size: 1.8rem; /* Larger number */
            color: var(--primary-color);
            font-weight: 700;
        }

        /* Doctor Availability Section (for Add Doctor form) */
        #availability-section {
            margin-top: 20px; /* Increased margin */
            border: 1px dashed #d0d0d0; /* Slightly darker dashed border */
            padding: 20px; /* Increased padding */
            border-radius: 8px;
            background-color: #fcfcfc;
        }

        .availability-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* Adjusted minmax */
            gap: 15px;
            margin-bottom: 15px;
            align-items: end;
            padding-bottom: 15px; /* Add padding to bottom of group */
            border-bottom: 1px dashed #eee; /* Separator for groups */
        }

        .availability-group:last-child {
            border-bottom: none; /* No border for the last group */
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .availability-group .form-group {
            margin-bottom: 0;
        }

        /* Message Box Styles */
        .message-box {
            padding: 15px 20px; /* Increased padding */
            border-radius: 8px;
            margin-bottom: 25px; /* Increased margin */
            font-size: 0.95rem;
            font-weight: 500;
            text-align: left;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05); /* Subtle shadow */
        }

        .message-box.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-box.info {
            background-color: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
        }

        .message-box.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                text-align: center;
                padding: 1rem;
            }
            .admin-header h1 {
                margin-bottom: 0.5rem;
                font-size: 1.5rem;
            }
            .container {
                margin: 20px auto;
                padding: 20px;
            }
            h2 {
                font-size: 1.5rem;
                margin-top: 2rem;
            }
            .clinic-overview ul {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .availability-group {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            table {
                display: block;
                width: 100%;
            }
            th, td {
                display: block;
                width: 100%;
            }
            th {
                text-align: center;
                padding: 10px;
            }
            td {
                text-align: center;
                padding: 8px;
                border-bottom: none; /* Remove individual cell borders on mobile */
            }
            thead {
                display: none;
            }
            tr {
                margin-bottom: 15px; /* More space between stacked rows */
                border: 1px solid #ddd;
                display: block;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
            }
            td:before {
                content: attr(data-label);
                font-weight: bold;
                text-transform: uppercase;
                display: block;
                margin-bottom: 5px;
                color: var(--primary-color);
                font-size: 0.8rem; /* Smaller label font */
            }
            /* Specific adjustments for nested tables (availability) */
            table .nested-table-cell {
                padding: 10px; /* Adjust padding for nested cell */
            }
            table .nested-table {
                box-shadow: none;
                border: none;
                margin-top: 10px;
                background-color: #fcfcfc; /* Lighter background for nested table */
            }
            table .nested-table th,
            table .nested-table td {
                padding: 8px 10px;
                font-size: 0.9rem;
            }
            table .nested-table tr {
                margin-bottom: 8px;
                border: 1px solid #eee;
            }
            table .nested-table td:before {
                font-size: 0.75rem;
            }
            /* Adjust action buttons for mobile stacked view */
            .action-buttons-group {
                justify-content: center; /* Center buttons when stacked */
                flex-direction: column; /* Stack buttons vertically */
                gap: 10px; /* More space when stacked */
            }
            .inline-form {
                width: 100%; /* Take full width when stacked */
                justify-content: center; /* Center content within form */
            }
            table .form-control {
                width: auto; /* Allow select to shrink */
                min-width: 120px; /* Ensure minimum width */
            }
        }
    </style>
</head>
<body>
    <header class="admin-header">
        <h1>Appointments</h1>
        <a href="<%= request.getContextPath() %>/logout" class="logout-link">Logout <i class="fas fa-sign-out-alt"></i></a>
    </header>
    <div class="container">
        <%
            String msg = (String) session.getAttribute("msg");
            if (msg != null) {
                boolean isSuccess = msg.toLowerCase().contains("success");
        %>
            <div class="message-box <%= isSuccess ? "success" : "error" %>">
                <%= msg %>
            </div>
        <%
                session.removeAttribute("msg");
            }
        %>
        <div style="margin-bottom: 20px;">
            <a href="<%= "admin".equalsIgnoreCase(user.getRole()) ? request.getContextPath() + "/view/adminDashboard.jsp" : request.getContextPath() + "/view/doctorDashboard.jsp" %>" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Go Back to Dashboard
            </a>
        </div>
        <h2>All Appointments</h2>
        <% boolean hasAppointments = false; %>
        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Department</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <% if ("admin".equalsIgnoreCase(user.getRole()) || "doctor".equalsIgnoreCase(user.getRole())) { %>
                        <th>Actions</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
                <%
                    java.text.SimpleDateFormat dateFormatter = new java.text.SimpleDateFormat("EEEE, MMM dd yyyy");
                    java.text.SimpleDateFormat timeFormatter = new java.text.SimpleDateFormat("hh:mm a");
                    for (Appointment app : appointments) {
                        // Doctor should only see their own confirmed appointments
                        if ("doctor".equalsIgnoreCase(user.getRole())) {
                            if (app.getDoctorId() != doctorId || !"Confirmed".equalsIgnoreCase(app.getStatus())) {
                                continue;
                            }
                        }
                        hasAppointments = true;
                %>
                <tr>
                    <td data-label="Patient"><%= app.getPatientName() %></td>
                    <td data-label="Doctor"><%= app.getDoctorName() %></td>
                    <td data-label="Department"><%= app.getDepartment() %></td>
                    <td data-label="Date"><%= dateFormatter.format(app.getAppointmentDate()) %></td>
                    <td data-label="Time">  <%= timeFormatter.format(app.getAppointmentTime()) %>  -  <%= app.getEndTime() != null ? timeFormatter.format(app.getEndTime()) : "N/A" %></td>
                    <td data-label="Status"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></td>
                    <td data-label="Actions">
                        <div class="action-buttons-group">
                            <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
                               <form action="<%= request.getContextPath() %>/updateAppointmentStatus" method="post" class="inline-form">
                                    <input type="hidden" name="appointmentId" value="<%= app.getId() %>">
                                    <select name="status" onchange="this.form.submit()" class="form-control">
                                        <option disabled selected>Change</option>
                                        <option value="Pending" <%= "Pending".equalsIgnoreCase(app.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="Confirmed" <%= "Confirmed".equalsIgnoreCase(app.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                        <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(app.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                        <option value="Completed" <%= "Completed".equalsIgnoreCase(app.getStatus()) ? "selected" : "" %>>Completed</option>
                                        <option value="No-show" <%= "No-show".equalsIgnoreCase(app.getStatus()) ? "selected" : "" %>>No-show</option>
                                    </select>
                                </form>
                            <% } else if ("doctor".equalsIgnoreCase(user.getRole())) { %>
                                <form action="<%= request.getContextPath() %>/updateAppointmentStatus" method="post" class="inline-form">
                                    <input type="hidden" name="appointmentId" value="<%= app.getId() %>">
                                    <input type="hidden" name="status" value="Completed">
                                    <button type="submit" class="btn btn-primary btn-sm">Mark as Completed</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/updateAppointmentStatus" method="post" class="inline-form">
                                    <input type="hidden" name="appointmentId" value="<%= app.getId() %>">
                                    <input type="hidden" name="status" value="No-show">
                                    <button type="submit" class="btn btn-danger btn-sm">Mark as No-show</button>
                                </form>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% if (!hasAppointments) { %>
            <p style="text-align: center; margin-top: 20px; color: #6c757d;">No appointments found.</p>
        <% } %>
    </div>
</body>
</html>
