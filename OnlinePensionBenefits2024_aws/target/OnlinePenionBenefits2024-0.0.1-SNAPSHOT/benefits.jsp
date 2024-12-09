<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="database.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Online Pension Benefits - Benefits</title>
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

.benefits-container {
    max-width: 800px;
    margin: 0 auto;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.benefit-section {
    margin-bottom: 20px;
}

.benefit-section h2 {
    color: #4CAF50;
    margin-bottom: 10px;
}

.benefit-section p {
    font-size: 16px;
    line-height: 1.5;
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
        <h1>Benefits</h1>
    </div>
    <div class="navbar">
        <a href="pensioner.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="benefits.jsp">Benefits</a>
        <a href="apply.jsp">Apply</a>
        <a href="contact.jsp">Contact</a>
    </div>
    <div class="main">
        <div class="benefits-container">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "SELECT * FROM benefits";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    if(rs.next()){
                        do {
                            int benefitId = rs.getInt("benefit_id");
                            String benefitName = rs.getString("benefit_name");
                            String description = rs.getString("description");
            %>
            <div class="benefit-section">
                <h2><%= benefitName %></h2>
                <p><%= description %></p>
            </div>
            <%
                        } while (rs.next());
                    } else {
            %>
            <h2>No benefits to display.</h2>
            <%
                    }
                } catch(Exception e){
                    e.printStackTrace();
                    out.println("<p>Error loading benefits. Please try again later.</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </div>
    </div>
    <div class="footer">
        <p>&copy; 2024 Pension Portal. All rights reserved.</p>
    </div>
</body>
</html>
