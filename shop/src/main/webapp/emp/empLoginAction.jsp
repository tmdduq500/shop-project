<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@page import="shop.dao.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/loginSessionCheck.jsp"%>

<%
	/* 로그인 하기 */
	
	// id, pw 요청값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	// 요청값 디버깅
	System.out.println("empLoginAction - empId = " + empId);
	System.out.println("empLoginAction - empPw = " + empPw);
	
	// id,pw일치하고 권한이 ON인 emp 로그인 정보 가져오기(empId, empName, grade)
	HashMap<String, Object> loginEmp =  EmpDAO.empLogin(empId, empPw);

	// emp정보 확인돼어 map에 데이터가 들어왔을 때
	if(loginEmp != null) {
		// 성공 -> /emp/empList.jsp
		System.out.println("로그인 성공");
		
		// 로그인된 emp 데이터(Map) 을 세션 변수에 담기(empId, empName, grade)
		session.setAttribute("loginEmp", loginEmp);
		
		// 디버깅(loginEmp 세션 변수)
// 		HashMap<String, Object> checkEmp = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
// 		System.out.println((String)(checkEmp.get("empId")));
// 		System.out.println((String)(checkEmp.get("empName")));
// 		System.out.println((Integer)(checkEmp.get("grade")));
		
		// 로그인 및 세션 변수 설정 후 empList로 redirect
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		System.out.println("로그인 실패");
		
		String errMsg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg=" + errMsg);
		return;
	}

%>