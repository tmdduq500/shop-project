<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file ="/customer/inc/customerLoginSessionCheck.jsp" %>
<%
	// 에러 메세지 요청값
	String errMsg = request.getParameter("errMsg");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>로그인</title>
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
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col-2 w3-container w3-half w3-margin-top" style="height: 90vh; width: 25%;">
		<form class="w3-container w3-card-4 w3-border w3-round-large" action="/shop/customer/customerLoginAction.jsp" method="post" style="margin: 50% auto; height: 330px;">
		
			<div class="row" style="margin-top: 30px; text-align: center;">
				<div class="col"></div>
				<div class="col">
					<h1>로그인</h1>
				</div>
				<div class="col">
					<a href="/shop/emp/empLoginForm.jsp" style="text-decoration: none; color: gray;">관리자용</a>
				</div>
			</div>
			
			<div class="form-floating mb-3 mt-3" style="margin-top: 30px;">
				<input class="form-control" type="text" name="customerId" id="id" placeholder="">
				<label for="id">id</label>
			</div>
			

			<div class="form-floating mb-3 mt-3" style="margin-top: 30px;">
				<input class="form-control" type="password" name="customerPw" id="pw" placeholder="">
				 <label for="pw">pw</label>
			</div>
			
			<div class="row" style="margin-top: 20px;">
				<div class="col" style="display: flex; align-items: center;">
					<button class="btn btn-outline-secondary" type="submit" style="width: 100%; vertical-align: middle;">
						로그인
					</button>
				</div>
				<div class="col">
					<a class="a-to-button" href="/shop/customer/signup/insertCustomerForm.jsp" style="width: 100%;">회원가입</a>
				</div>
				
			</div>
			
			
		</form>
	</div>
	
	<div class="col"></div>
</div>

</body>
</html>