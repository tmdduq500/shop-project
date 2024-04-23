<%@page import="shop.dao.GoodsDAO"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// loginCutomer 세션 변수 가져오기
	HashMap<String, Object> loginCustomerMember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));

	// 고객 id
	String customerId = (String)loginCustomerMember.get("customerId");
%>
<%
	//현재 페이지 구하기
	int currentPage = 1;	// 현재페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// currentPage 세션 값 설정
	session.setAttribute("currentPage", currentPage);
	
	// 페이지당 보여줄 row 수
	int rowPerPage = 10;
	
	// select 박스로 rowPerPage 구하기
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		session.setAttribute("customerOrdersRowPerPage", rowPerPage);
	}
	
	if((session.getAttribute("customerOrdersRowPerPage")) != null) {
		rowPerPage = (int)(session.getAttribute("customerOrdersRowPerPage"));
	}
	
	// 고객이 주문한 개수
	int ordersNumOfCustomer = OrdersDAO.selectOrdersNumOfCustomer(customerId);
	
	// 마지막 페이지 구하기
	int lastPage = ordersNumOfCustomer / rowPerPage;
	if(ordersNumOfCustomer % rowPerPage != 0) {
		lastPage += 1;
	}
		
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;

	// 고객의 주문 목록
	ArrayList<HashMap<String, Object>> ordersListByCustomer = OrdersDAO.selectOrdersListByCustomer(customerId, startRow, rowPerPage);
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
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-8">
		<h1>주문 목록</h1>
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<th>상품정보</th>
					<th>주문일자</th>
					<th>주문번호</th>
					<th>주문금액</th>
					<th colspan="2">주문상태</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(HashMap<String, Object> m : ordersListByCustomer) {
						String imgName = (String)GoodsDAO.selectGoodsInfo((String)m.get("goodsNo")).get("imgName");
				%>
						<tr>
							<td>
								<a href="/shop/customer/goods/customerGoodsOne.jsp?goodsNo=<%=(String)(m.get("goodsNo"))%>" 
									style="text-decoration: none; color: black;">
									<img alt="" src="/shop/upload/<%=imgName%>" width="80px;">
									<%=m.get("goodsTitle")%>
								</a>
							</td>
							<td style="vertical-align: middle;"><%=m.get("ordersDate")%></td>
							<td style="vertical-align: middle;">
								<a href="/shop/customer/orders/customerOrdersOne.jsp?ordersNo=<%=m.get("ordersNo")%>"
									style="text-decoration: none; color: black;">
									<%=m.get("ordersNo")%>
								</a>
								
							</td>
							<td style="vertical-align: middle;"><%=m.get("totalPrice")%>원</td>
							<td style="vertical-align: middle;"><%=m.get("ordersState")%></td>
							<%
								if(((String)(m.get("ordersState"))).equals("배송중")) {
							%>	
									<td style="width: 10%;">
										<a class="a-to-button" href="/shop/customer/orders/updateCustomerOrdersState.jsp?ordersNo=<%=m.get("ordersNo")%>" style="width: 100%;">구매확정</a>
									</td>
							<%
								} else if(((String)(m.get("ordersState"))).equals("구매확정")) {
							%>
									<td style="width: 10%;">
										<a class="a-to-button" href="/shop/customer/review/customerReviewForm.jsp?ordersNo=<%=m.get("ordersNo")%>" style="width: 100%;">리뷰작성</a>
									</td>
							<%
								} else if(((String)(m.get("ordersState"))).equals("리뷰완료")) {
							%>
									<td style="width: 10%;">
										<a class="a-to-button" href="/shop/customer/review/customerReviewOne.jsp?ordersNo=<%=m.get("ordersNo")%>" style="width: 100%;">리뷰보기</a>
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
		
		<!-- 페이징 버튼 -->	
		<div class="w3-bar w3-center">
	
			<%
				if(currentPage > 1) {
			%>	
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=1">처음페이지</a>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
			<%		
				} else {
			%>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=1">처음페이지</a>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=1">이전페이지</a>
			<%		
				}
	
				if(currentPage < lastPage) {
			%>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
			<%		
				} else {
			%>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=<%=lastPage%>">다음페이지</a>
					<a class="w3-button" href="/shop/customer/orders/customerOrdersList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
			<%
				}
			%>
	
		</div>
	</div>

	<div class="col"></div>
</div>
</body>
</html>