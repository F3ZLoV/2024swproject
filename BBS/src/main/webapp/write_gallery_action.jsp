<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs_gallery" class="bbs_gallery.Bbs_gallery" scope="page" />
<jsp:setProperty name="bbs_gallery" property="bbsTitle"/>
<jsp:setProperty name="bbs_gallery" property="bbsContent"/>
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
			if(bbs_gallery.getBbsTitle() == null || bbs_gallery.getBbsContent() == null) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('입력이 안 된 사항이 있습니다.');");
					script.println("history.back()");
					script.println("</script>");
				} else {
					Bbs_galleryDAO bbsDAO = new Bbs_galleryDAO();
					int result = bbsDAO.write(bbs_gallery.getBbsTitle(), userID, bbs_gallery.getBbsContent());
					if(result == -1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글쓰기에 실패했습니다.');");
						script.println("history.back()");
						script.println("</script>");
					} else {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href = 'bbs_review.jsp'");
						script.println("</script>");
					}
				}
		}
		
	%>
</body>
</html>