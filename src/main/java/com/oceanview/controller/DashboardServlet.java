package com.oceanview.controller;

import com.oceanview.dao.DashboardDAO;
import com.oceanview.model.DashboardStats;
import com.oceanview.model.RecentReservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // IMPORTANT: Add back this login check!
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        try {
            // Get stats using DashboardDAO
            DashboardDAO dao = new DashboardDAO();
            DashboardStats stats = dao.getDashboardStats();
            List<RecentReservation> recentReservations = dao.getRecentReservations(5);
            
            // Set attributes
            request.setAttribute("stats", stats);
            request.setAttribute("recentReservations", recentReservations);
            request.setAttribute("currentDate", new SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new Date()));
            
            // Forward to JSP
            request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}