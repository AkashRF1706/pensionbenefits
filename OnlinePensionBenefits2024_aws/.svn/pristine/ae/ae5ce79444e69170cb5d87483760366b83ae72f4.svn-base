package actions;

import java.io.IOException;
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

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = session.getAttribute("email").toString();
        String sender = request.getParameter("sender");
        String message = request.getParameter("message");
        String senderId = "";
        String receiverId = "";
        String senderName = "";
        String receiverName = "";

        try {
            Connection conn = DatabaseConnection.getConnection();
            ResultSet rs = null;

            if (sender.equalsIgnoreCase("Employee")) {
                String selectSQL = "SELECT e.id as empId, e.first_name as name, e.company as companyName, c.id as compId "
                                 + "FROM employees e JOIN companies c ON e.company = c.company_name WHERE e.email = ?";
                PreparedStatement ptst = conn.prepareStatement(selectSQL);
                ptst.setString(1, email);
                rs = ptst.executeQuery();
                if (rs.next()) {
                    senderId = "e" + rs.getInt("empId");
                    receiverId = "c" + rs.getInt("compId");
                    senderName = rs.getString("name");
                    receiverName = rs.getString("companyName");
                }
            } else if (sender.equalsIgnoreCase("Company")) {
                String selectedEmployeeId = request.getParameter("receiver_id"); // Get the selected employee's ID
                int userId = Integer.parseInt(request.getParameter("userId"));

                String selectSQL = "SELECT c.id as compId, c.company_name as companyName, e.first_name as employeeName "
                                 + "FROM companies c JOIN employees e ON e.company = c.company_name "
                                 + "WHERE c.user_id = ? AND e.id = ?";
                PreparedStatement ptst = conn.prepareStatement(selectSQL);
                ptst.setInt(1, userId); // Use the company userId from the session
                ptst.setString(2, selectedEmployeeId.substring(1)); // Use the employee ID from the request
                rs = ptst.executeQuery();

                if (rs.next()) {
                    senderId = "c" + rs.getInt("compId");
                    receiverId = selectedEmployeeId;
                    senderName = rs.getString("companyName");
                    receiverName = rs.getString("employeeName");
                }
            }

            if (!senderId.isEmpty() && !receiverId.isEmpty()) {
                // Insert the message into the messages table
                String insertMessageSQL = "INSERT INTO messages (sender_id, receiver_id, sender_name, receiver_name, message) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement psMessage = conn.prepareStatement(insertMessageSQL);
                psMessage.setString(1, senderId);
                psMessage.setString(2, receiverId);
                psMessage.setString(3, senderName);
                psMessage.setString(4, receiverName);
                psMessage.setString(5, message);
                psMessage.executeUpdate();
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
