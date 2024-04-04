<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>


<!-- Model Layer -->
<%
	// 요청 값
	String category = request.getParameter("category");
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청 값 디버깅
	System.out.println("deleteCategoryAction - category = " + category);
	System.out.println("deleteCategoryAction - empId = " + empId);
	System.out.println("deleteCategoryAction - empPw = " + empPw);
%>
<%
	/* session의 정보 가져오기(grade가 0이 아닐때 삭제 하기 위해) */
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* [DB]shop.emp에서 id와 pw가 일치하는지 확인하고, grade를 가져오는 쿼리 */
	String checkEmpInfoSql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = PASSWORD(?)";
	PreparedStatement checkEmpInfoStmt = null;
	ResultSet checkEmpInfoRs = null;
	checkEmpInfoStmt = conn.prepareStatement(checkEmpInfoSql);
	checkEmpInfoStmt.setString(1, empId);
	checkEmpInfoStmt.setString(2, empPw);
	checkEmpInfoRs = checkEmpInfoStmt.executeQuery();
	
	// id, pw가 일치한다면
	if(checkEmpInfoRs.next()) {
		// grade가 0이 아니면 삭제
		System.out.println("deleteCategoryAction - grade = " + (int)(loginMember.get("grade")));
		if((int)(loginMember.get("grade")) > 0) {
			String deleteCategorySql = "DELETE FROM category WHERE category = ?";
			PreparedStatement deleteCategoryStmt = null;
			
			deleteCategoryStmt = conn.prepareStatement(deleteCategorySql);
			deleteCategoryStmt.setString(1, category);
			
			// 삭제됐는지
			int row = deleteCategoryStmt.executeUpdate();
			System.out.println("deleteCategoryAction - row = " + row);	// 삭제 됐는지 디버깅
			
			response.sendRedirect("/shop/emp/category/categoryList.jsp");
		} else {
			System.out.println("grade 0 아님 ");
			// grade가 0이 아님
			response.sendRedirect("/shop/emp/category/deleteCategoryForm.jsp?category=" + category);
		}
	} else {
		// id, pw 불일치
		System.out.println("id, pw 불일치 ");
		response.sendRedirect("/shop/emp/category/deleteCategoryForm.jsp?category=" + category);
	}
	
%>