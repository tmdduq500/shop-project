package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class OrdersDAO {
	/* 고객이 구매확정 눌렀을 경우 구매확정으로 상태 변경 */
	public static int updateOrdersStateByCustomer(String ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String updateOrdersStateSql = "UPDATE orders SET state = '구매확정' WHERE orders_no = ?";
		PreparedStatement updateOrdersStateStmt = conn.prepareStatement(updateOrdersStateSql);
		updateOrdersStateStmt.setString(1, ordersNo);
		row = updateOrdersStateStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 고객이 주문한 것의 상세정보 확인 기능 */
	public static HashMap<String, Object> selectOrdersOneByCustomer(String ordersNo) throws Exception{
		HashMap<String, Object> ordersOne = new HashMap<>();
		
		Connection conn = DBHelper.getConnection();
		
		String ordersOneSql = "SELECT o.orders_no ordersNo, o.goods_no goodsNo, o.create_date ordersDate, o.state ordersState, o.total_price totalPrice,"
				+ " o.total_amount totalAmount, o.address orderAdderess, g.goods_title goodsTitle, g.img_name imgName"
				+ " FROM orders o INNER JOIN goods g"
				+ " ON o.goods_no = g.goods_no"
				+ " WHERE orders_no = ?";
		PreparedStatement ordersOneStmt = conn.prepareStatement(ordersOneSql);
		ordersOneStmt.setString(1, ordersNo);
		ResultSet ordersOneRs = ordersOneStmt.executeQuery();
		if(ordersOneRs.next()) {
			ordersOne.put("ordersNo", ordersOneRs.getString("ordersNo"));
			ordersOne.put("goodsTitle", ordersOneRs.getString("goodsTitle"));
			ordersOne.put("imgName", ordersOneRs.getString("imgName"));
			ordersOne.put("totalAmount", ordersOneRs.getString("totalAmount"));
			ordersOne.put("totalPrice", ordersOneRs.getString("totalPrice"));
			ordersOne.put("orderAdderess", ordersOneRs.getString("orderAdderess"));
			ordersOne.put("ordersDate", ordersOneRs.getString("ordersDate"));
			ordersOne.put("ordersState", ordersOneRs.getString("ordersState"));

		}
		
		conn.close();
		return ordersOne;
	}
	
	/* 해당 고객의 주문 개수 */
	public static int selectOrdersNumOfCustomer(String id) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String ordersNumOfCustomerSql = "SELECT COUNT(*) cnt FROM orders WHERE id = ?";
		PreparedStatement ordersNumOfCustomerStmt = conn.prepareStatement(ordersNumOfCustomerSql);
		ordersNumOfCustomerStmt.setString(1, id);
		ResultSet ordersNumOfCustomerRs = ordersNumOfCustomerStmt.executeQuery();
		if(ordersNumOfCustomerRs.next()) {
			row = ordersNumOfCustomerRs.getInt("cnt");
		}
		
		
		conn.close();
		return row;
	}
	
	/* 해당 고객의 주문 개수 */
	public static int selectTotalOrdersNum() throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String totalOrdersNumSql = "SELECT COUNT(*) cnt FROM orders";
		PreparedStatement totalOrdersNumStmt = conn.prepareStatement(totalOrdersNumSql);
		ResultSet totalOrdersNumRs = totalOrdersNumStmt.executeQuery();
		if(totalOrdersNumRs.next()) {
			row = totalOrdersNumRs.getInt("cnt");
		}
		
		conn.close();
		return row;
	}
	
	/* 고객이 주문한 것(일부 정보)을 확인할수 있는 기능(페이징 가능) */
	public static ArrayList<HashMap<String, Object>> selectOrdersListByCustomer(String id, int startRow, int rowPerPage) throws Exception{
		
		ArrayList<HashMap<String, Object>> ordersList = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String selectOrdersListSql = "SELECT o.orders_no ordersNo, o.goods_no goodsNo, o.create_date ordersDate, o.state ordersState, o.total_price totalPrice,"
				+ " g.goods_title goodsTitle"
				+ " FROM orders o inner join goods g"
				+ " ON o.goods_no = g.goods_no"
				+ " WHERE o.id = ? ORDER BY o.orders_no DESC"
				+ " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		PreparedStatement selectOrdersListStmt = conn.prepareStatement(selectOrdersListSql);
		selectOrdersListStmt.setString(1, id);
		selectOrdersListStmt.setInt(2, startRow);
		selectOrdersListStmt.setInt(3, rowPerPage);
		ResultSet selectOrdersListRs = selectOrdersListStmt.executeQuery();
		
		while (selectOrdersListRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", selectOrdersListRs.getString("ordersNo"));
			m.put("goodsNo", selectOrdersListRs.getString("goodsNo"));
			m.put("totalPrice", selectOrdersListRs.getString("totalPrice"));
			m.put("ordersDate", selectOrdersListRs.getString("ordersDate"));
			m.put("ordersState", selectOrdersListRs.getString("ordersState"));
			m.put("goodsTitle", selectOrdersListRs.getString("goodsTitle"));
			ordersList.add(m);
		}

		conn.close();
		return ordersList;
	}
	
	/* emp가 배송시작 버튼 눌렀을 경우 배송중으로 상태 변경 */
	public static int updateOrdersStateByEmp(String ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String updateOrdersStateSql = "UPDATE orders SET state = '배송중' WHERE orders_no = ?";
		PreparedStatement updateOrdersStateStmt = conn.prepareStatement(updateOrdersStateSql);
		updateOrdersStateStmt.setString(1, ordersNo);
		row = updateOrdersStateStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 고객이 주문한 것의 상세정보 확인 기능(emp) */
	public static HashMap<String, Object> selectOrdersOneByEmp(String ordersNo) throws Exception{
		HashMap<String, Object> ordersOne = new HashMap<>();
		
		Connection conn = DBHelper.getConnection();
		
		String ordersOneSql = "SELECT o.orders_no ordersNo, o.id customerId, o.goods_no goodsNo, o.create_date ordersDate, o.state ordersState, o.total_price totalPrice,"
				+ " o.total_amount totalAmount, o.address orderAdderess, g.goods_title goodsTitle, g.img_name imgName"
				+ " FROM orders o INNER JOIN goods g"
				+ " ON o.goods_no = g.goods_no"
				+ " WHERE orders_no = ?";
		PreparedStatement ordersOneStmt = conn.prepareStatement(ordersOneSql);
		ordersOneStmt.setString(1, ordersNo);
		ResultSet ordersOneRs = ordersOneStmt.executeQuery();
		if(ordersOneRs.next()) {
			ordersOne.put("ordersNo", ordersOneRs.getString("ordersNo"));
			ordersOne.put("customerId", ordersOneRs.getString("customerId"));
			ordersOne.put("goodsTitle", ordersOneRs.getString("goodsTitle"));
			ordersOne.put("imgName", ordersOneRs.getString("imgName"));
			ordersOne.put("totalAmount", ordersOneRs.getString("totalAmount"));
			ordersOne.put("totalPrice", ordersOneRs.getString("totalPrice"));
			ordersOne.put("orderAdderess", ordersOneRs.getString("orderAdderess"));
			ordersOne.put("ordersDate", ordersOneRs.getString("ordersDate"));
			ordersOne.put("ordersState", ordersOneRs.getString("ordersState"));
		}
		
		conn.close();
		return ordersOne;
	}
		
	/* 관리자가 주문 전체를 확인할 수 있는 기능(페이징 가능) */
	public static ArrayList<HashMap<String, Object>> selectTotalOrdersList(int startRow, int rowPerPage) throws Exception{
		
		ArrayList<HashMap<String, Object>> ordersList = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String selectTotalOrdersListSql = "SELECT o.orders_no ordersNo, o.id customerId, o.goods_no goodsNo, o.create_date ordersDate, o.state ordersState, o.total_price totalPrice,"
				+ " g.goods_title goodsTitle"
			 	+ " FROM orders o inner join goods g"
				+ " on o.goods_no = g.goods_no"
				+ " ORDER BY o.orders_no DESC"
				+ " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		PreparedStatement selectTotalOrdersListStmt = conn.prepareStatement(selectTotalOrdersListSql);
		selectTotalOrdersListStmt.setInt(1, startRow);
		selectTotalOrdersListStmt.setInt(2, rowPerPage);
		ResultSet selectTotalOrdersListRs = selectTotalOrdersListStmt.executeQuery();
		
		while (selectTotalOrdersListRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", selectTotalOrdersListRs.getString("ordersNo"));
			m.put("customerId", selectTotalOrdersListRs.getString("customerId"));
			m.put("goodsNo", selectTotalOrdersListRs.getString("goodsNo"));
			m.put("totalPrice", selectTotalOrdersListRs.getString("totalPrice"));
			m.put("ordersDate", selectTotalOrdersListRs.getString("ordersDate"));
			m.put("ordersState", selectTotalOrdersListRs.getString("ordersState"));
			m.put("goodsTitle", selectTotalOrdersListRs.getString("goodsTitle"));
			ordersList.add(m);
		}
		
		conn.close();
		return ordersList;
	}
	
	/* 고객이 주문한 것을 [DB]orders에 추가하기 */
	public static int insertOrdersOfCustomer(String id, int goodsNo, int totalAmount, int totalPrice, String address) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String insertOrdersSql = "INSERT INTO orders(orders_no, id, goods_no, total_amount, total_price, address, update_date, create_date)"
				+ " VALUES(s_orders_no.nextval, ?, ?, ?, ?, ?, sysdate, sysdate)";
		PreparedStatement insertOrdersStmt = conn.prepareStatement(insertOrdersSql);
		insertOrdersStmt.setString(1, id);
		insertOrdersStmt.setInt(2, goodsNo);
		insertOrdersStmt.setInt(3, totalAmount);
		insertOrdersStmt.setInt(4, totalPrice);
		insertOrdersStmt.setString(5, address);
		row = insertOrdersStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
}
