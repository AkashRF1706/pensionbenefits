<%@page import="com.opencsv.bean.ConverterUUID"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Request Transfer</title>
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

.form-group {
	margin: 15px 0;
	text-align: left;
}

.form-group label {
	font-size: 18px;
	margin-bottom: 5px;
	display: block;
}

.form-group select, input {
	padding: 10px;
	width: 100%;
	box-sizing: border-box;
	font-size: 16px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

.form-group button {
	background-color: #4CAF50;
	color: white;
	padding: 15px 25px;
	border: none;
	cursor: pointer;
	font-size: 18px;
	margin-top: 20px;
}

.form-group button:hover {
	background-color: #45a049;
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
</style>
</head>
<body>
	<% 
    String email = (String) session.getAttribute("email");
	String userId = session.getAttribute("userId").toString();
    int employeeId = -1;
    int currentCompany = 0;
    String currentCompanyName = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        String query = "SELECT e.id as empId, c.id as compId, e.company FROM employees e join companies c on e.company = c.company_name WHERE e.email = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, email);
        rs = ps.executeQuery();
        if (rs.next()) {
            employeeId = rs.getInt("empId");
            currentCompany = rs.getInt("compId");
            currentCompanyName = rs.getString("company");
            session.setAttribute("employeeId", employeeId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

	<% if (request.getParameter("success") != null) { %>
	<script>alert('Transfer Request Initiated');</script>
	<% } %>
	<% if (request.getParameter("error") != null) { %>
	<script>alert('Transfer Request failed. Please try again');</script>
	<% } %>
	<% if (request.getParameter("Pending") != null) { %>
	<script>alert('Your previous request is pending. Please contact your company.');</script>
	<% } %>
	<div class="header">
		<h1>Request Transfer</h1>
	</div>

	<div class="navbar">
		<a href="pensioner.jsp">Home</a> <a href="profile.jsp">Profile</a> <a
			href="managePension.jsp">Manage Pension</a> <a href="myRequests.jsp">My
			Pension Requests</a> <a href="contact.jsp">Contact</a> <a
			href="logout.jsp">Logout</a>
	</div>

	<div class="main">
		<h2>Employee Transfer Request Form</h2>
		<form action="TransferRequestServlet" method="post">
			<div class="form-group">
				<label for="currentCompany">Current Company:</label> <input
					type="text" name="currentCompanyName" id="currentCompanyName"
					value="<%=currentCompanyName%>" readonly="readonly"> <input
					type="hidden" name="currentCompany" id="currentCompany"
					value="<%=currentCompany%>">
			</div>

			<div class="form-group">
				<label for="destinationCompany">Destination Company:</label> <select
					name="destinationCompany" id="destinationCompany" required>
					<option value="">Select Destination Company</option>
					<% 
                    // Same code block as above for populating destination company dropdown
                    conn = DatabaseConnection.getConnection();
                    try {
                        String query = "SELECT id, company_name FROM companies";
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                %>
					<option value="<%= rs.getInt("id") %>"><%= rs.getString("company_name") %></option>
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
				</select>
			</div>

			<div class="form-group">
				<input type="hidden" name="employeeId" value="<%= employeeId %>">
				<button type="submit">Submit Transfer Request</button>
			</div>
		</form>

		<%
        boolean hasRecords = false;
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT et.id, c1.company_name AS current_company, c2.company_name AS destination_company, et.request_date, et.status, IFNULL(et.notes, 'N/A') as notes " +
                           "FROM employee_transfers et " +
                           "JOIN companies c1 ON et.from_company_id = c1.id " +
                           "JOIN companies c2 ON et.to_company_id = c2.id " +
                           "WHERE et.employee_id = ? order by request_date desc";
            ps = conn.prepareStatement(query);
            ps.setInt(1, employeeId);
            rs = ps.executeQuery();
            if (rs.isBeforeFirst()) { // Check if there are any records
                hasRecords = true;
            }
        %>
		<% if (hasRecords) { %>
		<h2>Your Transfer Requests</h2>
		<table border="1" width="100%">
			<thead>
				<tr>
					<th>Transfer ID</th>
					<th>Current Company</th>
					<th>Destination Company</th>
					<th>Request Date</th>
					<th>Status</th>
					<th>Notes</th>
				</tr>
			</thead>
			<tbody>
				<% 
                    while (rs.next()) {
                %>
				<tr>
					<td><%= rs.getInt("id") %></td>
					<td><%= rs.getString("current_company") %></td>
					<td><%= rs.getString("destination_company") %></td>
					<td><%= rs.getTimestamp("request_date") %></td>
					<td><%= (rs.getString("status").equalsIgnoreCase("Current Company") || rs.getString("status").equalsIgnoreCase("Destination Company")) ? "Pending Approval from " + rs.getString("status")  : rs.getString("status") %></td>
					<td><%= rs.getString("notes") %></td>
				</tr>
				<% 
                    }
                %>
			</tbody>
		</table>
		<% } %>
		<%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    %>
	</div>

	<div class="footer">
		<p>&copy; 2024 Pension Portal. All rights reserved.</p>
	</div>

</body>
</html>
