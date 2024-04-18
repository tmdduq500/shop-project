<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	/* 상품 목록 페이징 */
	
	// 현재 페이지 구하기
	int currentPage = 1;	// 현재페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// currentPage 세션 값 설정
	session.setAttribute("currentPage", currentPage);
	
	// 페이지당 보여줄 row 수
	int rowPerPage = 30;
	
//  	// select 박스로 rowPerPage 구하기
//  	if(request.getParameter("rowPerPage") != null) {
//  		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
//  	}
	
	// category 요청 값
	String category = request.getParameter("category");
	
	// category 세션 값 설정
	if(category == null) {
		category = "all";
		session.setAttribute("category", category);
	} else {
		session.setAttribute("category", category);
	}
	
	// 전체 goods 수
	int totalGoodsRow = GoodsDAO.getTotalGoods();
	
	// 카테고리별 goods 수
	int goodsPerCategoryRow = GoodsDAO.selectGoodsPerCategory(category);
	
	// 카테고리별(전체 포함) 마지막 페이지 구하기
	int lastPage = goodsPerCategoryRow / rowPerPage;
	if(goodsPerCategoryRow % rowPerPage != 0) {
		lastPage += 1;
	}
		
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;
	
%>

<%	
	/* 카테고리명, 카테고리 별 상품 수 구하기 */
	ArrayList<HashMap<String, Object>> goodsCntPerCategory = GoodsDAO.selectGoodsCntPerCategory();
%>

<%
	/* 상품 목록 출력하기(category, page조건을 맞춰서) */
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.selectGoodsList(startRow, rowPerPage, category);
%>

<%
	// 디버깅 코드
// 	System.out.println("CustomerGoodsList - currentPage 세션 값 = " + session.getAttribute("currentPage"));	// currentPage 세션 값 체크
// 	System.out.println("CustomerGoodsList - category = " + category);
// 	System.out.println("CustomerGoodsList - category 세션 값 = " + session.getAttribute("category"));	// category 세션 값 체크
// 	System.out.println("CustomerGoodsList - totalGoodsRow = " + totalGoodsRow);
// 	System.out.println("CustomerGoodsList - goodsPerCategoryRow = " + goodsPerCategoryRow);
// 	System.out.println("CustomerGoodsList - lastPage = " + lastPage);
// 	System.out.println("CustomerGoodsList - startRow = " + startRow);
	
// 	System.out.println("CustomerGoodsList - goodsCntPerCategory = " + goodsCntPerCategory);
	
// 	System.out.println("CustomerGoodsList - goodsList = " + goodsList);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<!-- 메인 메뉴 -->
	<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
	<div>
		<!-- 사이드바 - 서브메뉴 카테고리별 상품리스트 -->
		<div class="w3-sidebar w3-light-grey w3-bar-block" style="width:15%">
			<h3 class="w3-bar-item">카테고리</h3>

			<a href="/shop/customer/goods/customerGoodsList.jsp" class="w3-bar-item w3-button">전체(<%=totalGoodsRow%>)</a>
			<%
				for(HashMap m : goodsCntPerCategory) {
			%>

					<a href="/shop/customer/goods/customerGoodsList.jsp?category=<%=(String)(m.get("category")) %>" class="w3-bar-item w3-button">
						<%=(String)(m.get("category")) %>
						(<%=(Integer)(m.get("cnt")) %>)
					</a>

			<% 
				}
			%>
		</div>
		
		<!-- goodsList 본문 -->
		<div style="margin-left:15%; ">
			<div style="padding:20px 5%;">
				<h1 style="display: inline-block;">상품 목록</h1>
			</div>
			
			<!-- goods 목록 출력 -->
			<div>
				<div class="row" style="margin: 0 3%;">				

					<%
						for(HashMap<String, Object> m : goodsList) {
					%>
							
							<div class="col-md-3" style="height: 250px; margin: 20px 10px; width: 15%;">
							
								<div class="w3-card-2" style="height: 100%;">
							
									<!-- 상품 이미지 -->
									<div class="w3-border-bottom" style="text-align: center; height: 70%; padding-bottom: 5%;">
										<a href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=m.get("goodsNo")%>">
											<img alt="" src="/shop/upload/<%=m.get("imgName") %>" style="max-width: 100%; height: 100%;">
										</a>	
									</div>
									
									<!-- 상품 내용(이름, 가격) -->
									<div style="height: 30%; text-align: center;">
									
										<div style="margin-top: 10%;">
											<a href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=m.get("goodsNo")%>">
												<%=m.get("goodsTitle") %>
											</a>
										</div>
										
										<div>
											<%=m.get("goodsPrice") %>원
										</div>
										
									</div>
								
								</div>
							
							</div>
							
			
					<%
						}
					%>
	
				</div>
			</div>
			
			
			
			<!-- 페이징 버튼 -->	
			<div class="w3-bar w3-center">
		
				<%
					if(currentPage > 1) {
				%>	
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">처음페이지</a>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=currentPage-1%>">이전페이지</a>
				<%		
					} else {
				%>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">처음페이지</a>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">이전페이지</a>
				<%		
					}
		
					if(currentPage < lastPage) {
				%>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=currentPage+1%>">다음페이지</a>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">마지막페이지</a>
				<%		
					} else {
				%>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">다음페이지</a>
						<a class="w3-button" href="/shop/customer/goods/customerGoodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">마지막페이지</a>
				<%
					}
				%>
		
			</div>
		</div>
		
	</div>
	
</body>
</html>