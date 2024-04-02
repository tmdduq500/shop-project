<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") != null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empLoginForm</title>
</head>
<body>
	<form action="/shop/emp/empLoginAction.jsp">
		<div>
		id: <input type="text" name="empId">
		</div>
		
		<div>
			pw: <input type="password" name="empPw">
		</div>
		<button type="submit">로그인</button>
	</form>
</body>
</html>