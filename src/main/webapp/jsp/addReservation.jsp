<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Guest, com.oceanview.model.RoomType" %>
<%@ page import="java.time.LocalDate" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    List<Guest> guests = (List<Guest>) request.getAttribute("guests");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    String today = (String) request.getAttribute("today");
    String tomorrow = (String) request.getAttribute("tomorrow");
    
    if (guests == null || roomTypes == null) {
        response.sendRedirect(request.getContextPath() + "/reservation?action=addForm");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Reservation - Ocean View Resort</title>
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
            max-width: 700px;
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
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 500;
        }
        
        .form-group select, .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        
        .form-group select:focus, .form-group input:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .price-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .price-info span:first-child {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .price-info span:last-child {
            font-size: 28px;
            font-weight: bold;
        }
        
        .btn-submit {
            background: #2a5298;
            color: white;
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: all 0.3s;
        }
        
        .btn-submit:hover:not(:disabled) {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-submit:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }
        
        .btn-view {
            display: inline-block;
            background: #27ae60;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            width: 100%;
            transition: all 0.3s;
        }
        
        .btn-view:hover {
            background: #219a52;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .validation-message {
            font-size: 13px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .validation-error {
            color: #e74c3c;
        }
        
        .validation-success {
            color: #27ae60;
        }
        
        .note {
            font-size: 13px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .summary-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            border: 1px solid #e9ecef;
        }
        
        .summary-item {
            flex: 1;
            text-align: center;
        }
        
        .summary-item i {
            color: #2a5298;
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .summary-item .label {
            font-size: 12px;
            color: #666;
        }
        
        .summary-item .value {
            font-size: 18px;
            font-weight: bold;
            color: #1e3c72;
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
                <i class="fas fa-calendar-plus" style="color: #2a5298;"></i> 
                Add New Reservation
            </h2>
            
            <!-- Summary Box -->
            <div class="summary-box">
                <div class="summary-item">
                    <i class="fas fa-users"></i>
                    <div class="value"><%= guests.size() %></div>
                    <div class="label">Total Guests</div>
                </div>
                <div class="summary-item">
                    <i class="fas fa-bed"></i>
                    <div class="value"><%= roomTypes.size() %></div>
                    <div class="label">Room Types</div>
                </div>
                <div class="summary-item">
                    <i class="fas fa-calendar"></i>
                    <div class="value" id="nightCount">0</div>
                    <div class="label">Nights</div>
                </div>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> 
                    <% if ("past_date".equals(request.getParameter("error"))) { %>
                        Check-in date cannot be in the past!
                    <% } else if ("invalid_dates".equals(request.getParameter("error"))) { %>
                        Check-out date must be at least one day after check-in date!
                    <% } else if ("add_failed".equals(request.getParameter("error"))) { %>
                        Failed to add reservation. Please try again.
                    <% } else { %>
                        Invalid input. Please check all fields.
                    <% } %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/reservation" method="post" id="reservationForm">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="guestId">
                        <i class="fas fa-user"></i> Select Guest
                    </label>
                    <select id="guestId" name="guestId" required>
                        <option value="">-- Select Guest --</option>
                        <% for (Guest g : guests) { %>
                            <option value="<%= g.getGuestId() %>">
                                <%= g.getGuestName() %> - <%= g.getContactNumber() %>
                            </option>
                        <% } %>
                    </select>
                    <div class="note">
                        <i class="fas fa-info-circle"></i> 
                        <a href="${pageContext.request.contextPath}/jsp/addGuest.jsp">Add new guest</a> if not in list
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="roomTypeId">
                        <i class="fas fa-bed"></i> Select Room Type
                    </label>
                    <select id="roomTypeId" name="roomTypeId" required onchange="calculateTotal()">
                        <option value="">-- Select Room Type --</option>
                        <% for (RoomType rt : roomTypes) { %>
                            <option value="<%= rt.getRoomTypeId() %>" data-price="<%= rt.getPricePerNight() %>">
                                <%= rt.getTypeName() %> - LKR <%= String.format("%,.0f", rt.getPricePerNight()) %>/night
                            </option>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="checkInDate">
                            <i class="fas fa-sign-in-alt"></i> Check-in Date
                        </label>
                        <input type="date" id="checkInDate" name="checkInDate" 
                               min="<%= today %>" value="<%= today %>" required
                               onchange="calculateTotal()">
                    </div>
                    
                    <div class="form-group">
                        <label for="checkOutDate">
                            <i class="fas fa-sign-out-alt"></i> Check-out Date
                        </label>
                        <input type="date" id="checkOutDate" name="checkOutDate" 
                               min="<%= tomorrow %>" value="<%= tomorrow %>" required
                               onchange="calculateTotal()">
                        <div id="dateValidationMsg" class="validation-message"></div>
                    </div>
                </div>
                
                <!-- Price Display -->
                <div class="price-info" id="priceInfo" style="display: none;">
                    <span><i class="fas fa-calculator"></i> Total Amount:</span>
                    <span id="totalAmount">LKR 0</span>
                </div>
                
                <button type="submit" class="btn-submit" id="submitBtn" disabled>
                    <i class="fas fa-save"></i> Create Reservation
                </button>
            </form>
            
            <a href="${pageContext.request.contextPath}/reservation" class="btn-view">
                <i class="fas fa-list"></i> View All Reservations
            </a>
        </div>
    </div>
    
    <script>
        // Room types data from server
        const roomTypes = [
            <% for (RoomType rt : roomTypes) { %>
                { id: <%= rt.getRoomTypeId() %>, price: <%= rt.getPricePerNight() %> },
            <% } %>
        ];
        
        // Format number as currency
        function formatCurrency(amount) {
            return 'LKR ' + amount.toLocaleString('en-LK', {
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            });
        }
        
        // Calculate nights between two dates
        function calculateNights(checkIn, checkOut) {
            if (!checkIn || !checkOut) return 0;
            
            const start = new Date(checkIn);
            const end = new Date(checkOut);
            
            // Reset time part to avoid timezone issues
            start.setHours(0, 0, 0, 0);
            end.setHours(0, 0, 0, 0);
            
            // Calculate difference in days
            const diffTime = end.getTime() - start.getTime();
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            return diffDays;
        }
        
        // Main calculation function
        function calculateTotal() {
            const roomTypeId = document.getElementById('roomTypeId').value;
            const checkIn = document.getElementById('checkInDate').value;
            const checkOut = document.getElementById('checkOutDate').value;
            const priceInfo = document.getElementById('priceInfo');
            const submitBtn = document.getElementById('submitBtn');
            const dateMsg = document.getElementById('dateValidationMsg');
            const nightCount = document.getElementById('nightCount');
            
            // Reset if missing values
            if (!roomTypeId || !checkIn || !checkOut) {
                priceInfo.style.display = 'none';
                submitBtn.disabled = true;
                nightCount.textContent = '0';
                return;
            }
            
            // Calculate nights
            const nights = calculateNights(checkIn, checkOut);
            nightCount.textContent = nights;
            
            // Validate minimum 1 night
            if (nights < 1) {
                dateMsg.innerHTML = '<i class="fas fa-exclamation-circle"></i> Check-out must be at least 1 day after check-in';
                dateMsg.className = 'validation-message validation-error';
                priceInfo.style.display = 'none';
                submitBtn.disabled = true;
                return;
            }
            
            // Find selected room type
            const selectedRoom = roomTypes.find(rt => rt.id == roomTypeId);
            
            if (selectedRoom) {
                // Calculate total
                const total = selectedRoom.price * nights;
                
                // Update display
                document.getElementById('totalAmount').textContent = formatCurrency(total);
                priceInfo.style.display = 'flex';
                
                // Update validation message
                dateMsg.innerHTML = '<i class="fas fa-check-circle"></i> ' + nights + ' night' + (nights > 1 ? 's' : '') + ' • ' + formatCurrency(selectedRoom.price) + ' per night';
                dateMsg.className = 'validation-message validation-success';
                
                // Enable submit button
                submitBtn.disabled = false;
            }
        }
        
        // Initialize on page load
        window.onload = function() {
            calculateTotal();
        };
        
        // Add event listeners for real-time calculation
        document.getElementById('roomTypeId').addEventListener('change', calculateTotal);
        document.getElementById('checkInDate').addEventListener('change', calculateTotal);
        document.getElementById('checkOutDate').addEventListener('change', calculateTotal);
    </script>
</body>
</html>