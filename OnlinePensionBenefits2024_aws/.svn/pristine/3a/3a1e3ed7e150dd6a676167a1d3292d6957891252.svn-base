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

@WebServlet("/UpdatePensionServlet")
public class UpdatePensionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	int employeeId = Integer.parseInt(request.getParameter("empId"));

        String personalContributionStr = request.getParameter("personalContribution");
        double personalContribution = 0.0;

        if (personalContributionStr != null && !personalContributionStr.isEmpty()) {
            personalContribution = Double.parseDouble(personalContributionStr);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            conn = DatabaseConnection.getConnection();
            
            String sqlSelect = "Select employee_status from employees where id = ? and employee_status != 'Active'";
            PreparedStatement psql = conn.prepareStatement(sqlSelect);
            psql.setInt(1, employeeId);
            ResultSet rsSql = psql.executeQuery();
            if(rsSql.next()) {
            	String status = rsSql.getString("employee_status");
            	if(status.equalsIgnoreCase("Inactive")) {
            		response.sendRedirect("managePension.jsp?Inactive");
            		return;
            	} else if (status.equalsIgnoreCase("Pending")) {
            		response.sendRedirect("managePension.jsp?TransferRequest");
            		return;
            	}
            }

            String selectQuery = "SELECT update_flag FROM pensions WHERE update_flag = 'C' AND employee_id = ?";
            PreparedStatement ptst = conn.prepareStatement(selectQuery);
            ptst.setInt(1, employeeId);
            ResultSet rs = ptst.executeQuery();
            if(rs.next()) {
            	response.sendRedirect("managePension.jsp?RequestPending");
            	return;
            }
            
            // Prepare SQL query to update personal pension based on employee email
            String sql = "UPDATE pensions SET update_pension_amount = ?, update_flag = ? WHERE employee_id = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setDouble(1, personalContribution);
            pstmt.setString(2, "C");
            pstmt.setInt(3, employeeId);

            // Execute the update
            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Insert the operation into pension_operations table
                String insertOperation = "INSERT INTO pension_operations (employee_id, operation_type, amount, status) "
                                       + "VALUES (?, 'Update', ?, 'Company Pending')";
                PreparedStatement pstInsertOperation = conn.prepareStatement(insertOperation);
                pstInsertOperation.setInt(1, employeeId);
                pstInsertOperation.setDouble(2, personalContribution);
                pstInsertOperation.executeUpdate();
                pstInsertOperation.close();

                // Update successful, redirect to a success page 
                response.sendRedirect("myRequests.jsp?success");
            } else {
                // Update failed, display error message
                response.sendRedirect("myRequests.jsp?failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Handle the exception and possibly log it
            response.sendRedirect("myRequests.jsp?failed");
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle GET requests if necessary, otherwise forward to POST
        doPost(request, response);
    }
}
