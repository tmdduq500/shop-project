package shop.dao;
import java.io.FileReader;
import java.sql.*;
import java.util.Properties;

public class DBHelper {
	public static Connection getConnection() throws Exception {
		// 오라클 DB 접근 클래스 로딩
		Class.forName("oracle.jdbc.driver.OracleDriver");
//		System.out.println("db클래스 로딩 성공");
		
		// 로컬 PC의 Properties 파일 읽어오기
		FileReader fr = new FileReader("D:\\webDevExercise\\auth\\oracledb.properties");
		Properties prop = new Properties();
		prop.load(fr);
		
		String dbUrl = prop.getProperty("dbUrl");
		String dbUser = prop.getProperty("dbUser");
		String dbPw = prop.getProperty("dbPw");
		
		Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
//		System.out.println("db접근 성공");
		
		return conn;
	}
	
}
