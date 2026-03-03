package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.BillDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.RoomType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private GuestDAO guestDAO;
    private RoomTypeDAO roomTypeDAO;
    private BillDAO billDAO;
    
    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
        guestDAO = new GuestDAO();
        roomTypeDAO = new RoomTypeDAO();
        billDAO = new BillDAO();
        System.out.println("✅✅✅ ReservationServlet INITIALIZED ✅✅✅");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📥📥📥 ReservationServlet doGet CALLED 📥📥📥");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String statusFilter = request.getParameter("statusFilter");
        String searchTerm = request.getParameter("searchTerm");
        
        System.out.println("Action: " + action);
        System.out.println("Status Filter: " + statusFilter);
        System.out.println("Search Term: " + searchTerm);
        
        if ("search".equals(action)) {
            searchReservations(request, response);
        } else if ("addForm".equals(action)) {
            showAddForm(request, response);
        } else if ("editForm".equals(action)) {
            showEditForm(request, response);
        } else if ("view".equals(action)) {
            viewReservation(request, response);
        } else if ("delete".equals(action)) {
            deleteReservation(request, response);
        } else if ("stats".equals(action)) {
            getStats(request, response);
        } else {
            listReservations(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📥📥📥 ReservationServlet doPost CALLED 📥📥📥");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("Post Action: " + action);
        
        if ("add".equals(action)) {
            addReservation(request, response);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📝📝📝 EXECUTING showAddForm() 📝📝📝");
        
        List<Guest> guests = guestDAO.getAllGuests();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        
        request.setAttribute("guests", guests);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("today", LocalDate.now().toString());
        request.setAttribute("tomorrow", LocalDate.now().plusDays(1).toString());
        
        request.getRequestDispatcher("/jsp/addReservation.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📝📝📝 EXECUTING showEditForm() 📝📝📝");
        
        int id = Integer.parseInt(request.getParameter("id"));
        Reservation reservation = reservationDAO.getReservationById(id);
        
        if (reservation == null) {
            response.sendRedirect(request.getContextPath() + "/reservation?error=not_found");
            return;
        }
        
        // Check if error parameter exists
        if (request.getParameter("error") != null) {
            String error = request.getParameter("error");
            switch (error) {
                case "cannot_change_checkin":
                    request.setAttribute("error", "❌ Cannot change check-in date for checked-in guests!");
                    break;
                case "invalid_dates":
                    request.setAttribute("error", "❌ Check-out date must be after check-in date!");
                    break;
                case "update_failed":
                    request.setAttribute("error", "❌ Failed to update reservation. Please try again.");
                    break;
            }
        }
        
        List<Guest> guests = guestDAO.getAllGuests();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        
        request.setAttribute("reservation", reservation);
        request.setAttribute("guests", guests);
        request.setAttribute("roomTypes", roomTypes);
        
        request.getRequestDispatcher("/jsp/editReservation.jsp").forward(request, response);
    }
    
    private void addReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("➕➕➕ EXECUTING addReservation() ➕➕➕");
        
        try {
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"));
            LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"));
            
            System.out.println("Guest ID: " + guestId);
            System.out.println("Room Type ID: " + roomTypeId);
            System.out.println("Check-in: " + checkInDate);
            System.out.println("Check-out: " + checkOutDate);
            
            // Validate dates
            if (checkInDate.isBefore(LocalDate.now())) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=addForm&error=past_date");
                return;
            }
            
            if (!checkOutDate.isAfter(checkInDate)) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=addForm&error=invalid_dates");
                return;
            }
            
            Reservation reservation = new Reservation();
            reservation.setGuestId(guestId);
            reservation.setRoomTypeId(roomTypeId);
            reservation.setCheckInDate(checkInDate);
            reservation.setCheckOutDate(checkOutDate);
            
            boolean added = reservationDAO.addReservation(reservation);
            
            if (added) {
                response.sendRedirect(request.getContextPath() + "/reservation?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/reservation?action=addForm&error=add_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?action=addForm&error=invalid_input");
        }
    }
    
    private void updateReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("🔄🔄🔄 EXECUTING updateReservation() 🔄🔄🔄");
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"));
            LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"));
            
            // Get original reservation to check status
            Reservation originalRes = reservationDAO.getReservationById(id);
            
            if (originalRes == null) {
                response.sendRedirect(request.getContextPath() + "/reservation?error=not_found");
                return;
            }
            
            // VALIDATION 1: Cannot edit checked-out reservations
            if ("CHECKED-OUT".equals(originalRes.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/reservation?error=cannot_edit_checkedout");
                return;
            }
            
            // VALIDATION 2: Cannot change check-in date for CHECKED-IN reservations
            if ("CHECKED-IN".equals(originalRes.getStatus()) && 
                !checkInDate.equals(originalRes.getCheckInDate())) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=editForm&id=" + id + "&error=cannot_change_checkin");
                return;
            }
            
            // VALIDATION 3: Check-out must be after check-in
            if (!checkOutDate.isAfter(checkInDate)) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=editForm&id=" + id + "&error=invalid_dates");
                return;
            }
            
            // Get actual checkout date if provided
            String actualCheckoutStr = request.getParameter("actualCheckoutDate");
            LocalDate actualCheckoutDate = null;
            String status = request.getParameter("status");
            
            if (actualCheckoutStr != null && !actualCheckoutStr.isEmpty()) {
                actualCheckoutDate = LocalDate.parse(actualCheckoutStr);
                // If actual checkout is provided and it's before planned checkout, status becomes CHECKED-OUT
                if (actualCheckoutDate.isBefore(checkOutDate)) {
                    status = "CHECKED-OUT";
                }
            }
            
            // Create updated reservation object
            Reservation reservation = new Reservation();
            reservation.setReservationId(id);
            reservation.setReservationNumber(originalRes.getReservationNumber());
            reservation.setGuestId(guestId);
            reservation.setRoomTypeId(roomTypeId);
            reservation.setCheckInDate(checkInDate);
            reservation.setCheckOutDate(checkOutDate);
            reservation.setActualCheckoutDate(actualCheckoutDate);
            reservation.setStatus(status);
            
            System.out.println("Updating reservation: " + id);
            System.out.println("New status: " + status);
            System.out.println("Actual checkout: " + actualCheckoutDate);
            
            boolean updated = reservationDAO.updateReservation(reservation);
            
            if (updated) {
                System.out.println("✅ Reservation updated successfully");
                response.sendRedirect(request.getContextPath() + "/reservation?success=updated");
            } else {
                System.out.println("❌ Failed to update reservation");
                response.sendRedirect(request.getContextPath() + "/reservation?action=editForm&id=" + id + "&error=update_failed");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Exception in updateReservation: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation?error=invalid_input");
        }
    }
    
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("🗑️🗑️🗑️ EXECUTING deleteReservation() 🗑️🗑️🗑️");
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (reservationDAO.deleteReservation(id)) {
            response.sendRedirect(request.getContextPath() + "/reservation?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/reservation?error=delete_failed");
        }
    }
    
    private void searchReservations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔍🔍🔍 EXECUTING searchReservations() 🔍🔍🔍");
        
        String searchTerm = request.getParameter("searchTerm");
        String statusFilter = request.getParameter("statusFilter");
        
        System.out.println("Search Term: " + searchTerm);
        System.out.println("Status Filter: " + statusFilter);
        
        List<Reservation> reservations;
        
        // If both search term and status filter are provided
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) && 
            (statusFilter != null && !"ALL".equals(statusFilter))) {
            
            reservations = reservationDAO.searchByTermAndStatus(searchTerm, statusFilter);
        
        // If only status filter is provided
        } else if (statusFilter != null && !"ALL".equals(statusFilter)) {
            reservations = reservationDAO.getReservationsByStatus(statusFilter);
        
        // If only search term is provided
        } else if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            reservations = reservationDAO.searchReservations(searchTerm);
        
        // No filters - get all
        } else {
            reservations = reservationDAO.getAllReservations();
        }
        
        // Set hasBill flag for each reservation
        for (Reservation r : reservations) {
            boolean hasBill = billDAO.hasBill(r.getReservationId());
            r.setHasBill(hasBill);
        }
        
        System.out.println("Search results: " + (reservations != null ? reservations.size() : 0));
        
        request.setAttribute("reservations", reservations);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        
        request.getRequestDispatcher("/jsp/listReservations.jsp").forward(request, response);
    }
    
    private void viewReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("👁️👁️👁️ EXECUTING viewReservation() 👁️👁️👁️");
        
        int id = Integer.parseInt(request.getParameter("id"));
        Reservation reservation = reservationDAO.getReservationById(id);
        
        request.setAttribute("reservation", reservation);
        request.getRequestDispatcher("/jsp/viewReservation.jsp").forward(request, response);
    }
    
    private void listReservations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📋📋📋 EXECUTING listReservations() 📋📋📋");
        
        List<Reservation> reservations = reservationDAO.getAllReservations();
        System.out.println("Reservations loaded: " + (reservations != null ? reservations.size() : 0));
        
        // Set hasBill flag for each reservation
        for (Reservation r : reservations) {
            boolean hasBill = billDAO.hasBill(r.getReservationId());
            r.setHasBill(hasBill);
        }
        
        request.setAttribute("reservations", reservations);
        
        // Handle success messages
        if (request.getParameter("success") != null) {
            String success = request.getParameter("success");
            switch (success) {
                case "added":
                    request.setAttribute("message", "✅ Reservation added successfully!");
                    break;
                case "updated":
                    request.setAttribute("message", "✅ Reservation updated successfully!");
                    break;
                case "deleted":
                    request.setAttribute("message", "✅ Reservation deleted successfully!");
                    break;
            }
        }
        
        // Handle error messages
        if (request.getParameter("error") != null) {
            String error = request.getParameter("error");
            switch (error) {
                case "delete_failed":
                    request.setAttribute("error", "❌ Cannot delete reservation. It may have a bill or is not in BOOKED status.");
                    break;
                case "not_found":
                    request.setAttribute("error", "❌ Reservation not found.");
                    break;
                case "cannot_edit_checkedout":
                    request.setAttribute("error", "❌ Cannot edit checked-out reservations!");
                    break;
                default:
                    request.setAttribute("error", "❌ An error occurred. Please try again.");
                    break;
            }
        }
        
        request.getRequestDispatcher("/jsp/listReservations.jsp").forward(request, response);
    }
    
    private void getStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        List<Reservation> reservations = reservationDAO.getAllReservations();
        
        long total = reservations.size();
        long booked = reservations.stream().filter(r -> "BOOKED".equals(r.getStatus())).count();
        long checkedIn = reservations.stream().filter(r -> "CHECKED-IN".equals(r.getStatus())).count();
        long checkedOut = reservations.stream().filter(r -> "CHECKED-OUT".equals(r.getStatus())).count();
        
        String json = String.format(
            "{\"total\":%d, \"booked\":%d, \"checkedIn\":%d, \"checkedOut\":%d}",
            total, booked, checkedIn, checkedOut
        );
        
        response.setContentType("application/json");
        response.getWriter().print(json);
    }
}