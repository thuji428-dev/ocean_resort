package com.oceanview.dao;

import com.oceanview.model.DashboardStats;
import com.oceanview.model.RecentReservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {
    
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        
        // Updated query with your requirements
        String query = "SELECT " +
            "(SELECT COUNT(*) FROM room_type) as total_rooms, " +  // 1. Room types count
            "(SELECT COUNT(*) FROM guest) as total_guests, " +      // 4. Users/Guests count
            "(SELECT COUNT(*) FROM reservation WHERE status = 'BOOKED') as active_bookings, " + // 2. Active Bookings
            "(SELECT COALESCE(SUM(total_amount), 0) FROM bill WHERE MONTH(generated_date) = MONTH(CURDATE()) AND YEAR(generated_date) = YEAR(CURDATE())) as monthly_revenue, " + // Monthly revenue
            "(SELECT COALESCE(SUM(total_amount), 0) FROM bill WHERE DATE(generated_date) = CURDATE()) as today_revenue"; // Today's revenue
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                stats.setTotalRooms(rs.getInt("total_rooms"));           // Room types
                stats.setTotalGuests(rs.getInt("total_guests"));         // Guest count
                stats.setActiveBookings(rs.getInt("active_bookings"));   // Active bookings
                stats.setMonthlyRevenue(rs.getDouble("monthly_revenue")); // Monthly revenue
                stats.setTodayRevenue(rs.getDouble("today_revenue"));     // Today's revenue
                
                // Set other fields to 0 or empty as they're not used
                stats.setOccupiedRooms(0);
                stats.setAvailableRooms(0);
                stats.setCheckInsToday(0);
                stats.setCheckOutsToday(0);
                stats.setPendingBills(0);
                stats.setOccupancyRate(0);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
    
    public List<RecentReservation> getRecentReservations(int limit) {
        List<RecentReservation> reservations = new ArrayList<>();
        
        String query = "SELECT r.reservation_number, g.guest_name, rt.type_name, " +
                      "DATE_FORMAT(r.check_in_date, '%Y-%m-%d') as check_in_date, " +
                      "DATE_FORMAT(r.check_out_date, '%Y-%m-%d') as check_out_date, " +
                      "r.status, " +
                      "DATEDIFF(r.check_out_date, r.check_in_date) * rt.price_per_night as total_amount " +
                      "FROM reservation r " +
                      "JOIN guest g ON r.guest_id = g.guest_id " +
                      "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                      "WHERE r.status = 'BOOKED' " +
                      "ORDER BY r.check_in_date ASC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RecentReservation res = new RecentReservation();
                res.setReservationNumber(rs.getString("reservation_number"));
                res.setGuestName(rs.getString("guest_name"));
                res.setRoomType(rs.getString("type_name"));
                res.setCheckInDate(rs.getString("check_in_date"));
                res.setCheckOutDate(rs.getString("check_out_date"));
                res.setStatus(rs.getString("status"));
                res.setTotalAmount(rs.getDouble("total_amount"));
                reservations.add(res);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reservations;
    }
}