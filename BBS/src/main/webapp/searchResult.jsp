<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="search.SearchDAO" %>
<%@ page import="search.PostDTO" %>
<!DOCTYPE html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<%
	request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
    <title>S/W 프로젝트</title>
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
                <li><a href="bbs_review.jsp">Review</a></li>
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
	            request.setCharacterEncoding("UTF-8");
	    	    String searchField = request.getParameter("searchField"); // 검색 필드
	    	    String searchText = request.getParameter("searchText");         // 검색어
	    	    SearchDAO dao = new SearchDAO();
	    	    ArrayList<PostDTO> searchResults = dao.searchPosts(searchField, searchText);
	    	    int totalCount = searchResults.size();  // 총 게시글 수 가져오기
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
	            if (searchResults.size() > 0) {
	                for (PostDTO post : searchResults) {
	                	String link = null;
	                	if (post.getBbsTable().equals("bbs")) {
	                		link = "view.jsp?bbsID=" + post.getBbsID();
	                	} else {
	                		link = "view_" + post.getBbsTable() + ".jsp?bbsID=" + post.getBbsID();
	                	}
        	%>
					        <tr>
					            <td><%= rankNumber-- %></td> <!-- 게시글 번호 출력 -->
					            <td><a href="<%= link %>"><%= post.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
					            <td><%= post.getUserID() %></td>
					            <td><%= post.getBbsDate().substring(0, 11) + " " + post.getBbsDate().substring(11, 13) + "시" + post.getBbsDate().substring(14, 16) + "분" %></td>
					            <td><%= post.getBbsCount() %></td>
					            <td>+<%= post.getLikeCount() %></td>
					        </tr>
			<%
	                	}
	                } else {
			%>
					<tr>
						<td>검색 결과가 없습니다.</td>
					</tr>
			<%
	                }
			%>
	        			</tbody>
					</table>
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
