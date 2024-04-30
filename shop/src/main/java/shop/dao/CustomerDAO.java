package shop.dao;

import java.sql.*;
import java.util.HashMap;

public class CustomerDAO {

	/* 고객 로그인 */
	public static HashMap<String, String> loginCustomer(String customerId, String customerPw) throws Exception {

		HashMap<String, String> loginCustomerMap = null;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String customerLoginSql = "SELECT v.id customerId, v.name customerName"
				+ " FROM"
				+ " (SELECT c.id, c.name, h.pw, h.createdate"
				+ " FROM customer c  INNER JOIN cpw_history h"
				+ " ON c.id = h.id"
				+ " WHERE c.id = ?"
				+ " ORDER BY createdate DESC"
				+ " OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) v"
				+ " WHERE v.pw = ?";
		PreparedStatement customerLoginStmt = conn.prepareStatement(customerLoginSql);

		customerLoginStmt.setString(1, customerId);
		customerLoginStmt.setString(2, customerPw);
		ResultSet customerLoginRs = customerLoginStmt.executeQuery();

		if (customerLoginRs.next()) {
			loginCustomerMap = new HashMap<String, String>();
			loginCustomerMap.put("customerId", customerLoginRs.getString("customerId"));
			loginCustomerMap.put("customerName", customerLoginRs.getString("customerName"));
		}

		conn.close();
		return loginCustomerMap;
	}

	/* 고객 정보 가져오기 */
	public static HashMap<String, Object> selectCustomerInfo(String customerId) throws Exception {

		HashMap<String, Object> customerInfo = null;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		// 고객 정보 가져오는 쿼리
		String selectCustomerInfoSql = "SELECT id, name, birth, gender, update_date updateDate, create_date createDate FROM customer WHERE id = ?";
		PreparedStatement selectCustomerInfoStmt = conn.prepareStatement(selectCustomerInfoSql);
		selectCustomerInfoStmt.setString(1, customerId);
		ResultSet selectCustomerInfoRs = selectCustomerInfoStmt.executeQuery();

		if (selectCustomerInfoRs.next()) {
			customerInfo = new HashMap<String, Object>();
			customerInfo.put("customerId", selectCustomerInfoRs.getString("id"));
			customerInfo.put("customerName", selectCustomerInfoRs.getString("name"));
			customerInfo.put("customerBirth", selectCustomerInfoRs.getString("birth"));
			customerInfo.put("customerGender", selectCustomerInfoRs.getString("gender"));
			customerInfo.put("updateDate", selectCustomerInfoRs.getString("updateDate"));
			customerInfo.put("createDate", selectCustomerInfoRs.getString("createDate"));
		}

		conn.close();
		return customerInfo;
	}

	/* 고객 회원가입 */
	public static int insertCustomer(String customerId, String customerName, String customerBirth,
			String customerGender) throws Exception {

		int row = 0;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		// [DB]shop.customer에 INSERT쿼리로 data 삽입
		String insertCustomerSql = "INSERT INTO customer(id, name, birth, gender, update_date, create_date) VALUES(?, ?, ?, ?, sysdate, sysdate)";
		PreparedStatement insertCustomerStmt = null;
		insertCustomerStmt = conn.prepareStatement(insertCustomerSql);
		insertCustomerStmt.setString(1, customerId);
		insertCustomerStmt.setString(2, customerName);
		insertCustomerStmt.setString(3, customerBirth);
		insertCustomerStmt.setString(4, customerGender);

		row = insertCustomerStmt.executeUpdate();

		conn.close();
		return row;
	}
	
	/* 고객 회원가입시, 정보 수정시 고객 비밀번호 히스토리에도 INSERT */
	public static int insertCustomerPw(String customerId, String customerPw) throws Exception {
		// 쿼리 실행 결과 행 값
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// [DB]cpw_history에 데이터 추가 
		String sql = "INSERT INTO cpw_history(id, pw, createdate) VALUES(?, ?, sysdate)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customerId);
		stmt.setString(2, customerPw);
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
		
	}
	
	/* 고객 pw 변경 시 이전 비밀번호에 동일한 값이 있는지 확인(true면 pw 변경 가능). */
	public static boolean checkCustomerPwHistory(String customerId, String newCustomerPw) throws Exception{
		// pw가 history테이블에 있는지 없는지 boolean값으로 설정
		boolean result = true;
		
		Connection conn = DBHelper.getConnection();
		// 변경할 pw가 history에 있는지 SELECT
		String sql = "SELECT c.id, c.name, h.pw, h.createdate"
				+ " FROM customer c INNER JOIN cpw_history h"
				+ " ON c.id = h.id"
				+ " WHERE c.id = ? AND h.pw = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customerId);
		stmt.setString(2, newCustomerPw);
		ResultSet rs = stmt.executeQuery();
		// history에 있다면 사용 불가능이므로 false로 변경
		if (rs.next()) {
			result = false;
		}
		
		conn.close();
		return result;
		
	}

	/* 고객 아이디 중복 확인 */
	public static boolean checkDuplicatedId(String checkCustomerId) throws Exception {
		boolean result = false;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String checkIdSql = "SELECT id FROM customer WHERE id = ?";
		PreparedStatement checkIdStmt = conn.prepareStatement(checkIdSql);
		checkIdStmt.setString(1, checkCustomerId);
		ResultSet checkIdRs = checkIdStmt.executeQuery();

		if (!checkIdRs.next()) {
			result = true;
		}

		conn.close();
		return result;
	}

	/* 회원 탈퇴 */
	public static int deleteCustomer(String id, String pw) throws Exception {
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String deleteCustomerSql = "DELETE FROM customer WHERE id = ? AND pw = ?";
		PreparedStatement deleteCustomerStmt = conn.prepareStatement(deleteCustomerSql);
		deleteCustomerStmt.setString(1, id);
		deleteCustomerStmt.setString(2, pw);
		row = deleteCustomerStmt.executeUpdate();
		
		conn.close();
		return row;
	}

	/* 고객 id, pw 확인 */
	public static boolean checkCustomerIdPw(String customerId, String customerPw) throws Exception {
		boolean result = false;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String checkIdPwSql = "SELECT v.id customerId"
				+ " FROM"
				+ " (SELECT c.id, h.pw"
				+ " FROM customer c INNER JOIN cpw_history h"
				+ " ON c.id = h.id"
				+ " WHERE c.id = ?"
				+ " ORDER BY createdate DESC"
				+ " OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) v"
				+ " WHERE v.pw = ?" ;
		PreparedStatement checkIdPwStmt = conn.prepareStatement(checkIdPwSql);
		checkIdPwStmt.setString(1, customerId);
		checkIdPwStmt.setString(2, customerPw);
		ResultSet checkIdPwRs = checkIdPwStmt.executeQuery();

		if (checkIdPwRs.next()) {
			result = true;
		}

		conn.close();
		return result;
	}

	/* 고객 정보 변경 */
	public static int updateCustomer(String customerId, String customerName, String customerBirth,
			String customerGender) throws Exception {

		int row = 0;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String updateCustomerSql = "UPDATE customer SET name = ?, birth = ?, gender = ?, update_date = sysdate WHERE id = ?";
		PreparedStatement updateCustomerStmt = conn.prepareStatement(updateCustomerSql);
		updateCustomerStmt.setString(1, customerName);
		updateCustomerStmt.setString(2, customerBirth);
		updateCustomerStmt.setString(3, customerGender);
		updateCustomerStmt.setString(4, customerId);
		row = updateCustomerStmt.executeUpdate();

		conn.close();
		return row;
	}

}
