<%@page import="shop.dao.CategoryDAO"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// 카테고리 목록 가져오기
	ArrayList<HashMap<String, Object>> categoryList = CategoryDAO.selectCategoryList();
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
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
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
					<form action="/shop/emp/category/insertCategoryForm.jsp">
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
							
								<td>
									<form action="/shop/emp/category/deleteCategoryForm.jsp">
										<input type="hidden" name="category" value="<%=m.get("category")%>">
										<%
											if((Integer)(getSessionMap.get("grade")) > 0) {
										%>
												<button type="submit" class="btn btn-danger btn-sm">삭제</button>
										<%
											} else {
										%>
												<button type="submit" class="btn btn-danger btn-sm" disabled="disabled">삭제</button>
										<%
											}
										%>
									</form>
								</td>
							
							
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