<%@ page import="java.util.*, model.Appointment, dao.AppointmentDAO, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - MediTrackPro</title>
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
            max-width: 900px; /* Wider for table content */
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

        table {
            width: 100%;
            border-collapse: separate; /* Use separate for rounded corners */
            border-spacing: 0;
            margin-top: 25px;
            border: 1px solid var(--border-color);
            border-radius: 8px; /* Rounded corners for the whole table */
            overflow: hidden; /* Ensures rounded corners apply to content */
            box-shadow: 0 4px 15px var(--card-shadow);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--card-border);
        }

        th {
            background: var(--primary-color);
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
        }

        /* Rounded corners for first/last th */
        th:first-child {
            border-top-left-radius: 8px;
        }
        th:last-child {
            border-top-right-radius: 8px;
        }

        tr:nth-child(even) {
            background: var(--background-light);
        }

        tr:last-child td {
            border-bottom: none; /* Remove bottom border for last row */
        }

        /* Rounded corners for last row cells */
        tr:last-child td:first-child {
            border-bottom-left-radius: 8px;
        }
        tr:last-child td:last-child {
            border-bottom-right-radius: 8px;
        }

        .no-appointments-message {
            text-align: center;
            color: var(--text-medium);
            font-size: 1.1rem;
            padding: 30px 0;
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
            .button {
                font-size: 1rem;
                padding: 12px 15px;
            }
            table, th, td {
                display: block; /* Stack table elements on small screens */
                width: 100%;
            }
            th {
                text-align: right; /* Align header to right for stacked view */
                padding-right: 50%; /* Push text to the right */
                position: relative;
            }
            td {
                text-align: left;
                position: relative;
                padding-left: 50%; /* Make space for pseudo-element */
            }
            td:before {
                content: attr(data-label); /* Use data-label for pseudo-header */
                position: absolute;
                left: 15px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                text-align: left;
                font-weight: 600;
                color: var(--text-dark);
            }
            /* Remove rounded corners for stacked view */
            th:first-child, th:last-child,
            tr:last-child td:first-child, tr:last-child td:last-child {
                border-radius: 0;
            }
            table {
                border-radius: 0;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="patientDashboard.jsp" class="button back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>

    <h2>Your Appointment History</h2>

    <% if (appointments != null && !appointments.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>Doctor</th>
                    <th>Department</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.text.SimpleDateFormat dateFormatter = new java.text.SimpleDateFormat("EEEE, MMM dd yyyy");
                    java.text.SimpleDateFormat timeFormatter = new java.text.SimpleDateFormat("hh:mm a");
                    for (Appointment app : appointments) {
                %>
                <tr>
                    <td data-label="Doctor"><%= app.getDoctorName() %></td>
                    <td data-label="Department"><%= app.getDepartment() %></td>
                    <td data-label="Date"><%= dateFormatter.format(app.getAppointmentDate()) %></td>
                    <td data-label="Time"><%= timeFormatter.format(app.getAppointmentTime()) %></td>
                    <td data-label="Status"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p class="no-appointments-message">No appointment history found.</p>
    <% } %>
</div>
</body>
</html>
