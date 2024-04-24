<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	// 디버깅 
	System.out.println("empReviewOne - ordersNo = " + ordersNo);
	
	// 요청값 null일 경우 페이지 redirect
	if(ordersNo == null) {
		response.sendRedirect("/shop/emp/review/empReviewList.jsp");
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
	<title>고객 후기 상세보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-6">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1><%=reviewOne.get("customerId")%>의 <%=goodsInfo.get("goodsTitle")%> 상품 리뷰 보기</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/emp/review/empDeleteCustomerReviewForm.jsp" method="post">
					
					<!-- 주문 및 상품 정보 일부분 -->
					<div>
						<label>주문번호</label>
						<input class="w3-input" type="text" name="ordersNo" value="<%=ordersNo%>" readonly="readonly">
						
						<label>상품번호</label>
						<input class="w3-input" type="text" name="goodsNo" value="<%=reviewOne.get("goodsNo")%>" readonly="readonly">
						
						<label>상품정보</label>
						<input class="w3-input" type="text" name="goodsTitle" value="<%=goodsInfo.get("goodsTitle")%>" readonly="readonly" style="border: none;">
						<div style="border-bottom: 1px solid #ccc;">
							<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>" width="200px">
						</div>
					</div>

					<!-- 고객이 작성한 리뷰 부분 -->
					<div>
						<label>리뷰 작성일</label>
						<input class="w3-input" type="text" name="createDate" value="<%=reviewOne.get("createDate")%>" readonly="readonly">
						
						<label>고객ID</label>
						<input class="w3-input" type="text" name="customerId" value="<%=reviewOne.get("customerId")%>" readonly="readonly">
					
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
					
					<div>
						<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" style="width: 60%; margin: 0 auto;" type="submit">고객의 리뷰 삭제하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>