package controller;

import dao.AppointmentDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/updateAppointmentStatus")
public class UpdateAppointmentStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = Integer.parseInt(req.getParameter("appointmentId"));
        String status = req.getParameter("status");

        AppointmentDAO dao = new AppointmentDAO();
        boolean updated = dao.updateStatus(id, status);

        HttpSession session = req.getSession();
        session.setAttribute("msg", updated ? "Status updated successfully." : "Failed to update status.");
        res.sendRedirect("view/appointments.jsp");
    }
}
