// ================================
// 2. UpdateDepartmentServlet.java
// ================================
package controller;

import dao.DepartmentDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateDepartment")
public class UpdateDepartmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");

        DepartmentDAO dao = new DepartmentDAO();
        boolean updated = dao.updateDepartment(id, name);

        HttpSession session = req.getSession();
        if (updated) session.setAttribute("msg", "Department updated successfully.");
        else session.setAttribute("msg", "Failed to update department.");

        res.sendRedirect("view/adminDashboard.jsp");
    }
}
