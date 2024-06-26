<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/customerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
%>
<%
	// 요청 값 
	String customerId = request.getParameter("customerId");
	String customerName = request.getParameter("customerName");
	String customerBirth = request.getParameter("customerBirth");
	String customerGender = request.getParameter("customerGender");
	String oldCustomerPw = request.getParameter("customerPw");
	String newCustomerPw = request.getParameter("newCustomerPw");
	String newCustomerPwCheck = request.getParameter("newCustomerPwCheck");
	
	// 디버깅
	System.out.println("updateCustomerAction - customerId = " + customerId);
	System.out.println("updateCustomerAction - customerName = " + customerName);
	System.out.println("updateCustomerAction - customerBirth = " + customerBirth);
	System.out.println("updateCustomerAction - customerGender = " + customerGender);
	System.out.println("updateCustomerAction - oldCustomerPw = " + oldCustomerPw);
	System.out.println("updateCustomerAction - newCustomerPw = " + newCustomerPw);
	System.out.println("updateCustomerAction - newCustomerPwCheck = " + newCustomerPwCheck);
	
	// 요청 값 null일 경우
	if(customerId == null || customerName == null || customerBirth == null || customerGender == null) {
		response.sendRedirect("/shop/customer/goods/customerGoodsList.jsp");
		return;
	}
%>
<%
	// 새 비밀번호와 새 비밀번호 확인 값이 다를 경우
	if(!newCustomerPw.equals(newCustomerPwCheck)) {
		String msg = URLEncoder.encode("회원정보 수정에 실패했습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/customer/checkInfoUpdateCustomer.jsp?msg=" + msg);
		return;
	}

	// 고객 정보 수정하기
	int updateCustomerRow = CustomerDAO.updateCustomer(customerId, customerName, customerBirth, customerGender);

	// 새 비밀번호와 새 비밀번호 값이 같고, null이나 공백이 아닐경우
	if(newCustomerPw.equals(newCustomerPwCheck) && !newCustomerPw.equals("") && newCustomerPw != null) {
		// 새 비밀번호가 pw history에 있는지 확인
		boolean canUsePw = CustomerDAO.checkCustomerPwHistory(customerId, newCustomerPw);
		// 디버깅
		System.out.println("updateCustomerAction - canUsePw = " + canUsePw);
		// 새비밀번호 사용 가능하면
		if(canUsePw) {
			// 고객 비밀번호 히스토리 테이블에 데이터 추가
			int changeCustomerPwRow = CustomerDAO.insertCustomerPw(customerId, newCustomerPw);
			// 디버깅
			System.out.println("updateCustomerAction - changeCustomerPwRow = " + changeCustomerPwRow);
		} else {
			// 사용 불가능
			String msg = URLEncoder.encode("이전에 사용했던 비밀번호입니다. 다른 비밀번호를 사용해주세요", "UTF-8");
			response.sendRedirect("/shop/customer/checkInfoUpdateCustomer.jsp?msg=" + msg);
			return;
		}
	}

	// 고객 정보 수정 실패
	if(updateCustomerRow == 0) {
		String msg = URLEncoder.encode("회원정보 수정에 실패했습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/customer/checkInfoUpdateCustomer.jsp?msg=" + msg);
		return;
	}
	
	// 고객 정보 수정 성공 및 loginCustomer 세션 값 변경
	HashMap<String, Object> newCustomer = new HashMap<String,Object>();
	HashMap<String, Object> updateCustomer = CustomerDAO.selectCustomerInfo(customerId);
	newCustomer.put("customerId", updateCustomer.get("customerId"));
	newCustomer.put("customerName", updateCustomer.get("customerName"));
	session.setAttribute("loginCustomer", newCustomer);
	response.sendRedirect("/shop/customer/customerOne.jsp");
%>