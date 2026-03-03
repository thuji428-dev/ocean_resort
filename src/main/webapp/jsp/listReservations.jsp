<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String statusFilter = (String) request.getAttribute("statusFilter");
    
    if (searchTerm == null) searchTerm = "";
    if (statusFilter == null) statusFilter = "ALL";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations - Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            display: flex;
            background: #f4f7fc;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding: 30px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar-header h2 {
            font-size: 24px;
            font-weight: 300;
            letter-spacing: 1px;
        }
        
        .sidebar-header h2 span {
            font-weight: 700;
            display: block;
            font-size: 18px;
            color: #ffd700;
            margin-top: 5px;
        }
        
        .admin-info {
            padding: 20px;
            background: rgba(255,255,255,0.1);
            margin: 15px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .admin-avatar {
            width: 45px;
            height: 45px;
            background: #ffd700;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1e3c72;
            font-size: 20px;
            font-weight: bold;
        }
        
        .admin-details h4 {
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .admin-details p {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .nav-menu {
            list-style: none;
            padding: 10px;
            margin-top: 10px;
        }
        
        .nav-item {
            margin-bottom: 5px;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s;
            gap: 12px;
        }
        
        .nav-link i {
            width: 20px;
            font-size: 18px;
        }
        
        .nav-link:hover {
            background: rgba(255,255,255,0.15);
            color: white;
            transform: translateX(5px);
        }
        
        .nav-link.active {
            background: #ffd700;
            color: #1e3c72;
            font-weight: 600;
        }
        
        .nav-link.active i {
            color: #1e3c72;
        }
        
        .logout-link {
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 20px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
            width: calc(100% - 280px);
            background: #f4f7fc;
            min-height: 100vh;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .header h2 {
            color: #1e3c72;
            font-size: 24px;
        }
        
        .btn-add {
            background: #2a5298;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }
        
        .btn-add:hover {
            background: #1e3c72;
        }
        
        .search-container {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .search-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 2;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            min-width: 250px;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .filter-select {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            min-width: 150px;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .search-btn {
            background: #2a5298;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .search-btn:hover {
            background: #1e3c72;
        }
        
        .reset-btn {
            background: #95a5a6;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .reset-btn:hover {
            background: #7f8c8d;
        }
        
        .message {
            background: #d4edda;
            color: #155724;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid #28a745;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid #dc3545;
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f8fafd;
            color: #1e3c72;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            font-size: 14px;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
            color: #34495e;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-BOOKED {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .status-CHECKED-IN {
            background: #e8f5e9;
            color: #388e3c;
        }
        
        .status-CHECKED-OUT {
            background: #ffebee;
            color: #c62828;
        }
        
        .bill-badge {
            background: #27ae60;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            margin-left: 5px;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s;
            min-width: 60px;
            justify-content: center;
        }
        
        .btn-edit {
            background: #f39c12;
            color: white;
        }
        
        .btn-delete {
            background: #e74c3c;
            color: white;
        }
        
        .btn-bill {
            background: #27ae60;
            color: white;
        }
        
        .btn-view {
            background: #2a5298;
            color: white;
        }
        
        .btn-edit:hover:not(.btn-disabled) {
            background: #e67e22;
            transform: translateY(-2px);
        }
        
        .btn-delete:hover:not(.btn-disabled) {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .btn-bill:hover:not(.btn-disabled) {
            background: #219a52;
            transform: translateY(-2px);
        }
        
        .btn-disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            opacity: 0.5;
            pointer-events: none;
        }
        
        .reference-number {
            font-family: monospace;
            font-weight: bold;
            color: #2a5298;
        }
        
        .no-data {
            text-align: center;
            padding: 50px;
            color: #7f8c8d;
        }
        
        .no-data i {
            font-size: 50px;
            color: #d0d0d0;
            margin-bottom: 15px;
        }
        
        .stats-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            background: white;
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            flex: 1;
            min-width: 150px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stat-item.active {
            border: 2px solid #2a5298;
            background: #e3f2fd;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #1e3c72;
        }
        
        .stat-label {
            font-size: 13px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 80px;
            }
            
            .sidebar-header h2 span,
            .admin-details,
            .nav-link span {
                display: none;
            }
            
            .main-content {
                margin-left: 80px;
            }
            
            .search-row {
                flex-direction: column;
            }
            
            .search-input, .filter-select, .search-btn, .reset-btn {
                width: 100%;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="includes/navbar.jsp">
        <jsp:param name="activePage" value="addReservation" />
    </jsp:include>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h2><i class="fas fa-calendar-alt"></i> Reservation Management</h2>
            <a href="${pageContext.request.contextPath}/reservation?action=addForm" class="btn-add">
                <i class="fas fa-plus"></i> New Reservation
            </a>
        </div>
        
        <!-- Stats Bar -->
        <div class="stats-bar">
            <div class="stat-item <%= "ALL".equals(statusFilter) ? "active" : "" %>" onclick="filterByStatus('ALL')">
                <div class="stat-value" id="totalCount"><%= reservations != null ? reservations.size() : 0 %></div>
                <div class="stat-label">Total Reservations</div>
            </div>
            <div class="stat-item <%= "BOOKED".equals(statusFilter) ? "active" : "" %>" onclick="filterByStatus('BOOKED')">
                <div class="stat-value" id="bookedCount">
                    <%= reservations != null ? reservations.stream().filter(r -> "BOOKED".equals(r.getStatus())).count() : 0 %>
                </div>
                <div class="stat-label">BOOKED</div>
            </div>
            <div class="stat-item <%= "CHECKED-IN".equals(statusFilter) ? "active" : "" %>" onclick="filterByStatus('CHECKED-IN')">
                <div class="stat-value" id="checkedInCount">
                    <%= reservations != null ? reservations.stream().filter(r -> "CHECKED-IN".equals(r.getStatus())).count() : 0 %>
                </div>
                <div class="stat-label">CHECKED-IN</div>
            </div>
            <div class="stat-item <%= "CHECKED-OUT".equals(statusFilter) ? "active" : "" %>" onclick="filterByStatus('CHECKED-OUT')">
                <div class="stat-value" id="checkedOutCount">
                    <%= reservations != null ? reservations.stream().filter(r -> "CHECKED-OUT".equals(r.getStatus())).count() : 0 %>
                </div>
                <div class="stat-label">CHECKED-OUT</div>
            </div>
        </div>
        
        <!-- Search and Filter Box -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/reservation" method="get" class="search-form" id="searchForm">
                <input type="hidden" name="action" value="search">
                <div class="search-row">
                    <input type="text" name="searchTerm" class="search-input" 
                           placeholder="Search by guest name, phone number, or reservation #..." 
                           value="<%= searchTerm %>">
                    <select name="statusFilter" class="filter-select" id="statusFilterSelect">
                        <option value="ALL" <%= "ALL".equals(statusFilter) ? "selected" : "" %>>All Status</option>
                        <option value="BOOKED" <%= "BOOKED".equals(statusFilter) ? "selected" : "" %>>BOOKED</option>
                        <option value="CHECKED-IN" <%= "CHECKED-IN".equals(statusFilter) ? "selected" : "" %>>CHECKED-IN</option>
                        <option value="CHECKED-OUT" <%= "CHECKED-OUT".equals(statusFilter) ? "selected" : "" %>>CHECKED-OUT</option>
                    </select>
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i> Search & Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/reservation" class="reset-btn">
                        <i class="fas fa-redo"></i> Reset
                    </a>
                </div>
            </form>
        </div>
        
        <!-- Messages -->
        <div id="messageContainer">
            <% if (message != null) { %>
                <div class="message"><i class="fas fa-check-circle"></i> <%= message %></div>
            <% } %>
            <% if (error != null) { %>
                <div class="error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
            <% } %>
        </div>
        
        <!-- Reservations Table -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Reservation #</th>
                        <th>Guest</th>
                        <th>Phone</th>
                        <th>Room Type</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Actual Checkout</th>
                        <th>Nights</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (reservations != null && !reservations.isEmpty()) {
                        for (Reservation r : reservations) { 
                            String status = r.getStatus();
                    %>
                            <tr id="reservation-<%= r.getReservationId() %>">
                                <td class="reference-number">#<%= r.getReservationNumber() %></td>
                                <td><strong><%= r.getGuestName() %></strong></td>
                                <td><%= r.getContactNumber() != null ? r.getContactNumber() : "-" %></td>
                                <td><%= r.getRoomTypeName() %></td>
                                <td><%= r.getCheckInDate() %></td>
                                <td><%= r.getCheckOutDate() %></td>
                                <td class="actual-checkout"><%= r.getActualCheckoutDate() != null ? r.getActualCheckoutDate() : "-" %></td>
                                
                                <!-- NIGHTS COLUMN - FIXED FOR CHECKED-OUT -->
                                <td class="nights">
                                    <% 
                                        int displayNights = 0;
                                        
                                        if ("CHECKED-OUT".equals(status) && r.isHasBill()) {
                                            // Use bill data for checked-out reservations
                                            displayNights = r.getBillNights();
                                        } else {
                                            // Use calculated data for other statuses
                                            displayNights = r.getActualNights();
                                            // Ensure at least 1 night for checked-out without bill
                                            if ("CHECKED-OUT".equals(status) && displayNights == 0) {
                                                displayNights = 1;
                                            }
                                        }
                                        out.print(displayNights);
                                    %>
                                </td>
                                
                                <!-- TOTAL COLUMN - FIXED FOR CHECKED-OUT -->
                                <td class="amount">
                                    <% 
                                        double displayAmount = 0;
                                        
                                        if ("CHECKED-OUT".equals(status) && r.isHasBill()) {
                                            // Use bill data for checked-out reservations
                                            displayAmount = r.getBillAmount();
                                        } else {
                                            // Use calculated data for other statuses
                                            displayAmount = r.getActualAmount();
                                            // Ensure at least 1 night amount for checked-out without bill
                                            if ("CHECKED-OUT".equals(status) && displayAmount == 0) {
                                                displayAmount = r.getPricePerNight();
                                            }
                                        }
                                        out.print("LKR " + String.format("%,.0f", displayAmount));
                                    %>
                                </td>
                                
                                <td>
                                    <span class="status-badge status-<%= status %>">
                                        <%= status %>
                                    </span>
                                    <% if (r.isHasBill()) { %>
                                        <span class="bill-badge">
                                            <i class="fas fa-check-circle"></i> Bill #<%= r.getBillId() %>
                                        </span>
                                    <% } %>
                                </td>
                                
                                <td class="action-buttons">
                                    <!-- EDIT BUTTON -->
                                    <% if (!"CHECKED-OUT".equals(status)) { %>
                                        <a href="${pageContext.request.contextPath}/reservation?action=editForm&id=<%= r.getReservationId() %>" 
                                           class="action-btn btn-edit" title="Edit Reservation">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                    <% } else { %>
                                        <span class="action-btn btn-edit btn-disabled" title="Cannot edit checked-out reservations">
                                            <i class="fas fa-edit"></i> Edit
                                        </span>
                                    <% } %>
                                    
                                    <!-- DELETE BUTTON -->
                                    <% if ("BOOKED".equals(status)) { %>
                                        <a href="${pageContext.request.contextPath}/reservation?action=delete&id=<%= r.getReservationId() %>" 
                                           class="action-btn btn-delete" 
                                           onclick="return confirm('Are you sure you want to delete this reservation?')"
                                           title="Delete Reservation">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    <% } else { %>
                                        <span class="action-btn btn-delete btn-disabled" title="Cannot delete checked-in/out reservations">
                                            <i class="fas fa-trash"></i> Delete
                                        </span>
                                    <% } %>
                                    
                                    <!-- BILL BUTTON -->
                                    <% if (r.isHasBill()) { %>
                                        <a href="${pageContext.request.contextPath}/bill?action=print&id=<%= r.getReservationId() %>" 
                                           class="action-btn btn-view" title="Print Bill">
                                            <i class="fas fa-print"></i> Bill
                                        </a>
                                    <% } else if ("CHECKED-IN".equals(status) || "CHECKED-OUT".equals(status)) { %>
                                        <a href="#" 
                                           class="action-btn btn-bill bill-link" 
                                           data-id="<%= r.getReservationId() %>"
                                           title="Generate Bill">
                                            <i class="fas fa-file-invoice"></i> Bill
                                        </a>
                                    <% } else { %>
                                        <span class="action-btn btn-bill btn-disabled" title="Bill can only be generated for checked-in/out reservations">
                                            <i class="fas fa-file-invoice"></i> Bill
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                        <% }
                    } else { %>
                        <tr>
                            <td colspan="11" class="no-data">
                                <i class="fas fa-calendar-times"></i>
                                <h3>No Reservations Found</h3>
                                <p>Try adjusting your search or <a href="${pageContext.request.contextPath}/reservation?action=addForm">create a new reservation</a></p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Filter by status
        function filterByStatus(status) {
            document.getElementById('statusFilterSelect').value = status;
            document.getElementById('searchForm').submit();
        }

        // Bill button handling
        document.querySelectorAll('.bill-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const reservationId = this.dataset.id;
                if (confirm('Generate bill for this reservation?')) {
                    window.location.href = '${pageContext.request.contextPath}/bill?action=print&id=' + reservationId;
                }
            });
        });

        // Auto-hide messages after 5 seconds
        setTimeout(() => {
            const messages = document.querySelectorAll('.message, .error');
            messages.forEach(msg => msg.remove());
        }, 5000);
    </script>
</body>
</html>