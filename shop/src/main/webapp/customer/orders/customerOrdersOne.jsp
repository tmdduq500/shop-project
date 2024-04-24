<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.OrdersDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/customer/inc/CustomerCommonSessionCheck.jsp" %>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");

	// 요청 값 디버깅
	System.out.println("customerOrdersOne - ordersNo = " + ordersNo);
%>
<%
	// 고객의 주문 목록 상세 내용 가져오기
	HashMap<String, Object> customerOrdersOne = OrdersDAO.selectOrdersOneByCustomer(ordersNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>주문 상세보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<td colspan="2">
						<h1>주문번호 <%=customerOrdersOne.get("ordersNo")%>의 상세 내역</h1>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th style="vertical-align: middle;">상품명</th>
					<td>
						<%=customerOrdersOne.get("goodsTitle")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">상품사진</th>
					<td>
						<img alt="" src="/shop/upload/<%=customerOrdersOne.get("imgName")%>">
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문수량</th>
					<td>
						<%=customerOrdersOne.get("totalAmount")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문금액</th>
					<td>
						<%=customerOrdersOne.get("totalPrice")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">배달주소</th>
					<td>
						<%=customerOrdersOne.get("orderAdderess")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문일자</th>
					<td>
						<%=customerOrdersOne.get("ordersDate")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문상태</th>
					<td>
						<%=customerOrdersOne.get("ordersState")%>
						<%
							if(((String)(customerOrdersOne.get("ordersState"))).equals("배송중")) {
						%>	
								<a class="a-to-button" href="/shop/customer/orders/updateCustomerOrdersState.jsp?ordersNo=<%=customerOrdersOne.get("ordersNo")%>" style="width: 100%;">구매확정</a>
						<%
							} else if(((String)(customerOrdersOne.get("ordersState"))).equals("구매확정")) {
						%>
								<a class="a-to-button" href="/shop/customer/review/insertCustomerReviewForm.jsp?ordersNo=<%=customerOrdersOne.get("ordersNo")%>" style="width: 100%;">리뷰작성</a>
						<%
							} else if(((String)(customerOrdersOne.get("ordersState"))).equals("리뷰완료")) {
						%>
								<a class="a-to-button" href="/shop/customer/review/customerReviewOne.jsp?ordersNo=<%=customerOrdersOne.get("ordersNo")%>" style="width: 100%;">리뷰보기</a>
						<%
							}
						%>
					</td>
				</tr>
			</tbody>
		</table>
		
	</div>
	
	<div class="col"></div>
</div>
</body>
</html>