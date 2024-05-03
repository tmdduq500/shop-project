<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
	// 디버깅
	System.out.println("customerReviewOne - ordersNo = " + ordersNo);
		
	// 요청 값 null일 경우 메인페이지 redirect
	if(ordersNo == null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
		return;
	}
%>
<%
	// 작성된 리뷰 가져오기
	HashMap<String, Object> reviewOne = ReviewDAO.selectReviewOne(Integer.parseInt(ordersNo));

	// 작성된 리뷰의 상품 정보 가져오기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo((String)reviewOne.get("goodsNo"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>작성한 리뷰 보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-5">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>작성한 리뷰 보기</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/customer/review/deleteCustomerReviewForm.jsp" method="post">
					
					<!-- 상품의 정보 일부분 -->
					<div>
						<label>상품명</label>
						<input class="w3-input" type="text" name="goodsTitle" value="<%=goodsInfo.get("goodsTitle")%>" readonly="readonly">
						<div style="border-bottom: 1px solid #ccc;">
							<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>" width="200px">
						</div>
					</div>
						<input type="hidden" value="<%=ordersNo%>" name="ordersNo">

					<!-- 고객 리뷰 작성 부분 -->
					<div>
						<label>별점</label>
						
						<div class="score-star-read">
							<%
								for(int i = 5; i >= 1; i--) {
									if(i > (int)(reviewOne.get("score"))) {
							%>
										<input type="radio" id="<%=i %>-score" value="<%=i %>" disabled="disabled" style="text-decoration: none;">
										<label for="<%=i %>-score" class="score">&#9733;</label>
										
							<%
									} else {
							%>
										<input type="radio" id="<%=i %>-score" value="<%=i %>" checked="checked">
										<label for="<%=i %>-score" class="score">&#9733;</label>
							<%		
									}
								}
							%>
							
						</div>
						
					</div>
					
					<div>
						<label>리뷰 내용</label>
						<textarea class="w3-input" rows="5" cols="50" name="reviewContent" readonly="readonly"><%=reviewOne.get("content")%></textarea>
					</div>
					
					<div style="text-align: center; margin: 10px auto;">
						<button class="btn btn-outline-secondary" style="width: 60%; margin: 0 auto;" type="submit">리뷰 삭제하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>