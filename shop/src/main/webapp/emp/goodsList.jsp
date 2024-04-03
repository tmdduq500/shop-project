<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%
	/* 로그인 인증 분기*/
	
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

	/* 상품 목록 페이징 */
	
	// 현재 페이지 구하기
	int currentPage = 1;	// 현재페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// currentPage 세션 값
	session.setAttribute("currentPage", currentPage);
	System.out.println("goodsList - currentPage 세션 값 = " + session.getAttribute("currentPage"));	// currentPage 세션 값 체크
	
	// 페이지당 보여줄 row 수
	int rowPerPage = 30;
	
//  	// select 박스로 rowPerPage 구하기
//  	if(request.getParameter("rowPerPage") != null) {
//  		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
//  	}
	
	// 전체 goods 수 구하기
	String getTotalGoodsRowSql = "SELECT COUNT(*) cnt FROM goods";
	PreparedStatement getTotalGoodsRowStmt = null;
	
	// category 요청 값
	String category = request.getParameter("category");
	System.out.println("goodsList - category = " + category);
	
	// category 세션 값
	if(category != null) {
		session.setAttribute("category", category);
		System.out.println("goodsList - category 세션 값 = " + session.getAttribute("category"));	// category 세션 값 체크
	} else {
		category = "all";
	}
	
	// category
	if(category.equals("all")) {
		getTotalGoodsRowStmt = conn.prepareStatement(getTotalGoodsRowSql);
	} else {
		getTotalGoodsRowSql = "SELECT COUNT(*) cnt FROM goods WHERE category = ?";
		getTotalGoodsRowStmt = conn.prepareStatement(getTotalGoodsRowSql);
		getTotalGoodsRowStmt.setString(1, category);
	}
	
	ResultSet getTotalGoodsRowRs = getTotalGoodsRowStmt.executeQuery();
	
	int totalRow = 0;
	if(getTotalGoodsRowRs.next()) {
		totalRow = getTotalGoodsRowRs.getInt("cnt");
	}
	System.out.println("goodsList - totalRow = " + totalRow);
	
	// 마지막 페이지 구하기
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage += 1;
	}
	System.out.println("goodsList - lastPage = " + lastPage);
	
	// 페이지당 시작할 row
	int startRow = (currentPage - 1) * rowPerPage;
	System.out.println("goodsList - startRow = " + startRow);
	
%>

<!-- Model Layer -->
<%	
	/* 카테고리 별 상품 수 가져오는 sql쿼리 */
	String getCategorySql = "SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category ASC";
	PreparedStatement getCategoryStmt = null;
	ResultSet getCategoryRs = null;
	
	getCategoryStmt = conn.prepareStatement(getCategorySql);
	getCategoryRs = getCategoryStmt.executeQuery();
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
	
	while(getCategoryRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", getCategoryRs.getString("category"));
		m.put("cnt", getCategoryRs.getInt("cnt"));
		categoryList.add(m);
	}
	
	// 디버깅
	System.out.println(categoryList);
%>
<%
	/* category 별로 상품 보여주는 sql */
	/*
		category
		
		null이면
		SELECT * FROM goods
		
		null이 아니면
		SELECT * FROM goods WHERE category = ?
	
	*/
	
	String getTotalGoodsSql = "SELECT category, goods_title goodsTitle, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount FROM goods ORDER BY create_date DESC LIMIT ?,?";
	PreparedStatement getTotalGoodsStmt = null;
	
	ResultSet getTotalGoodsRs = null;
	
	if(category.equals("all")) {
		getTotalGoodsStmt = conn.prepareStatement(getTotalGoodsSql);
		getTotalGoodsStmt.setInt(1, startRow);
		getTotalGoodsStmt.setInt(2, rowPerPage);
		getTotalGoodsRs = getTotalGoodsStmt.executeQuery();
		
	} else {
		getTotalGoodsSql = "SELECT category, goods_title goodsTitle, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount FROM goods WHERE category = ? ORDER BY create_date DESC LIMIT ?,?";
		getTotalGoodsStmt = conn.prepareStatement(getTotalGoodsSql);
		getTotalGoodsStmt.setString(1, category);
		getTotalGoodsStmt.setInt(2, startRow);
		getTotalGoodsStmt.setInt(3, rowPerPage);
		getTotalGoodsRs = getTotalGoodsStmt.executeQuery();
	}
	
	ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();
	
	while(getTotalGoodsRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", getTotalGoodsRs.getString("category"));
		m.put("goodsTitle", getTotalGoodsRs.getString("goodsTitle"));
		m.put("goodsContent", getTotalGoodsRs.getString("goodsContent"));
		m.put("goodsPrice", getTotalGoodsRs.getString("goodsPrice"));
		m.put("goodsAmount", getTotalGoodsRs.getString("goodsAmount"));
		goodsList.add(m);
	}
	
	// 디버깅
// 	System.out.println(goodsList);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<style>
		li {
			list-style: none;
			float: left; 
			max-width: 250px;
			margin: 0 10px;
		}
		
		.goods {
			display: block;
		}
		
		.goods-info {
			display: block;
			text-align: center;
		}
	</style>
</head>
<body>
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	
	<!-- 로그아웃 -->
	<div>
		<a href="/shop/emp/empLogoutAction.jsp">
			로그아웃
		</a>
	</div>
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품 등록</a>
	</div>

	<!-- 서브메뉴 카테고리별 상품리스트 -->
	<div>
		<a href="/shop/emp/goodsList.jsp?category=all">전체</a>
		
		<!-- View Layer -->
		<%
			for(HashMap m : categoryList) {
		%>
				<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category")) %>">
					<%=(String)(m.get("category")) %>
					(<%=(Integer)(m.get("cnt")) %>)
				</a>
		<% 
			}
		%>
	</div>
	
	<!-- goods 목록 출력 -->
	<div>
		<h1>상품 목록</h1>	
		
		<ul style="display: block;">
			<%
				for(HashMap<String, Object> m : goodsList) {
			%>
				
					<li>
						<div class="goods">
							<a href="/shop/emp/goodsOne.jsp">
								<img alt="" src="/shop/emp/image/laptop.jpg" width="200px;" style="display: block;">
							</a>
						</div>
						<div class="goods-info">
							<div style="margin-top: 10px;">
								<%=m.get("goodsTitle") %>
							</div>
							
							<div style="margin-top: 10px;">
								<%=m.get("goodsPrice") %>원
							</div>
						</div>
					</li>				
			<%
				}
			%>
		</ul>
	</div>
	
	<!-- 페이징 버튼 -->	
	<div style="clear: both; text-align: center; margin-top: 30px;">

		<%
			if(currentPage > 1) {
		%>	
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">처음페이지</a>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=currentPage-1%>">이전페이지</a>
		<%		
			} else {
		%>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">처음페이지</a>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=1">이전페이지</a>
		<%		
			}

			if(currentPage < lastPage) {
		%>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=currentPage+1%>">다음페이지</a>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">마지막페이지</a>
		<%		
			} else {
		%>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">다음페이지</a>
				<a href="/shop/emp/goodsList.jsp?category=<%=session.getAttribute("category") %>&currentPage=<%=lastPage%>">마지막페이지</a>
		<%
			}
		%>

	</div>
</body>
</html>