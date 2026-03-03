<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%
    // Check if this page was accessed directly (without going through servlet)
    if (request.getAttribute("stats") == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
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
        
        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
            width: calc(100% - 280px);
            background-color: #f4f7fc;
            min-height: 100vh;
        }
        
        /* Top Bar */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .top-bar h1 {
            color: #1e3c72;
            font-size: 24px;
            font-weight: 600;
        }
        
        .top-bar p {
            color: #7f8c8d;
            font-size: 14px;
            margin-top: 5px;
        }
        
        .top-bar .date {
            color: #1e3c72;
            font-weight: 600;
            font-size: 16px;
        }
        
        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .welcome-banner h2 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .stat-card h3 {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .stat-card h3 i {
            margin-right: 8px;
            color: #2a5298;
        }
        
        .stat-card .value {
            font-size: 32px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 5px;
        }
        
        .stat-card .sub-text {
            font-size: 12px;
            color: #27ae60;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-top: 30px;
        }
        
        .action-btn {
            background: white;
            padding: 20px;
            text-align: center;
            border-radius: 12px;
            text-decoration: none;
            color: #1e3c72;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        
        .action-btn i {
            font-size: 24px;
            color: #2a5298;
        }
        
        .action-btn:hover {
            background: #2a5298;
            color: white;
            transform: translateY(-5px);
        }
        
        .action-btn:hover i {
            color: white;
        }
        
        /* Responsive */
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
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="includes/navbar.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>
    
    <!-- Main Content -->
    <div class="main-content">
        <% 
            com.oceanview.model.DashboardStats dashboardStats = (com.oceanview.model.DashboardStats) request.getAttribute("stats");
            String currentDate = (String) request.getAttribute("currentDate");
        %>
        
        <!-- Top Bar -->
        <div class="top-bar">
            <div>
                <h1>Dashboard</h1>
                <p>Welcome back, <strong><%= session.getAttribute("adminName") != null ? session.getAttribute("adminName") : "Admin" %></strong>!</p>
            </div>
            <div class="date">
                <i class="fas fa-calendar-alt"></i> <%= currentDate != null ? currentDate : "" %>
            </div>
        </div>
        
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <h2>Welcome to Ocean View Resort</h2>
            <p>Here's what's happening at your resort today.</p>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="fas fa-hotel"></i> ROOM TYPES</h3>
                <div class="value"><%= dashboardStats.getTotalRooms() %></div>
                <div class="sub-text"><i class="fas fa-tag"></i> Different room categories</div>
            </div>
            
            <div class="stat-card">
                <h3><i class="fas fa-users"></i> REGISTERED GUESTS</h3>
                <div class="value"><%= dashboardStats.getTotalGuests() %></div>
                <div class="sub-text"><i class="fas fa-user-check"></i> Total users</div>
            </div>
            
            <div class="stat-card">
                <h3><i class="fas fa-calendar-check"></i> ACTIVE BOOKINGS</h3>
                <div class="value"><%= dashboardStats.getActiveBookings() %></div>
                <div class="sub-text"><i class="fas fa-clock"></i> Current reservations</div>
            </div>
            
            <div class="stat-card">
                <h3><i class="fas fa-dollar-sign"></i> MONTHLY REVENUE</h3>
                <div class="value">LKR <%= String.format("%,.0f", dashboardStats.getMonthlyRevenue()) %></div>
                <div class="sub-text"><i class="fas fa-chart-line"></i> This month</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/jsp/addGuest.jsp" class="action-btn">
                <i class="fas fa-user-plus"></i>
                <span>Add Guest</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/addRoomType.jsp" class="action-btn">
                <i class="fas fa-bed"></i>
                <span>Add Room Type</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/help.jsp" class="action-btn">
                <i class="fas fa-question-circle"></i>
                <span>Help</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="action-btn">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>
</body>
</html>