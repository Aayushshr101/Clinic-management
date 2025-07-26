<%@ page session="true" %>
<%@ page import="model.User" %>
<%@ page import="dao.AppointmentDAO, dao.DoctorDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Appointment" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    DoctorDAO doctorDao = new DoctorDAO();
    AppointmentDAO apptDao = new AppointmentDAO();
    int doctorId = doctorDao.getDoctorIdByUserId(user.getId());
    int todayCount = apptDao.getTodayAppointmentCount(doctorId);
    String departmentName = doctorDao.getDoctorDepartmentName(doctorId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - MediTrackPro</title>
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
            --border-color: #e0e0e0; /* Lighter border */
            --card-bg: #ffffff;
            --card-shadow: rgba(0, 0, 0, 0.03); /* Softer shadow */
            --container-shadow: rgba(0, 0, 0, 0.05); /* Softer container shadow */
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background-light);
            padding: 15px; /* Reduced padding */
            color: var(--text-dark);
            line-height: 1.6;
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Align to top */
            min-height: 100vh;
        }

        .container {
            background: var(--card-bg);
            padding: 25px; /* Reduced padding */
            border-radius: 10px; /* Slightly smaller border-radius */
            max-width: 480px; /* Significantly smaller max-width */
            width: 100%;
            box-shadow: 0 5px 15px var(--container-shadow); /* Softer shadow */
            margin-top: 30px; /* Reduced margin-top */
            display: flex;
            flex-direction: column;
            gap: 20px; /* Spacing between main sections */
        }

        .header-section {
            text-align: center;
            padding-bottom: 10px; /* Reduced padding */
            border-bottom: 1px solid var(--border-color); /* Lighter border */
        }

        h1 {
            color: var(--primary-color);
            margin-bottom: 3px; /* Reduced margin */
            font-size: 1.8rem; /* Smaller font size */
            font-weight: 700;
        }

        h3 {
            color: var(--text-dark);
            margin-top: 0;
            margin-bottom: 10px; /* Reduced margin */
            font-size: 1.2rem; /* Smaller font size */
            font-weight: 600;
            text-align: center;
        }

        p {
            color: var(--text-medium);
            font-size: 0.9rem; /* Smaller font size */
            text-align: center;
            margin-bottom: 0;
        }

        .metrics-card {
            background: var(--background-light); /* Lighter background */
            padding: 20px; /* Reduced padding */
            border-radius: 8px; /* Slightly smaller border-radius */
            border: 1px solid var(--border-color); /* Lighter border */
            text-align: center;
            box-shadow: 0 2px 8px var(--card-shadow); /* Softer shadow */
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px; /* Reduced gap */
        }

        .metrics-card .count {
            font-size: 2.5rem; /* Significantly smaller font size */
            font-weight: 700;
            line-height: 1;
            margin-bottom: 0; /* Removed margin */
            color: var(--primary-color); /* Primary color for count */
        }

        .metrics-card .label {
            font-size: 0.95rem; /* Smaller font size */
            font-weight: 500;
            color: var(--text-medium); /* Darker text for light background */
        }

        .navigation-grid {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* More compact grid */
            gap: 10px; /* Reduced gap */
            width: 100%;
        }

        .navigation-grid li {
            margin-bottom: 0;
        }

        .button {
            background-color: var(--text-light); /* Use text-light for back button */
            color: white;
            padding: 10px 15px; /* Smaller padding */
            border: none;
            border-radius: 6px; /* Smaller border-radius */
            font-size: 0.95rem; /* Smaller font size */
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* Softer shadow */
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            text-decoration: none;
            gap: 6px; /* Reduced gap */
        }

        .button:hover {
            background-color: #5a6268; /* Darker hover for text-light */
            transform: translateY(-1px); /* Smaller hover effect */
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
        }

        .button:active {
            transform: translateY(0);
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);
        }

        .nav-link-btn {
            background-color: var(--primary-color); /* Use primary color for nav links */
            color: white;
            text-align: center;
            padding: 15px 10px; /* Reduced padding */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            border-radius: 8px; /* Slightly smaller border-radius */
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 3px 10px rgba(74, 144, 226, 0.2); /* Softer shadow */
            transition: background-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
            gap: 8px; /* Reduced gap */
            height: 100%;
        }

        .nav-link-btn i {
            font-size: 2rem; /* Smaller icons */
            margin-bottom: 0; /* Removed margin */
        }

        .nav-link-btn span {
            font-size: 0.9rem; /* Smaller font size */
            line-height: 1.2;
        }

        .nav-link-btn:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px); /* Smaller hover effect */
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .nav-link-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.2);
        }

        /* Specific style for logout button */
        .logout-btn {
            background-color: #dc3545; /* Red for logout */
            --primary-color: #dc3545; /* Override primary for this button */
            --primary-hover: #c82333;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            body {
                padding: 10px; /* Even less padding on small screens */
            }
            .container {
                margin-top: 20px;
                padding: 15px; /* Even less padding */
                gap: 15px;
            }
            h1 {
                font-size: 1.6rem;
            }
            h3 {
                font-size: 1.1rem;
            }
            .button {
                font-size: 0.9rem;
                padding: 8px 12px;
            }
            .metrics-card {
                padding: 15px;
            }
            .metrics-card .count {
                font-size: 2rem;
            }
            .metrics-card .label {
                font-size: 0.85rem;
            }
            .navigation-grid {
                grid-template-columns: 1fr; /* Stack buttons on very small screens */
            }
            .nav-link-btn {
                padding: 12px;
            }
            .nav-link-btn i {
                font-size: 1.8rem;
            }
            .nav-link-btn span {
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="index.jsp" class="button back-button">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>

    <div class="header-section">
        <h1>Welcome Dr. <%= user.getName() %></h1>
        <p><strong>Department:</strong> <%= departmentName %></p>
    </div>

    <div class="metrics-card">
        <div class="count"><%= todayCount %></div>
        <div class="label">Today's Appointments</div>
    </div>

    <div>
        <h3>Quick Links</h3>
        <ul class="navigation-grid">
            <li>
                <a href="<%= request.getContextPath() %>/view/appointments.jsp" class="nav-link-btn">
                    <i class="fas fa-calendar-alt"></i>
                    <span>View Appointments</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/view/doctorAvailability.jsp" class="nav-link-btn">
                    <i class="fas fa-clock"></i>
                    <span>View My Availability</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/view/doctorPatientHistory.jsp" class="nav-link-btn">
                    <i class="fas fa-history"></i>
                    <span>View Patient History</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/logout" class="nav-link-btn logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
</div>
</body>
</html>
