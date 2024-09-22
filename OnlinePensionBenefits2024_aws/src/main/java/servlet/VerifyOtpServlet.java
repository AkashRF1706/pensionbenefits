package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

	protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int enteredOtp = Integer.parseInt(request.getParameter("otp"));
        HttpSession session = request.getSession();
        int sessionOtp = Integer.parseInt(session.getAttribute("otp").toString());
        String redirectUrl = request.getParameter("redirectUrl");
        System.out.println(redirectUrl);

        if (enteredOtp == sessionOtp) {
            // OTP is correct, proceed with login
            session.removeAttribute("otp");
            session.setAttribute("email", session.getAttribute("email"));
            response.sendRedirect(redirectUrl);
        } else {
            // OTP is incorrect
            response.sendRedirect("verifyOtp.jsp?error=Invalid OTP");
        }
    }
}
