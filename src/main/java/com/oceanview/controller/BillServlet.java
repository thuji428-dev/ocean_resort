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
import java.time.LocalDate;

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
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("print".equals(action)) {
            printBill(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/reservation");
        }
    }
    
    private void printBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🖨️🖨️🖨️ EXECUTING printBill() 🖨️🖨️🖨️");
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reservation?error=invalid_id");
            return;
        }
        
        try {
            int reservationId = Integer.parseInt(idParam);
            
            // Get reservation details
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            
            if (reservation == null) {
                response.sendRedirect(request.getContextPath() + "/reservation?error=not_found");
                return;
            }
            
            System.out.println("========== BILL CALCULATION DEBUG ==========");
            System.out.println("Reservation ID: " + reservationId);
            System.out.println("Reservation #: " + reservation.getReservationNumber());
            System.out.println("Current Status: " + reservation.getStatus());
            System.out.println("Check-in Date: " + reservation.getCheckInDate());
            System.out.println("Planned Check-out: " + reservation.getCheckOutDate());
            System.out.println("Actual Check-out (before): " + reservation.getActualCheckoutDate());
            System.out.println("==========================================");
            
            // Check if bill already exists
            Bill bill = billDAO.getBillByReservationId(reservationId);
            
            if (bill == null) {
                // STEP 1: If this is a CHECKED-IN reservation, set actual checkout to TODAY
                LocalDate today = LocalDate.now();
                
                if ("CHECKED-IN".equals(reservation.getStatus())) {
                    System.out.println("🔄 CHECKED-IN reservation detected - auto-updating checkout to today");
                    
                    // Create an updated reservation object
                    Reservation updatedRes = new Reservation();
                    updatedRes.setReservationId(reservation.getReservationId());
                    updatedRes.setReservationNumber(reservation.getReservationNumber());
                    updatedRes.setGuestId(reservation.getGuestId());
                    updatedRes.setRoomTypeId(reservation.getRoomTypeId());
                    updatedRes.setCheckInDate(reservation.getCheckInDate());
                    updatedRes.setCheckOutDate(reservation.getCheckOutDate());
                    updatedRes.setActualCheckoutDate(today);  // Set actual checkout to TODAY
                    updatedRes.setStatus("CHECKED-OUT");
                    
                    // Update in database
                    boolean updated = reservationDAO.updateReservation(updatedRes);
                    System.out.println("Reservation update: " + (updated ? "SUCCESS" : "FAILED"));
                    
                    if (updated) {
                        // Refresh reservation data
                        reservation = reservationDAO.getReservationById(reservationId);
                    }
                }
                
                // STEP 2: Calculate nights based on ACTUAL checkout date
                int nights = 0;
                double amount = 0;
                
                if (reservation.getActualCheckoutDate() != null) {
                    // Use actual checkout date for calculation
                    nights = reservation.getActualNights();
                    amount = reservation.getActualAmount();
                    System.out.println("✅ Using ACTUAL checkout date: " + reservation.getActualCheckoutDate());
                } else {
                    // Fallback to planned dates (should not happen for CHECKED-OUT)
                    nights = reservation.getTotalNights();
                    amount = reservation.getTotalAmount();
                    System.out.println("⚠️ Using PLANNED checkout date (fallback)");
                }
                
                System.out.println("Calculated Nights: " + nights);
                System.out.println("Calculated Amount: LKR " + amount);
                
                // STEP 3: Generate bill
                boolean generated = billDAO.generateBill(reservationId, nights, amount);
                System.out.println("Bill generated: " + generated);
                
                if (generated) {
                    // Get the newly created bill
                    bill = billDAO.getBillByReservationId(reservationId);
                    System.out.println("Bill ID: " + bill.getBillId());
                    
                    // Ensure status is CHECKED-OUT
                    if (!"CHECKED-OUT".equals(reservation.getStatus())) {
                        reservationDAO.updateStatus(reservationId, "CHECKED-OUT");
                        reservation = reservationDAO.getReservationById(reservationId);
                    }
                    
                } else {
                    System.out.println("❌ Failed to generate bill");
                    response.sendRedirect(request.getContextPath() + "/reservation?error=bill_failed");
                    return;
                }
            } else {
                System.out.println("📋 Bill already exists with ID: " + bill.getBillId());
                System.out.println("Bill nights: " + bill.getTotalNights());
                System.out.println("Bill amount: " + bill.getTotalAmount());
            }
            
            System.out.println("========== FINAL STATE ==========");
            System.out.println("Final Status: " + reservation.getStatus());
            System.out.println("Final Actual Checkout: " + reservation.getActualCheckoutDate());
            System.out.println("Final Nights in Bill: " + (bill != null ? bill.getTotalNights() : "N/A"));
            System.out.println("==================================");
            
            request.setAttribute("reservation", reservation);
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("/jsp/printBill.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?error=bill_error");
        }
    }
}