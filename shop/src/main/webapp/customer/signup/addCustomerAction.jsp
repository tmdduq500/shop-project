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
		response.sendRedirect("/shop/customer/signup/addCustomerForm.jsp");
		return;
	}
	
	// 요청 값 디버깅
	System.out.println("addCustomerAction - customerId = " + customerId);
	System.out.println("addCustomerAction - customerPw = " + customerPw);
	System.out.println("addCustomerAction - customerName = " + customerName);
	System.out.println("addCustomerAction - customerBirth = " + customerBirth);
	System.out.println("addCustomerAction - customerGender = " + customerGender);
%>

<%
	// 고객 회원가입
	int addCustomerRow = CustomerDAO.addCustomer(customerId, customerPw, customerName, customerBirth, customerGender);

	// insert 됐는지 확인
	System.out.println("addCustomerAction - addCustomerRow = " + addCustomerRow);
	
	if(addCustomerRow == 1) {
		// 회원가입 성공
		System.out.println("회원가입 성공");
		response.sendRedirect("/shop/customer/customerLoginForm.jsp");
	} else {
		// 회원가입 실패
		System.out.println("회원가입 실패");
		String errMsg = URLEncoder.encode("회원가입 실패하였습니다. 다시 가입해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/signup/addCustomerForm.jsp?errMsg=" + errMsg + "&customerId=" + customerId);
	}
%>