<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>

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
	
	
	int TotalEmpRow = EmpDAO.selectTotalEmp();
	System.out.println("empList - TotalEmpRow = " + TotalEmpRow);
	
	// 마지막 페이지 구하기
	int lastPage = TotalEmpRow / rowPerPage;
	if(TotalEmpRow % rowPerPage != 0) {
		lastPage += 1;
	}
	System.out.println("empList - lastPage = " + lastPage);
	
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;
	System.out.println("empList - startRow = " + startRow);
%>

<%
	// 전체 emp 목록 가져오기
	ArrayList<HashMap<String, Object>> empList = EmpDAO.selectEmpList(startRow, rowPerPage);
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
	<title>emp 목록</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	<div class="col">
	
	</div>
	
	<div class="col-8">
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체: 클라이언트) -->
		<!-- 주체가 서버이기때문에 include할때는 절대주소가 /shop/...으로 시작하지 않는다 -->
		
		
		
		<!-- emp목록 출력 -->
		<div class="w3-panel w3-border w3-round-small">
		
			<div style="margin: 20px auto;">
				<h1>사원 목록</h1>
			</div>
				
			<table class="table table-hover" style="table-layout: fixed;">
				<thead>
					<tr>
						<th width="40%">직원 id</th>
						<th width="15%">직원 이름</th>
						<th width="15%">직급</th>
						<th width="15%">고용일자</th>
						<th width="15%">권한</th>
					</tr>
				</thead>
				
				<tbody>
				<%
					for(HashMap<String, Object> m : empList) {
				%>
						
						
						<tr>
							<td><%=m.get("empId") %></td>
							<td><%=m.get("empName") %></td>
							<td><%=m.get("empJob") %></td>
							<td><%=m.get("hireDate") %></td>
							<td>
								<form action="/shop/emp/modifyEmpActive.jsp" method="post">
									<input type="hidden" name="empId" value="<%=m.get("empId") %>">
									<input type="hidden" name="active" value="<%=m.get("active") %>">
									<%
										// grade가 0보다 클 경우 active ON,OFF 권한 부여
										if((Integer)(getSessionMap.get("grade")) > 0) {
									%>
											<div class="form-check form-switch">
												<%
													if(m.get("active").equals("ON")) {	
												%>
														<input class="form-check-input" type="checkbox" name="active" value="<%=m.get("active") %>" checked="checked">
												<%
													} else {
												%>
														<input class="form-check-input" type="checkbox" name="active" value="<%=m.get("active") %>">
												<%
													}
												%>
												<button type="submit" class="btn btn-outline-danger btn-sm">변경</button>
											</div>
									<%
										} else {
									%>
											<div class="form-check form-switch">
												<%
													if(m.get("active").equals("ON")) {	
												%>
														<input class="form-check-input" type="checkbox" name="active" value="<%=m.get("active") %>" checked="checked" disabled="disabled">
												<%
													} else {
												%>
														<input class="form-check-input" type="checkbox" name="active" value="<%=m.get("active") %>" disabled="disabled">
												<%
													}
												%>
											</div>
									<%
										}
									%>
								</form>		
							</td>
						</tr>
						
				<%
					}
				%>
				</tbody>
			</table>	
				
				
				<!-- 페이징 버튼 -->	
				<div class="w3-bar w3-center" style="margin-bottom: 10px;">
			
					<%
						if(currentPage > 1) {
					%>	
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
					<%		
						} else {
					%>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=1">이전페이지</a>
					<%		
						}
			
						if(currentPage < lastPage) {
					%>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
					<%		
						} else {
					%>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">다음페이지</a>
							<a class="w3-button" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
					<%
						}
					%>
			
				</div>
			</div>
			
			
	</div>
	
	<div class="col">
	
	</div>
</div>
	
</body>
</html>