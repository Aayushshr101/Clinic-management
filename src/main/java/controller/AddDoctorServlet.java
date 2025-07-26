package controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/addDoctor")
public class AddDoctorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        String[] days = request.getParameterValues("dayOfWeek");
        String[] starts = request.getParameterValues("startTime");
        String[] ends = request.getParameterValues("endTime");

        Connection conn = null;
        PreparedStatement userStmt = null;
        PreparedStatement doctorStmt = null;
        PreparedStatement availabilityStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");

            // 1. Insert into users
            String insertUserSQL = "INSERT INTO users (name, email, password, role) VALUES (?, ?, 'default123', 'doctor')";
            userStmt = conn.prepareStatement(insertUserSQL, Statement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, name);
            userStmt.setString(2, email);
            userStmt.executeUpdate();

            rs = userStmt.getGeneratedKeys();
            int userId = -1;
            if (rs.next()) userId = rs.getInt(1);

            if (userId != -1) {
                // 2. Insert into doctors
                String insertDoctorSQL = "INSERT INTO doctors (name, email, department_id, user_id) VALUES (?, ?, ?, ?)";
                doctorStmt = conn.prepareStatement(insertDoctorSQL, Statement.RETURN_GENERATED_KEYS);
                doctorStmt.setString(1, name);
                doctorStmt.setString(2, email);
                doctorStmt.setInt(3, departmentId);
                doctorStmt.setInt(4, userId);
                doctorStmt.executeUpdate();

                rs = doctorStmt.getGeneratedKeys();
                int doctorId = -1;
                if (rs.next()) doctorId = rs.getInt(1);

                // 3. Insert availability if provided
                if (doctorId != -1 && days != null) {
                    String insertAvailabilitySQL = "INSERT INTO doctor_availability (doctor_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
                    availabilityStmt = conn.prepareStatement(insertAvailabilitySQL);
                    for (int i = 0; i < days.length; i++) {
                        if (!starts[i].isEmpty() && !ends[i].isEmpty()) {
                            availabilityStmt.setInt(1, doctorId);
                            availabilityStmt.setString(2, days[i]);
                            availabilityStmt.setString(3, starts[i]);
                            availabilityStmt.setString(4, ends[i]);
                            availabilityStmt.addBatch();
                        }
                    }
                    availabilityStmt.executeBatch();
                }

                request.getSession().setAttribute("msg", "Doctor and availability added!");
            } else {
                request.getSession().setAttribute("msg", "Doctor user creation failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (userStmt != null) userStmt.close(); } catch (Exception ignored) {}
            try { if (doctorStmt != null) doctorStmt.close(); } catch (Exception ignored) {}
            try { if (availabilityStmt != null) availabilityStmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        response.sendRedirect("view/adminDashboard.jsp");
    }
}
