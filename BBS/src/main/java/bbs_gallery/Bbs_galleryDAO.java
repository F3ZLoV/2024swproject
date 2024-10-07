package bbs_gallery;

import java.sql.*;
import java.util.ArrayList;

import bbs.Bbs;

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

    public int write(String bbsTitle, String userID, String bbsContent, String imagePath) {
        String SQL = "INSERT INTO BBS_GALLERY (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable, imagePath)"
        			+ " VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext());
            pstmt.setString(2, bbsTitle);
            pstmt.setString(3, userID);
            pstmt.setString(4, getDate());
            pstmt.setString(5, bbsContent);
            pstmt.setInt(6, 1);
            pstmt.setString(7, imagePath);  // 이미지 경로 저장
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터베이스 오류
    }



    public ArrayList<Bbs_gallery> getList(int pageNumber) {
	    String SQL = "SELECT bbsID, bbsTitle, userID, bbsDate, bbsContent "
	               + "FROM BBS_GALLERY WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT ?, 10";
	    ArrayList<Bbs_gallery> list = new ArrayList<Bbs_gallery>();
	    try {
	        int totalCount = getTotalCount();	// 전체 게시글 수를 가져와서 계산
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, (pageNumber - 1) * 10);  // 페이징 처리
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Bbs_gallery bbs = new Bbs_gallery();
	            bbs.setRankNumber(totalCount--);
	            bbs.setBbsID(rs.getInt("bbsID"));
	            bbs.setBbsTitle(rs.getString("bbsTitle"));
	            bbs.setUserID(rs.getString("userID"));
	            bbs.setBbsDate(rs.getString("bbsDate"));
	            bbs.setBbsContent(rs.getString("bbsContent"));
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
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
                bbs.setBbsID(rs.getInt("bbsID"));
                bbs.setBbsTitle(rs.getString("bbsTitle"));
                bbs.setUserID(rs.getString("userID"));
                bbs.setBbsDate(rs.getString("bbsDate"));
                bbs.setBbsContent(rs.getString("bbsContent"));
                bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
                bbs.setImagePath(rs.getString("imagePath")); // 이미지 경로 추가
                return bbs;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // DB 오류 또는 게시글 없음
    }



    public int update(int bbsID, String bbsTitle, String bbsContent, String imagePath) {
        String SQL = "UPDATE BBS_GALLERY SET bbsTitle = ?, bbsContent = ?, imagePath = ? WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, bbsTitle);
            pstmt.setString(2, bbsContent);
            pstmt.setString(3, imagePath);  // 이미지 경로 업데이트
            pstmt.setInt(4, bbsID);
            return pstmt.executeUpdate();
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