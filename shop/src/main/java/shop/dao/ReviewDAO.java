package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

public class ReviewDAO {
	
	// 리뷰 작성하기
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
	
	// 리뷰 삭제하기
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
	
	// 해당 주문 번호에 작성된 리뷰와 상품 정보 가져오기
	public static HashMap<String, Object> selectReviewOne(int ordersNo) throws Exception{
		HashMap<String, Object> reviewOne = null;
		
		Connection conn = DBHelper.getConnection();
		
		String selectReviewOneSql = "SELECT r.orders_no ordersNo, r.score, r.content, r.create_date createDate, o.goods_no goodsNo"
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
			reviewOne.put("score", selectReviewOneRs.getInt("score"));
			reviewOne.put("content", selectReviewOneRs.getString("content"));
			reviewOne.put("createDate", selectReviewOneRs.getString("createDate"));
		}
		
		conn.close();
		return reviewOne;
	}
}
