<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));	
%>
<%
	// DB연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	// 고객 정보 가져오는 쿼리
	String getCustomerInfoSql = "SELECT id, name, birth, gender, update_date updateDate, create_date createDate FROM customer WHERE id = ?";
	PreparedStatement getCustomerInfoStmt = null;
	ResultSet getCustomerInfoRs = null;
	
	getCustomerInfoStmt = conn.prepareStatement(getCustomerInfoSql);
	getCustomerInfoStmt.setString(1, (String)(loginCustomerMember.get("customerId")));
	getCustomerInfoRs = getCustomerInfoStmt.executeQuery();
	
	HashMap<String, Object> customerInfo = new HashMap<String, Object>();
	if(getCustomerInfoRs.next()) {
		customerInfo.put("customerId", getCustomerInfoRs.getString("id"));
		customerInfo.put("customerName", getCustomerInfoRs.getString("name"));
		customerInfo.put("customerBirth", getCustomerInfoRs.getString("birth"));
		customerInfo.put("customerGender", getCustomerInfoRs.getString("gender"));
		customerInfo.put("updateDate", getCustomerInfoRs.getString("updateDate"));
		customerInfo.put("createDate", getCustomerInfoRs.getString("createDate"));
	}
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