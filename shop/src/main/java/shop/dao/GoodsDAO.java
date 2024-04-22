package shop.dao;

import java.io.*;
import java.nio.file.Files;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class GoodsDAO {
	/* 리뷰테이블과 상품 상세보기 조인 */
	public static ArrayList<HashMap<String, Object>> selectReviewJoinGoods(int startRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String, Object>> reviewJoinGoodsList = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String selectReviewJoinSql = "SELECT o.goods_no, c.score, c.content"
				+ " FROM COMMENT c INNER JOIN orders o"
				+ " ON c.orders_no = o.orders_no"
				+ " WHERE o.goods_no = 1"
				+ " offset ? rows fetch next ? rows only";
		
		
		conn.close();
		return reviewJoinGoodsList;
	}
	/* 전체 goods 수 구하기 */
	public static int selectTotalGoods() throws Exception{
		int totalGoodsRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 전체 goods Row 구하기
		String selectTotalGoodsRowSql = "SELECT COUNT(*) cnt FROM goods";
		PreparedStatement selectTotalGoodsRowStmt = null;
	
		// category
		selectTotalGoodsRowStmt = conn.prepareStatement(selectTotalGoodsRowSql);

		ResultSet selectTotalGoodsRowRs = selectTotalGoodsRowStmt.executeQuery();
		
		if(selectTotalGoodsRowRs.next()) {
			totalGoodsRow = selectTotalGoodsRowRs.getInt("cnt");
		}
		
		conn.close();
		return totalGoodsRow;
	}
	
	/* 카테고리별 goods Row 구하기 */
	public static int selectGoodsPerCategory(String category) throws Exception{
		int goodsPerCategoryRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 카테고리별 goods 수 구하기
		String selectGoodsPerCategoryRowSql = "SELECT COUNT(*) cnt FROM goods WHERE 1 = 1";
		PreparedStatement selectGoodsPerCategoryRowStmt = null;
	
		// category
		if(category.equals("all")) {
			selectGoodsPerCategoryRowStmt = conn.prepareStatement(selectGoodsPerCategoryRowSql);
		} else {
			selectGoodsPerCategoryRowSql = selectGoodsPerCategoryRowSql + " " + "AND category = ?";
			selectGoodsPerCategoryRowStmt = conn.prepareStatement(selectGoodsPerCategoryRowSql);
			selectGoodsPerCategoryRowStmt.setString(1, category);
		}
		
		ResultSet selectTotalGoodsRowRs = selectGoodsPerCategoryRowStmt.executeQuery();
		
		if(selectTotalGoodsRowRs.next()) {
			goodsPerCategoryRow = selectTotalGoodsRowRs.getInt("cnt");
		}

		conn.close();
		return goodsPerCategoryRow;
	}
	
	/* 사이드바 카테고리, 카테고리 별 상품 수 구하기 */
	public static ArrayList<HashMap<String, Object>> selectGoodsCntPerCategory() throws Exception{
		
		ArrayList<HashMap<String, Object>> goodsCntPerCategory = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 카테고리 별 상품 수 가져오는 sql쿼리 */
		String getCategorySql = "SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category ASC";
		PreparedStatement getCategoryStmt = null;
		ResultSet getCategoryRs = null;
		
		getCategoryStmt = conn.prepareStatement(getCategorySql);
		getCategoryRs = getCategoryStmt.executeQuery();
		goodsCntPerCategory = new ArrayList<HashMap<String, Object>>();
		
		while(getCategoryRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("category", getCategoryRs.getString("category"));
			m.put("cnt", getCategoryRs.getInt("cnt"));
			goodsCntPerCategory.add(m);
		}
		
		conn.close();
		return goodsCntPerCategory;
		
	}

	
	
	/* goods 목록 출력 */
	public static ArrayList<HashMap<String, Object>> selectGoodsList(int startRow, int rowPerPage, String category) throws Exception{
		ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();

		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* category 별로 상품 보여주는 sql */
		/*
			category
			
			null이면
			SELECT * FROM goods
			
			null이 아니면
			SELECT * FROM goods WHERE category = ?
		
		*/
		
		String selectTotalGoodsSql = "SELECT goods_no goodsNo, category, goods_title goodsTitle, img_name imgName, "
				+ "goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount FROM goods ";
		PreparedStatement selectTotalGoodsStmt = null;
		
		ResultSet selectTotalGoodsRs = null;
		
		if(category.equals("all")) {
			selectTotalGoodsSql = selectTotalGoodsSql + "ORDER BY create_date DESC offset ? rows fetch next ? rows only";
			selectTotalGoodsStmt = conn.prepareStatement(selectTotalGoodsSql);
			selectTotalGoodsStmt.setInt(1, startRow);
			selectTotalGoodsStmt.setInt(2, rowPerPage);
			selectTotalGoodsRs = selectTotalGoodsStmt.executeQuery();
			
		} else {
			selectTotalGoodsSql = selectTotalGoodsSql + " " + "WHERE category = ? ORDER BY create_date DESC offset ? rows fetch next ? rows only";
			selectTotalGoodsStmt = conn.prepareStatement(selectTotalGoodsSql);
			selectTotalGoodsStmt.setString(1, category);
			selectTotalGoodsStmt.setInt(2, startRow);
			selectTotalGoodsStmt.setInt(3, rowPerPage);
			selectTotalGoodsRs = selectTotalGoodsStmt.executeQuery();
		}
		
		while(selectTotalGoodsRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsNo", selectTotalGoodsRs.getString("goodsNo"));
			m.put("category", selectTotalGoodsRs.getString("category"));
			m.put("goodsTitle", selectTotalGoodsRs.getString("goodsTitle"));
			m.put("imgName", selectTotalGoodsRs.getString("imgName"));
			m.put("goodsContent", selectTotalGoodsRs.getString("goodsContent"));
			m.put("goodsPrice", selectTotalGoodsRs.getString("goodsPrice"));
			m.put("goodsAmount", selectTotalGoodsRs.getString("goodsAmount"));
			goodsList.add(m);
		}
		
		conn.close();
		return goodsList;
	}
	
	
	/* 카테고리 목록 얻기 */
	public static ArrayList<String> selectCategoryList() throws Exception{
		
		ArrayList<String> categoryList = new ArrayList<String>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String getCategorySql = "SELECT category FROM category";
		PreparedStatement getCategoryStmt = null;
		ResultSet getCategoryRs = null;
		getCategoryStmt = conn.prepareStatement(getCategorySql);
		getCategoryRs = getCategoryStmt.executeQuery();
		
		
		while(getCategoryRs.next()) {
			categoryList.add(getCategoryRs.getString("category"));
		}
		
		conn.close();
		return categoryList;
	}
	
	/* 상품 추가 */
	public static int insertGoods(String category, String empId, String goodsTitle, 
			String imgName, String goodsContent, int goodsPrice, int goodsAmount) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* [DB]shop.goods에 goods 추가하는 sql */
		String insertGoodsSql = "INSERT INTO goods(goods_no, category, emp_id, goods_title, img_name, goods_content, goods_price, goods_amount, update_date, create_date) "
				+ "VALUES (s_goods_no.nextval, ?, ?, ?, ?, ?, ?, ?, sysdate, sysdate)";
		PreparedStatement insertGoodsStmt = null;
		
		insertGoodsStmt = conn.prepareStatement(insertGoodsSql);
		insertGoodsStmt.setString(1, category);
		insertGoodsStmt.setString(2, empId);
		insertGoodsStmt.setString(3, goodsTitle);
		insertGoodsStmt.setString(4, imgName);
		insertGoodsStmt.setString(5, goodsContent);
		insertGoodsStmt.setInt(6, goodsPrice);
		insertGoodsStmt.setInt(7, goodsAmount);
		
		row = insertGoodsStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 이미지 업로드 */
	public static void uploadGoodsImg(String imgPath, String imgName, InputStream is) throws Exception {
		// part -> 1. inputStream -> 2. outputStream -> 3. 빈 파일 생성
		
		File image = new File(imgPath, imgName);	// 빈 파일 생성
		OutputStream os = Files.newOutputStream(image.toPath());	// os + file
		is.transferTo(os);
		
		os.close();
		is.close();
	}
	
	/* 상품 정보 가져오기 */
	public static HashMap<String, Object> selectGoodsInfo(String goodsNo) throws Exception{
		HashMap<String, Object> goodsInfo = new HashMap<String, Object>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 상품 하나의 모든 정보 가져오는 쿼리 */
		String selectGoodsInfoSql = "SELECT category, emp_id empId, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount, create_date createDate FROM goods WHERE goods_no = ?";
		PreparedStatement selectGoodsInfoStmt = null;
		ResultSet selectGoodsInfoRs = null;
		selectGoodsInfoStmt = conn.prepareStatement(selectGoodsInfoSql);
		selectGoodsInfoStmt.setString(1, goodsNo);
		selectGoodsInfoRs = selectGoodsInfoStmt.executeQuery();
		
		while(selectGoodsInfoRs.next()) {
			goodsInfo.put("category", selectGoodsInfoRs.getString("category"));
			goodsInfo.put("empId", selectGoodsInfoRs.getString("empId"));
			goodsInfo.put("goodsTitle", selectGoodsInfoRs.getString("goodsTitle"));
			goodsInfo.put("imgName", selectGoodsInfoRs.getString("imgName"));
			goodsInfo.put("goodsContent", selectGoodsInfoRs.getString("goodsContent"));
			goodsInfo.put("goodsPrice", selectGoodsInfoRs.getString("goodsPrice"));
			goodsInfo.put("goodsAmount", selectGoodsInfoRs.getString("goodsAmount"));
			goodsInfo.put("createDate", selectGoodsInfoRs.getString("createDate"));

		}
		
		conn.close();
		return goodsInfo; 
		
	}
	
	/* id,pw 확인 */
	public static HashMap<String, String> checkIdPw(String empId, String empPw) throws Exception{
		HashMap<String, String> checkIdPwMap = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String checkEmpIdPwSql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = ?";
		PreparedStatement checkEmpIdPwStmt = conn.prepareStatement(checkEmpIdPwSql);
		checkEmpIdPwStmt.setString(1, empId);
		checkEmpIdPwStmt.setString(2, empPw);
		ResultSet checkEmpIdPwRs = checkEmpIdPwStmt.executeQuery();
		
		if (checkEmpIdPwRs.next()) {
			checkIdPwMap = new HashMap<String, String>();
			checkIdPwMap.put("empId", checkEmpIdPwRs.getString("empId"));
		}
		
		conn.close();
		return checkIdPwMap;
	}
	
	/* 상품 삭제하기 */
	public static int deleteGoods(String goodsNo, String imgPath, String imgName) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품 삭제 쿼리
		String deleteGoodsSql = "DELETE FROM goods WHERE goods_no = ?";
		PreparedStatement deleteGoodsStmt = null;
		deleteGoodsStmt = conn.prepareStatement(deleteGoodsSql);
		deleteGoodsStmt.setString(1, goodsNo);
		
		row = deleteGoodsStmt.executeUpdate();
		
		// 이미지 삭제하기
		System.out.println("deleteGoodsAction - imgPath = " + imgPath);
		
	 	File deleteFile = new File(imgPath, imgName);
	 	deleteFile.delete();
	 	
	 	conn.close();
		return row;
	}
	
	/* 상품 수정하기 */
	public static int updateGoods(String category, String goodsTitle, String goodsContent, 
			String goodsPrice, String goodsAmount, String goodsNo, String newImgName) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 상품 하나의 정보를 업데이트 하는 쿼리 */
		String updateGoodsSql = "UPDATE goods SET category = ?, goods_title = ?, goods_content = ?, goods_price = ?, goods_amount = ?, update_date = sysdate";
		PreparedStatement updateGoodsStmt = null;
		
		// 새로운 이미지 업로드 x -> 기존 이미지 사용 ()
		if(newImgName.equals("")) {
			updateGoodsSql = updateGoodsSql + " " + "WHERE goods_no = ?";
			updateGoodsStmt = conn.prepareStatement(updateGoodsSql);
			updateGoodsStmt.setString(1, category);
			updateGoodsStmt.setString(2, goodsTitle);
			updateGoodsStmt.setString(3, goodsContent);
			updateGoodsStmt.setString(4, goodsPrice);
			updateGoodsStmt.setString(5, goodsAmount);
			updateGoodsStmt.setString(6, goodsNo);
		} else {
			// 새로운 이미지 업로드!
			updateGoodsSql = updateGoodsSql + ",img_name = ? WHERE goods_no = ?";
			updateGoodsStmt = conn.prepareStatement(updateGoodsSql);
			updateGoodsStmt.setString(1, category);
			updateGoodsStmt.setString(2, goodsTitle);
			updateGoodsStmt.setString(3, goodsContent);
			updateGoodsStmt.setString(4, goodsPrice);
			updateGoodsStmt.setString(5, goodsAmount);
			updateGoodsStmt.setString(6, newImgName);
			updateGoodsStmt.setString(7, goodsNo);
		}
		
		row = updateGoodsStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 상품 주문 or 주문 취소할 경우 수량 수정하기 */
	public static int updateGoodsAmount(int goodsNo, int amount) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String updateGoodsAmountSql = "UPDATE goods SET goods_amount = ?, update_date = sysdate WHERE goods_no = ?";
		PreparedStatement updateGoodsAmountStmt = conn.prepareStatement(updateGoodsAmountSql);
		updateGoodsAmountStmt.setInt(1, amount);
		updateGoodsAmountStmt.setInt(2, goodsNo);
		row = updateGoodsAmountStmt.executeUpdate();
		
		conn.close();
		return row;
		
	}
}