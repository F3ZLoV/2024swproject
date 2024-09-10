<%@ page import="java.sql.*" %>
<%
    String bbsTitle = request.getParameter("bbsTitle");
    String userID = (String) session.getAttribute("userID");  // 세션에서 사용자 ID를 가져옴
    String bbsContent = request.getParameter("bbsContent");

    Connection conn = null;
    PreparedStatement pstmt = null;
    String dbURL = "jdbc:mysql://localhost:3306/BBS_REVIEW";
    String dbID = "root";
    String dbPassword = "root";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String SQL = "INSERT INTO BBS_REVIEW (bbsTitle, userID, bbsContent, bbsAvailable) VALUES (?, ?, ?, 1)";
        pstmt = conn.prepareStatement(SQL);
        pstmt.setString(1, bbsTitle);
        pstmt.setString(2, userID);
        pstmt.setString(3, bbsContent);
        int result = pstmt.executeUpdate();

        if (result == 1) {
            response.sendRedirect("bbs_review.jsp");  // 성공 시 리뷰 목록으로 이동
        } else {
            out.println("리뷰 작성에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
