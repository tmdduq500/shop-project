<%@page import="shop.dao.EmpDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/emp/inc/commonSessionCheck.jsp" %>
<%
	// 요청 값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	String empName = request.getParameter("empName");
	String empJob = request.getParameter("empJob");
	String empHireDate = request.getParameter("empHireDate");

	// 디버깅
	System.out.println("insertEmpAction - empId = " + empId);
	System.out.println("insertEmpAction - empPw = " + empPw);
	System.out.println("insertEmpAction - empName = " + empName);
	System.out.println("insertEmpAction - empJob = " + empJob);
	System.out.println("insertEmpAction - empHireDate = " + empHireDate);
	
	// emp INSERT 메서드
	int insertEmpRow = EmpDAO.insertEmp(empId, empPw, empName, empJob, empHireDate);
	
	// emp INSERT row 디버깅
	System.out.println("insertEmpAction - insertEmpRow = " + insertEmpRow);
	
	response.sendRedirect("/shop/emp/empList.jsp");
	
%>