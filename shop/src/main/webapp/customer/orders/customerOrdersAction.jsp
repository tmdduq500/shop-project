<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));
%>
<%
	// 고객 id 세션에서 가져오기
	String customerId = (String)loginCustomerMember.get("customerId");

	// 요청 값
	int customerOrderGoodsNo = Integer.parseInt(request.getParameter("goodsNo"));
	int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice"));
	int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
	int customerOrderAmount = Integer.parseInt(request.getParameter("customerOrderAmount"));
	String customerAddress = request.getParameter("customerAddress");
	
	// 연산 필요한 값(전체 가격, 남은 상품 수량)
	int totalPrice = customerOrderAmount * goodsPrice; 	// 주문한 전체 가격
	int remainingAmount = goodsAmount - customerOrderAmount;	// 남는 상품 수량
	
	// 요청값 디버깅
	System.out.println("customerOrderAction - customerOrderGoodsNo = " + customerOrderGoodsNo);
	System.out.println("customerOrderAction - goodsPrice = " + goodsPrice);
	System.out.println("customerOrderAction - goodsAmount = " + goodsAmount);
	System.out.println("customerOrderAction - customerOrderAmount = " + customerOrderAmount);
	System.out.println("customerOrderAction - customerAddress = " + customerAddress);
	
	// 주문한 상품 수량 변경 - (여러사람이 약간의 시간차로 주문할 경우 수량이 반영이 안될 가능성때문에 수량 먼저 변경)
	int updateGoodsAmountRow = GoodsDAO.updateGoodsAmount(customerOrderGoodsNo, remainingAmount);; 
	System.out.println("customerOrdersAction - updateGoodsAmountRow = " + updateGoodsAmountRow);
	
	// 주문 목록에 추가
	if(updateGoodsAmountRow == 1) {
		int insertOrderRow = OrdersDAO.insertOrdersOfCustomer(customerId, customerOrderGoodsNo, customerOrderAmount, totalPrice, customerAddress);	

		System.out.println("customerOrdersAction - insertOrderRow = " + insertOrderRow);
		
		// 주문 목록으로 redirect
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	} else {
		// 예외 발생
		System.out.println("수량 변경 문제 발생");
		response.sendRedirect("/shop/customer/goods/customerGoodsOne.jsp?goodsNo=" + customerOrderGoodsNo);
	}
%>