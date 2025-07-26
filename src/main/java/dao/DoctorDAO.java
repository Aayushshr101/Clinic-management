package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Doctor;
import model.DoctorAvailability;
import util.DBConnection;



public class DoctorDAO {
    private Connection conn;

    public DoctorDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Fetch all doctors with department and availability
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        try {
            String query = "SELECT d.id, d.name, d.email, dept.name AS departmentName " +
                           "FROM doctors d JOIN departments dept ON d.department_id = dept.id";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            DoctorAvailabilityDAO availabilityDAO = new DoctorAvailabilityDAO();

            while (rs.next()) {
                Doctor doc = new Doctor();
                int doctorId = rs.getInt("id");
                doc.setId(doctorId);
                doc.setName(rs.getString("name"));
                doc.setEmail(rs.getString("email"));
                doc.setDepartmentName(rs.getString("departmentName"));

                // 🔽 Fetch availability
                List<DoctorAvailability> availabilityList = availabilityDAO.getAvailabilityByDoctorId(doctorId);
                doc.setAvailabilityList(availabilityList);

                list.add(doc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Add doctor (including user record)
    public boolean insertDoctor(String name, String email, int departmentId) {
        Connection con = null;
        PreparedStatement psDoctor = null;
        PreparedStatement psUser = null;
        try {
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
            con.setAutoCommit(false);  // Transaction

            // Insert into doctors
            String doctorQuery = "INSERT INTO doctors (name, email, department_id) VALUES (?, ?, ?)";
            psDoctor = con.prepareStatement(doctorQuery);
            psDoctor.setString(1, name);
            psDoctor.setString(2, email);
            psDoctor.setInt(3, departmentId);
            psDoctor.executeUpdate();

            // Insert into users
            String userQuery = "INSERT INTO users (name, email, password, role) VALUES (?, ?, NULL, 'doctor')";
            psUser = con.prepareStatement(userQuery);
            psUser.setString(1, name);
            psUser.setString(2, email);
            psUser.executeUpdate();

            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ignored) {}
            return false;
        } finally {
            try { if (psDoctor != null) psDoctor.close(); } catch (SQLException ignored) {}
            try { if (psUser != null) psUser.close(); } catch (SQLException ignored) {}
            try { if (con != null) con.close(); } catch (SQLException ignored) {}
        }
    }

    // ✅ Update doctor
    public boolean updateDoctor(int id, String name, String email, int deptId) {
        try {
            Connection conn = DBConnection.getConnection();
            String query = "UPDATE doctors SET name = ?, email = ?, department_id = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, deptId);
            ps.setInt(4, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Delete doctor
    public boolean deleteDoctor(int id) {
        try {
            String sql = "DELETE FROM doctors WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<DoctorAvailability> getAvailabilityByDoctorId(int doctorId) {
        List<DoctorAvailability> availabilityList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");

            String sql = "SELECT * FROM doctor_availability WHERE doctor_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                DoctorAvailability da = new DoctorAvailability();
                da.setId(rs.getInt("id"));
                da.setDoctorId(rs.getInt("doctor_id"));
                da.setDayOfWeek(rs.getString("day_of_week"));
                da.setStartTime(Time.valueOf(rs.getString("start_time")));
                da.setEndTime(Time.valueOf(rs.getString("end_time")));


                availabilityList.add(da);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        return availabilityList;
    }

    public Doctor getDoctorByUserId(int userId) {
        Doctor doctor = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM doctors WHERE user_id = ?")) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("name"));
                doctor.setEmail(rs.getString("email"));
                doctor.setDepartmentId(rs.getInt("department_id"));
                doctor.setAvailabilityList(getDoctorAvailability(rs.getInt("id"))); // Load availability
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctor;
    }
    
    public int getDoctorIdByUserId(int userId) {
        int doctorId = -1;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id FROM doctors WHERE user_id = ?")) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                doctorId = rs.getInt("id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctorId;
    }


    public List<DoctorAvailability> getDoctorAvailability(int doctorId) {
        List<DoctorAvailability> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM doctor_availability WHERE doctor_id = ?")) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

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

    public String getDoctorDepartmentName(int doctorId) {
        String name = "";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT d.name FROM departments d JOIN doctors doc ON d.id = doc.department_id WHERE doc.id = ?");
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
            }

            rs.close(); stmt.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace(); 
        }

        return name;
    }

}
