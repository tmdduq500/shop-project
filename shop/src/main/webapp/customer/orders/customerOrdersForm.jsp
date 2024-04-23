<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 어떤 고객이 주문했는지 알기위해 고객 session 가져오기
	HashMap<String, Object> loginCustomer = (HashMap<String, Object>)session.getAttribute("loginCustomer");
%>
<%
	// 요청 값
	String goodsNo = request.getParameter("goodsNo");

	// 요청값 디버깅
// 	System.out.println("customerOrdersForm - goodsNo = " + goodsNo);
%>
<%
	// 상품의 일부 정보를 보여주기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>주문 창</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-6">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>상품 주문</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/customer/orders/customerOrdersAction.jsp" method="post">
					
					<!-- 상품의 정보 일부분 -->
					<!-- customerId값은 action쪽에서 세션변수에서 넘겨주기 -->
					<div>
						<h5>상품 정보</h5>
					</div>
					<input type="hidden" name="goodsNo" value="<%=goodsNo%>">
					
					<div>
						<label>주문할 상품</label>
						<input class="w3-input" type="text" name="goodsTitle" value="<%=goodsInfo.get("goodsTitle")%>" readonly="readonly">
						<div style="border-bottom: 1px solid #ccc;">
							<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>">
						</div>
					</div>
					
					<div>
						<label>개당 가격</label>
						<input class="w3-input" type="number" name="goodsPrice" value="<%=goodsInfo.get("goodsPrice")%>" readonly="readonly">
					</div>
					
					<div>
						<label>남은 수량</label>
						<input class="w3-input" type="number" name="goodsAmount" value="<%=goodsInfo.get("goodsAmount")%>" readonly="readonly">
					</div>
					
					<!-- 고객이 입력해야 할 정보 -->
					<div style="margin-top: 10px;">
						<h5>입력 정보</h5>
					</div>
					
					<div>
						<label>주문 수량</label>
						<input class="w3-input" type="number" name="customerOrderAmount" min="1" max="<%=goodsInfo.get("goodsAmount") %>"  required="required">
					</div>
					
					<div>
						<label>주소</label>
						<input class="w3-input" type="text" name="customerAddress" required="required">
					</div>
					
					<div>
						<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" style="width: 60%; margin: 0 auto;" type="submit">주문하기</button>
					</div>
				</form>
			</div>
		</div>
		
	</div>
	
	<div class="col"></div>
</div>	
</body>
</html>