<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@ page import="search.SearchDAO" %>
<%@ page import="search.PostDTO" %>
<%@ page import="bbs_music.Bbs_musicDAO" %>
<%@ page import="bbs_music.Bbs_music" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>S/W 프로젝트</title>
</head>
<style>
	body {
		background-color: #EEEEEE;	
	}
    .form-control, .btn {
        border-radius: 15px;
    }
    .btn-success {
        background-color: #90EE90;
        border-color: #90EE90;
        color: #000000;
    }
    .card {
    	border-radius: 15px;
    	background-color: #FFFFFF;
    }
    .card-header {
    	background-color: #F7F7F7;
        border-radius: 15px 15px 0 0;
        padding: 8px 12px;
    }
    .list-group {
    	margin-top: 10px;
    	margin-botton: 10px;
    }
    .list-group-item {
    	display: flex;
    	align-items: center;
    	margin-bottom: 4px;
    	background-color: #FFFFFF;
    	padding: 8px 12px;
    	justify-content: flex-start;
    }
    
    .list-group-item .number {
    	flex-shrink: 0;
    	text-align: center;
    	margin-right: 10px;
    }
    .list-group-item span.badge {
        margin-left: auto;
    }
    .list-group-item:nth-child(1) .number {
        background-color: red;
    }
    .list-group-item:nth-child(2) .number {
        background-color: black;
    }
    .list-group-item:nth-child(3) .number {
        background-color: #FFD700;
    }
    .list-group-item:nth-child(n+4) .number {
        background-color: #E0E0E0;
        color: #777;
    }
    .list-group-item a {
        flex-grow: 1;
        text-align: center;
		display: inline-block;
        flex-grow: 0;
        margin-left: 15px;
        margin-bottom: 5px;
    }
    .list-group-item .recommend {
    	flex-shrink: 0; /* 크기 고정 */
        color: red; /* 추천수 색상 */
        margin-left: 5px;
        margin-bottom: 5px;
    }
    .number {
        color: white;
        border-radius: 5px;
        padding: 5px;
        width: 25px;
        height: 25px;
        margin-right: 10px;
    }
    .recommend {
        color: red;
        margin-left: 10px;
        text-decoration: underline;
    }
    .thumnail-container {
    	display: flex;
    	flex-wrap: nowrap;
    	overflow-x: auto;
    	position: relative;
    	width: 120px;
    	height: 120px;
    	overflow: hidden;
    }
    .thumnail-item {
    	margin: 5px;
    	flex-shrink: 0;
    }
    #music-thumnails {
    	display: flex;
    	flex-wrap: wrap;
    }
