<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	//현재 페이지 구하기
	int empReviewCurrentPage = 1;	// 현재페이지
	if(request.getParameter("empReviewCurrentPage") != null) {
		empReviewCurrentPage = Integer.parseInt(request.getParameter("empReviewCurrentPage"));
	}
	
	// 페이지당 보여줄 row 수
	int empReviewRowPerPage = 10;
	
	// select 박스로 rowPerPage 구하기
	if(request.getParameter("empReviewRowPerPage") != null) {
		empReviewRowPerPage = Integer.parseInt(request.getParameter("empReviewRowPerPage"));
	}
	
	
	// 모든 리뷰 개수
	int totalReveiwsNum = ReviewDAO.selectTotalReviewRow();
	
	// 마지막 페이지 구하기
	int empReviewLastPage = totalReveiwsNum / empReviewRowPerPage;
	if(totalReveiwsNum % empReviewRowPerPage != 0) {
		empReviewLastPage += 1;
	}
		
	// 페이지당 시작할 row
	int empReviewStartRow = (empReviewCurrentPage - 1) * empReviewRowPerPage;
	
	// 모든상품에 대한 리뷰 가져오기
	ArrayList<HashMap<String, Object>> reviewList = ReviewDAO.selectTotalReviewJoinGoods(empReviewStartRow, empReviewRowPerPage);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>모든 상품 후기 목록</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-7">
		<h1>모든 상품 후기 목록</h1>
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<th>주문번호</th>
					<th>상품번호</th>
					<th>상품정보</th>
					<th>주문고객</th>
					<th>별점</th>
					<th>리뷰보기</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(HashMap<String, Object> m : reviewList) {
						// 고객 리뷰 목록에 이미지 출력을 위해 상품 이미지 이름 가져오기
						String imgName = (String)GoodsDAO.selectGoodsInfo(String.valueOf(m.get("goodsNo"))).get("imgName");
						// 상품 이름 가져오기
						String goodsTitle = (String)GoodsDAO.selectGoodsInfo(String.valueOf(m.get("goodsNo"))).get("goodsTitle");
				%>
						<tr>
							<td><%=m.get("ordersNo") %></td>
							<td><%=m.get("goodsNo") %></td>
							<td>
								<a href="/shop/emp/goods/goodsOne.jsp?goodsNo=<%=(String.valueOf(m.get("goodsNo")))%>" 
									style="text-decoration: none; color: black;">
									<img alt="" src="/shop/upload/<%=imgName%>" width="80px;">
									<%=goodsTitle%>
								</a>
							</td>
							<td style="vertical-align: middle;"><%=m.get("customerId")%></td>
							<td style="vertical-align: middle; display: flex; justify-content: center;">
								<div class="score-star-read">
									<%
										for(int i = 5; i >= 1; i--) {
											if(i > (int)(m.get("score"))) {
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
							</td>
							<td>
								<a class="a-to-button" href="/shop/emp/review/empReviewOne.jsp?ordersNo=<%=m.get("ordersNo")%>" style="width: 100%;">고객 리뷰보기</a>
							</td>
							
						</tr>
				<%
					}
				%>
				
			</tbody>
		</table>
		
		<!-- 페이징 버튼 -->	
		<div class="w3-bar w3-center">
	
			<%
				if(empReviewCurrentPage > 1) {
			%>	
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=1">처음페이지</a>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=<%=empReviewCurrentPage-1%>">이전페이지</a>
			<%		
				} else {
			%>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=1">처음페이지</a>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=1">이전페이지</a>
			<%		
				}
	
				if(empReviewCurrentPage < empReviewLastPage) {
			%>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=<%=empReviewCurrentPage+1%>">다음페이지</a>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=<%=empReviewLastPage%>">마지막페이지</a>
			<%		
				} else {
			%>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=<%=empReviewLastPage%>">다음페이지</a>
					<a class="w3-button" href="/shop/emp/review/empReviewList.jsp?empReviewCurrentPage=<%=empReviewLastPage%>">마지막페이지</a>
			<%
				}
			%>
	
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>