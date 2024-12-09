<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="database.DatabaseConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Reports</title>
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
            flex: 1;
            text-align: center;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: static;
            width: 100%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        .no-operations {
            margin-top: 20px;
            font-size: 24px;
            color: #555;
        }
        .download-excel {
            text-align: right;
            margin-top: 10px;
        }
        .download-excel img {
            width: 32px;
            height: 32px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<% if (request.getParameter("success") != null) { %>
        <script>alert('Report generated successfully');</script>
<% } %>
<% if (request.getParameter("failed") != null) { %>
        <script>alert('Failed to generate report. Please try again');</script>
<% } %>
    <div class="header">
        <h1>Company Pension Reports</h1>
    </div>

    <div class="navbar">
    <a href="companyHome.jsp">Home</a>
    <a href="addEmployee.jsp">Add Employee</a>
    <a href="pensionRequests.jsp">Pension Requests</a>
    <a href="companyReports.jsp">Reports</a>
    <a href="employeeList.jsp">Employee List</a>
    <a href="companyChat.jsp">Chats</a>
    <a href="logout.jsp">Logout</a>
</div>

    <div class="main">
        <h2>Pension Report for <%= session.getAttribute("company") %></h2>
        <%
        String company = session.getAttribute("company").toString();
        
        try {
            Connection conn = DatabaseConnection.getConnection();
            String sql = "SELECT e.id AS employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, po.operation_type, po.status, IFNULL(po.details, 'N/A') AS details, po.created_at, po.updated_at "
                       + "FROM pension_operations po "
                       + "JOIN employees e ON e.id = po.employee_id "
                       + "WHERE e.company = ? "
                       + "ORDER BY po.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, company);
            ResultSet rs = ps.executeQuery();

            if (!rs.isBeforeFirst()) {
                %>
                <p class="no-operations">No pension requests found.</p>
                <%
            } else {
                %>
                <div class="download-excel">
                    <a href="ExportToExcelServlet" title="Download as Excel">
                        <img src="images/icons8-excel-48.png" alt="Excel Download"/>
                    </a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Employee ID</th>
                            <th>Employee Name</th>
                            <th>Operation Type</th>
                            <th>Status</th>
                            <th>Details</th>
                            <th>Requested Time</th>
                            <th>Last Updated Time</th>
                        </tr>
                    </thead>
                    <tbody>
                <%
                while (rs.next()) {
                    int employeeId = rs.getInt("employee_id");
                    String employeeName = rs.getString("employee_name");
                    String operationType = rs.getString("operation_type");
                    String status = rs.getString("status");
                    String details = rs.getString("details");
                    String createdAt = rs.getTimestamp("created_at").toString();
                    String updatedAt = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toString() : "N/A";
                %>
                <tr>
                    <td><%= employeeId %></td>
                    <td><%= employeeName %></td>
                    <td><%= operationType %></td>
                    <td><%= status %></td>
                    <td><%= details %></td>
                    <td><%= createdAt %></td>
                    <td><%= updatedAt %></td>
                </tr>
                <%
                }
                %>
                    </tbody>
                </table>
                <%
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
