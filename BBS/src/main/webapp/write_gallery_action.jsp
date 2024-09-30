<%@page import="javax.servlet.annotation.WebServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.MultipartConfig" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

<% 
    request.setCharacterEncoding("UTF-8"); 
%>

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
	 	if(session.getAttribute("userID") != null){
	 		userID = (String) session.getAttribute("userID");
	 	}
		String realFolder="";
		String saveFolder = "C:\\Users\\F3ZLoV\\git\\2024swproject\\BBS\\src\\main\\webapp\\images";
		String encType = "utf-8";
		String map="";
		int maxSize=5*1024*1024;
		
		ServletContext context = this.getServletContext();
		realFolder = context.getRealPath(saveFolder);
		
		MultipartRequest multi = null;
		
		//파일업로드를 직접적으로 담당	
		multi = new MultipartRequest(request,saveFolder,maxSize,encType,new DefaultFileRenamePolicy());		
		//form으로 전달받은 3가지를 가져온다
		String fileName = multi.getFilesystemName("fileName");
		String bbsTitle = multi.getParameter("bbsTitle");
		String bbsContent = multi.getParameter("bbsContent");
		bbs_gallery.setBbsTitle(bbsTitle);
		bbs_gallery.setBbsContent(bbsContent);

	 	if(userID == null){
	 		PrintWriter script = response.getWriter();
	 		script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
	 		script.println("location.href = 'login.jsp'");
	 		script.println("</script>");
	 	} else {
	 		if (bbs_gallery.getBbsTitle().equals("") || bbs_gallery.getBbsContent().equals("")){
	 			PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('입력이 안된 사항이 있습니다.')");
		 		script.println("history.back()");
		 		script.println("</script>");
		 	} else {
		 		Bbs_galleryDAO BbsDAO = new Bbs_galleryDAO();
		 		int bbsID = BbsDAO.write(bbs_gallery.getBbsTitle(), userID, bbs_gallery.getBbsContent());
		 		if (bbsID == -1){
			 		PrintWriter script = response.getWriter();
			 		script.println("<script>");
			 		script.println("alert('글쓰기에 실패했습니다.')");
			 		script.println("history.back()");
			 		script.println("</script>");
			 	}
			 	else{
			 		PrintWriter script = response.getWriter();
					if(fileName != null){
						File oldFile = new File(saveFolder+"\\"+fileName);
						File newFile = new File(saveFolder+"\\"+(bbsID-1)+"사진.jpg");
						oldFile.renameTo(newFile);
					}
			 		script.println("<script>");
					script.println("location.href='bbs_gallery.jsp'");
			 		script.println("</script>");
			 	}
		 	}
	 	}
	 %>

</body>
</html>