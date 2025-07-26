package controller;

import dao.DoctorAvailabilityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorAvailability;

import java.io.IOException;
import java.sql.Time;
import java.time.LocalTime;

@WebServlet("/updateAvailability")
public class UpdateAvailabilityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
        	int id = Integer.parseInt(req.getParameter("availabilityId"));
        	String day = req.getParameter("dayOfWeek");

        	LocalTime start = LocalTime.parse(req.getParameter("startTime"));
        	Time startTime = Time.valueOf(start);

        	LocalTime end = LocalTime.parse(req.getParameter("endTime"));  // ✅ Added
        	Time endTime = Time.valueOf(end);  // ✅ Added

        	DoctorAvailability availability = new DoctorAvailability();
        	availability.setId(id);
        	availability.setDayOfWeek(day);
        	availability.setStartTime(startTime);
        	availability.setEndTime(endTime);  


            DoctorAvailabilityDAO dao = new DoctorAvailabilityDAO();
            boolean updated = dao.updateAvailability(availability);

            HttpSession session = req.getSession();
            session.setAttribute("msg", updated ? "Availability updated." : "Failed to update availability.");
            res.sendRedirect("view/adminDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("msg", "Error: " + e.getMessage());
            res.sendRedirect("view/adminDashboard.jsp");
        }
    }
}
