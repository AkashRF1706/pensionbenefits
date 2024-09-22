package actions;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.DatabaseConnection;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

@WebServlet("/forgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try {

            Connection conn = DatabaseConnection.getConnection();

            String sql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String token = generateToken();
                Timestamp expiration = Timestamp.from(Instant.now().plusSeconds(3600)); // Token valid for 1 hour

                sql = "INSERT INTO password_reset_tokens (user_id, token, expiration) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, token);
                stmt.setTimestamp(3, expiration);
                stmt.executeUpdate();

                sendResetEmail(email, token);
                response.sendRedirect("login.jsp?resetLinkSent");
            } else {
                response.sendRedirect("forgotPassword.jsp?InvalidEmail");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=1");
        }
    }

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().encodeToString(bytes);
    }

    private void sendResetEmail(String email, String token) throws MessagingException {
        String resetLink = "http://localhost:8080/OnlinePensionBenefits2024/resetPassword.jsp?token=" + token;

        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
        	@Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("imranmohamed20132@gmail.com", "bveu fkjs grxt qjnf");
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress("imranmohamed20132@gmail.com"));
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
        message.setSubject("Password Reset Request - Online Pension Benefits");
        message.setText("To reset your password, click the link below:\n" + resetLink);

        Transport.send(message);
    }
}
