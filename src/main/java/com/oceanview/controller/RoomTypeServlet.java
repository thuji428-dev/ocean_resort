package com.oceanview.controller;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/room-type")
public class RoomTypeServlet extends HttpServlet {
    private RoomTypeDAO roomTypeDAO;
    
    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
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
            deleteRoomType(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("search".equals(action)) {
            searchRoomTypes(request, response);
        } else if ("checkName".equals(action)) {  // ADD THIS LINE
            checkRoomName(request, response);      // ADD THIS LINE
        } else {
            listRoomTypes(request, response);
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
            addRoomType(request, response);
        } else if ("update".equals(action)) {
            updateRoomType(request, response);
        }
    }
    
    // Method to check if room name exists (for AJAX calls)
    private void checkRoomName(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String name = request.getParameter("name");
        String excludeId = request.getParameter("excludeId"); // For edit form, exclude current ID
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        if (name == null || name.trim().isEmpty()) {
            out.print("{\"exists\": false, \"valid\": false, \"message\": \"Room name cannot be empty\"}");
            return;
        }
        
        boolean exists;
        if (excludeId != null && !excludeId.isEmpty()) {
            // Check if name exists excluding current room type (for edit form)
            exists = roomTypeDAO.isRoomTypeExistsExcludingId(name, Integer.parseInt(excludeId));
        } else {
            // Normal check for add form
            exists = roomTypeDAO.isRoomTypeExists(name);
        }
        
        if (exists) {
            out.print("{\"exists\": true, \"valid\": false, \"message\": \"❌ This room type already exists!\"}");
        } else {
            out.print("{\"exists\": false, \"valid\": true, \"message\": \"✅ Room type name is available\"}");
        }
    }
    
    private void addRoomType(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String typeName = request.getParameter("typeName");
        double pricePerNight = Double.parseDouble(request.getParameter("pricePerNight"));
        
        // Double-check if name already exists before adding
        if (roomTypeDAO.isRoomTypeExists(typeName)) {
            response.sendRedirect(request.getContextPath() + "/jsp/addRoomType.jsp?error=exists");
            return;
        }
        
        RoomType roomType = new RoomType(typeName, pricePerNight);
        
        if (roomTypeDAO.addRoomType(roomType)) {
            response.sendRedirect(request.getContextPath() + "/room-type?success=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/room-type?error=add");
        }
    }
    
    private void updateRoomType(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String typeName = request.getParameter("typeName");
        double pricePerNight = Double.parseDouble(request.getParameter("pricePerNight"));
        
        // Check if name exists for OTHER room types (excluding current one)
        if (roomTypeDAO.isRoomTypeExistsExcludingId(typeName, id)) {
            response.sendRedirect(request.getContextPath() + "/room-type?action=edit&id=" + id + "&error=exists");
            return;
        }
        
        RoomType roomType = new RoomType(id, typeName, pricePerNight);
        
        if (roomTypeDAO.updateRoomType(roomType)) {
            response.sendRedirect(request.getContextPath() + "/room-type?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/room-type?error=update");
        }
    }
    
    private void deleteRoomType(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (roomTypeDAO.deleteRoomType(id)) {
            response.sendRedirect(request.getContextPath() + "/room-type?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/room-type?error=delete");
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        RoomType roomType = roomTypeDAO.getRoomTypeById(id);
        
        // Check if there's an error parameter
        if (request.getParameter("error") != null) {
            request.setAttribute("error", "Room type name already exists! Please use a different name.");
        }
        
        request.setAttribute("roomType", roomType);
        request.getRequestDispatcher("/jsp/editRoomType.jsp").forward(request, response);
    }
    
    private void searchRoomTypes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchType = request.getParameter("searchType");
        List<RoomType> roomTypes;
        
        if ("name".equals(searchType)) {
            String searchTerm = request.getParameter("searchTerm");
            roomTypes = roomTypeDAO.searchByName(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("searchType", "name");
            
        } else if ("price".equals(searchType)) {
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            
            Double minPrice = null;
            Double maxPrice = null;
            
            try {
                if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                    minPrice = Double.parseDouble(minPriceStr);
                }
                if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                    maxPrice = Double.parseDouble(maxPriceStr);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Please enter valid numbers for price range");
                roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.setAttribute("searchType", "price");
                request.getRequestDispatcher("/jsp/listRoomTypes.jsp").forward(request, response);
                return;
            }
            
            roomTypes = roomTypeDAO.searchByPriceRange(minPrice, maxPrice);
            request.setAttribute("minPrice", minPriceStr);
            request.setAttribute("maxPrice", maxPriceStr);
            request.setAttribute("searchType", "price");
            
        } else {
            roomTypes = roomTypeDAO.getAllRoomTypes();
            request.setAttribute("searchType", "name");
        }
        
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/jsp/listRoomTypes.jsp").forward(request, response);
    }
    
    private void listRoomTypes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
        
        // Check for success/error messages
        if (request.getParameter("success") != null) {
            String success = request.getParameter("success");
            if ("added".equals(success)) {
                request.setAttribute("message", "Room type added successfully!");
            } else if ("updated".equals(success)) {
                request.setAttribute("message", "Room type updated successfully!");
            } else if ("deleted".equals(success)) {
                request.setAttribute("message", "Room type deleted successfully!");
            }
        } else if (request.getParameter("error") != null) {
            String error = request.getParameter("error");
            if ("add".equals(error)) {
                request.setAttribute("error", "Failed to add room type. Please try again.");
            } else if ("update".equals(error)) {
                request.setAttribute("error", "Failed to update room type. Please try again.");
            } else if ("delete".equals(error)) {
                request.setAttribute("error", "Failed to delete room type. It may be in use.");
            } else {
                request.setAttribute("error", "Operation failed. Please try again.");
            }
        }
        
        request.getRequestDispatcher("/jsp/listRoomTypes.jsp").forward(request, response);
    }
}