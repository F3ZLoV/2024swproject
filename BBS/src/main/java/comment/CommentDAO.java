package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO {
	private Connection conn;
	private ResultSet rs;
	
	public CommentDAO() {
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
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	public int getNext() {
		String SQL = "SELECT commentID FROM comment ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int write(int bbsID, String userID, String commentText, Integer parentCommentID) {
		String SQL = "INSERT INTO comment VALUES (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setInt(2, bbsID);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, commentText);
			pstmt.setInt(6, 1);
			if (parentCommentID == null) {
				pstmt.setNull(7, java.sql.Types.INTEGER);
			} else {
				pstmt.setInt(7, parentCommentID);
			}
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public String getUpdateComment(int commentID) {
		String SQL = "SELECT commentText FROM comment WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return "";
 	}
	
	public ArrayList<Comment> getList(int bbsID) {
	    String SQL = "SELECT * "
	               + "FROM comment WHERE bbsID = ? AND commentAvailable = 1 ORDER BY commentID ASC";
	    ArrayList<Comment> list = new ArrayList<Comment>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, bbsID);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	Comment cmt = new Comment();
	        	cmt.setCommentID(rs.getInt(1));
	        	cmt.setBbsID(rs.getInt(2));
	        	cmt.setUserID(rs.getString(3));
	        	cmt.setCommentDate(rs.getString(4));
	        	cmt.setCommentText(rs.getString(5));
	        	cmt.setCommentAvailable(rs.getInt(6));
	        	cmt.setParentCommentID(rs.getInt(7));
	            list.add(cmt);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public Comment getComment(int commentID) {
		String SQL = "SELECT * FROM comment WHERE commentID = ? ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Comment cmt = new Comment();
				cmt.setCommentID(rs.getInt(1));
				cmt.setBbsID(rs.getInt(2));
				cmt.setUserID(rs.getString(3));
				cmt.setCommentDate(rs.getString(4));
				cmt.setCommentText(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				return cmt;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ArrayList<Comment> getReplies(int parentCommentID) {
	    String SQL = "SELECT * FROM comment WHERE parentCommentID = ? AND commentAvailable = 1 ORDER BY commentID ASC";
	    ArrayList<Comment> list = new ArrayList<Comment>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, parentCommentID);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Comment cmt = new Comment();
	            cmt.setCommentID(rs.getInt(1));
	            cmt.setBbsID(rs.getInt(2));
	            cmt.setUserID(rs.getString(3));
	            cmt.setCommentDate(rs.getString(4));
	            cmt.setCommentText(rs.getString(5));
	            cmt.setCommentAvailable(rs.getInt(6));
	            cmt.setParentCommentID(rs.getInt(7));
	            list.add(cmt);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	
	public int update(int commentID, String commentText) {
		String SQL = "UPDATE comment SET commentText = ? WHERE commentID LIKE ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentText);
			pstmt.setInt(2, commentID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int delete(int commentID) {
		String SQL = "DELETE FROM comment WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int getCommentCount(int bbsID) {
		String SQL = "SELECT count(*) FROM comment WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
 	}
}