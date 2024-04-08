<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<%
	// 요청 값 확인
	String goodsNo = request.getParameter("goodsNo");
	// 요청 값 디버깅
	System.out.println("goodsOne - goodsNo = " + goodsNo);
%>

<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");
	
	/* 상품 하나의 모든 정보 가져오는 쿼리 */
	String getGoodsInfoSql = "SELECT category, emp_id empId, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount, create_date createDate FROM goods WHERE goods_no = ?";
	PreparedStatement getGoodsInfoStmt = null;
	ResultSet getGoodsInfoRs = null;
	getGoodsInfoStmt = conn.prepareStatement(getGoodsInfoSql);
	getGoodsInfoStmt.setString(1, goodsNo);
	getGoodsInfoRs = getGoodsInfoStmt.executeQuery();
	
	HashMap<String, Object> goodsInfo = new HashMap<String, Object>();
	while(getGoodsInfoRs.next()) {
		goodsInfo.put("category", getGoodsInfoRs.getString("category"));
		goodsInfo.put("empId", getGoodsInfoRs.getString("empId"));
		goodsInfo.put("goodsTitle", getGoodsInfoRs.getString("goodsTitle"));
		goodsInfo.put("imgName", getGoodsInfoRs.getString("imgName"));
		goodsInfo.put("goodsContent", getGoodsInfoRs.getString("goodsContent"));
		goodsInfo.put("goodsPrice", getGoodsInfoRs.getString("goodsPrice"));
		goodsInfo.put("goodsAmount", getGoodsInfoRs.getString("goodsAmount"));
		goodsInfo.put("createDate", getGoodsInfoRs.getString("createDate"));

	}
	
	String getCategorySql = "SELECT category FROM category";
	PreparedStatement getCategoryStmt = null;
	ResultSet getCategoryRs = null;
	getCategoryStmt = conn.prepareStatement(getCategorySql);
	getCategoryRs = getCategoryStmt.executeQuery();
	
	ArrayList<String> categoryList = new ArrayList<String>();
	while(getCategoryRs.next()) {
		categoryList.add(getCategoryRs.getString("category"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
</head>
<body>
	<!-- 메인 메뉴 -->
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		
	<h1>상품 수정</h1>
	
	<form action="/shop/emp/goods/updateGoodsAction.jsp" method="post" enctype="multipart/form-data">
	
		<div>
			상품 번호 : 
			<input type="text" name="goodsNo" value="<%=goodsNo%>" readonly="readonly">
		</div>
		
		<div>
			카테고리 : 
			<select name="category" required="required">
				<option value="">선택</option>
				<%
					for(String s : categoryList) {
						if(goodsInfo.get("category").equals(s)) {
				%>
							<option value="<%=s%>" selected="selected"><%=s%></option>
				<%
						} else {
				%>
							<option value="<%=s%>"><%=s%></option>
				<%
						}
					}
				%>
			</select>
		</div>
		
		<!-- emp_id값은 action쪽에서 세션변수에서 바인딩 -->
		<div>
			관리자 : 
			<input type="text" name="empId" value="<%=goodsInfo.get("empId")%>" readonly="readonly">
		</div>
		
		<div>
			상품명 : 
			<input type="text" name="goodsTitle" value="<%=goodsInfo.get("goodsTitle")%>" required="required">
		</div>
		
		<div>
			<div>
				<div>기존 이미지:</div>
				<img alt="" src="/shop/upload/<%=goodsInfo.get("imgName")%>">
			</div>
			
			변경할 이미지(선택 안할 시 기존 이미지 사용) : 
			<input type="file" name="newGoodsImg">
		</div>
		
		<div>
			가격 : 
			<input type="number" name="goodsPrice" value="<%=goodsInfo.get("goodsPrice")%>" required="required">
		</div>
		
		<div>
			수량 : 
			<input type="number" name="goodsAmount" value="<%=goodsInfo.get("goodsAmount")%>" required="required">
		</div>
		
		<div>
			<div>
				설명 :
			</div>
			 
			<textarea rows="5" cols="50" name="goodsContent"><%=goodsInfo.get("goodsContent")%></textarea>
		</div>
		
		<div>
			<button type="submit">상품 수정</button>
		</div>
	</form>
</body>
</html>