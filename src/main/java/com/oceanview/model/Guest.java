package com.oceanview.model;

public class Guest {
    private int guestId;
    private String guestName;
    private String address;
    private String contactNumber;
    
    public Guest() {}
    
    public Guest(String guestName, String address, String contactNumber) {
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
    }
    
    public Guest(int guestId, String guestName, String address, String contactNumber) {
        this.guestId = guestId;
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
    }
    
    // Getters and Setters
    public int getGuestId() {
        return guestId;
    }
    
    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }
    
    public String getGuestName() {
        return guestName;
    }
    
    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getContactNumber() {
        return contactNumber;
    }
    
    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
    
    @Override
    public String toString() {
        return "Guest{guestId=" + guestId + ", guestName='" + guestName + "', contact='" + contactNumber + "'}";
    }
}