<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!-- Model Layer -->
<%
	// 요청 값
	String category = request.getParameter("category");

	// 요청 값 디버깅
	System.out.println("deleteCategoryForm - category = " + category);
%>
<%
	/* session의 정보 가져오기(grade별로 카테고리 삭제 권한 설정하기 위해) */
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 삭제</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
		
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey" style="padding: 10px;">
				<h1>카테고리 삭제</h1>
			</div>	
			
			<div class="w3-card-4" style="padding: 5%;">
				<form class="w3-container" action="/shop/emp/category/deleteCategoryAction.jsp" method="post">
					<div>
						<label>삭제하려는 카테고리는</label>
						<input type="text" value="<%=category%>" name="category" readonly="readonly" style="text-align: center;">
						<label>입니다.</label>
						
						<br>
						
						<label>
							삭제할 경우 해당 카테고리의 <strong>모든 상품들이 삭제됩니다</strong>
							<br>정말 삭제하시려면 id 와 pw를 입력해주세요.
						</label>
					</div>
					
					<div style="margin-top: 20px;">
						<label>id</label>
						<input class="w3-input" type="text" name="empId" value="<%=loginMember.get("empId")%>" readonly="readonly">
					</div>
					
					<div>
						<label>pw</label>
						<input class="w3-input" type="password" name="empPw">
					</div>
							
					<div style="text-align: center; margin: 10px auto;">
						<button class="btn btn-outline-secondary" type="submit">카테고리 삭제</button>
					</div>
				</form>
			</div>
		</div>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>