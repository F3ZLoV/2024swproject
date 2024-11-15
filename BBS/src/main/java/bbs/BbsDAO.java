package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
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
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
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
	
	public int write(String bbsTitle, String userID, String bbsContent, String category, int bbsCount, int likeCount) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext());
			pstmt.setString(2,  bbsTitle);
			pstmt.setString(3,  userID);
			pstmt.setString(4,  getDate());
			pstmt.setString(5,  bbsContent);
			pstmt.setInt(6, 1);
			pstmt.setInt(7, bbsCount);
			pstmt.setInt(8, likeCount);
			pstmt.setString(9, category);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber) {
	    String SQL = "SELECT * "
	               + "FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT ?, 10";
	    ArrayList<Bbs> list = new ArrayList<Bbs>();
	    try {
	        int totalCount = getTotalCount();	// 전체 게시글 수를 가져와서 계산
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, (pageNumber - 1) * 10);  // 페이징 처리
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Bbs bbs = new Bbs();
	            bbs.setRankNumber(totalCount--);
	            bbs.setBbsID(rs.getInt(1));
	            bbs.setBbsTitle(rs.getString(2));
	            bbs.setUserID(rs.getString(3));
	            bbs.setBbsDate(rs.getString(4));
	            bbs.setBbsContent(rs.getString(5));
	            bbs.setBbsAvailable(rs.getInt(6));
	            bbs.setBbsCount(rs.getInt(7));
	            bbs.setLikeCount(rs.getInt(8));
	            bbs.setCategory(rs.getString(9));
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	private String getOrderBySortingText(String sortBy, String sortOrder) {
	    String orderColumn;
	    switch (sortBy) {
	        case "날짜":
	            orderColumn = "bbsDate";
	            break;
	        case "조회순":
	            orderColumn = "bbsCount";
	            break;
	        case "추천순":
	            orderColumn = "likeCount";
	            break;
	        default:
	            orderColumn = "bbsID";
	            break;
	    }
	    return orderColumn + (sortOrder.equals("DESC") ? " DESC" : " ASC");
	}

	
	public ArrayList<Bbs> getList(int pageNumber, String category, String sortBy, String sortOrder) {
	    String orderBy = getOrderBySortingText(sortBy, sortOrder);
	    String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1" 
	               + (category != null && !category.isEmpty() ? " AND category = ?" : "") 
	               + " ORDER BY " + orderBy + " LIMIT ?, 10";
	    
	    ArrayList<Bbs> list = new ArrayList<Bbs>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        int parameterIndex = 1;
	        
	        if (category != null && !category.isEmpty()) {
	            pstmt.setString(parameterIndex++, category);
	        }
	        
	        pstmt.setInt(parameterIndex, (pageNumber - 1) * 10);
	        rs = pstmt.executeQuery();
	        
	        // 결과 리스트 생성
	        while (rs.next()) {
	            Bbs bbs = new Bbs();
	            bbs.setBbsID(rs.getInt("bbsID"));
	            bbs.setBbsTitle(rs.getString("bbsTitle"));
	            bbs.setUserID(rs.getString("userID"));
	            bbs.setBbsDate(rs.getString("bbsDate"));
	            bbs.setBbsContent(rs.getString("bbsContent"));
	            bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
	            bbs.setBbsCount(rs.getInt("bbsCount"));
	            bbs.setLikeCount(rs.getInt("likeCount"));
	            bbs.setCategory(rs.getString("category"));
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}


	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; // 데이터베이스 오류
	}
	
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				int bbsCount=rs.getInt(7);
				bbs.setBbsCount(bbsCount);
				bbsCount++;
				countUpdate(bbsCount, bbsID);
				bbs.setLikeCount(rs.getInt(8));
				bbs.setCategory(rs.getString(9));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  bbsTitle);
			pstmt.setString(2,  bbsContent);
			pstmt.setInt(3,  bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int getTotalCount() {
	    String SQL = "SELECT COUNT(*) FROM BBS WHERE bbsAvailable = 1";
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
	
	public ArrayList<Bbs> getListByCategory(int pageNumber, String category) {
	    String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 AND category = ? ORDER BY bbsID DESC LIMIT ?, 10";
	    ArrayList<Bbs> list = new ArrayList<Bbs>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, category);
	        pstmt.setInt(2, (pageNumber - 1) * 10);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Bbs bbs = new Bbs();
	            bbs.setBbsID(rs.getInt(1));
	            bbs.setBbsTitle(rs.getString(2));
	            bbs.setUserID(rs.getString(3));
	            bbs.setBbsDate(rs.getString(4));
	            bbs.setBbsContent(rs.getString(5));
	            bbs.setBbsAvailable(rs.getInt(6));
	            bbs.setBbsCount(rs.getInt(7));
	            bbs.setLikeCount(rs.getInt(8));
	            bbs.setCategory(rs.getString(9)); 
	            list.add(bbs);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int getTotalCountByCategory(String category) {
	    String SQL = "SELECT COUNT(*) FROM BBS WHERE bbsAvailable = 1 AND category = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, category);
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;
	}
	
	public String getDisplayDate(String dateString) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            String sql = "SELECT NOW() AS currentTime";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String currentTimeString = rs.getString("currentTime");
                Date currentDate = sdf.parse(currentTimeString);
                Date inputDate = sdf.parse(dateString);

                long diffInSeconds = (currentDate.getTime() - inputDate.getTime()) / 1000;

                if (diffInSeconds < 3600) {
                    return (diffInSeconds / 60) + "분 전";
                } else if (diffInSeconds < 86400) {
                    return (diffInSeconds / 3600) + "시간 전";
                } else if (diffInSeconds < 604800) {
                    return (diffInSeconds / 86400) + "일 전";
                } else {
                    return new SimpleDateFormat("yy.MM.dd").format(inputDate);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return dateString;
    }


	public int countUpdate(int bbsCount, int bbsID) {
		String SQL = "update bbs set bbsCount = ? where bbsID = ?";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsCount);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();//insert,delete,update			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int like(int bbsID) {
		String SQL = "update bbs set likeCount = likeCount + 1 where bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}