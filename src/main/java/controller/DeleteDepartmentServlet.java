package controller;

import dao.DepartmentDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteDepartment")
public class DeleteDepartmentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        DepartmentDAO dao = new DepartmentDAO();
        boolean deleted = dao.deleteDepartment(id);

        HttpSession session = req.getSession();
        if (deleted) session.setAttribute("msg", "Department deleted.");
        else session.setAttribute("msg", "Failed to delete department.");

        res.sendRedirect("view/adminDashboard.jsp");
    }
}
