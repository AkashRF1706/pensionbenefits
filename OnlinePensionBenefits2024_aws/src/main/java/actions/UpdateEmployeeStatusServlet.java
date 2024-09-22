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

@WebServlet("/UpdateEmployeeStatusServlet")
public class UpdateEmployeeStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String niNumber = request.getParameter("niNumber");
        String newStatus = request.getParameter("newStatus");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();

            String updateStatusSQL = "UPDATE employees SET employee_status = ? WHERE ni_number = ?";
            ps = conn.prepareStatement(updateStatusSQL);
            ps.setString(1, newStatus);
            ps.setString(2, niNumber);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("employeeList.jsp?statusUpdateSuccess");
            } else {
                response.sendRedirect("employeeList.jsp?statusUpdateFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employeeList.jsp?statusUpdateFailed");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
