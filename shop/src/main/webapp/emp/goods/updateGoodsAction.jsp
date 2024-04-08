<%@page import="java.nio.file.Files"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값 
	String goodsNo = request.getParameter("goodsNo");
	String category = request.getParameter("category");
	String empId = request.getParameter("empId");
	String goodsTitle = request.getParameter("goodsTitle");
	String existImgName = request.getParameter("existImgName");
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter("goodsAmount");
	String goodsContent = request.getParameter("goodsContent");
	
	String newImgName = "";
	Part part = request.getPart("newGoodsImg");
	
	if(part != null) {
		newImgName = existImgName;
	}
	
	// 요청 값 디버깅
	System.out.println("updateGoodsAction - goodsNo = " + goodsNo);
	System.out.println("updateGoodsAction - category = " + category);
	System.out.println("updateGoodsAction - empId = " + empId);
	System.out.println("updateGoodsAction - goodsTitle = " + goodsTitle);
	System.out.println("updateGoodsAction - existImgName = " + existImgName);
	System.out.println("updateGoodsAction - newImgName = " + newImgName);
	System.out.println("updateGoodsAction - goodsPrice = " + goodsPrice);
	System.out.println("updateGoodsAction - goodsAmount = " + goodsAmount);
	System.out.println("updateGoodsAction - goodsContent = " + goodsContent);
	
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* 상품 하나의 정보를 업데이트 하는 쿼리 */
	String updateGoodsSql = "UPDATE goods SET category = ?, goods_title = ?, goods_content = ?, goods_price = ?, goods_amount = ?, update_date = NOW()";
	PreparedStatement updateGoodsStmt = null;
	
	
	// 새로운 이미지 업로드 x -> 기존 이미지 사용 ()
	if(newImgName.equals("")) {
		updateGoodsSql = updateGoodsSql + " " + "WHERE goods_no = ?";
		updateGoodsStmt = conn.prepareStatement(updateGoodsSql);
		updateGoodsStmt.setString(1, category);
		updateGoodsStmt.setString(2, goodsTitle);
		updateGoodsStmt.setString(3, goodsContent);
		updateGoodsStmt.setString(4, goodsPrice);
		updateGoodsStmt.setString(5, goodsAmount);
		updateGoodsStmt.setString(6, goodsNo);
	} else {
		// 새로운 이미지 업로드!
		updateGoodsSql = updateGoodsSql + ",img_name = ? WHERE goods_no = ?";
		updateGoodsStmt = conn.prepareStatement(updateGoodsSql);
		updateGoodsStmt.setString(1, category);
		updateGoodsStmt.setString(2, goodsTitle);
		updateGoodsStmt.setString(3, goodsContent);
		updateGoodsStmt.setString(4, goodsPrice);
		updateGoodsStmt.setString(5, goodsAmount);
		updateGoodsStmt.setString(6, newImgName);
		updateGoodsStmt.setString(7, goodsNo);
	}
	
	int row = updateGoodsStmt.executeUpdate();

	if(row == 1) {
		// 상품 등록 성공
		
		// part -> 1. inputStream -> 2. outputStream -> 3. 빈 파일 생성
		if(newImgName != null) {
			// 1번
			InputStream is = part.getInputStream();
			// 3번 + 2번 같이
			String imgPath = request.getServletContext().getRealPath("upload");
			System.out.println("updateGoodsAction - imgPath = " + imgPath);
			System.out.println("updateGoodsAction - newImgName = " + newImgName);
			File image = new File(imgPath, newImgName);	// 빈 파일 생성
			OutputStream os = Files.newOutputStream(image.toPath());	// os + file
			is.transferTo(os);
			
			os.close();
			is.close();
		}
		
		
		System.out.println("상품 수정 성공");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	} else {
		// 상품 등록 실패
		System.out.println("상품 수정 실패");
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	}
	
%>