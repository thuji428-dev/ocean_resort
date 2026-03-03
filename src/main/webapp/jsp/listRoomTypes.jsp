<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.RoomType" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String searchType = (String) request.getAttribute("searchType");
    String minPrice = (String) request.getAttribute("minPrice");
    String maxPrice = (String) request.getAttribute("maxPrice");
    
    if (searchTerm == null) searchTerm = "";
    if (searchType == null) searchType = "name";
    if (minPrice == null) minPrice = "";
    if (maxPrice == null) maxPrice = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Types - Ocean View Resort</title>
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
        
        /* Search Box */
        .search-container {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .search-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 10px;
        }
        
        .search-tab {
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .search-tab.active {
            background: #2a5298;
            color: white;
        }
        
        .search-tab:not(.active):hover {
            background: #e3f2fd;
            color: #1e3c72;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 2;
            padding: 12px;
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
        
        .price-range {
            display: flex;
            gap: 10px;
            align-items: center;
            flex: 3;
            flex-wrap: wrap;
        }
        
        .price-input {
            flex: 1;
            min-width: 120px;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .price-input:focus {
            outline: none;
            border-color: #2a5298;
        }
        
        .price-separator {
            color: #7f8c8d;
            font-weight: bold;
            font-size: 16px;
        }
        
        .search-actions {
            display: flex;
            gap: 10px;
            margin-left: auto;
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
        
        .no-data a {
            color: #2a5298;
            text-decoration: none;
        }
        
        .no-data a:hover {
            text-decoration: underline;
        }
        
        .price-tag {
            font-weight: bold;
            color: #27ae60;
        }
        
        .search-hint {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .active-filter {
            background: #e3f2fd;
            padding: 5px 10px;
            border-radius: 20px;
            display: inline-block;
            margin-right: 10px;
            margin-bottom: 10px;
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
            
            .search-form {
                flex-direction: column;
            }
            
            .price-range {
                width: 100%;
            }
            
            .search-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .search-btn, .reset-btn {
                flex: 1;
                justify-content: center;
            }
            
            .search-tabs {
                justify-content: center;
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
        <div class="header">
            <h2><i class="fas fa-bed"></i> Room Types Management</h2>
            <a href="${pageContext.request.contextPath}/jsp/addRoomType.jsp" class="btn-add">
                <i class="fas fa-plus"></i> Add New Room Type
            </a>
        </div>
        
        <!-- Search Box with Tabs -->
        <div class="search-container">
            <div class="search-tabs">
                <span class="search-tab <%= "name".equals(searchType) ? "active" : "" %>" onclick="setSearchType('name')">
                    <i class="fas fa-font"></i> Search by Name
                </span>
                <span class="search-tab <%= "price".equals(searchType) ? "active" : "" %>" onclick="setSearchType('price')">
                    <i class="fas fa-dollar-sign"></i> Search by Price Range
                </span>
            </div>
            
            <form action="${pageContext.request.contextPath}/room-type" method="get" class="search-form" id="searchForm">
                <input type="hidden" name="action" value="search">
                <input type="hidden" name="searchType" id="searchType" value="<%= searchType %>">
                
                <!-- Name Search (shown/hidden based on type) -->
                <div id="nameSearch" style="display: <%= "name".equals(searchType) ? "flex" : "none" %>; flex: 1; width: 100%;">
                    <input type="text" name="searchTerm" class="search-input" 
                           placeholder="Enter room type name (e.g., Deluxe)" 
                           value="<%= searchTerm %>" style="width: 100%;">
                </div>
                
                <!-- Price Range Search (shown/hidden based on type) -->
                <div id="priceSearch" style="display: <%= "price".equals(searchType) ? "flex" : "none" %>; width: 100%;">
                    <div class="price-range">
                        <input type="number" name="minPrice" class="price-input" 
                               placeholder="Min Price (LKR)" value="<%= minPrice %>" 
                               min="0" step="100">
                        <span class="price-separator">—</span>
                        <input type="number" name="maxPrice" class="price-input" 
                               placeholder="Max Price (LKR)" value="<%= maxPrice %>" 
                               min="0" step="100">
                    </div>
                </div>
                
                <div class="search-actions">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i> Search
                    </button>
                    <a href="${pageContext.request.contextPath}/room-type" class="reset-btn">
                        <i class="fas fa-redo"></i> Reset
                    </a>
                </div>
            </form>
            
            <!-- Search hints -->
            <div class="search-hint" id="nameHint" style="display: <%= "name".equals(searchType) ? "flex" : "none" %>;">
                <i class="fas fa-info-circle"></i> 
                Search by partial or full room name (case insensitive)
            </div>
            <div class="search-hint" id="priceHint" style="display: <%= "price".equals(searchType) ? "flex" : "none" %>;">
                <i class="fas fa-info-circle"></i> 
                Leave fields empty to search all prices, fill one for min/max only, or both for range
            </div>
        </div>
        
        <!-- Active filter display -->
        <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
            <div class="active-filter">
                <i class="fas fa-filter"></i> Filter: Name contains "<%= searchTerm %>"
            </div>
        <% } %>
        <% if (minPrice != null && !minPrice.isEmpty() || maxPrice != null && !maxPrice.isEmpty()) { %>
            <div class="active-filter">
                <i class="fas fa-filter"></i> Filter: Price 
                <% if (!minPrice.isEmpty() && !maxPrice.isEmpty()) { %>
                    between LKR <%= minPrice %> - <%= maxPrice %>
                <% } else if (!minPrice.isEmpty()) { %>
                    ≥ LKR <%= minPrice %>
                <% } else if (!maxPrice.isEmpty()) { %>
                    ≤ LKR <%= maxPrice %>
                <% } %>
            </div>
        <% } %>
        
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
                    <th>Room Type Name</th>
                    <th>Price Per Night (LKR)</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (roomTypes != null && !roomTypes.isEmpty()) {
                    for (RoomType rt : roomTypes) { %>
                        <tr>
                            <td>#<%= rt.getRoomTypeId() %></td>
                            <td><strong><%= rt.getTypeName() %></strong></td>
                            <td class="price-tag">LKR <%= String.format("%,.2f", rt.getPricePerNight()) %></td>
                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/room-type?action=edit&id=<%= rt.getRoomTypeId() %>" 
                                   class="action-btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/room-type?action=delete&id=<%= rt.getRoomTypeId() %>" 
                                   class="action-btn btn-delete"
                                   onclick="return confirm('Are you sure you want to delete <%= rt.getTypeName() %>? This action cannot be undone.')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    <% }
                } else { %>
                    <tr>
                        <td colspan="4" class="no-data">
                            <i class="fas fa-info-circle" style="font-size: 40px; color: #ccc; margin-bottom: 10px; display: block;"></i>
                            No room types found. 
                            <% if ((searchTerm != null && !searchTerm.isEmpty()) || 
                                  (minPrice != null && !minPrice.isEmpty()) || 
                                  (maxPrice != null && !maxPrice.isEmpty())) { %>
                                Try different search criteria or 
                                <a href="${pageContext.request.contextPath}/room-type">view all room types</a>.
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/jsp/addRoomType.jsp">Add your first room type!</a>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <% if (roomTypes != null && !roomTypes.isEmpty()) { %>
            <p style="margin-top: 15px; color: #7f8c8d;">
                <i class="fas fa-info-circle"></i> Showing <%= roomTypes.size() %> room type(s)
            </p>
        <% } %>
    </div>
    
    <script>
        function setSearchType(type) {
            document.getElementById('searchType').value = type;
            
            // Update tab UI
            document.querySelectorAll('.search-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // Show/hide appropriate search fields
            if (type === 'name') {
                document.getElementById('nameSearch').style.display = 'flex';
                document.getElementById('priceSearch').style.display = 'none';
                document.getElementById('nameHint').style.display = 'flex';
                document.getElementById('priceHint').style.display = 'none';
            } else {
                document.getElementById('nameSearch').style.display = 'none';
                document.getElementById('priceSearch').style.display = 'flex';
                document.getElementById('nameHint').style.display = 'none';
                document.getElementById('priceHint').style.display = 'flex';
            }
        }
        
        // Confirm delete
        function confirmDelete(name) {
            return confirm('Are you sure you want to delete ' + name + '? This action cannot be undone.');
        }
    </script>
</body>
</html>