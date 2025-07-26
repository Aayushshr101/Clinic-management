package dao;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

import model.DoctorAvailability;
import util.DBConnection;

public class DoctorAvailabilityDAO {
    private Connection conn;

    public DoctorAvailabilityDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ This is the missing method
    public List<DoctorAvailability> getAvailabilityByDoctorId(int doctorId) {
        List<DoctorAvailability> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctor_availability WHERE doctor_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DoctorAvailability da = new DoctorAvailability();
                da.setId(rs.getInt("id"));
                da.setDoctorId(rs.getInt("doctor_id"));
                da.setDayOfWeek(rs.getString("day_of_week"));
                da.setStartTime(rs.getTime("start_time"));
                da.setEndTime(rs.getTime("end_time"));
                list.add(da);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addAvailability(DoctorAvailability availability) {
        try {
            String query = "INSERT INTO doctor_availability (doctor_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, availability.getDoctorId());
            ps.setString(2, availability.getDayOfWeek());
            ps.setTime(3, availability.getStartTime());
            ps.setTime(4, availability.getEndTime());

            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
 // src/dao/DoctorAvailabilityDAO.java
    public boolean updateAvailability(DoctorAvailability availability) {
        try {
            String sql = "UPDATE doctor_availability SET day_of_week = ?, start_time = ?, end_time = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, availability.getDayOfWeek());
            ps.setTime(2, availability.getStartTime());
            ps.setTime(3, availability.getEndTime());
            ps.setInt(4, availability.getId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAvailability(int id) {
        try {
            String sql = "DELETE FROM doctor_availability WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}
