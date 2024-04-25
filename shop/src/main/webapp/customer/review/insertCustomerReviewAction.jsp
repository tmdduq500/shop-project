<%@page import="shop.dao.OrdersDAO"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
	String reviewScore = request.getParameter("reviewScore");
	String reviewContent = request.getParameter("reviewContent");

	// 주문 번호가 null일 경우 주문 목록으로 이동
	if(ordersNo == null) {
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");
		return;
	}
	
	// 요청 값 디버깅
	System.out.println("customerReviewAction - ordersNo = " + ordersNo);
	System.out.println("customerReviewAction - reviewScore = " + reviewScore);
	System.out.println("customerReviewAction - reviewContent = " + reviewContent);
%>

<%
	// 리뷰 작성하기
	int insertReviewRow = ReviewDAO.insertReview(Integer.parseInt(ordersNo), Integer.parseInt(reviewScore), reviewContent);
	
	// 리뷰 작성 쿼리 실행됐을 경우
	if(insertReviewRow == 1 ) {
		System.out.println("customerReviewAction - insertReviewRow = " + insertReviewRow);
		
		// 주문 상태 변환
		String updateState = "리뷰완료";
		int updateStateRow = OrdersDAO.updateOrdersState(ordersNo, updateState);	
		// 디버깅
		System.out.println("customerReviewAction - updateStateRow = " + updateStateRow);
		
		response.sendRedirect("/shop/customer/orders/customerOrdersList.jsp");	
		return;
	} else {
		// 쿼리 실행 실패
		response.sendRedirect("/shop/customer/orders/customerOrdersForm.jsp?ordersNo=" + ordersNo);
		return;
	}
	
	
%>