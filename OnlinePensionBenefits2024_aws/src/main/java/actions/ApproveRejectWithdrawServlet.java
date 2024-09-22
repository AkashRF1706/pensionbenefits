package actions;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import database.DatabaseConnection;
import servlet.EmailUtil;

@WebServlet("/ApproveRejectWithdrawServlet")
public class ApproveRejectWithdrawServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String employeeId = request.getParameter("employeeId");
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String employeeName = request.getParameter("employeeName");
        String statusFlag = "R";  // Default to rejection
        String details = "";
        String loginLink = "http://localhost:8080/OnlinePenionBenefits2024/login.jsp";
        EmailUtil emailUtil = new EmailUtil();
        
        if(!action.endsWith("e")) {
        	details = request.getParameter("details");
        }
        try {
            Connection conn = DatabaseConnection.getConnection();
            String sql = "";

            if (!("adminApprove".equalsIgnoreCase(action))) {
                statusFlag = "approve".equalsIgnoreCase(action) ? "A" : "R";  // Send to Admin approval
                String emailDecision = statusFlag.equals("R") ? "Rejected" : "";
                String emailMessage = "Hello " + employeeName + ",<br/><br/>" +
                        "Your pension update request has been " + emailDecision +
                        ". Please <a href='" + loginLink + "'>log in</a> to view the details.";
                
                sql = "UPDATE pensions SET withdraw_flag = ? WHERE employee_id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, statusFlag);
                pst.setInt(2, Integer.parseInt(employeeId));
                int rowsUpdated = pst.executeUpdate();

                if (rowsUpdated > 0) {
                    // Update the pension_operations table based on statusFlag
                    String updateOperationSql = "UPDATE pension_operations SET status = ?, details = ? WHERE employee_id = ? AND operation_type = 'Withdraw' AND status NOT IN ('Approved', 'Rejected')";
                    PreparedStatement pstUpdateOperation = conn.prepareStatement(updateOperationSql);
                    String operationStatus = "R".equals(statusFlag) ? "Rejected" : "Admin Pending";

                    pstUpdateOperation.setString(1, operationStatus);
                    pstUpdateOperation.setString(2, details);
                    pstUpdateOperation.setInt(3, Integer.parseInt(employeeId));
                    pstUpdateOperation.executeUpdate();
                    pstUpdateOperation.close();
                    
                    if(!emailDecision.isEmpty()) {
                    	emailUtil.sendEmailNotification(email, "Pension Withdraw Request Decision", emailMessage);
                    }

                    response.sendRedirect("pensionRequests.jsp?withdrawSuccess");
                } else {
                    response.sendRedirect("pensionRequests.jsp?withdrawFailed");
                }

                pst.close();
            } else if("adminApprove".equalsIgnoreCase(action)) {
                statusFlag = "AP"; // Approved by admin
                String emailDecision = "Approved";
                String emailMessage = "Hello " + employeeName + ",<br/><br/>" +
                        "Your pension update request has been " + emailDecision +
                        ". Please <a href='" + loginLink + "'>log in</a> to view the details.";
                
                sql = "UPDATE pensions SET withdraw_flag = ?, pension_amount = pension_amount - withdraw_pension_amount, used_pension = used_pension + withdraw_pension_amount, "
                    + "withdraw_pension_amount = 0, last_updated_date = ? WHERE employee_id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, statusFlag);
                pst.setTimestamp(2, java.sql.Timestamp.valueOf(LocalDateTime.now()));
                pst.setInt(3, Integer.parseInt(employeeId));
                int rowsUpdated = pst.executeUpdate();

                if (rowsUpdated > 0) {
                    // Update the pension_operations table for approval
                    String updateOperationSql = "UPDATE pension_operations SET status = ? WHERE employee_id = ? AND operation_type = 'Withdraw' AND status NOT IN ('Approved', 'Rejected')";
                    PreparedStatement pstUpdateOperation = conn.prepareStatement(updateOperationSql);
                    pstUpdateOperation.setString(1, "Approved");
                    pstUpdateOperation.setInt(2, Integer.parseInt(employeeId));
                    pstUpdateOperation.executeUpdate();
                    pstUpdateOperation.close();
                    
                    emailUtil.sendEmailNotification(email, "Pension Withdraw Request Decision", emailMessage);

                    response.sendRedirect("pensionRequests.jsp?withdrawSuccess");
                } else {
                    response.sendRedirect("pensionRequests.jsp?withdrawFailed");
                }

                pst.close();
            }            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pensionRequests.jsp?withdrawFailed");
        }
    }
}
