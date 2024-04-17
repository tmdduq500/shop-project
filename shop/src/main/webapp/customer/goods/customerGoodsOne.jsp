<%@page import="java.util.*"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");
	// 요청 값 디버깅
	System.out.println("customerGoodsOne - goodsNo = " + goodsNo);
	
	// 최근 본 상품 세션에 추가
	Set<String> recentViewdGoods = null;
	if(session.getAttribute("recentViewdGoods") == null) {
		recentViewdGoods = new HashSet<String>();
	} else {
		recentViewdGoods = (HashSet<String>)session.getAttribute("recentViewdGoods");		
	}
	if(goodsNo != null) {
		recentViewdGoods.add(goodsNo);
		session.setAttribute("recentViewdGoods", recentViewdGoods);	
	}
	
%>

<%
	//전체 goods 수
	int totalGoodsRow = GoodsDAO.getTotalGoods();

	/* 카테고리명, 카테고리 별 상품 수 구하기 */
	ArrayList<HashMap<String, Object>> goodsCntPerCategory = GoodsDAO.getGoodsCntPerCategory();

	// 상품 상세보기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
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
		<div class="w3-sidebar w3-light-grey w3-bar-block" style="width:15%">
			<h3 class="w3-bar-item">카테고리</h3>

			<a href="#" class="w3-bar-item w3-button">전체(<%=totalGoodsRow%>)</a>
			<%
				for(HashMap m : goodsCntPerCategory) {
			%>

					<a href="#" class="w3-bar-item w3-button">
						<%=(String)(m.get("category")) %>
						(<%=(Integer)(m.get("cnt")) %>)
					</a>

			<% 
				}
			%>
		</div>
		
		<!-- customerGoodsOne 본문 -->
		<div style="margin-left:15%; ">
			<div style="padding:20px 5%;">
				<h1 style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></h1>
			</div>
			
			<!-- 상품 상세 출력 -->
			<div>
				<div class="row" style="margin: 0 3%; align-items: center;">		
					<div class="col">
						<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName") %>" style="width: 100%;">	
					</div>
					<div class="col">
						<div>
							<div style="display: inline-block; width: 15%;">카테고리</div>
							<div style="display: inline-block;"><%=goodsInfo.get("category") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">판매자</div>
							<div style="display: inline-block;"><%=goodsInfo.get("empId") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">상품명</div>
							<div style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">설명</div>
							<div style="display: inline-block;"><%=goodsInfo.get("goodsContent") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">가격</div>
							<div style="display: inline-block;"><%=goodsInfo.get("goodsPrice") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">수량</div>
							<div style="display: inline-block;"><%=goodsInfo.get("goodsAmount") %></div>
						</div>
						
						<div>
							<div style="display: inline-block; width: 15%;">등록일</div>
							<div style="display: inline-block;"><%=goodsInfo.get("createDate") %></div>
						</div>
					</div>
					
				</div>
			</div>
			
		</div>
		
	</div>

</body>
</html>