package listener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import database.DatabaseConnection;

@WebListener
public class PensionUpdateListener implements ServletContextListener {

    private Timer timer;
    private static final Logger LOGGER = Logger.getLogger(PensionUpdateListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Schedule the task to run every minute for testing purposes
        LOGGER.info("Initializing PensionUpdateListener and scheduling tasks.");
        timer = new Timer(true);
        timer.scheduleAtFixedRate(new PensionUpdateTask(), getNextFirstOfMonthAt10AM(), 30L * 24L * 60L * 60L * 1000L); // Run every month
        //timer.scheduleAtFixedRate(new PensionUpdateTask(), 0, 60L * 1000L); // Run every minute for testing
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cancel the timer when the context is destroyed
        if (timer != null) {
            LOGGER.info("Destroying PensionUpdateListener and cancelling tasks.");
            timer.cancel();
        }
    }
    
    private static java.util.Date getNextFirstOfMonthAt10AM() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 10);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        if (calendar.getTime().before(new java.util.Date())) {
            calendar.add(Calendar.MONTH, 1);
        }
        return calendar.getTime();
    }

    class PensionUpdateTask extends TimerTask {
        @Override
        public void run() {
            LOGGER.info("Running PensionUpdateTask.");
            updatePensions();
        }

        private void updatePensions() {
            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                connection = DatabaseConnection.getConnection();

                // Fetch all employee salaries
                Map<Integer, Double> employeeSalaries = new HashMap<>();
                Statement stmt = connection.createStatement();
                LOGGER.info("Fetching employee salaries.");
                rs = stmt.executeQuery("SELECT es.employee_id, es.personal_pension, es.workplace_pension FROM employee_salaries es JOIN employees e on e.id = es.employee_id where e.employee_status = 'Active'");
                while (rs.next()) {
                    int employeeId = rs.getInt("employee_id");
                    double pensionAmount = rs.getDouble("personal_pension") + rs.getDouble("workplace_pension");
                    employeeSalaries.put(employeeId, pensionAmount);
                }
                rs.close();
                stmt.close();
                LOGGER.info("Fetched employee salaries: " + employeeSalaries.size() + " records.");

                // Fetch all existing pensions
                Map<Integer, Double> existingPensions = new HashMap<>();
                Set<String> pensionIds = new HashSet<>();
                stmt = connection.createStatement();
                LOGGER.info("Fetching existing pensions.");
                rs = stmt.executeQuery("SELECT pension_id, employee_id, pension_amount FROM pensions");
                while (rs.next()) {
                    String pensionId = rs.getString("pension_id");
                    int employeeId = rs.getInt("employee_id");
                    double pensionAmount = rs.getDouble("pension_amount");
                    existingPensions.put(employeeId, pensionAmount);
                    pensionIds.add(pensionId);
                }
                rs.close();
                stmt.close();
                LOGGER.info("Fetched existing pensions: " + existingPensions.size() + " records.");

                // Process and update pensions
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                for (Map.Entry<Integer, Double> entry : employeeSalaries.entrySet()) {
                    int employeeId = entry.getKey();
                    double pensionAmount = entry.getValue();

                    if (existingPensions.containsKey(employeeId)) {
                        // Update existing pension
                        double newPensionAmount = existingPensions.get(employeeId) + pensionAmount;
                        pstmt = connection.prepareStatement("UPDATE pensions SET pension_amount = ?, last_updated_date = ? WHERE employee_id = ?");
                        pstmt.setDouble(1, newPensionAmount);
                        pstmt.setTimestamp(2, currentTime);
                        pstmt.setInt(3, employeeId);
                        pstmt.executeUpdate();
                        LOGGER.info("Updated pension for employee_id: " + employeeId);
                    } else {
                        // Insert new pension
                        String newPensionId = generateUniquePensionId(pensionIds);
                        pstmt = connection.prepareStatement("INSERT INTO pensions (pension_id, employee_id, pension_amount, last_updated_date) VALUES (?, ?, ?, ?)");
                        pstmt.setString(1, newPensionId);
                        pstmt.setInt(2, employeeId);
                        pstmt.setDouble(3, pensionAmount);
                        pstmt.setTimestamp(4, currentTime);
                        pstmt.executeUpdate();
                        pensionIds.add(newPensionId);
                        LOGGER.info("Inserted new pension for employee_id: " + employeeId);
                    }
                }

            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "SQL Exception occurred while updating pensions", e);
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "SQL Exception occurred while closing resources", e);
                }
            }
        }

        private String generateUniquePensionId(Set<String> existingPensionIds) {
            String newPensionId;
            do {
                newPensionId = UUID.randomUUID().toString();
            } while (existingPensionIds.contains(newPensionId));
            return newPensionId;
        }
    }
}
