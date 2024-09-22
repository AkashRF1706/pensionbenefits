package actions;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import database.DatabaseConnection;

@WebServlet("/signupServlet")
public class Signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String hasPwd = BCrypt.hashpw(password, BCrypt.gensalt());
        String email = request.getParameter("email");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String dateOfBirth = request.getParameter("date_of_birth");
        int roleId = Integer.parseInt(request.getParameter("role"));
        String gender = request.getParameter("gender") != null ? String.valueOf(request.getParameter("gender").charAt(0)) : null;
        
        String companyName = request.getParameter("company_name");
        String status = (roleId == 2) ? "Pending" : "Active";

        try {
            
            Connection conn = DatabaseConnection.getConnection();

            String sql = "INSERT INTO users (username, password, email, first_name, last_name, date_of_birth, gender, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, username);
            stmt.setString(2, hasPwd);
            stmt.setString(3, email);
            stmt.setString(4, firstName);
            stmt.setString(5, lastName);
            if(roleId == 3) {
            stmt.setDate(6, Date.valueOf(dateOfBirth));
            } else {
            	stmt.setString(6, null);
            }
            stmt.setString(7, gender);
            stmt.setString(8, status);
            int insertCount = stmt.executeUpdate();
            
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            int roleInsertCount = 0;
            if (generatedKeys.next()) {
                int userId = generatedKeys.getInt(1);

                sql = "INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setInt(2, roleId);
                roleInsertCount = stmt.executeUpdate();
                
                if (roleId == 2) {
                    String companySql = "INSERT INTO companies (user_id, company_name) VALUES (?, ?)";
                    stmt = conn.prepareStatement(companySql);
                    stmt.setInt(1, userId);
                    stmt.setString(2, companyName);
                    stmt.executeUpdate();
                }
            }
            conn.close();
            
            if(insertCount > 0 && roleInsertCount > 0) {
                response.sendRedirect("login.jsp?SignUpComplete");
            } else {
                response.sendRedirect("signup.jsp?SignUpFailed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?SignUpFailed");
        }
    }
}
