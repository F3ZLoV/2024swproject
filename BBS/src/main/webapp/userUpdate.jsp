<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
    <title>S/W 프로젝트</title>
    <%
        String userID = (String) session.getAttribute("userID");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUser(userID);
	%>
    <script>
        function validateForm() {
            var newPassword = document.getElementsByName("newPassword")[0].value;
            var confirmPassword = document.getElementsByName("confirmPassword")[0].value;
            if (newPassword !== confirmPassword) {
                alert("수정할 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                return false;
            }
            return true;
        }
        function confirmDelete() {
        	var currentPassword = document.getElementsByName("currentPassword")[0].value;
        	var dbPassword = "<%= user.getUserPassword()%>";
            if (currentPassword !== dbPassword) {
                alert("탈퇴하시려면 기존 비밀번호란에 비밀번호를 제대로 입력해주세요");
                return false;
            } else {
            	if (confirm("정말 탈퇴하시겠습니까?")) {
            		return true;
            	} else {
            		alert("탈퇴가 취소되었습니다.");
            		return false;
            	}
            }
            return true;
        }
    </script>
</head>
<body>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">S/W 프로젝트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">Home</a></li>
                <li><a href="bbs.jsp">General</a></li>
                <li><a href="bbs_review.jsp">Review</a></li>
                <li><a href="bbs_gallery.jsp">Gallery</a></li>
                <li><a href="bbs_music.jsp">Musics</a></li>
                <li><a href="bbs_market.jsp">Market</a></li>
            </ul>
            <%
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				 <a href="#" class=dropdown-toggle
				 	data-toggle="dropdown" role="botton" aria-haspopup="true"
				 	aria-expanded="false">접속하기<span class="caret"></span></a>
				 <ul class="dropdown-menu">
				 	<li><a href="login.jsp">로그인</a></li>
				 	<li><a href="join.jsp">회원가입</a></li>
				 </ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				 <a href="#" class=dropdown-toggle
				 	data-toggle="dropdown" role="botton" aria-haspopup="true"
				 	aria-expanded="false">회원관리<span class="caret"></span></a>
				 <ul class="dropdown-menu">
				 	<li><a href="logoutAction.jsp">로그아웃</a></li>
				 	<li><a href="userUpdate.jsp">회원수정</a></li>
				 </ul>
				</li>
			</ul>
			<%
				}
			%>
        </div>
    </nav>
    <div class="container">
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <div class="jumbotron" style="padding-top: 20px;">
                <form method="post" action="userUpdateAction.jsp" onsubmit="return validateForm();">
                    <h3 style="text-align: center;">회원 수정 화면</h3>
                    <div class="form-group">
                    	<label>아이디 <span style="color: red;">*</span></label>
                        <input type="text" class="form-control" placeholder="아이디" name="userID" value="<%= userID %>" readonly>
                    </div>
                    <div class="form-group">
                    	<label>기존 비밀번호 <span style="color: red;">*</span></label>
                        <input type="password" class="form-control" placeholder="기존 비밀번호" name="currentPassword" maxlength="20">
                    </div>
                    <div class="form-group">
                    	<label>수정할 비밀번호</label>
                        <input type="password" class="form-control" placeholder="수정할 비밀번호 (선택사항)" name="newPassword" maxlength="20">
                    </div>
                    <div class="form-group">
                    	<label>수정할 비밀번호 확인</label>
	                    <input type="password" class="form-control" placeholder="수정 비밀번호 확인 (선택사항)" name="confirmPassword" maxlength="20">
	                </div>
	                <% 
                    	String userName = user.getUserName();
                    %>
                    <div class="form-group">
                    	<label>이름 <span style="color: red;">*</span></label>
                        <input type="text" class="form-control" placeholder="이름" name="userName" value="<%=userName %>" maxlength="20">
                    </div>
                    <% String userGender = user.getUserGender(); %>
					<div class="form-group" style="text-align: center;">
					    <div class="btn-group" data-toggle="buttons">
					        <label class="btn btn-primary <%= userGender.equals("남자") ? "active" : "" %>">
					            <input type="radio" name="userGender" autocomplete="off" value="남자" <%= userGender.equals("남자") ? "checked" : "" %>>남자
					        </label>
					        <label class="btn btn-primary <%= userGender.equals("여자") ? "active" : "" %>">
					            <input type="radio" name="userGender" autocomplete="off" value="여자" <%= userGender.equals("여자") ? "checked" : "" %>>여자
					        </label>
					    </div>
					</div>
                    <% 
                    	String userEmail = user.getUserEmail();
                    %>
                    <div class="form-group">
                    	<label>이메일 <span style="color: red;">*</span></label>
                        <input type="email" class="form-control" placeholder="이메일" value="<%=userEmail %>" name="userEmail" maxlength="50">
                    </div>
                    <input type="submit" class="btn btn-primary form-control" value="수정">
                </form>
                <form method="post" action="userDeleteAction.jsp" style="margin-top: 10px;" onsubmit="return confirmDelete()">
                    <input type="submit" class="btn btn-danger form-control" value="회원 탈퇴">
                </form>
            </div>
        </div>
        <div class="col-lg-4"></div>
    </div>
    <!-- FOOTER -->
    <footer style="background-color: #000000; color: #ffffff">
        <div class="container">
            <br>
            <div class="row">
                <div class="col-sm-2" style="text-align: center">
                    <h5>Copyright&copy; F3ZLoV All rights reserved.</h5>
                    <h5>박태준(Taejoon Park)</h5>
                </div>
                <div class="col-sm-4">
                    <h4>개발자 소개</h4>
                    <p>저는 박태준입니다. 인하공업전문대학교에서 공부를 하고 있습니다.</p>
                </div>
                <div class="col-sm-2">
                    <h4 style="text-align: center;">Navigation</h4>
                    <div class="list-group">
                        <a href="#" class="list-group-item">소개</a>
                        <a href="#" class="list-group-item">이용약관</a>
                        <a href="#" class="list-group-item">개인정보처리방침</a>
                    </div>
                </div>
                <div class="col-sm-2">
                    <h4 style="text-align: center;">Contact</h4>
                    <div class="list-group">
                        <a href="#" class="list-group-item">010-0000-0000</a>
                        <a href="#" class="list-group-item">fsirtru@gmail.com</a>
                        <a href="#" class="list-group-item">github.com/F3ZLoV</a>
                    </div>
                </div>
                <div class="col-sm-2">
                    <h4 style="text-align: center;">
                        <span class="glyphicon glyphicon-ok"></span>&nbsp;by 박태준
                    </h4>
                </div>
            </div>
        </div>
    </footer>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
