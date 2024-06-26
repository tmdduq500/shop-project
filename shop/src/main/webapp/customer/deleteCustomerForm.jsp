<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
	// 로그인 돼있는 고객의 id
	String customerId = (String)loginCustomerMember.get("customerId");
%>
<%
	// msg 출력
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원 탈퇴</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<div style="text-align: center;">
			<%
				if(msg != null) {
			%>
					<%=msg %>
			<%
				}
			%>
		</div>
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey" style="padding: 10px;">
				<h1>회원 탈퇴</h1>
			</div>	
			
			<div class="w3-card-4" style="padding: 5%;">
				<form class="w3-container" action="/shop/customer/deleteCustomerAction.jsp" method="post">
					<div>
						회원을 정말 탈퇴하시려면 ID와 PW를 입력해주세요:(
					</div>
					
					<div style="margin-top: 20px;">
						<label>ID</label>
						<input class="w3-input" type="text" name="customerId" value="<%=customerId %>" readonly="readonly">
					</div>
					
					<div>
						<label>PW</label>
						<input class="w3-input" type="password" name="customerPw" required="required">
					</div>
							
					<div style="text-align: center; margin: 10px auto;">
						<button class="btn btn-outline-secondary" type="submit">회원 탈퇴</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>