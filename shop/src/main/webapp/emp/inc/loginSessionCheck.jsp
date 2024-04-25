<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	// 세션 변수 이름 - loginEmp
	// loginEmp 세션 변수가 있다면 -> 로그인이 돼있는 것이므로 메인페이지(empList)로 redirect
	if(session.getAttribute("loginEmp") != null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>