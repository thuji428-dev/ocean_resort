<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), 
                        url('https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.5s ease-in-out;
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
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo i {
            font-size: 50px;
            color: #2a5298;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        
        .logo h2 {
            color: #333;
            font-size: 24px;
            font-weight: 600;
        }
        
        .logo p {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            border-left: 4px solid #c62828;
            animation: shake 0.3s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .input-group i {
            position: absolute;
            left: 15px;
            color: #2a5298;
            font-size: 16px;
        }
        
        .input-group input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #2a5298;
            box-shadow: 0 0 0 3px rgba(42, 82, 152, 0.1);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            color: #95a5a6;
            cursor: pointer;
            font-size: 16px;
        }
        
        .password-toggle:hover {
            color: #2a5298;
        }
        
        .login-btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        
        .forgot-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .forgot-link a {
            color: #666;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.3s;
            cursor: pointer;
        }
        
        .forgot-link a:hover {
            color: #2a5298;
        }
        
        /* Modal/Popup Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeInModal 0.3s ease-in-out;
        }
        
        @keyframes fadeInModal {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .modal-content {
            background: white;
            margin: 15% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 350px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            position: relative;
            animation: slideDown 0.3s ease-in-out;
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .modal-header i {
            font-size: 50px;
            color: #2a5298;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        
        .modal-header h3 {
            color: #333;
            font-size: 20px;
        }
        
        .credential-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #2a5298;
        }
        
        .credential-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .credential-item:last-child {
            border-bottom: none;
        }
        
        .credential-item i {
            width: 30px;
            height: 30px;
            background: #e3f2fd;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2a5298;
        }
        
        .credential-item .label {
            font-weight: 600;
            color: #555;
            min-width: 80px;
        }
        
        .credential-item .value {
            font-family: monospace;
            font-size: 16px;
            color: #2a5298;
            font-weight: bold;
            background: #fff;
            padding: 5px 10px;
            border-radius: 5px;
            border: 1px dashed #2a5298;
        }
        
        .close-btn {
            position: absolute;
            right: 15px;
            top: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #999;
            transition: color 0.3s;
        }
        
        .close-btn:hover {
            color: #e74c3c;
        }
        
        .modal-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            width: 100%;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .modal-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .copy-btn {
            background: #2a5298;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .copy-btn:hover {
            background: #1e3c72;
        }
        
        @media (max-width: 480px) {
            .login-container {
                margin: 20px;
                padding: 30px 20px;
            }
            
            .modal-content {
                margin: 30% auto;
                width: 95%;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <i class="fas fa-umbrella-beach"></i>
            <h2>Ocean View Resort</h2>
            <p>Admin Login</p>
        </div>
        
        <!-- Error Message Display -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="error-message" id="errorMessage">
                <i class="fas fa-exclamation-circle"></i>
                <% if ("invalid".equals(error)) { %>
                    Invalid username or password! Please try again.
                <% } else if ("session".equals(error)) { %>
                    Session expired! Please login again.
                <% } else if ("logout".equals(error)) { %>
                    You have been successfully logged out.
                <% } else { %>
                    Login failed! Please check your credentials.
                <% } %>
            </div>
        <% } %>
        
        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">
                    <i class="fas fa-user"></i> Username
                </label>
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           placeholder="Enter your username"
                           value="admin"
                           required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Password
                </label>
                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           placeholder="Enter your password"
                           value="admin123"
                           required>
                    <i class="fas fa-eye password-toggle" onclick="togglePassword()"></i>
                </div>
            </div>
            
            <button type="submit" class="login-btn">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
        </form>
        
        <!-- Forgot Password Link -->
        <div class="forgot-link">
            <a onclick="showForgotPopup()">
                <i class="fas fa-question-circle"></i> Forgot Password?
            </a>
        </div>
    </div>
    
    <!-- Forgot Password Popup Modal -->
    <div id="forgotModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeForgotPopup()">&times;</span>
            
            <div class="modal-header">
                <i class="fas fa-key"></i>
                <h3>Admin Credentials</h3>
            </div>
            
            <div class="credential-box">
                <div class="credential-item">
                    <i class="fas fa-user"></i>
                    <span class="label">Username:</span>
                    <span class="value" id="usernameValue">admin</span>
                    <button class="copy-btn" onclick="copyToClipboard('usernameValue')">
                        <i class="fas fa-copy"></i>
                    </button>
                </div>
                
                <div class="credential-item">
                    <i class="fas fa-lock"></i>
                    <span class="label">Password:</span>
                    <span class="value" id="passwordValue">admin123</span>
                    <button class="copy-btn" onclick="copyToClipboard('passwordValue')">
                        <i class="fas fa-copy"></i>
                    </button>
                </div>
            </div>
            
            <p style="color: #666; font-size: 13px; text-align: center; margin-bottom: 15px;">
                <i class="fas fa-info-circle"></i> 
                Use these credentials to login
            </p>
            
            <button class="modal-btn" onclick="closeForgotPopup()">
                <i class="fas fa-check"></i> Got it
            </button>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        // Show forgot password popup
        function showForgotPopup() {
            document.getElementById('forgotModal').style.display = 'block';
        }
        
        // Close forgot password popup
        function closeForgotPopup() {
            document.getElementById('forgotModal').style.display = 'none';
        }
        
        // Copy to clipboard function
        function copyToClipboard(elementId) {
            const text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(() => {
                // Show temporary success message
                const btn = event.target.closest('.copy-btn');
                const originalHtml = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i>';
                btn.style.background = '#27ae60';
                
                setTimeout(() => {
                    btn.innerHTML = originalHtml;
                    btn.style.background = '#2a5298';
                }, 1500);
            });
        }
        
        // Form validation
        function validateForm() {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (username === '') {
                showTemporaryError('Please enter username');
                return false;
            }
            
            if (password === '') {
                showTemporaryError('Please enter password');
                return false;
            }
            
            return true;
        }
        
        // Show temporary error message
        function showTemporaryError(message) {
            const container = document.querySelector('.login-container');
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
            
            // Remove any existing error message
            const existingError = document.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }
            
            // Insert at top of form
            container.insertBefore(errorDiv, container.querySelector('form'));
            
            // Auto remove after 3 seconds
            setTimeout(() => {
                errorDiv.remove();
            }, 3000);
        }
        
        // Auto hide error message after 5 seconds
        window.onload = function() {
            const errorMsg = document.getElementById('errorMessage');
            if (errorMsg) {
                setTimeout(() => {
                    errorMsg.style.opacity = '0';
                    setTimeout(() => {
                        errorMsg.remove();
                    }, 500);
                }, 5000);
            }
        };
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('forgotModal');
            if (event.target === modal) {
                closeForgotPopup();
            }
        };
        
        // Handle ESC key to close modal
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeForgotPopup();
            }
        });
    </script>
</body>
</html>