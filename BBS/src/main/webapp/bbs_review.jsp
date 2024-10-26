<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs_review.Bbs_reviewDAO" %>
<%@ page import="bbs_review.Bbs_review" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>S/W 프로젝트</title>
<style type="text/css">
	a, a:hover {
		color:#000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">S/W 프로젝트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">Home</a></li>
				<li><a href="bbs.jsp">General</a></li>
				<li class="active"><a href="bbs_review.jsp">Review</a></li>
				<li><a href="bbs_gallery.jsp">Gallery</a></li>
				<li><a href="bbs_music.jsp">Musics</a></li>
				<li><a href="bbs_market.jsp">Market</a></li>
			</ul>
			<%
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				 <a href="#" class=dropdown-toggle
				 	data-toggle="dropdown" role="botton" aria-haspopup="true"
				 	aria-expanded="false">접속하기<span class="caret"></span></a>
				 <ul class="dropdown-menu">
				 	<li><a href="login.jsp">로그인</a></li>
				 	<li><a href="join.jsp">회원가입</a></li>
				 </ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				 <a href="#" class=dropdown-toggle
				 	data-toggle="dropdown" role="botton" aria-haspopup="true"
				 	aria-expanded="false">회원관리<span class="caret"></span></a>
				 <ul class="dropdown-menu">
				 	<li><a href="logoutAction.jsp">로그아웃</a></li>
				 </ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
        <div class="row">
            <%
			    Bbs_reviewDAO bbsDAO = new Bbs_reviewDAO();
			    ArrayList<Bbs_review> list = bbsDAO.getList(pageNumber);
			    int totalCount = bbsDAO.getTotalCount();  // 총 게시글 수 가져오기
			    int rankNumber = totalCount - (pageNumber - 1) * 10;  // 게시글 번호 계산
			%>
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			    <thead>
			        <tr>
			            <th style="background-color: #eeeeee; text-align: center;">번호</th>
			            <th style="background-color: #eeeeee; text-align: center;">제목</th>
			            <th style="background-color: #eeeeee; text-align: center;">작성자</th>
			            <th style="background-color: #eeeeee; text-align: center;">작성일</th>
			            <th style="background-color: #eeeeee; text-align: center;">조회수</th>
			            <th style="background-color: #eeeeee; text-align: center;">추천수</th>
			        </tr>
			    </thead>
			    <tbody>
			        <%
			            for (Bbs_review bbs : list) {
			        %>
			        <tr>
			            <td><%= rankNumber-- %></td> <!-- 게시글 번호 출력 -->
			            <td><a href="view_review.jsp?bbsID=<%= bbs.getBbsID() %>"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
			            <td><%= bbs.getUserID() %></td>
			            <td><%= bbs.getBbsDate().substring(0, 11) + " " + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
			            <td><%= bbs.getBbsCount() %></td>
			            <td>+<%= bbs.getLikeCount() %></td>
			        </tr>
			        <%
			            }
			        %>
			    </tbody>
			</table>
		<%
            int pageSize = 10;  // 페이지당 게시글 수
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);  // 총 페이지 수 계산
            int pageBlock = 5;  // 한 번에 표시할 페이지 번호 개수
            int startPage = ((pageNumber - 1) / pageBlock) * pageBlock + 1;
            int endPage = startPage + pageBlock - 1;
            if (endPage > totalPages) {
                endPage = totalPages;
            }
        %>

        <nav aria-label="Page navigation">
            <ul class="pagination">
                <% if (startPage > 1) { %>
                <li>
                    <a href="bbs.jsp?pageNumber=<%=startPage - 1%>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <% } %>
                
                <% for (int i = startPage; i <= endPage; i++) { %>
                <li class="<%= (i == pageNumber) ? "active" : "" %>">
                    <a href="bbs.jsp?pageNumber=<%=i%>"><%=i%></a>
                </li>
                <% } %>
                
                <% if (endPage < totalPages) { %>
                <li>
                    <a href="bbs.jsp?pageNumber=<%=endPage + 1%>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
                <% } %>
            </ul>
        </nav>
		<a href="write_review.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<!-- FOOTER -->
	<footer style="background-color: #000000; color: #ffffff">
		<div class="container">
			<br>
			<div class="row">
				<div class="col-sm-2" style="text-align: center"><h5>Copyright&copy; F3ZLoV All rights reserved.</h5><h5>박태준(Taejoon Park)</h5></div>
				<div class="col-sm-4"><h4>개발자 소개</h4><p>저는 박태준입니다. 인하공업전문대학교에서 공부를 하고 있습니다.</p></div>
				<div class="col-sm-2"><h4 style="text-align: center;">Navigation</h4>
					<div class="list-group">
						<a href="#" class="list-group-item">소개</a>
						<a href="#" class="list-group-item">이용약관</a>
						<a href="#" class="list-group-item">개인정보처리방침</a>
					</div>
				</div>
				<div class="col-sm-2"><h4 style="text-align: center;">Contact</h4>
					<div class="list-group">
						<a href="#" class="list-group-item">010-0000-0000</a>
						<a href="#" class="list-group-item">fsirtru@gmail.com</a>
						<a href="#" class="list-group-item">github.com/F3ZLoV</a>
					</div>
				</div>
				<div class="col-sm-2"><h4 style="text-align: center;"><span class="glyphicon glyphicon-ok"></span>&nbsp;by 박태준</h4></div>
			</div>
		</div>
	</footer>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>