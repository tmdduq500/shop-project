<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<%
	HashMap<String, Object> loginCustomerMember = null;
	if(session.getAttribute("loginCustomer") != null) {
		loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
	}
%>

<div>
	
<div class="w3-bar w3-black w3-large">
	<!-- 쇼핑몰 홈 이동 -->
	<a class="w3-bar-item w3-button" href="/shop/customer/goods/customerGoodsList.jsp">Home</a>

	
	
	<!-- 개인정보 페이지 -->
	<%
		if(loginCustomerMember != null) {	
	%>
			<!-- 로그아웃 -->
			<a class="w3-bar-item w3-button w3-right" href="/shop/customer/customerLogoutAction.jsp">로그아웃</a>
			
			<!-- 인사 글 -->
			<span class="w3-bar-item w3-right"><%=(String)(loginCustomerMember.get("customerName"))%>님 반갑습니다</span>
			
			<!-- 프로필 사진 -->
			<a href="/shop/customer/customerOne.jsp" class="w3-bar-item w3-button w3-white w3-right">
				<img src="/shop/upload/profile_basic.jpg" alt="프로필사진" style="width:40px;" class="rounded-pill">	
			</a>
			
			<!-- 장바구니 -->
			<a class="w3-bar-item w3-button w3-right" href="/shop/customer/orders/customerOrdersList.jsp">주문 목록</a>
	<%
		} else {
	%>
			<!-- 비회원의 경우 로그인 폼으로 -->
			<span class="w3-bar-item w3-right">비회원님 반갑습니다.</span>
			<a href="/shop/customer/customerLoginForm.jsp" class="w3-bar-item w3-button w3-white w3-right">
				<img src="/shop/upload/profile_basic.jpg" alt="프로필사진" style="width:40px;" class="rounded-pill">	
			</a>
			
			<!-- 장바구니 -->
			<a class="w3-bar-item w3-button w3-right" href="/shop/customer/customerLoginForm.jsp">주문 목록</a>
	<%
		}
	%>
	
	<!-- 최근 본 상품 -->
	<a class="w3-bar-item w3-button w3-right" href="/shop/customer/goods/recentViewedGoods.jsp">최근</a>
	
	
</div>
</div>