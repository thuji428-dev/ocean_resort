package com.oceanview.model;

public class RoomType {
    private int roomTypeId;
    private String typeName;
    private double pricePerNight;
    
    public RoomType() {}
    
    public RoomType(String typeName, double pricePerNight) {
        this.typeName = typeName;
        this.pricePerNight = pricePerNight;
    }
    
    public RoomType(int roomTypeId, String typeName, double pricePerNight) {
        this.roomTypeId = roomTypeId;
        this.typeName = typeName;
        this.pricePerNight = pricePerNight;
    }
    
    // Getters and Setters
    public int getRoomTypeId() {
        return roomTypeId;
    }
    
    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }
    
    public String getTypeName() {
        return typeName;
    }
    
    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    
    public double getPricePerNight() {
        return pricePerNight;
    }
    
    public void setPricePerNight(double pricePerNight) {
        this.pricePerNight = pricePerNight;
    }
}