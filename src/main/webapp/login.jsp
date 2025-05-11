<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

boolean valid = false;
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
    	    "jdbc:mysql://127.0.0.1:3306/Admin_project", "root", "Superstar0!26");
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT * FROM Admins WHERE username=? AND password=?");
    stmt.setString(1, username);
    stmt.setString(2, password);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
        valid = true;
        session.setAttribute("username", username);
    }
    rs.close(); stmt.close(); conn.close();
} catch (Exception e) {
    out.println("Database error: " + e.getMessage());
}

if (valid) {
	response.sendRedirect("dashboard.jsp");
} else {
    out.println("Invalid credentials. <a href='login.html'>Try again</a>");
}
%>