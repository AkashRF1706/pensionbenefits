package model;

public class Employee {
	private int id;
	private String firstName;
	private String lastName;
	private String email;
	private String company;
	private String niNumber;
	private double annualSalary;
	private double personalPension;
	private double workplacePension;
	private String employeeStatus;

	public String getEmployeeStatus() {
		return employeeStatus;
	}

	public void setEmployeeStatus(String employeeStatus) {
		this.employeeStatus = employeeStatus;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getNiNumber() {
		return niNumber;
	}

	public void setNiNumber(String niNumber) {
		this.niNumber = niNumber;
	}

	public double getAnnualSalary() {
		return annualSalary;
	}

	public void setAnnualSalary(double annualSalary) {
		this.annualSalary = annualSalary;
	}

	public double getPersonalPension() {
		return personalPension;
	}

	public void setPersonalPension(double personalPension) {
		this.personalPension = personalPension;
	}

	public double getWorkplacePension() {
		return workplacePension;
	}

	public void setWorkplacePension(double workplacePension) {
		this.workplacePension = workplacePension;
	}

	public Employee(String firstName, String lastName, String email, String company, String niNumber,
			double annualSalary, double personalPension, double workplacePension, String employeeStatus) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.company = company;
		this.niNumber = niNumber;
		this.annualSalary = annualSalary;
		this.personalPension = personalPension;
		this.workplacePension = workplacePension;
		this.employeeStatus = employeeStatus;
	}

}
