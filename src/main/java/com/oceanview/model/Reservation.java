package com.oceanview.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Reservation {
    private int reservationId;
    private String reservationNumber;
    private int guestId;
    private int roomTypeId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private LocalDate actualCheckoutDate;
    private String status;
    
    // Additional fields for joined data (not in database)
    private String guestName;
    private String contactNumber;
    private String roomTypeName;
    private double pricePerNight;
    
    // Bill related fields
    private int billId;
    private int billNights;
    private double billAmount;
    private boolean hasBill;
    
    public Reservation() {}
    
    public Reservation(String reservationNumber, int guestId, int roomTypeId, 
                      LocalDate checkInDate, LocalDate checkOutDate, String status) {
        this.reservationNumber = reservationNumber;
        this.guestId = guestId;
        this.roomTypeId = roomTypeId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.status = status;
    }
    
    // Getters and Setters
    public int getReservationId() {
        return reservationId;
    }
    
    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }
    
    public String getReservationNumber() {
        return reservationNumber;
    }
    
    public void setReservationNumber(String reservationNumber) {
        this.reservationNumber = reservationNumber;
    }
    
    public int getGuestId() {
        return guestId;
    }
    
    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }
    
    public int getRoomTypeId() {
        return roomTypeId;
    }
    
    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }
    
    public LocalDate getCheckInDate() {
        return checkInDate;
    }
    
    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }
    
    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }
    
    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }
    
    public LocalDate getActualCheckoutDate() {
        return actualCheckoutDate;
    }
    
    public void setActualCheckoutDate(LocalDate actualCheckoutDate) {
        this.actualCheckoutDate = actualCheckoutDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    // Guest details
    public String getGuestName() {
        return guestName;
    }
    
    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }
    
    public String getContactNumber() {
        return contactNumber;
    }
    
    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
    
    // Room details
    public String getRoomTypeName() {
        return roomTypeName;
    }
    
    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }
    
    public double getPricePerNight() {
        return pricePerNight;
    }
    
    public void setPricePerNight(double pricePerNight) {
        this.pricePerNight = pricePerNight;
    }
    
    // Bill related getters/setters
    public int getBillId() { 
        return billId; 
    }
    
    public void setBillId(int billId) { 
        this.billId = billId; 
    }

    public int getBillNights() { 
        return billNights; 
    }
    
    public void setBillNights(int billNights) { 
        this.billNights = billNights; 
    }

    public double getBillAmount() { 
        return billAmount; 
    }
    
    public void setBillAmount(double billAmount) { 
        this.billAmount = billAmount; 
    }
    
    public boolean isHasBill() {
        return hasBill;
    }
    
    public void setHasBill(boolean hasBill) {
        this.hasBill = hasBill;
    }
    
    /**
     * Calculate planned total nights based on check-in and check-out dates
     * If same day, count as 1 night (though this shouldn't happen in booking)
     */
    public int getTotalNights() {
        if (checkInDate != null && checkOutDate != null) {
            long days = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            return days == 0 ? 1 : (int) days;
        }
        return 0;
    }
    
    /**
     * Calculate actual nights stayed based on actual checkout date
     * If actual checkout is same as check-in, count as 1 night
     * Example: check-in Mar 3, checkout Mar 3 = 1 night
     */
    public int getActualNights() {
        if (actualCheckoutDate != null) {
            long days = ChronoUnit.DAYS.between(checkInDate, actualCheckoutDate);
            // If same day checkout (days = 0), charge for 1 night
            return days == 0 ? 1 : (int) days;
        }
        return getTotalNights();
    }
    
    /**
     * Calculate planned total amount
     */
    public double getTotalAmount() {
        return getTotalNights() * pricePerNight;
    }
    
    /**
     * Calculate actual amount based on actual checkout
     */
    public double getActualAmount() {
        return getActualNights() * pricePerNight;
    }
    
    /**
     * Check if reservation can be edited (not checked out)
     */
    public boolean isEditable() {
        return !"CHECKED-OUT".equals(status);
    }
    
    /**
     * Check if bill can be generated
     */
    public boolean canGenerateBill() {
        return "CHECKED-OUT".equals(status) || actualCheckoutDate != null;
    }
    
    /**
     * Get display nights (use bill nights if available)
     */
    public int getDisplayNights() {
        if (hasBill && billNights > 0) {
            return billNights;
        }
        return getActualNights();
    }
    
    /**
     * Get display amount (use bill amount if available)
     */
    public double getDisplayAmount() {
        if (hasBill && billAmount > 0) {
            return billAmount;
        }
        return getActualAmount();
    }
    
    @Override
    public String toString() {
        return "Reservation{reservationNumber='" + reservationNumber + "', status='" + status + "'}";
    }
}