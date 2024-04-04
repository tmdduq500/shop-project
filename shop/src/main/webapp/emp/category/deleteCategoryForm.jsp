<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

<!-- Model Layer -->
<%
	// 요청 값
	String category = request.getParameter("category");

	// 요청 값 디버깅
	System.out.println("deleteCategoryForm - category = " + category);
	
%>
<%
	/* session의 정보 가져오기(grade별로 카테고리 삭제 권한 설정하기 위해) */
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 삭제</title>
</head>
<body>
	<h1>카테고리 삭제</h1>
	
	<form action="/shop/emp/category/deleteCategoryAction.jsp" method="post">
		<div>
			삭제하려는 카테고리는
			<input type="text" value="<%=category%>" name="category" readonly="readonly">
			입니다.
		</div>
		
		<div>
			삭제할 경우 해당 카테고리의 <strong>모든 상품들이 삭제됩니다</strong>
			정말 삭제하시려면 id 와 pw를 입력해주세요.
		</div>
		
		<div>
			id <input type="text" name="empId" value="<%=loginMember.get("empId")%>" readonly="readonly">
		</div>
		<div>
			pw <input type="password" name="empPw">
		</div>
				
		<div>
			<button type="submit">카테고리 삭제</button>
		</div>
	</form>
</body>
</html>