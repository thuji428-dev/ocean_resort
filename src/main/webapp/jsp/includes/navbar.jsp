<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Sidebar only - no html/head/body tags -->
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
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/jsp/addReservation.jsp" class="nav-link ${param.activePage == 'addReservation' ? 'active' : ''}">
                <i class="fas fa-calendar-plus"></i>
                <span>Add Reservation</span>
            </a>
        </li>
       <a href="${pageContext.request.contextPath}/reservation" class="nav-link">
    <i class="fas fa-list"></i>
    <span>View Reservations</span>
</a>
     
       <li class="nav-item">
    <a href="${pageContext.request.contextPath}/guest" class="nav-link ${param.activePage == 'guest' ? 'active' : ''}">
        <i class="fas fa-users"></i>
        <span>Guest Management</span>
    </a>
</li>
            </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/room-type" class="nav-link ${param.activePage == 'roomType' ? 'active' : ''}">
                <i class="fas fa-bed"></i>
                <span>Room Types</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/jsp/help.jsp" class="nav-link ${param.activePage == 'help' ? 'active' : ''}">
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
<!-- No closing div for main-content here - that will be in the main page -->