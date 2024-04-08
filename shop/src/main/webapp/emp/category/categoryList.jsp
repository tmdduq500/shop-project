<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* [DB]shop.category에서 category와 생성일 가져오는 쿼리 */
	String getCategorySql = "SELECT category, emp_id empId, LEFT(create_date,16) createDate FROM category ORDER BY createDate DESC";
	PreparedStatement getCategoryStmt = null;
	ResultSet getCategoryRs = null;
	
	getCategoryStmt = conn.prepareStatement(getCategorySql);
	getCategoryRs = getCategoryStmt.executeQuery();
	
	// 자료 구조 변경(ResultSet --> ArrayList<HashMap>)
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
	while(getCategoryRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", getCategoryRs.getString("category"));
		m.put("empId", getCategoryRs.getString("empId"));
		m.put("createDate", getCategoryRs.getString("createDate"));
		categoryList.add(m);
	}
%>
<%
	/* session의 정보 가져오기(grade별로 카테고리 삭제 권한 설정하기 위해) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 목록</title>
	<link href="/shop/emp/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col-5">

		<!-- category 목록 출력 -->
		<div class="w3-panel w3-border w3-round-small">
			<div class="row" style="margin: 20px auto;">
				<div class="col">
					<h1>category 목록</h1>
				</div>
			
				<div class="col" style="text-align: right;">
					<form action="/shop/emp/category/addCategoryForm.jsp">
						<button type="submit" class="btn btn-outline-dark">카테고리 추가</button>
					</form>
				</div>
			</div>
					
				
			<table class="table table-hover" style="margin-bottom: 30px;">
				<thead>
					<tr>
						<th>카테고리</th>
						<th>생성한 사람</th>
						<th>생성일</th>
						<th>삭제</th>
					</tr>
				</thead>

			<%
				for(HashMap<String, Object> m : categoryList) {
			%>
					<tbody>
						<tr>
							<td><%=m.get("category") %></td>
							<td><%=m.get("empId") %></td>
							<td><%=m.get("createDate") %></td>
							<%
								if((Integer)(getSessionMap.get("grade")) > 0) {
							%>
									<td>
										<form action="/shop/emp/category/deleteCategoryForm.jsp">
											<input type="hidden" name="category" value="<%=m.get("category")%>">
										</form>
										<button type="submit" class="btn btn-danger btn-sm">삭제</button>
									</td>
							<%
								}
							%>
							
						</tr>
					</tbody>
			<%
				}
			%>
			</table>
		</div>
	</div>
		
	<div class="col"></div>
</div>

</body>
</html>