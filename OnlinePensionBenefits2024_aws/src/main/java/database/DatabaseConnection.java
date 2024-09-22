package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

	private static final String DBURL = "jdbc:mysql://pension-database.cf4saooaqwam.eu-west-1.rds.amazonaws.com:3306/pensionbenefits";
    private static final String DBUSERNAME = "admin";
    private static final String DBPASSWORD = "pensionbenefits";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DBURL, DBUSERNAME, DBPASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new SQLException("Error connecting to the database: " + e.getMessage());
        }	
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
