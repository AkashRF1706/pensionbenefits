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
import database.DatabaseConnection;

@WebServlet("/TransferRequestServlet")
public class TransferRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String employeeId = request.getParameter("employeeId");
        String currentCompanyId = request.getParameter("currentCompany");
        String destinationCompanyId = request.getParameter("destinationCompany");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();
            
            String selectSql = "Select * from employee_transfers where employee_id = ? and status in ('Current Company', 'Destination Company')";
            PreparedStatement ptst = conn.prepareStatement(selectSql);
            ptst.setInt(1, Integer.parseInt(employeeId));
            ResultSet rs = ptst.executeQuery();
            if(rs.next()) {
            	response.sendRedirect("transferRequest.jsp?Pending");
            	return;
            }
            String sql = "INSERT INTO employee_transfers (employee_id, from_company_id, to_company_id, request_date, status) VALUES (?, ?, ?, NOW(), ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(employeeId));
            ps.setInt(2, Integer.parseInt(currentCompanyId));
            ps.setInt(3, Integer.parseInt(destinationCompanyId));
            ps.setString(4, "Current Company");
            int result = ps.executeUpdate();
            if (result > 0) {
            	String updateSql = "Update employees set employee_status = ? where id = ?";
            	PreparedStatement ps1 = conn.prepareStatement(updateSql);
            	ps1.setString(1, "Pending");
            	ps1.setInt(2, Integer.parseInt(employeeId));
            	ps1.executeUpdate();
                response.sendRedirect("transferRequest.jsp?success");
                return;
            } else {
                response.sendRedirect("transferRequest.jsp?error");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("transferRequest.jsp?error");
            return;
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
