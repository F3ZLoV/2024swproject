<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <link rel="stylesheet" href="css/bootstrap.css">
</head>
<body>
    <!-- General 게시판과 동일한 navbar -->
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
            </div>
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">Home</a></li>
                <li><a href="bbs.jsp">General</a></li>
                <li class="active"><a href="bbs_review.jsp">Review</a></li>
                <li><a href="bbs_galary.jsp">Gallery</a></li>
                <li><a href="bbs_music.jsp">Musics</a></li>
                <li><a href="bbs_marketplace.jsp">Market</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="login.jsp"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2>리뷰 작성</h2>
        <form action="write_review_action.jsp" method="post">
            <div class="form-group">
                <label for="bbsTitle">제목</label>
                <input type="text" class="form-control" name="bbsTitle" id="bbsTitle" required>
            </div>
            <div class="form-group">
                <label for="bbsContent">내용</label>
                <textarea class="form-control" name="bbsContent" id="bbsContent" rows="10" required></textarea>
            </div>
            <button type="submit" class="btn btn-success">작성</button>
        </form>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
