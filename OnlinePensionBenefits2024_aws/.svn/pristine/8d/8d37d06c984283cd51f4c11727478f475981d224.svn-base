package servlet;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResendOtpServlet")
public class ResendOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = session.getAttribute("email").toString();
        String redirectPage = request.getParameter("redirect");


        // Generate a new OTP
        int otp = new Random().nextInt(900000) + 100000; // Generates a 6-digit OTP

        // Update the OTP in the session
        session.setAttribute("otp", otp);

        // Send OTP via email (simplified example)
        try {
            EmailUtil.sendOtpEmail(email, String.valueOf(otp));
            response.sendRedirect("verifyOtp.jsp?otpSent=1&redirect=" + redirectPage);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("verifyOtp.jsp?error=Unable to resend OTP");
        }
    }
}
