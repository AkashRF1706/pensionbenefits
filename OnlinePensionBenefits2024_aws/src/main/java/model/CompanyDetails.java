package model;

public class CompanyDetails {
    private int companyId;
    private int userId;
    private String companyName;
    private String email;

    public CompanyDetails(int companyId, int userId, String companyName, String email) {
        this.companyId = companyId;
        this.userId = userId;
        this.companyName = companyName;
        this.email = email;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
}
