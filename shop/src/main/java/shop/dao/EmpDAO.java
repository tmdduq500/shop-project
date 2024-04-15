package shop.dao;

import java.sql.*;
import java.util.HashMap;

public class EmpDAO {
	
	/* 관리자 추가 */
	public static int addEmp(String empId, String empPw, String empName, String empJob) throws Exception {
		int row = 0;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// [DB]sho.emp에 emp 추가하는 쿼리
		String addEmpSql = "INSERT emp(emp_id, emp_pw, emp_name, emp_job) VALUES(?, ?, ?, ?)";
		PreparedStatement addEmpStmt = conn.prepareStatement(addEmpSql);
		addEmpStmt.setString(1, empId);
		addEmpStmt.setString(2, empPw);
		addEmpStmt.setString(3, empName);
		addEmpStmt.setString(4, empJob);
		row = addEmpStmt.executeUpdate();
		
		System.out.println("EmpDAO - row = " + row);
		
		conn.close();
		return row;
	}
	
	/* 관리자 로그인 */
	// HashMap<String, Object> : null이면 로그인 실패, 아니면 로그인 성공
	// String empId, String empPw : 로그인 폼에서 사용자가 입력한 id/pw
	// 호출 -> HashMap<String, Object> m = EmpDAO.empLogin("admin", "1234");
	public static HashMap<String, Object> empLogin(String empId, String empPw) throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		/* 로그인 하기 */		
		/*
			[DB]shop.emp에 empId, empPw 확인 SQL문 
			
			SELECT emp_id empId
			FROM emp
			WHERE active='ON' AND emp_id=? AND emp_pw = password(?)
		*/
		String loginSql = "SELECT emp_id empId, emp_name empName, grade FROM emp WHERE active='ON' AND emp_id=? AND emp_pw = password(?)";
		PreparedStatement loginStmt = conn.prepareStatement(loginSql);

		loginStmt.setString(1, empId);
		loginStmt.setString(2, empPw);
		ResultSet loginRs = loginStmt.executeQuery();
		
		if(loginRs.next()) {
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", loginRs.getString("empId"));
			resultMap.put("empName", loginRs.getString("empName"));
			resultMap.put("grade", loginRs.getInt("grade"));
		}
		
		conn.close();
		return resultMap;
	}
	
	/* 관리자 상세보기 */
	public static HashMap<String, Object> empInfo(String empId) throws Exception {
				
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// [DB]shop.emp에서 empId의 모든 정보 가져오는 쿼리
		String getEmpDataSql = "SELECT emp_id empId, grade, emp_name empName, emp_job empJob, hire_date hireDate, update_date updateDate, create_date createDate, active FROM emp WHERE emp_id = ?";
		PreparedStatement getEmpDataStmt = null;
		ResultSet getEmpDataRs = null;
		
		getEmpDataStmt = conn.prepareStatement(getEmpDataSql);
		getEmpDataStmt.setString(1, empId);
		getEmpDataRs = getEmpDataStmt.executeQuery();
		
		// ResultSet -> HashMap 변환
		if(getEmpDataRs.next()) {
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", getEmpDataRs.getString("empId"));
			resultMap.put("grade", getEmpDataRs.getString("grade"));
			resultMap.put("empName", getEmpDataRs.getString("empName"));
			resultMap.put("empJob", getEmpDataRs.getString("empJob"));
			resultMap.put("hireDate", getEmpDataRs.getString("hireDate"));
			resultMap.put("updateDate", getEmpDataRs.getString("updateDate"));
			resultMap.put("createDate", getEmpDataRs.getString("createDate"));
			resultMap.put("active", getEmpDataRs.getString("active"));
		}
		
		conn.close();
		return resultMap;
	}
	
	/* 관리자 권한 수정 */
	public static int modifyEmpGrade(String empId, String active) throws Exception{
		int row = 0;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// [DB]shop.emp의 active 값 수정
	    /*
	        [DB]shop.emp에 empId, empPw SQL문
	        
	        UPDATE emp
	        SET active = 'ON' or 'OFF'
	        WHERE emp_id = ?
	    */
	    
	    String changeActiveSql = "UPDATE emp SET active = ? WHERE emp_id = ?";
	    PreparedStatement changeActiveStmt = null; 
	    changeActiveStmt = conn.prepareStatement(changeActiveSql);
	    
	    // active 값 교체
	    if(active.equals("ON")) {
	        // active가 ON일 경우
	        active = "OFF";
	        changeActiveStmt.setString(1, active);
	        changeActiveStmt.setString(2, empId);
	        row = changeActiveStmt.executeUpdate();
	    } else {    
	        // active가 OFF일 경우
	        active = "ON";
	        changeActiveStmt.setString(1, active);
	        changeActiveStmt.setString(2, empId);
	        row = changeActiveStmt.executeUpdate();
	    }
	    
	    conn.close();
		return row;
	}
}
