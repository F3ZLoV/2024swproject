<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>S/W 프로젝트</title>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
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
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				 <a href="#" class=dropdown-toggle
				 	data-toggle="dropdown" role="botton" aria-haspopup="true"
				 	aria-expanded="false">접속하기<span class="caret"></span></a>
				 <ul class="dropdown-menu">
				 	<li class="active"><a href="login.jsp">로그인</a></li>
				 	<li><a href="join.jsp">회원가입</a></li>
				 </ul>
				</li>
			</ul>
		</div>
	</nav>
	<script>
    function validatePassword() {
        var password = document.getElementsByName("userPassword")[0].value;
        var confirmPassword = document.getElementsByName("confirmPassword")[0].value;
        if (password != confirmPassword) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        return true;
    }
	</script>
	<div class="container">
	    <div class="col-lg-4"></div>
	    <div class="col-lg-4">
	        <div class="jumbotron" style="padding-top: 20px;">
	            <form method="post" action="joinAction.jsp" onsubmit="return validatePassword();">
	                <h3 style="text-align: center;">회원가입 화면</h3>
	                <div class="form-group">
	                    <input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
	                </div>
	                <div class="form-group">
	                    <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
	                </div>
	                <div class="form-group">
	                    <input type="password" class="form-control" placeholder="비밀번호 확인" name="confirmPassword" maxlength="20">
	                </div>
	                <div class="form-group">
	                    <input type="text" class="form-control" placeholder="이름" name="userName" maxlength="20">
	                </div>
	                <div class="form-group" style="text-align: center;">
	                    <div class="btn-group" data-toggle="buttons">
	                        <label class="btn btn-primary active">
	                            <input type="radio" name="userGender" autocomplete="off" value="남자" checked>남자
	                        </label>
	                        <label class="btn btn-primary">
	                            <input type="radio" name="userGender" autocomplete="off" value="여자">여자
	                        </label>
	                    </div>
	                </div>
	                <div class="form-group">
	                    <input type="email" class="form-control" placeholder="이메일" name="userEmail" maxlength="50">
	                </div>
	                <input type="submit" class="btn btn-primary form-control" value="회원가입">
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
				<div class="col-sm-2" style="text-align: center"><h5>Copyright&copy; F3ZLoV All rights reserved.</h5><h5>박태준(Taejoon Park)</h5></div>
				<div class="col-sm-4"><h4>개발자 소개</h4><p>저는 박태준입니다. 인하공업전문대학교에서 공부를 하고 있습니다.</p></div>
				<div class="col-sm-2"><h4 style="text-align: center;">Navigation</h4>
					<div class="list-group">
						<a href="#" class="list-group-item">소개</a>
						<a href="#" class="list-group-item">이용약관</a>
						<a href="#" class="list-group-item">개인정보처리방침</a>
					</div>
				</div>
				<div class="col-sm-2"><h4 style="text-align: center;">Contact</h4>
					<div class="list-group">
						<a href="#" class="list-group-item">010-0000-0000</a>
						<a href="#" class="list-group-item">fsirtru@gmail.com</a>
						<a href="#" class="list-group-item">github.com/F3ZLoV</a>
					</div>
				</div>
				<div class="col-sm-2"><h4 style="text-align: center;"><span class="glyphicon glyphicon-ok"></span>&nbsp;by 박태준</h4></div>
			</div>
		</div>
	</footer>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>