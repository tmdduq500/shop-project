<%@page import="shop.dao.ReviewDAO"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");
	// 요청 값 디버깅
	System.out.println("goodsOne - goodsNo = " + goodsNo);
%>

<%
	// 상품 상세보기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);

	//전체 goods 수
	int totalGoodsRow = GoodsDAO.selectTotalGoods();
	
	/* 카테고리명, 카테고리 별 상품 수 구하기 */
	ArrayList<HashMap<String, Object>> goodsCntPerCategory = GoodsDAO.selectGoodsCntPerCategory();
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
	ArrayList<HashMap<String, Object>> reviewJoinGoodsList = ReviewDAO.selectReviewJoinGoods(goodsNo, reviewStartRow, reviewRowPerPage);
%>
<%
	/* session의 정보 가져오기(상품을 올린 emp_id가 같거나, grade가 0보다 클때만 상품 수정,삭제 가능) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 상세보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<!-- 사이드바 - 서브메뉴 카테고리별 상품리스트 -->
	<jsp:include page="/emp/inc/empSideBar.jsp"></jsp:include>
	
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
							<div style="display: inline-block; width: 20%;">상품 번호</div>
							<div style="display: inline-block;"><%=goodsNo %></div>
						</div>
					
						<div style="margin-top: 10px;">
							<div style="display: inline-block; width: 20%;">카테고리</div>
							<div style="display: inline-block;"><%=goodsInfo.get("category") %></div>
						</div>
						
						<div style="margin-top: 10px;">
							<div style="display: inline-block; width: 20%;">관리자</div>
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
							<div style="display: inline-block;"><%=((String)goodsInfo.get("createDate"))%></div>
						</div>
						
						<!-- 동일한 관리자거나 관리자 등급 0보다 클때만 수정,삭제 가능 -->
						<%
							if(getSessionMap.get("empId").equals(goodsInfo.get("empId")) || (int)getSessionMap.get("grade") > 0) {
						%>
								<div>
									<div>
										<form action="/shop/emp/goods/updateGoodsForm.jsp?goodsNo=<%=goodsNo%>" method="post" style="display: inline-block; width: 45%;">
											<button type="submit" class="btn btn-outline-secondary" style="width: 100%;">수정</button>
										</form>
											
										<form action="/shop/emp/goods/deleteGoodsForm.jsp?goodsNo=<%=goodsNo%>" method="post" style="display: inline-block; width: 45%;">
											<button type="submit" class="btn btn-outline-secondary" style="width: 100%;">삭제</button>
										</form>
									</div>
								</div>
						<%
							}
						%>
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
					<div class="row">
						<div class="col">
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
						</div>
						<div class="col" style="text-align: right; vertical-align: middle;">
							<span><%=m.get("customerId") %></span>
							<span>|</span>
							<span><%=m.get("createDate") %></span>
							<div>
								<a href="/shop/emp/review/empDeleteCustomerReviewForm.jsp?ordersNo=<%=m.get("ordersNo")%>&customerId=<%=m.get("customerId")%>"
									style="text-align: right; text-decoration: none; color: gray;">
									삭제
								</a>
							</div>
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
</body>
</html>