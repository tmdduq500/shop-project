<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<!-- Model Layer -->
<%
	// 1. 특수한 형태의 데이터(RDBMS:mariaDB)
	// 2. API 사용(JDBC API)해 자료구조(ResultSet) 획득
	// 3. 일반화된 자료구조(ex. List, Set 등)로 변경 -> 모델 획득
	
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

%>

<%
	/* emp목록 페이징 */
	
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("empList - currentPage = " + currentPage);
	
	// 페이지당 보여줄 row 수
	int rowPerPage = 10;
	
// 	// select 박스로 rowPerPage 구하기
// 	if(request.getParameter("rowPerPage") != null) {
// 		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
// 	}

	// 전체 emp 수 구하기
	String getTotalRowSql = "SELECT COUNT(*) cnt FROM emp";
	PreparedStatement getTotalRowStmt = null;
	getTotalRowStmt = conn.prepareStatement(getTotalRowSql);
	ResultSet getTotalRowRs = getTotalRowStmt.executeQuery();
	
	int totalRow = 0;
	if(getTotalRowRs.next()) {
		totalRow = getTotalRowRs.getInt("cnt");
	}
	System.out.println("empList - totalRow = " + totalRow);
	
	// 마지막 페이지 구하기
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage += 1;
	}
	System.out.println("empList - lastPage = " + lastPage);
	
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;
	System.out.println("empList - startRow = " + startRow);
%>

<%
	/*
	[DB]shop.emp 테이블 가져오는 SQL쿼리
	
	SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active 
	FROM emp
	ORDER BY active ASC, hire_date DESC
	*/
	String getEmpSql = "SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active FROM emp ORDER BY hire_date ASC LIMIT ?,?";
	PreparedStatement getEmpStmt = null; 
	ResultSet getEmpRs = null;
	getEmpStmt = conn.prepareStatement(getEmpSql);
	getEmpStmt.setInt(1, startRow);
	getEmpStmt.setInt(2, rowPerPage);
	getEmpRs = getEmpStmt.executeQuery();
	
	// JDBC API에 종속된 자료구조 모델인 ResultSet -> 기본 API (ArrayList)로 변경
	ArrayList<HashMap<String, Object>> empList = new ArrayList<HashMap<String,Object>>();
	
	// ResultSet -> ArrayList<HashMap<String, Object>>
	while(getEmpRs.next()) {
		HashMap<String, Object> empMap = new HashMap<String, Object>();
		empMap.put("empId", getEmpRs.getString("empId"));
		empMap.put("empName", getEmpRs.getString("empName"));
		empMap.put("empJob", getEmpRs.getString("empJob"));
		empMap.put("hireDate", getEmpRs.getString("hireDate"));
		empMap.put("active", getEmpRs.getString("active"));
		empList.add(empMap);
	}
%>

<!-- View Layer : 모델(ArrayList<HashMap<String, Object>>) 출력 -->
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<div>
		<a href="/shop/emp/empLogoutAction.jsp">
			로그아웃
		</a>
	</div>
	
	
	<div style="display:table;">
		<h1>사원 목록</h1>	
		
		<div style="display:table-row">
			<div style="display:table-cell">직원 id</div>
			<div style="display:table-cell">직원 이름</div>
			<div style="display:table-cell">직급</div>
			<div style="display:table-cell">고용일자</div>
			<div style="display:table-cell">권한</div>
		</div>
		
		<%
			for(HashMap<String, Object> m : empList) {
		%>
				
					
					<div style="display:table-row">
						<div style="display:table-cell"><%=m.get("empId") %></div>
						<div style="display:table-cell"><%=m.get("empName") %></div>
						<div style="display:table-cell"><%=m.get("empJob") %></div>
						<div style="display:table-cell"><%=m.get("hireDate") %></div>
						<form action="/shop/emp/modifyEmpActive.jsp" method="post">
							<div style="display:table-cell">
								<input type="hidden" name="empId" value="<%=m.get("empId") %>">
								<input type="hidden" name="active" value="<%=m.get("active") %>">
								<button type="submit"><%=m.get("active") %></button>
							</div>
						</form>
					</div>
				
		<%
			}
		%>
	</div>	
	
	<div>
		<!-- 페이징 버튼 -->
		
		<%
			if(currentPage > 1) {
		%>	
			<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
			<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		<%		
			} else {
		%>
				<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
		<%		
			}

			if(currentPage < lastPage) {
		%>
				<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
				<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
		<%		
			}
		%>

			

	</div>
		
</body>
</html>