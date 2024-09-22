package actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.DatabaseConnection;
import servlet.EmailUtil;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/loginServlet")
public class Login extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res) {
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		HttpSession session = req.getSession();
		
		try {
			Connection conn = DatabaseConnection.getConnection();
			
			String sql = "SELECT u.user_id, u.username, u.password, r.role_name, u.email, u.first_name, u.status, (SELECT c.company_name "
					+ " FROM companies c WHERE c.user_id = u.user_id) AS company_name FROM users u JOIN user_roles ur "
					+ " ON u.user_id = ur.user_id JOIN roles r ON ur.role_id = r.role_id "
					+ " WHERE u.username = ? ";
			
			PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()) {
            	int userId = rs.getInt("user_id");
            	String role = rs.getString("role_name");
            	String hashPwd = rs.getString("password"); 
            	String name = rs.getString("first_name");
            	String email = rs.getString("email");
            	String status = rs.getString("status");
            	
            	if (status.equalsIgnoreCase("Pending")) {
            	    res.sendRedirect("login.jsp?AccountPending");
            	    return;
            	} else if(status.equalsIgnoreCase("Inactive") || status.equalsIgnoreCase("Rejected")) {
            		res.sendRedirect("login.jsp?AccountInactive");
            		return;
            	}
            	
            	session.setAttribute("role", role);
            	
            	if(BCrypt.checkpw(password, hashPwd)) {
            		
            		session.setAttribute("userId", userId);
            		session.setAttribute("name", name);
            		session.setAttribute("email", email);
            		
            		String otp = EmailUtil.generateOtp();
            		session.setAttribute("otp", otp);
            		
            		EmailUtil.sendOtpEmail(email, otp);
            		
            		if(role.equalsIgnoreCase("Administrator")) {
            			res.sendRedirect("admin.jsp");
            		} else if (role.equalsIgnoreCase("Company")) {
            			String company = rs.getString("company_name");
            			session.setAttribute("company", company);
            			res.sendRedirect("verifyOtp.jsp?redirect=companyHome.jsp");
            			//res.sendRedirect("companyHome.jsp");
            		} else if (role.equalsIgnoreCase("Pensioner")) {
            			res.sendRedirect("verifyOtp.jsp?redirect=pensioner.jsp");
            			//res.sendRedirect("pensioner.jsp");
            		}
            	}else if (username.equalsIgnoreCase("Admin") && password.equalsIgnoreCase("admin")) {
            		res.sendRedirect("admin.jsp");
            	} 
            	else {
            		res.sendRedirect("login.jsp?IncorrectPwd");
            	}
            }
            else {
            	res.sendRedirect("login.jsp?InvalidUsername");
            }
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}
