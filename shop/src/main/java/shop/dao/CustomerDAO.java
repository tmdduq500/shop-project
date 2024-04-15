package shop.dao;

import java.sql.*;
import java.util.HashMap;

public class CustomerDAO {
	
	/* 고객 로그인 */
	public static HashMap<String, Object> loginCustomer(String customerId, String customerPw) throws Exception{
		
		HashMap<String, Object> loginCustomerMap = null; 
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String customerLoginSql = "SELECT id customerId, name customerName FROM customer WHERE id = ? AND pw = PASSWORD(?)";
		PreparedStatement customerLoginStmt = conn.prepareStatement(customerLoginSql);
		
		customerLoginStmt.setString(1, customerId);
		customerLoginStmt.setString(2, customerPw);
		ResultSet customerLoginRs = customerLoginStmt.executeQuery();
		
		if(customerLoginRs.next()) {
			loginCustomerMap = new HashMap<String, Object>();
			loginCustomerMap.put("customerId", customerLoginRs.getString("customerId"));
			loginCustomerMap.put("customerName", customerLoginRs.getString("customerName"));
		}
		
		conn.close();
		return loginCustomerMap;
	}
	
	/* 고객 정보 가져오기 */
	public static HashMap<String, Object> getCustomerInfo(String customerId) throws Exception{
		
		HashMap<String, Object> customerInfo = new HashMap<String, Object>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 고객 정보 가져오는 쿼리
		String getCustomerInfoSql = "SELECT id, name, birth, gender, update_date updateDate, create_date createDate FROM customer WHERE id = ?";
		PreparedStatement getCustomerInfoStmt = conn.prepareStatement(getCustomerInfoSql);		
		getCustomerInfoStmt.setString(1, customerId);
		ResultSet getCustomerInfoRs = getCustomerInfoStmt.executeQuery();
		
		if(getCustomerInfoRs.next()) {
			customerInfo.put("customerId", getCustomerInfoRs.getString("id"));
			customerInfo.put("customerName", getCustomerInfoRs.getString("name"));
			customerInfo.put("customerBirth", getCustomerInfoRs.getString("birth"));
			customerInfo.put("customerGender", getCustomerInfoRs.getString("gender"));
			customerInfo.put("updateDate", getCustomerInfoRs.getString("updateDate"));
			customerInfo.put("createDate", getCustomerInfoRs.getString("createDate"));
		}
		
		return customerInfo;
	}
	
	/* 고객 회원가입 */
	public static int addCustomer(String customerId, String customerPw, 
			String customerName, String customerBirth, String customerGender) throws Exception{
		
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		//[DB]shop.customer에 INSERT쿼리로 data 삽입
		String addCustomerSql = "INSERT INTO customer(id, pw, name, birth, gender) VALUES(?, PASSWORD(?), ?, ?, ?)";
		PreparedStatement addCustomerStmt = null;
		addCustomerStmt = conn.prepareStatement(addCustomerSql);
		addCustomerStmt.setString(1, customerId);
		addCustomerStmt.setString(2, customerPw);
		addCustomerStmt.setString(3, customerName);
		addCustomerStmt.setString(4, customerBirth);
		addCustomerStmt.setString(5, customerGender);
		
		row = addCustomerStmt.executeUpdate();
		
		return row;
	}
	
	/* 고객 아이디 중복 확인 */
	public static HashMap<String, Object> checkDuplicatedId(String checkCustomerId) throws Exception{
		HashMap<String, Object> checkDuplicatedIdMap = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		String checkIdSql  = "SELECT id FROM customer WHERE id = ?";
		PreparedStatement checkIdStmt = null;
		ResultSet checkIdRs = null;
		
		checkIdStmt = conn.prepareStatement(checkIdSql);
		checkIdStmt.setString(1, checkCustomerId);
		checkIdRs = checkIdStmt.executeQuery();
		
		if (checkIdRs.next()) {
			checkDuplicatedIdMap = new HashMap<String, Object>();
			checkDuplicatedIdMap.put("checkCustomerId", checkCustomerId);
		}
		
		return checkDuplicatedIdMap;
	}
}
