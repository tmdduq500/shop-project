<%@page import="java.util.ArrayList"%>
<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// 요청값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	// 디버깅
	System.out.println("udpateEmpForm - empId = " + empId);
	System.out.println("udpateEmpForm - empPw = " + empPw);
%>
<%
	// ID, PW 체크
	boolean isEmp = EmpDAO.checkEmpIdPw(empId, empPw);
	//id,pw가 불일치할 경우
	if(!isEmp) {
		String msg = URLEncoder.encode("id, pw를 다시 확인해주세요", "UTF-8");
		response.sendRedirect("/shop/emp/checkInfoUpdateEmp.jsp?msg=" + msg);
		return;
	}
	// emp 정보 가져오기
	HashMap<String, Object> empInfo =  EmpDAO.selectEmpInfo(empId);
	
	// 직급 select 하기위해 직급 리스트 가져오는 메서드
	ArrayList<String> empJobList = EmpDAO.selectEmpJobList();
%>
<%
	// msg 출력
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>emp정보 수정</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<div style="text-align: center;">
			<%
				if(msg != null) {
			%>
					<%=msg %>
			<%
				}
			%>
		</div>
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey" style="padding: 10px;">
				<h1>emp정보 수정</h1>
			</div>
			
			<div class="w3-card-4">
				<form class="w3-container" action="/shop/emp/updateEmpAction.jsp" method="post">
					<div>
						<label style="margin: 10px;">emp ID</label>
						<input class="w3-input" type="text" name="empId" value="<%=empInfo.get("empId")%>" readonly="readonly">
						<input type="hidden" name="empPw" value="<%=empPw%>">
					</div>
					
					<div>
						<label style="margin: 10px;">emp 이름</label>
						<input class="w3-input" type="text" name="empName" value="<%=empInfo.get("empName")%>" required="required">
					</div>
					
					<div>
						<label style="margin: 10px;">직급</label>
						<select class="w3-input" name="empJob" required="required">
							<%
								for(String s : empJobList) {
									if(empInfo.get("empJob").equals(s)) {
							%>
										<option value="<%=s%>" selected="selected"><%=s%></option>
							<%
									} else {
							%>
										<option value="<%=s%>"><%=s%></option>
							<%
									}
								}
							%>
						</select>
					</div>
					
					<div>
						<label style="margin: 10px;">고용일</label>
						<input class="w3-input" type="datetime" name="hireDate" value="<%=empInfo.get("hireDate") %>" readonly="readonly">
					</div>
					
					<div>
						
						<label style="margin: 10px;">새 비밀번호</label>
						<div>
							<input class="w3-input" type="password" name="newEmpPw" placeholder="새 비밀번호를 입력해주세요">
						</div>
						
						<label style="margin: 10px;">새 비밀번호 확인</label>
						<div>
							<input class="w3-input" type="password" name="newEmpPwCheck" placeholder="새 비밀번호를 다시 입력해주세요">
						</div>
					</div>
					
					<div style="text-align: center; margin: 10px auto;">
						<button class="btn btn-outline-secondary" type="submit" style="width: 80%; margin: 20px;">
							변경하기
						</button>
					</div>
		
				</form>
			</div>
		</div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>