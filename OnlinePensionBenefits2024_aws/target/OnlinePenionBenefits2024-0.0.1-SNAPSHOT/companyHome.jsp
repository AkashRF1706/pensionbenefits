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
    <title>Company - Home</title>
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
            position: static;
            width: 100%;
        }
        .chart-container {
            display: flex;
            justify-content: space-around;
            align-items: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        .chart {
            width: 30%;
            min-width: 300px;
            margin: 20px 0;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<% String company = session.getAttribute("company").toString(); %>
    <div class="header">
        <h1>Welcome to Pension Portal - <%= company %></h1>
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
        <p>Use the navigation menu to manage employee pension details.</p>
        
        <div class="chart-container">
            <div class="chart">
                <canvas id="pensionWithdrawChart"></canvas>
            </div>
            <div class="chart">
                <canvas id="pensionUpdateChart"></canvas>
            </div>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>

    <% 
        // Initialize the counters
        int withdrawApproved = 0;
        int withdrawRejected = 0;
        int withdrawPending = 0;

        int updateApproved = 0;
        int updateRejected = 0;
        int updatePending = 0;

        try {
            Connection conn = DatabaseConnection.getConnection();

            // Query for withdrawal operations
            String sqlWithdraw = "SELECT status, COUNT(*) AS count FROM pension_operations po "
                               + "JOIN employees e ON e.id = po.employee_id "
                               + "WHERE e.company = ? AND po.operation_type = 'Withdraw' "
                               + "GROUP BY status";
            PreparedStatement pstmt = conn.prepareStatement(sqlWithdraw);
            pstmt.setString(1, company);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                if ("Approved".equals(status)) {
                    withdrawApproved = count;
                } else if ("Rejected".equals(status)) {
                    withdrawRejected = count;
                } else if (status.contains("Pending")) {
                    withdrawPending = count;
                }
            }

            rs.close();
            pstmt.close();

            // Query for update operations
            String sqlUpdate = "SELECT status, COUNT(*) AS count FROM pension_operations po "
                             + "JOIN employees e ON e.id = po.employee_id "
                             + "WHERE e.company = ? AND po.operation_type = 'Update' "
                             + "GROUP BY status";
            pstmt = conn.prepareStatement(sqlUpdate);
            pstmt.setString(1, company);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                if ("Approved".equals(status)) {
                    updateApproved = count;
                } else if ("Rejected".equals(status)) {
                    updateRejected = count;
                } else if (status.contains("Pending")) {
                    updatePending = count;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            renderCharts();
        });

        function renderCharts() {
            var withdrawData = {
                labels: ['Pension Withdrawal Approved', 'Pension Withdrawal Rejected', 'Pension Withdrawal Pending Approval'],
                datasets: [{
                    data: [<%= withdrawApproved %>, <%= withdrawRejected %>, <%= withdrawPending %>],
                    backgroundColor: ['#4CAF50', '#f44336', '#FFCE56'],
                    hoverOffset: 4
                }]
            };

            var updateData = {
                labels: ['Pension Update Approved', 'Pension Update Rejected', 'Pension Update Pending Approval'],
                datasets: [{
                    data: [<%= updateApproved %>, <%= updateRejected %>, <%= updatePending %>],
                    backgroundColor: ['#4CAF50', '#f44336', '#FFCE56'],
                    hoverOffset: 4
                }]
            };

            var ctxWithdraw = document.getElementById('pensionWithdrawChart').getContext('2d');
            var pensionWithdrawChart = new Chart(ctxWithdraw, {
                type: 'pie',
                data: withdrawData
            });

            var ctxUpdate = document.getElementById('pensionUpdateChart').getContext('2d');
            var pensionUpdateChart = new Chart(ctxUpdate, {
                type: 'pie',
                data: updateData
            });
        }
    </script>
</body>
</html>
