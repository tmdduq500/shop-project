<%@page import="java.util.*"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
<link href="/shop/css/bootstrap.css" rel="stylesheet" type="text/css">
<%
	//전체 goods 수
	int totalGoodsRow = GoodsDAO.selectTotalGoods();
	
	/* 카테고리명, 카테고리 별 상품 수 구하기 */
	ArrayList<HashMap<String, Object>> goodsCntPerCategory = GoodsDAO.selectGoodsCntPerCategory();
%>
<div class="w3-sidebar w3-light-grey w3-bar-block" style="width:15%">
	<h3 class="w3-bar-item">카테고리</h3>

	<a href="/shop/emp/goods/goodsList.jsp" class="w3-bar-item w3-button">전체(<%=totalGoodsRow%>)</a>
	<%
		for(HashMap m : goodsCntPerCategory) {
	%>

			<a href="/shop/emp/goods/goodsList.jsp?category=<%=(String)(m.get("category")) %>" class="w3-bar-item w3-button">
				<%=(String)(m.get("category")) %>
				(<%=(Integer)(m.get("cnt")) %>)
			</a>

	<% 
		}
	%>
</div>