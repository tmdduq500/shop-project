<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/loginSessionCheck.jsp"></jsp:include>

<%
	/* 에러 메시지 */
	String errMsg = request.getParameter("errMsg");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empLoginForm</title>
</head>
<body>
	<!-- 에러 메시지 출력 -->
	<%
		if(errMsg != null) {
	%>
			<div>
				<%=errMsg %>
			</div>
	<% 
		}
	%>
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