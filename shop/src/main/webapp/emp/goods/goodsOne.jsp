<%@page import="shop.dao.GoodsDAO"%>
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
	// 상품 상세보기
	HashMap<String, Object> goodsInfo = GoodsDAO.selectGoodsInfo(goodsNo);
%>

<%
	/* session의 정보 가져오기(상품을 올린 emp_id가 같거나, grade가 0보다 클때만 상품 수정,삭제 가능) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 상세보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-5">
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<td colspan="3">
						<h1><%=goodsInfo.get("goodsTitle") %>의 상세정보</h1>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td rowspan="9" style=" border: solid 1px #ddd">
						<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName") %>" style="width: 100%;">
					</td>
				</tr>
				<tr>
					<td>상품번호</td>
					<td><%=goodsNo %></td>
				</tr>
				<tr>
					<td>카테고리</td>
					<td>
						<%=goodsInfo.get("category") %>
					</td>
				</tr>
				<tr>
					<td>관리자</td>
					<td>
						<%=goodsInfo.get("empId") %>
					</td>
				</tr>
				<tr>
					<td>상품명</td>
					<td>
						<%=goodsInfo.get("goodsTitle") %>
					</td>
				</tr>
				<tr>
					<td>설명</td>
					<td>
						<%=goodsInfo.get("goodsContent") %>
					</td>
				</tr>
				<tr>
					<td>가격</td>
					<td>
						<%=goodsInfo.get("goodsPrice") %>
					</td>
				</tr>
				<tr>
					<td>수량</td>
					<td>
						<%=goodsInfo.get("goodsAmount") %>
					</td>
				</tr>
				<tr>
					<td>등록일</td>
					<td>
						<%=goodsInfo.get("createDate") %>
					</td>
				</tr>
				
				<!-- 동일한 관리자거나 관리자 등급 0보다 클때만 수정,삭제 가능 -->
				<%
					if(getSessionMap.get("empId").equals(goodsInfo.get("empId")) || (int)getSessionMap.get("grade") > 0) {
				%>
						<tr>
							<td colspan="3">
								<form action="/shop/emp/goods/updateGoodsForm.jsp?goodsNo=<%=goodsNo%>" method="post" style="display: inline-block;">
									<button type="submit" class="btn btn-outline-secondary">수정</button>
								</form>
									
								<form action="/shop/emp/goods/deleteGoodsForm.jsp?goodsNo=<%=goodsNo%>" method="post" style="display: inline-block;">
									<button type="submit" class="btn btn-outline-secondary">삭제</button>
								</form>
							</td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		
	</div>
	
	<div class="col"></div>
</div>

</body>
</html>