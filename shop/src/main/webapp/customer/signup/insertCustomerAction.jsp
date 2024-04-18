<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/CustomerLoginSessionCheck.jsp" %>

<%
	// 요청 값 
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	String customerName = request.getParameter("customerName");
	String customerBirth = request.getParameter("customerBirth");
	String customerGender = request.getParameter("customerGender");

	// 요청 값 하나라도 null일 경우
	if(customerId == null || customerPw == null ||customerName == null ||customerBirth == null ||customerGender == null) {
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp");
		return;
	}
	
	// 요청 값 디버깅
	System.out.println("insertCustomerAction - customerId = " + customerId);
	System.out.println("insertCustomerAction - customerPw = " + customerPw);
	System.out.println("insertCustomerAction - customerName = " + customerName);
	System.out.println("insertCustomerAction - customerBirth = " + customerBirth);
	System.out.println("insertCustomerAction - customerGender = " + customerGender);
%>

<%
	// 고객 회원가입
	int insertCustomerRow = CustomerDAO.insertCustomer(customerId, customerPw, customerName, customerBirth, customerGender);

	// insert 됐는지 확인
	System.out.println("insertCustomerAction - insertCustomerRow = " + insertCustomerRow);
	
	if(insertCustomerRow == 1) {
		// 회원가입 성공
		System.out.println("회원가입 성공");
		response.sendRedirect("/shop/customer/customerLoginForm.jsp");
	} else {
		// 회원가입 실패
		System.out.println("회원가입 실패");
		String errMsg = URLEncoder.encode("회원가입 실패하였습니다. 다시 가입해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp?errMsg=" + errMsg + "&customerId=" + customerId);
	}
%>