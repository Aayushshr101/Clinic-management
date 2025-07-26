package controller;

import dao.DoctorDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteDoctor")
public class DeleteDoctorServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        DoctorDAO dao = new DoctorDAO();
        boolean deleted = dao.deleteDoctor(id);

        HttpSession session = req.getSession();
        if (deleted) session.setAttribute("msg", "Doctor deleted successfully.");
        else session.setAttribute("msg", "Failed to delete doctor.");

        res.sendRedirect("view/adminDashboard.jsp");
    }
}
