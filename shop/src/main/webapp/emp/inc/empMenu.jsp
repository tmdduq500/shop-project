<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<div>
	<a href="/shop/emp/empList.jsp">사원 관리</a>
	<!-- category CRUD -->
	<a href="/shop/emp/categoryList.jsp">카테고리 관리</a>
	<a href="/shop/emp/goodsList.jsp">상품 관리</a>
	
	<span>
		<!-- 개인정보 페이지 -->
		<a href="/shop/emp/empOne.jsp">
			<%=(String)(loginMember.get("empName"))%>님 반갑습니다 
		</a>
	</span>
	
</div>