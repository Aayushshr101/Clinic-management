<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*, dao.UserDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Set Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="doctor-set-password.css"> <!-- Link to the new doctor-set-password.css -->
</head>
<body class="auth-page"> <!-- Use auth-page class for consistent styling -->
    <div class="auth-container"> <!-- Use auth-container for consistent styling -->
        <%
            String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
            <div class="message-box success">
                <%= msg %>
            </div>
        <%
                session.removeAttribute("msg");
            }
        %>
        <h2>Set Password</h2>
        <form action="<%= request.getContextPath() %>/setDoctorPassword" method="post">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required />
            </div>
            <div class="form-group">
                <label for="password">New Password:</label>
                <input type="password" id="password" name="password" required />
            </div>
            <button type="submit" class="btn btn-primary">Set Password</button> <!-- Use btn btn-primary class -->
        </form>
    </div>
</body>
</html>
