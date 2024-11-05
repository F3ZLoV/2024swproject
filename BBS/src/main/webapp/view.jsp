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
</head>
<body>
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
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>조회수</td>
						<td colspan="2"><%=bbs.getBbsCount() + 1 %></td>
					</tr>
					<tr>
						<td>추천수</td>
						<td colspan="2">+<%=bbs.getLikeCount() %></td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<a onclick="return confirm('추천하시겠습니까?')" href="likeAction.jsp?bbsID=<%=bbsID %>"
				 class="btn btn-success pull-right">👍</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())) {
			%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
		</div>
	</div>
	<div class="container">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
            <tbody>
            <tr>
                <td align="left" bgcolor="beige">댓글</td>
            </tr>
            <c:forEach var="comment" items="${commentList}">
                <!-- 댓글이 상위 댓글인지 확인 -->
                <div class="container" style="margin-left: ${comment.parentCommentID != null ? '200px' : '0'};">
                    <div class="row">
                        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                            <tbody>
                            <tr>
                                <td align="left">
                                    ${comment.userID}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    ${comment.commentDate.substring(0,10)} ${comment.commentDate.substring(11,13)}시${comment.commentDate.substring(14,16)}분
                                </td>
                                <td align="right">
                                    <!-- 댓글 작성자만 수정/삭제 가능 -->
                                    <c:if test="${comment.userID != null && comment.userID == userID}">
                                        <form name="p_search">
                                            <a type="button" onclick="nwindow(${bbsID},${comment.commentID})" class="btn-primary">수정</a>
                                        </form>
                                        <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="commentDeleteAction.jsp?bbsID=${bbsID}&commentID=${comment.commentID}" class="btn-primary">삭제</a>
                                    </c:if>
                                    <a href="#" onclick="showReplyForm(${comment.commentID})" class="btn-primary">답글</a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5" align="left">${comment.commentText}</td>
                            </tr>
                            <!-- 답글 입력 폼 -->
                            <tr id="replyForm_${comment.commentID}" style="display:none;">
                                <td colspan="5">
                                    <form method="post" action="commentAction.jsp?bbsID=<%= bbsID%>">
                                        <input type="hidden" name="parentCommentID" value="${comment.commentID}">
                                        <textarea name="commentText" class="form-control" placeholder="답글을 작성해주세요."></textarea>
                                        <input type="submit" class="btn-primary pull" value="답글 작성">
                                    </form>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:forEach>
            </tr>
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
	<script>
		function showReplyForm(commentID) {
	    var replyForm = document.getElementById("replyForm_" + commentID);
	    if (replyForm.style.display === "none") {
	        replyForm.style.display = "block";
	    } else {
	        replyForm.style.display = "none";
	    }
	}
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