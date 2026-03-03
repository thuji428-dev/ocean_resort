package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    
    // Generate bill for reservation
    public boolean generateBill(int reservationId, int totalNights, double totalAmount) {
        String sql = "INSERT INTO bill (reservation_id, total_nights, total_amount, generated_date) " +
                    "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reservationId);
            pstmt.setInt(2, totalNights);
            pstmt.setDouble(3, totalAmount);
            pstmt.setDate(4, Date.valueOf(LocalDate.now()));
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if bill exists for reservation
    public boolean hasBill(int reservationId) {
        String sql = "SELECT COUNT(*) FROM bill WHERE reservation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Get bill by reservation ID
    public Bill getBillByReservationId(int reservationId) {
        String sql = "SELECT b.*, r.reservation_number, g.guest_name, rt.type_name " +
                    "FROM bill b " +
                    "JOIN reservation r ON b.reservation_id = r.reservation_id " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "WHERE b.reservation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setReservationNumber(rs.getString("reservation_number"));
                bill.setGuestName(rs.getString("guest_name"));
                bill.setRoomTypeName(rs.getString("type_name"));
                bill.setTotalNights(rs.getInt("total_nights"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setGeneratedDate(rs.getDate("generated_date").toLocalDate());
                return bill;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get all bills
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, r.reservation_number, g.guest_name, rt.type_name " +
                    "FROM bill b " +
                    "JOIN reservation r ON b.reservation_id = r.reservation_id " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "ORDER BY b.generated_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setReservationNumber(rs.getString("reservation_number"));
                bill.setGuestName(rs.getString("guest_name"));
                bill.setRoomTypeName(rs.getString("type_name"));
                bill.setTotalNights(rs.getInt("total_nights"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setGeneratedDate(rs.getDate("generated_date").toLocalDate());
                bills.add(bill);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bills;
    }
    
 // Get bill by ID
    public Bill getBillById(int billId) {
        String sql = "SELECT b.*, r.reservation_number, g.guest_name, rt.type_name " +
                    "FROM bill b " +
                    "JOIN reservation r ON b.reservation_id = r.reservation_id " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "WHERE b.bill_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setReservationNumber(rs.getString("reservation_number"));
                bill.setGuestName(rs.getString("guest_name"));
                bill.setRoomTypeName(rs.getString("type_name"));
                bill.setTotalNights(rs.getInt("total_nights"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setGeneratedDate(rs.getDate("generated_date").toLocalDate());
                return bill;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}