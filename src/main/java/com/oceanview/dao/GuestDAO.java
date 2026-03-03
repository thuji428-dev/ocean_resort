package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {
    
    // Add new guest
    public boolean addGuest(Guest guest) {
        String sql = "INSERT INTO guest (guest_name, address, contact_number) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, guest.getGuestName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNumber());
            
            int result = pstmt.executeUpdate();
            System.out.println("✅ Guest added: " + guest.getGuestName() + " - " + guest.getContactNumber());
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error adding guest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all guests
    public List<Guest> getAllGuests() {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guest ORDER BY guest_id DESC";
        
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
            System.out.println("📋 Retrieved " + guests.size() + " guests");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return guests;
    }
    
    // Search guests by name
    public List<Guest> searchByName(String name) {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guest WHERE LOWER(guest_name) LIKE LOWER(?) ORDER BY guest_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + name + "%";
            pstmt.setString(1, searchPattern);
            
            System.out.println("🔍 Searching guests by name: '" + name + "' with pattern: " + searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setGuestName(rs.getString("guest_name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNumber(rs.getString("contact_number"));
                guests.add(guest);
            }
            
            System.out.println("✅ Found " + guests.size() + " guests by name");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return guests;
    }
    
    // FIXED: Search guests by contact with better handling
    public List<Guest> searchByContact(String contact) {
        List<Guest> guests = new ArrayList<>();
        
        if (contact == null || contact.trim().isEmpty()) {
            System.out.println("⚠️ Empty contact search term");
            return getAllGuests();
        }
        
        // Remove any non-digit characters for better matching
        String cleanContact = contact.trim().replaceAll("[^0-9]", "");
        
        String sql = "SELECT * FROM guest WHERE contact_number LIKE ? OR REPLACE(contact_number, '-', '') LIKE ? ORDER BY guest_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + contact.trim() + "%";
            String cleanPattern = "%" + cleanContact + "%";
            
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, cleanPattern);
            
            System.out.println("🔍 Searching guests by contact:");
            System.out.println("   Original: '" + contact + "' → pattern: " + searchPattern);
            System.out.println("   Clean: '" + cleanContact + "' → pattern: " + cleanPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setGuestName(rs.getString("guest_name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNumber(rs.getString("contact_number"));
                guests.add(guest);
                
                System.out.println("   Found: " + guest.getGuestName() + " - " + guest.getContactNumber());
            }
            
            System.out.println("✅ Found " + guests.size() + " guests by contact");
            
        } catch (SQLException e) {
            System.out.println("❌ Error searching by contact: " + e.getMessage());
            e.printStackTrace();
        }
        
        return guests;
    }
    
    // Get guest by ID
    public Guest getGuestById(int id) {
        String sql = "SELECT * FROM guest WHERE guest_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setGuestName(rs.getString("guest_name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNumber(rs.getString("contact_number"));
                return guest;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Update guest
    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE guest SET guest_name = ?, address = ?, contact_number = ? WHERE guest_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, guest.getGuestName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNumber());
            pstmt.setInt(4, guest.getGuestId());
            
            int result = pstmt.executeUpdate();
            System.out.println("✅ Guest updated: " + guest.getGuestName());
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error updating guest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete guest
    public boolean deleteGuest(int id) {
        // First check if guest has any reservations
        String checkSql = "SELECT COUNT(*) FROM reservation WHERE guest_id = ?";
        String deleteSql = "DELETE FROM guest WHERE guest_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setInt(1, id);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("❌ Cannot delete guest ID " + id + " - has existing reservations");
                return false; // Guest has reservations - cannot delete
            }
            
            // No reservations - safe to delete
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, id);
                int result = deleteStmt.executeUpdate();
                System.out.println("✅ Guest deleted ID: " + id);
                return result > 0;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error deleting guest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if contact number already exists
    public boolean isContactExists(String contact) {
        String sql = "SELECT COUNT(*) FROM guest WHERE contact_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, contact);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                System.out.println("🔍 Contact " + contact + " exists: " + exists);
                return exists;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if contact exists excluding a specific ID (for edit)
    public boolean isContactExistsExcludingId(String contact, int excludeId) {
        String sql = "SELECT COUNT(*) FROM guest WHERE contact_number = ? AND guest_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, contact);
            pstmt.setInt(2, excludeId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                System.out.println("🔍 Contact " + contact + " exists (excluding ID " + excludeId + "): " + exists);
                return exists;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
}