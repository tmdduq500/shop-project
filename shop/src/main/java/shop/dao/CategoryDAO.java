package shop.dao;

import java.io.File;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CategoryDAO {
	
	/* 카테고리 목록 출력 */
	public static ArrayList<HashMap<String, Object>> selectCategoryList() throws Exception {
		
		ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* [DB]shop.category에서 category와 생성일 가져오는 쿼리 */
		String getCategorySql = "SELECT category, emp_id empId, create_date createDate FROM category ORDER BY createDate DESC";
		PreparedStatement getCategoryStmt = null;
		ResultSet getCategoryRs = null;
		
		getCategoryStmt = conn.prepareStatement(getCategorySql);
		getCategoryRs = getCategoryStmt.executeQuery();
		
		// 자료 구조 변경(ResultSet --> ArrayList<HashMap>)
		while(getCategoryRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("category", getCategoryRs.getString("category"));
			m.put("empId", getCategoryRs.getString("empId"));
			m.put("createDate", getCategoryRs.getString("createDate"));
			categoryList.add(m);
		}
		
		conn.close();
		return categoryList;
	}
	
	/* 카테고리 추가 */
	public static int insertCategory(String category, String empId) throws Exception{
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		/* [DB]shop.category에 category에 추가하는 sql */
		String insertCategorySql = "INSERT INTO category(category, create_date, emp_id) VALUES (?, sysdate, ?)";
		PreparedStatement insertCategoryStmt = null;
		
		insertCategoryStmt = conn.prepareStatement(insertCategorySql);
		insertCategoryStmt.setString(1, category);
		insertCategoryStmt.setString(2, empId);

		row = insertCategoryStmt.executeUpdate();
		
		conn.close();
		return row;
	}

	/* 카테고리 삭제시 id,pw 확인 */
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
	
	/* 해당 카테고리의 상품들의 이미지 이름 가져오기*/
	public static ArrayList<HashMap<String, String>> selectGoodsOfCategory(String category) throws Exception{
		ArrayList<HashMap<String, String>> imgNameListOfGoods = new ArrayList<HashMap<String, String>>();;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		String getGoodsOfCategorySql = "SELECT img_name imgName from goods WHERE category = ?";
		PreparedStatement getGoodsOfCategoryStmt = null;
		ResultSet getGoodsOfCategoryRs = null;
		
		getGoodsOfCategoryStmt = conn.prepareStatement(getGoodsOfCategorySql);
		getGoodsOfCategoryStmt.setString(1, category);
		getGoodsOfCategoryRs = getGoodsOfCategoryStmt.executeQuery();
		
		while (getGoodsOfCategoryRs.next()) {
			HashMap<String, String> m = new HashMap<String, String>();
			m.put("imgName", getGoodsOfCategoryRs.getString("imgName"));
			imgNameListOfGoods.add(m);
		}
		
		conn.close();
		return imgNameListOfGoods;
	}
	
	/* 카테고리의 상품 삭제 */
	public static int deleteGoodsOfCategory(String imgPath, String imgName) throws Exception{
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String deleteGoodsImgSql = "DELETE FROM goods WHERE img_name = ?";
		PreparedStatement deleteGoodsImgStmt  = conn.prepareStatement(deleteGoodsImgSql);
		deleteGoodsImgStmt.setString(1, imgName);
		row = deleteGoodsImgStmt.executeUpdate();
		
	 	File deleteFile = new File(imgPath, imgName);
	 	deleteFile.delete();
		
	 	conn.close();
		return row;
	}
	
	
	/* 카테고리 삭제 */
	public static int deleteCategory(String category, String empId) throws Exception{
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String deleteCategorySql = "DELETE FROM category WHERE category = ?";
		PreparedStatement deleteCategoryStmt = null;
		
		deleteCategoryStmt = conn.prepareStatement(deleteCategorySql);
		deleteCategoryStmt.setString(1, category);
		row = deleteCategoryStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	
}
