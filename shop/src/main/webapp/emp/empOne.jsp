<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// loginEmp 세션 변수 가져오기
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
	
	// emp 정보 가져오기
	HashMap<String, Object> empInfo = EmpDAO.selectEmpInfo((String)loginMember.get("empId"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>emp마이페이지</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<!-- emp 마이페이지 -->
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
				<tr>
					<td colspan="2">
						<a class="a-to-button" href="/shop/emp/checkInfoUpdateEmp.jsp" style="width: 100%;">정보 수정</a>
					</td>
				</tr>
			</tbody>
		</table>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>