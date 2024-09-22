package actions;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.DatabaseConnection;

@WebServlet("/FetchMessagesServlet")
public class FetchMessagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        int userId = Integer.parseInt(session.getAttribute("userId").toString());        
        if (userId <= 0 || email == null) {
            out.println("No user id found in session.");
            return;
        }

        String userRole = (String) session.getAttribute("role");
        String employeeId = request.getParameter("employee_id");
        String companyId = "";

        try {
            Connection conn = DatabaseConnection.getConnection();

            if ("Company".equalsIgnoreCase(userRole)) {
                // Company is fetching messages with a specific employee
                String sql = "SELECT c.id as compId FROM companies c WHERE c.user_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    companyId = "c" + rs.getInt("compId");
                } else {
                    out.println("No company found for this email.");
                    return;
                }

                // Now fetch messages using employeeId and companyId
                sql = "SELECT m.* FROM messages m "
                    + "WHERE (m.sender_id = ? AND m.receiver_id = ?) "
                    + "OR (m.sender_id = ? AND m.receiver_id = ?) ORDER BY m.created_at";
                ps = conn.prepareStatement(sql);
                ps.setString(1, employeeId);
                ps.setString(2, companyId);
                ps.setString(3, companyId);
                ps.setString(4, employeeId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String messageClass = (rs.getString("sender_id").equals(employeeId)) ? "received" : "sent";
                    String senderName = rs.getString("sender_name");
                    String message = rs.getString("message");
                    String time = rs.getString("created_at");
                    out.println("<div class='message " + messageClass + "'>");
                    out.println("<span><strong>" + senderName + ":</strong> " + message + "</span>");
                    out.println("<span style='float:right;'>" + time + "</span>");
                    out.println("</div>");
                }
            } else {
                // Employee is fetching their own messages
                String sql = "SELECT e.id as empId, c.id as compId FROM employees e "
                           + "JOIN companies c ON e.company = c.company_name "
                           + "WHERE e.email = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    employeeId = "e" + rs.getInt("empId");
                    companyId = "c" + rs.getInt("compId");
                } else {
                    out.println("No employee or company found for this email.");
                    return;
                }

                // Now fetch messages using employeeId and companyId
                sql = "SELECT m.* FROM messages m "
                    + "WHERE (m.sender_id = ? AND m.receiver_id = ?) "
                    + "OR (m.sender_id = ? AND m.receiver_id = ?) ORDER BY m.created_at";
                ps = conn.prepareStatement(sql);
                ps.setString(1, employeeId);
                ps.setString(2, companyId);
                ps.setString(3, companyId);
                ps.setString(4, employeeId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String messageClass = (rs.getString("sender_id").equals(employeeId)) ? "sent" : "received";
                    String senderName = rs.getString("sender_name");
                    String message = rs.getString("message");
                    String time = rs.getString("created_at");
                    out.println("<div class='message " + messageClass + "'>");
                    out.println("<span><strong>" + senderName + ":</strong> " + message + "</span>");
                    out.println("<span style='float:right;'>" + time + "</span>");
                    out.println("</div>");
                }
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
