<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<%
	// 1. 특수한 형태의 데이터(RDBMS:mariaDB)
	// 2. API 사용(JDBC API)해 자료구조(ResultSet) 획득
	// 3. 일반화된 자료구조(ex. List, Set 등)로 변경 -> 모델 획득
	
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	// [DB]shop.emp에서 empId의 모든 정보 가져오는 쿼리
	String getEmpDataSql = "SELECT emp_id empId, grade, emp_name empName, emp_job empJob, hire_date hireDate, update_date updateDate, create_date createDate, active FROM emp WHERE emp_id = ?";
	PreparedStatement getEmpDataStmt = null;
	ResultSet getEmpDataRs = null;
	
	getEmpDataStmt = conn.prepareStatement(getEmpDataSql);
	getEmpDataStmt.setString(1, (String)(loginMember.get("empId")));
	getEmpDataRs = getEmpDataStmt.executeQuery();
	
	// ResultSet -> HashMap 변환
	HashMap<String, Object> empInfo = new HashMap<String, Object>();
	if(getEmpDataRs.next()) {
		empInfo.put("empId", getEmpDataRs.getString("empId"));
		empInfo.put("grade", getEmpDataRs.getString("grade"));
		empInfo.put("empName", getEmpDataRs.getString("empName"));
		empInfo.put("empJob", getEmpDataRs.getString("empJob"));
		empInfo.put("hireDate", getEmpDataRs.getString("hireDate"));
		empInfo.put("updateDate", getEmpDataRs.getString("updateDate"));
		empInfo.put("createDate", getEmpDataRs.getString("createDate"));
		empInfo.put("active", getEmpDataRs.getString("active"));
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<td colspan="3">
						<h1><%=empInfo.get("empName") %>의 상세정보</h1>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>직원 ID</th>
					<td>
						<%=empInfo.get("empId") %>
					</td>
				</tr>
				<tr>
					<th>권한 등급</th>
					<td>
						<%=empInfo.get("grade") %>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>
						<%=empInfo.get("empName") %>
					</td>
				</tr>
				<tr>
					<th>직급</th>
					<td>
						<%=empInfo.get("empJob") %>
					</td>
				</tr>
				<tr>
					<th>고용일</th>
					<td>
						<%=empInfo.get("hireDate") %>
					</td>
				</tr>
				<tr>
					<th>정보 수정일</th>
					<td>
						<%=empInfo.get("updateDate") %>
					</td>
				</tr>
				<tr>
					<th>정보 생성일</th>
					<td>
						<%=empInfo.get("createDate") %>
					</td>
				</tr>
				<tr>
					<th>권한</th>
					<td>
						<%=empInfo.get("active") %>
					</td>
				</tr>
			</tbody>
		</table>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>