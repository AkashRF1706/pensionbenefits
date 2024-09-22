<%@page import="database.EmployeeDAO"%>
<%@page import="database.DatabaseConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.Employee, database.EmployeeDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee List</title>
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
        .container {
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            max-width: 100%;
            margin: 20px auto;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: left;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
            font-size: 14px;
            word-wrap: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        th {
            background-color: #4CAF50;
            color: white;
            width: 150px;
        }
        td {
            max-width: 150px;
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
        .no-operations {
            margin-top: 20px;
            font-size: 24px;
            color: #555;
        }
        .alert-warning {
            background-color: #f9e3b4;
            padding: 15px;
            border: 1px solid #f0c36d;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .alert-warning h4 {
            margin-top: 0;
        }
        .status-button {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            color: white;
            cursor: pointer;
        }
        .active-button {
            background-color: #4CAF50;
        }
        .inactive-button {
            background-color: #f44336;
        }
        .pending-text {
            color: #555;
            font-weight: bold;
        }
    </style>
    <script>
    function confirmStatusChange(niNumber, currentStatus) {
        var newStatus = currentStatus === 'Active' ? 'Inactive' : 'Active';
        const confirmation = confirm('Are you sure you want to change the status to ' + newStatus + ' ?');
        if (confirmation) {
            window.location.href = 'UpdateEmployeeStatusServlet?niNumber=' + niNumber + '&newStatus=' + newStatus;
        }
    }
    </script>
</head>
<body>
<% if (request.getParameter("employeeAdded") != null) { %>
    <script>alert('Employee Added successfully!!!');</script>
<% } %>
<% if (request.getParameter("employeesAdded") != null) { %>
    <script>alert('Employees Added successfully!!!');</script>
<% } %>
<% if (request.getParameter("statusUpdateSuccess") != null) { %>
	<script>alert('Employee Status Update Success');</script>
<% } %>
<% if (request.getParameter("statusUpdateFailed") != null) { %>
	<script>alert('Employee Status Update failed. Please try again');</script>
<% } %>
<div class="header">
    <h1>Employee List</h1>
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
<div class="container">
    <%
        String failed = request.getParameter("failed");
        List<Employee> failedEmployees = null;

        if ("true".equals(failed)) {
            failedEmployees = (List<Employee>) session.getAttribute("failedEmployees");

            if (failedEmployees != null && !failedEmployees.isEmpty()) {
                request.setAttribute("failedEmployees", failedEmployees);
                session.removeAttribute("failedEmployees");
            }
        }
    %>
    <% if ("true".equals(failed) && request.getAttribute("failedEmployees") != null) { %>
    <div class="alert-warning">
        <h4>Failed to Add Some Employees</h4>
        <p>The following employees could not be added due to duplicate email or NI number:</p>
        <ul>
            <%
                List<Employee> failedEmpList = (List<Employee>) request.getAttribute("failedEmployees");
                for (Employee emp : failedEmpList) {
            %>
                <li><strong><%= emp.getFirstName() %> <%= emp.getLastName() %></strong> 
                    (Email: <%= emp.getEmail() %>, NI Number: <%= emp.getNiNumber() %>)
                </li>
            <% } %>
        </ul>
    </div>
<% } %>

    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            String company = session.getAttribute("company").toString();
            EmployeeDAO employeeDAO = new EmployeeDAO();
            List<Employee> employees = employeeDAO.getAllEmployees(company);
            if (employees != null && !employees.isEmpty()) {
    %>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>NI Number</th>
                    <th>Company</th>
                    <th>Annual Salary</th>
                    <th>Personal Pension</th>
                    <th>Workplace Pension</th>
                    <th>Employment Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Employee employee : employees) {
                        String status = employee.getEmployeeStatus();
                        String statusClass = status.equals("Active") ? "active-button" : "inactive-button";
                        boolean isPending = status.equals("Pending");
                %>
                <tr>
                    <td><%= employee.getFirstName() %> <%= employee.getLastName() %></td>
                    <td><%= employee.getEmail() %></td>
                    <td><%= employee.getNiNumber() %></td>
                    <td><%= employee.getCompany() %></td>
                    <td><%= employee.getAnnualSalary() %></td>
                    <td><%= employee.getPersonalPension() %></td>
                    <td><%= employee.getWorkplacePension() %></td>
                    <td>
                        <%
                            if (isPending) {
                        %>
                            <span class="pending-text">Pending Transfer</span>
                        <%
                            } else {
                        %>
                            <button class="status-button <%= statusClass %>" 
                                    onclick="confirmStatusChange('<%= employee.getNiNumber() %>', '<%= status %>')">
                                <%= status %>
                            </button>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    <% 
            } else { 
    %>
        <p class="no-operations">No records to display. <a href="addEmployee.jsp">Add Employee</a></p>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>
</body>
</html>
