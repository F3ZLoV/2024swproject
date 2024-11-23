<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="bbs_gallery.Bbs_galleryDAO" %>

<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        response.setContentType("text/html; charset=UTF-8");
        out.println("<script>alert('로그인 후 이용하세요.'); location.href='login.jsp';</script>");
        return;
    }

    String uploadPath = getServletContext().getRealPath("/images");
    File uploadDir = new File(uploadPath);

    if (!uploadDir.exists()) {
        uploadDir.mkdirs(); // 업로드 디렉토리 생성
    }

    List<String> uploadedFiles = new ArrayList<>();
    String bbsTitle = null;
    String bbsContent = null;

    try {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        factory.setSizeThreshold(5 * 1024 * 1024); // 메모리 임계값 5MB

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(10 * 1024 * 1024); // 파일 당 최대 크기 10MB
        upload.setSizeMax(50 * 1024 * 1024); // 전체 요청 최대 크기 50MB

        List<FileItem> formItems = upload.parseRequest(request);

        if (formItems != null && !formItems.isEmpty()) {
            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    // 일반 폼 필드 처리
                    if ("bbsTitle".equals(item.getFieldName())) {
                        bbsTitle = item.getString("UTF-8");
                    } else if ("bbsContent".equals(item.getFieldName())) {
                        bbsContent = item.getString("UTF-8");
                    }
                } else {
                    // 파일 필드 처리
                    String fileName = new File(item.getName()).getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);

                        // 파일 저장
                        item.write(storeFile);

                        // 이미지 파일 MIME 타입 검증
                        String mimeType = getServletContext().getMimeType(filePath);
                        if (mimeType == null || !mimeType.startsWith("image")) {
                            storeFile.delete(); // 이미지가 아니면 삭제
                        } else {
                            uploadedFiles.add("/images/" + fileName);
                        }
                    }
                }
            }
        }

        // 유효성 검사 실패 처리
        if (bbsTitle == null || bbsContent == null || uploadedFiles.isEmpty()) {
            out.println("<script>alert('입력된 내용이 없거나 이미지 파일만 업로드 가능합니다.'); history.back();</script>");
            return;
        }

        // DB 저장
        Bbs_galleryDAO bbsDAO = new Bbs_galleryDAO();
        String filesPath = String.join(",", uploadedFiles); // 쉼표로 구분된 문자열 생성
        int result = bbsDAO.write(bbsTitle, userID, bbsContent, filesPath, 0, 0);

        if (result == -1) {
            out.println("<script>alert('글쓰기에 실패했습니다.'); history.back();</script>");
        } else {
            response.sendRedirect("bbs_gallery.jsp");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        out.println("<script>alert('파일 업로드 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
