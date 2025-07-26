package controller;

import dao.DoctorAvailabilityDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteAvailability")
public class DeleteAvailabilityServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            DoctorAvailabilityDAO dao = new DoctorAvailabilityDAO();
            boolean deleted = dao.deleteAvailability(id);

            HttpSession session = req.getSession();
            session.setAttribute("msg", deleted ? "Availability deleted." : "Failed to delete availability.");
            res.sendRedirect("view/adminDashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("msg", "Error: " + e.getMessage());
            res.sendRedirect("view/adminDashboard.jsp");
        }
    }
}
