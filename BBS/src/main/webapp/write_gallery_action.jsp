<%@page import="javax.servlet.annotation.WebServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.MultipartConfig" %>

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
    request.setCharacterEncoding("UTF-8");

    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    // 로그인 확인
    if (userID == null) {
        out.println("<script>");
        out.println("alert('로그인이 필요합니다.');");
        out.println("location.href = 'login.jsp';");
        out.println("</script>");
        return;
    }

    // 파일 저장 경로 설정 (실제 서버의 webapp/images 폴더)
    String savePath = application.getRealPath("/images");  // webapp/images 경로
    File fileSaveDir = new File(savePath);
    if (!fileSaveDir.exists()) {
        fileSaveDir.mkdir();  // 디렉토리가 없으면 생성
    }

    // Apache Commons FileUpload를 이용한 파일 업로드 처리
    if (ServletFileUpload.isMultipartContent(request)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(1024 * 1024 * 10);  // 최대 10MB 파일 사이즈 제한

        String title = null;
        String content = null;
        String imagePath = null;

        try {
            List<FileItem> formItems = upload.parseRequest(request);
            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (!item.isFormField()) {
                        // 파일 필드 처리
                        String fileName = System.currentTimeMillis() + "_" + new File(item.getName()).getName();
                        String filePath = savePath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile);  // 파일을 서버에 저장
                        imagePath = "images/" + fileName;  // 웹 경로 설정
                    } else {
                        // 일반 필드 처리
                        String fieldName = item.getFieldName();
                        if (fieldName.equals("bbsTitle")) {
                            title = item.getString("UTF-8");  // 제목
                        } else if (fieldName.equals("bbsContent")) {
                            content = item.getString("UTF-8");  // 내용
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            out.println("<script>");
            out.println("alert('파일 업로드 중 오류가 발생했습니다.');");
            out.println("history.back();");
            out.println("</script>");
            return;
        }

        // 필수 입력 항목 확인
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            out.println("<script>");
            out.println("alert('제목 또는 내용을 입력해주세요.');");
            out.println("history.back();");
            out.println("</script>");
            return;
        }

        // 데이터베이스에 저장
        Bbs_galleryDAO dao = new Bbs_galleryDAO();
        int result = dao.write(title, userID, content, imagePath);

        if (result == -1) {
            out.println("<script>");
            out.println("alert('글 작성에 실패했습니다. 다시 시도해주세요.');");
            out.println("history.back();");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("location.href = 'bbs_gallery.jsp';");
            out.println("</script>");
        }
    } else {
        out.println("<script>");
        out.println("alert('올바른 양식이 아닙니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>

</body>
</html>
