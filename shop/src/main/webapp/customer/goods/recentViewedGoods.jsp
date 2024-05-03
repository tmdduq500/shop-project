<%@page import="java.util.*"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 최근 본 상품 세션 변수 가져오기
	Set<String> recentViewdGoods = (HashSet<String>)session.getAttribute("recentViewdGoods");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>최근 본 상품</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-8">
    <h1>최근 본 상품</h1>
    <div class="row">
        <% 
	        if(recentViewdGoods != null) {
	            for(String goodsNo : recentViewdGoods) {
	                HashMap<String,Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
        %>
		            <div class="col-md-3" style="height: 200px; margin: 20px 10px; width: 15%;">
		                <div class="w3-card-2" style="height: 100%; display: flex; flex-direction: column; justify-content: center;">
		                    <!-- 상품 이미지 -->
		                    <div style="text-align: center;">
		                        <a href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=goodsNo%>" style="display: inline-block;">
		                            <img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>" style="max-width: 100%; max-height: 100%;">
		                        </a>   
		                    </div>
		                </div>
		            </div>
        <% 
				}
       		} 
        %>
	    </div>
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>