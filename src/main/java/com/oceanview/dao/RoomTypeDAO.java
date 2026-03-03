package com.oceanview.dao;

import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {
    
    // Add new room type
    public boolean addRoomType(RoomType roomType) {
        String sql = "INSERT INTO room_type (type_name, price_per_night) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, roomType.getTypeName());
            pstmt.setDouble(2, roomType.getPricePerNight());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all room types
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_type ORDER BY room_type_id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("room_type_id"));
                roomType.setTypeName(rs.getString("type_name"));
                roomType.setPricePerNight(rs.getDouble("price_per_night"));
                roomTypes.add(roomType);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return roomTypes;
    }
 // Search by price range
    public List<RoomType> searchByPriceRange(Double minPrice, Double maxPrice) {
        List<RoomType> roomTypes = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM room_type WHERE 1=1");
        
        if (minPrice != null) {
            sql.append(" AND price_per_night >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price_per_night <= ?");
        }
        sql.append(" ORDER BY price_per_night");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (minPrice != null) {
                pstmt.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                pstmt.setDouble(paramIndex, maxPrice);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
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
    
    // Search by name (case insensitive, partial match)
    public List<RoomType> searchByName(String name) {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_type WHERE LOWER(type_name) LIKE LOWER(?) ORDER BY type_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("room_type_id"));
                roomType.setTypeName(rs.getString("type_name"));
                roomType.setPricePerNight(rs.getDouble("price_per_night"));
                roomTypes.add(roomType);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return roomTypes;
    }
    
 // Check if room type exists by name
    public boolean isRoomTypeExists(String name) {
        String sql = "SELECT COUNT(*) FROM room_type WHERE LOWER(type_name) = LOWER(?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, name.trim());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Check if room type exists excluding a specific ID (for edit form)
    public boolean isRoomTypeExistsExcludingId(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM room_type WHERE LOWER(type_name) = LOWER(?) AND room_type_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, name.trim());
            pstmt.setInt(2, excludeId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    
    // Search by price (exact match or range)
    public List<RoomType> searchByPrice(double price) {
        List<RoomType> roomTypes = new ArrayList<>();
        // Allow price within ±1000 range for flexibility
        String sql = "SELECT * FROM room_type WHERE price_per_night BETWEEN ? AND ? ORDER BY price_per_night";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, price - 1000);
            pstmt.setDouble(2, price + 1000);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("room_type_id"));
                roomType.setTypeName(rs.getString("type_name"));
                roomType.setPricePerNight(rs.getDouble("price_per_night"));
                roomTypes.add(roomType);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return roomTypes;
    }
    
    // Get room type by ID
    public RoomType getRoomTypeById(int id) {
        String sql = "SELECT * FROM room_type WHERE room_type_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeId(rs.getInt("room_type_id"));
                roomType.setTypeName(rs.getString("type_name"));
                roomType.setPricePerNight(rs.getDouble("price_per_night"));
                return roomType;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Update room type
    public boolean updateRoomType(RoomType roomType) {
        String sql = "UPDATE room_type SET type_name = ?, price_per_night = ? WHERE room_type_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, roomType.getTypeName());
            pstmt.setDouble(2, roomType.getPricePerNight());
            pstmt.setInt(3, roomType.getRoomTypeId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete room type
    public boolean deleteRoomType(int id) {
        String sql = "DELETE FROM room_type WHERE room_type_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}