<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userGender"/>
<jsp:setProperty name="user" property="userEmail"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>S/W 프로젝트</title>
</head>
</head>
<body>
<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인이 필요합니다.');");
        script.println("location.href = 'login.jsp';");
        script.println("</script>");
    } else {
    	String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String userName = request.getParameter("userName");
        String userGender = request.getParameter("userGender");
        String userEmail = request.getParameter("userEmail");

        if (currentPassword == null || userName == null || userGender == null || userEmail == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력이 안 된 사항이 있습니다.');");
            script.println("history.back();");
            script.println("</script>");
        } else {
            UserDAO userDAO = new UserDAO();
            int result = userDAO.update(userID, currentPassword, newPassword, userName, userGender, userEmail);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('회원 정보 수정에 실패했습니다.');");
                script.println("history.back();");
                script.println("</script>");
            } else if (result == -2) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('기존 비밀번호를 정확히 입력해주세요.');");
                script.println("history.back();");
                script.println("</script>");
            }else {
                session.setAttribute("userID", userID);
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('회원 정보가 수정되었습니다.');");
                script.println("location.href = 'main.jsp';");
                script.println("</script>");
            }
        }
    }
%>
</body>
</html>
</html>