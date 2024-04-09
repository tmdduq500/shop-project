<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/CustomerLoginSessionCheck.jsp" %>

<%
	// 요청 값
	String checkIdFirst = request.getParameter("checkIdFirst");
	String checkIdMiddle = request.getParameter("checkIdMiddle");
	String checkIdLast = request.getParameter("checkIdLast");
	// 요청 값 디버깅
	System.out.println("checkIdAction - checkIdFirst = " + checkIdFirst);
	System.out.println("checkIdAction - checkIdMiddle = " + checkIdMiddle); 
	System.out.println("checkIdAction - checkIdLast = " + checkIdLast); 

	if(checkIdFirst.equals("") || checkIdMiddle.equals("") || checkIdLast.equals("")) {
		String errMsg = URLEncoder.encode("ID를 정확히 입력해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?errMsg=" + errMsg);
		return;
	}
	String checkCustomerId = checkIdFirst + checkIdMiddle + checkIdLast;
	// 요청 값 디버깅
	System.out.println("checkIdAction - checkCustomerId = " + checkCustomerId); 
	
%>

<%
	//DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	String checkIdSql  = "SELECT id FROM customer WHERE id = ?";
	PreparedStatement checkIdStmt = null;
	ResultSet checkIdRs = null;
	
	checkIdStmt = conn.prepareStatement(checkIdSql);
	checkIdStmt.setString(1, checkCustomerId);
	checkIdRs = checkIdStmt.executeQuery();
	
	if(checkIdRs.next()) {
		// 아이디가 중복
		String errMsg = URLEncoder.encode("이미 존재하는 ID입니다.", "UTF-8");
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?errMsg=" + errMsg);
	} else {
		// 아이디 사용 가능
		String errMsg = URLEncoder.encode("사용 가능한 아이디 입니다", "UTF-8");
		response.sendRedirect("/shop/customer/addCustomerForm.jsp?errMsg=" + errMsg + "&customerId=" + checkCustomerId);
	}
	
%>