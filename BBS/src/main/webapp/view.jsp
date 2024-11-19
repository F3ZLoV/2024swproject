<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@page import="comment.Comment"%>
<%@page import="comment.CommentDAO"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentText" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>S/W 프로젝트</title>
<style>
	body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
    }
 	.post-container {
        max-width: 1200px;
        padding: 20px; 
        border: 1px solid #ddd;
        border-radius: 10px;
        background-color: #fff; 
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    }
    .post-image {
        width: 100%;
        height: auto;
    }
    .post-header {
        padding: 30px;
        background-color: #f7f7f7;
    }
    .post-header .category {
        display: inline-block;
        padding: 8px 15px;
        background-color: #007bff;
        color: white;
        border-radius: 5px;
        font-size: 16px;
    }
    .post-header .title {
        margin-top: 10px;
        font-size: 24px;
        font-weight: bold;
    }
    .post-info {
        margin-top: 10px;
        font-size: 12px;
        color: #666;
        display: flex;
        justify-content: space-between;
    }
    
    .post-info div {
        display: flex;
        align-items: center;
    }

    .post-info .user-id {
        color: #000000; /* 사용자 ID 색상 */
        font-weight: bold;
    }

    .post-info .date {
        color: #9FA09F; /* 작성일 색상 */
        margin-left: 10px;
    }

    .post-info .stats {
        display: flex;
        gap: 15px; /* 통계 아이콘 간격 */
        color: #666; /* 기본 회색 */
        align-items: center;
    }

    .post-info .stats .icon {
        display: flex;
        align-items: center;
        gap: 15px; /* 아이콘과 숫자 간격 */
    }

    .post-info .stats .views {
        color: #666; /* 조회수 색상 */
    }

    .post-info .stats .likes {
        color: #ff4d4f; /* 좋아요 색상 */
    }

    .post-info .stats .comments {
        color: #000000; /* 댓글 색상 */
    }
    .post-content {
        padding: 30px;
        line-height: 1.8;
        font-size: 18px;
        color: #333;
    }
    .post-stats {
        text-align: right;
        padding: 15px 30px;
        border-top: 1px solid #ddd;
        font-size: 12px;
        background-color: #f7f7f7;
    }
    a.btn {
        margin-left: 10px;
    }

    .icon {
        font-size: 18px;
        vertical-align: middle;
    }
 /* 댓글 스타일 */
    .comment {
        margin-bottom: 20px;
        padding: 10px;
        background-color: #f9f9f9;
        border-radius: 5px;
    }
    /* 대댓글 들여쓰기 스타일 */
    .reply {
        margin-left: 40px;
    }
    /* 테이블 행 간격 설정 */
    .table {
        border-spacing: 0 10px; /* 각 행 사이에 10px의 간격 추가 */
    }
    /* 일반 댓글 스타일 */
    .comment-container td {
        padding-left: 0; /* 기본 들여쓰기 없음 */
    }
    /* 대댓글 스타일 */
    .comment-reply td {
        padding-left: 50px; /* 대댓글의 들여쓰기 설정 */
    }
</style>
</head>
<body>
<script src="https://kit.fontawesome.com/957b70594e.js" crossorigin="anonymous"></script>
<script>
	function showReplyForm(commentID) {
	    var replyForm = document.getElementById("replyForm_" + commentID);
	    replyForm.style.display = replyForm.style.display === "none" ? "block" : "none";
	}
</script>

