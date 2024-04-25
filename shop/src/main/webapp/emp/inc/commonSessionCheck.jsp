<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	
	// 세션 변수 이름 - loginEmp
	// loginEmp가 null이면 -> 로그인이 안돼있는 것 -> 로그인으로 이동
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>