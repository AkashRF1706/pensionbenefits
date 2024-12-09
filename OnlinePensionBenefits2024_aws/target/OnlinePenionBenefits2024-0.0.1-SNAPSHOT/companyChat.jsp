<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Company Chat</title>
    <style>
        /* CSS styles */
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

        .container {
            display: flex;
            width: 80%;
            margin: 50px auto;
        }

        .employee-list, .chat-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1);
            margin-right: 10px;
        }

        .employee-list {
            width: 25%;
            height: 500px;
            overflow-y: auto;
        }

        .chat-container {
            width: 70%;
            height: 500px;
        }

        .chat-box {
            height: 400px;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow-y: scroll;
            padding: 10px;
        }

        .message-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 10px;
        }

        .send-button {
            margin-top: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        /* Employee List Item Styling */
        .employee-container {
            background-color: #f9f9f9;
            margin-bottom: 10px;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .employee-container:hover {
            background-color: #e0f7fa;
        }

        .employee-name {
            font-size: 16px; 
            font-weight: bold; 
            color: #333;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Employee Chats</h1>
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
    <div class="employee-list" id="employee-list">
        <!-- Employee list will be populated here -->
    </div>
    <div class="chat-container">
        <div class="chat-box" id="chat-box">
            <!-- Chat messages will be displayed here -->
        </div>
        <input type="text" id="message" class="message-input" placeholder="Type your message here...">
        <input type="hidden" name="userId" id="userId" value="<%=Integer.parseInt(session.getAttribute("userId").toString())%>">
        <button class="send-button" onclick="sendMessage()">Send</button>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
var currentEmployeeId = null;
var messageInterval;
var employeeInterval;

$(document).ready(function() {
    fetchEmployees(); // Fetch the initial list of employees
    employeeInterval = setInterval(fetchEmployees, 5000); 
});

    function fetchEmployees() {
        $.ajax({
            url: 'FetchEmployeesServlet',
            method: 'GET',
            success: function(data) {
                $('#employee-list').html(data);
                console.log("Employees loaded successfully.");
            },
            error: function(xhr, status, error) {
                console.error("Error fetching employees: " + error);
            }
        });
    }

    function selectEmployee(employeeId) {
        currentEmployeeId = employeeId;
        console.log("Selected employee ID: " + employeeId);
        fetchMessages(); // Fetch initial messages
        if (messageInterval) {
            clearInterval(messageInterval);
        }
        messageInterval = setInterval(fetchMessages, 3000);
    }

    function fetchMessages() {
        if (currentEmployeeId === null) {
            console.warn("No employee selected.");
            return;
        }

        $.ajax({
            url: 'FetchMessagesServlet',
            method: 'GET',
            data: { employee_id: currentEmployeeId },
            success: function(data) {
                $('#chat-box').html(data);
                $('#chat-box').scrollTop($('#chat-box')[0].scrollHeight);
                console.log("Messages loaded successfully.");
            },
            error: function(xhr, status, error) {
                console.error("Error fetching messages: " + error);
            }
        });
    }

    function sendMessage() {
        var message = $('#message').val();
        var userId = $('#userId').val();
        if (message === '' || !currentEmployeeId) return;

        $.ajax({
            url: 'SendMessageServlet',
            method: 'POST',
            data: {
                message: message,
                sender: 'Company',
                userId: userId,
                receiver_id: currentEmployeeId
            },
            success: function() {
                $('#message').val('');
                fetchMessages();
            },
            error: function(xhr, status, error) {
                console.error("Error sending message: " + error);
            }
        });
    }
</script>
</body>
</html>
