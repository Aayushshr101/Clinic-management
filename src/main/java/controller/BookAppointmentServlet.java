package controller;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Appointment;
import model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.*;

@WebServlet("/bookAppointment")
public class BookAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User patient = (User) session.getAttribute("user");

        if (patient == null || !"patient".equals(patient.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        try {
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));
            String slot = req.getParameter("slot");  // ✅ FIXED: this must match radio input name

            if (slot == null || !slot.contains("|")) {
                session.setAttribute("msg", "Invalid time slot selected.");
                res.sendRedirect("view/patientDashboard.jsp");
                return;
            }

            String[] parts = slot.split("\\|");
            String dayOfWeekStr = parts[0];
            String timeStr = parts[1];

            // Get next date for selected day
            DayOfWeek selectedDay = DayOfWeek.valueOf(dayOfWeekStr.toUpperCase());
            LocalDate today = LocalDate.now();
            int daysUntil = (selectedDay.getValue() - today.getDayOfWeek().getValue() + 7) % 7;
            LocalDate appointmentDate = today.plusDays(daysUntil == 0 ? 7 : daysUntil);
            Date sqlDate = Date.valueOf(appointmentDate);
            Time sqlTime = Time.valueOf(timeStr);

            // Get patient info
            String fullName = req.getParameter("fullName");
            String contact = req.getParameter("contact");
            int age = Integer.parseInt(req.getParameter("age"));
            String gender = req.getParameter("gender");

            // Build Appointment object
            Appointment app = new Appointment();
            app.setPatientId(patient.getId());
            app.setDoctorId(doctorId);
            app.setAppointmentDate(sqlDate);
            app.setAppointmentTime(sqlTime);
            app.setPatientName(fullName);
            app.setContact(contact);
            app.setAge(age);
            app.setGender(gender);

            // Save to DB
            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.bookAppointment(app);

            session.setAttribute("msg", success ? "Appointment booked successfully." : "Failed to book appointment.");
            res.sendRedirect("view/patientDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            res.sendRedirect("view/patientDashboard.jsp");
        }
    }
}