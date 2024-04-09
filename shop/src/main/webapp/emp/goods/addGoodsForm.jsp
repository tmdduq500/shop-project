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
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-6">
		<div class="w3-border w3-round" style="margin-top: 20px;">
			<div class="w3-container w3-dark-grey " style="padding: 10px;">
				<h1>상품 등록</h1>
			</div>	
			
			<div class="w3-card-4" style="padding-top: 15px;">
				<form class="w3-container" action="/shop/emp/goods/addGoodsAction.jsp" method="post" enctype="multipart/form-data">
				
					<div>
						<label>카테고리</label>
						<select class="w3-select" name="category" required="required">
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
						<label>상품명</label>
						<input class="w3-input" type="text" name="goodsTitle" required="required">
					</div>
					
					<div>
						<label>이미지</label>
						<input class="w3-input" type="file" name="goodsImg" required="required">
					</div>
					
					<div>
						<label>가격</label>
						<input class="w3-input" type="number" name="goodsPrice" required="required">
					</div>
					
					<div>
						<label>수량</label>
						<input class="w3-input" type="number" name="goodsAmount" required="required">
					</div>
					
					<div>
						<label>설명</label>
						<textarea class="w3-input" rows="5" cols="50" name="goodsContent" required="required"></textarea>
					</div>
					
					<div>
						<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" style="width: 60%; margin: 0 auto;" type="submit">상품 등록</button>
					</div>
				</form>
			</div>
		</div>
		
	</div>
	
	<div class="col"></div>
</div>

</body>
</html>