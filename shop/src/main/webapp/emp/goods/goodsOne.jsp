<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");
	// 요청 값 디버깅
	System.out.println("goodsOne - goodsNo = " + goodsNo);
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* 상품 하나의 모든 정보 가져오는 쿼리 */
	String getGoodsInfoSql = "SELECT category, emp_id empId, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount, create_date createDate FROM goods WHERE goods_no = ?";
	PreparedStatement getGoodsInfoStmt = null;
	ResultSet getGoodsInfoRs = null;
	getGoodsInfoStmt = conn.prepareStatement(getGoodsInfoSql);
	getGoodsInfoStmt.setString(1, goodsNo);
	getGoodsInfoRs = getGoodsInfoStmt.executeQuery();
	
	HashMap<String, Object> goodsInfo = new HashMap<String, Object>();
	while(getGoodsInfoRs.next()) {
		goodsInfo.put("category", getGoodsInfoRs.getString("category"));
		goodsInfo.put("empId", getGoodsInfoRs.getString("empId"));
		goodsInfo.put("goodsTitle", getGoodsInfoRs.getString("goodsTitle"));
		goodsInfo.put("imgName", getGoodsInfoRs.getString("imgName"));
		goodsInfo.put("goodsContent", getGoodsInfoRs.getString("goodsContent"));
		goodsInfo.put("goodsPrice", getGoodsInfoRs.getString("goodsPrice"));
		goodsInfo.put("goodsAmount", getGoodsInfoRs.getString("goodsAmount"));
		goodsInfo.put("createDate", getGoodsInfoRs.getString("createDate"));

	}
	
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<link href="/shop/emp/css/emp.css" rel="stylesheet" type="text/css">
</head>
<body style="height: 100vh;">
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	
	<div style="width: 1000px; height:500px; text-align: center;">
	
		<div style="display: inline-block; ">
			<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName") %>" style="height: 400px;">
		</div>	
	
		<div style="display: inline-block; height: 400px; margin-top: 30px;">

			<div class="my-table-row" >
				<div class="my-table-cell">상품 번호</div>
				<div class="my-table-cell">
					<%=goodsNo %>
				</div>
			</div>
			
			<div class="my-table-row" >
				<div class="my-table-cell">카테고리</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("category") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">관리자</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("empId") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">상품명</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("goodsTitle") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">설명</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("goodsContent") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">가격</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("goodsPrice") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">수량</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("goodsAmount") %>
				</div>
			</div>
			
			<div class="my-table-row">
				<div class="my-table-cell">등록일</div>
				<div class="my-table-cell">
					<%=goodsInfo.get("createDate") %>
				</div>
			</div>
			
		</div>
		
		<div>
			<a href="/shop/goods/updateGoodsForm.jsp?goodsNo=<%=goodsNo%>">수정</a>
			<a href="/shop/goods/deleteGoodsForm.jsp?goodsNo=<%=goodsNo%>">삭제</a>
		</div>
	</div>
</body>
</html>