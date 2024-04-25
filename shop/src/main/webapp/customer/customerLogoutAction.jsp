<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 세션 공간 초기화(포맷) - 로그아웃시 세션 초기화
	
	response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
%>