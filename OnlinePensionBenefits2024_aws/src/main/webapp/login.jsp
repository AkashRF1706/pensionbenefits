<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Pension Benefits - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .header {
            background-color: #4CAF50;
            padding: 20px;
            text-align: center;
            color: white;
        }
        .header h1 {
            margin: 0;
        }
        .main {
            padding: 20px;
            padding-top: 70px;
            text-align: center;
            flex: 1;
        }
        .login-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
        }
        .login-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .login-container input[type="text"], .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .login-container button {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        .login-container button:hover {
            background-color: #0056b3;
        }
        .login-container .links {
            margin-top: 10px;
        }
        .login-container .links a {
            color: #007bff;
            text-decoration: none;
        }
        .login-container .links a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            margin: 10px 0;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: static;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome to Pension Portal</h1>
    </div>

    <div class="main">
        <% if (request.getParameter("SignUpComplete") != null) { %>
        <script>alert('SignUp Successful! Please login to the application');</script>
        <% } %>
        <% if (request.getParameter("resetLinkSent") != null) { %>
        <script>alert('Password Reset Link sent to email!');</script>
        <% } %>
        <% if (request.getParameter("passwordResetSuccess") != null) { %>
        <script>alert('Your Password has been reset. Please login');</script>
        <% } %>
        <% if (request.getParameter("AccountPending") != null) { %>
        <script>alert('Admin approval required. Please wait upto 48 hours of signup);</script>
        <% } %>
        <% if (request.getParameter("AccountInactive") != null) { %>
        <script>alert('Account inactive or Admin approval rejected. Please contact the admin');</script>
        <% } %>

        <div class="login-container">
            <h1>Login</h1>
            <form action="loginServlet" method="post">
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Login</button>
                <% if (request.getParameter("InvalidUsername") != null) { %>
                    <p class="error">Username does not exist</p>
                <% } else if (request.getParameter("IncorrectPwd") != null) { %>
                    <p class="error">Invalid password</p>
                <% } %>
            </form>
            <div class="links">
                <a href="signup.jsp">Signup</a> | <a href="forgotPassword.jsp">Forgot Password?</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
