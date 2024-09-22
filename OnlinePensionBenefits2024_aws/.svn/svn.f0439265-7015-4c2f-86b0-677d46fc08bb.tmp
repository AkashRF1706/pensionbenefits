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

@WebServlet("/ApproveRejectTransferServlet")
public class ApproveRejectTransferServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String transferId = request.getParameter("transferId");
		String action = request.getParameter("action");
		String companyType = request.getParameter("companyType");
		String reason = request.getParameter("reason");
		String salary = request.getParameter("salary");
		String personalPension = request.getParameter("personalPension");
		String workplacePension = request.getParameter("workplacePension");

		String newStatus = "";
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = DatabaseConnection.getConnection();

			if ("approve".equalsIgnoreCase(action)) {
				if ("current".equalsIgnoreCase(companyType)) {
					// Current company approves, move to destination company's approval
					newStatus = "Destination Company";

					// Update employee_transfers table
					String updateTransferSQL = "UPDATE employee_transfers SET status = ? WHERE id = ?";
					ps = conn.prepareStatement(updateTransferSQL);
					ps.setString(1, newStatus);
					ps.setString(2, transferId);
					int result = ps.executeUpdate();
					ps.close();

					if (result > 0) {
						response.sendRedirect("companyTransfers.jsp?success");
					} else {
						response.sendRedirect("companyTransfers.jsp?failed");
					}
					return;

				} else if ("destination".equalsIgnoreCase(companyType)) {
					// Destination company approves, finalize the transfer
					newStatus = "Approved";

					// Insert into employee_history before updating employees and employee_salaries
					String insertHistorySQL = "INSERT INTO employee_history (employee_id, name, personal_pension, workplace_pension, salary, company, change_date) "
							+ "SELECT e.id, CONCAT(e.first_name, ' ', e.last_name), es.personal_pension, es.workplace_pension, es.salary, e.company, NOW() "
							+ "FROM employees e " + "JOIN employee_salaries es ON e.id = es.employee_id "
							+ "WHERE e.id = (SELECT et.employee_id FROM employee_transfers et WHERE et.id = ?)";
					ps = conn.prepareStatement(insertHistorySQL);
					ps.setString(1, transferId);
					int insertHistoryResult = ps.executeUpdate();
					ps.close();

					if (insertHistoryResult <= 0) {
						response.sendRedirect("companyTransfers.jsp?error");
						return;
					}

					// Update employee_transfers table
					String updateTransferSQL = "UPDATE employee_transfers SET status = ?, transfer_date = NOW() WHERE id = ?";
					ps = conn.prepareStatement(updateTransferSQL);
					ps.setString(1, newStatus);
					ps.setString(2, transferId);
					int updateTransferResult = ps.executeUpdate();
					ps.close();

					// Update employees table (set company_name and employee_status)
					String updateEmployeeSQL = "UPDATE employees e SET e.company = (SELECT c.company_name FROM companies c WHERE c.id = (SELECT et.to_company_id FROM employee_transfers et WHERE et.id = ?)), e.employee_status = 'Active' WHERE e.id = (SELECT et.employee_id FROM employee_transfers et WHERE et.id = ?)";
					ps = conn.prepareStatement(updateEmployeeSQL);
					ps.setString(1, transferId);
					ps.setString(2, transferId);
					int updateEmployeeResult = ps.executeUpdate();
					ps.close();

					// Update employee_salaries table
					String updateSalarySQL = "UPDATE employee_salaries SET salary = ?, personal_pension = ?, workplace_pension = ? WHERE employee_id = (SELECT employee_id FROM employee_transfers WHERE id = ?)";
					ps = conn.prepareStatement(updateSalarySQL);
					ps.setString(1, salary);
					ps.setString(2, personalPension);
					ps.setString(3, workplacePension);
					ps.setString(4, transferId);
					int updateSalaryResult = ps.executeUpdate();
					ps.close();

					// Check if all updates are successful
					if (updateTransferResult > 0 && updateEmployeeResult > 0 && updateSalaryResult > 0) {
						response.sendRedirect("companyTransfers.jsp?success");
					} else {
						response.sendRedirect("companyTransfers.jsp?failed");
					}
					return;
				}
			} else if ("reject".equalsIgnoreCase(action)) {
				// Rejection case for both current and destination company
				if ("current".equalsIgnoreCase(companyType)) {
					newStatus = "Rejected by Current Company";

				} else if ("destination".equalsIgnoreCase(companyType)) {
					newStatus = "Rejected by Destination Company";
				}

				// Update employee_transfers table with rejection status and reason
				String updateTransferSQL = "UPDATE employee_transfers SET status = ?, notes = ? WHERE id = ?";
				ps = conn.prepareStatement(updateTransferSQL);
				ps.setString(1, newStatus);
				ps.setString(2, reason);
				ps.setString(3, transferId);
				int updateTransferResult = ps.executeUpdate();
				ps.close();

				// Update employees table to set employee status to Active
				String updateEmployeeSQL = "UPDATE employees SET employee_status = 'Active' WHERE id = (SELECT employee_id FROM employee_transfers WHERE id = ?)";
				ps = conn.prepareStatement(updateEmployeeSQL);
				ps.setString(1, transferId);
				int updateEmployeeResult = ps.executeUpdate();
				ps.close();

				// Check if all updates are successful
				if (updateTransferResult > 0 && updateEmployeeResult > 0) {
					response.sendRedirect("companyTransfers.jsp?success");
				} else {
					response.sendRedirect("companyTransfers.jsp?failed");
				}
				return;
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("companyTransfers.jsp?error");
		} finally {
			if (ps != null)
				try {
					ps.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
	}
}
