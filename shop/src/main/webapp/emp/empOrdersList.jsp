<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.util.*"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	//현재 페이지 구하기
	int currentPage = 1;	// 현재페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// currentPage 세션 값 설정
	session.setAttribute("currentPage", currentPage);
	
	// 페이지당 보여줄 row 수
	int rowPerPage = 30;
	
	// select 박스로 rowPerPage 구하기
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		session.setAttribute("customerOrdersRowPerPage", rowPerPage);
	}
	
	if((session.getAttribute("customerOrdersRowPerPage")) != null) {
		rowPerPage = (int)(session.getAttribute("customerOrdersRowPerPage"));
	}
	
	// 모든 고객이 주문한 개수
	int ordersNum = OrdersDAO.selectTotalOrdersNum();
	
	// 마지막 페이지 구하기
	int lastPage = ordersNum / rowPerPage;
	if(ordersNum % rowPerPage != 0) {
		lastPage += 1;
	}
		
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;

	// 고객의 주문 목록
	ArrayList<HashMap<String, Object>> ordersList = OrdersDAO.selectTotalOrdersList(startRow, rowPerPage);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>주문 목록</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-8">
		<h1>전체 고객 주문 목록</h1>
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<th>상품정보</th>
					<th>주문일자</th>
					<th>주문고객</th>
					<th>주문번호</th>
					<th>주문금액</th>
					<th colspan="2">주문상태</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(HashMap<String, Object> m : ordersList) {
						String imgName = (String)GoodsDAO.selectGoodsInfo((String)m.get("goodsNo")).get("imgName");
				%>
						<tr>
							<td>
								<a href="/shop/emp/goods/goodsOne.jsp?goodsNo=<%=(String)(m.get("goodsNo"))%>" 
									style="text-decoration: none; color: black;">
									<img alt="" src="/shop/upload/<%=imgName%>" width="80px;">
									<%=m.get("goodsTitle")%>
								</a>
							</td>
							<td style="vertical-align: middle;"><%=m.get("ordersDate")%></td>
							<td style="vertical-align: middle;"><%=m.get("customerId")%></td>
							<td style="vertical-align: middle;">
								<a href="/shop/emp/empOrdersOne.jsp?ordersNo=<%=m.get("ordersNo")%>"
									style="text-decoration: none; color: black;">
									<%=m.get("ordersNo")%>
								</a>
								
							</td>
							<td style="vertical-align: middle;"><%=m.get("totalPrice")%>원</td>
							<td style="vertical-align: middle;"><%=m.get("ordersState")%></td>
							<%
								if(((String)(m.get("ordersState"))).equals("결제완료")) {
							%>	
									<td style="width: 10%;">
										<a class="a-to-button" href="/shop/emp/updateOrdersState.jsp?ordersNo=<%=m.get("ordersNo")%>" style="width: 100%;">구매확정</a>
									</td>
							<%
								}
							%>
							
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