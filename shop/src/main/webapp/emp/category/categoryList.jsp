<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<jsp:include page="/emp/inc/commonSessionCheck.jsp"></jsp:include>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* [DB]shop.category에서 category와 생성일 가져오는 쿼리 */
	String getCategorySql = "SELECT category, emp_id empId, LEFT(create_date,16) createDate FROM category ORDER BY createDate DESC";
	PreparedStatement getCategoryStmt = null;
	ResultSet getCategoryRs = null;
	
	getCategoryStmt = conn.prepareStatement(getCategorySql);
	getCategoryRs = getCategoryStmt.executeQuery();
	
	// 자료 구조 변경(ResultSet --> ArrayList<HashMap>)
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
	while(getCategoryRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", getCategoryRs.getString("category"));
		m.put("empId", getCategoryRs.getString("empId"));
		m.put("createDate", getCategoryRs.getString("createDate"));
		categoryList.add(m);
	}
%>
<%
	/* session의 정보 가져오기(grade별로 카테고리 삭제 권한 설정하기 위해) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 목록</title>
	<link href="/shop/emp/css/emp.css" rel="stylesheet" type="text/css">
</head>
<body>
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	
	<!-- category 목록 출력 -->
	<div style="display:table; max-width:700px;">
		<div class="list-title">
			<h1 style="display: inline;">category 목록</h1>
			<a href="/shop/emp/category/addCategoryForm.jsp">카테고리 추가</a>
		</div>
			
		
		<div style="display:table-row;">
			<div class="list-cell" style="display:table-cell">카테고리</div>
			<div class="list-cell" style="display:table-cell">생성한 사람</div>
			<div class="list-cell" style="display:table-cell">생성일</div>
		</div>
		
		<%
			for(HashMap<String, Object> m : categoryList) {
		%>
				<div style="display:table-row;">
					<div class="list-cell" style="display:table-cell"><%=m.get("category") %></div>
					<div class="list-cell" style="display:table-cell"><%=m.get("empId") %></div>
					<div class="list-cell" style="display:table-cell"><%=m.get("createDate") %></div>
					<%
						if((Integer)(getSessionMap.get("grade")) > 0) {
					%>
							<div style="display: inline-block; margin: 10px;">
								<a href="/shop/emp/category/deleteCategoryForm.jsp?category=<%=m.get("category")%>">삭제</a>
							</div>
					<%
						}
					%>
					
				</div>
		<%
			}
		%>
	</div>
</body>
</html>