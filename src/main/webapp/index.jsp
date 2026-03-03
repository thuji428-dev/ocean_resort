<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Booking System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Your existing styles remain the same */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), 
                        url('https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .container {
            width: 100%;
            max-width: 1200px;
            padding: 20px;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 700px;
            margin: 0 auto;
            backdrop-filter: blur(10px);
            animation: fadeIn 1s ease-in-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .logo {
            margin-bottom: 30px;
        }
        
        .logo i {
            font-size: 60px;
            color: #2a5298;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }
        
        .logo h1 {
            font-size: 42px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        
        .logo .subtitle {
            font-size: 18px;
            color: #555;
            font-weight: 300;
            letter-spacing: 1px;
        }
        
        .welcome-message {
            margin: 40px 0;
        }
        
        .welcome-message h2 {
            font-size: 32px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .welcome-message p {
            font-size: 18px;
            color: #666;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .features {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 40px 0;
            flex-wrap: wrap;
        }
        
        .feature-item {
            flex: 1;
            min-width: 150px;
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 15px;
            transition: transform 0.3s;
        }
        
        .feature-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .feature-item i {
            font-size: 30px;
            color: #2a5298;
            margin-bottom: 10px;
        }
        
        .feature-item span {
            display: block;
            font-size: 14px;
            color: #555;
            font-weight: 500;
        }
        
        .login-btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 50px;
            border-radius: 50px;
            text-decoration: none;
            font-size: 20px;
            font-weight: 600;
            letter-spacing: 1px;
            transition: all 0.3s;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            margin: 20px 0;
            border: none;
            cursor: pointer;
        }
        
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.6);
        }
        
        .login-btn i {
            margin-right: 10px;
        }
        
        .forgot-container {
            margin: 15px 0 25px;
        }
        
        .forgot-link {
            color: #666;
            text-decoration: none;
            font-size: 15px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 30px;
            background: #f8f9fa;
        }
        
        .forgot-link:hover {
            color: #2a5298;
            background: #e3f2fd;
            transform: translateY(-2px);
        }
        
        .forgot-link i {
            font-size: 16px;
        }
        
        .admin-note {
            margin-top: 20px;
            padding: 15px;
            background: #fff3e0;
            border-radius: 10px;
            border-left: 4px solid #f39c12;
            text-align: left;
        }
        
        .admin-note p {
            margin: 5px 0;
            font-size: 14px;
            color: #e67e22;
        }
        
        .admin-note i {
            margin-right: 8px;
        }
        
        .footer {
            margin-top: 40px;
            color: #888;
            font-size: 14px;
        }
        
        .footer a {
            color: #2a5298;
            text-decoration: none;
        }
        
        .footer a:hover {
            text-decoration: underline;
        }
        
        .wave {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            z-index: -1;
            opacity: 0.1;
        }
        
        @media (max-width: 768px) {
            .welcome-card {
                padding: 30px 20px;
            }
            
            .logo h1 {
                font-size: 32px;
            }
            
            .welcome-message h2 {
                font-size: 24px;
            }
            
            .features {
                gap: 15px;
            }
            
            .feature-item {
                min-width: 120px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Decorative wave -->
    <svg class="wave" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
        <path fill="#2a5298" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
    </svg>

    <div class="container">
        <div class="welcome-card">
            <div class="logo">
                <i class="fas fa-umbrella-beach"></i>
                <h1>OCEAN VIEW</h1>
                <div class="subtitle">RESORT & SPA</div>
            </div>
            
            <div class="welcome-message">
                <h2>Welcome to Paradise</h2>
                <p>Experience luxury and comfort at Ocean View Resort, Galle. 
                   Our booking system makes it easy to manage reservations, 
                   guests, and billing all in one place.</p>
            </div>
            
            <div class="features">
                <div class="feature-item">
                    <i class="fas fa-calendar-check"></i>
                    <span>Easy Booking</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-users"></i>
                    <span>Guest Management</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-file-invoice"></i>
                    <span>Instant Billing</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-clock"></i>
                    <span>24/7 Support</span>
                </div>
            </div>
            
            <!-- CORRECTED LOGIN LINK - Only one /jsp/ -->
            <a href="jsp/login.jsp" class="login-btn">
                <i class="fas fa-sign-in-alt"></i> Login to Dashboard
            </a>
            
            <!-- Forgot Password Link -->
            <div class="forgot-container">
                <a href="#" class="forgot-link" onclick="showForgotMessage()">
                    <i class="fas fa-question-circle"></i> Forgot Password?
                </a>
            </div>
            
            <!-- Admin Note -->
            <div class="admin-note" id="forgotMessage" style="display: none;">
                <p><i class="fas fa-info-circle"></i> <strong>Demo Credentials:</strong></p>
                <p><i class="fas fa-user"></i> Username: admin</p>
                <p><i class="fas fa-lock"></i> Password: admin123</p>
                <p style="font-size: 12px; margin-top: 10px;">Please contact system administrator for password reset.</p>
            </div>
            
            <div class="footer">
                <p>&copy; 2026 Ocean View Resort, Galle. All rights reserved.</p>
                <p><a href="#"><i class="fas fa-phone"></i> +94 77 123 4567</a> | 
                   <a href="#"><i class="fas fa-envelope"></i> info@oceanview.lk</a></p>
            </div>
        </div>
    </div>

    <script>
        function showForgotMessage() {
            const messageDiv = document.getElementById('forgotMessage');
            if (messageDiv.style.display === 'none') {
                messageDiv.style.display = 'block';
            } else {
                messageDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>