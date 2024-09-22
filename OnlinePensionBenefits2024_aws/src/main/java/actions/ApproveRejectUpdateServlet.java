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
import servlet.EmailUtil;

@WebServlet("/ApproveRejectUpdateServlet")
public class ApproveRejectUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String employeeId = request.getParameter("employeeId");
        String action = request.getParameter("action");
        String emailId = request.getParameter("email");
        String employeeName = request.getParameter("employeeName");
        String statusFlag = "R";  // Default to rejection
        EmailUtil email = new EmailUtil();
        String loginLink = "http://localhost:8080/OnlinePenionBenefits2024/login.jsp";
        String emailDecision = "Rejected";
        if ("approve".equalsIgnoreCase(action)) {
            statusFlag = "AP";  // Change to approved
            emailDecision = "Approved";
        }
        String emailMessage = "Hello " + employeeName + ",<br/><br/>" +
                "Your pension update request has been " + emailDecision +
                ". Please <a href='" + loginLink + "'>log in</a> to view the details.";

        try {
            Connection conn = DatabaseConnection.getConnection();
            int rowsUpdated = 0;

            if ("approve".equalsIgnoreCase(action)) {
                String sqlUpdateAmount = "UPDATE pensions p "
                        + "JOIN employee_salaries es ON p.employee_id = es.employee_id "
                        + "SET es.personal_pension = (SELECT update_pension_amount FROM (SELECT update_pension_amount FROM pensions WHERE employee_id = p.employee_id) AS sub), p.update_pension_amount = 0, p.update_flag = ? "
                        + "WHERE p.employee_id = ?";
                PreparedStatement pstUpdateAmount = conn.prepareStatement(sqlUpdateAmount);
                pstUpdateAmount.setString(1, statusFlag);
                pstUpdateAmount.setInt(2, Integer.parseInt(employeeId));
                rowsUpdated = pstUpdateAmount.executeUpdate();
                pstUpdateAmount.close();

                // Update the pension_operations table to set status as Approved
                String updateOperationSql = "UPDATE pension_operations SET status = 'Approved' WHERE employee_id = ? AND operation_type = 'Update' AND status NOT IN ('Approved', 'Rejected')";
                PreparedStatement pstUpdateOperation = conn.prepareStatement(updateOperationSql);
                pstUpdateOperation.setInt(1, Integer.parseInt(employeeId));
                pstUpdateOperation.executeUpdate();
                pstUpdateOperation.close();
            } else {
                String sqlUpdateAmount = "UPDATE pensions p SET update_flag = ? WHERE p.employee_id = ?";
                PreparedStatement pstUpdateAmount = conn.prepareStatement(sqlUpdateAmount);
                pstUpdateAmount.setString(1, statusFlag);
                pstUpdateAmount.setInt(2, Integer.parseInt(employeeId));
                rowsUpdated = pstUpdateAmount.executeUpdate();
                pstUpdateAmount.close();

                // Update the pension_operations table to set status as Rejected
                String details = request.getParameter("details");
                String updateOperationSql = "UPDATE pension_operations SET status = 'Rejected', details = ? WHERE employee_id = ? AND operation_type = 'Update' AND status NOT IN ('Approved', 'Rejected')";
                PreparedStatement pstUpdateOperation = conn.prepareStatement(updateOperationSql);
                pstUpdateOperation.setString(1, details);
                pstUpdateOperation.setInt(2, Integer.parseInt(employeeId));
                pstUpdateOperation.executeUpdate();
                pstUpdateOperation.close();
            }

            conn.close();

            if (rowsUpdated > 0) {
            	email.sendEmailNotification(emailId, "Pension Update Request Decision", emailMessage);
                response.sendRedirect("pensionRequests.jsp?updateSuccess");
            } else {
                response.sendRedirect("pensionRequests.jsp?updateFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pensionRequests.jsp?updateFailed");
        }
    }
}
