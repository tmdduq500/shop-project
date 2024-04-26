<%@page import="java.net.URLEncoder"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
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
		return;
	}
%>
<%
	// 회원정보 일치 검증
	boolean canDeleteCustomer = CustomerDAO.checkCustomerIdPw(customerId, customerPw);

	// 회원 정보 일치할 경우
	if(canDeleteCustomer) {
		// 회원 삭제
		int deleteCustomerRow = CustomerDAO.deleteCustomer(customerId, customerPw);	
		// 회원 삭제 쿼리 실행 디버깅
		System.out.println("deleteCustomerAction - deleteCustomerRow = " + deleteCustomerRow);
	} else {
		// 회원 정보 일치하지 않을 경우
		String msg = URLEncoder.encode("회원 탈퇴에 실패헀습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/customer/deleteCustomerForm.jsp?msg=" + msg);
		return;
	}
	
	// 회원 탈퇴시 로그인돼있던 회원 세션 초기화
	session.invalidate();
	response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
%>