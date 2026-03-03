package com.oceanview.controller;

import com.oceanview.dao.AdminDAO;
import com.oceanview.model.Admin;
import com.oceanview.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("===== LOGIN DEBUG START =====");
        System.out.println("Username: [" + username + "]");

        String hashedPassword = PasswordUtil.hashPassword(password);
        System.out.println("Generated Hash: [" + hashedPassword + "]");

        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login(username, hashedPassword);

        if (admin != null) {
            System.out.println("LOGIN SUCCESS - Admin ID: " + admin.getAdminId());
            
            HttpSession session = request.getSession();
            session.setAttribute("adminId", admin.getAdminId());
            session.setAttribute("adminName", admin.getUsername());
            session.setAttribute("admin", admin);
            
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            response.sendRedirect(request.getContextPath() + "/dashboard");
            
        } else {
            System.out.println("LOGIN FAILED");
            // Redirect with error parameter
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=invalid");
        }

        System.out.println("===== LOGIN DEBUG END =====");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=logout");
        } else {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        }
    }
}