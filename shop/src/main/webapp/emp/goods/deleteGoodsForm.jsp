<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	/* session의 정보 가져오기(상품 삭제 시 로그인한 id 표시 및 요청 값으로 넘기기 위해) */
	HashMap<String, Object> getSessionMap = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<%
	// 요청 값
	String goodsNo = request.getParameter("goodsNo");

	// 요청 값 디버깅
	System.out.println("deleteGoodsForm - goodsNo = " + goodsNo);
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	// [DB]shop.goods의 정보 일부분 가져오는 쿼리
	String getGoodsInfoSql = "SELECT category, goods_title goodsTitle, img_name imgName FROM goods WHERE goods_no = ?";
	PreparedStatement getGoodsInfoStmt = null;
	ResultSet getGoodsInfoRs = null;
	
	getGoodsInfoStmt = conn.prepareStatement(getGoodsInfoSql);
	getGoodsInfoStmt.setString(1, goodsNo);
	getGoodsInfoRs = getGoodsInfoStmt.executeQuery();
	
	HashMap<String, Object> goodsInfo = new HashMap<String, Object>();
	
	if(getGoodsInfoRs.next()) {
		goodsInfo.put("category", getGoodsInfoRs.getString("category"));
		goodsInfo.put("goodsTitle", getGoodsInfoRs.getString("goodsTitle"));
		goodsInfo.put("imgName", getGoodsInfoRs.getString("imgName"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
</head>
<body>
	<div>
		<div>
			<div>
				상품번호 : <%=goodsNo%>
			</div>
			
			<div>
				카테고리 : <%=goodsInfo.get("category")%>
			</div>
			
			<div>
				상품명 : <%=goodsInfo.get("goodsTitle")%>
			</div>
			
			<div>
				<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>">
			</div>
			
			<div>
				해당 상품을 삭제하시려면 id와 pw를 입력해주세요.
			</div>
		</div>
		
		<form action="/shop/emp/goods/deleteGoodsAction.jsp">
			<input type="hidden" name="goodsNo" value="<%=goodsNo%>">
			<input type="hidden" name="imgName" value="<%=goodsInfo.get("imgName")%>">
			<div>
				id <input type="text" name="empId" value="<%=getSessionMap.get("empId")%>" readonly="readonly">
			</div>
			
			<div>
				pw <input type="password" name="empPw">
			</div>
			
			<button type="submit">삭제</button>
		</form>
	</div>
</body>
</html>