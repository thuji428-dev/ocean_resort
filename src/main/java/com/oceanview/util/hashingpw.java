package com.oceanview.util;

public class hashingpw {
    public static void main(String[] args) {
        String hashed = PasswordUtil.hashPassword("admin123");
        System.out.println("Hashed Password: " + hashed);
    }
}