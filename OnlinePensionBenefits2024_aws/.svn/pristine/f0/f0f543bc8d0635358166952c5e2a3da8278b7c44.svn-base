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

@WebServlet("/FetchEmployeesServlet")
public class FetchEmployeesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(session.getAttribute("userId").toString());

        if (userId <= 0) {
            out.println("No userId found in session.");
            return;
        }

        try {
            Connection conn = DatabaseConnection.getConnection();
            
         // Fetch company_id based on email
            String selectSQL = "SELECT c.id as compId FROM companies c WHERE c.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(selectSQL);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            String companyId = "";
            if (rs.next()) {
                companyId = "c" + rs.getInt("compId");
            } else {
                out.println("No company found for this email.");
                return;
            }
            String sql = "SELECT DISTINCT sender_id, sender_name, MAX(created_at) AS last_message_time FROM messages WHERE receiver_id = ? "
            		+ " GROUP BY sender_id, sender_name order by last_message_time DESC";
            PreparedStatement ptst = conn.prepareStatement(sql);
            ptst.setString(1, companyId);
            ResultSet rs1 = ptst.executeQuery();

            while (rs1.next()) {
                String employeeId = rs1.getString("sender_id");
                String employeeName = rs1.getString("sender_name");
                out.println("<div class='employee-container' onclick='selectEmployee(\"" + employeeId + "\")'>");
                out.println("<span class='employee-name'>" + employeeName + "</span>");
                out.println("</div>");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
