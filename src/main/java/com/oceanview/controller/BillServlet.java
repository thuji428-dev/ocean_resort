package com.oceanview.controller;

import com.oceanview.dao.BillDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    private BillDAO billDAO;
    private ReservationDAO reservationDAO;
    
    @Override
    public void init() {
        billDAO = new BillDAO();
        reservationDAO = new ReservationDAO();
        System.out.println("✅✅✅ BillServlet INITIALIZED ✅✅✅");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📥📥📥 BillServlet doGet CALLED 📥📥📥");
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Query String: " + request.getQueryString());
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            System.out.println("❌ No session - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        System.out.println("Action parameter: '" + action + "'");
        System.out.println("ID parameter: '" + idParam + "'");
        
        if ("print".equals(action)) {
            printBill(request, response);
        } else {
            System.out.println("❌ Unknown action: " + action);
            response.sendRedirect(request.getContextPath() + "/reservation");
        }
    }
    
    private void printBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🖨️🖨️🖨️ EXECUTING printBill() 🖨️🖨️🖨️");
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            System.out.println("❌ No ID provided");
            response.sendRedirect(request.getContextPath() + "/reservation?error=invalid_id");
            return;
        }
        
        try {
            int reservationId = Integer.parseInt(idParam);
            System.out.println("Reservation ID: " + reservationId);
            
            // Get reservation details
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            
            if (reservation == null) {
                System.out.println("❌ Reservation not found for ID: " + reservationId);
                response.sendRedirect(request.getContextPath() + "/reservation?error=not_found");
                return;
            }
            
            System.out.println("Reservation found: " + reservation.getReservationNumber());
            System.out.println("Current status: " + reservation.getStatus());
            System.out.println("Actual checkout date: " + reservation.getActualCheckoutDate());
            
            // Check if bill exists
            Bill bill = billDAO.getBillByReservationId(reservationId);
            System.out.println("Bill exists: " + (bill != null));
            
            if (bill == null) {
                // Generate bill if it doesn't exist
                System.out.println("💰 Generating new bill...");
                int nights = reservation.getActualNights();
                double amount = reservation.getActualAmount();
                
                System.out.println("Nights: " + nights);
                System.out.println("Amount: LKR " + amount);
                
                boolean generated = billDAO.generateBill(reservationId, nights, amount);
                System.out.println("Bill generated: " + generated);
                
                if (generated) {
                    // Get the newly created bill
                    bill = billDAO.getBillByReservationId(reservationId);
                    System.out.println("Bill ID: " + bill.getBillId());
                    
                    // ALWAYS update reservation status to CHECKED-OUT
                    System.out.println("🔄 Updating reservation status to CHECKED-OUT...");
                    boolean statusUpdated = reservationDAO.updateStatus(reservationId, "CHECKED-OUT");
                    System.out.println("Status updated: " + statusUpdated);
                    
                    // Verify the update by fetching again
                    Reservation updatedReservation = reservationDAO.getReservationById(reservationId);
                    System.out.println("New status: " + updatedReservation.getStatus());
                    System.out.println("New actual checkout: " + updatedReservation.getActualCheckoutDate());
                    
                    // Use updated reservation for display
                    reservation = updatedReservation;
                    
                } else {
                    System.out.println("❌ Failed to generate bill");
                    response.sendRedirect(request.getContextPath() + "/reservation?error=bill_failed");
                    return;
                }
            } else {
                System.out.println("📋 Bill already exists with ID: " + bill.getBillId());
                
                // Even if bill exists, ensure status is CHECKED-OUT
                if (!"CHECKED-OUT".equals(reservation.getStatus())) {
                    System.out.println("🔄 Bill exists but status not CHECKED-OUT - updating...");
                    boolean statusUpdated = reservationDAO.updateStatus(reservationId, "CHECKED-OUT");
                    System.out.println("Status updated: " + statusUpdated);
                    
                    // Refresh reservation data
                    reservation = reservationDAO.getReservationById(reservationId);
                }
            }
            
            // Final check before forwarding
            System.out.println("Final reservation status: " + reservation.getStatus());
            System.out.println("Final actual checkout: " + reservation.getActualCheckoutDate());
            System.out.println("Forwarding to printBill.jsp");
            
            request.setAttribute("reservation", reservation);
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("/jsp/printBill.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid ID format: " + idParam);
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?error=invalid_id");
        } catch (Exception e) {
            System.out.println("❌ Exception in printBill: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?error=bill_error");
        }
    }
}