package com.oceanview.dao;

import com.oceanview.model.Admin;
import com.oceanview.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public Admin login(String username, String password) {

        Admin admin = null;

        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("DB Connection: " + conn);

            String sql = "SELECT * FROM admin WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);

            System.out.println("Executing query for username: " + username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String dbPassword = rs.getString("password");

                System.out.println("DB Password: [" + dbPassword + "]");
                System.out.println("DB Password Length: " + dbPassword.length());
                System.out.println("Entered Hashed Password: [" + password + "]");

                if (dbPassword.equals(password)) {
                    System.out.println("PASSWORD MATCHED");

                    admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));

                } else {
                    System.out.println("PASSWORD NOT MATCHING");
                }

            } else {
                System.out.println("USERNAME NOT FOUND");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }
}