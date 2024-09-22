package model;

import java.sql.Date;

public class UserDetails {
    private int userId;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private String role;
    private String companyName;
    private Date dateOfBirth;

    // Constructor for Company users
    public UserDetails(int userId, String username, String email, String role, String companyName) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.role = role;
        this.companyName = companyName;
    }

    // Constructor for Pensioner users
    public UserDetails(int userId, String username, String email, String firstName, String lastName, String role, Date dateOfBirth) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.dateOfBirth = dateOfBirth;
    }

    // Common getters and setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Company-specific getter and setter
    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    // Pensioner-specific getter and setter
    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
}
