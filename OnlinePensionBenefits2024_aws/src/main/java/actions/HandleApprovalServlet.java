package actions;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.DatabaseConnection;

@WebServlet("/handleApprovalServlet")
public class HandleApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int companyId = Integer.parseInt(request.getParameter("companyId"));
        boolean isApproved = Boolean.parseBoolean(request.getParameter("isApproved"));

        try {
            Connection conn = DatabaseConnection.getConnection();
            String sql;
            
            if (isApproved) {
                sql = "UPDATE users SET status = 'Active' WHERE user_id = ?";
            } else {
                sql = "UPDATE users SET status = 'Rejected' WHERE user_id = ?";
            }
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, companyId);
            int rowsUpdated = stmt.executeUpdate();
            
            conn.close();
            
            if (rowsUpdated > 0) {
                response.sendRedirect("companyApproval.jsp?success");
            } else {
                response.sendRedirect("companyApproval.jsp?failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("approveCompanies.jsp?status=error");
        }
    }
}
