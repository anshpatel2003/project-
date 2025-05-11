<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String error = null;

    if (username != null && password != null) {
        username = username.trim();
        password = password.trim();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mysqlproject?useSSL=false&serverTimezone=UTC",
                "root",
                "pass1234"
            );

            PreparedStatement ps = conn.prepareStatement(
                "SELECT user_id, user_type FROM Users WHERE username=? AND password=?"
            );
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String userType = rs.getString("user_type");

                session.setAttribute("user_id", userId);
                session.setAttribute("username", username);
                session.setAttribute("user_type", userType);

                if ("admin".equals(userType)) {
                    response.sendRedirect("dashboard.jsp");
                } else if ("rep".equals(userType)) {
                    response.sendRedirect("rep_home.jsp");
                } else {
                    response.sendRedirect("user_portal.jsp");
                }
                return; 
            } else {
                error = "Invalid username or password.";
            }

            conn.close();
        } catch (Exception e) {
            error = "Login error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<%-- Debug connection --%>
<% if (error == null && username == null) { %>
    <p style="color:green">Connected to MySQL!</p>
<% } %>

<h2>Login</h2>
<% if (error != null) { %>
    <p style="color:red"><%= error %></p>
<% } %>

<form method="post">
    <label>Username:</label> <input name="username" required /><br/>
    <label>Password:</label> <input type="password" name="password" required /><br/>
    <button type="submit">Login</button>
</form>

</body>
</html>