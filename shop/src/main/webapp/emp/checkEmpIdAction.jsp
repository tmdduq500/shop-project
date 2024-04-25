<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>

<%
	// 요청 값
	String empId = request.getParameter("empId");

	// 요청 값 디버깅
	System.out.println("checkEmpIdAction - empId = " + empId);


	// 요청 값 하나라도 null이거나 공백일 경우
	if(empId == null) {
		
		String errMsg = URLEncoder.encode("ID를 정확히 입력해주세요.", "UTF-8");
		response.sendRedirect("/shop/customer/signup/insertCustomerForm.jsp?errMsg=" + errMsg);
		return;
	}
	
%>

<%
	// emp 아이디 중복 체크
	boolean canUseId = EmpDAO.checkDuplicatedEmpId(empId);
	
	if(canUseId) {
		// 아이디 사용 가능
		String errMsg = URLEncoder.encode("사용 가능한 아이디 입니다", "UTF-8");
		response.sendRedirect("/shop/emp/insertEmpForm.jsp?errMsg=" + errMsg + "&empId=" + empId);
		
	} else {
		// 아이디가 중복
		String errMsg = URLEncoder.encode("이미 존재하는 ID입니다.", "UTF-8");
		response.sendRedirect("/shop/emp/insertEmpForm.jsp?errMsg=" + errMsg);
	}
	
%>