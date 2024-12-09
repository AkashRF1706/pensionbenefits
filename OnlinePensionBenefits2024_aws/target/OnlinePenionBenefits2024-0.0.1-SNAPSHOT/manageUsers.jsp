<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.UserDetails" %>
<%@ page import="servlet.AdminServlet" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Manage Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
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
        .navbar {
            display: flex;
            justify-content: center;
            background-color: #333;
        }
        .navbar a {
            padding: 14px 20px;
            display: block;
            color: white;
            text-align: center;
            text-decoration: none;
        }
        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }
        .main {
            padding: 20px;
            text-align: center;
        }
        .main h2 {
            color: #4CAF50;
        }
        .main p {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: relative;
            bottom: 0;
            width: 100%;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 15px 25px;
            border: none;
            cursor: pointer;
            font-size: 18px;
            margin: 10px;
        }
        .button:hover {
            background-color: #45a049;
        }
        .table-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        table {
            width: 80%;
            margin: 20px 0;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .action-buttons {
            display: flex;
            justify-content: space-around;
        }
        .edit-button {
            background-color: #4CAF50;
        }
        .delete-button {
            background-color: #f44336;
        }
        .filter-buttons {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <% String adminName = (String) session.getAttribute("name"); %>
        <h1>Welcome to the Admin Portal</h1>
    </div>
    <div class="navbar">
        <a href="admin.jsp">Home</a> 
		<a href="companyApproval.jsp">Approve Companies</a> 
			<a href="pensionRequests.jsp">Pension Requests</a> 
			<a href="manageUsers.jsp">Manage Users</a> 
			<a href="logout.jsp">Logout</a>
    </div>
    <div class="main">
        <h2>Manage Users</h2>
        <p>View and manage all registered users.</p>
        
        <div class="filter-buttons">
            <button class="button" onclick="showTable('pensioners')">Pensioners</button>
            <button class="button" onclick="showTable('companies')">Companies</button>
        </div>

        <div class="table-container">
        
        <%List<UserDetails>  userDetailsList = new ArrayList<>();
        AdminServlet as = new AdminServlet();
        userDetailsList = as.getUserDetails();%>
            
            <div id="pensionersTable" class="user-table" style="display: none;">
                <h3>Pensioners</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Date of Birth</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (UserDetails user : userDetailsList) {
                                if ("Pensioner".equalsIgnoreCase(user.getRole())) {
                        %>
                            <tr>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getFirstName() %></td>
                                <td><%= user.getLastName() %></td>
                                <td><%= user.getDateOfBirth() %></td>
                            </tr>
                        <% 
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div id="companiesTable" class="user-table" style="display: none;">
                <h3>Companies</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Company Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (UserDetails user : userDetailsList) {
                                if ("Company".equalsIgnoreCase(user.getRole())) {
                        %>
                            <tr>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getCompanyName() %></td>
                            </tr>
                        <% 
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
    <script>
        function showTable(table) {
            document.getElementById('pensionersTable').style.display = 'none';
            document.getElementById('companiesTable').style.display = 'none';

            if (table === 'pensioners') {
                document.getElementById('pensionersTable').style.display = '';
            } else if (table === 'companies') {
                document.getElementById('companiesTable').style.display = '';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            showTable('pensioners');
        });
    </script>
</body>
</html>
