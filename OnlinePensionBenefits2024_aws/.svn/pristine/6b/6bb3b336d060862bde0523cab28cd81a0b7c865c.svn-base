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

@WebServlet("/WithdrawPensionServlet")
public class WithdrawPensionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        double withdrawAmount = Double.parseDouble(request.getParameter("withdrawAmount"));
        String withdrawReason = request.getParameter("withdrawReason");
        String otherReason = request.getParameter("otherReason");
        int employeeId = Integer.parseInt(request.getParameter("empId"));

        if (withdrawReason.equals("Other") && otherReason != null && !otherReason.trim().isEmpty()) {
            withdrawReason = otherReason;
        }

        try {
            Connection conn = DatabaseConnection.getConnection();
            
            String sqlSelect = "Select employee_status from employees where id = ? and employee_status = 'Pending'";
            PreparedStatement psql = conn.prepareStatement(sqlSelect);
            psql.setInt(1, employeeId);
            ResultSet rsSql = psql.executeQuery();
            if(rsSql.next()) {
            	response.sendRedirect("managePension.jsp?TransferRequest");
            	return;
            }
            
            String selectQuery = "SELECT withdraw_flag FROM pensions WHERE withdraw_flag IN ('C','A') AND employee_id = ?";
            PreparedStatement ptst = conn.prepareStatement(selectQuery);
            ptst.setInt(1, employeeId);
            ResultSet rs = ptst.executeQuery();
            if(rs.next()) {
                response.sendRedirect("myRequests.jsp?RequestPending");
                return;
            }

            String sqlUpdate = "UPDATE pensions SET withdraw_pension_amount = ?, withdraw_flag = ? WHERE employee_id = ? "
                            + " AND withdraw_flag NOT IN (?, ?)";
            PreparedStatement pstUpdate = conn.prepareStatement(sqlUpdate);
            pstUpdate.setDouble(1, withdrawAmount);
            pstUpdate.setString(2, "C");
            pstUpdate.setInt(3, employeeId);
            pstUpdate.setString(4, "C");
            pstUpdate.setString(5, "A");

            int rowsUpdated = pstUpdate.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Insert the operation into pension_operations table
                String insertOperation = "INSERT INTO pension_operations (employee_id, operation_type, amount, status, withdraw_reason) "
                                       + "VALUES (?, 'Withdraw', ?, 'Company Pending', ?)";
                PreparedStatement pstInsertOperation = conn.prepareStatement(insertOperation);
                pstInsertOperation.setInt(1, employeeId);
                pstInsertOperation.setDouble(2, withdrawAmount);
                pstInsertOperation.setString(3, withdrawReason);
                pstInsertOperation.executeUpdate();
                pstInsertOperation.close();

                response.sendRedirect("myRequests.jsp?withdrawSuccess");
            } else {
                response.sendRedirect("myRequests.jsp?withdrawFailed");
            }

            pstUpdate.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myRequests.jsp?withdrawFailed");
        }
    }
}
