<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="project336.ApplicationDB" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String error = null;
    Connection conn = null;

    if (username != null && password != null) {
        username = username.trim();
        password = password.trim();

        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();

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
                session.setAttribute("role", userType);  // renamed key to "role" for consistency

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

            rs.close();
            ps.close();
        } catch (Exception e) {
            error = "Login error: " + e.getMessage();
        } finally {
            ApplicationDB db = new ApplicationDB();
            db.closeConnection(conn);
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

<h2>Login</h2>

<% if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>

<form method="post">
    <label>Username:</label> <input name="username" required /><br/>
    <label>Password:</label> <input type="password" name="password" required /><br/>
    <button type="submit">Login</button>
</form>

</body>
</html>