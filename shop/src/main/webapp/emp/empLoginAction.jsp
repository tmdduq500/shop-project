<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

<%
	//DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* 로그인 하기 */
	
	// id, pw 요청값
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	System.out.println("empLoginAction - empId = " + empId);
	System.out.println("empLoginAction - empPw = " + empPw);
		
	/*
		[DB]shop.emp에 empId, empPw 확인 SQL문 
		
		SELECT emp_id empId
		FROM emp
		WHERE active='ON' AND emp_id=? AND emp_pw = password(?)
	*/
	String loginSql = "SELECT emp_id empId, emp_name empName, grade FROM emp WHERE active='ON' AND emp_id=? AND emp_pw = password(?)";
	PreparedStatement loginStmt = null; 
	ResultSet loginRs = null;
	
	loginStmt = conn.prepareStatement(loginSql);
	loginStmt.setString(1, empId);
	loginStmt.setString(2, empPw);
	loginRs = loginStmt.executeQuery();
	
	
	if(loginRs.next()) {
		// 성공 -> /emp/empList.jsp
		System.out.println("로그인 성공");
		
		// 하나의 세션변수 안에 여러개의 값을 저장하기 위해 HashMap타입 사용
		HashMap<String, Object> loginEmp = new HashMap<String, Object>();
		loginEmp.put("empId", loginRs.getString("empId"));
		loginEmp.put("empName", loginRs.getString("empName"));
		loginEmp.put("grade", loginRs.getInt("grade"));
		
		session.setAttribute("loginEmp", loginEmp);
		
		// 디버깅(loginEmp 세션 변수)
		HashMap<String, Object> checkEmp = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
		System.out.println((String)(checkEmp.get("empId")));
		System.out.println((String)(checkEmp.get("empName")));
		System.out.println((Integer)(checkEmp.get("grade")));
		
				
		response.sendRedirect("/shop/emp/empList.jsp");
	} else {
		// 실패 -> /emp/empLoginForm.jsp	
		System.out.println("로그인 실패");
		
		String errMsg = URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다.", "utf-8");
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg=" + errMsg);
	}

	// 자원 반납
	loginRs.close();
	loginStmt.close();
	conn.close();
%>