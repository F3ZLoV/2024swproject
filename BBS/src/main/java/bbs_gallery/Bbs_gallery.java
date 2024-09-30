package bbs_gallery;

public class Bbs_gallery {

    private int bbsID;        // 게시글 ID
    private String bbsTitle;  // 게시글 제목
    private String userID;    // 작성자 ID
    private String bbsDate;   // 작성 날짜
    private String bbsContent; // 게시글 내용
    private int bbsAvailable; // 게시글 사용 가능 여부 (1: 활성, 0: 삭제)
    private String bbsImage;
    private int rankNumber;
	
	public int getRankNumber() {
		return rankNumber;
	}
	public void setRankNumber(int rankNumber) {
		this.rankNumber = rankNumber;
	}
    
    public String getBbsImage() {
		return bbsImage;
	}

	public void setBbsImage(String bbsImage) {
		this.bbsImage = bbsImage;
	}

	// 기본 생성자
    public Bbs_gallery() {}

    // getter와 setter 메서드
    public int getBbsID() {
        return bbsID;
    }

    public void setBbsID(int bbsID) {
        this.bbsID = bbsID;
    }

    public String getBbsTitle() {
        return bbsTitle;
    }

    public void setBbsTitle(String bbsTitle) {
        this.bbsTitle = bbsTitle;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getBbsDate() {
        return bbsDate;
    }

    public void setBbsDate(String bbsDate) {
        this.bbsDate = bbsDate;
    }

    public String getBbsContent() {
        return bbsContent;
    }

    public void setBbsContent(String bbsContent) {
        this.bbsContent = bbsContent;
    }

    public int getBbsAvailable() {
        return bbsAvailable;
    }

    public void setBbsAvailable(int bbsAvailable) {
        this.bbsAvailable = bbsAvailable;
    }
}