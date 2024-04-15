<%@page import="shop.dao.CategoryDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.File"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!-- Model Layer -->
<%
	// 요청 값
	String category = request.getParameter("category");
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청 값 디버깅
	System.out.println("deleteCategoryAction - category = " + category);
	System.out.println("deleteCategoryAction - empId = " + empId);
	System.out.println("deleteCategoryAction - empPw = " + empPw);
%>
<%
	/* session의 정보 가져오기(grade가 0이 아닐때 삭제 하기 위해) */
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<%
	// [DB]에서 id, pw 체크
	HashMap<String, String> checkIdPw = CategoryDAO.checkIdPw(empId, empPw);
	
	// id, pw가 일치한다면
	if(checkIdPw != null) {
		// grade가 0이 아니면 삭제
		System.out.println("deleteCategoryAction - grade = " + (int)(loginMember.get("grade")));
		if((int)(loginMember.get("grade")) > 0) {
			
			/* 카테고리와 연관된 상품들의 img 삭제하기 */
			// 해당 카테고리의 상품들의 이미지 이름가져오기
			ArrayList<HashMap<String, String>> imgNameListOfGoods = CategoryDAO.selectGoodsOfCategory(category);
			
			for(HashMap<String, String> m : imgNameListOfGoods) {
				String imgName = m.get("imgName");	// 이미지 이름 
				String imgPath = request.getServletContext().getRealPath("upload");	// 이미지 경로
				
				// 해당 카테고리의 상품, 상품 이미지 삭제
				int deleteGoodsOfCategoryRow = CategoryDAO.deleteGoodsOfCategory(imgPath, imgName);

			}
			// 카테고리 삭제
			int deleteCategoryRow = CategoryDAO.deleteCategory(category, empId);
			
			response.sendRedirect("/shop/emp/category/categoryList.jsp");
			
		} else {
			System.out.println("grade 0 아님 ");
			// grade가 0이 아님
			response.sendRedirect("/shop/emp/category/deleteCategoryForm.jsp?category=" + category);
		}
	} else {
		// id, pw 불일치
		System.out.println("id, pw 불일치 ");
		response.sendRedirect("/shop/emp/category/deleteCategoryForm.jsp?category=" + category);
	}
	
%>