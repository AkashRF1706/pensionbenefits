<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, database.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Pension Benefits - Signup</title>
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
            text-align: center;
            flex: 1;
        }
        .signup-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 0 auto;
        }
        .signup-container h1 {
            margin-bottom: 20px;
            color: #333;
        }
        .signup-container input[type="text"], .signup-container input[type="password"], .signup-container input[type="email"], .signup-container input[type="date"], .signup-container select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .signup-container button {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        .signup-container button:hover {
            background-color: #0056b3;
        }
        .signup-container .links {
            margin-top: 10px;
        }
        .signup-container .links a {
            color: #007bff;
            text-decoration: none;
        }
        .signup-container .links a:hover {
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
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome to Pension Portal</h1>
    </div>

    <div class="main">
        <% if (request.getParameter("SignUpFailed") != null) { %>
        <script>alert('SignUp Failed! Please try again...');</script>
        <% } %>

        <div class="signup-container">
            <h1>Signup</h1>
            <form id="signupForm" action="signupServlet" method="post">
                <select id="role" name="role" required onchange="showFormFields()">
                    <option value="" disabled selected>Select Role</option>
                    <% 
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            conn = DatabaseConnection.getConnection();
                            String sql = "SELECT role_id, role_name FROM roles WHERE signup_required = 'Y'";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                int roleId = rs.getInt("role_id");
                                String roleName = rs.getString("role_name");
                    %>
                                <option value="<%= roleId %>"><%= roleName %></option>
                    <% 
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </select>

                <div id="commonFields" class="hidden">
                    <input type="text" name="username" placeholder="Username" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <input type="email" name="email" placeholder="Email" required>
                </div>

                <div id="companyFields" class="hidden">
                    <input type="text" name="company_name" id="company_name" placeholder="Company Name">
                </div>

                <div id="pensionerFields" class="hidden">
                    <input type="text" name="first_name" id="first_name" placeholder="First Name">
                    <input type="text" name="last_name" id="last_name" placeholder="Last Name">
                    <input type="date" name="date_of_birth" id="date_of_birth" placeholder="Date of Birth">
                    <select id="gender" name="gender">
                        <option value="" disabled selected>Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <button type="submit" id="submitButton" class="hidden">Signup</button>
            </form>
            <div class="links">
                <a href="login.jsp">Login</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', (event) => {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('date_of_birth').setAttribute('max', today);
        });

        function showFormFields() {
            const role = document.getElementById('role').value;
            const commonFields = document.getElementById('commonFields');
            const submitButton = document.getElementById('submitButton');
            const companyFields = document.getElementById('companyFields');
            const pensionerFields = document.getElementById('pensionerFields');

            commonFields.classList.remove('hidden');
            submitButton.classList.remove('hidden');

            companyFields.classList.add('hidden');
            pensionerFields.classList.add('hidden');

            document.getElementById('company_name').removeAttribute('required');
            document.getElementById('first_name').removeAttribute('required');
            document.getElementById('last_name').removeAttribute('required');
            document.getElementById('date_of_birth').removeAttribute('required');
            document.getElementById('gender').removeAttribute('required');

            if (role == 2) { 
                companyFields.classList.remove('hidden');
                document.getElementById('company_name').setAttribute('required', 'required');
            } else if (role == 3) { 
                pensionerFields.classList.remove('hidden');
                document.getElementById('first_name').setAttribute('required', 'required');
                document.getElementById('last_name').setAttribute('required', 'required');
                document.getElementById('date_of_birth').setAttribute('required', 'required');
                document.getElementById('gender').setAttribute('required', 'required');
            }
        }
    </script>
</body>
</html>
