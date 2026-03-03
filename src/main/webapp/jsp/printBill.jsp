<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Reservation, com.oceanview.model.Bill" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    Reservation r = (Reservation) request.getAttribute("reservation");
    Bill bill = (Bill) request.getAttribute("bill");
    
    if (r == null || bill == null) {
        response.sendRedirect(request.getContextPath() + "/reservation");
        return;
    }
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill - Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Courier New', monospace;
            margin: 0;
            padding: 20px;
            background: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .bill-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border-radius: 10px;
        }
        
        .bill-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #1e3c72;
            padding-bottom: 20px;
        }
        
        .bill-header h1 {
            color: #1e3c72;
            font-size: 32px;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .bill-header h3 {
            color: #666;
            font-weight: normal;
            margin-bottom: 10px;
        }
        
        .bill-header p {
            color: #888;
            font-size: 14px;
        }
        
        .bill-info {
            margin: 30px 0;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #ddd;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .label {
            font-weight: bold;
            color: #555;
        }
        
        .value {
            color: #333;
        }
        
        .bill-details {
            margin: 30px 0;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .detail-row.header {
            background: #1e3c72;
            color: white;
            padding: 12px;
            border-radius: 5px;
            font-weight: bold;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            margin-top: 20px;
            border-top: 3px double #1e3c72;
            font-size: 20px;
            font-weight: bold;
            color: #1e3c72;
        }
        
        .bill-footer {
            margin-top: 40px;
            text-align: center;
            color: #666;
            font-size: 14px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
        }
        
        .print-btn {
            text-align: center;
            margin-top: 30px;
        }
        
        .btn {
            background: #1e3c72;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin: 0 10px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn:hover {
            background: #2a5298;
        }
        
        .btn-secondary {
            background: #95a5a6;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .bill-id {
            font-size: 18px;
            color: #1e3c72;
            font-weight: bold;
        }
        
        .status-paid {
            color: #27ae60;
            font-weight: bold;
        }
        
        @media print {
            body {
                background: white;
                padding: 0;
            }
            .print-btn {
                display: none;
            }
            .bill-container {
                box-shadow: none;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="bill-container" id="billContent">
        <div class="bill-header">
            <h1>🌊 OCEAN VIEW RESORT</h1>
            <h3>Galle, Sri Lanka</h3>
            <p>123 Beach Road, Galle | Tel: +94 77 123 4567 | Email: info@oceanview.lk</p>
            <hr>
            <h2>TAX INVOICE / BILL</h2>
        </div>
        
        <div class="bill-info">
            <div class="info-row">
                <span class="label">Bill No:</span>
                <span class="value bill-id">BILL-<%= String.format("%05d", bill.getBillId()) %></span>
            </div>
            <div class="info-row">
                <span class="label">Date:</span>
                <span class="value"><%= bill.getGeneratedDate().format(dateFormatter) %> <%= java.time.LocalTime.now().format(timeFormatter) %></span>
            </div>
            <div class="info-row">
                <span class="label">Reservation #:</span>
                <span class="value"><%= r.getReservationNumber() %></span>
            </div>
            <div class="info-row">
                <span class="label">Guest Name:</span>
                <span class="value"><%= r.getGuestName() %></span>
            </div>
            <div class="info-row">
                <span class="label">Contact:</span>
                <span class="value"><%= r.getContactNumber() %></span>
            </div>
            <div class="info-row">
                <span class="label">Room Type:</span>
                <span class="value"><%= r.getRoomTypeName() %></span>
            </div>
        </div>
        
        <div class="bill-details">
            <div class="detail-row header">
                <span>Description</span>
                <span>Amount</span>
            </div>
            
            <div class="detail-row">
                <span>
                    Room Charges (<%= r.getRoomTypeName() %>)<br>
                    <small><%= r.getCheckInDate().format(dateFormatter) %> to <%= r.getCheckOutDate().format(dateFormatter) %></small>
                </span>
                <span>LKR <%= String.format("%,.0f", r.getPricePerNight()) %> x <%= r.getActualNights() %> nights</span>
            </div>
            
            <% if (r.getActualCheckoutDate() != null && !r.getActualCheckoutDate().equals(r.getCheckOutDate())) { %>
            <div class="detail-row" style="color: #e67e22;">
                <span>
                    Early Checkout Adjustment<br>
                    <small>Actual checkout: <%= r.getActualCheckoutDate().format(dateFormatter) %></small>
                </span>
                <span>Adjusted</span>
            </div>
            <% } %>
            
            <div class="detail-row" style="font-weight: bold;">
                <span>Sub Total</span>
                <span>LKR <%= String.format("%,.0f", r.getActualAmount()) %></span>
            </div>
            
            <div class="detail-row">
                <span>Service Charge (10%)</span>
                <span>LKR <%= String.format("%,.0f", r.getActualAmount() * 0.1) %></span>
            </div>
            
            <div class="detail-row">
                <span>Tax (12%)</span>
                <span>LKR <%= String.format("%,.0f", r.getActualAmount() * 0.12) %></span>
            </div>
            
            <div class="total-row">
                <span>TOTAL AMOUNT</span>
                <span>LKR <%= String.format("%,.0f", bill.getTotalAmount()) %></span>
            </div>
        </div>
        
        <div class="bill-footer">
            <p>Thank you for choosing Ocean View Resort!</p>
            <p>This is a computer generated invoice - valid without signature</p>
            <p class="status-paid">✓ PAID</p>
        </div>
    </div>
    
    <div class="print-btn">
        <button class="btn" onclick="window.print()">
            <i class="fas fa-print"></i> Print Bill
        </button>
        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Reservations
        </a>
    </div>
    
    <script>
        // Auto-trigger print dialog when page loads (optional)
        // window.onload = function() { window.print(); }
    </script>
</body>
</html>