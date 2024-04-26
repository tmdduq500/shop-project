<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	/* session의 정보 가져오기(상품 삭제 시 로그인한 id 표시 및 요청 값으로 넘기기 위해) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<%
	// 요청 값
	String goodsNo = request.getParameter("goodsNo");

	// 요청 값 디버깅
	System.out.println("deleteGoodsForm - goodsNo = " + goodsNo);
%>

<%
	// 상품 정보 일부분 가져오기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 삭제</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>
	
	<div class="col-4">
		<div class="w3-container w3-dark-grey w3-border w3-round" style="padding: 10px; margin-top: 10px">
			<h1>상품 삭제</h1>
		</div>
		
		<div class="w3-card-4" style="padding-top: 15px;">
			<form class="w3-container" action="/shop/emp/goods/deleteGoodsAction.jsp">	
			
				<div>
					<label>상품 번호</label>
					<input class="w3-input" type="text" name="goodsNo" value="<%=goodsNo%>" readonly="readonly">
				</div>
				
				<div>
					<label>카테고리</label>
					<input class="w3-input" type="text" name="goodsNo" value="<%=goodsInfo.get("category")%>" readonly="readonly">
				</div>
				
				<div>
					<label>상품명</label>
					<input class="w3-input" type="text" name="goodsNo" value="<%=goodsInfo.get("goodsTitle")%>" readonly="readonly">
				</div>
				
				<div>
					<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>">
				</div>
				
				<div>
					해당 상품을 삭제하시려면 pw를 입력해주세요.
				</div>
			
				<input class="w3-input" type="hidden" name="goodsNo" value="<%=goodsNo%>">
				<input class="w3-input" type="hidden" name="imgName" value="<%=goodsInfo.get("imgName")%>">
				
				<div style="margin-top: 10px;">
					<label>id</label>
					<input class="w3-input" type="text" name="empId" value="<%=getSessionMap.get("empId")%>" readonly="readonly">
				</div>
				
				<div>
					<label>pw</label>
					<input class="w3-input" type="password" name="empPw">
				</div>
				
				<div style="text-align: center; margin: 10px auto;">
					<button class="btn btn-outline-secondary"  type="submit">삭제</button>
				</div>
			</form>
			
		</div>

	</div>
	
	<div class="col"></div>
</div>
	
</body>
</html>