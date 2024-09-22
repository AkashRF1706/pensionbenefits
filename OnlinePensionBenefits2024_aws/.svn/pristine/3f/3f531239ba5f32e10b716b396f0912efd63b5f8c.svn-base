package actions;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import database.DatabaseConnection;

@WebServlet("/resetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("new_password");
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        try {
            
            Connection conn = DatabaseConnection.getConnection();

            String sql = "SELECT user_id, expiration FROM password_reset_tokens WHERE token = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Timestamp expiration = rs.getTimestamp("expiration");
                if (expiration.after(new Timestamp(System.currentTimeMillis()))) {
                    int userId = rs.getInt("user_id");

                    sql = "UPDATE users SET password = ? WHERE user_id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, hashedNewPassword);  // You should hash the password here
                    stmt.setInt(2, userId);
                    stmt.executeUpdate();

                    sql = "DELETE FROM password_reset_tokens WHERE token = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, token);
                    stmt.executeUpdate();

                    response.sendRedirect("login.jsp?passwordResetSuccess");
                } else {
                	System.out.println("Token expired: " + token);
                    response.sendRedirect("forgotPassword.jsp?errorexpired");
                }
            } else {
            	System.out.println("Token not available in database: "+token);
                response.sendRedirect("forgotPassword.jsp?errorinvalid");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("resetPassword.jsp?token=" + token + "&error=1");
        }
    }
}
