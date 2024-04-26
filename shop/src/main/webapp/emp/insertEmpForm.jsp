<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>

<%
	// 요청 값
	String empId = request.getParameter("empId");
	String errMsg = request.getParameter("errMsg");
	
	// empId가 null일 경우 input 태그에 null 표시 하지 않기 위해 
	if(empId == null) {
		empId = "";
	}
	// 디버깅
	System.out.println("insertEmpForm - empId = " + empId);
	
	// 직급 select 하기위해 직급 리스트 가져오는 메서드
	ArrayList<String> empJobList = EmpDAO.selectEmpJobList();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>emp 추가</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col">
		<div class="w3-border w3-round" style="margin-top: 20px;">
		
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>emp 추가</h1>
			</div>	
			
			<div class="w3-card-4">
			
				<!-- emp id 중복 체크-->
				<div>
					<form class="w3-container" action="/shop/emp/checkEmpIdAction.jsp" method="post">
						<label>id 중복 확인</label>
						<div>
							<input class="form-control" type="text" name="empId" style="width: 70%; display: inline-block;">
							<button class="btn btn-outline-secondary" type="submit">중복확인</button>
						</div>
						
						<!-- 에러 메시지 출력 -->
						<%
							if(errMsg != null) { 
						%>
								<span><%=errMsg %></span>
						<%
							}
						%>
						<hr>
					</form>
					
				</div>
				
				<!-- emp 추가 폼 -->
				<div>
					<form class="w3-container" action="/shop/emp/insertEmpAction.jsp" method="post">
						<div>
							<div>
								<label>id</label>
								<input class="w3-input" type="text" value="<%=empId %>" name="empId" required="required" readonly="readonly">
							</div>
							
							<label>pw</label>
							<input class="w3-input" type="password" name=empPw required="required">
							
							<label>이름</label>
							<input class="w3-input" type="text" name="empName" required="required">
							
							<label>직급</label>
							<select class="w3-input" name="empJob" required="required">
								<%
									for(String s : empJobList) {
								%>
										<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
							</select>
							<label>고용일자</label>
							<input class="w3-input" type="date" name="empHireDate" required="required">
							
						</div>
						
						<div style="text-align: center; margin: 10px auto;">
							<button class="btn btn-outline-secondary" type="submit">emp 추가하기</button>
						</div>
						
					</form>
				</div>

			</div>
			
		</div>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>