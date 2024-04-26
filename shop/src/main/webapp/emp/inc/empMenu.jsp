<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 세션 변수인 loginEmp 가져오기(empId, empName, grade)
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<div>
	
<div class="w3-bar w3-black w3-large">
	
	<a class="w3-bar-item w3-button" href="/shop/emp/empList.jsp">사원 관리</a>
	<!-- category CRUD -->
	<a class="w3-bar-item w3-button" href="/shop/emp/category/categoryList.jsp">카테고리 관리</a>
	<a class="w3-bar-item w3-button" href="/shop/emp/goods/goodsList.jsp">상품 관리</a>
	<a class="w3-bar-item w3-button" href="/shop/emp/empOrdersList.jsp">주문 관리</a>
	<a class="w3-bar-item w3-button" href="/shop/emp/review/empReviewList.jsp">리뷰 관리</a>
	
	
	
	
	<!-- 로그아웃 -->
	<a class="w3-bar-item w3-button w3-right" href="/shop/emp/empLogoutAction.jsp">로그아웃</a>
	
	<!-- 개인정보 페이지 -->
	<span class="w3-bar-item w3-right"><%=(String)(loginMember.get("empName"))%>님(관리자모드) 반갑습니다</span>
	<!-- emp 마이페이지 -->
	<a href="/shop/emp/empOne.jsp" class="w3-bar-item w3-button w3-white w3-right">
		<img src="/shop/upload/profile_basic.jpg" alt="프로필사진" style="width:40px;" class="rounded-pill">	
	</a>
</div>
</div>