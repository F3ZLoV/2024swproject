<%@page import="java.util.List"%>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.MultipartConfig" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 파일 저장 경로 설정
    String savePath = "C:/Users/F3ZLoV/git/2024swproject/BBS/src/main/webapp/images";
    int maxSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB

    // multipart/form-data 체크
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    if (isMultipart) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(maxSize); // 파일 크기 제한 설정

        try {
            // 요청에서 파일 아이템 리스트 추출
            List<FileItem> items = upload.parseRequest(request);

            String fileName = null;  // 업로드된 파일 이름
            String filePath = null;  // 서버에 저장된 파일 경로
            String bbsTitle = null;  // 게시글 제목
            String bbsContent = null;  // 게시글 내용
            int bbsID = 0;  // 게시글 ID

            // 폼 데이터 처리
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // 일반 폼 필드 처리 (bbsTitle, bbsContent 등)
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");

                    if (fieldName.equals("bbsID")) {
                        bbsID = Integer.parseInt(fieldValue);
                    } else if (fieldName.equals("bbsTitle")) {
                        bbsTitle = fieldValue;
                    } else if (fieldName.equals("bbsContent")) {
                        bbsContent = fieldValue;
                    }

                } else {
                    // 파일 필드 처리
                    fileName = new File(item.getName()).getName();
                    filePath = savePath + File.separator + fileName;

                    // 파일을 지정된 경로에 저장
                    File uploadedFile = new File(filePath);
                    item.write(uploadedFile);
                }
            }

            // 파일 경로를 DB에 저장
            String imagePath = "images/" + fileName;  // 웹 경로
            Bbs_galleryDAO bbsDAO = new Bbs_galleryDAO();
            int result = bbsDAO.update(bbsID, bbsTitle, bbsContent, imagePath);

            if (result > 0) {
                out.println("<script>alert('이미지 업로드 및 게시글 업데이트 성공'); location.href='view_gallery.jsp?bbsID=" + bbsID + "';</script>");
            } else {
                out.println("<script>alert('DB 업데이트 실패'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('파일 업로드 실패'); history.back();</script>");
        }

    } else {
        out.println("<script>alert('multipart/form-data 형식이 아닙니다.'); history.back();</script>");
    }
%>