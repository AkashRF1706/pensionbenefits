<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification</title>
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
        .otp-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
        }
        .otp-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .otp-container input[type="text"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .otp-container button {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        .otp-container button:hover {
            background-color: #0056b3;
        }
        .otp-container .links {
            margin-top: 10px;
        }
        .otp-container .links a {
            color: #007bff;
            text-decoration: none;
        }
        .otp-container .links a:hover {
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
<% String redirectPage = "verifyOtp.jsp";
   if(request.getParameter("redirect") != null && !request.getParameter("redirect").isEmpty()){
       redirectPage = request.getParameter("redirect"); 
   }
%>
<% if (request.getParameter("otpSent") != null) { %>
    <script>alert('A new OTP has been sent to your email.');</script>
<% } %>
<% if (request.getParameter("error") != null) { %>
    <script>alert('Unable to resend OTP. Please try again.');</script>
<% } %>

    <div class="header">
        <h1>OTP Verification</h1>
    </div>

    <div class="main">
        <div class="otp-container">
            <h1>Enter OTP</h1>
            <form action="VerifyOtpServlet" method="post">
                <label for="otp">OTP:</label>
                <input type="text" id="otp" name="otp" required>
                <input type="hidden" name="redirectUrl" value="<%=redirectPage%>">
                <button type="submit">Verify</button>
            </form>
            <div class="links">
                <a href="ResendOtpServlet?redirect=<%=redirectPage%>">Resend OTP</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
