<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/customerLoginSessionCheck.jsp" %>

<%
	// 요청 값 
	String customerId = request.getParameter("customerId");
	String errMsg = request.getParameter("errMsg");
	
	// null값 넘어올 시 공백으로 바꾸기
	if(customerId == null) {
		customerId = "";
	}
	// 요청 값 디버깅
	System.out.println("insertCustomerForm - customerId = " + customerId);
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
	<!-- 메인 메뉴 -->
	<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col">
		<div class="w3-border w3-round" style="margin-top: 20px;">
		
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>회원 가입</h1>
			</div>	
			
			<div class="w3-card-4">
			
				<!-- 고객 아이디 중복 체크 -->
				<div>
					<form class="w3-container" action="/shop/customer/signup/checkIdAction.jsp" method="post">
						<label>id 중복 확인</label>
						<div class="input-group mb-3">
							<input class="form-control" type="text" name="checkIdFirst" style="width: 45%;">
							<input class="form-control" type="text" value="@" readonly="readonly" name="checkIdMiddle" style="width: 5%;">
							<select class="form-control" style="width: 45%;" id="email" name="checkIdLast">
								<option value="">email을 선택해주세요</option>
								<option value="naver.com">naver.com</option>
								<option value="google.com">google.com</option>
								<option value="daum.net">daum.net</option>
								<option value="nate.com">nate.com</option>
							</select>
						</div>
						
						<button class="btn btn-outline-secondary" type="submit">중복확인</button>
						<!-- 에러 메시지 출력 -->
						<%
							if(errMsg != null) { 
						%>
								<span><%=errMsg %></span>
						<%
							}
						%>
					</form>
					
				</div>
				
				<!-- 회원가입 폼 -->
				<div>
					<form class="w3-container" action="/shop/customer/signup/insertCustomerAction.jsp" method="post">
						<div>
							<div>
								<label>id</label>
								<input class="w3-input" type="text" value="<%=customerId %>" name="customerId" required="required" readonly="readonly">
							</div>
							
							<label>pw</label>
							<input class="w3-input" type="password" name="customerPw" required="required">
							
							<label>이름</label>
							<input class="w3-input" type="text" name="customerName" required="required">
							
							<label>생년월일</label>
							<input class="w3-input" type="date" name="customerBirth" required="required">
							
							<label>성별</label>
							<p>
							<input class="w3-radio" type="radio" name="customerGender" value="남" required="required">
							<label>남</label>
							<input class="w3-radio" type="radio" name="customerGender" value="여" required="required">
							<label>여</label>
						</div>
						
						<div style="text-align: center; margin: 10px auto;">
							<button class="btn btn-outline-secondary" type="submit" style="width: 60%;">회원가입</button>
						</div>
						
					</form>
				</div>

			</div>
			
		</div>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>