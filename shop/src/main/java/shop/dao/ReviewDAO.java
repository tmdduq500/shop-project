package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class ReviewDAO {
	/* 해당 상품의 리뷰 개수 구하기 */
	public static int selectTotalReviewOfGoodsRow(String goodsNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT COUNT(*) cnt"
				+ " FROM review r INNER JOIN orders o"
				+ " ON r.orders_no = o.orders_no"
				+ " WHERE o.goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, goodsNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		
		conn.close();
		return row;
	}
	
	/* 모든 상품의 리뷰 개수 구하기 */
	public static int selectTotalReviewRow() throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT COUNT(*) cnt"
				+ " FROM review r INNER JOIN orders o"
				+ " ON r.orders_no = o.orders_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		
		conn.close();
		return row;
	}
	
	/* 리뷰테이블과 상품 상세보기 조인 - 특정 상품(customer) */
	public static ArrayList<HashMap<String, Object>> selectReviewJoinGoods(String goodsNo, int startRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String selectReviewJoinSql = "SELECT o.goods_no goodsNo, o.orders_no ordersNo, o.id, RPAD(SUBSTR(o.id, 1, 2), LENGTH(o.id), '*') reviewCustomerId,"
				+ " r.score, r.content, r.create_date createDate, SUBSTR(r.create_date, 1, 10) reviewCreateDate"
				+ " FROM review r INNER JOIN orders o"
				+ " ON r.orders_no = o.orders_no"
				+ " WHERE o.goods_no = ?"
				+ " ORDER BY createDate DESC"
				+ " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		PreparedStatement selectReviewJoinStmt = conn.prepareStatement(selectReviewJoinSql);
		selectReviewJoinStmt.setString(1, goodsNo);
		selectReviewJoinStmt.setInt(2, startRow);
		selectReviewJoinStmt.setInt(3, rowPerPage);
		ResultSet selectReviewJoinRs = selectReviewJoinStmt.executeQuery();
		while (selectReviewJoinRs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("goodsNo", selectReviewJoinRs.getInt("goodsNo"));
			m.put("ordersNo", selectReviewJoinRs.getString("ordersNo"));
			m.put("customerId", selectReviewJoinRs.getString("id"));
			m.put("reviewCustomerId", selectReviewJoinRs.getString("reviewCustomerId"));
			m.put("score", selectReviewJoinRs.getInt("score"));
			m.put("content", selectReviewJoinRs.getString("content"));
			m.put("createDate", selectReviewJoinRs.getString("createDate"));
			m.put("reviewCreateDate", selectReviewJoinRs.getString("reviewCreateDate"));
			list.add(m);
		}
		
		conn.close();
		return list;
	}
	
	/* 리뷰테이블과 상품 테이블 조인 - 모든 상품(emp) */
	public static ArrayList<HashMap<String, Object>> selectTotalReviewJoinGoods(int startRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String selectReviewJoinSql = "SELECT o.goods_no goodsNo, o.orders_no ordersNo, o.id, RPAD(SUBSTR(o.id, 1, 2), LENGTH(o.id), '*') reviewCustomerId,"
				+ " r.score, r.content, r.create_date createDate, SUBSTR(r.create_date, 1, 10) reviewCreateDate"
				+ " FROM review r INNER JOIN orders o"
				+ " ON r.orders_no = o.orders_no"
				+ " ORDER BY createDate DESC"
				+ " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		PreparedStatement selectReviewJoinStmt = conn.prepareStatement(selectReviewJoinSql);
		selectReviewJoinStmt.setInt(1, startRow);
		selectReviewJoinStmt.setInt(2, rowPerPage);
		ResultSet selectReviewJoinRs = selectReviewJoinStmt.executeQuery();
		while (selectReviewJoinRs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("goodsNo", selectReviewJoinRs.getInt("goodsNo"));
			m.put("ordersNo", selectReviewJoinRs.getInt("ordersNo"));
			m.put("customerId", selectReviewJoinRs.getString("id"));
			m.put("reviewCustomerId", selectReviewJoinRs.getString("reviewCustomerId"));
			m.put("score", selectReviewJoinRs.getInt("score"));
			m.put("content", selectReviewJoinRs.getString("content"));
			m.put("createDate", selectReviewJoinRs.getString("createDate"));
			m.put("reviewCreateDate", selectReviewJoinRs.getString("reviewCreateDate"));
			list.add(m);
		}
		
		conn.close();
		return list;
	}
	
	/* 리뷰 작성하기 */
	public static int insertReview(int ordersNo, int score, String content) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String insertReviewSql = "INSERT INTO review(orders_no, score, content, create_date) VALUES(?, ?, ?, SYSDATE)";
		PreparedStatement insertReviewStmt = conn.prepareStatement(insertReviewSql);
		insertReviewStmt.setInt(1, ordersNo);
		insertReviewStmt.setInt(2, score);
		insertReviewStmt.setString(3, content);
		row = insertReviewStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 리뷰 삭제하기 */
	public static int deleteReview(String ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String deleteReviewSql = "DELETE FROM review WHERE orders_no = ?";
		PreparedStatement deleteReviewStmt = conn.prepareStatement(deleteReviewSql);
		deleteReviewStmt.setString(1, ordersNo);
		row = deleteReviewStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 해당 주문 번호에 작성된 리뷰와 상품 정보 가져오기 */
	public static HashMap<String, Object> selectReviewOne(int ordersNo) throws Exception{
		HashMap<String, Object> reviewOne = null;
		
		Connection conn = DBHelper.getConnection();
		
		String selectReviewOneSql = "SELECT r.orders_no ordersNo, r.score, r.content, r.create_date createDate, o.goods_no goodsNo, o.id"
				+ " FROM review r INNER JOIN orders o"
				+ " ON r.orders_no = o.orders_no"
				+ " WHERE r.orders_no = ?";
		PreparedStatement selectReviewOneStmt = conn.prepareStatement(selectReviewOneSql);
		selectReviewOneStmt.setInt(1, ordersNo);
		ResultSet selectReviewOneRs = selectReviewOneStmt.executeQuery();
		
		if(selectReviewOneRs.next()) {
			reviewOne = new HashMap<>();
			reviewOne.put("goodsNo", selectReviewOneRs.getString("goodsNo"));
			reviewOne.put("ordersNo", selectReviewOneRs.getInt("ordersNo"));
			reviewOne.put("customerId", selectReviewOneRs.getString("id"));
			reviewOne.put("score", selectReviewOneRs.getInt("score"));
			reviewOne.put("content", selectReviewOneRs.getString("content"));
			reviewOne.put("createDate", selectReviewOneRs.getString("createDate"));
		}
		
		conn.close();
		return reviewOne;
	}
}
