<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation, com.oceanview.model.Guest, com.oceanview.model.RoomType" %>
<%@ page import="java.time.LocalDate" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Guest> guests = (List<Guest>) request.getAttribute("guests");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    
    if (reservation == null) {
        response.sendRedirect(request.getContextPath() + "/reservation");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    LocalDate today = LocalDate.now();
    String status = reservation.getStatus();
    
    boolean isBooked = "BOOKED".equals(status);
    boolean isCheckedIn = "CHECKED-IN".equals(status);
    boolean isCheckedOut = "CHECKED-OUT".equals(status);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Reservation - Ocean View Resort</title>
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
        
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
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
        }
        
        .sidebar-header h2 span {
            font-weight: 700;
            display: block;
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
            font-weight: bold;
        }
        
        .nav-menu {
            list-style: none;
            padding: 10px;
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
            gap: 12px;
        }
        
        .nav-link:hover {
            background: rgba(255,255,255,0.15);
        }
        
        .nav-link.active {
            background: #ffd700;
            color: #1e3c72;
        }
        
        .logout-link {
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 20px;
        }
        
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
            width: calc(100% - 280px);
        }
        
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-container h2 {
            color: #1e3c72;
            margin-bottom: 30px;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-box {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border-left: 4px solid #2a5298;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed #b0bec5;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #1e3c72;
        }
        
        .info-value {
            color: #2c3e50;
        }
        
        .status-badge {
            padding: 5px 10px;
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
        
        .warning-box {
            background: #fff3e0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #f39c12;
            color: #e67e22;
        }
        
        .error-box {
            background: #ffebee;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
            color: #c62828;
        }
        
        .success-box {
            background: #e8f5e9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #388e3c;
            color: #388e3c;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .form-group {
            flex: 1;
            min-width: 250px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 500;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .form-group input:disabled, .form-group select:disabled {
            background: #f5f5f5;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .form-group input.error {
            border-color: #e74c3c;
            background-color: #fff5f5;
        }
        
        .form-group .hint {
            font-size: 12px;
            margin-top: 5px;
            color: #7f8c8d;
        }
        
        .form-group .hint.error {
            color: #e74c3c;
        }
        
        .form-group .hint.success {
            color: #27ae60;
        }
        
        .price-display {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .total-amount {
            font-size: 28px;
            font-weight: bold;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn-save {
            background: #2a5298;
            color: white;
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            flex: 2;
            transition: all 0.3s;
        }
        
        .btn-save:hover:not(:disabled) {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-save:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }
        
        .btn-cancel {
            background: #95a5a6;
            color: white;
            padding: 14px 30px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            text-align: center;
            flex: 1;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .reference-number {
            font-family: monospace;
            font-weight: bold;
            color: #2a5298;
            font-size: 18px;
        }
        
        .validation-summary {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #e9ecef;
        }
        
        .validation-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 5px 0;
        }
        
        .validation-item i.fa-check-circle {
            color: #27ae60;
        }
        
        .validation-item i.fa-exclamation-circle {
            color: #e74c3c;
        }
        
        /* Status Change Warning */
        .status-change-warning {
            background: #fff3e0;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #f39c12;
            display: none;
        }
        
        .status-change-warning.active {
            display: block;
            animation: pulse 1s ease-in-out;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }
        
        .new-status {
            font-weight: bold;
            color: #e67e22;
            background: #fff;
            padding: 3px 8px;
            border-radius: 4px;
            margin-left: 5px;
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
            
            .form-row {
                flex-direction: column;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp">
        <jsp:param name="activePage" value="addReservation" />
    </jsp:include>
    
    <div class="main-content">
        <div class="form-container">
            <h2>
                <i class="fas fa-edit" style="color: #2a5298;"></i> 
                Edit Reservation
            </h2>
            
            <% if (error != null) { %>
                <div class="error-box">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>
            
            <!-- Reservation Info Box -->
            <div class="info-box">
                <div class="info-row">
                    <span class="info-label">Reservation #:</span>
                    <span class="info-value reference-number"><%= reservation.getReservationNumber() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Current Status:</span>
                    <span class="info-value">
                        <span class="status-badge status-<%= reservation.getStatus() %>">
                            <%= reservation.getStatus() %>
                        </span>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Check-in Date:</span>
                    <span class="info-value"><%= reservation.getCheckInDate() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Check-out Date:</span>
                    <span class="info-value"><%= reservation.getCheckOutDate() %></span>
                </div>
            </div>
            
            <!-- Status-specific messages and validations -->
            <% if (isBooked) { %>
                <div class="success-box">
                    <i class="fas fa-check-circle"></i>
                    <strong>BOOKED Status - Full Edit Mode</strong>
                    <p style="margin-top: 5px; font-size: 14px;">You can modify all reservation details including guest, room type, and dates.</p>
                </div>
            <% } %>
            
            <% if (isCheckedIn) { %>
                <div class="warning-box">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>CHECKED-IN Status - Limited Edit Mode</strong>
                    <p style="margin-top: 5px; font-size: 14px;">Check-in date cannot be changed. You can modify room type and check-out date.</p>
                </div>
            <% } %>
            
            <% if (isCheckedOut) { %>
                <div class="error-box">
                    <i class="fas fa-ban"></i>
                    <strong>CHECKED-OUT Status - Read Only</strong>
                    <p style="margin-top: 5px; font-size: 14px;">This reservation has been checked out and cannot be modified.</p>
                </div>
            <% } %>
            
            <!-- Status Change Warning (for BOOKED to CHECKED-IN) -->
            <div id="statusChangeWarning" class="status-change-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Status will change to <span id="newStatusDisplay" class="new-status">CHECKED-IN</span></strong>
                <p style="margin-top: 5px; font-size: 14px;">Since check-in date is set to today, this reservation will be marked as CHECKED-IN.</p>
            </div>
            
            <!-- Validation Summary for BOOKED status -->
            <% if (isBooked) { %>
            <div class="validation-summary">
                <h4 style="margin-bottom: 10px; color: #1e3c72;">Edit Rules for BOOKED Status:</h4>
                <div class="validation-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Guest can be changed</span>
                </div>
                <div class="validation-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Room type can be changed</span>
                </div>
                <div class="validation-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Check-in date can be changed (must be today or future)</span>
                </div>
                <div class="validation-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Check-out date must be after check-in date</span>
                </div>
                <div class="validation-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Minimum 1 night stay required</span>
                </div>
                <div class="validation-item" style="color: #f39c12;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Setting check-in to today will auto-change status to CHECKED-IN</span>
                </div>
            </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/reservation" method="post" id="editForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= reservation.getReservationId() %>">
                <input type="hidden" name="originalStatus" id="originalStatus" value="<%= reservation.getStatus() %>">
                <input type="hidden" name="originalCheckIn" id="originalCheckIn" value="<%= reservation.getCheckInDate() %>">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="guestId">
                            <i class="fas fa-user"></i> Guest
                        </label>
                        <select id="guestId" name="guestId" <%= isCheckedOut ? "disabled" : "" %> required>
                            <% for (Guest g : guests) { %>
                                <option value="<%= g.getGuestId() %>" 
                                    <%= g.getGuestId() == reservation.getGuestId() ? "selected" : "" %>>
                                    <%= g.getGuestName() %> - <%= g.getContactNumber() %>
                                </option>
                            <% } %>
                        </select>
                        <% if (isCheckedOut) { %>
                            <input type="hidden" name="guestId" value="<%= reservation.getGuestId() %>">
                            <div class="hint">Cannot change guest for checked-out reservations</div>
                        <% } %>
                    </div>
                    
                    <div class="form-group">
                        <label for="roomTypeId">
                            <i class="fas fa-bed"></i> Room Type
                        </label>
                        <select id="roomTypeId" name="roomTypeId" <%= isCheckedOut ? "disabled" : "" %> required onchange="calculateTotal()">
                            <% for (RoomType rt : roomTypes) { 
                                String selected = rt.getRoomTypeId() == reservation.getRoomTypeId() ? "selected" : "";
                            %>
                                <option value="<%= rt.getRoomTypeId() %>" 
                                        data-price="<%= rt.getPricePerNight() %>"
                                        <%= selected %>>
                                    <%= rt.getTypeName() %> - LKR <%= String.format("%,.0f", rt.getPricePerNight()) %>/night
                                </option>
                            <% } %>
                        </select>
                        <% if (isCheckedOut) { %>
                            <input type="hidden" name="roomTypeId" value="<%= reservation.getRoomTypeId() %>">
                        <% } %>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="checkInDate">
                            <i class="fas fa-sign-in-alt"></i> Check-in Date
                        </label>
                        <input type="date" id="checkInDate" name="checkInDate" 
                               value="<%= reservation.getCheckInDate() %>" 
                               min="<%= today %>"
                               <%= (isCheckedIn || isCheckedOut) ? "disabled" : "" %>
                               required onchange="checkStatusChange(); validateDates(); calculateTotal()">
                        <div id="checkInHint" class="hint">
                            <% if (isBooked) { %>
                                <i class="fas fa-info-circle"></i> Can be changed to any future date
                            <% } else if (isCheckedIn) { %>
                                <i class="fas fa-lock"></i> Check-in date cannot be changed for checked-in guests
                                <input type="hidden" name="checkInDate" value="<%= reservation.getCheckInDate() %>">
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="checkOutDate">
                            <i class="fas fa-sign-out-alt"></i> Check-out Date
                        </label>
                        <input type="date" id="checkOutDate" name="checkOutDate" 
                               value="<%= reservation.getCheckOutDate() %>" 
                               min="<%= reservation.getCheckInDate().plusDays(1) %>"
                               <%= isCheckedOut ? "disabled" : "" %>
                               required onchange="validateDates(); calculateTotal()">
                        <div id="checkOutHint" class="hint"></div>
                    </div>
                </div>
                
                <!-- Status Field (Hidden) -->
                <input type="hidden" name="status" id="statusField" value="<%= reservation.getStatus() %>">
                
                <!-- Price Calculation Display -->
                <div class="price-display">
                    <span>
                        <i class="fas fa-calculator"></i> 
                        <span id="nightsLabel">0 nights</span>
                    </span>
                    <span class="total-amount" id="totalAmount">LKR 0</span>
                </div>
                
                <!-- Validation Messages -->
                <div id="validationMessages"></div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-save" id="submitBtn" <%= isCheckedOut ? "disabled" : "" %>>
                        <i class="fas fa-save"></i> Update Reservation
                    </button>
                    <a href="${pageContext.request.contextPath}/reservation" class="btn-cancel">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Room types data
        const roomTypes = [
            <% for (RoomType rt : roomTypes) { %>
                { id: <%= rt.getRoomTypeId() %>, price: <%= rt.getPricePerNight() %> },
            <% } %>
        ];
        
        const originalCheckIn = '<%= reservation.getCheckInDate() %>';
        const originalCheckOut = '<%= reservation.getCheckOutDate() %>';
        const status = '<%= reservation.getStatus() %>';
        const isBooked = <%= isBooked %>;
        const isCheckedIn = <%= isCheckedIn %>;
        const isCheckedOut = <%= isCheckedOut %>;
        const today = '<%= today %>';
        
        // Check if status should change to CHECKED-IN
        function checkStatusChange() {
            if (!isBooked) return; // Only for BOOKED reservations
            
            const checkIn = document.getElementById('checkInDate').value;
            const warningDiv = document.getElementById('statusChangeWarning');
            const statusField = document.getElementById('statusField');
            
            if (checkIn === today) {
                // Show warning and update status
                warningDiv.classList.add('active');
                statusField.value = 'CHECKED-IN';
                
                // Update checkout min date
                const checkOut = document.getElementById('checkOutDate');
                const nextDay = getNextDay(checkIn);
                checkOut.min = nextDay;
                
                // Update hint
                document.getElementById('checkInHint').innerHTML = '<i class="fas fa-exclamation-triangle" style="color: #f39c12;"></i> Check-in is today - status will become CHECKED-IN';
                document.getElementById('checkInHint').className = 'hint';
            } else {
                // Hide warning and keep original status
                warningDiv.classList.remove('active');
                statusField.value = 'BOOKED';
                
                // Update hint
                document.getElementById('checkInHint').innerHTML = '<i class="fas fa-info-circle"></i> Can be changed to any future date';
                document.getElementById('checkInHint').className = 'hint';
            }
        }
        
        function getNextDay(date) {
            const d = new Date(date);
            d.setDate(d.getDate() + 1);
            return d.toISOString().split('T')[0];
        }
        
        // Calculate nights between two dates
        function calculateNights(checkIn, checkOut) {
            if (!checkIn || !checkOut) return 0;
            const start = new Date(checkIn);
            const end = new Date(checkOut);
            const diffTime = end - start;
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            return diffDays;
        }
        
        // Validate dates based on status
        function validateDates() {
            const checkIn = document.getElementById('checkInDate').value;
            const checkOut = document.getElementById('checkOutDate').value;
            const checkOutHint = document.getElementById('checkOutHint');
            const validationDiv = document.getElementById('validationMessages');
            const submitBtn = document.getElementById('submitBtn');
            
            let isValid = true;
            let messages = [];
            
            // Clear previous messages
            validationDiv.innerHTML = '';
            
            if (!checkIn || !checkOut) {
                submitBtn.disabled = true;
                return;
            }
            
            const nights = calculateNights(checkIn, checkOut);
            
            // VALIDATION 1: Check-out must be after check-in
            if (nights < 1) {
                checkOutHint.innerHTML = '<i class="fas fa-exclamation-circle"></i> Check-out must be at least 1 day after check-in';
                checkOutHint.className = 'hint error';
                isValid = false;
                messages.push('❌ Check-out must be after check-in date');
            } else {
                checkOutHint.innerHTML = '<i class="fas fa-check-circle"></i> ' + nights + ' night' + (nights > 1 ? 's' : '');
                checkOutHint.className = 'hint success';
            }
            
            // VALIDATION 2: For BOOKED status, check-in cannot be in the past
            if (isBooked && checkIn < today) {
                document.getElementById('checkInHint').innerHTML = '<i class="fas fa-exclamation-circle"></i> Check-in date cannot be in the past';
                document.getElementById('checkInHint').className = 'hint error';
                isValid = false;
                messages.push('❌ Check-in date cannot be in the past');
            }
            
            // VALIDATION 3: For CHECKED-IN, check-in cannot be changed
            if (isCheckedIn && checkIn !== originalCheckIn) {
                document.getElementById('checkInHint').innerHTML = '<i class="fas fa-exclamation-circle"></i> Check-in date cannot be changed for checked-in guests';
                document.getElementById('checkInHint').className = 'hint error';
                isValid = false;
                messages.push('❌ Check-in date cannot be changed for checked-in guests');
            }
            
            // Display validation messages
            if (messages.length > 0) {
                let html = '<div class="error-box" style="margin-top: 10px;">';
                messages.forEach(msg => {
                    html += '<div style="padding: 3px 0;">' + msg + '</div>';
                });
                html += '</div>';
                validationDiv.innerHTML = html;
            }
            
            submitBtn.disabled = !isValid;
            return isValid;
        }
        
        // Calculate total amount
        function calculateTotal() {
            const roomTypeId = document.getElementById('roomTypeId').value;
            const checkIn = document.getElementById('checkInDate').value;
            const checkOut = document.getElementById('checkOutDate').value;
            
            if (!roomTypeId || !checkIn || !checkOut) return;
            
            const roomType = roomTypes.find(rt => rt.id == roomTypeId);
            if (!roomType) return;
            
            const nights = calculateNights(checkIn, checkOut);
            
            if (nights > 0) {
                const total = roomType.price * nights;
                document.getElementById('totalAmount').textContent = 'LKR ' + total.toLocaleString();
                document.getElementById('nightsLabel').textContent = nights + ' night' + (nights > 1 ? 's' : '');
            }
        }
        
        // Form submission validation
        document.getElementById('editForm').addEventListener('submit', function(e) {
            if (isCheckedOut) {
                e.preventDefault();
                alert('Cannot edit checked-out reservations');
                return;
            }
            
            if (!validateDates()) {
                e.preventDefault();
                return;
            }
            
            // For BOOKED status changing to CHECKED-IN, confirm
            if (isBooked) {
                const checkIn = document.getElementById('checkInDate').value;
                if (checkIn === today) {
                    if (!confirm('This reservation will be marked as CHECKED-IN. Continue?')) {
                        e.preventDefault();
                    }
                }
            }
        });
        
        // Initialize calculations and validation
        window.onload = function() {
            calculateTotal();
            validateDates();
            if (isBooked) {
                checkStatusChange();
            }
        };
        
        // Real-time validation on changes
        document.getElementById('checkInDate').addEventListener('change', function() {
            validateDates();
            calculateTotal();
            checkStatusChange();
            
            // Update check-out min date
            const checkIn = this.value;
            const checkOut = document.getElementById('checkOutDate');
            if (checkIn) {
                checkOut.min = getNextDay(checkIn);
            }
        });
        
        document.getElementById('checkOutDate').addEventListener('change', function() {
            validateDates();
            calculateTotal();
        });
        
        document.getElementById('roomTypeId').addEventListener('change', calculateTotal);
    </script>
</body>
</html>