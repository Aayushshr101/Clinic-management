package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/login")

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            switch (user.getRole()) {
                case "admin":
                    res.sendRedirect("view/adminDashboard.jsp");
                    break;
                case "doctor":
                    res.sendRedirect("view/doctorDashboard.jsp");
                    break;
                case "patient":
                    res.sendRedirect("view/index.jsp");
                    break;
                default:
                    res.sendRedirect("error.jsp");
            }
        } else {
            req.setAttribute("msg", "Invalid credentials");
            req.getRequestDispatcher("/view/login.jsp").forward(req, res);

        }
    }
}
