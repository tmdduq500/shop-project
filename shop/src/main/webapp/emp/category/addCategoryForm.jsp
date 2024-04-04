<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 추가</title>
</head>
<body>
	<h1>카테고리 추가</h1>
	
	<form action="/shop/emp/category/addCategoryAction.jsp" method="post">
		<div>
			카테고리 이름 : 
			<input type="text" name="category">
		</div>
				
		<div>
			<button type="submit">카테고리 추가</button>
		</div>
	</form>
</body>
</html>