</style>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
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
				<li class="active"><a href="main.jsp">Home</a></li>
				<li><a href="bbs.jsp">General</a></li>
				<li><a href="bbs_review.jsp">Review</a></li>
				<li><a href="bbs_gallery.jsp">Gallery</a></li>
				<li><a href="bbs_music.jsp">Musics</a></li>
				<li><a href="bbs_market.jsp">Market</a></li>
			</ul>
			<div class="navbar-form navbar-left">
                    <form method="post" name="search" action="searchResult.jsp" class="form-inline">
                        <div class="form-group">
                            <select class="form-control" name="searchField">
                                <option value="0">선택</option>
                                <option value="bbsTitle">제목</option>
                                <option value="userID">작성자</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="검색어 입력" name="searchText" maxlength="100">
                        </div>
                        <button type="submit" class="btn btn-success">검색</button>
                    </form>
                </div>
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
				 	<li><a href="userUpdate.jsp">회원수정</a></li>
				 </ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container mt-5">
    <div class="row">
        <!-- 최신글 섹션 -->
        <div class="col-md-6">
		    <div class="card">
		        <div class="card-header bg-light">
		            <h4 class="mb-0">최신글</h4>
		        </div>
		        <ul class="list-group list-group-flush">
		            <% 
		                SearchDAO recentDAO = new SearchDAO();
		                ArrayList<PostDTO> latestPosts = recentDAO.getLatestPosts();
		                int recentNumber = 1;
		                for (PostDTO post : latestPosts) { 
		                    String link = null;
		                    if (post.getBbsTable().equals("bbs")) {
		                        link = "view.jsp?bbsID=" + post.getBbsID();
		                    } else {
		                        link = "view_" + post.getBbsTable() + ".jsp?bbsID=" + post.getBbsID();
		                    }
		            %>
		            <li class="list-group-item">
		                <a class="number"><%= recentNumber++ %></a><a href="<%= link %>"><%= post.getBbsTitle() %></a>
		                <span class="recommend"><%= post.getLikeCount() %></span>
		            </li>
		            <% } %>
		        </ul>
		    </div>
		</div>

        <!-- 인기글 섹션 -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header bg-light">
                    <h4 class="mb-0">인기글</h4>
                </div>
                <ul class="list-group list-group-flush">
                    <% 
		                SearchDAO mostLikedDAO = new SearchDAO();
		                ArrayList<PostDTO> mostLikedPosts = mostLikedDAO.getMostLikedPosts();
		                int mostLikedNumber = 1;
		                for (PostDTO post : mostLikedPosts) { 
		                    String link = null;
		                    if (post.getBbsTable().equals("bbs")) {
		                        link = "view.jsp?bbsID=" + post.getBbsID();
		                    } else {
		                        link = "view_" + post.getBbsTable() + ".jsp?bbsID=" + post.getBbsID();
		                    }
		            %>
		            <li class="list-group-item">
		                <a class="number"><%= mostLikedNumber++ %></a><a href="<%= link %>"><%= post.getBbsTitle() %></a>
		                <span class="recommend"><%= post.getLikeCount() %></span>
		            </li>
		            <% } %>
                </ul>
            </div>
        </div>
    </div>
    </div>
	<div class="container">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner">
				<div class="item active">
					<img src="images/1.jpg">
				</div>
				<div class="item">
					<img src="images/2.jpg">
				</div>
				<div class="item">
					<img src="images/3.jpg">
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</a>
		</div>
	</div>
	<div class="container mt-5">
    <div class="row">
        <!-- 음악 섹션 -->
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-light">
                    <h4 class="mb-0">음악</h4>
                </div>
                <div id="music-thumbnails" class="list-group list-group-flush">
                    <% 
                        Bbs_musicDAO musicDAO = new Bbs_musicDAO();
                        ArrayList<Bbs_music> musicPosts = musicDAO.getMusicPosts();
                        int pageSize = 5;
                        int pageCount = (int) Math.ceil((double) musicPosts.size() / pageSize);
                        for (int i = 0; i < musicPosts.size(); i++) {
                            Bbs_music post = musicPosts.get(i);
                            String link = "view_music.jsp?bbsID=" + post.getBbsID();
                            String content = post.getBbsContent();
                            String youtubeId = "";
                            
                            // YouTube 링크에서 ID 추출
                            Pattern pattern = Pattern.compile("https?://(?:www\\.|m\\.)?(?:youtube\\.com/watch\\?v=|youtu\\.be/)([a-zA-Z0-9_-]{11})");
                            Matcher matcher = pattern.matcher(content);
                            if (matcher.find()) {
                                youtubeId = matcher.group(1); // ID 추출
                            }
                    %>
                    <div class="col-md-2 thumbnail-item" data-page="<%= (i / pageSize) + 1 %>" style="display: none;">
                        <% if (!youtubeId.isEmpty()) { %>
                            <a href="<%= link %>">
                                <img src="https://img.youtube.com/vi/<%= youtubeId %>/0.jpg" 
                                     alt="<%=post.getBbsTitle() %>" 
                                     class="img-thumbnail" 
                                     style="width: 120px; height: 90px;">
                            </a>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                <!-- 페이징 버튼 -->
                <div class="card-footer text-center">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="Previous" onclick="showPage(currentPage - 1)">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <% for (int i = 1; i <= pageCount; i++) { %>
                                <li class="page-item"><a class="page-link" href="#" onclick="showPage(<%= i %>)"><%= i %></a></li>
                            <% } %>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="Next" onclick="showPage(currentPage + 1)">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

    <script>
	    let currentPage = 1;
	    const pageSize = 5;
	    const pageCount = <%= pageCount %>;
	
	    function showPage(page) {
	        if (page < 1 || page > pageCount) return;
	        currentPage = page;
	
	        const items = document.querySelectorAll('.thumbnail-item');
	        items.forEach(item => {
	            item.style.display = (item.getAttribute('data-page') == currentPage) ? 'block' : 'none';
	        });
	
	        document.querySelectorAll('.page-item').forEach(item => {
	            item.classList.remove('active');
	        });
	
	        document.querySelector('.pagination .page-item:nth-child(' + (currentPage + 1) + ')').classList.add('active');
	    }
	
	    document.addEventListener('DOMContentLoaded', function () {
	        showPage(1);
	    });
	</script>

		
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