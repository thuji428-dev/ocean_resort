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
        
        .screenshot-placeholder {
            background: #f8f9fa;
            border: 2px dashed #2a5298;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            margin: 20px 0;
            position: relative;
        }
        
        .screenshot-placeholder i {
            font-size: 50px;
            color: #2a5298;
            margin-bottom: 15px;
        }
        
        .screenshot-placeholder p {
            color: #7f8c8d;
            margin-bottom: 15px;
        }
        
        .mock-screen {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 100%;
            overflow-x: auto;
        }
        
        .mock-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        
        .mock-table th {
            background: #f8fafd;
            padding: 8px;
            text-align: left;
        }
        
        .mock-table td {
            padding: 8px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .mock-button {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 10px;
            margin: 2px;
        }
        
        .btn-edit-mock {
            background: #f39c12;
            color: white;
        }
        
        .btn-delete-mock {
            background: #e74c3c;
            color: white;
        }
        
        .btn-bill-mock {
            background: #27ae60;
            color: white;
        }
        
        .status-mock {
            padding: 3px 6px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 600;
        }
        
        .status-BOOKED-mock {
            background: #e3f2fd;
            color: #1976d2;
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
        
        .video-placeholder {
            background: #1e3c72;
            color: white;
            padding: 60px;
            text-align: center;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .video-placeholder i {
            font-size: 60px;
            margin-bottom: 15px;
            color: #ffd700;
        }
        
        .quick-tips {
            background: #e8f5e9;
            border-left: 4px solid #388e3c;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .quick-tips h4 {
            color: #388e3c;
            margin-bottom: 10px;
        }
        
        .quick-tips ul {
            list-style: none;
        }
        
        .quick-tips li {
            padding: 5px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quick-tips i {
            color: #388e3c;
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
        
        @media print {
            .sidebar, .print-btn, .search-box, .help-grid {
                display: none;
            }
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            .detailed-section {
                break-inside: avoid;
            }
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
                <a href="${pageContext.request.contextPath}/bill?action=list" class="nav-link">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <span>Bills</span>
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
            <h1><i class="fas fa-life-ring"></i> Help & Support Guide</h1>
            <p>Learn how to use the Ocean View Resort Management System effectively</p>
            
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="helpSearch" placeholder="Search help topics...">
            </div>
        </div>
        
        <!-- Quick Help Cards -->
        <div class="help-grid" id="helpCards">
            <div class="help-card" data-topic="dashboard">
                <div class="card-header">
                    <i class="fas fa-home"></i>
                    <h3>Dashboard Overview</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> View key statistics</li>
                        <li><span class="step-number">2</span> Monitor room occupancy</li>
                        <li><span class="step-number">3</span> Check today's revenue</li>
                        <li><span class="step-number">4</span> Access quick actions</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">Quick Stats</span>
                        <span class="tag">Analytics</span>
                    </div>
                </div>
            </div>
            
            <div class="help-card" data-topic="reservation">
                <div class="card-header">
                    <i class="fas fa-calendar-plus"></i>
                    <h3>Add Reservation</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Select guest from list</li>
                        <li><span class="step-number">2</span> Choose room type</li>
                        <li><span class="step-number">3</span> Pick check-in/out dates</li>
                        <li><span class="step-number">4</span> System auto-calculates total</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">New Booking</span>
                        <span class="tag">Auto Status</span>
                    </div>
                </div>
            </div>
            
            <div class="help-card" data-topic="manage">
                <div class="card-header">
                    <i class="fas fa-list"></i>
                    <h3>Manage Reservations</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Search by guest/phone</li>
                        <li><span class="step-number">2</span> Filter by status</li>
                        <li><span class="step-number">3</span> Edit or delete bookings</li>
                        <li><span class="step-number">4</span> Generate bills</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">Search</span>
                        <span class="tag">Filter</span>
                        <span class="tag">Edit</span>
                    </div>
                </div>
            </div>
            
            <div class="help-card" data-topic="billing">
                <div class="card-header">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <h3>Billing</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Auto-calculate bill amount</li>
                        <li><span class="step-number">2</span> Print professional invoice</li>
                        <li><span class="step-number">3</span> Early checkout adjustments</li>
                        <li><span class="step-number">4</span> View bill history</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">Print</span>
                        <span class="tag">PDF</span>
                        <span class="tag">Tax</span>
                    </div>
                </div>
            </div>
            
            <div class="help-card" data-topic="guest">
                <div class="card-header">
                    <i class="fas fa-users"></i>
                    <h3>Guest Management</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Add new guests</li>
                        <li><span class="step-number">2</span> Edit guest details</li>
                        <li><span class="step-number">3</span> Search by name/phone</li>
                        <li><span class="step-number">4</span> View guest history</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">Contact</span>
                        <span class="tag">Address</span>
                    </div>
                </div>
            </div>
            
            <div class="help-card" data-topic="room">
                <div class="card-header">
                    <i class="fas fa-bed"></i>
                    <h3>Room Types</h3>
                </div>
                <div class="card-content">
                    <ul class="step-list">
                        <li><span class="step-number">1</span> Add room categories</li>
                        <li><span class="step-number">2</span> Set price per night</li>
                        <li><span class="step-number">3</span> Edit/delete room types</li>
                        <li><span class="step-number">4</span> View all room types</li>
                    </ul>
                    <div style="margin-top: 15px;">
                        <span class="tag">Pricing</span>
                        <span class="tag">Categories</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Detailed Section (Changes based on selection) -->
        <div class="detailed-section" id="detailedSection">
            <h2 id="detailTitle"><i class="fas fa-home"></i> Dashboard Overview</h2>
            
            <!-- Screenshot Placeholder -->
            <div class="screenshot-placeholder" id="screenshotPlaceholder">
                <i class="fas fa-camera"></i>
                <p>Screenshot of Dashboard will be displayed here</p>
                <div class="mock-screen">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                        <div><strong>Dashboard</strong></div>
                        <div>📅 March 03, 2026</div>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 20px;">
                        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            <div style="color: #666;">Total Rooms</div>
                            <div style="font-size: 24px; font-weight: bold;">8</div>
                        </div>
                        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            <div style="color: #666;">Active Bookings</div>
                            <div style="font-size: 24px; font-weight: bold;">14</div>
                        </div>
                        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            <div style="color: #666;">Check-ins Today</div>
                            <div style="font-size: 24px; font-weight: bold;">3</div>
                        </div>
                        <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                            <div style="color: #666;">Revenue</div>
                            <div style="font-size: 24px; font-weight: bold;">LKR 25k</div>
                        </div>
                    </div>
                    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                        <div style="font-weight: bold; margin-bottom: 10px;">Recent Reservations</div>
                        <table class="mock-table">
                            <tr><th>#</th><th>Guest</th><th>Room</th><th>Status</th></tr>
                            <tr><td>RES001</td><td>John Doe</td><td>Deluxe</td><td><span class="status-mock status-BOOKED-mock">BOOKED</span></td></tr>
                            <tr><td>RES002</td><td>Jane Smith</td><td>Suite</td><td><span class="status-mock status-CHECKED-IN-mock">CHECKED-IN</span></td></tr>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Step-by-step instructions -->
            <div id="instructions">
                <h3 style="color: #1e3c72; margin: 20px 0 10px;">📋 Step-by-Step Guide</h3>
                <ol style="padding-left: 20px; line-height: 1.8;">
                    <li><strong>Login:</strong> Use your admin credentials to access the system</li>
                    <li><strong>Dashboard Overview:</strong> The dashboard shows key metrics:
                        <ul style="margin-left: 20px; margin-top: 5px;">
                            <li>Total rooms and their current status</li>
                            <li>Active bookings count</li>
                            <li>Today's check-ins and check-outs</li>
                            <li>Revenue summary</li>
                        </ul>
                    </li>
                    <li><strong>Quick Actions:</strong> Use the buttons below stats for common tasks</li>
                    <li><strong>Navigation:</strong> Use sidebar to access different modules</li>
                </ol>
            </div>
            
            <!-- Quick Tips -->
            <div class="quick-tips">
                <h4><i class="fas fa-lightbulb"></i> Pro Tips</h4>
                <ul>
                    <li><i class="fas fa-check"></i> Click on stat cards to filter reservations by status</li>
                    <li><i class="fas fa-check"></i> Use the search box to quickly find reservations</li>
                    <li><i class="fas fa-check"></i> Dashboard auto-refresh every 30 seconds</li>
                </ul>
            </div>
            
            <!-- FAQ -->
            <div class="faq-section">
                <h3 style="color: #1e3c72; margin-bottom: 15px;">❓ Frequently Asked Questions</h3>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I add a new reservation?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Click "Add Reservation" in sidebar → Select guest → Choose room type → Pick dates → Click "Create Reservation". System auto-assigns status based on dates.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I handle early checkout?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Go to "View Reservations" → Find the guest → Click "Edit" → Set "Actual Checkout Date" → System recalculates amount and updates status to CHECKED-OUT.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I generate a bill?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        For CHECKED-IN or CHECKED-OUT reservations, click "Bill" button → System generates invoice → Click "Print" to save as PDF.
                    </div>
                </div>
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
        
        // Help Cards Data
        const helpData = {
            dashboard: {
                title: 'Dashboard Overview',
                icon: 'fa-home',
                steps: [
                    'Login with your admin credentials',
                    'View key statistics at a glance',
                    'Monitor room occupancy in real-time',
                    'Check today\'s revenue and check-ins',
                    'Access quick actions for common tasks'
                ],
                tips: [
                    'Click on stat cards to filter reservations',
                    'Dashboard auto-refreshes every 30 seconds',
                    'Use the search to find specific data'
                ],
                faq: [
                    { q: 'What do the colors mean?', a: 'Green = CHECKED-IN, Blue = BOOKED, Red = CHECKED-OUT' },
                    { q: 'How often does data update?', a: 'Real-time updates from database' }
                ]
            },
            reservation: {
                title: 'Add New Reservation',
                icon: 'fa-calendar-plus',
                steps: [
                    'Click "Add Reservation" from sidebar',
                    'Select guest from dropdown (or add new guest)',
                    'Choose room type and price per night',
                    'Select check-in and check-out dates',
                    'System auto-calculates total amount',
                    'Click "Create Reservation" to save'
                ],
                tips: [
                    'Check-in date cannot be in the past',
                    'Minimum 1 night stay required',
                    'Status auto-assigns based on dates'
                ],
                faq: [
                    { q: 'What if guest not in list?', a: 'Click "Add new guest" link below dropdown' },
                    { q: 'How is status determined?', a: 'Future dates = BOOKED, Today = CHECKED-IN' }
                ]
            },
            manage: {
                title: 'Manage Reservations',
                icon: 'fa-list',
                steps: [
                    'Go to "View Reservations" from sidebar',
                    'Use search box to find by name/phone',
                    'Filter by status using dropdown',
                    'Click "Edit" to modify reservation',
                    'Click "Delete" only for BOOKED status',
                    'Click "Bill" to generate invoice'
                ],
                tips: [
                    'Different buttons appear based on status',
                    'Use status filter to see specific bookings',
                    'Early checkout available for CHECKED-IN'
                ],
                faq: [
                    { q: 'Why can\'t I delete some reservations?', a: 'Only BOOKED status can be deleted' },
                    { q: 'How to handle early checkout?', a: 'Edit reservation and set actual checkout date' }
                ]
            },
            billing: {
                title: 'Billing System',
                icon: 'fa-file-invoice-dollar',
                steps: [
                    'Click "Bill" button for any reservation',
                    'System auto-calculates nights and amount',
                    'View detailed bill with taxes',
                    'Click "Print" to save or print',
                    'Bill automatically saved in database'
                ],
                tips: [
                    'Bills include 10% service charge',
                    '12% tax automatically added',
                    'Early checkout adjustments auto-calculated'
                ],
                faq: [
                    { q: 'Can I print old bills?', a: 'Yes, click "Print Bill" for any checked-out reservation' },
                    { q: 'What if guest checks out early?', a: 'System adjusts amount based on actual checkout' }
                ]
            },
            guest: {
                title: 'Guest Management',
                icon: 'fa-users',
                steps: [
                    'Go to "Guest Management" from sidebar',
                    'View all registered guests',
                    'Search by name or phone number',
                    'Add new guest with contact details',
                    'Edit or delete guest information'
                ],
                tips: [
                    'Phone numbers must be unique',
                    'Can\'t delete guests with reservations',
                    'View guest booking history'
                ],
                faq: [
                    { q: 'Why can\'t I delete a guest?', a: 'Guest has existing reservations' },
                    { q: 'How to add new guest quickly?', a: 'Use "Add Guest" button or from reservation form' }
                ]
            },
            room: {
                title: 'Room Type Management',
                icon: 'fa-bed',
                steps: [
                    'Go to "Room Types" from sidebar',
                    'View all room categories and prices',
                    'Add new room type with name and price',
                    'Edit existing room details',
                    'Delete unused room types'
                ],
                tips: [
                    'Room names must be unique',
                    'Prices can be updated anytime',
                    'Can\'t delete room types with reservations'
                ],
                faq: [
                    { q: 'How to change room price?', a: 'Click "Edit" next to room type and update price' },
                    { q: 'Can I have multiple same room types?', a: 'No, each room type is unique category' }
                ]
            }
        };
        
        // Update detailed section based on selected card
        document.querySelectorAll('.help-card').forEach(card => {
            card.addEventListener('click', function() {
                // Remove active class from all cards
                document.querySelectorAll('.help-card').forEach(c => c.classList.remove('active'));
                
                // Add active class to clicked card
                this.classList.add('active');
                
                // Get topic
                const topic = this.dataset.topic;
                const data = helpData[topic];
                
                if (data) {
                    // Update title
                    document.getElementById('detailTitle').innerHTML = `<i class="fas ${data.icon}"></i> ${data.title}`;
                    
                    // Update steps
                    let stepsHtml = '<h3 style="color: #1e3c72; margin: 20px 0 10px;">📋 Step-by-Step Guide</h3><ol style="padding-left: 20px; line-height: 1.8;">';
                    data.steps.forEach(step => {
                        stepsHtml += `<li>${step}</li>`;
                    });
                    stepsHtml += '</ol>';
                    
                    // Update tips
                    let tipsHtml = '<div class="quick-tips"><h4><i class="fas fa-lightbulb"></i> Pro Tips</h4><ul>';
                    data.tips.forEach(tip => {
                        tipsHtml += `<li><i class="fas fa-check"></i> ${tip}</li>`;
                    });
                    tipsHtml += '</ul></div>';
                    
                    // Update FAQ
                    let faqHtml = '<div class="faq-section"><h3 style="color: #1e3c72; margin-bottom: 15px;">❓ Frequently Asked Questions</h3>';
                    data.faq.forEach(item => {
                        faqHtml += `
                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleFaq(this)">
                                    ${item.q}
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer">${item.a}</div>
                            </div>
                        `;
                    });
                    faqHtml += '</div>';
                    
                    // Update instructions div
                    document.getElementById('instructions').innerHTML = stepsHtml + tipsHtml;
                    
                    // Update FAQ section
                    document.querySelector('.faq-section').innerHTML = faqHtml;
                    
                    // Update screenshot placeholder based on topic
                    updateScreenshot(topic);
                }
            });
        });
        
        // Update screenshot based on topic
        function updateScreenshot(topic) {
            const placeholder = document.getElementById('screenshotPlaceholder');
            
            let mockHtml = '<i class="fas fa-camera"></i><p>Screenshot of ' + topic + ' will be displayed here</p>';
            
            if (topic === 'dashboard') {
                mockHtml = `
                    <i class="fas fa-camera"></i>
                    <p>Dashboard Screenshot</p>
                    <div class="mock-screen">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                            <div><strong>Dashboard</strong></div>
                            <div>📅 March 03, 2026</div>
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 20px;">
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                <div style="color: #666;">Total Rooms</div>
                                <div style="font-size: 24px; font-weight: bold;">8</div>
                            </div>
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                <div style="color: #666;">Active Bookings</div>
                                <div style="font-size: 24px; font-weight: bold;">14</div>
                            </div>
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                <div style="color: #666;">Check-ins Today</div>
                                <div style="font-size: 24px; font-weight: bold;">3</div>
                            </div>
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                <div style="color: #666;">Revenue</div>
                                <div style="font-size: 24px; font-weight: bold;">LKR 25k</div>
                            </div>
                        </div>
                    </div>
                `;
            } else if (topic === 'reservation') {
                mockHtml = `
                    <i class="fas fa-camera"></i>
                    <p>Add Reservation Form Screenshot</p>
                    <div class="mock-screen">
                        <div style="margin-bottom: 15px;"><strong>➕ Add New Reservation</strong></div>
                        <div style="margin-bottom: 10px;">👤 Guest: John Doe [▼]</div>
                        <div style="margin-bottom: 10px;">🛏️ Room: Deluxe Ocean View [▼]</div>
                        <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                            <div>📅 Check-in: 2026-03-15</div>
                            <div>📅 Check-out: 2026-03-18</div>
                        </div>
                        <div style="background: #e3f2fd; padding: 10px; border-radius: 5px;">
                            Total: LKR 45,000 (3 nights)
                        </div>
                        <div style="background: #2a5298; color: white; padding: 10px; text-align: center; margin-top: 10px; border-radius: 5px;">
                            Create Reservation
                        </div>
                    </div>
                `;
            } else if (topic === 'manage') {
                mockHtml = `
                    <i class="fas fa-camera"></i>
                    <p>Reservation List Screenshot</p>
                    <div class="mock-screen">
                        <table class="mock-table">
                            <tr><th>#</th><th>Guest</th><th>Room</th><th>Status</th><th>Actions</th></tr>
                            <tr>
                                <td>RES001</td>
                                <td>John Doe</td>
                                <td>Deluxe</td>
                                <td><span class="status-mock status-BOOKED-mock">BOOKED</span></td>
                                <td>
                                    <span class="mock-button btn-edit-mock">Edit</span>
                                    <span class="mock-button btn-delete-mock">Delete</span>
                                    <span class="mock-button btn-bill-mock">Bill</span>
                                </td>
                            </tr>
                            <tr>
                                <td>RES002</td>
                                <td>Jane Smith</td>
                                <td>Suite</td>
                                <td><span class="status-mock status-CHECKED-IN-mock">CHECKED-IN</span></td>
                                <td>
                                    <span class="mock-button btn-edit-mock">Edit</span>
                                    <span class="mock-button btn-delete-mock btn-disabled">Delete</span>
                                    <span class="mock-button btn-bill-mock">Bill</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                `;
            }
            
            placeholder.innerHTML = mockHtml;
        }
        
        // Search functionality
        document.getElementById('helpSearch').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            
            document.querySelectorAll('.help-card').forEach(card => {
                const topic = card.dataset.topic;
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
        
        // Initialize with dashboard view
        document.querySelector('[data-topic="dashboard"]').classList.add('active');
    </script>
</body>
</html>