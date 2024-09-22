<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Apply for Benefits - Pension Portal</title>
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

.apply-container {
    max-width: 800px;
    margin: 0 auto;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.apply-section {
    margin-bottom: 20px;
}

.apply-section h2 {
    color: #4CAF50;
    margin-bottom: 10px;
}

.apply-section p {
    font-size: 16px;
    line-height: 1.5;
}

.form-container {
    text-align: left;
}

.form-container label {
    display: block;
    margin: 10px 0 5px;
    font-weight: bold;
}

.form-container select, .form-container textarea, .form-container input[type="submit"] {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.form-container input[type="submit"] {
    background-color: #4CAF50;
    color: white;
    cursor: pointer;
}

.form-container input[type="submit"]:hover {
    background-color: #45a049;
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
</style>
</head>
<body>
    <div class="header">
        <h1>Apply for Benefits</h1>
    </div>
    <div class="navbar">
        <a href="pensioner.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="benefits.jsp">Benefits</a>
        <a href="apply.jsp">Apply</a>
        <a href="contact.jsp">Contact</a>
    </div>
    <div class="main">
        <div class="apply-container">
            <div class="apply-section">
                <h2>Select a Benefit to Apply</h2>
                <div class="form-container">
                    <form action="applyBenefitServlet" method="post">
                        <label for="benefit">Benefit:</label>
                        <select id="benefit" name="benefit_id" required>
                            <option value="" disabled selected>Select a benefit</option>
                            <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;

                                try {
                                    conn = DatabaseConnection.getConnection();
                                    String sql = "SELECT * FROM benefits";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();

                                    while (rs.next()) {
                                        int benefitId = rs.getInt("benefit_id");
                                        String benefitName = rs.getString("benefit_name");
                            %>
                                        <option value="<%= benefitId %>"><%= benefitName %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                }
                            %>
                        </select>
                        <label for="reason">Reason for Applying:</label>
                        <textarea id="reason" name="reason" rows="4" required></textarea>
                        <input type="submit" value="Apply">
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
