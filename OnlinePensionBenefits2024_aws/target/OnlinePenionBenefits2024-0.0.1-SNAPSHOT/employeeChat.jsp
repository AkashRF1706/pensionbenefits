<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Chat</title>
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
        .chat-container {
            width: 50%;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1);
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
        .message {
    padding: 10px;
    margin: 5px 0;
    border-radius: 5px;
    background-color: #f1f1f1;
}

.sent {
    background-color: #dcf8c6;
    text-align: left;
}

.received {
    background-color: #fff;
    text-align: left;
}

    </style>
</head>
<body>
<div class="header">
		<h1>Company Contact</h1>
	</div>

	<div class="navbar">
		<a href="pensioner.jsp">Home</a> 
		<a href="profile.jsp">Profile</a> 
		<a href="managePension.jsp">Manage Pension</a> 
		<a href="myRequests.jsp">My Pension Requests</a> 
		<a href="employeeChat.jsp">Contact</a> 
		<a href="logout.jsp">Logout</a>
	</div>
    <div class="chat-container">
        <div class="chat-box" id="chat-box">
            <!-- Messages will be displayed here -->
        </div>
        <input type="text" id="message" class="message-input" placeholder="Type your message here...">
        <button class="send-button" onclick="sendMessage()">Send</button>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        fetchMessages(); // Fetch messages immediately on page load
        setInterval(fetchMessages, 3000); // Continue fetching messages every 3 seconds
    });

        function fetchMessages() {
            $.ajax({
                url: 'FetchMessagesServlet',
                method: 'GET',
                success: function(data) {
                    $('#chat-box').html(data);
                    $('#chat-box').scrollTop($('#chat-box')[0].scrollHeight);
                }
            });
        }

        function sendMessage() {
            var message = $('#message').val();
            var email = $('email').val();
            if (message == '') return;
            $.ajax({
                url: 'SendMessageServlet',
                method: 'POST',
                data: {
                    message: message,
                    sender: 'Employee'
                },
                success: function() {
                    $('#message').val('');
                    fetchMessages();
                }
            });
        }
    </script>
</body>
</html>
