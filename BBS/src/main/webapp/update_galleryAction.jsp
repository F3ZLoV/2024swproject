<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="bbs_gallery.Bbs_gallery" %>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");
%>
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
			int bbsID = 0;
			if (request.getParameter("bbsID") != null) {
				bbsID = Integer.parseInt(request.getParameter("bbsID"));
			}
			if (bbsID == 0) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'bbs_gallery.jsp';");
				script.println("</script>");
			}
			String realFolder = "C:/Users/F3ZLoV/git/2024swproject/BBS/src/main/webapp/images";
	        int maxSize = 5 * 1024 * 1024;  // 5MB
	        String encType = "UTF-8";

	        MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

	        String bbsTitle = multi.getParameter("bbsTitle");
	        String bbsContent = multi.getParameter("bbsContent");
	        String fileName = multi.getFilesystemName("imageFile");
	        
			Bbs_gallery bbs = new Bbs_galleryDAO().getBbs(bbsID);
			
			String oldFilePath = realFolder + bbs.getImagePath();
			
			if(!userID.equals(bbs.getUserID())) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'bbs_gallery.jsp';");
				script.println("</script>");
			} else {
				if(bbsTitle == null || bbsContent == null || fileName == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.');");
				script.println("history.back()");
				script.println("</script>");
				} else {
					File oldFile = new File(oldFilePath);
					if(oldFile.exists()) {
						oldFile.delete();
					}
					
					Bbs_galleryDAO bbsDAO = new Bbs_galleryDAO();
					int result = bbsDAO.update(bbsID, bbsTitle, bbsContent, "/images/" + fileName);
					if(result == -1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 수정에 실패했습니다.');");
						script.println("history.back()");
						script.println("</script>");
					} else {
						PrintWriter script = response.getWriter();
						
						script.println("<script>");
						script.println("location.href = 'bbs_gallery.jsp'");
						script.println("</script>");
					}
				}
			}
		}
		
		
	%>
</body>
</html>