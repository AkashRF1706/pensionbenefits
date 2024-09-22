<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Pension Benefits - Reset Password</title>
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
        .reset-password-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
        }
        .reset-password-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .reset-password-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .reset-password-container button {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        .reset-password-container button:hover {
            background-color: #0056b3;
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
        <div class="reset-password-container">
            <h1>Reset Password</h1>
            <form action="resetPasswordServlet" method="post">
                <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
                <input type="password" name="new_password" placeholder="New Password" required>
                <button type="submit">Reset Password</button>
            </form>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
