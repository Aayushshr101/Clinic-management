package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/updatePatient")
public class UpdatePatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");

        UserDAO dao = new UserDAO();
        boolean updated = dao.updatePatient(id, name, email);

        HttpSession session = req.getSession();
        session.setAttribute("msg", updated ? "Patient updated successfully!" : "Failed to update patient.");

        res.sendRedirect("view/adminDashboard.jsp");
    }
}
