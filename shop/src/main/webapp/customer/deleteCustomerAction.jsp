<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	
	// 디버깅
	System.out.println("deleteCustomerAction - customerId = " + customerId);
	System.out.println("deleteCustomerAction - customerPw = " + customerPw);
	
	// 해당 jsp 바로 실행했을 경우
	if(customerId == null && customerPw == null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
	}
%>
<%
	// 회원 삭제
	int deleteCustomerRow = CustomerDAO.deleteCustomer(customerId, customerPw);
	
	System.out.println("deleteCustomerAction - deleteCustomerRow = " + deleteCustomerRow);
	// 회원 탈퇴시 로그인돼있던 회원 세션 초기화
	session.invalidate();
	response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
%>