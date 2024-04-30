<%@page import="java.net.URLEncoder"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@page import="shop.dao.EmpDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>

<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청 값 디버깅
	System.out.println("cancelEmpOrdersAction - ordersNo = " + ordersNo);
	System.out.println("cancelEmpOrdersAction - empId = " + empId);
	System.out.println("cancelEmpOrdersAction - empPw = " + empPw);
	
	// 요청 값 null일 경우
	if(ordersNo == null || empId == null || empPw == null	) {
		response.sendRedirect("/shop/emp/empOrdersList.jsp");
		return;
	}
	
	// emp의 id,pw 검증
	boolean isEmp = EmpDAO.checkEmpIdPw(empId, empPw);
	
	// emp가 맞다면
	if(isEmp) {
		// ordersNo값 integer로 변환 후 emp에 의한 주문 삭제 쿼리 실행
		int deleteOrdersRow = OrdersDAO.deleteOrders(Integer.parseInt(ordersNo));	
		
		// 디버깅
		System.out.println("cancelEmpOrdersAction - deleteOrdersRow = " + deleteOrdersRow);
		
		response.sendRedirect("/shop/emp/empOrdersList.jsp");
		return;
	} else {
		// id, pw 불일치
		String msg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/emp/cancelEmpOrdersForm.jsp?msg=" + msg);
		return;
	}

%>