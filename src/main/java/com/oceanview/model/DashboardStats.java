package com.oceanview.model;

public class DashboardStats {
    private int totalRooms;
    private int occupiedRooms;
    private int availableRooms;
    private int totalGuests;
    private int activeBookings;
    private int checkInsToday;
    private int checkOutsToday;
    private double todayRevenue;
    private double monthlyRevenue;
    private double occupancyRate;
    private int pendingBills;
    
    public DashboardStats() {}
    
    // Getters and Setters
    public int getTotalRooms() {
        return totalRooms;
    }
    
    public void setTotalRooms(int totalRooms) {
        this.totalRooms = totalRooms;
    }
    
    public int getOccupiedRooms() {
        return occupiedRooms;
    }
    
    public void setOccupiedRooms(int occupiedRooms) {
        this.occupiedRooms = occupiedRooms;
    }
    
    public int getAvailableRooms() {
        return availableRooms;
    }
    
    public void setAvailableRooms(int availableRooms) {
        this.availableRooms = availableRooms;
    }
    
    public int getTotalGuests() {
        return totalGuests;
    }
    
    public void setTotalGuests(int totalGuests) {
        this.totalGuests = totalGuests;
    }
    
    public int getActiveBookings() {
        return activeBookings;
    }
    
    public void setActiveBookings(int activeBookings) {
        this.activeBookings = activeBookings;
    }
    
    public int getCheckInsToday() {
        return checkInsToday;
    }
    
    public void setCheckInsToday(int checkInsToday) {
        this.checkInsToday = checkInsToday;
    }
    
    public int getCheckOutsToday() {
        return checkOutsToday;
    }
    
    public void setCheckOutsToday(int checkOutsToday) {
        this.checkOutsToday = checkOutsToday;
    }
    
    public double getTodayRevenue() {
        return todayRevenue;
    }
    
    public void setTodayRevenue(double todayRevenue) {
        this.todayRevenue = todayRevenue;
    }
    
    public double getMonthlyRevenue() {
        return monthlyRevenue;
    }
    
    public void setMonthlyRevenue(double monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }
    
    public double getOccupancyRate() {
        return occupancyRate;
    }
    
    public void setOccupancyRate(double occupancyRate) {
        this.occupancyRate = occupancyRate;
    }
    
    public int getPendingBills() {
        return pendingBills;
    }
    
    public void setPendingBills(int pendingBills) {
        this.pendingBills = pendingBills;
    }
}