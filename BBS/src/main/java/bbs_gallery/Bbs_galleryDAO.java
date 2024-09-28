package bbs_gallery;

import java.sql.*;
import java.util.ArrayList;

public class Bbs_galleryDAO {
    private Connection conn;  // DB 연결 객체
    private ResultSet rs;     // 결과셋 객체

    // 생성자: DB 연결 설정
    public Bbs_galleryDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/BBS?useSSL=false"; // DB URL
            String dbID = "root";    // DB ID
            String dbPassword = "root"; // DB Password
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 현재 시간을 가져오는 메서드
    public String getDate() {
        String SQL = "SELECT NOW()"; // MySQL의 NOW() 함수 사용
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);  // 현재 시간 반환
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // DB 오류
    }

    // 다음 게시글 번호 가져오기
    public int getNext() {
        String SQL = "SELECT bbsID FROM BBS_GALLERY ORDER BY bbsID DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;  // 가장 최근 게시글 번호 + 1
            }
            return 1; // 첫 번째 게시물인 경우
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // DB 오류
    }

    public int write(String bbsTitle, String userID, String bbsContent, String bbsImage) {
        String SQL = "INSERT INTO BBS_GALLERY (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable, bbsImage) VALUES (?, ?, ?, ?, ?, 1, ?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext());       // 다음 게시글 ID
            pstmt.setString(2, bbsTitle);     // 게시글 제목
            pstmt.setString(3, userID);       // 작성자 ID
            pstmt.setString(4, getDate());    // 작성 날짜
            pstmt.setString(5, bbsContent);   // 게시글 내용
            pstmt.setString(6, bbsImage);     // 이미지 경로
            return pstmt.executeUpdate();     // SQL 실행
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // DB 오류
    }



    public ArrayList<Bbs_gallery> getList(int pageNumber) {
        String SQL = "SELECT * FROM BBS_GALLERY WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
        ArrayList<Bbs_gallery> list = new ArrayList<Bbs_gallery>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // 페이징 처리
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Bbs_gallery bbs = new Bbs_gallery();
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsTitle(rs.getString(2));
                bbs.setUserID(rs.getString(3));
                bbs.setBbsDate(rs.getString(4));
                bbs.setBbsContent(rs.getString(5));
                bbs.setBbsAvailable(rs.getInt(6));
                list.add(bbs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; // DB 오류
    }


    public boolean nextPage(int pageNumber) {
        String SQL = "SELECT * FROM BBS_GALLERY WHERE bbsID < ? AND bbsAvailable = 1";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return true; // 다음 페이지가 있음
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // DB 오류 또는 다음 페이지 없음
    }


    public Bbs_gallery getBbs(int bbsID) {
        String SQL = "SELECT * FROM BBS_GALLERY WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, bbsID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Bbs_gallery bbs = new Bbs_gallery();
                bbs.setBbsID(rs.getInt(1));            // bbsID
                bbs.setBbsTitle(rs.getString(2));      // bbsTitle
                bbs.setUserID(rs.getString(3));        // userID
                bbs.setBbsDate(rs.getString(4));       // bbsDate
                bbs.setBbsContent(rs.getString(5));    // bbsContent
                bbs.setBbsAvailable(rs.getInt(6));     // bbsAvailable
                bbs.setBbsImage(rs.getString(7));      // bbsImage - 추가
                return bbs;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // DB 오류 또는 게시글 없음
    }



    public int update(int bbsID, String bbsTitle, String bbsContent) {
        String SQL = "UPDATE BBS_GALLERY SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, bbsTitle);
            pstmt.setString(2, bbsContent);
            pstmt.setInt(3, bbsID);
            return pstmt.executeUpdate(); // SQL 실행
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // DB 오류
    }


    public int delete(int bbsID) {
        String SQL = "UPDATE BBS_GALLERY SET bbsAvailable = 0 WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, bbsID);
            return pstmt.executeUpdate(); // SQL 실행
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // DB 오류
    }
    
    public int getTotalCount() {
	    String SQL = "SELECT COUNT(*) FROM BBS_GALLERY";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);  // 총 게시글 수 반환
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;  // 오류 발생 시
	}
}
