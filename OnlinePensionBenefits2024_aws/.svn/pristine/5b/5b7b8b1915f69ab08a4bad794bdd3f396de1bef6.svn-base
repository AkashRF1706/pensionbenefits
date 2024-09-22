package servlet;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import database.DatabaseConnection;

@WebServlet("/PensionersHomePageServlet")
public class PensionersHomePageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class PensionDetails {
        private int employeeId;
        private double monthlyPension;
        private double pensionAmount;
        private double totalPensionAfter68;
        private double usedPension;
        
		public PensionDetails(int employeeId, double monthlyPension, double pensionAmount, double totalPensionAfter68,
				double usedPension) {
			super();
			this.employeeId = employeeId;
			this.monthlyPension = monthlyPension;
			this.pensionAmount = pensionAmount;
			this.totalPensionAfter68 = totalPensionAfter68;
			this.usedPension = usedPension;
		}
		public int getEmployeeId() {
			return employeeId;
		}
		public void setEmployeeId(int employeeId) {
			this.employeeId = employeeId;
		}
		public double getMonthlyPension() {
			return monthlyPension;
		}
		public void setMonthlyPension(double monthlyPension) {
			this.monthlyPension = monthlyPension;
		}
		public double getPensionAmount() {
			return pensionAmount;
		}
		public void setPensionAmount(double pensionAmount) {
			this.pensionAmount = pensionAmount;
		}
		public double getTotalPensionAfter68() {
			return totalPensionAfter68;
		}
		public void setTotalPensionAfter68(double totalPensionAfter68) {
			this.totalPensionAfter68 = totalPensionAfter68;
		}
		public double getUsedPension() {
			return usedPension;
		}
		public void setUsedPension(double usedPension) {
			this.usedPension = usedPension;
		}
        
        
    }

    public List<PensionDetails> getPensionDetails(String email, int userId) throws IOException {
        
        List<PensionDetails> pensionDetailsList = new ArrayList<>();
        
        try (Connection connection = DatabaseConnection.getConnection()) {
            String query = "SELECT u.date_of_birth, e.id AS employee_id, " +
                           "(es.personal_pension + es.workplace_pension) AS monthly_pension, " +
                           "p.pension_amount, p.used_pension " +
                           "FROM users u " +
                           "JOIN employees e ON u.email = e.email " +
                           "JOIN employee_salaries es ON e.id = es.employee_id " +
                           "JOIN pensions p ON e.id = p.employee_id " +
                           "WHERE u.email = ? and u.user_id = ?";
            
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, email);
                statement.setInt(2, userId);
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {LocalDate dateOfBirth = resultSet.getDate("date_of_birth").toLocalDate();
                    int employeeId = resultSet.getInt("employee_id");
                    double monthlyPension = resultSet.getDouble("monthly_pension");
                    double pensionAmount = resultSet.getDouble("pension_amount");
                    double usedPension = resultSet.getDouble("used_pension");

                    LocalDate dateAt68 = dateOfBirth.plusYears(68);
                    Period periodUntil68 = Period.between(LocalDate.now(), dateAt68);
                    int monthsUntil68 = periodUntil68.getYears() * 12 + periodUntil68.getMonths();

                    System.out.println(LocalDate.now());
                    System.out.println(dateAt68);
                    System.out.println(monthsUntil68);

                    double totalPensionAfter68 = pensionAmount + (monthsUntil68 * monthlyPension);

                    PensionDetails details = new PensionDetails(employeeId, monthlyPension, pensionAmount, totalPensionAfter68, usedPension);

                    pensionDetailsList.add(details);
}
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
		return pensionDetailsList;
    }
}
