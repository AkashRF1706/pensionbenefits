package servlet;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {
    public static void sendOtpEmail(String toEmail, String otp) {
        final String fromEmail = "imranmohamed20132@gmail.com";
        final String password = "bveu fkjs grxt qjnf";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Your OTP Code");
            message.setText("Your OTP code is: " + otp);

            Transport.send(message);

            System.out.println("OTP email sent successfully.");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // Generate a 6-digit OTP
        return String.valueOf(otp);
    }
    
    public void sendEmailNotification (String toEmail, String subject, String message) {
    	final String fromEmail = "imranmohamed20132@gmail.com";
        final String password = "bveu fkjs grxt qjnf";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
        try {
            Message notificationMessage = new MimeMessage(session);
            notificationMessage.setFrom(new InternetAddress(fromEmail));
            notificationMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            notificationMessage.setSubject(subject);
            notificationMessage.setContent(message, "text/html; charset=utf-8");

            Transport.send(notificationMessage);

            System.out.println("OTP email sent successfully.");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
