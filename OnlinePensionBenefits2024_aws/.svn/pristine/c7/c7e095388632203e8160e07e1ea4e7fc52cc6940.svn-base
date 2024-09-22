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
    <title>Approve/Reject Transfer Requests</title>
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
        .footer {
	background-color: #333;
	color: white;
	text-align: center;
	padding: 10px;
	position: static;
	width: 100%;
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
        }
        .tabs {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }
        .tabs button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            outline: none;
        }
        .tabs button:hover {
            background-color: #45a049;
        }
        .tabcontent {
            display: none;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .tabcontent.active {
            display: block;
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
        .action-buttons {
            display: flex;
            justify-content: space-around;
        }
        .action-buttons form {
            display: inline;
        }
        .action-buttons button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
        }
        .approve {
            background-color: #4CAF50;
            color: white;
        }
        .approve:hover {
            background-color: #45a049;
        }
        .reject {
            background-color: #f44336;
            color: white;
        }
        .reject:hover {
            background-color: #d32f2f;
        }
    </style>
    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }

        function confirmReject(transferId, companyType) {
            var reason = prompt("Please enter the reason for rejection:", "");
            if (reason != null && reason.trim() !== "") {
                document.getElementById("rejectForm-" + transferId).reason.value = reason;
                document.getElementById("rejectForm-" + transferId).companyType.value = companyType;
                document.getElementById("rejectForm-" + transferId).submit();
            } else {
                alert("Rejection reason is required.");
            }
        }

        function calculatePensions(transferId) {
            const salaryInput = document.getElementById('salaryInput-' + transferId);
            const personalPensionInput = document.getElementById('personalPensionInput-' + transferId);
            const workplacePensionInput = document.getElementById('workplacePensionInput-' + transferId);

            const salary = parseFloat(salaryInput.value);
            if (!isNaN(salary)) {
                const monthlySalary = salary / 12;
                const personalPension = Math.round(monthlySalary * 0.05 * 100.0) / 100.0;
                const workplacePension = Math.round(monthlySalary * 0.05 * 100.0) / 100.0;

                personalPensionInput.value = personalPension.toFixed(2);
                workplacePensionInput.value = workplacePension.toFixed(2);
            } else {
                personalPensionInput.value = '';
                workplacePensionInput.value = '';
            }
        }

        function approveWithSalary(transferId, companyType) {
            const salaryInput = document.getElementById("salaryInput-" + transferId).value;
            if (salaryInput.trim() === "") {
                alert("Please enter a salary.");
                return;
            }
            const personalPensionInput = document.getElementById("personalPensionInput-" + transferId).value;
            const workplacePensionInput = document.getElementById("workplacePensionInput-" + transferId).value;

            document.getElementById("approveForm-" + transferId).companyType.value = companyType;
            document.getElementById("approveForm-" + transferId).salary.value = salaryInput;
            document.getElementById("approveForm-" + transferId).personalPension.value = personalPensionInput;
            document.getElementById("approveForm-" + transferId).workplacePension.value = workplacePensionInput;
            document.getElementById("approveForm-" + transferId).submit();
        }
    </script>
</head>
<body>
<% if (request.getParameter("success") != null) { %>
	<script>alert('Transfer Request Updated');</script>
	<% } %>
	<% if (request.getParameter("failed") != null) { %>
	<script>alert('Transfer Request update failed. Please try again');</script>
	<% } %>

<div class="header">
    <h1>Approve/Reject Transfer Requests</h1>
</div>

<div class="navbar">
        <a href="companyHome.jsp">Home</a>
        <a href="addEmployee.jsp">Add Employee</a>
        <a href="pensionRequests.jsp">Pension Requests</a>
        <a href="companyReports.jsp">Reports</a>
        <a href="employeeList.jsp">Employee List</a>
        <a href="logout.jsp">Logout</a>
    </div>

