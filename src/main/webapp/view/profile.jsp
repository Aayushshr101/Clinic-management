<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    String gender = user.getGender() != null ? user.getGender() : "";
    String contact = user.getContact() != null ? user.getContact() : "";
    int age = user.getAge();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MediTrackPro</title>
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
            max-width: 600px;
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

        label {
            display: block;
            font-weight: 600;
            color: var(--text-medium);
            margin-bottom: 8px;
            margin-top: 20px;
            font-size: 0.95rem;
        }

        input[type="text"],
        input[type="number"],
        input[type="email"],
        select {
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

        input:focus,
        select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
        }

        input[readonly] {
            background-color: var(--background-light);
            cursor: default;
            font-weight: 500;
            color: var(--text-medium);
            opacity: 1;
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

        .error-message {
            background-color: #f8d7da; /* Light red */
            color: #721c24; /* Dark red */
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 8px;
            border: 1px solid #f5c6cb;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
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
            .button {
                font-size: 1rem;
                padding: 12px 15px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="patientDashboard.jsp" class="button back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>

    <h2>My Profile</h2>
    <%
        String msg = (String) session.getAttribute("msg");
        String error = (String) session.getAttribute("error");
        if (msg != null) {
    %>
        <div class="message">
            <i class="fas fa-check-circle"></i>
            <%= msg %>
        </div>
    <%
            session.removeAttribute("msg");
        } else if (error != null) {
    %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <%= error %>
        </div>
    <%
            session.removeAttribute("error");
        }
    %>

    <form action="../updateProfile" method="post" class="space-y-4">
        <div>
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="<%= user.getName() %>" required>
        </div>
        <div>
            <label for="email">Email</label>
            <input type="email" name="email" id="email" value="<%= user.getEmail() %>" readonly>
        </div>
        <div>
            <label for="contact">Contact</label>
            <input type="text" name="contact" id="contact" value="<%= contact %>" required>
        </div>
        <div>
            <label for="age">Age</label>
            <input type="number" name="age" id="age" value="<%= age %>" required min="1" max="120">
        </div>
        <input type="hidden" name="id" value="<%= user.getId() %>">
        <div>
            <label for="gender">Gender</label>
            <select name="gender" id="gender" required>
                <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
            </select>
        </div>
        <button type="submit" class="button">
            <i class="fas fa-save"></i>
            Update Profile
        </button>
    </form>
</div>
</body>
</html>
