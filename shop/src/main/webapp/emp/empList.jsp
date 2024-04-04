<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

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

<%
	/* session의 정보 가져오기(어떤 emp가 로그인 돼있고, grade로 권한 부여 설정하기 위해) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!-- View Layer : 모델(ArrayList<HashMap<String, Object>>) 출력 -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empList</title>
	<link href="/shop/emp/css/emp.css" rel="stylesheet" type="text/css">
</head>
<body>
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체: 클라이언트) -->
	<!-- 주체가 서버이기때문에 include할때는 절대주소가 /shop/...으로 시작하지 않는다 -->
	
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	
	<!-- emp목록 출력 -->
	<div style="display:table;">
	
		<div class="list-title">
			<h1>사원 목록</h1>
		</div>
			
		
		<div style="display:table-row">
			<div class="list-cell" style="display:table-cell">직원 id</div>
			<div class="list-cell" style="display:table-cell">직원 이름</div>
			<div class="list-cell" style="display:table-cell">직급</div>
			<div class="list-cell" style="display:table-cell">고용일자</div>
			<div class="list-cell" style="display:table-cell">권한</div>
		</div>
		
		<%
			for(HashMap<String, Object> m : empList) {
		%>
				
					
					<div style="display:table-row">
						<div class="list-cell" style="display:table-cell"><%=m.get("empId") %></div>
						<div class="list-cell" style="display:table-cell"><%=m.get("empName") %></div>
						<div class="list-cell" style="display:table-cell"><%=m.get("empJob") %></div>
						<div class="list-cell" style="display:table-cell"><%=m.get("hireDate") %></div>
						<form action="/shop/emp/modifyEmpActive.jsp" method="post">
							<div class="list-cell" style="display:table-cell">
							<%
								// grade가 0보다 클 경우 active ON,OFF 권한 부여
								if((Integer)(getSessionMap.get("grade")) > 0) {
							%>
									<input type="hidden" name="empId" value="<%=m.get("empId") %>">
									<input type="hidden" name="active" value="<%=m.get("active") %>">
									<button type="submit"><%=m.get("active") %></button>
							<%
								} else {
							%>
									<button disabled="disabled"><%=m.get("active") %></button>
							<%
								}
							%>
								
							</div>
						</form>
					</div>
				
		<%
			}
		%>
	</div>
	
	<!-- 페이징 버튼 -->	
	<div>

		<%
			if(currentPage > 1) {
		%>	
				<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
				<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		<%		
			} else {
		%>
				<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
				<a href="/shop/emp/empList.jsp?currentPage=1">이전페이지</a>
		<%		
			}

			if(currentPage < lastPage) {
		%>
				<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
				<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
		<%		
			} else {
		%>
				<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">다음페이지</a>
				<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
		<%
			}
		%>

	</div>
		
</body>
</html>