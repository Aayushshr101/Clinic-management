package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deletePatient")
public class DeletePatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        UserDAO dao = new UserDAO();
        boolean deleted = dao.deletePatient(id);

        HttpSession session = req.getSession();
        if (deleted) {
            session.setAttribute("msg", "Patient deleted successfully!");
        } else {
            session.setAttribute("msg", "Failed to delete patient.");
        }

        res.sendRedirect("view/adminDashboard.jsp");
    }
}
