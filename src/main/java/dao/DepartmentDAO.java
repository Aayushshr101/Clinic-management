package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Department;

public class DepartmentDAO {
    private Connection conn;

    public DepartmentDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/clinic_db", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean addDepartment(String name) {
        try {
            String query = "INSERT INTO departments (name) VALUES (?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, name);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM departments";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean deleteDepartment(int id) {
        try {
            String sql = "DELETE FROM departments WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateDepartment(int id, String name) {
        try {
            String sql = "UPDATE departments SET name = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
