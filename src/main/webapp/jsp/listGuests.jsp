<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Guest" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<Guest> guests = (List<Guest>) request.getAttribute("guests");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String searchType = (String) request.getAttribute("searchType");
    
    if (searchTerm == null) searchTerm = "";
    if (searchType == null) searchType = "name";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Management - Ocean View Resort</title>
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
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
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
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 2;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .search-select {
            flex: 1;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            background: white;
        }
        
        .search-btn {
            background: #2a5298;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        
        .reset-btn {
            background: #95a5a6;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 8px;
        }
        
        .message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        th {
            background: #f8fafd;
            color: #1e3c72;
            font-weight: 600;
            padding: 15px;
            text-align: left;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .action-btn {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
        }
        
        .btn-edit {
            background: #f39c12;
            color: white;
        }
        
        .btn-delete {
            background: #e74c3c;
            color: white;
        }
        
        .btn-view {
            background: #2a5298;
            color: white;
        }
        
        .btn-edit:hover {
            background: #e67e22;
        }
        
        .btn-delete:hover {
            background: #c0392b;
        }
        
        .no-data {
            text-align: center;
            padding: 30px;
            color: #7f8c8d;
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
        <div class="header">
            <h2><i class="fas fa-users"></i> Guest Management</h2>
            <a href="${pageContext.request.contextPath}/jsp/addGuest.jsp" class="btn-add">
                <i class="fas fa-plus"></i> Add New Guest
            </a>
        </div>
        
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/guest" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="searchTerm" class="search-input" 
                       placeholder="Search..." value="<%= searchTerm %>">
                <select name="searchType" class="search-select">
                    <option value="name" <%= "name".equals(searchType) ? "selected" : "" %>>Search by Name</option>
                    <option value="contact" <%= "contact".equals(searchType) ? "selected" : "" %>>Search by Contact</option>
                </select>
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i> Search
                </button>
                <a href="${pageContext.request.contextPath}/guest" class="reset-btn">
                    <i class="fas fa-redo"></i> Reset
                </a>
            </form>
        </div>
        
        <% if (message != null) { %>
            <div class="message"><i class="fas fa-check-circle"></i> <%= message %></div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% } %>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Guest Name</th>
                    <th>Address</th>
                    <th>Contact Number</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (guests != null && !guests.isEmpty()) {
                    for (Guest g : guests) { %>
                        <tr>
                            <td>#<%= g.getGuestId() %></td>
                            <td><strong><%= g.getGuestName() %></strong></td>
                            <td><%= g.getAddress() %></td>
                            <td><%= g.getContactNumber() %></td>
                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/guest?action=edit&id=<%= g.getGuestId() %>" 
                                   class="action-btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/guest?action=delete&id=<%= g.getGuestId() %>" 
                                   class="action-btn btn-delete"
                                   onclick="return confirm('Are you sure you want to delete <%= g.getGuestName() %>? This action cannot be undone.')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    <% }
                } else { %>
                    <tr>
                        <td colspan="5" class="no-data">
                            <i class="fas fa-user-slash" style="font-size: 40px; color: #ccc; margin-bottom: 10px; display: block;"></i>
                            No guests found. 
                            <a href="${pageContext.request.contextPath}/jsp/addGuest.jsp">Add your first guest!</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>