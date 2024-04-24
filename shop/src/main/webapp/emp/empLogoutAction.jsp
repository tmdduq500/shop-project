<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 세션 공간 초기화(포맷) - 로그아웃
	
	// 로그아웃 및 세션 초기화 후 login폼으로 redirect
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
%>