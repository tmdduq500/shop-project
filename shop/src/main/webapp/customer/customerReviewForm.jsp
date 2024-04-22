<%@page import="shop.dao.OrdersDAO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	// 디버깅
	System.out.println("customerReviewForm - ordersNo = " + ordersNo);
%>
<%
	// 해당 주문번호의 상품 정보 가져오기
	HashMap<String, Object> ordersOne = OrdersDAO.selectOrdersOneByEmp(ordersNo);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>리뷰 작성</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-5">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>후기 작성</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/customer/customerReviewAction.jsp" method="post">
					
					<!-- 상품의 정보 일부분 -->
					<div>
						<label>상품명</label>
						<input class="w3-input" type="text" name="goodsTitle" value="<%=ordersOne.get("goodsTitle")%>" readonly="readonly">
						<div style="border-bottom: 1px solid #ccc;">
							<img alt="" src="/shop/upload/<%=ordersOne.get("imgName")%>" width="200px">
						</div>
					</div>
						<input type="hidden" value="<%=ordersNo%>" name="ordersNo">

						<!-- 고객 리뷰 작성 부분 -->
					<div>
						<label>별점을 매겨주세요</label>
						
						<div class="score-star">
							<input type="radio" id="5-score" name="reviewScore" value="5" required="required">
							<label for="5-score" class="score">&#9733;</label>
							
							<input type="radio" id="4-score" name="reviewScore" value="4" >
							<label for="4-score" class="score">&#9733;</label>
							
							<input type="radio" id="3-score" name="reviewScore" value="3" >
							<label for="3-score" class="score">&#9733;</label>
							
							<input type="radio" id="2-score" name="reviewScore" value="2" >
							<label for="2-score" class="score">&#9733;</label>
							
							<input type="radio" id="1-score" name="reviewScore" value="1" >
							<label for="1-score" class="score">&#9733;</label>
						</div>
						
					</div>
					
					<div>
						<label>리뷰 내용</label>
						<textarea class="w3-input" rows="5" cols="50" name="reviewContent" required="required"></textarea>
					</div>
					
					<div>
						<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" style="width: 60%; margin: 0 auto;" type="submit">리뷰 작성하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>