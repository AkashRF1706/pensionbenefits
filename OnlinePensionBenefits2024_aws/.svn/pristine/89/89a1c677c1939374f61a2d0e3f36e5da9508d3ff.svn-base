<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DatabaseConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Benefits - Pension Portal</title>
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
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: relative;
            bottom: 0;
            width: 100%;
        }
        .benefits-table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 80%;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .benefits-table th, .benefits-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .benefits-table th {
            background-color: #4CAF50;
            color: white;
        }
        .benefits-table tr:hover {
            background-color: #f1f1f1;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 20px 10px;
            text-decoration: none;
            display: inline-block;
        }
        .button:hover {
            background-color: #45a049;
        }
        /* Pop-up form styles */
        .popup-form {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            border-radius: 8px;
        }
        .popup-form h2 {
            margin-top: 0;
            color: #4CAF50;
        }
        .popup-form label {
            display: block;
            margin: 10px 0 5px;
        }
        .popup-form input[type="text"], .popup-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .popup-form .close-btn, .popup-form .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .popup-form .close-btn:hover, .popup-form .submit-btn:hover {
            background-color: #45a049;
        }
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Manage Benefits</h1>
    </div>
    <div class="navbar">
        <a href="pensionOfficerHome.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="manageBenefits.jsp">Manage Benefits</a>
        <a href="viewApplications.jsp">View Applications</a>
        <a href="logout.jsp">Logout</a>
    </div>
    <div class="main">
        <% 
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM benefits";
                pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                rs = pstmt.executeQuery();
                if (rs.next()) { %>
                <table class="benefits-table">
                    <tr>
                        <th>Benefit ID</th>
                        <th>Benefit Name</th>
                        <th>Description</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                    <% 
                        rs.beforeFirst();
                        while (rs.next()) {
                            int benefitId = rs.getInt("benefit_id");
                            String benefitName = rs.getString("benefit_name");
                            String description = rs.getString("description");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                    %>
                    <tr>
                        <td><%= benefitId %></td>
                        <td><%= benefitName %></td>
                        <td><%= description %></td>
                        <td><%= createdAt %></td>
                        <td>
                            <button class="button" onclick="openEditForm('<%= benefitId %>', '<%= benefitName.replace("'", "\\'") %>', '<%= description.replace("'", "\\'") %>')">Edit</button>
                            <a href="deleteBenefitServlet?benefit_id=<%= benefitId %>" class="button">Delete</a>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } else { %>
                <h2>No benefits to display.</h2>
                <% }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
        <a href="addBenefit.jsp" class="button">Add New Benefit</a>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
    
    <!-- Pop-up Form for Editing -->
    <div class="overlay" id="overlay"></div>
    <div class="popup-form" id="editForm">
        <h2>Edit Benefit</h2>
        <form id="editBenefitForm">
            <input type="hidden" id="editBenefitId" name="benefit_id">
            <label for="editBenefitName">Benefit Name:</label>
            <input type="text" id="editBenefitName" name="benefit_name">
            <label for="editDescription">Description:</label>
            <textarea id="editDescription" name="description"></textarea>
            <button type="button" class="submit-btn" onclick="submitEditForm()">Update Benefit</button>
            <button type="button" class="close-btn" onclick="closeEditForm()">Cancel</button>
        </form>
    </div>
    
    <script>
        function openEditForm(benefitId, benefitName, description) {
            document.getElementById('editBenefitId').value = benefitId;
            document.getElementById('editBenefitName').value = benefitName;
            document.getElementById('editDescription').value = description;
            document.getElementById('overlay').style.display = 'block';
            document.getElementById('editForm').style.display = 'block';
        }

        function closeEditForm() {
            document.getElementById('editForm').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }

        function submitEditForm() {
            var xhr = new XMLHttpRequest();
            var url = "updateBenefitServlet";
            var form = document.getElementById('editBenefitForm');
            var formData = new FormData(form);

            xhr.open("POST", url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    alert('Benefit updated successfully');
                    location.reload();
                }
            };
            xhr.send(formData);
        }
    </script>
</body>
</html>
