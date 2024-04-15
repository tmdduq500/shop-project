<%@page import="shop.dao.CustomerDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
%>
<%
	// 고객 정보 가져오기
	HashMap<String, Object> customerInfo = CustomerDAO.getCustomerInfo((String)loginCustomerMember.get("customerId"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<td colspan="3">
						<h1><%=customerInfo.get("customerName") %>의 상세정보</h1>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>고객 ID</th>
					<td>
						<%=customerInfo.get("customerId") %>
					</td>
				</tr>
				<tr>
					<th>고객 이름</th>
					<td>
						<%=customerInfo.get("customerName") %>
					</td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td>
						<%=customerInfo.get("customerBirth") %>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<%=customerInfo.get("customerGender") %>
					</td>
				</tr>
				<tr>
					<th>정보 수정일</th>
					<td>
						<%=customerInfo.get("updateDate") %>
					</td>
				</tr>
				<tr>
					<th>정보 생성일</th>
					<td>
						<%=customerInfo.get("createDate") %>
					</td>
				</tr>
			</tbody>
		</table>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>