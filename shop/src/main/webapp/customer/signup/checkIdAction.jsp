<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/customer/inc/CustomerLoginSessionCheck.jsp" %>

<%
	// 요청 값
	String checkIdFirst = request.getParameter("checkIdFirst");
	String checkIdMiddle = request.getParameter("checkIdMiddle");
	String checkIdLast = request.getParameter("checkIdLast");

	// 요청 값 디버깅
	System.out.println("checkIdAction - checkIdFirst = " + checkIdFirst);
	System.out.println("checkIdAction - checkIdMiddle = " + checkIdMiddle); 
	System.out.println("checkIdAction - checkIdLast = " + checkIdLast); 

	// 요청 값 하나라도 null이거나 공백일 경우
	if(checkIdFirst == null || checkIdMiddle == null || checkIdLast == null 
		|| checkIdFirst.equals("") || checkIdMiddle.equals("") || checkIdLast.equals("")) {
		
		String errMsg = URLEncoder.encode("ID를 정확히 입력해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp?errMsg=" + errMsg);
		return;
	}
	// customerID 종합해서 추가
	String checkCustomerId = checkIdFirst + checkIdMiddle + checkIdLast;
	// 요청 값 디버깅
	System.out.println("checkIdAction - checkCustomerId = " + checkCustomerId); 
	
%>

<%
	// 고객 아이디 중복 체크
	boolean canUseId = CustomerDAO.checkDuplicatedId(checkCustomerId);
	
	if(canUseId) {
		// 아이디 사용 가능
		String errMsg = URLEncoder.encode("사용 가능한 아이디 입니다", "UTF-8");
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp?errMsg=" + errMsg + "&customerId=" + checkCustomerId);
		
	} else {
		// 아이디가 중복
		String errMsg = URLEncoder.encode("이미 존재하는 ID입니다.", "UTF-8");
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp?errMsg=" + errMsg);
	}
	
%>