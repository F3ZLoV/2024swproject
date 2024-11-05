<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.File" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentText" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>S/W 프로젝트</title>
</head>
<body>
<%
	 	String userID = null;
	 	if(session.getAttribute("userID") != null){
	 		userID = (String) session.getAttribute("userID");
	 	}
	 	
		String commentText = request.getParameter("commentText");
		comment.setCommentText(commentText);
		
	 	if(userID == null){
	 		PrintWriter script = response.getWriter();
	 		script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
	 		script.println("location.href = 'login.jsp'");
	 		script.println("</script>");
	 	} 
	 	else{
		 	int bbsID = 0; 
		 	if (request.getParameter("bbsID") != null){
		 		bbsID = Integer.parseInt(request.getParameter("bbsID"));
		 	}
		 	
		 	Integer parentCommentID = null;
		 	if (request.getParameter("parentCommentID") != null) {
		 		parentCommentID = Integer.parseInt(request.getParameter("parentCommentID"));
		 	}
		 	
		 	if (bbsID == 0){
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('유효하지 않은 글입니다.')");
		 		script.println("location.href = 'login.jsp'");
		 		script.println("</script>");
		 	}
	 		if (commentText == null || commentText.trim().isEmpty()){
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('입력이 안된 사항이 있습니다.')");
		 		script.println("history.back()");
		 		script.println("</script>");
		 	} else {
		 		CommentDAO commentDAO = new CommentDAO();
		 		int commentID = commentDAO.write(bbsID, userID, commentText, parentCommentID);
		 		if (commentID == -1){
			 		PrintWriter script = response.getWriter();
			 		script.println("<script>");
			 		script.println("alert('댓글 쓰기에 실패했습니다.')");
			 		script.println("history.back()");
			 		script.println("</script>");
			 	}
		 		else{
			 		PrintWriter script = response.getWriter();
			 		script.println("<script>");
			 		script.println("location.href=document.referrer;");
			 		script.println("</script>");
			 	}
		 	}
		 }
	 %>
</body>
</html>