<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp';");
		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	CommentDAO commentDAO = new CommentDAO();
	ArrayList<Comment> list = commentDAO.getList(bbsID);
	request.setAttribute("commentList", list);
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
				<li class="active"><a href="bbs.jsp">General</a></li>
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
	<div class="post-container">
		<div class="row">
			<div class="post-header">
		        <span class="category"><%= bbs.getCategory() %></span>
		        <div class="title"><%= bbs.getBbsTitle() %></div>
		        <div class="post-info">
		            <div>
		                 <%= bbs.getUserID() %> &nbsp;&nbsp;&nbsp;&nbsp; <%= bbs.getBbsDate().substring(0, 16) %>
		            </div>
		            <div>
						<div class="icon views">
	                        <i class="fas fa-eye"></i> <span><%= bbs.getBbsCount() %></span>
	                    </div>
	                    &nbsp;&nbsp;
	                    <div class="icon likes">
	                        <i class="fas fa-thumbs-up"></i> <span><%= bbs.getLikeCount() %></span>
	                    </div>
	                    &nbsp;&nbsp;
	                    <div class="icon comments">
	                        <i class="fas fa-comment-dots"></i> <span><%= list.size() %></span>
	                    </div>
                    </div>
		        </div>
		    </div>
		    <div class="post-content">
		        <%= bbs.getBbsContent().replaceAll("\n", "<br>") %>
		    </div>
		    <div class="post-stats">
		        <a href="likeAction.jsp?bbsID=<%= bbsID %>" class="btn btn-success">👍 좋아요</a>
		        <% if (userID != null && userID.equals(bbs.getUserID())) { %>
		            <a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
		            <a href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-danger" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
		        <% } %>
		    </div>
		</div>
	</div>
	
	<%!
	    // 댓글 계층 출력 메서드
	    void renderComments(ArrayList<Comment> comments, int parentID, int depth, javax.servlet.jsp.JspWriter out, String currentUserID) throws Exception {
	        for (Comment comment : comments) {
	            if (comment.getParentCommentID() == parentID) {
	                out.println("<tr style='border-bottom: 1px solid #dddddd; background-color: " + (depth % 2 == 0 ? "#f9f9f9" : "#ffffff") + ";'>");
	                out.println("<td align='left' colspan='5' style='padding-left: " + (depth * 35) + "px; padding-top: 10px; padding-bottom: 5px;'>");
	                
	                // 대댓글 표시 구분자
	                if (depth > 0) {
	                    out.println("<span style='color: #aaaaaa;'>ㄴ</span> ");
	                }
	                out.println(comment.getUserID() + " &nbsp;&nbsp;" + comment.getCommentDate().substring(2, 10) + 
	                            " " + comment.getCommentDate().substring(11, 16));
	                
	                out.println("<div style='float: right;'>");
	                if (comment.getUserID().equals(currentUserID)) {
	                    out.println("<a type='button' onclick='nwindow(" + comment.getBbsID() + ", " + comment.getCommentID() + ")' class='btn-primary'>수정</a> ");
	                    out.println("<a onclick='return confirm(\"정말로 삭제하시겠습니까?\")' href='commentDeleteAction.jsp?bbsID=" + comment.getBbsID() + "&commentID=" + comment.getCommentID() + "' class='btn-primary'>삭제</a> ");
	                }
	                out.println("<a href='#' onclick=\"showReplyForm(" + comment.getCommentID() + ")\" class='btn-primary'>답글</a>");
	                out.println("</div>");
	                
	                out.println("</td>");
	                out.println("</tr>");
	                
	                // 댓글 내용
	                out.println("<tr style='background-color: " + (depth % 2 == 0 ? "#f9f9f9" : "#ffffff") + ";'>");
	                out.println("<td colspan='5' align='left' style='padding-left: " + (depth * 35) + "px; padding-bottom: 10px;'>");
	                out.println(comment.getCommentText().replace("\n", "<br>"));
	                out.println("</td>");
	                out.println("</tr>");
	                
	                // 답글 입력 폼 (기본은 숨김 처리)
	                out.println("<tr id='replyForm_" + comment.getCommentID() + "' style='display: none; background-color: " + (depth % 2 == 0 ? "#f9f9f9" : "#ffffff") + ";'>");
	                out.println("<td colspan='5' style='padding-left: " + (depth * 20) + "px;'>");
	                out.println("<form method='post' action='commentAction.jsp?bbsID=" + comment.getBbsID() + "'>");
	                out.println("<input type='hidden' name='parentCommentID' value='" + comment.getCommentID() + "'>");
	                out.println("<textarea name='commentText' class='form-control' placeholder='답글을 작성해주세요.'></textarea>");
	                out.println("<input type='submit' class='btn-primary pull' value='답글 작성'>");
	                out.println("</form>");
	                out.println("</td>");
	                out.println("</tr>");
	                
	                // 현재 댓글 ID를 부모로 가지는 대댓글을 재귀호출
	                renderComments(comments, comment.getCommentID(), depth + 1, out, currentUserID);
	            }
	        }
	    }
	%>


	<div class="container">
	    <div class="row">
	        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd;">
	            <tbody>
	                <% renderComments(list, 0, 0, out, userID); %>
	            </tbody>
	        </table>
	    </div>
	</div>
	
	<div class="container">
	    <div class="form-group">
	    <form method="post" action="commentAction.jsp?bbsID=<%= bbsID %>">
	        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
	            <tr>
	                <td style="border-bottom:none;" valign="middle"><br><br><%= userID %></td>
	                <td><input type="text" style="height:100px;" class="form-control" placeholder="댓글을 작성해주세요." name="commentText"></td>
	                <td><br><br><input type="submit" class="btn-primary pull" value="댓글 작성"></td>
	            </tr>
	        </table>
	    </form>
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
	<script type="text/javascript">
		function nwindow(bbsID,commentID){
			window.name = "commentParant";
			var url= "commentUpdate.jsp?bbsID="+bbsID+"&commentID="+commentID;
			window.open(url,"","width=600,height=230,left=300");
		}
	</script>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>