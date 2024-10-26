<%@page import="bbs_gallery.Bbs_gallery"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<jsp:useBean id="bbs_gallery" class="bbs_gallery.Bbs_gallery" scope="page" />
<%
    // 로그인 체크
    String userID = null;
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if(userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.');");
        script.println("location.href = 'login.jsp';");
        script.println("</script>");
    } else {
        request.setCharacterEncoding("UTF-8");
        String realFolder = "C:/Users/F3ZLoV/git/2024swproject/BBS/src/main/webapp/images";
        int maxSize = 5 * 1024 * 1024;  // 5MB
        String encType = "UTF-8";

        MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

        String bbsTitle = multi.getParameter("bbsTitle");
        String bbsContent = multi.getParameter("bbsContent");
        String fileName = multi.getFilesystemName("imageFile");

        if (bbsTitle == null || bbsContent == null || fileName == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력되지 않은 사항이 있습니다.');");
            script.println("history.back();");
            script.println("</script>");
        } else {
            Bbs_galleryDAO bbsDAO = new Bbs_galleryDAO();
            int result = bbsDAO.write(bbsTitle, userID, bbsContent, "/images/" + fileName, bbs_gallery.getBbsCount(), bbs_gallery.getLikeCount());
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글쓰기에 실패했습니다.');");
                script.println("history.back();");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href='bbs_gallery.jsp';");
                script.println("</script>");
            }
        }
    }
%>