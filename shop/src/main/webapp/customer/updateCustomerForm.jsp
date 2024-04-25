<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청값
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	// 디버깅
	System.out.println("udpateCustomerForm - customerId = " + customerId);
	System.out.println("udpateCustomerForm - customerPw = " + customerPw);
%>
<%
	// ID, PW 체크
	boolean isCustomer = CustomerDAO.checkCustomerIdPw(customerId, customerPw);	
	//id,pw가 불일치할 경우
	if(!isCustomer) {
		String msg = URLEncoder.encode("id, pw를 다시 확인해주세요", "UTF-8");
		response.sendRedirect("/shop/customer/checkInfoUpdateCustomer.jsp?msg=" + msg);
		return;
	}
	// customer 정보 가져오기
	HashMap<String, Object> customerInfo =  CustomerDAO.selectCustomerInfo(customerId);
	// customer 생일 가져오기(DB의 날짜 데이터 년/월/일만 출력하기위해)
	String customerBirth = (String)customerInfo.get("customerBirth");
	customerBirth = customerBirth.substring(0, 10);
	
%>
<%
	// msg 출력
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>비밀번호 변경</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
				<h1>회원정보 수정</h1>
			</div>
			
			<div class="w3-card-4">
				<form class="w3-container" action="/shop/customer/updateCustomerAction.jsp" method="post">
					<div>
						<label style="margin: 10px;">고객 ID</label>
						<input class="w3-input" type="text" name="customerId" value="<%=customerInfo.get("customerId")%>" readonly="readonly">
						<input type="hidden" name="customerPw" value="<%=customerPw%>">
					</div>
					
					<div>
						<label style="margin: 10px;">고객 이름</label>
						<input class="w3-input" type="text" name="customerName" value="<%=customerInfo.get("customerName")%>" required="required">
					</div>
					
					<div>
						<label style="margin: 10px;">생년월일</label>
						<input class="w3-input" type="date" name="customerBirth" value="<%=customerBirth %>" required="required">
					</div>
					
					<div>
						<label style="margin: 10px;">성별</label>
						<p>
						<%
							if((customerInfo.get("customerGender")).equals("남")) {
						%>
								<input class="w3-radio" type="radio" name="customerGender" value="남" required="required" checked="checked">
								<label>남</label>
								<input class="w3-radio" type="radio" name="customerGender" value="여" required="required">
								<label>여</label>
						<%
							} else {
						%>
								<input class="w3-radio" type="radio" name="customerGender" value="남" required="required">
								<label>남</label>
								<input class="w3-radio" type="radio" name="customerGender" value="여" required="required" checked="checked">
								<label>여</label>
						<%
							}
						%>
						
					</div>
					
					<div>
						
						<label style="margin: 10px;">새 비밀번호</label>
						<div>
							<input class="w3-input" type="password" name="newCustomerPw" placeholder="새 비밀번호를 입력해주세요">
						</div>
						
						<label style="margin: 10px;">새 비밀번호 확인</label>
						<div>
							<input class="w3-input" type="password" name="newCustomerPwCheck" placeholder="새 비밀번호를 다시 입력해주세요">
						</div>
					</div>
					
					<div style="text-align: center;">
						<button class="w3-button w3-section w3-dark-grey w3-ripple" type="submit" style="width: 80%; margin: 20px;">
							변경하기
						</button>
					</div>
		
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>