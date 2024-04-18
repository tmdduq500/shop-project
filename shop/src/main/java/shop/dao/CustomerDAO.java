package shop.dao;

import java.sql.*;
import java.util.HashMap;

public class CustomerDAO {
	
	/* 고객 로그인 */
	public static HashMap<String, String> loginCustomer(String customerId, String customerPw) throws Exception{
		
		HashMap<String, String> loginCustomerMap = null; 
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String customerLoginSql = "SELECT id customerId, name customerName FROM customer WHERE id = ? AND pw = ?";
		PreparedStatement customerLoginStmt = conn.prepareStatement(customerLoginSql);
		
		customerLoginStmt.setString(1, customerId);
		customerLoginStmt.setString(2, customerPw);
		ResultSet customerLoginRs = customerLoginStmt.executeQuery();
		
		if(customerLoginRs.next()) {
			loginCustomerMap = new HashMap<String, String>();
			loginCustomerMap.put("customerId", customerLoginRs.getString("customerId"));
			loginCustomerMap.put("customerName", customerLoginRs.getString("customerName"));
		}
		
		conn.close();
		return loginCustomerMap;
	}
	
	/* 고객 정보 가져오기 */
	public static HashMap<String, Object> getCustomerInfo(String customerId) throws Exception{
		
		HashMap<String, Object> customerInfo = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 고객 정보 가져오는 쿼리
		String getCustomerInfoSql = "SELECT id, name, birth, gender, update_date updateDate, create_date createDate FROM customer WHERE id = ?";
		PreparedStatement getCustomerInfoStmt = conn.prepareStatement(getCustomerInfoSql);		
		getCustomerInfoStmt.setString(1, customerId);
		ResultSet getCustomerInfoRs = getCustomerInfoStmt.executeQuery();
		
		if(getCustomerInfoRs.next()) {
			customerInfo = new HashMap<String, Object>();
			customerInfo.put("customerId", getCustomerInfoRs.getString("id"));
			customerInfo.put("customerName", getCustomerInfoRs.getString("name"));
			customerInfo.put("customerBirth", getCustomerInfoRs.getString("birth"));
			customerInfo.put("customerGender", getCustomerInfoRs.getString("gender"));
			customerInfo.put("updateDate", getCustomerInfoRs.getString("updateDate"));
			customerInfo.put("createDate", getCustomerInfoRs.getString("createDate"));
		}
		
		conn.close();
		return customerInfo;
	}
	
	/* 고객 회원가입 */
	public static int addCustomer(String customerId, String customerPw, 
		String customerName, String customerBirth, String customerGender) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		//[DB]shop.customer에 INSERT쿼리로 data 삽입
		String addCustomerSql = "INSERT INTO customer(id, pw, name, birth, gender, update_date, create_date) VALUES(?, ?, ?, ?, ?, sysdate, sysdate)";
		PreparedStatement addCustomerStmt = null;
		addCustomerStmt = conn.prepareStatement(addCustomerSql);
		addCustomerStmt.setString(1, customerId);
		addCustomerStmt.setString(2, customerPw);
		addCustomerStmt.setString(3, customerName);
		addCustomerStmt.setString(4, customerBirth);
		addCustomerStmt.setString(5, customerGender);
		
		row = addCustomerStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	/* 고객 아이디 중복 확인 */
	public static boolean checkDuplicatedId(String checkCustomerId) throws Exception{
		boolean result = false;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String checkIdSql  = "SELECT id FROM customer WHERE id = ?";
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
	public static void deleteCustomer() {
		
	}
	
	/* 정보 수정 전 고객 id, pw 확인 */
	public static boolean checkCustomerIdPw(String customerId, String customerPw) throws Exception{
		boolean result = false;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String checkIdPwSql = "SELECT id customerID FROM customer WHERE id = ? AND pw = ?";
		PreparedStatement checkIdPwStmt = conn.prepareStatement(checkIdPwSql);
		checkIdPwStmt.setString(1, customerId);
		checkIdPwStmt.setString(2, customerPw);
		ResultSet checkIdPwRs = checkIdPwStmt.executeQuery();
		
		if(checkIdPwRs.next()) {
			result = true;
		}
		
		conn.close();
		return result;
	}
	
	/* 고객 정보 변경 */
	public static int updateCustomer(String customerId, String customerName, String customerBirth, 
			String customerGender, String oldCustomerPw, String newCustomerPw) throws Exception {
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String updateCustomerSql = "UPDATE customer SET name = ?, birth = ?, gender = ?, update_date = sysdate, pw = ? WHERE id = ? AND pw = ?";
		PreparedStatement updateCustomerStmt = conn.prepareStatement(updateCustomerSql);
		updateCustomerStmt.setString(1, customerName);
		updateCustomerStmt.setString(2, customerBirth);
		updateCustomerStmt.setString(3, customerGender);
		updateCustomerStmt.setString(4, newCustomerPw);
		updateCustomerStmt.setString(5, customerId);
		updateCustomerStmt.setString(6, oldCustomerPw);
		row = updateCustomerStmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	
}
