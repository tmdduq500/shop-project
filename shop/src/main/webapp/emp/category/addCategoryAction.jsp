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

	// 요청 값이  null일시
	if(category == null) {
		response.sendRedirect("/shop/emp/category/addCategoryForm.jsp");
	}
	
	// 요청값 디버깅
	System.out.println("addCategoryForm - category = " + category);	
%>

<!-- Controller Layer -->
<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

	/* [DB]shop.category에 category에 추가하는 sql */
	String addCategorySql = "INSERT INTO category(category, emp_id) VALUES (?, ?)";
	PreparedStatement addCategoryStmt = null;
	
	addCategoryStmt = conn.prepareStatement(addCategorySql);
	addCategoryStmt.setString(1, category);
	addCategoryStmt.setString(2, (String)(loginMember.get("empId")));

	int row = addCategoryStmt.executeUpdate();
	
	if(row == 1) {
		// 카테고리 등록 성공
		System.out.println("카테고리 등록 성공");
		response.sendRedirect("/shop/emp/category/categoryList.jsp");
	} else {
		// 카테고리 등록 실패
		System.out.println("카테고리 등록 실패");
		response.sendRedirect("/shop/emp/category/addCategoryForm.jsp");
	}
	
%>