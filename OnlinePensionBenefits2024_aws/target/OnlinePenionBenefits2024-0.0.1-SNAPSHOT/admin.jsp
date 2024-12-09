<%@page import="java.sql.ResultSet"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: static;
            width: 100%;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="header">
        <h1>Admin Dashboard</h1>
    </div>

    <div class="navbar">
        <a href="admin.jsp">Home</a>
        <a href="companyApproval.jsp">Approve Companies</a>
        <a href="pensionRequests.jsp">Pension Requests</a>
        <a href="manageUsers.jsp">Manage Users</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="main">
        <h2>Welcome, Admin</h2>

        <% 
        int activeEmployees = 0;
        int inactiveEmployees = 0;
        int pendingEmployees = 0;
        int companies = 0;
        
        int approvedPensions = 0;
        int pendingPensions = 0;
        int rejectedPensions = 0;
        try{
        	Connection conn = DatabaseConnection.getConnection();
        	String selectSQL = "SELECT "
        		    + " (SELECT COUNT(*) FROM employees WHERE employee_status = 'Active') AS active_employees, "
        		    + " (SELECT COUNT(*) FROM employees WHERE employee_status = 'Inactive') AS inactive_employees, "
        		    + " (SELECT COUNT(*) FROM employees WHERE employee_status = 'Pending') AS pending_employees, "
        		    + " (SELECT COUNT(*) FROM companies) AS companies";
        	
        	PreparedStatement ptst = conn.prepareStatement(selectSQL);
        	ResultSet rs = ptst.executeQuery();
        	if(rs.next()){
        		activeEmployees = rs.getInt("active_employees");
        		inactiveEmployees = rs.getInt("inactive_employees");
        		companies = rs.getInt("companies");
        		pendingEmployees = rs.getInt("pending_employees");
        	}
        	
        	String selectSQL2 = "Select "
        			+ " (Select COUNT(*) from pension_operations where status = 'Admin Pending' and operation_type = 'Withdraw') AS pending_withdrawal, "
        			+ " (Select COUNT(*) from pension_operations where status = 'Approved' and operation_type = 'Withdraw') AS approved_withdrawal, "
        			+ " (Select COUNT(*) from pension_operations where status = 'Rejected' and operation_type = 'Withdraw') AS rejected_withdrawal ";
        	PreparedStatement ptst2 = conn.prepareStatement(selectSQL2);
        	ResultSet rs2 = ptst2.executeQuery();
        	if(rs2.next()){
        		approvedPensions = rs2.getInt("approved_withdrawal");
        		pendingPensions = rs2.getInt("pending_withdrawal");
        		rejectedPensions = rs2.getInt("rejected_withdrawal");
        	}
        } catch(Exception e){
        	e.printStackTrace();
        }
            
            Map<String, Integer> employeeCompanyStatus = new HashMap<>();
            employeeCompanyStatus.put("Active Employees", activeEmployees);
            employeeCompanyStatus.put("Inactive Employees", inactiveEmployees);
            employeeCompanyStatus.put("Pending Employees", pendingEmployees);
            employeeCompanyStatus.put("Companies", companies);
            
            Map<String, Integer> pensionStatus = new HashMap<>();
            pensionStatus.put("Pension Withdrawal Approved", approvedPensions);
            pensionStatus.put("Pension Withdrawal Pending", pendingPensions);
            pensionStatus.put("Pension Withdrawal Rejected", rejectedPensions);
        %>

        <input type="hidden" id="employeeCompanyStatus" value='<%= new Gson().toJson(employeeCompanyStatus) %>'>
        <input type="hidden" id="pensionStatus" value='<%= new Gson().toJson(pensionStatus) %>'>
        
        <div class="chart-container">
            <div class="chart">
                <canvas id="employeeCompanyChart"></canvas>
            </div>
            <div class="chart">
                <canvas id="pensionStatusChart"></canvas>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const employeeCompanyStatus = JSON.parse(document.getElementById('employeeCompanyStatus').value);
            const pensionStatus = JSON.parse(document.getElementById('pensionStatus').value);

            renderCharts(employeeCompanyStatus, pensionStatus);
        });

        function renderCharts(employeeCompanyStatus, pensionStatus) {
            var ctx1 = document.getElementById('employeeCompanyChart').getContext('2d');
            var employeeCompanyChart = new Chart(ctx1, {
                type: 'pie',
                data: {
                    labels: Object.keys(employeeCompanyStatus),
                    datasets: [{
                        label: 'Status',
                        data: Object.values(employeeCompanyStatus),
                        backgroundColor: ['#4CAF50', '#FF6384', '#36A2EB', '#FFCE56'],
                        hoverOffset: 4
                    }]
                }
            });

            var ctx2 = document.getElementById('pensionStatusChart').getContext('2d');
            var pensionStatusChart = new Chart(ctx2, {
                type: 'pie',
                data: {
                    labels: Object.keys(pensionStatus),
                    datasets: [{
                        label: 'Status',
                        data: Object.values(pensionStatus),
                        backgroundColor: ['#4CAF50', '#FF6384', '#FFCE56'],
                        hoverOffset: 4
                    }]
                }
            });
        }
    </script>
</body>
</html>
