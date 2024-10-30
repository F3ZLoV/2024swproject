package search;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.io.UnsupportedEncodingException;

public class SearchDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    public SearchDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/BBS?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void setUnicodeParameters(PreparedStatement pstmt, int index, String value) throws SQLException {
    	try {
            pstmt.setBytes(index, value.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException e) {
            throw new SQLException("Unsupported encoding: UTF-8", e);
        }
    }
    
    // 게시판 통합 검색 메서드
    public ArrayList<PostDTO> searchPosts(String searchField, String searchText) {
        ArrayList<PostDTO> postList = new ArrayList<>();
        try {
            String sql = 
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'bbs' AS bbsTable FROM bbs WHERE " + searchField + " LIKE ? and bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'review' AS bbsTable FROM bbs_review WHERE " + searchField + " LIKE ? and bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'market' AS bbsTable FROM bbs_market WHERE " + searchField + " LIKE ? and bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'gallery' AS bbsTable FROM bbs_gallery WHERE " + searchField + " LIKE ? and bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'music' AS bbsTable FROM bbs_music WHERE " + searchField + " LIKE ? and bbsAvailable = 1 ";

            pstmt = conn.prepareStatement(sql);
            
            // 모든 ? 파라미터에 동일한 검색어 적용
            for (int i = 1; i <= 5; i++) {
            	setUnicodeParameters(pstmt, i, "%" + searchText + "%");
            }

            rs = pstmt.executeQuery();
            // 결과 처리
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setBbsID(rs.getInt("bbsID"));
                post.setUserID(rs.getString("userID"));
                post.setBbsTitle(rs.getString("bbsTitle"));
                post.setBbsDate(rs.getString("bbsDate"));
                post.setBbsCount(rs.getInt("bbsCount"));
                post.setLikeCount(rs.getInt("likeCount"));
                post.setBbsTable(rs.getString("bbsTable"));
                postList.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }

        return postList;
    }
    
    public ArrayList<PostDTO> getLatestPosts() {
        ArrayList<PostDTO> postList = new ArrayList<>();
        try {
            String sql =
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'bbs' AS bbsTable FROM bbs WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'review' AS bbsTable FROM bbs_review WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'market' AS bbsTable FROM bbs_market WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'gallery' AS bbsTable FROM bbs_gallery WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'music' AS bbsTable FROM bbs_music WHERE bbsAvailable = 1 " +
                "ORDER BY bbsDate DESC LIMIT 10";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setBbsID(rs.getInt("bbsID"));
                post.setUserID(rs.getString("userID"));
                post.setBbsTitle(rs.getString("bbsTitle"));
                post.setBbsDate(rs.getString("bbsDate"));
                post.setBbsCount(rs.getInt("bbsCount"));
                post.setLikeCount(rs.getInt("likeCount"));
                post.setBbsTable(rs.getString("bbsTable"));
                postList.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return postList;
    }
    
    public ArrayList<PostDTO> getMostLikedPosts() {
        ArrayList<PostDTO> postList = new ArrayList<>();
        try {
            String sql =
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'bbs' AS bbsTable FROM bbs WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'review' AS bbsTable FROM bbs_review WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'market' AS bbsTable FROM bbs_market WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'gallery' AS bbsTable FROM bbs_gallery WHERE bbsAvailable = 1 " +
                "UNION ALL " +
                "SELECT bbsID, userID, bbsTitle, bbsDate, bbsCount, likeCount, 'music' AS bbsTable FROM bbs_music WHERE bbsAvailable = 1 " +
                "ORDER BY likeCount DESC LIMIT 10";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setBbsID(rs.getInt("bbsID"));
                post.setUserID(rs.getString("userID"));
                post.setBbsTitle(rs.getString("bbsTitle"));
                post.setBbsDate(rs.getString("bbsDate"));
                post.setBbsCount(rs.getInt("bbsCount"));
                post.setLikeCount(rs.getInt("likeCount"));
                post.setBbsTable(rs.getString("bbsTable"));
                postList.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return postList;
    }

}
