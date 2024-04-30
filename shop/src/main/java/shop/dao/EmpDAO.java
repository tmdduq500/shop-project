package shop.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class EmpDAO {
	
	// 직급 리스트 가져오기 메서드
	public static ArrayList<String> selectEmpJobList() throws Exception {
		ArrayList<String> list = new ArrayList<>();
		
		Connection conn = DBHelper.getConnection();
		
		String sql = "SELECT emp_job empJob"
				+ " FROM empjob";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		
		while (rs.next()) {
			list.add(rs.getString("empJob"));
		}
		
		conn.close();
		return list;
	}
	
	/* emp 아이디 중복 확인 */
	public static boolean checkDuplicatedEmpId(String empId) throws Exception {
		boolean result = false;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String checkIdSql = "SELECT emp_id empId FROM emp WHERE emp_id = ?";
		PreparedStatement checkIdStmt = conn.prepareStatement(checkIdSql);
		checkIdStmt.setString(1, empId);
		ResultSet checkIdRs = checkIdStmt.executeQuery();

		if (!checkIdRs.next()) {
			result = true;
		}

		conn.close();
		return result;
	}
	
	/* 관리자 추가 */
	public static int insertEmp(String empId, String empPw, String empName, String empJob, String hireDate) throws Exception {
		int row = 0;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// [DB]sho.emp에 emp 추가하는 쿼리
		String insertEmpSql = "INSERT INTO emp(emp_id, emp_pw, emp_name, emp_job, hire_date, update_date, create_date) VALUES(?, ?, ?, ?, ?, sysdate, sysdate)";
		PreparedStatement insertEmpStmt = conn.prepareStatement(insertEmpSql);
		insertEmpStmt.setString(1, empId);
		insertEmpStmt.setString(2, empPw);
		insertEmpStmt.setString(3, empName);
		insertEmpStmt.setString(4, empJob);
		insertEmpStmt.setString(5, hireDate);
		row = insertEmpStmt.executeUpdate();
		
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
			WHERE active='ON' AND emp_id=? AND emp_pw = ?
		*/
		String loginSql = "SELECT v.emp_id empId, v.emp_name empName, v.grade grade"
				+ " FROM"
				+ " (SELECT e.emp_id, e.emp_name, j.grade, h.emp_pw, h.createdate"
				+ " FROM empjob j RIGHT OUTER JOIN emp e ON j.emp_job = e.emp_job INNER JOIN epw_history h ON e.emp_id = h.emp_id"
				+ " WHERE e.emp_id = ?"
				+ " ORDER BY createdate DESC"
				+ " OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) v"
				+ " WHERE v.emp_pw = ?";
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
	public static HashMap<String, Object> selectEmpInfo(String empId) throws Exception {
				
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// [DB]shop.emp에서 empId의 모든 정보 가져오는 쿼리
		String getEmpDataSql = "SELECT e.emp_id empId, j.grade, e.emp_name empName, e.emp_job empJob, e.hire_date hireDate, e.update_date updateDate, e.create_date createDate, e.active "
				+ " FROM emp e INNER JOIN empjob j"
				+ " ON e.emp_job = j.emp_job"
				+ " WHERE emp_id = ?";
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
	public static int updateEmpGrade(String empId, String active) throws Exception{
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
	
	/* 전체 emp 수 구하기 */
	public static int selectTotalEmp() throws Exception{
		int totalEmpRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 전체 goods Row 구하기
		String selectTotalEmpRowSql = "SELECT COUNT(*) cnt FROM emp";
		PreparedStatement selectTotalEmpRowStmt = null;
	
		// category
		selectTotalEmpRowStmt = conn.prepareStatement(selectTotalEmpRowSql);

		ResultSet selectTotalEmpRowRs = selectTotalEmpRowStmt.executeQuery();
		
		if(selectTotalEmpRowRs.next()) {
			totalEmpRow = selectTotalEmpRowRs.getInt("cnt");
		}
		
		conn.close();
		return totalEmpRow;
	}
	
	/* 전체 emp 출력 */
	public static ArrayList<HashMap<String, Object>> selectEmpList(int startRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String, Object>> empList = new ArrayList<HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
				
		/*
		[DB]shop.emp 테이블 가져오는 SQL쿼리
		
		SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active 
		FROM emp
		ORDER BY active ASC, hire_date DESC
		*/
		String getEmpSql = "SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active FROM emp ORDER BY hire_date ASC offset ? rows fetch next ? rows only";
		PreparedStatement getEmpStmt = null; 
		ResultSet getEmpRs = null;
		getEmpStmt = conn.prepareStatement(getEmpSql);
		getEmpStmt.setInt(1, startRow);
		getEmpStmt.setInt(2, rowPerPage);
		getEmpRs = getEmpStmt.executeQuery();
		
		// JDBC API에 종속된 자료구조 모델인 ResultSet -> 기본 API (ArrayList)로 변경
		// ResultSet -> ArrayList<HashMap<String, Object>>
		while(getEmpRs.next()) {
			HashMap<String, Object> empMap = new HashMap<String, Object>();
			empMap.put("empId", getEmpRs.getString("empId"));
			empMap.put("empName", getEmpRs.getString("empName"));
			empMap.put("empJob", getEmpRs.getString("empJob"));
			empMap.put("hireDate", getEmpRs.getString("hireDate"));
			empMap.put("active", getEmpRs.getString("active"));
			empList.add(empMap);
		}
		
		conn.close();
		return empList;
		
	}
	
	/* emp id, pw 검증 */
	public static boolean checkEmpIdPw(String empId, String empPw) throws Exception {
		boolean result = false;

		// DB 연결
		Connection conn = DBHelper.getConnection();

		String checkIdPwSql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = ?";
		PreparedStatement checkIdPwStmt = conn.prepareStatement(checkIdPwSql);
		checkIdPwStmt.setString(1, empId);
		checkIdPwStmt.setString(2, empPw);
		ResultSet checkIdPwRs = checkIdPwStmt.executeQuery();

		if (checkIdPwRs.next()) {
			result = true;
		}

		conn.close();
		return result;
	}
}
