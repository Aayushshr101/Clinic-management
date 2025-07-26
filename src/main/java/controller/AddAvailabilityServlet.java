package controller;

import dao.DoctorAvailabilityDAO;
import model.DoctorAvailability;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Time;

@WebServlet("/addAvailability")
public class AddAvailabilityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        String day = req.getParameter("dayOfWeek");
        Time start = Time.valueOf(req.getParameter("startTime") + ":00");
        Time end = Time.valueOf(req.getParameter("endTime") + ":00");

        DoctorAvailability av = new DoctorAvailability();
        av.setDoctorId(doctorId);
        av.setDayOfWeek(day);
        av.setStartTime(start);
        av.setEndTime(end);

        DoctorAvailabilityDAO dao = new DoctorAvailabilityDAO();
        if (dao.addAvailability(av)) {
            req.getSession().setAttribute("msg", "Availability added.");
        } else {
            req.getSession().setAttribute("msg", "Failed to add availability.");
        }
        res.sendRedirect("view/adminDashboard.jsp");

    }
}
