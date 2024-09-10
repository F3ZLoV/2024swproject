<%@ page import="java.sql.*, java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 게시판</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <!-- General 게시판에서 사용된 navbar 복사 -->
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
            </div>
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">Home</a></li>
                <li><a href="bbs.jsp">General</a></li>
                <li class="active"><a href="bbs_review.jsp">Review</a></li>
                <li><a href="bbs_galary.jsp">Gallery</a></li>
                <li><a href="bbs_music.jsp">Musics</a></li>
                <li><a href="bbs_marketplace.jsp">Market</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="login.jsp"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2>리뷰 게시판</h2>
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
            <thead>
                <tr>
                    <th style="background-color: #eeeeee; text-align: center;">번호</th>
                    <th style="background-color: #eeeeee; text-align: center;">제목</th>
                    <th style="background-color: #eeeeee; text-align: center;">작성자</th>
                    <th style="background-color: #eeeeee; text-align: center;">작성일</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    String dbURL = "jdbc:mysql://localhost:3306/BBS_REVIEW";
                    String dbID = "root";
                    String dbPassword = "root";

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                        // 리뷰 목록을 가져오는 SQL
                        String SQL = "SELECT * FROM BBS_REVIEW WHERE bbsAvailable = 1 ORDER BY bbsID DESC";
                        pstmt = conn.prepareStatement(SQL);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int bbsID = rs.getInt("bbsID");
                            String bbsTitle = rs.getString("bbsTitle");
                            String userID = rs.getString("userID");
                            String bbsDate = rs.getString("bbsDate").substring(0, 10); // 날짜만 출력

                %>
                <tr>
                    <td><%= bbsID %></td>
                    <td><a href="view_review.jsp?bbsID=<%= bbsID %>"><%= bbsTitle %></a></td>
                    <td><%= userID %></td>
                    <td><%= bbsDate %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
        
        <!-- 리뷰 작성 버튼 -->
        <a href="write_review.jsp" class="btn btn-primary">리뷰 작성</a>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
