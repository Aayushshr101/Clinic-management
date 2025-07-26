package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.DepartmentDAO;

@WebServlet("/addDepartment")
public class AddDepartmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String deptName = req.getParameter("department");

        DepartmentDAO dao = new DepartmentDAO();
        boolean added = dao.addDepartment(deptName);

        if (added) {
            // ✅ Add success message to session
            HttpSession session = req.getSession();
            session.setAttribute("msg", "Department added successfully!");
            res.sendRedirect("view/adminDashboard.jsp");
        } else {
            req.setAttribute("msg", "Failed to add department.");
            req.getRequestDispatcher("view/adminDashboard.jsp").forward(req, res);
        }
    }
}
