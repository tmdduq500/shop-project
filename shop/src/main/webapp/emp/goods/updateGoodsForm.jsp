<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.awt.font.ImageGraphicAttribute"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
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
	// 상품 정보 가져오기 
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);

	// 카테고리 목록 가져오기
	ArrayList<String> categoryList = GoodsDAO.selectCategoryList();
	
%>
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
		<div class="w3-container w3-dark-grey w3-border w3-round" style="padding: 10px; margin-top: 10px">
			<h1>상품 수정</h1>
		</div>
		
		<div class="w3-card-4" style="padding-top: 15px;">
			<form class="w3-container" action="/shop/emp/goods/updateGoodsAction.jsp" method="post" enctype="multipart/form-data">
			
				<div>
					<label>상품 번호</label>
					<input class="w3-input" type="text" name="goodsNo" value="<%=goodsNo%>" readonly="readonly">
				</div>
				
				<div>
					<label>카테고리</label>
					<select class="w3-select" name="category" required="required">
						<option value="">선택</option>
						<%
							for(String s : categoryList) {
								if(goodsInfo.get("category").equals(s)) {
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
				
				<!-- emp_id값은 action쪽에서 세션변수에서 바인딩 -->
				<div>
					<label>관리자</label>
					<input class="w3-input" type="text" name="empId" value="<%=goodsInfo.get("empId")%>" readonly="readonly">
				</div>
				
				<div>
					<label>상품명</label>
					<input class="w3-input" type="text" name="goodsTitle" value="<%=goodsInfo.get("goodsTitle")%>" required="required">
				</div>
				
				<div>
					<div>
						<div>
							<label>기존 이미지</label>
						</div>
						<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>">
						<input class="w3-input" type="hidden" name="existImgName" value="<%=goodsInfo.get("imgName")%>">
					</div>
					
					<label>변경할 이미지</label>
					<input class="w3-input" type="file" name="newGoodsImg">
				</div>
				
				<div>
					<label>가격</label>
					<input class="w3-input" type="number" name="goodsPrice" value="<%=goodsInfo.get("goodsPrice")%>" required="required">
				</div>
				
				<div>
					<label>수량</label> 
					<input class="w3-input" type="number" name="goodsAmount" value="<%=goodsInfo.get("goodsAmount")%>" required="required">
				</div>
				
				<div>
					<div>
						<label>설명</label>
					</div>
					 
					<textarea class="w3-input" rows="5" cols="50" name="goodsContent"><%=goodsInfo.get("goodsContent")%></textarea>
				</div>
				
				<div>
					<button class="w3-button w3-section w3-block w3-dark-grey w3-ripple" type="submit">상품 수정</button>
				</div>
			</form>
		</div>
	</div>

	<div class="col"></div>
</div>

</body>
</html>