<%@page import="shop.dao.CategoryDAO"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!-- Session 설정 값 : 입력할 때 로그인한 emp의 emp_id값이 필요하기 때문! -->
<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<!-- Model Layer -->
<%
	// 요청 값 분석
	String category = request.getParameter("category");

	// 요청 값이 null일 경우
	if(category == null) {
		response.sendRedirect("/shop/emp/category/insertCategoryForm.jsp");
	}
	
	// 요청값 디버깅
	System.out.println("insertCategoryForm - category = " + category);	
%>

<%
	int insertCategoryRow = CategoryDAO.insertCategory(category, (String)loginMember.get("empId"));
	
	if(insertCategoryRow == 1) {
		// 카테고리 등록 성공
		System.out.println("카테고리 등록 성공");
		response.sendRedirect("/shop/emp/category/categoryList.jsp");
	} else {
		// 카테고리 등록 실패
		System.out.println("카테고리 등록 실패");
		response.sendRedirect("/shop/emp/category/insertCategoryForm.jsp");
	}
	
%>