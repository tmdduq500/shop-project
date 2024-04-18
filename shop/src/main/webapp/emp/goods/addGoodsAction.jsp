<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

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
	
	// 이미지 파일 업로드
	Part part = request.getPart("goodsImg");
	String originalName = part.getSubmittedFileName();
	// 원본 이름에서 확장자만 분리
	int dotIndex = originalName.lastIndexOf(".");
	String ext = originalName.substring(dotIndex);	// 확장자(ex. jpg, png ...)
	
	UUID uuid = UUID.randomUUID();
	String imgName = uuid.toString().replace("-", "");
	imgName = imgName + ext;
	
	
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
	System.out.println("addGoodsAction - imgName = " + imgName);
%>

<!-- Controller Layer -->
<%
	

	int row = GoodsDAO.addGoods(category, (String)loginMember.get("empId"), goodsTitle, 
			imgName, goodsContent, Integer.parseInt(goodsPrice) , Integer.parseInt(goodsAmount));
	
	if(row == 1) {
		// 상품 등록 성공
		// part -> 1. inputStream -> 2. outputStream -> 3. 빈 파일 생성
		
		// 1번
		InputStream is = part.getInputStream();
		// 3번 + 2번 같이
		String imgPath = request.getServletContext().getRealPath("upload");
		GoodsDAO.uploadGoodsImg(imgPath, imgName, is);
		
		System.out.println("상품 등록 성공");
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
	} else {
		// 상품 등록 실패
		System.out.println("상품 등록 실패");
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
	}
		
%>