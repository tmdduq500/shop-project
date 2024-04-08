<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 추가</title>
	<link href="/shop/emp/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col-2 w3-container w3-half w3-margin-top" style="height: 90vh; width: 25%;">
		<form class="w3-container w3-card-4 w3-border w3-round-large" action="/shop/emp/category/addCategoryAction.jsp" method="post" style="margin: 50% auto; height: 330px;">
		
			<div style="margin-top: 30px; text-align: center;">
				<h1>카테고리 추가</h1>
			</div>
			
			<div class="form-floating mb-4 mt-5 form-control-lg" style="margin-top: 30px;">
				<input class="w3-input" type="text" name="category" placeholder="카테고리를 입력해주세요">
			</div>
			
			<div class="input-group" style="margin-top: 20px;">
				<button class="w3-button w3-section w3-teal w3-ripple" type="submit" style="width: 100%;">
					카테고리 추가
				</button>
			</div>
			
			
		</form>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>