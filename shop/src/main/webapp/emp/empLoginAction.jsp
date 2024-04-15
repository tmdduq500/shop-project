<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@page import="shop.dao.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/loginSessionCheck.jsp"%>

<%
	/* 로그인 하기 */
	
	// id, pw 요청값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	System.out.println("empLoginAction - empId = " + empId);
	System.out.println("empLoginAction - empPw = " + empPw);
		
	HashMap<String, Object> loginEmp =  EmpDAO.empLogin(empId, empPw);

	if(loginEmp != null) {
		// 성공 -> /emp/empList.jsp
		System.out.println("로그인 성공");
		
		session.setAttribute("loginEmp", loginEmp);
		
		// 디버깅(loginEmp 세션 변수)
// 		HashMap<String, Object> checkEmp = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
// 		System.out.println((String)(checkEmp.get("empId")));
// 		System.out.println((String)(checkEmp.get("empName")));
// 		System.out.println((Integer)(checkEmp.get("grade")));
		
				
		response.sendRedirect("/shop/emp/empList.jsp");
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		System.out.println("로그인 실패");
		
		String errMsg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg=" + errMsg);
	}

%>