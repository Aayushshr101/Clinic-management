package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/setDoctorPassword")
public class SetDoctorPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        boolean updated = dao.setDoctorPassword(email, password);

        HttpSession session = req.getSession();
        if (updated) {
            session.setAttribute("msg", "Password set successfully! You can now login.");
            res.sendRedirect("view/login.jsp");
        } else {
            session.setAttribute("msg", "Failed to set password.");
            res.sendRedirect("view/doctorSetPassword.jsp");
        }
    }
}
