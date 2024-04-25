<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
	// 로그인 돼있는 고객의 id
	String customerId = (String)loginCustomerMember.get("customerId");
	
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
	// 디버깅
	System.out.println("deleteCustomerReviewForm - ordersNo = " + ordersNo);
	
	// 주문 번호가 null일 경우 주문 목록으로 이동
	if(ordersNo == null) {
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	}
%>
<%
	// msg 출력
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>리뷰 삭제</title>
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
				<h1>리뷰 삭제하기</h1>
			</div>	
			
			<div class="w3-card-4" style="padding: 5%;">
				<form class="w3-container" action="/shop/customer/review/deleteCustomerReviewAction.jsp" method="post">
					<div>
						리뷰를 삭제하시려면 ID와 PW를 입력해주세요:(
					</div>
					<input type="hidden" name="ordersNo" value="<%=ordersNo%>">
					<div style="margin-top: 20px;">
						<label>ID</label>
						<input class="w3-input" type="text" name="customerId" value="<%=customerId %>" readonly="readonly">
					</div>
					
					<div>
						<label>PW</label>
						<input class="w3-input" type="password" name="customerPw" required="required">
					</div>
							
					<div>
						<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" type="submit">리뷰 삭제하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>