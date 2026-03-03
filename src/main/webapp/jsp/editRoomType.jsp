<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.RoomType" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    if (roomType == null) {
        response.sendRedirect(request.getContextPath() + "/room-type");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Room Type - Ocean View Resort</title>
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
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-container h2 {
            color: #1e3c72;
            margin-bottom: 30px;
            font-size: 24px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .form-group input.error {
            border-color: #e74c3c;
            background-color: #fff5f5;
        }
        
        .form-group input.valid {
            border-color: #27ae60;
            background-color: #f0fff0;
        }
        
        .input-hint {
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .hint-error {
            color: #e74c3c;
        }
        
        .hint-success {
            color: #27ae60;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn-submit {
            background: #2a5298;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
            flex: 1;
        }
        
        .btn-submit:hover {
            background: #1e3c72;
        }
        
        .btn-submit:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }
        
        .btn-cancel {
            background: #95a5a6;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            text-align: center;
            flex: 1;
        }
        
        .btn-cancel:hover {
            background: #7f8c8d;
        }
        
        .current-value {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
        }
        
        .price-input-group {
            position: relative;
        }
        
        .price-input-group::before {
            content: "LKR";
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            font-weight: 600;
            z-index: 1;
        }
        
        .price-input-group input {
            padding-left: 60px;
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
                width: calc(100% - 80px);
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="includes/navbar.jsp">
        <jsp:param name="activePage" value="roomType" />
    </jsp:include>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="form-container">
            <h2><i class="fas fa-edit"></i> Edit Room Type</h2>
            
            <% if (request.getParameter("error") != null) { %>
                <div style="background: #ffebee; color: #c62828; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle"></i> 
                    <% if ("exists".equals(request.getParameter("error"))) { %>
                        Room type with this name already exists! Please use a different name.
                    <% } else { %>
                        Error updating room type. Please try again.
                    <% } %>
                </div>
            <% } %>
            
            <div class="current-value">
                <i class="fas fa-info-circle"></i> Editing Room Type ID: #<%= roomType.getRoomTypeId() %>
            </div>
            
            <form action="${pageContext.request.contextPath}/room-type" method="post" id="editRoomTypeForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= roomType.getRoomTypeId() %>">
                
                <div class="form-group">
                    <label for="typeName">Room Type Name</label>
                    <input type="text" id="typeName" name="typeName" 
                           value="<%= roomType.getTypeName() %>" required 
                           placeholder="e.g., Deluxe Ocean View"
                           onkeyup="checkRoomName(this.value)">
                    <div id="nameHint" class="input-hint"></div>
                </div>
                
                <div class="form-group">
                    <label for="pricePerNight">Price Per Night (LKR)</label>
                    <div class="price-input-group">
                        <input type="number" id="pricePerNight" name="pricePerNight" 
                               value="<%= roomType.getPricePerNight() %>" 
                               step="0.01" min="0" required 
                               placeholder="e.g., 15000"
                               onkeyup="validatePrice(this.value)"
                               onchange="validatePrice(this.value)">
                    </div>
                    <div id="priceHint" class="input-hint"></div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-submit" id="submitBtn">
                        <i class="fas fa-save"></i> Update Room Type
                    </button>
                    <a href="${pageContext.request.contextPath}/room-type" class="btn-cancel">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        let checkTimeout;
        const originalName = '<%= roomType.getTypeName() %>';
        const roomTypeId = <%= roomType.getRoomTypeId() %>;
        
        // Check room name with server
        function checkRoomNameWithServer(name) {
            return fetch('${pageContext.request.contextPath}/room-type?action=checkName&name=' + encodeURIComponent(name) + '&excludeId=' + roomTypeId)
                .then(response => response.json());
        }
        
        function checkRoomName(name) {
            const nameInput = document.getElementById('typeName');
            const nameHint = document.getElementById('nameHint');
            const submitBtn = document.getElementById('submitBtn');
            
            // If name is same as original, it's valid
            if (name.trim() === originalName) {
                nameInput.classList.add('valid');
                nameInput.classList.remove('error');
                nameHint.innerHTML = '<i class="fas fa-check-circle" style="color: #27ae60;"></i> <span style="color: #27ae60;">Original name (unchanged)</span>';
                enableSubmitIfValid();
                return;
            }
            
            // Basic validation
            if (name.trim().length < 3) {
                nameInput.classList.remove('error', 'valid');
                nameHint.innerHTML = '<i class="fas fa-exclamation-triangle" style="color: #f39c12;"></i> <span style="color: #f39c12;">Name must be at least 3 characters</span>';
                submitBtn.disabled = true;
                return;
            }
            
            // Show checking status
            nameHint.innerHTML = '<i class="fas fa-spinner fa-spin" style="color: #2a5298;"></i> <span style="color: #2a5298;">Checking availability...</span>';
            
            // Clear previous timeout
            if (checkTimeout) {
                clearTimeout(checkTimeout);
            }
            
            // Debounce API call
            checkTimeout = setTimeout(() => {
                checkRoomNameWithServer(name.trim())
                    .then(data => {
                        if (data.exists) {
                            nameInput.classList.add('error');
                            nameInput.classList.remove('valid');
                            nameHint.innerHTML = '<i class="fas fa-times-circle" style="color: #e74c3c;"></i> <span style="color: #e74c3c;">' + data.message + '</span>';
                            submitBtn.disabled = true;
                        } else {
                            nameInput.classList.add('valid');
                            nameInput.classList.remove('error');
                            nameHint.innerHTML = '<i class="fas fa-check-circle" style="color: #27ae60;"></i> <span style="color: #27ae60;">' + data.message + '</span>';
                            enableSubmitIfValid();
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        nameHint.innerHTML = '<i class="fas fa-exclamation-circle" style="color: #e74c3c;"></i> <span style="color: #e74c3c;">Error checking availability</span>';
                    });
            }, 500);
        }
        
        function validatePrice(price) {
            const priceInput = document.getElementById('pricePerNight');
            const priceHint = document.getElementById('priceHint');
            
            if (price === '' || price === null) {
                priceInput.classList.remove('valid', 'error');
                priceHint.innerHTML = '<i class="fas fa-info-circle" style="color: #7f8c8d;"></i> <span style="color: #7f8c8d;">Enter price per night</span>';
                document.getElementById('submitBtn').disabled = true;
                return false;
            }
            
            const priceNum = parseFloat(price);
            
            if (isNaN(priceNum) || priceNum <= 0) {
                priceInput.classList.add('error');
                priceInput.classList.remove('valid');
                priceHint.innerHTML = '<i class="fas fa-exclamation-circle" style="color: #e74c3c;"></i> <span style="color: #e74c3c;">Price must be greater than 0</span>';
                document.getElementById('submitBtn').disabled = true;
                return false;
            } else {
                priceInput.classList.add('valid');
                priceInput.classList.remove('error');
                priceHint.innerHTML = '<i class="fas fa-check-circle" style="color: #27ae60;"></i> <span style="color: #27ae60;">Valid price</span>';
                enableSubmitIfValid();
                return true;
            }
        }
        
        function enableSubmitIfValid() {
            const nameInput = document.getElementById('typeName');
            const priceInput = document.getElementById('pricePerNight');
            const submitBtn = document.getElementById('submitBtn');
            
            const isNameValid = nameInput.classList.contains('valid');
            const isPriceValid = priceInput.classList.contains('valid');
            
            submitBtn.disabled = !(isNameValid && isPriceValid);
        }
        
        // Form submission validation
        document.getElementById('editRoomTypeForm').addEventListener('submit', function(e) {
            const nameInput = document.getElementById('typeName');
            const priceInput = document.getElementById('pricePerNight');
            
            if (!nameInput.classList.contains('valid')) {
                e.preventDefault();
                alert('Please enter a valid and unique room type name');
                return;
            }
            
            if (!priceInput.classList.contains('valid')) {
                e.preventDefault();
                alert('Please enter a valid price greater than 0');
                return;
            }
        });
        
        // Initial validation on page load
        window.onload = function() {
            // Validate price on load
            const priceInput = document.getElementById('pricePerNight');
            validatePrice(priceInput.value);
            
            // Mark name as valid since it's original
            document.getElementById('typeName').classList.add('valid');
            document.getElementById('nameHint').innerHTML = '<i class="fas fa-check-circle" style="color: #27ae60;"></i> <span style="color: #27ae60;">Original name</span>';
            
            enableSubmitIfValid();
        };
    </script>
</body>
</html>