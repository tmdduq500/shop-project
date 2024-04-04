<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

<!-- Session 설정 값 : 입력할 때 로그인한 emp의 emp_id값이 필요하기 때문! -->
<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<!-- Model Layer -->
<%
	// 요청 값 분석
	String category = request.getParameter("category");
	String goodsTitle = request.getParameter("goodsTitle");
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter("goodsAmount");
	String goodsContent = request.getParameter("goodsContent");
	
	// 요청 값이 1개라도 null일시
	if(category == null || goodsTitle == null || goodsPrice == null || 
			goodsAmount == null || goodsContent == null) {
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
	}
	
	// 요청값 디버깅
	System.out.println("addGoodsAction - category = " + category);
	System.out.println("addGoodsAction - goodsTitle = " + goodsTitle);
	System.out.println("addGoodsAction - goodsPrice = " + goodsPrice);
	System.out.println("addGoodsAction - goodsAmount = " + goodsAmount);
	System.out.println("addGoodsAction - goodsContent = " + goodsContent);
	
	
%>

<!-- Controller Layer -->
<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

	/* [DB]shop.goods에 goods 추가하는 sql */
	String addGoodsSql = "INSERT INTO goods(category, emp_id, goods_title, goods_content, goods_price, goods_amount) VALUES (?, ?, ?, ?, ?, ?)";
	PreparedStatement addGoodsStmt = null;
	
	addGoodsStmt = conn.prepareStatement(addGoodsSql);
	addGoodsStmt.setString(1, category);
	addGoodsStmt.setString(2, (String)(loginMember.get("empId")));
	addGoodsStmt.setString(3, goodsTitle);
	addGoodsStmt.setString(4, goodsContent);
	addGoodsStmt.setInt(5, Integer.parseInt(goodsPrice));
	addGoodsStmt.setInt(6, Integer.parseInt(goodsAmount));
	
	int row = addGoodsStmt.executeUpdate();
	
	if(row == 1) {
		// 상품 등록 성공
		System.out.println("상품 등록 성공");
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
	} else {
		// 상품 등록 실패
		System.out.println("상품 등록 실패");
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
	}
	
%>