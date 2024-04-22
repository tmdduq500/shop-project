<%@page import="shop.dao.OrdersDAO"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	String ordersNo = request.getParameter("ordersNo");
	
	// 디버깅
	System.out.println("deleteCustomerReviewAction - customerId = " + customerId);
	System.out.println("deleteCustomerReviewAction - customerPw = " + customerPw);
	System.out.println("deleteCustomerReviewAction - ordersNo = " + ordersNo);
	
	// 해당 jsp 바로 실행했을 경우
	if(customerId == null && customerPw == null) {
		response.sendRedirect("/shop/customer/deleteCustomerReviewForm.jsp");
		return;
	}
%>

<%
	// 회원정보 일치 검증
	boolean canDeleteCustomer = CustomerDAO.checkCustomerIdPw(customerId, customerPw);

	int deleteCustomerReviewRow = 0;
	// 회원 정보 일치할 경우
	if(canDeleteCustomer) {
		// 리뷰 삭제
		deleteCustomerReviewRow = ReviewDAO.deleteReview(ordersNo);	
		String updateState = "구매확정";
		OrdersDAO.updateOrdersState(ordersNo, updateState);
		System.out.println("deleteCustomerReviewAction - deleteCustomerReviewRow = " + deleteCustomerReviewRow);
		response.sendRedirect("/shop/customer/customerOrdersList.jsp");
	} else {
		// 회원 정보 일치하지 않을 경우
		String msg = URLEncoder.encode("리뷰 삭제에 실패헀습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/customer/deleteCustomerReviewForm.jsp?msg=" + msg);
		return;
	}
	
	
%>