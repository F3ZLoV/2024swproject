<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs_music.Bbs_musicDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bbs_music" class="bbs_music.Bbs_music" scope="page" />
<jsp:setProperty name="bbs_music" property="bbsTitle"/>
<jsp:setProperty name="bbs_music" property="bbsContent"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>S/W 프로젝트</title>
</head>
<body>
	<%
	String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp';");
			script.println("</script>");
		} else {
			if(bbs_music.getBbsTitle() == null || bbs_music.getBbsContent() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.');");
			script.println("history.back()");
			script.println("</script>");
		} else {
			Bbs_musicDAO bbsDAO = new Bbs_musicDAO();
			int result = bbsDAO.write(bbs_music.getBbsTitle(), userID, bbs_music.getBbsContent());
			if(result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다.');");
				script.println("history.back()");
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'bbs_music.jsp'");
				script.println("</script>");
			}
		}
		}
	%>
</body>
</html>