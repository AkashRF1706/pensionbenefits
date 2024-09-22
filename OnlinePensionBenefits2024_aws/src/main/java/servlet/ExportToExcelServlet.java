package servlet;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import database.DatabaseConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

@WebServlet("/ExportToExcelServlet")
public class ExportToExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String role = request.getSession().getAttribute("role").toString();
            String sql;
            PreparedStatement ps;

            if ("Company".equalsIgnoreCase(role)) {
                String company = request.getSession().getAttribute("company").toString();
                sql = "SELECT e.id as employee_id, CONCAT(e.first_name, ' ', e.last_name) as employee_name, po.operation_type, po.status, IFNULL(po.withdraw_reason, 'N/A') as withdraw_reason, IFNULL(po.details, 'N/A') as details, po.created_at, po.updated_at "
                    + "FROM pension_operations po "
                    + "JOIN employees e ON e.id = po.employee_id "
                    + "WHERE e.company = ? "
                    + "ORDER BY po.created_at DESC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, company);
            } else {
                String email = request.getSession().getAttribute("email").toString();
                sql = "SELECT po.operation_type, po.status, IFNULL(po.withdraw_reason, 'N/A') as withdraw_reason, IFNULL(po.details, 'N/A') as details, po.created_at, po.updated_at "
                    + "FROM pension_operations po "
                    + "JOIN employees e ON e.id = po.employee_id "
                    + "WHERE e.email = ? "
                    + "ORDER BY po.created_at DESC";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
            }

            ResultSet rs = ps.executeQuery();

            XSSFWorkbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Pension Operations");

            Row header = sheet.createRow(0);
            int colIndex = 0;

            if ("Company".equalsIgnoreCase(role)) {
                header.createCell(colIndex++).setCellValue("Employee ID");
                header.createCell(colIndex++).setCellValue("Employee Name");
            }
            
            header.createCell(colIndex++).setCellValue("Operation Type");
            header.createCell(colIndex++).setCellValue("Status");
            header.createCell(colIndex++).setCellValue("Reason");
            header.createCell(colIndex++).setCellValue("Details");
            header.createCell(colIndex++).setCellValue("Requested Time");
            header.createCell(colIndex++).setCellValue("Last Updated Time");

            int rowNum = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowNum++);
                colIndex = 0;

                if ("Company".equalsIgnoreCase(role)) {
                    row.createCell(colIndex++).setCellValue(rs.getInt("employee_id"));
                    row.createCell(colIndex++).setCellValue(rs.getString("employee_name"));
                }

                row.createCell(colIndex++).setCellValue(rs.getString("operation_type"));
                row.createCell(colIndex++).setCellValue(rs.getString("status"));
                row.createCell(colIndex++).setCellValue(rs.getString("withdraw_reason") != null && !rs.getString("withdraw_reason").isEmpty() ? rs.getString("withdraw_reason") : "N/A");
                row.createCell(colIndex++).setCellValue(rs.getString("details") != null && !rs.getString("details").isEmpty() ? rs.getString("details") : "N/A");
                row.createCell(colIndex++).setCellValue(rs.getTimestamp("created_at").toString());
                row.createCell(colIndex++).setCellValue(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toString() : "N/A");
            }

            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment;filename=PensionOperations_" + new Date().getTime() + ".xlsx");
            workbook.write(response.getOutputStream());
            workbook.close();

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
