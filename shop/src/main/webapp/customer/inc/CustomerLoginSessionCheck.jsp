<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	// 세션 변수 이름 - loginCustomer
	
	if(session.getAttribute("loginCustomer") != null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
		return;
	}
%>