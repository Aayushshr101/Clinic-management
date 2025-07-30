package controller;

import dao.DepartmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteDepartment")
public class DeleteDepartmentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            DepartmentDAO dao = new DepartmentDAO();
            dao.deleteDepartment(id);

            
            request.getSession().setAttribute("msg", "Department deleted successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Error deleting department.");
        }

        response.sendRedirect("view/adminDashboard.jsp"); // Redirect to your admin page
    }
}

