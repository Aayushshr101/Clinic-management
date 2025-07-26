package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import util.DBConnection;

public class AppointmentDAO {
    private Connection conn;

    public AppointmentDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean bookAppointment(Appointment app) {
        // Updated query with end_time field
        String query = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, end_time, patient_name, contact, age, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            // Get start time from appointment
            Time startTime = app.getAppointmentTime();

            // Calculate end time (30 minutes after start)
            long endMillis = startTime.getTime() + 30 * 60 * 1000; // 30 minutes in milliseconds
            Time endTime = new Time(endMillis);

            // Set values in the prepared statement
            ps.setInt(1, app.getPatientId());
            ps.setInt(2, app.getDoctorId());
            ps.setDate(3, app.getAppointmentDate());
            ps.setTime(4, startTime);
            ps.setTime(5, endTime); // ✅ new field
            ps.setString(6, app.getPatientName());
            ps.setString(7, app.getContact());
            ps.setInt(8, app.getAge());
            ps.setString(9, app.getGender());

            // Execute and return result
            int rows = ps.executeUpdate();
            if (rows == 1) {
                System.out.println("✅ Appointment booked successfully.");
                return true;
            } else {
                System.out.println("⚠️ No rows inserted.");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Error booking appointment:");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }




    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        try {
            String query = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.appointment_time, a.end_time, " +
                           "u.name AS patientName, d.name AS doctorName, dept.name AS department, a.status " +
                           "FROM appointments a " +
                           "JOIN users u ON a.patient_id = u.id " +
                           "JOIN doctors d ON a.doctor_id = d.id " +
                           "JOIN departments dept ON d.department_id = dept.id";

            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setPatientId(rs.getInt("patient_id"));
                app.setDoctorId(rs.getInt("doctor_id"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setEndTime(rs.getTime("end_time"));  // ✅ include end time
                app.setPatientName(rs.getString("patientName"));
                app.setDoctorName(rs.getString("doctorName"));
                app.setDepartment(rs.getString("department"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public boolean updateStatus(int appointmentId, String status) {
        try {
            String query = "UPDATE appointments SET status = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        try {
            String query = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.appointment_time, " +
                           "u.name AS patientName, d.name AS doctorName, dept.name AS department, a.status " +
                           "FROM appointments a " +
                           "JOIN users u ON a.patient_id = u.id " +
                           "JOIN doctors d ON a.doctor_id = d.id " +
                           "JOIN departments dept ON d.department_id = dept.id " +
                           "WHERE a.doctor_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setPatientId(rs.getInt("patient_id"));
                app.setDoctorId(rs.getInt("doctor_id"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setPatientName(rs.getString("patientName"));
                app.setDoctorName(rs.getString("doctorName"));
                app.setDepartment(rs.getString("department"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Appointment> getConfirmedAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        try {
            String query = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.appointment_time, " +
                    "u.name AS patientName, d.name AS doctorName, dept.name AS department, a.status " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.id " +
                    "JOIN doctors d ON a.doctor_id = d.id " +
                    "JOIN departments dept ON d.department_id = dept.id " +
                    "WHERE a.doctor_id = ? AND a.status = 'Confirmed'";

            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setPatientId(rs.getInt("patient_id"));
                app.setDoctorId(rs.getInt("doctor_id"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setPatientName(rs.getString("patientName"));
                app.setDoctorName(rs.getString("doctorName"));
                app.setDepartment(rs.getString("department"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        try {
            String query = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.appointment_time, " +
                    "u.name AS patientName, d.name AS doctorName, dept.name AS department, a.status " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.id " +
                    "JOIN doctors d ON a.doctor_id = d.id " +
                    "JOIN departments dept ON d.department_id = dept.id " +
                    "WHERE a.patient_id = ?";

            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, patientId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setPatientId(rs.getInt("patient_id"));
                app.setDoctorId(rs.getInt("doctor_id"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setPatientName(rs.getString("patientName"));
                app.setDoctorName(rs.getString("doctorName"));
                app.setDepartment(rs.getString("department"));
                app.setStatus(rs.getString("status"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public int getTodayAppointmentCount(int doctorId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND DATE(appointment_date) = CURDATE()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public List<Appointment> getCompletedAppointmentsByDoctorId(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.appointment_date, a.appointment_time, a.end_time, a.status, u.name AS patient_name " +
                     "FROM appointments a " +
                     "JOIN users u ON a.patient_id = u.id " +
                     "WHERE a.doctor_id = ? AND a.status = 'Completed'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setAppointmentDate(rs.getDate("appointment_date"));
                appt.setAppointmentTime(rs.getTime("appointment_time"));
                appt.setEndTime(rs.getTime("end_time")); // Include if you added end_time
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name"));
                list.add(appt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    }




