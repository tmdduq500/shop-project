<%@page import="java.nio.file.Files"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Controller Layer -->
<%@ include file="/emp/inc/commonSessionCheck.jsp"%>

<!-- Session 설정 값 : 입력할 때 로그인한 emp의 emp_id값이 필요하기 때문! -->
<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<!-- Model Layer -->
<%
	// 요청 값 분석
	String category = request.getParameter("category");
	String goodsTitle = request.getParameter("goodsTitle");
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter("goodsAmount");
	String goodsContent = request.getParameter("goodsContent");
	
	Part part = request.getPart("goodsImg");
	String originalName = part.getSubmittedFileName();
	// 원본 이름에서 확장자만 분리
	int dotIndex = originalName.lastIndexOf(".");
	String ext = originalName.substring(dotIndex);	// 확장자(ex. jpg, png ...)
	
	UUID uuid = UUID.randomUUID();
	String imgName = uuid.toString().replace("-", "");
	imgName = imgName + ext;
	
	
	// 요청 값이 1개라도 null일시
	if(category == null || goodsTitle == null || goodsPrice == null || 
			goodsAmount == null || goodsContent == null) {
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
	}
	
	// 요청값 디버깅
	System.out.println("addGoodsAction - category = " + category);
	System.out.println("addGoodsAction - goodsTitle = " + goodsTitle);
	System.out.println("addGoodsAction - goodsPrice = " + goodsPrice);
	System.out.println("addGoodsAction - goodsAmount = " + goodsAmount);
	System.out.println("addGoodsAction - goodsContent = " + goodsContent);
	System.out.println("addGoodsAction - imgName = " + imgName);
%>

<!-- Controller Layer -->
<%
	/* DB 연결 및 초기화 */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", "root", "java1234");

	/* [DB]shop.goods에 goods 추가하는 sql */
	String addGoodsSql = "INSERT INTO goods(category, emp_id, goods_title, img_name, goods_content, goods_price, goods_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement addGoodsStmt = null;
	
	addGoodsStmt = conn.prepareStatement(addGoodsSql);
	addGoodsStmt.setString(1, category);
	addGoodsStmt.setString(2, (String)(loginMember.get("empId")));
	addGoodsStmt.setString(3, goodsTitle);
	addGoodsStmt.setString(4, imgName);
	addGoodsStmt.setString(5, goodsContent);
	addGoodsStmt.setInt(6, Integer.parseInt(goodsPrice));
	addGoodsStmt.setInt(7, Integer.parseInt(goodsAmount));
	
	int row = addGoodsStmt.executeUpdate();
	
	if(row == 1) {
		// 상품 등록 성공
		// part -> 1. inputStream -> 2. outputStream -> 3. 빈 파일 생성
		
		// 1번
		InputStream is = part.getInputStream();
		// 3번 + 2번 같이
		String imgPath = request.getServletContext().getRealPath("upload");
		System.out.println("addGoodsAction - imgPath = " + imgPath);
		System.out.println("addGoodsAction - imgName = " + imgName);
		File image = new File(imgPath, imgName);	// 빈 파일 생성
		OutputStream os = Files.newOutputStream(image.toPath());	// os + file
		is.transferTo(os);
		
		os.close();
		is.close();
		
		System.out.println("상품 등록 성공");
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
	} else {
		// 상품 등록 실패
		System.out.println("상품 등록 실패");
		response.sendRedirect("/shop/emp/goods/addGoodsForm.jsp");
	}
	
	// 이미지 삭제하기
// 	File deleteFile = new File(imgPath, rs.getString("file_name"));
// 	deleteFile.delete();
	
%>