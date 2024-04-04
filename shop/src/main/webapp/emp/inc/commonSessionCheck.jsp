<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/emp/empLoginForm.jsp");
		return;
	}
%>