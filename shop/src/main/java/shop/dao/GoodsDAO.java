package shop.dao;

import java.io.*;
import java.nio.file.Files;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class GoodsDAO {
	
	/* 전체 goods 수 구하기 */
	public static int getTotalGoods() throws Exception{
		int totalGoodsRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 전체 goods Row 구하기
		String getTotalGoodsRowSql = "SELECT COUNT(*) cnt FROM goods";
		PreparedStatement getTotalGoodsRowStmt = null;
	
		// category
		getTotalGoodsRowStmt = conn.prepareStatement(getTotalGoodsRowSql);

		ResultSet getTotalGoodsRowRs = getTotalGoodsRowStmt.executeQuery();
		
		if(getTotalGoodsRowRs.next()) {
			totalGoodsRow = getTotalGoodsRowRs.getInt("cnt");
		}
		
		conn.close();
		return totalGoodsRow;
	}
	
	/* 카테고리별 goods Row 구하기 */
	public static int getGoodsPerCategory(String category) throws Exception{
		int goodsPerCategoryRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 카테고리별 goods 수 구하기
		String getgoodsPerCategoryRowSql = "SELECT COUNT(*) cnt FROM goods WHERE 1 = 1";
		PreparedStatement getgoodsPerCategoryRowStmt = null;
	
		// category
		if(category.equals("all")) {
			getgoodsPerCategoryRowStmt = conn.prepareStatement(getgoodsPerCategoryRowSql);
		} else {
			getgoodsPerCategoryRowSql = getgoodsPerCategoryRowSql + " " + "AND category = ?";
			getgoodsPerCategoryRowStmt = conn.prepareStatement(getgoodsPerCategoryRowSql);
			getgoodsPerCategoryRowStmt.setString(1, category);
		}
		
		ResultSet getTotalGoodsRowRs = getgoodsPerCategoryRowStmt.executeQuery();
		
		if(getTotalGoodsRowRs.next()) {
			goodsPerCategoryRow = getTotalGoodsRowRs.getInt("cnt");
		}

		conn.close();
		return goodsPerCategoryRow;
	}
	
	/* 사이드바 카테고리, 카테고리 별 상품 수 구하기 */
	public static ArrayList<HashMap<String, Object>> getGoodsCntPerCategory() throws Exception{
		
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
		
		String getTotalGoodsSql = "SELECT goods_no goodsNo, category, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount FROM goods ";
		PreparedStatement getTotalGoodsStmt = null;
		
		ResultSet getTotalGoodsRs = null;
		
		if(category.equals("all")) {
			getTotalGoodsSql = getTotalGoodsSql + "ORDER BY create_date DESC LIMIT ?,?";
			getTotalGoodsStmt = conn.prepareStatement(getTotalGoodsSql);
			getTotalGoodsStmt.setInt(1, startRow);
			getTotalGoodsStmt.setInt(2, rowPerPage);
			getTotalGoodsRs = getTotalGoodsStmt.executeQuery();
			
		} else {
			getTotalGoodsSql = getTotalGoodsSql + " " + "WHERE category = ? ORDER BY create_date DESC LIMIT ?,?";
			getTotalGoodsStmt = conn.prepareStatement(getTotalGoodsSql);
			getTotalGoodsStmt.setString(1, category);
			getTotalGoodsStmt.setInt(2, startRow);
			getTotalGoodsStmt.setInt(3, rowPerPage);
			getTotalGoodsRs = getTotalGoodsStmt.executeQuery();
		}
		
		while(getTotalGoodsRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsNo", getTotalGoodsRs.getString("goodsNo"));
			m.put("category", getTotalGoodsRs.getString("category"));
			m.put("goodsTitle", getTotalGoodsRs.getString("goodsTitle"));
			m.put("imgName", getTotalGoodsRs.getString("imgName"));
			m.put("goodsContent", getTotalGoodsRs.getString("goodsContent"));
			m.put("goodsPrice", getTotalGoodsRs.getString("goodsPrice"));
			m.put("goodsAmount", getTotalGoodsRs.getString("goodsAmount"));
			goodsList.add(m);
		}
		
		conn.close();
		return goodsList;
	}
	
	/* 상품 상세보기 */
	public static HashMap<String, Object> selectGoodsInfo(String goodsNo) throws Exception{
		HashMap<String, Object> goodsInfo = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 상품 하나의 모든 정보 가져오는 쿼리 */
		String getGoodsInfoSql = "SELECT category, emp_id empId, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount, create_date createDate FROM goods WHERE goods_no = ?";
		PreparedStatement getGoodsInfoStmt = null;
		ResultSet getGoodsInfoRs = null;
		getGoodsInfoStmt = conn.prepareStatement(getGoodsInfoSql);
		getGoodsInfoStmt.setString(1, goodsNo);
		getGoodsInfoRs = getGoodsInfoStmt.executeQuery();
		
		while(getGoodsInfoRs.next()) {
			goodsInfo = new HashMap<String, Object>();
			goodsInfo.put("category", getGoodsInfoRs.getString("category"));
			goodsInfo.put("empId", getGoodsInfoRs.getString("empId"));
			goodsInfo.put("goodsTitle", getGoodsInfoRs.getString("goodsTitle"));
			goodsInfo.put("imgName", getGoodsInfoRs.getString("imgName"));
			goodsInfo.put("goodsContent", getGoodsInfoRs.getString("goodsContent"));
			goodsInfo.put("goodsPrice", getGoodsInfoRs.getString("goodsPrice"));
			goodsInfo.put("goodsAmount", getGoodsInfoRs.getString("goodsAmount"));
			goodsInfo.put("createDate", getGoodsInfoRs.getString("createDate"));

		}
		
		return goodsInfo;
	}
	
	/* 카테고리 목록 얻기 */
	public static ArrayList<String> getCategoryList() throws Exception{
		
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
		
		return categoryList;
	}
	
	/* 상품 추가 */
	public static int addGoods(String category, String empId, String goodsTitle, 
			String imgName, String goodsContent, int goodsPrice, int goodsAmount) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* [DB]shop.goods에 goods 추가하는 sql */
		String addGoodsSql = "INSERT INTO goods(category, emp_id, goods_title, img_name, goods_content, goods_price, goods_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement addGoodsStmt = null;
		
		addGoodsStmt = conn.prepareStatement(addGoodsSql);
		addGoodsStmt.setString(1, category);
		addGoodsStmt.setString(2, empId);
		addGoodsStmt.setString(3, goodsTitle);
		addGoodsStmt.setString(4, imgName);
		addGoodsStmt.setString(5, goodsContent);
		addGoodsStmt.setInt(6, goodsPrice);
		addGoodsStmt.setInt(7, goodsAmount);
		
		row = addGoodsStmt.executeUpdate();
		
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
	public static HashMap<String, Object> getGoodsInfo(String goodsNo) throws Exception{
		HashMap<String, Object> goodsInfo = new HashMap<String, Object>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 상품 하나의 모든 정보 가져오는 쿼리 */
		String getGoodsInfoSql = "SELECT category, emp_id empId, goods_title goodsTitle, img_name imgName, goods_content goodsContent, goods_price goodsPrice, goods_amount goodsAmount, create_date createDate FROM goods WHERE goods_no = ?";
		PreparedStatement getGoodsInfoStmt = null;
		ResultSet getGoodsInfoRs = null;
		getGoodsInfoStmt = conn.prepareStatement(getGoodsInfoSql);
		getGoodsInfoStmt.setString(1, goodsNo);
		getGoodsInfoRs = getGoodsInfoStmt.executeQuery();
		
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
		
		return goodsInfo; 
		
	}
	
	/* id,pw 확인 */
	public static HashMap<String, String> checkIdPw(String empId, String empPw) throws Exception{
		HashMap<String, String> checkIdPwMap = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String checkEmpIdPwSql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = PASSWORD(?)";
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
	 	
		return row;
	}
	
	/* 상품 수정하기 */
	public static int updateGoods(String category, String goodsTitle, String goodsContent, 
			String goodsPrice, String goodsAmount, String goodsNo, String newImgName) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* 상품 하나의 정보를 업데이트 하는 쿼리 */
		String updateGoodsSql = "UPDATE goods SET category = ?, goods_title = ?, goods_content = ?, goods_price = ?, goods_amount = ?, update_date = NOW()";
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
		
		return row;
	}
	
}