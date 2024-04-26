<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/customerLoginSessionCheck.jsp" %>

<%
	// 요청 값
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	
	// 디버깅
	System.out.println("customerLoginAction - customerId = " + customerId);
	System.out.println("customerLoginAction - customerPw = " + customerPw);
%>

<%
	// 고객 로그인
	HashMap<String, String> loginCustomer = CustomerDAO.loginCustomer(customerId, customerPw);
	
	if(loginCustomer != null) {
		// 성공 -> /shop/customer/goodsList.jsp
		System.out.println("고객 로그인 성공");

		session.setAttribute("loginCustomer", loginCustomer);
		
		// 디버깅(loginEmp 세션 변수)
// 		HashMap<String, Object> checkCustomer = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));
// 		System.out.println((String)(checkCustomer.get("customerId")));
// 		System.out.println((String)(checkCustomer.get("customerName")));		
				
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		System.out.println("로그인 실패");
		
		String errMsg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/customer/customerLoginForm.jsp?errMsg=" + errMsg);
	}
%>