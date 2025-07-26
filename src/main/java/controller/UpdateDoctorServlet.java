package controller;

import dao.DoctorDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateDoctor")
public class UpdateDoctorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        int deptId = Integer.parseInt(req.getParameter("departmentId"));

        DoctorDAO dao = new DoctorDAO();
        boolean updated = dao.updateDoctor(id, name, email, deptId);

        HttpSession session = req.getSession();
        session.setAttribute("msg", updated ? "Doctor updated." : "Doctor update failed.");
        res.sendRedirect("view/adminDashboard.jsp");
    }
}

