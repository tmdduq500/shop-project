<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") != null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>
<%
	//DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* 로그인 하기 */
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	System.out.println("empLoginAction - empId = " + empId);
	System.out.println("empLoginAction - empPw = " + empPw);
		
	/*
		[DB]shop.emp에 empId, empPw 확인 SQL문 
		
		SELECT emp_id empId
		FROM emp
		WHERE active='ON' AND emp_id=? AND emp_pw = password(?)
	*/
	String loginSql = "SELECT emp_id empId FROM emp WHERE active='ON' AND emp_id=? AND emp_pw = password(?)";
	PreparedStatement loginStmt = null; 
	ResultSet loginRs = null;
	loginStmt = conn.prepareStatement(loginSql);
	loginStmt.setString(1, empId);
	loginStmt.setString(2, empPw);
	loginRs = loginStmt.executeQuery();
	
	
	if(loginRs.next()) {
		// 성공 -> /emp/empList.jsp
		session.setAttribute("loginEmp", loginRs.getString("empId"));		
		response.sendRedirect("/shop/emp/empList.jsp");
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
	}

%>