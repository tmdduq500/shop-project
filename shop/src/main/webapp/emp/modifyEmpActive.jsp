<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%   
    // 요청 값
    String empId = request.getParameter("empId");
    String active = request.getParameter("active");
    
    // 요청 값 체크
    System.out.println("modifyEmpActive - empId = " + empId);
    System.out.println("modifyEmpActive - active = " + active);
    
	// 요청 값 null일 경우 페이지 redirect
	if(empId == null || active == null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
	
	// 관리자의 권한 수정 메서드
    int row = EmpDAO.updateEmpGrade(empId, active);
    
	// 권한 수정 메서드 디버깅
    System.out.println("modifyEmpActive - row = " + row);
	// 권한 수정 후 emp목록으로 redirect
    response.sendRedirect("/shop/emp/empList.jsp");

%>