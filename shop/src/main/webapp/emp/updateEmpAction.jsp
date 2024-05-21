<%@page import="shop.dao.EmpDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>
<%
	// loginEmp 세션 변수 가져오기
	HashMap<String, Object> loginEmp = (HashMap<String, Object>)(session.getAttribute("loginEmp"));	
%>
<%
	// 요청 값 
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	String empName = request.getParameter("empName");
	String empJob = request.getParameter("empJob");
	String oldEmpPw = request.getParameter("empPw");
	String newEmpPw = request.getParameter("newEmpPw");
	String newEmpPwCheck = request.getParameter("newEmpPwCheck");
	
	// 디버깅
	System.out.println("updateEmpAction - empId = " + empId);
	System.out.println("updateEmpAction - empPw = " + empPw);
	System.out.println("updateEmpAction - empName = " + empName);
	System.out.println("updateEmpAction - empJob = " + empJob);
	System.out.println("updateEmpAction - oldEmpPw = " + oldEmpPw);
	System.out.println("updateEmpAction - newEmpPw = " + newEmpPw);
	System.out.println("updateEmpAction - newEmpPwCheck = " + newEmpPwCheck);
	
	// 요청 값 null일 경우
	if(empId == null || empName == null || empJob == null || oldEmpPw == null) {
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>
<%
	// 새 비밀번호와 새 비밀번호 확인 값이 다를 경우
	if(!newEmpPw.equals(newEmpPwCheck)) {
		String msg = URLEncoder.encode("emp정보 수정에 실패했습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/emp/checkInfoUpdateEmp.jsp?msg=" + msg);
		return;
	}

	// emp 정보 수정하기
	int updateEmpRow = 0;

	// 새 비밀번호와 새 비밀번호 값이 같고, null이나 공백이 아닐경우
	if(newEmpPw.equals(newEmpPwCheck) && !newEmpPw.equals("") && newEmpPw != null) {
		// 새 비밀번호가 pw history에 있는지 확인
		boolean canUsePw = EmpDAO.checkEmpPwHistory(empId, newEmpPw);
		// 디버깅
		System.out.println("updateEmpAction - canUsePw = " + canUsePw);
		// 새비밀번호 사용 가능하면
		if(canUsePw) {
			// 고객 비밀번호 히스토리 테이블에 데이터 추가
			int changeEmpPwRow = EmpDAO.insertEmpPw(empId, newEmpPw);
			// 디버깅
			System.out.println("updateEmpAction - changeEmpPwRow = " + changeEmpPwRow);
		} else {
			// 사용 불가능
			String msg = URLEncoder.encode("이전에 사용했던 비밀번호입니다. 다른 비밀번호를 사용해주세요", "UTF-8");
			response.sendRedirect("/shop/emp/checkInfoUpdateEmp.jsp?msg=" + msg);
			return;
		}
	}

	// emp 정보 수정 실패
	if(updateEmpRow == 0) {
		String msg = URLEncoder.encode("emp정보 수정에 실패했습니다. 다시 입력 해주세요", "UTF-8");
		response.sendRedirect("/shop/emp/checkInfoUpdateEmp.jsp?msg=" + msg);
		return;
	}
	
	// 고객 정보 수정 성공 및 loginEmp 세션 값 변경
	HashMap<String, Object> newEmp = new HashMap<String,Object>();
	HashMap<String, Object> updateEmp = EmpDAO.selectEmpInfo(empId);
	newEmp.put("empId", updateEmp.get("empId"));
	newEmp.put("empName", updateEmp.get("empName"));
	newEmp.put("grade", updateEmp.get("grade"));
	session.setAttribute("loginEmp", newEmp);
	response.sendRedirect("/shop/emp/empList.jsp");
%>