package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ReservationDAO {
    
    // Generate unique reservation number
    private String generateReservationNumber() {
        String year = String.valueOf(LocalDate.now().getYear());
        String month = String.format("%02d", LocalDate.now().getMonthValue());
        String day = String.format("%02d", LocalDate.now().getDayOfMonth());
        String random = UUID.randomUUID().toString().substring(0, 4).toUpperCase();
        
        return "RES" + year + month + day + "-" + random;
    }
    
    // Determine status based on dates
    private String determineStatus(LocalDate checkIn, LocalDate checkOut) {
        LocalDate today = LocalDate.now();
        
        if (checkIn.equals(today)) {
            return "CHECKED-IN";
        } else if (checkIn.isAfter(today)) {
            return "BOOKED";
        } else if (checkIn.isBefore(today) && checkOut.isAfter(today)) {
            return "CHECKED-IN";
        } else if (checkOut.isBefore(today) || checkOut.equals(today)) {
            return "CHECKED-OUT";
        }
        return "BOOKED";
    }
    
    // Add new reservation
    public boolean addReservation(Reservation reservation) {
        String sql = "INSERT INTO reservation (reservation_number, guest_id, room_type_id, " +
                    "check_in_date, check_out_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        reservation.setReservationNumber(generateReservationNumber());
        reservation.setStatus(determineStatus(
            reservation.getCheckInDate(), 
            reservation.getCheckOutDate()
        ));
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, reservation.getReservationNumber());
            pstmt.setInt(2, reservation.getGuestId());
            pstmt.setInt(3, reservation.getRoomTypeId());
            pstmt.setDate(4, Date.valueOf(reservation.getCheckInDate()));
            pstmt.setDate(5, Date.valueOf(reservation.getCheckOutDate()));
            pstmt.setString(6, reservation.getStatus());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all reservations with bill information
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.guest_name, g.contact_number, rt.type_name, rt.price_per_night, " +
                    "b.bill_id, b.total_nights as bill_nights, b.total_amount as bill_amount, " +
                    "b.generated_date as bill_date " +
                    "FROM reservation r " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "LEFT JOIN bill b ON r.reservation_id = b.reservation_id " +
                    "ORDER BY r.check_in_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservationWithBill(rs);
                reservations.add(res);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reservations;
    }
    
    // Get reservation by ID with bill information
    public Reservation getReservationById(int id) {
        String sql = "SELECT r.*, g.guest_name, g.contact_number, rt.type_name, rt.price_per_night, " +
                    "b.bill_id, b.total_nights as bill_nights, b.total_amount as bill_amount, " +
                    "b.generated_date as bill_date " +
                    "FROM reservation r " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "LEFT JOIN bill b ON r.reservation_id = b.reservation_id " +
                    "WHERE r.reservation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReservationWithBill(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Search reservations by keyword with bill information
    public List<Reservation> searchReservations(String keyword) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.guest_name, g.contact_number, rt.type_name, rt.price_per_night, " +
                    "b.bill_id, b.total_nights as bill_nights, b.total_amount as bill_amount, " +
                    "b.generated_date as bill_date " +
                    "FROM reservation r " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "LEFT JOIN bill b ON r.reservation_id = b.reservation_id " +
                    "WHERE LOWER(g.guest_name) LIKE LOWER(?) " +
                    "OR g.contact_number LIKE ? " +
                    "OR r.reservation_number LIKE ? " +
                    "OR r.status LIKE ? " +
                    "ORDER BY r.check_in_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservationWithBill(rs);
                reservations.add(res);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reservations;
    }
    
    // Get reservations by status with bill information
    public List<Reservation> getReservationsByStatus(String status) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.guest_name, g.contact_number, rt.type_name, rt.price_per_night, " +
                    "b.bill_id, b.total_nights as bill_nights, b.total_amount as bill_amount, " +
                    "b.generated_date as bill_date " +
                    "FROM reservation r " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "LEFT JOIN bill b ON r.reservation_id = b.reservation_id " +
                    "WHERE r.status = ? " +
                    "ORDER BY r.check_in_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservationWithBill(rs);
                reservations.add(res);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reservations;
    }

    // Search by term AND status with bill information
    public List<Reservation> searchByTermAndStatus(String keyword, String status) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, g.guest_name, g.contact_number, rt.type_name, rt.price_per_night, " +
                    "b.bill_id, b.total_nights as bill_nights, b.total_amount as bill_amount, " +
                    "b.generated_date as bill_date " +
                    "FROM reservation r " +
                    "JOIN guest g ON r.guest_id = g.guest_id " +
                    "JOIN room_type rt ON r.room_type_id = rt.room_type_id " +
                    "LEFT JOIN bill b ON r.reservation_id = b.reservation_id " +
                    "WHERE (LOWER(g.guest_name) LIKE LOWER(?) " +
                    "OR g.contact_number LIKE ? " +
                    "OR r.reservation_number LIKE ?) " +
                    "AND r.status = ? " +
                    "ORDER BY r.check_in_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, status);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Reservation res = mapResultSetToReservationWithBill(rs);
                reservations.add(res);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reservations;
    }
    
    // Update reservation (for early checkout)
    public boolean updateReservation(Reservation reservation) {
        String sql = "UPDATE reservation SET guest_id = ?, room_type_id = ?, " +
                    "check_in_date = ?, check_out_date = ?, actual_checkout_date = ?, " +
                    "status = ? WHERE reservation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reservation.getGuestId());
            pstmt.setInt(2, reservation.getRoomTypeId());
            pstmt.setDate(3, Date.valueOf(reservation.getCheckInDate()));
            pstmt.setDate(4, Date.valueOf(reservation.getCheckOutDate()));
            
            if (reservation.getActualCheckoutDate() != null) {
                pstmt.setDate(5, Date.valueOf(reservation.getActualCheckoutDate()));
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            
            pstmt.setString(6, reservation.getStatus());
            pstmt.setInt(7, reservation.getReservationId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update reservation status
    public boolean updateStatus(int reservationId, String status) {
        String sql;
        if ("CHECKED-OUT".equals(status)) {
            sql = "UPDATE reservation SET status = ?, actual_checkout_date = CURDATE() WHERE reservation_id = ?";
        } else {
            sql = "UPDATE reservation SET status = ? WHERE reservation_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, reservationId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete reservation (only if BOOKED)
    public boolean deleteReservation(int reservationId) {
        // First check if reservation has a bill
        String checkBillSql = "SELECT COUNT(*) FROM bill WHERE reservation_id = ?";
        String deleteSql = "DELETE FROM reservation WHERE reservation_id = ? AND status = 'BOOKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkBillSql)) {
            
            checkStmt.setInt(1, reservationId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Has bill - cannot delete
            }
            
            // No bill - safe to delete
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, reservationId);
                int result = deleteStmt.executeUpdate();
                return result > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // FIXED: Helper method to map ResultSet to Reservation object with bill information
    private Reservation mapResultSetToReservationWithBill(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        
        // Reservation fields
        res.setReservationId(rs.getInt("reservation_id"));
        res.setReservationNumber(rs.getString("reservation_number"));
        res.setGuestId(rs.getInt("guest_id"));
        res.setGuestName(rs.getString("guest_name"));
        res.setContactNumber(rs.getString("contact_number"));
        res.setRoomTypeId(rs.getInt("room_type_id"));
        res.setRoomTypeName(rs.getString("type_name"));
        res.setPricePerNight(rs.getDouble("price_per_night"));
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        
        if (rs.getDate("actual_checkout_date") != null) {
            res.setActualCheckoutDate(rs.getDate("actual_checkout_date").toLocalDate());
        }
        
        res.setStatus(rs.getString("status"));
        
        // Bill fields - FIXED: Actually set the values in the model
        try {
            int billId = rs.getInt("bill_id");
            if (!rs.wasNull()) {
                res.setBillId(billId);
                res.setBillNights(rs.getInt("bill_nights"));
                res.setBillAmount(rs.getDouble("bill_amount"));
                res.setHasBill(true);
            } else {
                res.setHasBill(false);
                res.setBillId(0);
                res.setBillNights(0);
                res.setBillAmount(0.0);
            }
        } catch (SQLException e) {
            res.setHasBill(false);
            res.setBillId(0);
            res.setBillNights(0);
            res.setBillAmount(0.0);
        }
        
        return res;
    }
    
    // Keep original mapper for backward compatibility
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setReservationNumber(rs.getString("reservation_number"));
        res.setGuestId(rs.getInt("guest_id"));
        res.setGuestName(rs.getString("guest_name"));
        res.setContactNumber(rs.getString("contact_number"));
        res.setRoomTypeId(rs.getInt("room_type_id"));
        res.setRoomTypeName(rs.getString("type_name"));
        res.setPricePerNight(rs.getDouble("price_per_night"));
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        
        if (rs.getDate("actual_checkout_date") != null) {
            res.setActualCheckoutDate(rs.getDate("actual_checkout_date").toLocalDate());
        }
        
        res.setStatus(rs.getString("status"));
        return res;
    }
    
    // Get all guests for dropdown
    public List<Guest> getAllGuests() {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guest ORDER BY guest_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setGuestName(rs.getString("guest_name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNumber(rs.getString("contact_number"));
                guests.add(guest);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return guests;
    }
    
    // Get all room types for dropdown
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_type ORDER BY price_per_night";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setPricePerNight(rs.getDouble("price_per_night"));
                roomTypes.add(rt);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return roomTypes;
    }
    
    // Check if reservation has bill
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
}