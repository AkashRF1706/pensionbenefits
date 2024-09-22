package actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;

import database.EmployeeDAO;
import model.Employee;

@WebServlet("/addMultipleEmployees")
@MultipartConfig
public class AddMultipleEmployeesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
    private static final Pattern NI_NUMBER_PATTERN = Pattern.compile("^[A-Z]{2}[0-9]{6}[A-Z]$");
    private static final Logger LOGGER = Logger.getLogger(AddMultipleEmployeesServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Received request to add multiple employees");

        Part filePart = request.getPart("file");
        String company = request.getParameter("company");
        if (filePart == null) {
            LOGGER.severe("File part is null");
            request.setAttribute("errorMessage", "No file uploaded");
            request.getRequestDispatcher("uploadError.jsp").forward(request, response);
            return;
        }

        LOGGER.info("File part received: " + filePart.getSubmittedFileName());

        List<Employee> employees = new ArrayList<>();
        List<String> invalidEmails = new ArrayList<>();
        List<String> invalidNiNumbers = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream()));
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {

            String[] line;
            int lineNumber = 0;

            while ((line = csvReader.readNext()) != null) {
                lineNumber++;
                LOGGER.info("Processing line " + lineNumber + ": " + String.join(", ", line));

                // Ensuring the line has expected number of columns
                if (line.length != 5) {
                    LOGGER.warning("Line " + lineNumber + " is malformed: " + String.join(", ", line));
                    continue;
                }

                String firstName = line[0];
                String lastName = line[1];
                String email = line[2];
                String niNumber = line[3].toUpperCase();
                double annualSalary = Double.parseDouble(line[4]);

                if (!EMAIL_PATTERN.matcher(email).matches()) {
                    invalidEmails.add(email);
                    continue;
                }
                if(!NI_NUMBER_PATTERN.matcher(niNumber).matches()) {
                	invalidNiNumbers.add(niNumber);
                	continue;
                }

                double monthlySalary = annualSalary / 12;
                double personalPension = Math.round(monthlySalary * 0.05 * 100.0) / 100.0;
                double workplacePension = Math.round(monthlySalary * 0.05 * 100.0) / 100.0;

                Employee employee = new Employee(firstName, lastName, email, company, niNumber, annualSalary, personalPension, workplacePension, "Active");
                employees.add(employee);
            }

            if (lineNumber == 0) {
                LOGGER.severe("The CSV file is empty or not correctly formatted.");
                request.setAttribute("errorMessage", "The CSV file is empty or not correctly formatted.");
                request.getRequestDispatcher("uploadError.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error reading CSV file", e);
            request.setAttribute("errorMessage", "Error reading CSV file: " + e.getMessage());
            request.getRequestDispatcher("uploadError.jsp").forward(request, response);
            return;
        }

        if (!invalidEmails.isEmpty()) {
            request.setAttribute("invalidEmails", invalidEmails);
            request.getRequestDispatcher("uploadError.jsp").forward(request, response);
            return;
        } 
        if (!invalidNiNumbers.isEmpty()) {
        	request.setAttribute("invalidNiNumbers", invalidNiNumbers);
        	request.getRequestDispatcher("uploadError.jsp").forward(request, response);
        	return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        List<Employee> failedEmployees = new ArrayList<Employee>();
        try {
            List<String> existingEmails = employeeDAO.fetchAllEmails();
            List<String> existingNINumbers = employeeDAO.fetchAllNINumbers();
            failedEmployees = employeeDAO.saveEmployees(employees, existingEmails, existingNINumbers);
            if (failedEmployees != null && !failedEmployees.isEmpty()) {
                // Store the failed employees list in the session or request
                request.getSession().setAttribute("failedEmployees", failedEmployees);
                response.sendRedirect("employeeList.jsp?employeesAdded&failed=true");
                return;
            } else {
                response.sendRedirect("employeeList.jsp?employeesAdded");
                return;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving employees", e);
            throw new ServletException("Error saving employees", e);
        }
    }
}
