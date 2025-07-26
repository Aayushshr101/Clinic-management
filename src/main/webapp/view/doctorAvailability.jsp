<%@ page session="true" import="model.User, dao.DoctorDAO, model.Doctor" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    DoctorDAO dao = new DoctorDAO();
    Doctor doctor = dao.getDoctorByUserId(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Availability - MediTrackPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

        /* Header */
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
            max-width: 800px; /* Adjusted max-width for table content */
            margin: 30px auto;
            box-shadow: 0 6px 20px var(--container-shadow);
            border: 1px solid #e9ecef; /* Subtle border for the main container */
            flex-grow: 1; /* Allow container to grow and push footer down */
        }

        h2 {
            color: var(--text-dark);
            font-weight: 700;
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 0.8rem;
            margin-top: 0; /* Remove extra top margin */
            text-align: center;
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

        .no-availability-message {
            text-align: center;
            color: var(--text-medium);
            font-size: 1.1rem;
            padding: 30px 0;
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
                margin-top: 1.5rem;
            }
            .btn {
                font-size: 0.85rem;
                padding: 0.6rem 1.2rem;
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
        }
    </style>
</head>
<body>
    <header class="admin-header">
        <h1>My Availability</h1>
        <a href="<%= request.getContextPath() %>/logout" class="logout-link">Logout <i class="fas fa-sign-out-alt"></i></a>
    </header>
    <div class="container">
        <div style="margin-bottom: 20px;">
            <a href="<%= request.getContextPath() %>/view/doctorDashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        <h2>Hello, <%= user.getName() %> - Your Weekly Availability</h2>
        <%
            if (doctor != null && doctor.getAvailabilityList() != null && !doctor.getAvailabilityList().isEmpty()) {
        %>
            <table>
                <thead>
                    <tr>
                        <th>Day</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (model.DoctorAvailability av : doctor.getAvailabilityList()) { %>
                        <tr>
                            <td data-label="Day"><%= av.getDayOfWeek() %></td>
                            <td data-label="Start Time"><%= av.getStartTime() %></td>
                            <td data-label="End Time"><%= av.getEndTime() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="no-availability-message">No availability set. Please contact the admin to add your time slots.</p>
        <% } %>
    </div>
</body>
</html>
