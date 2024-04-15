package shop.dao;
import java.io.FileReader;
import java.sql.*;
import java.util.Properties;

public class DBHelper {
	public static Connection getConnection() throws Exception {
		// DB 접근
		Class.forName("org.mariadb.jdbc.Driver");
		
		// 로컬 PC의 Properties 파일 읽어오기
		FileReader fr = new FileReader("D:\\webDevExercise\\auth\\mariadb.properties");
		Properties prop = new Properties();
		prop.load(fr);
		
		String id = prop.getProperty("id");
		String pw = prop.getProperty("pw");
		
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/shop", id, pw);
		
		return conn;
	}
	
}
