<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	System.out.println("updateOrdersState - ordersNo = " + ordersNo);
	
	// 주문번호가 null일 경우
	if(ordersNo == null) {
		response.sendRedirect("/shop/emp/empOrdersList.jsp");
	}
%>
<%
	// 주문 상태 배송중으로 변경
	int updateOrdersStateRow = OrdersDAO.updateOrdersStateByEmp(ordersNo);
	System.out.println("updateOrdersState - updateOrdersStateRow = " + updateOrdersStateRow);
	
	// 주문 상태 변경 후 주문 목록 리스트로 redirect
	response.sendRedirect("/shop/emp/empOrdersList.jsp");
%>