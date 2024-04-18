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
//     System.out.println("modifyEmpActive - empId = " + empId);
//     System.out.println("modifyEmpActive - active = " + active);
    
    int row = EmpDAO.updateEmpGrade(empId, active);
    
    System.out.println("modifyEmpActive - row = " + row);
    
    response.sendRedirect("/shop/emp/empList.jsp");

%>