<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

boolean valid = false;
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/flight_reservation_system", "root", "");
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT * FROM Users WHERE username=? AND password=?");
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
    out.println("Welcome, " + username + "! <a href='logout.jsp'>Logout</a>");
} else {
    out.println("Invalid credentials. <a href='login.html'>Try again</a>");
}
%>