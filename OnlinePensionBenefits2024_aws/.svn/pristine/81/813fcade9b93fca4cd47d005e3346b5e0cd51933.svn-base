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

@WebServlet("/addBenefitServlet")
public class AddBenefitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String benefitName = request.getParameter("benefit_name");
        String description = request.getParameter("description");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO benefits (benefit_name, description, created_at) VALUES (?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, benefitName);
            pstmt.setString(2, description);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("manageBenefits.jsp?addSuccess");
            } else {
                response.sendRedirect("addBenefit.jsp?error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addBenefit.jsp?error");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
