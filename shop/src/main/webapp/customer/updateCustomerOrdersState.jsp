<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	System.out.println("updateCustomerOrdersState - ordersNo = " + ordersNo);
	
	// 주문 번호가 null일 경우(페이지 바로 접속 시)
	if(ordersNo == null) {
		response.sendRedirect("/shop/customer/customerOrdersList.jsp");
	}
%>

<%
	int updateOrdersStateByCustomerRow = OrdersDAO.updateOrdersStateByCustomer(ordersNo);
	
	System.out.println("updateCustomerOrdersState - updateOrdersStateByCustomerRow = " + updateOrdersStateByCustomerRow);
	
	response.sendRedirect("/shop/customer/customerOrdersList.jsp");
%>