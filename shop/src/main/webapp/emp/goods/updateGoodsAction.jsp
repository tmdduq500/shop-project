<%@page import="shop.dao.GoodsDAO"%>
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
	
	// 새로운 이미지 업로드 할 경우 이미지 이름 생성
	String newImgName = "";
	Part part = request.getPart("newGoodsImg");
	
	// 파일을 아무것도 올리지 않았을경우 기존 상품의 이미지 이름 사용하기
	if(part != null && part.getSize() > 0) {
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
	// 상품 수정 메서드
	int updateGoodsRow = GoodsDAO.updateGoods(category, goodsTitle, goodsContent, goodsPrice, goodsAmount, goodsNo, newImgName);

	if(updateGoodsRow == 1) {
		// 상품 등록 성공
		
		// part -> 1. inputStream -> 2. outputStream -> 3. 빈 파일 생성
		if(!newImgName.equals("")) {
			InputStream is = part.getInputStream();

			String imgPath = request.getServletContext().getRealPath("upload");
	
			GoodsDAO.uploadGoodsImg(imgPath, newImgName, is);
		}
		
		System.out.println("상품 수정 성공");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	} else {
		// 상품 등록 실패
		System.out.println("상품 수정 실패");
		response.sendRedirect("/shop/emp/goods/insertGoodsForm.jsp");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	}
	
%>