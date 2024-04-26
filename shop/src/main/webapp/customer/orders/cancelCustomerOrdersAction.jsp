<%@page import="java.net.URLEncoder"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
	String customerId = request.getParameter("customerId");
	String customerPw = request.getParameter("customerPw");
	
	// 요청 값 디버깅
	System.out.println("cancelCustomerOrdersAction - ordersNo = " + ordersNo);
	System.out.println("cancelCustomerOrdersAction - customerId = " + customerId);
	System.out.println("cancelCustomerOrdersAction - customerPw = " + customerPw);
	
	// 요청 값 null일 경우
	if(ordersNo == null || customerId == null || customerPw == null	) {
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	}
	
	// customer의 id,pw 검증
	boolean isCustomer = CustomerDAO.checkCustomerIdPw(customerId, customerPw);
	
	// customer이 맞다면
	if(isCustomer) {
		// ordersNo값 integer로 변환 후 고객에 의한 주문 삭제 쿼리 실행
		int deleteOrdersRow = OrdersDAO.deleteOrdersByCustomer(Integer.parseInt(ordersNo));	
		
		// 디버깅
		System.out.println("cancelCustomerOrdersAction - deleteOrdersRow = " + deleteOrdersRow);
		
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	} else {
		// id, pw 불일치
		String msg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/customer/orders/cancelCustomerOrdersForm.jsp?msg=" + msg);
		return;
	}

%>