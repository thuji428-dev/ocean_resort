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
    <title>Help Guide - Ocean View Resort</title>
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
        }
        
        .help-header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            text-align: center;
        }
        
        .help-header h1 {
            color: #1e3c72;
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .help-header p {
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .search-box {
            max-width: 500px;
            margin: 20px auto 0;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 50px;
            font-size: 16px;
            padding-left: 50px;
            transition: all 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #2a5298;
            box-shadow: 0 5px 15px rgba(42, 82, 152, 0.2);
        }
        
        .search-box i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #2a5298;
            font-size: 18px;
        }
        
        .help-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .help-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .help-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .help-card.active {
            border: 2px solid #2a5298;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .card-header i {
            font-size: 30px;
        }
        
        .card-header h3 {
            font-size: 18px;
            font-weight: 600;
        }
        
        .card-content {
            padding: 20px;
        }
        
        .step-list {
            list-style: none;
        }
        
        .step-list li {
            padding: 10px 0;
            border-bottom: 1px solid #ecf0f1;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .step-list li:last-child {
            border-bottom: none;
        }
        
        .step-number {
            width: 25px;
            height: 25px;
            background: #2a5298;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
        }
        
        .tag {
            background: #e3f2fd;
            color: #1976d2;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .detailed-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .detailed-section h2 {
            color: #1e3c72;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .feature-box {
            background: #f8f9fa;
            border-left: 4px solid #2a5298;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .feature-box h4 {
            color: #2a5298;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .image-container {
            margin: 20px 0;
            text-align: center;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            background: white;
        }
        
        .feature-image {
            max-width: 100%;
            max-height: 400px;
            border-radius: 5px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .image-caption {
            margin-top: 10px;
            color: #7f8c8d;
            font-size: 13px;
            font-style: italic;
        }
        
        .status-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        .status-table th {
            background: #f8fafd;
            padding: 12px;
            text-align: left;
            color: #1e3c72;
        }
        
        .status-table td {
            padding: 12px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-booked {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .status-checkedin {
            background: #e8f5e9;
            color: #388e3c;
        }
        
        .status-checkedout {
            background: #ffebee;
            color: #c62828;
        }
        
        .tip-box {
            background: #e8f5e9;
            border-left: 4px solid #27ae60;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
        }
        
        .warning-box {
            background: #fff3e0;
            border-left: 4px solid #f39c12;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
        }
        
        .code-block {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 15px;
            border-radius: 8px;
            font-family: monospace;
            margin: 10px 0;
        }
        
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        
        .feature-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
            border: 1px solid #e9ecef;
        }
        
        .feature-item i {
            font-size: 30px;
            color: #2a5298;
            margin-bottom: 10px;
        }
        
        .print-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #2a5298;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            transition: all 0.3s;
            z-index: 100;
        }
        
        .print-btn:hover {
            background: #1e3c72;
            transform: scale(1.1);
        }
        
        .faq-section {
            margin-top: 30px;
        }
        
        .faq-item {
            border-bottom: 1px solid #ecf0f1;
            padding: 15px 0;
        }
        
        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            color: #1e3c72;
            font-weight: 600;
        }
        
        .faq-answer {
            padding-top: 10px;
            color: #7f8c8d;
            display: none;
        }
        
        .faq-answer.show {
            display: block;
        }
        
        .quick-tips {
            background: #e8f5e9;
            border-left: 4px solid #388e3c;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
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
            
            .help-grid {
                grid-template-columns: 1fr;
            }
            
            .feature-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>OCEAN VIEW <span>RESORT</span></h2>
        </div>
        
        <div class="admin-info">
            <div class="admin-avatar">
                <%= session.getAttribute("adminName") != null ? 
                    session.getAttribute("adminName").toString().charAt(0) : 'A' %>
            </div>
            <div class="admin-details">
                <h4><%= session.getAttribute("adminName") != null ? session.getAttribute("adminName") : "Admin" %></h4>
                <p>Administrator</p>
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/reservation?action=addForm" class="nav-link">
                    <i class="fas fa-calendar-plus"></i>
                    <span>Add Reservation</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/reservation" class="nav-link">
                    <i class="fas fa-list"></i>
                    <span>View Reservations</span>
                </a>
            </li>
          
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/guest" class="nav-link">
                    <i class="fas fa-users"></i>
                    <span>Guest Management</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/room-type" class="nav-link">
                    <i class="fas fa-bed"></i>
                    <span>Room Types</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/jsp/help.jsp" class="nav-link active">
                    <i class="fas fa-question-circle"></i>
                    <span>Help</span>
                </a>
            </li>
            <li class="nav-item logout-link">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="help-header">
            <h1><i class="fas fa-life-ring"></i> Complete System Guide</h1>
            <p>Everything you need to know about the Ocean View Resort Management System</p>
            
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="helpSearch" placeholder="Search help topics...">
            </div>
        </div>
        
        <!-- Quick Feature Overview -->
        <div class="feature-grid">
            <div class="feature-item">
                <i class="fas fa-bolt"></i>
                <h4>One-Click Checkout</h4>
                <p>Click Bill button - auto-sets checkout date</p>
            </div>
            <div class="feature-item">
                <i class="fas fa-search"></i>
                <h4>Smart Search</h4>
                <p>Search by name, phone, or reservation #</p>
            </div>
            <div class="feature-item">
                <i class="fas fa-filter"></i>
                <h4>Status Filters</h4>
                <p>Filter by BOOKED/CHECKED-IN/CHECKED-OUT</p>
            </div>
            <div class="feature-item">
                <i class="fas fa-calendar-check"></i>
                <h4>Auto Status</h4>
                <p>Status updates based on dates</p>
            </div>
            <div class="feature-item">
                <i class="fas fa-file-invoice"></i>
                <h4>Bill Printing</h4>
                <p>Professional invoice format</p>
            </div>
            <div class="feature-item">
                <i class="fas fa-users"></i>
                <h4>Guest Management</h4>
                <p>Unique contact numbers</p>
            </div>
        </div>
        
        <!-- Quick Help Cards -->
        <div class="help-grid" id="helpCards">
            <div class="help-card" data-topic="dashboard">
                <div class="card-header">
                    <i class="fas fa-home"></i>
                    <h3>Dashboard</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Real-time statistics</li>
                        <li><span class="step-number">2</span> Click stats to filter</li>
                        <li><span class="step-number">3</span> Quick actions</li>
                    </ul>
                </div>
            </div>
            
            <div class="help-card" data-topic="reservation-add">
                <div class="card-header">
                    <i class="fas fa-plus-circle"></i>
                    <h3>Add Reservation</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Select guest</li>
                        <li><span class="step-number">2</span> Choose room type</li>
                        <li><span class="step-number">3</span> Pick dates</li>
                        <li><span class="step-number">4</span> Auto-calculates total</li>
                    </ul>
                </div>
            </div>
            
            <div class="help-card" data-topic="reservation-list">
                <div class="card-header">
                    <i class="fas fa-list"></i>
                    <h3>Manage Reservations</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Search/filter</li>
                        <li><span class="step-number">2</span> Edit by status rules</li>
                        <li><span class="step-number">3</span> Delete (BOOKED only)</li>
                        <li><span class="step-number">4</span> One-click checkout</li>
                    </ul>
                </div>
            </div>
            
            <div class="help-card" data-topic="billing">
                <div class="card-header">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <h3>Billing System</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Click Bill button</li>
                        <li><span class="step-number">2</span> Confirm checkout</li>
                        <li><span class="step-number">3</span> Auto-sets today</li>
                        <li><span class="step-number">4</span> Print invoice</li>
                    </ul>
                </div>
            </div>
            
            <div class="help-card" data-topic="guest">
                <div class="card-header">
                    <i class="fas fa-user-plus"></i>
                    <h3>Guest Management</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Add new guest</li>
                        <li><span class="step-number">2</span> Edit details</li>
                        <li><span class="step-number">3</span> Search by name/phone</li>
                        <li><span class="step-number">4</span> Delete (no bookings)</li>
                    </ul>
                </div>
            </div>
            
            <div class="help-card" data-topic="room">
                <div class="card-header">
                    <i class="fas fa-bed"></i>
                    <h3>Room Types</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Add room category</li>
                        <li><span class="step-number">2</span> Set price</li>
                        <li><span class="step-number">3</span> Search by price range</li>
                        <li><span class="step-number">4</span> Edit/delete</li>
                    </ul>
                </div>
            </div>
        </div>
        
        <!-- Detailed Documentation -->
        <div class="detailed-section" id="detailedSection">
            <h2><i class="fas fa-book"></i> Complete System Documentation</h2>
            
            <!-- 1. User Authentication -->
            <div class="feature-box">
                <h4><i class="fas fa-lock"></i> 1. User Authentication</h4>
                
                <!-- Image for Login Page -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/login-screen.png" 
                         alt="Login Screen" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place login-screen.png here
                    </div>
                    <div class="image-caption">Figure 1: Admin Login Screen</div>
                </div>
                
                <ul style="margin-left: 20px;">
                    <li>Single admin account with secure password hashing (SHA-256)</li>
                    <li>Session timeout: 30 minutes of inactivity</li>
                    <li>Demo credentials: username: <strong>admin</strong>, password: <strong>admin123</strong></li>
                    <li>Click "Forgot Password?" to view credentials</li>
                </ul>
            </div>
            
            <!-- 2. Dashboard Overview -->
            <div class="feature-box">
                <h4><i class="fas fa-chart-line"></i> 2. Dashboard Overview</h4>
                
                <!-- Image for Dashboard -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/dashboard.png" 
                         alt="Dashboard" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place dashboard.png here
                    </div>
                    <div class="image-caption">Figure 2: Main Dashboard</div>
                </div>
                
                <ul style="margin-left: 20px;">
                    <li><strong>Statistics Cards:</strong> Total Rooms, Active Bookings, Check-ins Today, Revenue</li>
                    <li><strong>Click to Filter:</strong> Click on any stat card to filter reservations by that status</li>
                    <li><strong>Recent Reservations:</strong> Shows latest 10 reservations</li>
                    <li><strong>Quick Actions:</strong> Buttons for common tasks</li>
                </ul>
            </div>
            
            <!-- 3. Reservation Status Rules -->
            <div class="feature-box">
                <h4><i class="fas fa-tags"></i> 3. Reservation Status & Edit Rules</h4>
                <table class="status-table">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Description</th>
                            <th>Can Edit</th>
                            <th>Cannot Edit</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="status-badge status-booked">BOOKED</span></td>
                            <td>Future booking</td>
                            <td>✓ Room Type<br>✓ Check-in Date<br>✓ Check-out Date</td>
                            <td>✗ Guest Name</td>
                        </tr>
                        <tr>
                            <td><span class="status-badge status-checkedin">CHECKED-IN</span></td>
                            <td>Currently staying</td>
                            <td>✓ Check-out Date</td>
                            <td>✗ Guest<br>✗ Room Type<br>✗ Check-in Date</td>
                        </tr>
                        <tr>
                            <td><span class="status-badge status-checkedout">CHECKED-OUT</span></td>
                            <td>Already departed</td>
                            <td>-</td>
                            <td>✗ All fields (read-only)</td>
                        </tr>
                    </tbody>
                </table>
                <p><small>Note: Guest name is always fixed and cannot be changed for any status.</small></p>
            </div>
            
            <!-- 4. Adding New Reservations -->
            <div class="feature-box">
                <h4><i class="fas fa-plus-circle"></i> 4. Adding New Reservations</h4>
                
                <!-- Image for Add Reservation Form -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/add-reservation.png" 
                         alt="Add Reservation Form" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place add-reservation.png here
                    </div>
                    <div class="image-caption">Figure 3: Add Reservation Form</div>
                </div>
                
                <ol style="margin-left: 20px;">
                    <li>Click "Add Reservation" in sidebar</li>
                    <li>Select guest from dropdown (or click "Add new guest" if not found)</li>
                    <li>Choose room type (prices are pre-configured)</li>
                    <li>Select check-in and check-out dates:
                        <ul>
                            <li>Check-in cannot be in the past</li>
                            <li>Minimum 1 night stay required</li>
                            <li>Check-out must be after check-in</li>
                        </ul>
                    </li>
                    <li>System auto-calculates total amount</li>
                    <li>Status auto-assigned based on dates:
                        <ul>
                            <li>Future dates → <span class="status-badge status-booked">BOOKED</span></li>
                            <li>Today's date → <span class="status-badge status-checkedin">CHECKED-IN</span></li>
                        </ul>
                    </li>
                    <li>Click "Create Reservation" to save</li>
                </ol>
            </div>
            
            <!-- 5. Managing Reservations -->
            <div class="feature-box">
                <h4><i class="fas fa-tasks"></i> 5. Managing Reservations</h4>
                
                <!-- Image for Reservation List -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/reservation-list.png" 
                         alt="Reservation List" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place reservation-list.png here
                    </div>
                    <div class="image-caption">Figure 4: Reservation List with Search & Filters</div>
                </div>
                
                <h5 style="margin: 15px 0 10px;">🔍 Search & Filter</h5>
                <ul style="margin-left: 20px;">
                    <li><strong>Search:</strong> By guest name, phone number, or reservation number</li>
                    <li><strong>Note:</strong> Reservation numbers can be searched with or without the # symbol (e.g., both "#RES123" and "RES123" work)</li>
                    <li><strong>Filter:</strong> By status (ALL/BOOKED/CHECKED-IN/CHECKED-OUT)</li>
                    <li><strong>Click Stats:</strong> Click on stat cards to filter instantly</li>
                </ul>
                
                <h5 style="margin: 15px 0 10px;">✏️ Editing Reservations</h5>
                <ul style="margin-left: 20px;">
                    <li>Click "Edit" button for any reservation</li>
                    <li>Edit options depend on status (see table above)</li>
                    <li><strong>For BOOKED:</strong> Can change room type, check-in, check-out</li>
                    <li><strong>For CHECKED-IN:</strong> Can only change check-out date</li>
                    <li><strong>For CHECKED-OUT:</strong> Cannot edit (read-only)</li>
                    <li>Real-time price calculation updates as you change dates</li>
                </ul>
                
                <h5 style="margin: 15px 0 10px;">🗑️ Deleting Reservations</h5>
                <ul style="margin-left: 20px;">
                    <li>Only <span class="status-badge status-booked">BOOKED</span> reservations can be deleted</li>
                    <li>Delete button is disabled for CHECKED-IN and CHECKED-OUT</li>
                    <li>Confirmation dialog prevents accidental deletion</li>
                </ul>
            </div>
            
            <!-- 6. One-Click Billing System (⚡ New Feature) -->
            <div class="feature-box" style="border-left-color: #27ae60;">
                <h4><i class="fas fa-bolt" style="color: #27ae60;"></i> 6. One-Click Billing System (⚡ New Feature)</h4>
                
                <!-- Image for Bill Button -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/bill-button.png" 
                         alt="Bill Button" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place bill-button.png here
                    </div>
                    <div class="image-caption">Figure 5: Bill Button with ⚡ Icon</div>
                </div>
                
                <!-- Image for Bill Confirmation -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/bill-confirmation.png" 
                         alt="Bill Confirmation" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place bill-confirmation.png here
                    </div>
                    <div class="image-caption">Figure 6: Checkout Confirmation Dialog</div>
                </div>
                
                <!-- Image for Generated Bill -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/generated-bill.png" 
                         alt="Generated Bill" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place generated-bill.png here
                    </div>
                    <div class="image-caption">Figure 7: Generated Bill</div>
                </div>
                
                <div class="tip-box">
                    <strong>⚡ How it works:</strong> When a guest is ready to check out, simply click the Bill button!
                </div>
                
                <h5 style="margin: 15px 0 10px;">Step-by-Step Process:</h5>
                <ol style="margin-left: 20px;">
                    <li>Navigate to "View Reservations"</li>
                    <li>Find the CHECKED-IN reservation</li>
                    <li>Click the <strong style="background: #27ae60; color: white; padding: 2px 8px; border-radius: 3px;">Bill⚡</strong> button</li>
                    <li>Confirmation dialog appears: "Is guest checking out TODAY?"</li>
                    <li>Click "Yes, Checkout Today"</li>
                </ol>
                
                <h5 style="margin: 15px 0 10px;">What happens automatically:</h5>
                <ul style="margin-left: 20px;">
                    <li>✅ Actual checkout date is set to <strong>today's date</strong></li>
                    <li>✅ Nights calculated correctly (minimum 1 night for same-day checkout)</li>
                    <li>✅ Status updates to <span class="status-badge status-checkedout">CHECKED-OUT</span></li>
                    <li>✅ Bill generated with correct amount</li>
                    <li>✅ Bill displayed in professional format</li>
                </ul>
                
                <div class="warning-box">
                    <strong>📌 Important:</strong> You do NOT need to manually edit the checkout date! The system handles everything automatically, including early checkout calculations.
                </div>
                
                <h5 style="margin: 15px 0 10px;">Early Checkout Example:</h5>
                <div class="code-block">
                    Check-in: 2026-03-04<br>
                    Planned Checkout: 2026-03-06<br>
                    Today: 2026-03-04 (early checkout)<br>
                    → Bill calculates: 1 night<br>
                    → Amount: 1 × room price
                </div>
            </div>
            
            <!-- 7. Guest Management -->
            <div class="feature-box">
                <h4><i class="fas fa-users"></i> 7. Guest Management</h4>
                
                <!-- Image for Guest List -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/guest-list.png" 
                         alt="Guest List" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place guest-list.png here
                    </div>
                    <div class="image-caption">Figure 8: Guest Management</div>
                </div>
                
                <ul style="margin-left: 20px;">
                    <li><strong>Add Guest:</strong> Enter name, address, and contact number</li>
                    <li><strong>Validation:</strong> Contact numbers must be unique (no duplicates)</li>
                    <li><strong>Search:</strong> By name or phone number (partial matches work)</li>
                    <li><strong>Edit:</strong> Update guest details</li>
                    <li><strong>Delete:</strong> Only possible if guest has no reservations</li>
                    <li><strong>History:</strong> View all bookings for a guest</li>
                </ul>
            </div>
            
            <!-- 8. Room Type Management -->
            <div class="feature-box">
                <h4><i class="fas fa-bed"></i> 8. Room Type Management</h4>
                
                <!-- Image for Room Types -->
                <div class="image-container">
                    <img src="${pageContext.request.contextPath}/jsp/includes/images/room-types.png" 
                         alt="Room Types" 
                         class="feature-image"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                    <div style="display:none; padding:20px; background:#f8f9fa; border:1px dashed #ccc;">
                        <i class="fas fa-image"></i> Place room-types.png here
                    </div>
                    <div class="image-caption">Figure 9: Room Type Management</div>
                </div>
                
                <ul style="margin-left: 20px;">
                    <li><strong>Add Room Type:</strong> Enter unique name and price per night</li>
                    <li><strong>Validation Rules:</strong>
                        <ul>
                            <li>Name must be at least 5 characters</li>
                            <li>Must contain at least 2 letters</li>
                            <li>Can include letters, numbers, spaces, hyphens, apostrophes</li>
                            <li>Price must be greater than 0</li>
                        </ul>
                    </li>
                    <li><strong>Search:</strong> By name or price range</li>
                    <li><strong>Price Range Search:</strong> 
                        <ul>
                            <li>Min only: shows rooms ≥ price</li>
                            <li>Max only: shows rooms ≤ price</li>
                            <li>Both: shows rooms between min and max</li>
                        </ul>
                    </li>
                    <li><strong>Edit/Delete:</strong> Update prices or delete unused room types</li>
                </ul>
            </div>
            
            <!-- Search Tips -->
            <div class="tip-box">
                <h4><i class="fas fa-search"></i> Search Tips</h4>
                <ul>
                    <li><strong>Reservation Numbers:</strong> Works with or without # symbol</li>
                    <li><strong>Phone Numbers:</strong> Search partial numbers (e.g., "077" finds all starting with 077)</li>
                    <li><strong>Guest Names:</strong> Case-insensitive partial matching</li>
                    <li><strong>Price Range:</strong> Leave one field empty for min/max only searches</li>
                </ul>
            </div>
            
            <!-- FAQ -->
            <div class="faq-section">
                <h3 style="color: #1e3c72; margin: 30px 0 15px;">❓ Frequently Asked Questions</h3>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I handle early checkout?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Simply click the <strong>Bill button (⚡)</strong>! The system automatically sets today's date as checkout, calculates the correct nights (minimum 1), and generates the bill. No manual editing needed!
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Why can't I edit the guest name?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Guest names are fixed to maintain data integrity and booking history. If you need to change a guest's name, you can edit it in the Guest Management section.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How are nights calculated for same-day checkout?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        If a guest checks in and out on the same day, they are charged for <strong>1 night</strong>. The system automatically handles this when you click the Bill button.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Can I search by reservation number with the # symbol?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Yes! You can search with or without the # symbol. For example, both "#RES20260304-E433" and "RES20260304-E433" will work.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        What's the difference between BOOKED and CHECKED-IN?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <strong>BOOKED:</strong> Future reservation (check-in date is in the future)<br>
                        <strong>CHECKED-IN:</strong> Guest is currently staying (check-in date is today or past, but check-out is future)
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I generate a bill for a past reservation?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Go to View Reservations, find the CHECKED-OUT reservation, and click the "Print" button to view/reprint the bill.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Can I delete a guest with existing reservations?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        No, guests with booking history cannot be deleted to maintain data integrity. You can only delete guests with no reservations.
                    </div>
                </div>
            </div>
            
            <!-- Pro Tips -->
            <div class="quick-tips">
                <h4><i class="fas fa-lightbulb"></i> Pro Tips</h4>
                <ul>
                    <li><i class="fas fa-check"></i> <strong>⚡ Bill Button:</strong> One-click checkout - no need to manually edit dates!</li>
                    <li><i class="fas fa-check"></i> <strong>🎯 Click Stats:</strong> Click on stat cards to instantly filter reservations</li>
                    <li><i class="fas fa-check"></i> <strong>🔍 Search:</strong> Works with or without # for reservation numbers</li>
                    <li><i class="fas fa-check"></i> <strong>📅 Same-Day:</strong> System automatically charges 1 night for same-day checkout</li>
                    <li><i class="fas fa-check"></i> <strong>💰 Billing:</strong> Bills show room charges only - no taxes</li>
                    <li><i class="fas fa-check"></i> <strong>🔄 Status Colors:</strong> Blue = BOOKED, Green = CHECKED-IN, Red = CHECKED-OUT</li>
                </ul>
            </div>
        </div>
        
        <!-- Print Button -->
        <div class="print-btn" onclick="window.print()">
            <i class="fas fa-print"></i>
        </div>
    </div>
    
    <script>
        // FAQ Toggle
        function toggleFaq(element) {
            const answer = element.nextElementSibling;
            const icon = element.querySelector('i');
            
            if (answer.classList.contains('show')) {
                answer.classList.remove('show');
                icon.className = 'fas fa-chevron-down';
            } else {
                answer.classList.add('show');
                icon.className = 'fas fa-chevron-up';
            }
        }
        
        // Search functionality
        document.getElementById('helpSearch').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            
            document.querySelectorAll('.help-card').forEach(card => {
                const title = card.querySelector('h3').textContent.toLowerCase();
                const steps = Array.from(card.querySelectorAll('.step-list li')).map(li => li.textContent.toLowerCase());
                
                const matches = title.includes(searchTerm) || steps.some(step => step.includes(searchTerm));
                
                if (searchTerm === '' || matches) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>