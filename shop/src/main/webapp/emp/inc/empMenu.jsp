<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<div>
	<a href="/shop/emp/empList.jsp">사원 관리</a>
	<!-- category CRUD -->
	<a href="/shop/emp/category/categoryList.jsp">카테고리 관리</a>
	<a href="/shop/emp/goods/goodsList.jsp">상품 관리</a>
	
	<!-- 개인정보 페이지 -->
	<span>
		<a href="/shop/emp/empOne.jsp"><%=(String)(loginMember.get("empName"))%>님</a> 반갑습니다 
	</span>
	
	<!-- 로그아웃 -->
	<div>
		<a href="/shop/emp/empLogoutAction.jsp">
			로그아웃
		</a>
	</div>
</div>