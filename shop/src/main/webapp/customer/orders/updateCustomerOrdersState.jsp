<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	System.out.println("updateCustomerOrdersState - ordersNo = " + ordersNo);
	
	// 주문 번호가 null일 경우(페이지 바로 접속 시)
	if(ordersNo == null) {
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	}
%>

<%
	// 구매확정으로 주문 상태 변경하기
	String updateState = "구매확정";
	int updateOrdersStateRow = OrdersDAO.updateOrdersState(ordersNo, updateState);
	
	// 주문 상태 변경 디버깅
	System.out.println("updateCustomerOrdersState - updateOrdersStateRow = " + updateOrdersStateRow);
	
	response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
%>