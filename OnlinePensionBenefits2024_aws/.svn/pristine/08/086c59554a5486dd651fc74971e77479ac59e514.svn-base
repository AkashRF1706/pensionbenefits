<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Pension Benefits - Forgot Password</title>
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
            padding-top: 80px;
            text-align: center;
            flex: 1;
        }
        .forgot-password-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
        }
        .forgot-password-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .forgot-password-container input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .forgot-password-container button {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        .forgot-password-container button:hover {
            background-color: #0056b3;
        }
        .forgot-password-container .links {
            margin-top: 10px;
        }
        .forgot-password-container .links a {
            color: #007bff;
            text-decoration: none;
        }
        .forgot-password-container .links a:hover {
            text-decoration: underline;
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
        <% if (request.getParameter("InvalidEmail") != null) { %>
        <script>alert('Email does not exist! Please try again');</script>
        <% } %>
        <% if (request.getParameter("errorexpired") != null) { %>
        <script>alert('Your password reset link expired. Please try again');</script>
        <% } %>
        <% if (request.getParameter("errorinvalid") != null) { %>
        <script>alert('Error! Please try again');</script>
        <% } %>

        <div class="forgot-password-container">
            <h1>Forgot Password</h1>
            <form action="forgotPasswordServlet" method="post">
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit">Submit</button>
            </form>
            <div class="links">
                <a href="login.jsp">Login</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
