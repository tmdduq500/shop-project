<%@page import="shop.dao.ReviewDAO"%>
<%@page import="java.util.*"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");

	// goodsNo가 null이면 메인페이지로 redirect
	if(goodsNo == null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
	}
	
	// 최근 본 상품 세션(내용 : goodsNo)에 추가하기
	Set<String> recentViewdGoods = null;
	
	// 최근 본 상품 세션이 null이면(없다면)
	if(session.getAttribute("recentViewdGoods") == null) {
		// new HashSet 생성
		recentViewdGoods = new HashSet<String>();
	} else {
		// Set에 최근 본 상품 세션 담기
		recentViewdGoods = (HashSet<String>)session.getAttribute("recentViewdGoods");		
	}
	
	// goodsNo가 null이 아니면 최근 본 상품 세션에 추가
	if(goodsNo != null) {
		recentViewdGoods.add(goodsNo);
		session.setAttribute("recentViewdGoods", recentViewdGoods);	
	}
	
%>

<%
	// 상품 상세보기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
%>

<%
	// 비회원 주문 누를 경우 로그인 이동 하기위해 고객 session 가져오기
	HashMap<String, Object> loginCustomer = (HashMap<String, Object>)session.getAttribute("loginCustomer");
	System.out.println("customerGoodsOne - loginCustomer = " + loginCustomer);
%>

<%
	/* 리뷰 목록 페이징 */
	
	// 현재 페이지 구하기
	int reviewCurrentPage = 1;	// 현재페이지
	if(request.getParameter("reviewCurrentPage") != null) {
		reviewCurrentPage = Integer.parseInt(request.getParameter("reviewCurrentPage"));
	}
	
	// reviewCurrentPage 세션 값 설정
	session.setAttribute("reviewCurrentPage", reviewCurrentPage);
	
	// 페이지당 보여줄 row 수
	int reviewRowPerPage = 5;

	// 해당 상품의 리뷰 수
	int totalReviewOfGoodsRow = ReviewDAO.selectTotalReviewOfGoodsRow(goodsNo);
	
	// 리뷰 마지막 페이지 구하기
	int reviewLastPage = totalReviewOfGoodsRow / reviewRowPerPage;
	if(totalReviewOfGoodsRow % reviewRowPerPage != 0) {
		reviewLastPage += 1;
	}
		
	// 페이지당 시작할 row
	int reviewStartRow = (reviewCurrentPage - 1) * reviewRowPerPage;
	
%>
<%
	// 상품과 리뷰 테이블 조인해서 상품 상세페이지에 출력
	// Map의 키 : goodsNo, customerId, score, content
	ArrayList<HashMap<String, Object>> reviewJoinGoodsList = ReviewDAO.selectReviewJoinGoods(goodsNo, reviewStartRow, reviewRowPerPage);
%>
<%
	// 디버깅
// 	System.out.println("customerGoodsOne - goodsNo = " + goodsNo);
// 	System.out.println("customerGoodsOne - reviewCurrentPage = " + reviewCurrentPage);
// 	System.out.println("customerGoodsOne - totalReviewOfGoodsRow = " + totalReviewOfGoodsRow);
// 	System.out.println("customerGoodsOne - reviewRowPerPage = " + reviewRowPerPage);
// 	System.out.println("customerGoodsOne - reviewLastPage = " + reviewLastPage);
// 	System.out.println("customerGoodsOne - reviewStartRow = " + reviewStartRow);

%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title><%=goodsInfo.get("goodsTitle") %></title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
	<div>
		<!-- 사이드바 - 서브메뉴 카테고리별 상품리스트 -->
		<jsp:include page="/customer/inc/customerSideBar.jsp"></jsp:include>
		
		<!-- customerGoodsOne 본문 -->
		<div style="margin-left:15%; ">
			<div style="padding:20px 10%;">
				<h1 style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></h1>
			</div>
			
			<!-- 상품 상세 출력 -->
			<div style="display: flex; justify-content: center;">
				<div class="row" style="margin: 0 3%; align-items: center; width: 60%;">		
					<div class="col-6" style="width: 50%; height: 100%;">
						<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName") %>" >	
					</div>
					<div class="col-6" style="width: 50%; height: 100%;">
						<div style="width: 90%;">
							<div>
								<div style="display: inline-block; width: 20%;">카테고리</div>
								<div style="display: inline-block;"><%=goodsInfo.get("category") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">판매자</div>
								<div style="display: inline-block;"><%=goodsInfo.get("empId") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">상품명</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">설명</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsContent") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">가격</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsPrice") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">수량</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsAmount") %></div>
							</div>
							
							<div style="margin-top: 10px;">
								<div style="display: inline-block; width: 20%;">등록일</div>
								<div style="display: inline-block;"><%=((String)goodsInfo.get("createDate")).substring(0, 10)%></div>
							</div>
							
							<!-- 주문 하기 -->
							<div>
							<%
								if(loginCustomer != null) {
									if(Integer.parseInt((String)goodsInfo.get("goodsAmount")) > 0) {
							%>
										<a class="a-to-button" href="/shop/customer/orders/customerOrdersForm.jsp?goodsNo=<%=goodsNo %>" style="width: 100%;">
											주문 하기
										</a>
							<%
									} else {
							%>
										<a class="a-to-button" href="#" style="width: 100%;">품절입니다</a>
							<%
									}
								} else {
							%>
									<a class="a-to-button" href="/shop/customer/customerLoginForm.jsp" style="width: 100%;">주문 하기</a>
							<%
								}
							%>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 후기 출력 -->
			<div style="padding:20px 10%;">
				<h2 style="display: inline-block;">리뷰</h2>
				<hr>
				<%
					for(HashMap<String, Object> m : reviewJoinGoodsList) {
				%>
						<div style="padding: 10px;">
							<div>
								<span class="score-star-read">
								<%=m.get("score") %>&nbsp;
									<%
										for(int i = 5; i >= 1; i--) {
											if(i > (int)(m.get("score"))) {
									%>
												<input type="radio" id="<%=i %>-score" value="<%=i %>" disabled="disabled">
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
									
								</span>
								
								<span>|</span>
								<span><%=m.get("reviewCustomerId") %></span>
								<span>|</span>
								<span><%=m.get("reviewCreateDate") %></span>
							</div>
							<div style="padding-top: 10px;"><%=m.get("content") %></div>
						</div>	
						<hr>
				<%
					}
				%>
				
				<!-- 페이징 버튼 -->	
				<div class="w3-bar w3-center">
			
					<%
						if(reviewCurrentPage > 1) {
					%>	
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=1">처음페이지</a>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=<%=reviewCurrentPage-1%>">이전페이지</a>
					<%		
						} else {
					%>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=1">처음페이지</a>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=1">이전페이지</a>
					<%		
						}
			
						if(reviewCurrentPage < reviewLastPage) {
					%>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=<%=reviewCurrentPage+1%>">다음페이지</a>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=<%=reviewLastPage%>">마지막페이지</a>
					<%		
						} else {
					%>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=<%=reviewLastPage%>">다음페이지</a>
							<a class="w3-button" href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>&reviewCurrentPage=<%=reviewLastPage%>">마지막페이지</a>
					<%
						}
					%>
			
				</div>
			</div>
			
		</div>
		
	</div>

</body>
</html>