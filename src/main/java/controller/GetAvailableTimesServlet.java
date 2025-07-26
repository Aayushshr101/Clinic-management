package controller;

import dao.DoctorAvailabilityDAO;
import model.DoctorAvailability;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/getAvailableTimes")
public class GetAvailableTimesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String doctorIdStr = req.getParameter("doctorId");
        res.setContentType("text/html;charset=UTF-8");
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        PrintWriter out = res.getWriter();

        try {
            if (doctorIdStr == null || doctorIdStr.isEmpty()) {
                out.println("<p>Please select a doctor first.</p>");
                return;
            }

            int doctorId = Integer.parseInt(doctorIdStr);
            DoctorAvailabilityDAO dao = new DoctorAvailabilityDAO();
            List<DoctorAvailability> slots = dao.getAvailabilityByDoctorId(doctorId);

            if (slots == null || slots.isEmpty()) {
                out.println("<p>No available slots.</p>");
            } else {
                for (DoctorAvailability slot : slots) {
                    String value = slot.getDayOfWeek() + "|" + slot.getStartTime();
                    String label = slot.getDayOfWeek() + " - " + slot.getStartTime() + " to " + slot.getEndTime();

                    out.println("<label style='display:block;margin-bottom:8px;'>");
                    out.println("<input type='radio' name='slot' value='" + value + "' required> " + label);
                    out.println("</label>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error loading slots.</p>");
        }
    }
}
