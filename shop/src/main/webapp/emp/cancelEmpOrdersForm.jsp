<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	// 요청 값 디버깅
	System.out.println("cancelEmpOrdersForm - ordersNo = " + ordersNo);
	
	// 요청 값 null일 경우 주문 목록 페이지 redirect
	if(ordersNo == null) {
		response.sendRedirect("/shop/emp/empOrdersList.jsp");
		return;
	}
%>
<%
	// 고객의 주문 목록 상세 내용 가져오기
	HashMap<String, Object> customerOrdersOne = OrdersDAO.selectOrdersOneByEmp(ordersNo);
%>
<%
	// 에러 메세지 요청값
	String msg = request.getParameter("msg");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-6" style="height: 95%;">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>고객의 주문 취소</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/emp/cancelEmpOrdersAction.jsp" method="post">
					<!-- 에러 메시지 출력 -->
					<%
						if(msg != null) {
					%>
							<div>
								<%=msg %>
							</div>
					<% 
						}
					%>	
					<!-- 상품의 정보 일부분 -->
					<div>
						<label>주문번호</label>
						<input class="w3-input" type="text" value="<%=ordersNo%>" name="ordersNo" readonly="readonly">
					
						<label>상품명</label>
						<input class="w3-input" type="text" name="goodsTitle" value="<%=customerOrdersOne.get("goodsTitle")%>" readonly="readonly">
						<div style="border-bottom: 1px solid #ccc;">
							<img alt="" src="/shop/upload/<%=customerOrdersOne.get("imgName")%>" width="200px">
						</div>
						
						<label>주문수량</label>
						<input class="w3-input" type="text" name="totalAmount" value="<%=customerOrdersOne.get("totalAmount")%>" readonly="readonly">
						
						<label>주문금액</label>
						<input class="w3-input" type="text" name="totalPrice" value="<%=customerOrdersOne.get("totalPrice")%>" readonly="readonly">
						
						<label>배달주소</label>
						<input class="w3-input" type="text" name="orderAdderess" value="<%=customerOrdersOne.get("orderAdderess")%>" readonly="readonly">
						
						<label>주문일자</label>
						<input class="w3-input" type="text" name="ordersDate" value="<%=customerOrdersOne.get("ordersDate")%>" readonly="readonly">
						
						<div style="text-align: center; margin: 10px auto;">
							<h5>고객의 주문을 취소하시려면 ID,PW를 입력해주세요</h5>
						</div>
						
						<label>관리자 ID</label>
						<input class="w3-input" type="text" name="empId" required="required">
						
						<label>관리자 PW</label>
						<input class="w3-input" type="password" name="empPw" required="required">
					</div>


					
					<div style="text-align: center; margin: 10px auto;">
						<button class="btn btn-outline-secondary" style="width: 60%; margin: 0 auto;" type="submit">고객의 주문 취소하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>