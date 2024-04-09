<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/CustomerLoginSessionCheck.jsp" %>

<%
	// 요청 값
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	
	System.out.println("customerLoginAction - customerId = " + customerId);
	System.out.println("customerLoginAction - customerPw = " + customerPw);
%>

<%
	// DB연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

	String customerLoginSql = "SELECT id customerId, name customerName FROM customer WHERE id = ? AND pw = PASSWORD(?)";
	PreparedStatement customerLoginStmt = null;
	ResultSet customerLoginRs = null;
	
	customerLoginStmt = conn.prepareStatement(customerLoginSql);
	customerLoginStmt.setString(1, customerId);
	customerLoginStmt.setString(2, customerPw);
	customerLoginRs = customerLoginStmt.executeQuery();
	
	if(customerLoginRs.next()) {
		// 성공 -> /shop/customer/goodsList.jsp
		System.out.println("고객 로그인 성공");
		
		// 하나의 세션변수 안에 여러개의 값을 저장하기 위해 HashMap타입 사용
		HashMap<String, Object> loginCustomer = new HashMap<String, Object>();
		loginCustomer.put("customerId", customerLoginRs.getString("customerId"));
		loginCustomer.put("customerName", customerLoginRs.getString("customerName"));

		
		session.setAttribute("loginCustomer", loginCustomer);
		
		// 디버깅(loginEmp 세션 변수)
		HashMap<String, Object> checkCustomer = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));
		System.out.println((String)(checkCustomer.get("customerId")));
		System.out.println((String)(checkCustomer.get("customerName")));		
				
		response.sendRedirect("/shop/customer/goodsList.jsp");
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		System.out.println("로그인 실패");
		
		String errMsg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/customer/customerLoginForm.jsp?errMsg=" + errMsg);
	}
%>