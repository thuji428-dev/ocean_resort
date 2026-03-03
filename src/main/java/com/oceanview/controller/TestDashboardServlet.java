package com.oceanview.controller;

import com.oceanview.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/test-dashboard")
public class TestDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Create session if not exists
        HttpSession session = request.getSession(true);
        session.setAttribute("adminId", 1);
        session.setAttribute("adminName", "Test Admin");
        
        // Create test stats manually
        DashboardStats stats = new DashboardStats();
        stats.setTotalRooms(10);
        stats.setOccupiedRooms(5);
        stats.setActiveBookings(8);
        stats.setTodayRevenue(25000.00);
        
        // Set attributes
        request.setAttribute("stats", stats);
        request.setAttribute("currentDate", "March 02, 2026");
        
        // Forward to JSP
        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}