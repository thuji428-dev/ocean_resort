package com.oceanview.model;

import java.time.LocalDate;

public class Bill {
    private int billId;
    private int reservationId;
    private int totalNights;
    private double totalAmount;
    private LocalDate generatedDate;
    
    // Additional fields for joined data
    private String reservationNumber;
    private String guestName;
    private String roomTypeName;
    
    public Bill() {}
    
    public Bill(int reservationId, int totalNights, double totalAmount) {
        this.reservationId = reservationId;
        this.totalNights = totalNights;
        this.totalAmount = totalAmount;
        this.generatedDate = LocalDate.now();
    }
    
    // Getters and Setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    
    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }
    
    public int getTotalNights() { return totalNights; }
    public void setTotalNights(int totalNights) { this.totalNights = totalNights; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public LocalDate getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(LocalDate generatedDate) { this.generatedDate = generatedDate; }
    
    // Additional getters and setters
    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }
    
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    
    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
}