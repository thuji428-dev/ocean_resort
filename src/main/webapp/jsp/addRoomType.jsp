<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.RoomType" %>
<%
    // Check login
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    // Get room types from request attribute (set by servlet)
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    if (roomTypes == null) {
        // If not set, create empty list
        roomTypes = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Room Type - Ocean View Resort</title>
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
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .existing-count {
            background: #e3f2fd;
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #1e3c72;
            display: flex;
            align-items: center;
            gap: 10px;
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
            font-size: 13px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 5px 0;
        }
        
        .hint-error {
            color: #e74c3c;
        }
        
        .hint-success {
            color: #27ae60;
        }
        
        .hint-info {
            color: #7f8c8d;
        }
        
        .hint-warning {
            color: #f39c12;
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
            transition: all 0.3s;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-submit:hover:not(:disabled) {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-submit:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            opacity: 0.7;
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
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid #c62828;
        }
        
        .validation-rules {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2a5298;
        }
        
        .validation-rules h4 {
            color: #1e3c72;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .validation-rules ul {
            list-style: none;
            padding-left: 10px;
        }
        
        .validation-rules li {
            padding: 5px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }
        
        .validation-rules li i {
            width: 16px;
        }
        
        .rule-valid {
            color: #27ae60;
        }
        
        .rule-invalid {
            color: #e74c3c;
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
        
        .character-count {
            text-align: right;
            font-size: 12px;
            margin-top: 5px;
            color: #7f8c8d;
        }
        
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #2a5298;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
                padding: 15px;
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
            <h2>
                <i class="fas fa-bed" style="color: #2a5298;"></i> 
                Add New Room Type
            </h2>
            
            <!-- Show existing room types count -->
            <div class="existing-count">
                <i class="fas fa-info-circle"></i>
                Currently <strong><%= roomTypes.size() %></strong> room type(s) in system
            </div>
            
            <!-- Validation Rules Box -->
            <div class="validation-rules">
                <h4><i class="fas fa-clipboard-check"></i> Room Name Validation Rules:</h4>
                <ul>
                    <li id="ruleLength">
                        <i class="fas fa-circle"></i> At least 5 characters
                    </li>
                    <li id="ruleLetters">
                        <i class="fas fa-circle"></i> Must contain at least 2 letters
                    </li>
                    <li id="ruleFormat">
                        <i class="fas fa-circle"></i> Can include letters, numbers, spaces, hyphens, and apostrophes
                    </li>
                    <li id="ruleUnique">
                        <i class="fas fa-circle"></i> Must be unique (not already existing)
                    </li>
                </ul>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> 
                    <% if ("exists".equals(request.getParameter("error"))) { %>
                        Room type with this name already exists! Please use a different name.
                    <% } else if ("invalid_format".equals(request.getParameter("error"))) { %>
                        Invalid room name format! Please follow the validation rules.
                    <% } else { %>
                        Error adding room type. Please try again.
                    <% } %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/room-type" method="post" id="addRoomTypeForm">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="typeName">
                        <i class="fas fa-tag" style="color: #2a5298;"></i> Room Type Name
                    </label>
                    <input type="text" 
                           id="typeName" 
                           name="typeName" 
                           required 
                           placeholder="e.g., Deluxe Ocean View"
                           onkeyup="validateRoomName(this.value)"
                           onblur="validateRoomName(this.value, true)"
                           autocomplete="off"
                           maxlength="50">
                    <div class="character-count" id="charCount">0/50 characters</div>
                    <div id="nameHint" class="input-hint hint-info">
                        <i class="fas fa-info-circle"></i> 
                        <span>Enter a unique room type name</span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="pricePerNight">
                        <i class="fas fa-dollar-sign" style="color: #2a5298;"></i> Price Per Night (LKR)
                    </label>
                    <div class="price-input-group">
                        <input type="number" 
                               id="pricePerNight" 
                               name="pricePerNight" 
                               step="0.01" 
                               min="0" 
                               required 
                               placeholder="15000"
                               onkeyup="validatePrice(this.value)">
                    </div>
                    <div id="priceHint" class="input-hint hint-info">
                        <i class="fas fa-info-circle"></i> 
                        <span>Enter the price per night</span>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit" id="submitBtn" disabled>
                    <i class="fas fa-save"></i> 
                    <span>Add Room Type</span>
                </button>
            </form>
            
            <a href="${pageContext.request.contextPath}/room-type" class="btn-view">
                <i class="fas fa-list"></i> View All Room Types
            </a>
        </div>
    </div>
    
    <script>
        let checkTimeout;
        
        // Update validation rules UI
        function updateValidationRules(name) {
            const ruleLength = document.getElementById('ruleLength');
            const ruleLetters = document.getElementById('ruleLetters');
            const ruleFormat = document.getElementById('ruleFormat');
            const ruleUnique = document.getElementById('ruleUnique');
            
            // Reset all to default
            ruleLength.innerHTML = '<i class="fas fa-circle"></i> At least 5 characters';
            ruleLetters.innerHTML = '<i class="fas fa-circle"></i> Must contain at least 2 letters';
            ruleFormat.innerHTML = '<i class="fas fa-circle"></i> Can include letters, numbers, spaces, hyphens, and apostrophes';
            ruleUnique.innerHTML = '<i class="fas fa-circle"></i> Must be unique (not already existing)';
            
            ruleLength.className = '';
            ruleLetters.className = '';
            ruleFormat.className = '';
            ruleUnique.className = '';
            
            if (!name || name.trim() === '') return;
            
            const trimmedName = name.trim();
            
            // Rule 1: Length >= 5
            if (trimmedName.length >= 5) {
                ruleLength.innerHTML = '<i class="fas fa-check-circle rule-valid"></i> At least 5 characters ✓';
                ruleLength.className = 'rule-valid';
            } else {
                ruleLength.innerHTML = '<i class="fas fa-times-circle rule-invalid"></i> At least 5 characters (current: ' + trimmedName.length + ')';
                ruleLength.className = 'rule-invalid';
            }
            
            // Rule 2: At least 2 letters
            const letterCount = (trimmedName.match(/[a-zA-Z]/g) || []).length;
            if (letterCount >= 2) {
                ruleLetters.innerHTML = '<i class="fas fa-check-circle rule-valid"></i> Contains at least 2 letters (has ' + letterCount + ') ✓';
                ruleLetters.className = 'rule-valid';
            } else {
                ruleLetters.innerHTML = '<i class="fas fa-times-circle rule-invalid"></i> Must contain at least 2 letters (current: ' + letterCount + ')';
                ruleLetters.className = 'rule-invalid';
            }
            
            // Rule 3: Valid format (letters, numbers, spaces, hyphens, apostrophes)
            const validFormat = /^[a-zA-Z0-9\s\-']+$/.test(trimmedName);
            if (validFormat) {
                ruleFormat.innerHTML = '<i class="fas fa-check-circle rule-valid"></i> Valid format ✓';
                ruleFormat.className = 'rule-valid';
            } else {
                ruleFormat.innerHTML = '<i class="fas fa-times-circle rule-invalid"></i> Can only contain letters, numbers, spaces, hyphens, and apostrophes';
                ruleFormat.className = 'rule-invalid';
            }
        }
        
        // Check room name with AJAX
        function checkRoomNameWithServer(name) {
            return fetch('${pageContext.request.contextPath}/room-type?action=checkName&name=' + encodeURIComponent(name))
                .then(response => response.json());
        }
        
        function validateRoomName(name) {
            const nameInput = document.getElementById('typeName');
            const nameHint = document.getElementById('nameHint');
            const submitBtn = document.getElementById('submitBtn');
            const price = document.getElementById('pricePerNight').value;
            const charCount = document.getElementById('charCount');
            
            // Update character count
            charCount.textContent = name.length + '/50 characters';
            
            // Update validation rules display
            updateValidationRules(name);
            
            // Basic validation
            if (name.trim().length < 3) {
                nameInput.classList.remove('error', 'valid');
                nameHint.className = 'input-hint hint-warning';
                nameHint.innerHTML = '<i class="fas fa-exclamation-triangle"></i> <span>Room name must be at least 5 characters</span>';
                submitBtn.disabled = true;
                return;
            }
            
            const trimmedName = name.trim();
            
            // Check minimum length (5 characters)
            if (trimmedName.length < 5) {
                nameInput.classList.add('error');
                nameInput.classList.remove('valid');
                nameHint.className = 'input-hint hint-error';
                nameHint.innerHTML = '<i class="fas fa-times-circle"></i> <span>Room name must be at least 5 characters</span>';
                submitBtn.disabled = true;
                return;
            }
            
            // Check for at least 2 letters
            const letterCount = (trimmedName.match(/[a-zA-Z]/g) || []).length;
            if (letterCount < 2) {
                nameInput.classList.add('error');
                nameInput.classList.remove('valid');
                nameHint.className = 'input-hint hint-error';
                nameHint.innerHTML = '<i class="fas fa-times-circle"></i> <span>Room name must contain at least 2 letters</span>';
                submitBtn.disabled = true;
                return;
            }
            
            // Check valid characters
            const validFormat = /^[a-zA-Z0-9\s\-']+$/.test(trimmedName);
            if (!validFormat) {
                nameInput.classList.add('error');
                nameInput.classList.remove('valid');
                nameHint.className = 'input-hint hint-error';
                nameHint.innerHTML = '<i class="fas fa-times-circle"></i> <span>Only letters, numbers, spaces, hyphens (-) and apostrophes (\') allowed</span>';
                submitBtn.disabled = true;
                return;
            }
            
            // Show checking status
            nameHint.className = 'input-hint hint-info';
            nameHint.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>Checking availability...</span>';
            
            // Clear previous timeout
            if (checkTimeout) {
                clearTimeout(checkTimeout);
            }
            
            // Debounce the API call
            checkTimeout = setTimeout(() => {
                checkRoomNameWithServer(trimmedName)
                    .then(data => {
                        if (data.exists) {
                            nameInput.classList.add('error');
                            nameInput.classList.remove('valid');
                            nameHint.className = 'input-hint hint-error';
                            nameHint.innerHTML = '<i class="fas fa-times-circle"></i> <span>' + data.message + '</span>';
                            submitBtn.disabled = true;
                            
                            // Update unique rule
                            document.getElementById('ruleUnique').innerHTML = '<i class="fas fa-times-circle rule-invalid"></i> Name already exists!';
                            document.getElementById('ruleUnique').className = 'rule-invalid';
                        } else {
                            nameInput.classList.add('valid');
                            nameInput.classList.remove('error');
                            nameHint.className = 'input-hint hint-success';
                            nameHint.innerHTML = '<i class="fas fa-check-circle"></i> <span>' + data.message + '</span>';
                            
                            // Update unique rule
                            document.getElementById('ruleUnique').innerHTML = '<i class="fas fa-check-circle rule-valid"></i> Name is available ✓';
                            document.getElementById('ruleUnique').className = 'rule-valid';
                            
                            // Enable submit if price is also valid
                            if (price && parseFloat(price) > 0) {
                                submitBtn.disabled = false;
                            } else {
                                submitBtn.disabled = true;
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Error checking room name:', error);
                        nameHint.className = 'input-hint hint-error';
                        nameHint.innerHTML = '<i class="fas fa-exclamation-circle"></i> <span>Error checking availability</span>';
                    });
            }, 500);
        }
        
        function validatePrice(price) {
            const priceInput = document.getElementById('pricePerNight');
            const priceHint = document.getElementById('priceHint');
            const submitBtn = document.getElementById('submitBtn');
            const nameInput = document.getElementById('typeName');
            
            if (price === '' || price === null) {
                priceInput.classList.remove('valid', 'error');
                priceHint.className = 'input-hint hint-info';
                priceHint.innerHTML = '<i class="fas fa-info-circle"></i> <span>Enter the price per night</span>';
                submitBtn.disabled = true;
                return;
            }
            
            const priceNum = parseFloat(price);
            
            if (isNaN(priceNum) || priceNum <= 0) {
                priceInput.classList.add('error');
                priceInput.classList.remove('valid');
                priceHint.className = 'input-hint hint-error';
                priceHint.innerHTML = '<i class="fas fa-exclamation-circle"></i> <span>Please enter a valid price greater than 0</span>';
                submitBtn.disabled = true;
            } else {
                priceInput.classList.add('valid');
                priceInput.classList.remove('error');
                priceHint.className = 'input-hint hint-success';
                priceHint.innerHTML = '<i class="fas fa-check-circle"></i> <span>Valid price</span>';
                
                // Enable submit if name is also valid
                if (nameInput.classList.contains('valid')) {
                    submitBtn.disabled = false;
                }
            }
        }
        
        // Form submission validation
        document.getElementById('addRoomTypeForm').addEventListener('submit', function(e) {
            const nameInput = document.getElementById('typeName');
            const priceInput = document.getElementById('pricePerNight');
            const submitBtn = document.getElementById('submitBtn');
            
            // Final validation before submit
            const name = nameInput.value.trim();
            
            if (!nameInput.classList.contains('valid')) {
                e.preventDefault();
                alert('Please enter a valid and unique room type name');
                return;
            }
            
            if (!priceInput.classList.contains('valid')) {
                e.preventDefault();
                alert('Please enter a valid price');
                return;
            }
            
            // Disable button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
        });
    </script>
</body>
</html>