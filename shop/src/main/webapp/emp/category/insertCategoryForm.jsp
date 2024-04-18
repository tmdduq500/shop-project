<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 추가</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	<div class="col"></div>
	
	<div class="col-3">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey" style="padding: 10px;">
				<h1>카테고리 추가</h1>
			</div>
			
			<div class="w3-card-4" style="padding: 5%;">
				<form class="w3-container" action="/shop/emp/category/insertCategoryAction.jsp" method="post">
					<label style="margin: 20px;">카테고리</label>
					
					<div style="margin: 10px;">
						<input class="w3-input" type="text" name="category" placeholder="카테고리를 입력해주세요">
					</div>
					
					<div style="text-align: center;">
						<button class="w3-button w3-section w3-dark-grey w3-ripple" type="submit" style="width: 80%; margin: 20px;">
							카테고리 추가
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