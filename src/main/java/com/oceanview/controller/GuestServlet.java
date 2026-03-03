package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/guest")
public class GuestServlet extends HttpServlet {
    private GuestDAO guestDAO;
    
    @Override
    public void init() {
        guestDAO = new GuestDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteGuest(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("search".equals(action)) {
            searchGuests(request, response);
        } else if ("checkContact".equals(action)) {
            checkContact(request, response);
        } else {
            listGuests(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addGuest(request, response);
        } else if ("update".equals(action)) {
            updateGuest(request, response);
        }
    }
    
    private void addGuest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String guestName = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        
        // Check if contact already exists
        if (guestDAO.isContactExists(contactNumber)) {
            response.sendRedirect(request.getContextPath() + "/jsp/addGuest.jsp?error=exists");
            return;
        }
        
        Guest guest = new Guest(guestName, address, contactNumber);
        
        if (guestDAO.addGuest(guest)) {
            response.sendRedirect(request.getContextPath() + "/guest?success=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/guest?error=add");
        }
    }
    
    private void updateGuest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String guestName = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        
        // Check if contact exists for OTHER guests
        if (guestDAO.isContactExistsExcludingId(contactNumber, id)) {
            response.sendRedirect(request.getContextPath() + "/guest?action=edit&id=" + id + "&error=exists");
            return;
        }
        
        Guest guest = new Guest(id, guestName, address, contactNumber);
        
        if (guestDAO.updateGuest(guest)) {
            response.sendRedirect(request.getContextPath() + "/guest?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/guest?error=update");
        }
    }
    
    private void deleteGuest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (guestDAO.deleteGuest(id)) {
            response.sendRedirect(request.getContextPath() + "/guest?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/guest?error=delete");
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Guest guest = guestDAO.getGuestById(id);
        
        if (request.getParameter("error") != null) {
            request.setAttribute("error", "Contact number already exists! Please use a different number.");
        }
        
        request.setAttribute("guest", guest);
        request.getRequestDispatcher("/jsp/editGuest.jsp").forward(request, response);
    }
    
    private void searchGuests(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("searchTerm");
        String searchType = request.getParameter("searchType");
        
        List<Guest> guests;
        
        if ("name".equals(searchType)) {
            guests = guestDAO.searchByName(searchTerm);
        } else if ("contact".equals(searchType)) {
            guests = guestDAO.searchByContact(searchTerm);
        } else {
            guests = guestDAO.getAllGuests();
        }
        
        request.setAttribute("guests", guests);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchType", searchType);
        request.getRequestDispatcher("/jsp/listGuests.jsp").forward(request, response);
    }
    
    private void listGuests(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Guest> guests = guestDAO.getAllGuests();
        request.setAttribute("guests", guests);
        
        if (request.getParameter("success") != null) {
            String success = request.getParameter("success");
            if ("added".equals(success)) {
                request.setAttribute("message", "Guest added successfully!");
            } else if ("updated".equals(success)) {
                request.setAttribute("message", "Guest updated successfully!");
            } else if ("deleted".equals(success)) {
                request.setAttribute("message", "Guest deleted successfully!");
            }
        } else if (request.getParameter("error") != null) {
            String error = request.getParameter("error");
            if ("add".equals(error)) {
                request.setAttribute("error", "Failed to add guest. Please try again.");
            } else if ("update".equals(error)) {
                request.setAttribute("error", "Failed to update guest. Please try again.");
            } else if ("delete".equals(error)) {
                request.setAttribute("error", "Cannot delete guest. They have existing reservations.");
            }
        }
        
        request.getRequestDispatcher("/jsp/listGuests.jsp").forward(request, response);
    }
    
    private void checkContact(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String contact = request.getParameter("contact");
        String excludeId = request.getParameter("excludeId");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        if (contact == null || contact.trim().isEmpty()) {
            out.print("{\"exists\": false, \"valid\": false, \"message\": \"Contact number cannot be empty\"}");
            return;
        }
        
        boolean exists;
        if (excludeId != null && !excludeId.isEmpty()) {
            exists = guestDAO.isContactExistsExcludingId(contact, Integer.parseInt(excludeId));
        } else {
            exists = guestDAO.isContactExists(contact);
        }
        
        if (exists) {
            out.print("{\"exists\": true, \"valid\": false, \"message\": \"❌ This contact number already exists!\"}");
        } else {
            out.print("{\"exists\": false, \"valid\": true, \"message\": \"✅ Contact number is available\"}");
        }
    }
}