<div class="main">
    <div class="tabs">
        <button class="tablinks active" onclick="openTab(event, 'CurrentCompany')">Current Company Approvals</button>
        <button class="tablinks" onclick="openTab(event, 'DestinationCompany')">Destination Company Approvals</button>
    </div>

    <!-- Current Company Tab -->
    <div id="CurrentCompany" class="tabcontent active">
        <h2>Current Company - Pending Transfer Requests</h2>
        <%
            String companyName = (String) session.getAttribute("company");
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT et.id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, c1.company_name AS current_company, c2.company_name AS destination_company, IFNULL(et.request_date, 'N/A') as request_date, et.status " +
                             "FROM employee_transfers et " +
                             "JOIN companies c1 ON et.from_company_id = c1.id " +
                             "JOIN companies c2 ON et.to_company_id = c2.id " +
                             "JOIN employees e ON et.employee_id = e.id " +
                             "WHERE c1.company_name = ? AND et.status = 'Current Company'";
                ps = conn.prepareStatement(sql);
                ps.setString(1, companyName);
                rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) {
                    %>
                    <p>No pending transfer requests found for Current Company.</p>
                    <%
                } else {
                    %>
                    <table>
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Employee Name</th>
                                <th>Current Company</th>
                                <th>Destination Company</th>
                                <th>Request Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                    <%
                    while (rs.next()) {
                        String transferId = rs.getString("id");
                        String employeeName = rs.getString("employee_name");
                        String currentCompany = rs.getString("current_company");
                        String destinationCompany = rs.getString("destination_company");
                        String requestDate = rs.getTimestamp("request_date").toString();
                        String status = rs.getString("status");
                    %>
                        <tr>
                            <td><%= transferId %></td>
                            <td><%= employeeName %></td>
                            <td><%= currentCompany %></td>
                            <td><%= destinationCompany %></td>
                            <td><%= requestDate %></td>
                            <td><%= (rs.getString("status").equalsIgnoreCase("Current Company") || rs.getString("status").equalsIgnoreCase("Destination Company")) ? "Pending Approval from " + rs.getString("status")  : rs.getString("status") %></td>
                            <td class="action-buttons">
                                <form action="ApproveRejectTransferServlet" method="post">
                                    <input type="hidden" name="transferId" value="<%= transferId %>">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="companyType" value="current">
                                    <button type="submit" class="approve">Approve</button>
                                </form>
                                <form id="rejectForm-<%= transferId %>" action="ApproveRejectTransferServlet" method="post">
                                    <input type="hidden" name="transferId" value="<%= transferId %>">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="companyType" value="current">
                                    <input type="hidden" name="reason" value="">
                                    <button type="button" class="reject" onclick="confirmReject('<%= transferId %>', 'current')">Reject</button>
                                </form>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                        </tbody>
                    </table>
                    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
                if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        %>
    </div>

    <!-- Destination Company Tab -->
    <div id="DestinationCompany" class="tabcontent">
        <h2>Destination Company - Pending Transfer Requests</h2>
        <%
            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT et.id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, c1.company_name AS current_company, c2.company_name AS destination_company, IFNULL(et.request_date, 'N/A') as request_date, et.status " +
                             "FROM employee_transfers et " +
                             "JOIN companies c1 ON et.from_company_id = c1.id " +
                             "JOIN companies c2 ON et.to_company_id = c2.id " +
                             "JOIN employees e ON et.employee_id = e.id " +
                             "WHERE c2.company_name = ? AND et.status = 'Destination Company'";
                ps = conn.prepareStatement(sql);
                ps.setString(1, companyName);
                rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) {
                    %>
                    <p>No pending transfer requests found for Destination Company.</p>
                    <%
                } else {
                    %>
                    <table>
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Employee Name</th>
                                <th>Current Company</th>
                                <th>Destination Company</th>
                                <th>Request Date</th>
                                <th>Status</th>
                                <th>Salary</th>
                                <th>Personal Pension</th>
                                <th>Workplace Pension</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                    <%
                    while (rs.next()) {
                        String transferId = rs.getString("id");
                        String employeeName = rs.getString("employee_name");
                        String currentCompany = rs.getString("current_company");
                        String destinationCompany = rs.getString("destination_company");
                        String requestDate = rs.getDate("request_date").toString();
                        String status = rs.getString("status");
                    %>
                        <tr>
                            <td><%= transferId %></td>
                            <td><%= employeeName %></td>
                            <td><%= currentCompany %></td>
                            <td><%= destinationCompany %></td>
                            <td><%= requestDate %></td>
                            <td><%= (rs.getString("status").equalsIgnoreCase("Current Company") || rs.getString("status").equalsIgnoreCase("Destination Company")) ? "Pending Approval from " + rs.getString("status")  : rs.getString("status") %></td>
                            <td>
                                <input type="number" id="salaryInput-<%= transferId %>" oninput="calculatePensions('<%= transferId %>')" required>
                            </td>
                            <td>
                                <input type="number" id="personalPensionInput-<%= transferId %>" readonly>
                            </td>
                            <td>
                                <input type="number" id="workplacePensionInput-<%= transferId %>" readonly>
                            </td>
                            <td class="action-buttons">
                                <form id="approveForm-<%= transferId %>" action="ApproveRejectTransferServlet" method="post">
                                    <input type="hidden" name="transferId" value="<%= transferId %>">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="companyType" value="destination">
                                    <input type="hidden" name="salary" value="">
                                    <input type="hidden" name="personalPension" value="">
                                    <input type="hidden" name="workplacePension" value="">
                                    <button type="button" class="approve" onclick="approveWithSalary('<%= transferId %>', 'destination')">Approve</button>
                                </form>
                                <form id="rejectForm-<%= transferId %>" action="ApproveRejectTransferServlet" method="post">
                                    <input type="hidden" name="transferId" value="<%= transferId %>">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="companyType" value="destination">
                                    <input type="hidden" name="reason" value="">
                                    <button type="button" class="reject" onclick="confirmReject('<%= transferId %>', 'destination')">Reject</button>
                                </form>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                        </tbody>
                    </table>
                    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
                if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        %>
    </div>
</div>

<div class="footer">
    <p>&copy; 2024 Pension Portal. All rights reserved.</p>
</div>

</body>
</html>
