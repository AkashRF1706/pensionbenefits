<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DatabaseConnection, java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Profile - Pension Portal</title>
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
        .profile-info {
            text-align: left;
            margin: 0 auto;
            max-width: 600px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .profile-info h3 {
            color: #4CAF50;
        }
        .profile-info p {
            font-size: 16px;
            line-height: 1.5;
        }
        .profile-info label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        .profile-info input[type="text"], .profile-info input[type="email"], .profile-info input[type="tel"], .profile-info select {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .profile-info button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .profile-info button:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function validateContact(input) {
            input.setCustomValidity('');
            if (!input.validity.valid) {
                input.setCustomValidity('Contact number must be exactly 10 digits long.');
            }
        }
    </script>
</head>
<body>
<% 
if (request.getParameter("updateSuccess") != null) { %>
<script>alert('Profile updated');</script>
<%}

if (request.getParameter("updateError") != null) { %>
<script>alert('Error updating. Please try again!');</script>
<%}

int userId = (Integer) session.getAttribute("userId");
Connection conn = null;
ResultSet rs1 = null;
String user = "";

try {
    conn = DatabaseConnection.getConnection();
    String userSql = "SELECT role_id FROM user_roles WHERE user_id = ?";
    PreparedStatement ptst = conn.prepareStatement(userSql);
    ptst.setInt(1, userId);
    rs1 = ptst.executeQuery();
    
    if (rs1.next()) {
        int roleId = rs1.getInt("role_id");
        switch (roleId) {
            case 1:
                user = "Administrator";
                break;
            case 2:
                user = "Pension Officer";
                break;
            case 3:
                user = "Pensioner";
                break;
        }
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs1 != null) try { rs1.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>
    <div class="header">
        <h1>Welcome to Pension Portal</h1>
    </div>
    <% if ("Pensioner".equalsIgnoreCase(user)) { %>
   <div class="navbar">
		<a href="pensioner.jsp">Home</a> 
		<a href="profile.jsp">Profile</a> 
		<a href="managePension.jsp">Manage Pension</a> 
		<a href="myRequests.jsp">My Pension Requests</a> 
		<a href="employeeChat.jsp">Contact</a> 
		<a href="logout.jsp">Logout</a>
	</div>
    <% } %>
    <div class="main">
        <h2>Your Profile</h2>
        <div class="profile-info">
            <form action="updateProfileServlet" method="post">
                <%
                Connection conn2 = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    conn2 = DatabaseConnection.getConnection();
                    String sql = "SELECT * FROM users WHERE user_id = ?";
                    pstmt = conn2.prepareStatement(sql);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String fname = rs.getString("first_name");
                        String lname = rs.getString("last_name");
                        String email = rs.getString("email");
                        String username = rs.getString("username");
                        String contact = rs.getString("contact_no") != null ? rs.getString("contact_no").substring(3) : "";
                        String gender = rs.getString("gender") != null ? rs.getString("gender") : "";
                        String genderVal;
                        
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                        LocalDate dob = LocalDate.parse(rs.getDate("date_of_birth").toString(), formatter);
                        LocalDate currentDate = LocalDate.now();
                        Period period = Period.between(dob, currentDate);
                        int age = period.getYears();
                        

                        if ("M".equals(gender)) {
                            genderVal = "Male";
                        } else if ("F".equals(gender)) {
                            genderVal = "Female";
                        } else {
                            genderVal = "Other";
                        }
                %>
                            <input type="hidden" name="user_id" value="<%= userId %>">
                            <label for="fname">First Name:</label>
                            <input type="text" id="fname" name="first_name" value="<%= fname %>" required readonly="readonly">

                            <label for="lname">Last Name:</label>
                            <input type="text" id="lname" name="last_name" value="<%= lname %>" required readonly="readonly">
                            
                            <label for="lname">Age:</label>
                            <input type="text" id="age" name="age" value="<%= age %>" required readonly="readonly">

                            <label for="email">Email:</label>
                            <input type="email" id="email" name="email" value="<%= email %>" required readonly="readonly">

                            <label for="username">Username:</label>
                            <input type="text" id="username" name="username" value="<%= username %>" required readonly>

                            <label for="contact">Contact Number:</label>
							<input type="tel" id="contact" name="contact" value="<%= contact %>" pattern="\d{10}" oninvalid="validateContact(this)" oninput="validateContact(this)" maxlength="10" required>


                            <label for="gender">Gender:</label>
                            <input type="text" id="gender" name="gender" value="<%= genderVal %>" required readonly="readonly">

                            <button type="submit">Update Contact</button>
                <%
                    } else {
                        out.println("<p>User details not found.</p>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Error retrieving user details.</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn2 != null) try { conn2.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                %>
            </form>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
