<%-- <%@page import="java.util.HashMap"%> --%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
%>
<%
	// msg 출력
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col-2 w3-container w3-half w3-margin-top" style="height: 90vh; width: 25%;">
		<div style="text-align: center;">
			<%
				if(msg != null) {
			%>
					<%=msg %>
			<%
				}
			%>
		</div>
		<form class="w3-container w3-card-4 w3-border w3-round-large" action="/shop/customer/updateCustomerForm.jsp" method="post" style="margin: 40% auto; height: 330px;">
		
			<div style="margin-top: 30px; text-align: center;">
				<h1>회원정보 수정</h1>
			</div>
			
			<div>
				<label>ID 확인</label>
				<input class="w3-input" type="text" name="customerId" value="<%=loginCustomerMember.get("customerId")%>" readonly="readonly">
			</div>
			
			<div>
				<label>PW 확인</label>
				<input class="w3-input" type="password" name="customerPw" required="required">
			</div>

			<div class="row" style="margin-top: 20px;">
				<div class="col" style="text-align: center; margin: 10px auto;">
					<button class="btn btn-outline-secondary" type="submit" style="width: 100%;">
						정보 수정하기
					</button>
				</div>				
			</div>
			
			
		</form>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>