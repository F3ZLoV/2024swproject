<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
    request.setCharacterEncoding("UTF-8");

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
        UserDAO userDAO = new UserDAO();
        int result = userDAO.delete(userID);
        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('회원 탈퇴에 실패했습니다.');");
            script.println("history.back();");
            script.println("</script>");
        } else {
            session.invalidate(); // 세션 무효화
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('회원 탈퇴가 완료되었습니다.');");
            script.println("location.href = 'main.jsp';");
            script.println("</script>");
        }
    }
%>
