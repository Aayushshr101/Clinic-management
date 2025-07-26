package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.User;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String idParam = request.getParameter("id");
        int id = 0;
        if (idParam != null && !idParam.trim().isEmpty()) {
            id = Integer.parseInt(idParam);
        } else {
            request.getSession().setAttribute("msg", "User ID missing. Update failed.");
            response.sendRedirect("view/profile.jsp");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String gender = request.getParameter("gender");

        int age = 0;
        String ageParam = request.getParameter("age");
        if (ageParam != null && !ageParam.trim().isEmpty()) {
            age = Integer.parseInt(ageParam);
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
             PreparedStatement stmt = conn.prepareStatement(
                 "UPDATE users SET name=?, email=?, contact=?, age=?, gender=? WHERE id=?")) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, contact);
            stmt.setInt(4, age);
            stmt.setString(5, gender);
            stmt.setInt(6, id);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // Update session user info
                User updatedUser = (User) request.getSession().getAttribute("user");
                updatedUser.setName(name);
                updatedUser.setEmail(email);
                updatedUser.setContact(contact);
                updatedUser.setAge(age);
                updatedUser.setGender(gender);

                request.getSession().setAttribute("user", updatedUser);
                request.getSession().setAttribute("msg", "Profile updated successfully!");
            } else {
                request.getSession().setAttribute("msg", "Update failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Error: " + e.getMessage());
        }

        response.sendRedirect("view/profile.jsp");
    }
}
