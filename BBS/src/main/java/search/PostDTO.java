package search;

public class PostDTO {
    private int bbsID;
    private String userID;
	private String bbsTitle;
    private String bbsDate;
    private int bbsCount;
    private int likeCount;
    private String bbsTable;

    // Getters and Setters
    public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
    public int getBbsID() { return bbsID; }
    public void setBbsID(int bbsID) { this.bbsID = bbsID; }

    public String getBbsTitle() { return bbsTitle; }
    public void setBbsTitle(String bbsTitle) { this.bbsTitle = bbsTitle; }

    public String getBbsDate() { return bbsDate; }
    public void setBbsDate(String bbsDate) { this.bbsDate = bbsDate; }

    public int getBbsCount() { return bbsCount; }
    public void setBbsCount(int bbsCount) { this.bbsCount = bbsCount; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public String getBbsTable() { return bbsTable; }
    public void setBbsTable(String bbsTable) { this.bbsTable = bbsTable; }
}
