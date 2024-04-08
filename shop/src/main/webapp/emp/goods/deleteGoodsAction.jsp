<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값
	String goodsNo = request.getParameter("goodsNo");
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청 값 디버깅
	System.out.println("deleteGoodsAction - goodsNo = " + goodsNo);
	System.out.println("deleteGoodsAction - empId = " + empId);
	System.out.println("deleteGoodsAction - empPw = " + empPw);
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	// [DB]shop.emp에서 id,pw 확인
	String checkEmpSql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = PASSWORD(?)";
	PreparedStatement checkEmpStmt = null;
	ResultSet checkEmpRs = null;
	
	checkEmpStmt = conn.prepareStatement(checkEmpSql);
	checkEmpStmt.setString(1, empId);
	checkEmpStmt.setString(2, empPw);
	checkEmpRs = checkEmpStmt.executeQuery();
	
	// id, pw가 일치한다면
	if(checkEmpRs.next()) {
		// 상품 삭제 쿼리
		String deleteGoodsSql = "DELETE FROM goods WHERE goods_no = ?";
		PreparedStatement deleteGoodsStmt = null;
		deleteGoodsStmt = conn.prepareStatement(deleteGoodsSql);
		deleteGoodsStmt.setString(1, goodsNo);
		int row = deleteGoodsStmt.executeUpdate();
		
		System.out.println("deleteGoodsAction - row = " + row);
		
		System.out.println("상품 삭제 성공");
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
	} else {
		// 상품 삭제 실패
		System.out.println("상품 삭제 실패");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	}
%>