<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인 인증 분기*/
	// 세션 변수 이름 - loginEmp
	
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<%
    //DB 연결 및 초기화
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = null;
    conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
    
    // 요청 값
    String empId = request.getParameter("empId");
    String active = request.getParameter("active");
    
    // 요청 값 체크
    System.out.println("modifyEmpActive - empId = " + empId);
    System.out.println("modifyEmpActive - active = " + active);
    
    // [DB]shop.emp의 active 값 수정
    /*
        [DB]shop.emp에 empId, empPw SQL문
        
        UPDATE emp
        SET active = 'ON' or 'OFF'
        WHERE emp_id = ?
    */
    
    String changeActiveSql = "UPDATE emp SET active = ? WHERE emp_id = ?";
    PreparedStatement changeActiveStmt = null; 
    changeActiveStmt = conn.prepareStatement(changeActiveSql);
    int row = 0;    // 쿼리 실행 확인
    
    // active 값 교체
    if(active.equals("ON")) {
        // active가 ON일 경우
        active = "OFF";
        changeActiveStmt.setString(1, active);
        changeActiveStmt.setString(2, empId);
        row = changeActiveStmt.executeUpdate();
    } else {    
        // active가 OFF일 경우
        active = "ON";
        changeActiveStmt.setString(1, active);
        changeActiveStmt.setString(2, empId);
        row = changeActiveStmt.executeUpdate();
    }
    
    System.out.println("modifyEmpActive - row = " + row);
    
    response.sendRedirect("/shop/emp/empList.jsp");

%>