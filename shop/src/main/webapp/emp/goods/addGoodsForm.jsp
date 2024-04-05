<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	String getCategorySql = "SELECT category FROM category";
	PreparedStatement getCategoryStmt = null;
	ResultSet getCategoryRs = null;
	getCategoryStmt = conn.prepareStatement(getCategorySql);
	getCategoryRs = getCategoryStmt.executeQuery();
	
	ArrayList<String> categoryList = new ArrayList<String>();
	while(getCategoryRs.next()) {
		categoryList.add(getCategoryRs.getString("category"));
	}
%>

<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
</head>
<body>
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
	<h1>상품 등록</h1>
	
	<form action="/shop/emp/goods/addGoodsAction.jsp" method="post" enctype="multipart/form-data">
	
		<div>
			category : 
			<select name="category">
				<option value="">선택</option>
				<%
					for(String s : categoryList) {
				%>
						<option value="<%=s%>"><%=s%></option>
				<%
					}
				%>
			</select>
		</div>
		
		<!-- emp_id값은 action쪽에서 세션변수에서 바인딩 -->
		<div>
			goodsTitle : 
			<input type="text" name="goodsTitle">
		</div>
		
		<div>
			goodsImage : 
			<input type="file" name="goodsImg">
		</div>
		
		<div>
			goodsPrice : 
			<input type="number" name="goodsPrice">
		</div>
		
		<div>
			goodsAmount : 
			<input type="number" name="goodsAmount">
		</div>
		
		<div>
			<div>
				goodsContent :
			</div>
			 
			<textarea rows="5" cols="50" name="goodsContent"></textarea>
		</div>
		
		<div>
			<button type="submit">상품 등록</button>
		</div>
	</form>
</body>
</html>