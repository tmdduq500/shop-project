<%@page import="java.net.URLEncoder"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@page import="shop.dao.ReviewDAO"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	String ordersNo = request.getParameter("ordersNo");
	
	// 디버깅
	System.out.println("empDeleteCustomerReviewAction - empId = " + empId);
	System.out.println("empDeleteCustomerReviewAction - empPw = " + empPw);
	System.out.println("empDeleteCustomerReviewAction - ordersNo = " + ordersNo);
	
	// 해당 jsp 바로 실행했을 경우
	if(empId == null && empPw == null) {
		response.sendRedirect("/shop/emp/review/empDeleteCustomerReviewForm.jsp");
		return;
	}
%>

<%
	// 회원정보 일치 검증
	boolean canDeleteReview = EmpDAO.checkEmpIdPw(empId, empPw);

	int deleteCustomerReviewRow = 0;
	// emp 정보 일치할 경우
	if(canDeleteReview) {
		// 리뷰 삭제
		deleteCustomerReviewRow = ReviewDAO.deleteReview(ordersNo);	
		
		// 리뷰 삭제 시 주문상태 다시 구매확정으로 변경(리뷰 작성 가능하도록)
		String updateState = "구매확정";
		OrdersDAO.updateOrdersState(ordersNo, updateState);
		
		// 리뷰삭제 디버깅
		System.out.println("empDeleteCustomerReviewAction - deleteCustomerReviewRow = " + deleteCustomerReviewRow);
		response.sendRedirect("/shop/emp/review/empReviewList.jsp");
	} else {
		// emp 정보 일치하지 않을 경우
		String msg = URLEncoder.encode("리뷰 삭제에 실패헀습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/emp/review/empDeleteCustomerReviewForm.jsp?msg=" + msg);
		return;
	}
	
	
%>