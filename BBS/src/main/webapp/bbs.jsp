<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
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
<style>
    .dropdown-menu {
        display: none;
        position: absolute;
        will-change: transform;
        transition: transform 0.2s ease-out, opacity 0.2s ease-out;
        transform: translateY(-10px);
        opacity: 0;
    }

    .dropdown-menu.show {
        display: block;
        transform: translateY(0);
        opacity: 1;
    }

    .dropdown-menu .dropdown-item {
        display: block;
        width: 100%;
        margin-left: 5px;
        margin-right: 5px;
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
        String category = request.getParameter("category");
        String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "기본";
        String sortOrder = request.getParameter("sortOrder") != null ? request.getParameter("sortOrder") : "DESC";
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "기본";  // 기본 정렬 설정
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "ASC";  // 기본 정렬 순서 설정
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
                <li class="active"><a href="bbs.jsp?category=">General</a></li>
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
    	<div class="row mb-3">
    		<!-- 정렬 Dropdown menu -->
    		<div class="btn-group" role="group" aria-label="Sort Options" style="margin-bottom: 10px;">
			    <button id="sortDropdown" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			        정렬: <%= sortBy %>
			    </button>
			    <div class="dropdown-menu" aria-labelledby="sortDropdown">
			        <a class="dropdown-item" href="bbs.jsp?category=<%= (category == null ? "" : category) %>&sortBy=기본&sortOrder=<%= toggleOrder("기본", sortBy, sortOrder) %>">기본</a>
			        <a class="dropdown-item" href="bbs.jsp?category=<%= (category == null ? "" : category) %>&sortBy=날짜&sortOrder=<%= toggleOrder("날짜", sortBy, sortOrder) %>">날짜</a>
			        <a class="dropdown-item" href="bbs.jsp?category=<%= (category == null ? "" : category) %>&sortBy=조회순&sortOrder=<%= toggleOrder("조회순", sortBy, sortOrder) %>">조회순</a>
			        <a class="dropdown-item" href="bbs.jsp?category=<%= (category == null ? "" : category) %>&sortBy=추천순&sortOrder=<%= toggleOrder("추천순", sortBy, sortOrder) %>">추천순</a>
			    </div>
			</div>
    		<!-- 카테고리 버튼 -->
    		<div class="btn-group" role="group" aria-label="Category">
	            <a href="bbs.jsp?category=" class="btn btn-secondary <%= (category == null || category.equals("")) ? "active" : "" %>">전체</a>
	            <a href="bbs.jsp?category=잡담" class="btn btn-secondary <%= "잡담".equals(category) ? "active" : "" %>">잡담</a>
	            <a href="bbs.jsp?category=음향" class="btn btn-secondary <%= "음향".equals(category) ? "active" : "" %>">음향</a>
	            <a href="bbs.jsp?category=IT" class="btn btn-secondary <%= "IT".equals(category) ? "active" : "" %>">IT</a>
	            <a href="bbs.jsp?category=뉴스" class="btn btn-secondary <%= "뉴스".equals(category) ? "active" : "" %>">뉴스</a>
	            <a href="bbs.jsp?category=유머" class="btn btn-secondary <%= "유머".equals(category) ? "active" : "" %>">유머</a>
	            <a href="bbs.jsp?category=인사" class="btn btn-secondary <%= "인사".equals(category) ? "active" : "" %>">인사</a>
	            <a href="bbs.jsp?category=공지" class="btn btn-secondary <%= "공지".equals(category) ? "active" : "" %>">공지</a>
	        </div>
		</div>
        <div class="row">
            <%
	            BbsDAO bbsDAO = new BbsDAO();
            	CommentDAO commentDAO = new CommentDAO();
	            ArrayList<Bbs> list = bbsDAO.getList(pageNumber, category, sortBy, sortOrder);
	            int totalCount = (category == null || category.isEmpty()) 
	                    ? bbsDAO.getTotalCount() : bbsDAO.getTotalCountByCategory(category);
	            int rankNumber = totalCount - (pageNumber - 1) * 10;
			%>
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
		    <thead>
		        <tr>
		            <th style="background-color: #eeeeee; text-align: center; width: 5%;">번호</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 10%;">분류</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 30%;">제목</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 10%;">글쓴이</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 15%;">날짜</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 5%;">조회수</th>
		            <th style="background-color: #eeeeee; text-align: center; width: 5%;">추천</th>
		        </tr>
		    </thead>
		    <tbody>
		        <%
		            for (Bbs bbs : list) {
		        %>
		        <tr>
		            <td><%= rankNumber-- %></td> <!-- 게시글 번호 출력 -->
		            <td><%= bbs.getCategory() %></td> <!-- 카테고리 출력 -->
		            <td style="text-align: left;">
		            	<a href="view.jsp?bbsID=<%= bbs.getBbsID() %>"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a>
		            	<span style="color: red; text-decoration: underline;"> 
		            		<%=commentDAO.getCommentCount(bbs.getBbsID()) %>
		            	</span>
		            </td>
		            <td><%= bbs.getUserID() %></td>
		            <td><%= bbsDAO.getDisplayDate(bbs.getBbsDate()) %></td>
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
		            <a href="bbs.jsp?category=<%=category%>&pageNumber=<%=startPage - 1%>" aria-label="Previous">
		                <span aria-hidden="true">&laquo;</span>
		            </a>
		        </li>
		        <% } %>
		
		        <% for (int i = startPage; i <= endPage; i++) { %>
		        <li class="<%= (i == pageNumber) ? "active" : "" %>">
		            <a href="bbs.jsp?category=<%=category%>&pageNumber=<%=i%>"><%=i%></a>
		        </li>
		        <% } %>
		
		        <% if (endPage < totalPages) { %>
		        <li>
		            <a href="bbs.jsp?category=<%=category%>&pageNumber=<%=endPage + 1%>" aria-label="Next">
		                <span aria-hidden="true">&raquo;</span>
		            </a>
		        </li>
		        <% } %>
		    </ul>
		</nav>
		
		<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
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
    <script>
	    document.addEventListener("DOMContentLoaded", function() {
	        var sortDropdownButton = document.getElementById("sortDropdown");
	        var dropdownMenu = sortDropdownButton.nextElementSibling;
	
	        sortDropdownButton.addEventListener("click", function() {
	            dropdownMenu.classList.toggle("show");
	        });
	
	        window.addEventListener("click", function(event) {
	            if (!sortDropdownButton.contains(event.target)) {
	                dropdownMenu.classList.remove("show");
	            }
	        });
	    });
	</script>
</body>
</html>
<%!
    String toggleOrder(String currentSort, String previousSort, String previousOrder) {
        if (currentSort.equals(previousSort)) {
            return previousOrder.equals("DESC") ? "ASC" : "DESC";
        } else {
            return "DESC";
        }
    }
%>

