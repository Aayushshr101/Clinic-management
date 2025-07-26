package dao;

import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

	public User login(String email, String password) {
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        String hashed = PasswordUtil.hashPassword(password);
	        
	        System.out.println("Trying to log in with:");
	        System.out.println("Email: " + email);
	        System.out.println("Hashed Password: " + hashed);

	        ps.setString(1, email);
	        ps.setString(2, hashed);
	        
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            System.out.println("Login success");
	            User user = new User();
	            user.setId(rs.getInt("id"));
	            user.setName(rs.getString("name"));
	            user.setEmail(rs.getString("email"));
	            user.setRole(rs.getString("role"));
	            return user;
	        } else {
	            System.out.println("Login failed");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public boolean register(User user) {
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'patient')";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, user.getName());
	        ps.setString(2, user.getEmail());
	        ps.setString(3, PasswordUtil.hashPassword(user.getPassword())); //  hash
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}


	public boolean setDoctorPassword(String email, String password) {
	    try (Connection con = DBConnection.getConnection()) {
	        String query = "UPDATE users SET password = ? WHERE email = ? AND role = 'doctor'";
	        PreparedStatement ps = con.prepareStatement(query);
	        ps.setString(1, PasswordUtil.hashPassword(password)); // 🔒 hash
	        ps.setString(2, email);
	        return ps.executeUpdate() == 1;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}


    public List<User> getAllPatients() {
        List<User> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE role = 'patient'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updatePatient(int id, String name, String email) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE users SET name = ?, email = ? WHERE id = ? AND role = 'patient'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePatient(int id) {
        try (Connection con = DBConnection.getConnection()) {
            // First delete patient's appointments
            String deleteAppointments = "DELETE FROM appointments WHERE patient_id = ?";
            PreparedStatement ps1 = con.prepareStatement(deleteAppointments);
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // Now delete the patient
            String deletePatient = "DELETE FROM users WHERE id = ? AND role = 'patient'";
            PreparedStatement ps2 = con.prepareStatement(deletePatient);
            ps2.setInt(1, id);
            return ps2.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static void main(String[] args) {
        String hashed = PasswordUtil.hashPassword("admin123");
        System.out.println("Hashed admin123: " + hashed);
    }

}
