<%@page import="java.util.*"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");
	// 요청 값 디버깅
	System.out.println("customerGoodsOne - goodsNo = " + goodsNo);
	
	// goodsNo가 null이면 메인페이지로 redirect
	if(goodsNo == null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
	}
	
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
	// 상품 상세보기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
%>

<%
	// 비회원 주문 누를 경우 로그인 이동 하기위해 고객 session 가져오기
	HashMap<String, Object> loginCustomer = (HashMap<String, Object>)session.getAttribute("loginCustomer");
	System.out.println("customerGoodsOne - loginCustomer = " + loginCustomer);
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
			<div style="padding:20px 5%;">
				<h1 style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></h1>
			</div>
			
			<!-- 상품 상세 출력 -->
			<div style="display: flex; justify-content: center;">
				<div class="row" style="margin: 0 3%; align-items: center; width: 60%;">		
					<div class="col-6">
						<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName") %>" style="width: 100%;">	
					</div>
					<div class="col-6">
						<div style="width: 90%;">
							<div>
								<div style="display: inline-block; width: 20%;">카테고리</div>
								<div style="display: inline-block;"><%=goodsInfo.get("category") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">판매자</div>
								<div style="display: inline-block;"><%=goodsInfo.get("empId") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">상품명</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsTitle") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">설명</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsContent") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">가격</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsPrice") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">수량</div>
								<div style="display: inline-block;"><%=goodsInfo.get("goodsAmount") %></div>
							</div>
							
							<div>
								<div style="display: inline-block; width: 20%;">등록일</div>
								<div style="display: inline-block;"><%=goodsInfo.get("createDate") %></div>
							</div>
							
							<!-- 주문 하기 -->
							<div>
							<%
								if(loginCustomer != null) {
									if(Integer.parseInt((String)goodsInfo.get("goodsAmount")) > 0) {
							%>
										<a class="a-to-button" href="/shop/customer/customerOrdersForm.jsp?goodsNo=<%=goodsNo %>" style="width: 100%;">
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
			
		</div>
		
	</div>

</body>
</html>