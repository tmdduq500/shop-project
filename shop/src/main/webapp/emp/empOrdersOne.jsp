<%@page import="shop.dao.OrdersDAO"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// 요청 값
	String ordersNo = request.getParameter("ordersNo");
%>
<%
	HashMap<String, Object> ordersOneByEmp = OrdersDAO.selectOrdersOneByEmp(ordersNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객 주문 상세보기</title>
	<link href="/shop/css/w3.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
<!-- 메인 메뉴 -->
<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

	<div class="col"></div>

	<div class="col-4">
		<table class="w3-table w3-centered w3-card-4 w3-bordered" style="margin-top: 50px; width: 100%;">
			<thead class="w3-dark-grey">
				<tr>
					<td colspan="2">
						<h1>주문번호 <%=ordersOneByEmp.get("ordersNo")%>의 상세 내역</h1>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th style="vertical-align: middle;">상품번호</th>
					<td>
						<%=ordersOneByEmp.get("goodsNo")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">상품명</th>
					<td>
						<%=ordersOneByEmp.get("goodsTitle")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문고객</th>
					<td>
						<%=ordersOneByEmp.get("customerId")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">상품사진</th>
					<td>
						<img alt="" src="/shop/upload/<%=ordersOneByEmp.get("imgName")%>">
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문수량</th>
					<td>
						<%=ordersOneByEmp.get("totalAmount")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문금액</th>
					<td>
						<%=ordersOneByEmp.get("totalPrice")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">배달주소</th>
					<td>
						<%=ordersOneByEmp.get("orderAdderess")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문일자</th>
					<td>
						<%=ordersOneByEmp.get("ordersDate")%>
					</td>
				</tr>
				<tr>
					<th style="vertical-align: middle;">주문상태</th>
					<td>
						<%=ordersOneByEmp.get("ordersState")%>
						<%
							if(((String)(ordersOneByEmp.get("ordersState"))).equals("결제완료")) {
						%>	
								<a class="a-to-button" href="/shop/emp/updateOrdersState.jsp?ordersNo=<%=ordersOneByEmp.get("ordersNo")%>" style="width: 100%;">배송 시작</a>
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