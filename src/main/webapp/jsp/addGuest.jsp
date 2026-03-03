<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Guest - Ocean View Resort</title>
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
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 500;
        }
        
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .form-group input.error, .form-group textarea.error {
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
        
        .btn-submit:hover {
            background: #1e3c72;
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
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
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
        }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp">
        <jsp:param name="activePage" value="guest" />
    </jsp:include>
    
    <div class="main-content">
        <div class="form-container">
            <h2>
                <i class="fas fa-user-plus" style="color: #2a5298;"></i> 
                Add New Guest
            </h2>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> 
                    <% if ("exists".equals(request.getParameter("error"))) { %>
                        Contact number already exists! Please use a different number.
                    <% } else { %>
                        Error adding guest. Please try again.
                    <% } %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/guest" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="guestName">
                        <i class="fas fa-user"></i> Guest Name
                    </label>
                    <input type="text" id="guestName" name="guestName" required 
                           placeholder="Enter guest full name">
                </div>
                
                <div class="form-group">
                    <label for="address">
                        <i class="fas fa-map-marker-alt"></i> Address
                    </label>
                    <textarea id="address" name="address" required 
                              placeholder="Enter guest address"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="contactNumber">
                        <i class="fas fa-phone"></i> Contact Number
                    </label>
                    <input type="tel" id="contactNumber" name="contactNumber" required 
                           placeholder="e.g., 0771234567" 
                           pattern="[0-9]{10}" 
                           title="Please enter a valid 10-digit Sri Lankan phone number">
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> Add Guest
                </button>
            </form>
            
            <a href="${pageContext.request.contextPath}/guest" class="btn-view">
                <i class="fas fa-list"></i> View All Guests
            </a>
        </div>
    </div>
</body>
</html>