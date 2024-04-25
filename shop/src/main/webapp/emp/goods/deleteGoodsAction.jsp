<%@page import="java.util.HashMap"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값
	String goodsNo = request.getParameter("goodsNo");
	String imgName = request.getParameter("imgName");
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청 값 디버깅
	System.out.println("deleteGoodsAction - goodsNo = " + goodsNo);
	System.out.println("deleteGoodsAction - empId = " + empId);
	System.out.println("deleteGoodsAction - empPw = " + empPw);
%>

<%
	// id, pw 확인
	HashMap<String, String> checkIdPw = GoodsDAO.checkIdPw(empId, empPw);

	// id, pw가 일치한다면
	if(checkIdPw != null) {
		
		// 이미지 삭제
		String imgPath = request.getServletContext().getRealPath("upload");
		int deleteGoodsRow = GoodsDAO.deleteGoods(goodsNo, imgPath, imgName);
		
		// 상품 삭제 쿼리 디버깅
		System.out.println("deleteGoodsAction - row = " + deleteGoodsRow);
		System.out.println("상품 삭제 성공");
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
		
		
	} else {
		// 상품 삭제 실패
		System.out.println("상품 삭제 실패");
		response.sendRedirect("/shop/emp/goods/goodsOne.jsp?goodsNo=" + goodsNo);
	}
%>