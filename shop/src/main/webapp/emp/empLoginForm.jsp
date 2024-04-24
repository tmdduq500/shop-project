<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/loginSessionCheck.jsp"%>
<%
	// 요청 값(에러 메시지 출력을 위한)
	String errMsg = request.getParameter("errMsg");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>emp 로그인</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
	
<div class="row">
	<div class="col"></div>
	
	<div class="col-2 w3-container w3-half w3-margin-top" style="height: 90vh; width: 25%;">
		<form class="w3-container w3-card-4 w3-border w3-round-large" action="/shop/emp/empLoginAction.jsp" method="post" style="margin: 50% auto; height: 330px;">
		
			<div style="margin-top: 30px; text-align: center;">
				<h1>관리자 로그인</h1>
			</div>
			
			<div class="form-floating mb-3 mt-3" style="margin-top: 30px;">
				<input class="form-control" type="text" name="empId" id="id" placeholder="">
				<label for="id">id</label>
			</div>
			

			<div class="form-floating mb-3 mt-3" style="margin-top: 30px;">
				<input class="form-control" type="password" name="empPw" id="pw" placeholder="">
				 <label for="pw">pw</label>
			</div>
			
			<div style="margin-top: 20px;">
				<button class="w3-button w3-section w3-dark-grey w3-ripple" type="submit" style="width: 100%;">
					로그인
				</button>
			</div>
			
			
		</form>
	</div>
	
	<div class="col"></div>
</div>

</body>
</html>