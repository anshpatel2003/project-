<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<%
    String repUsername = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (repUsername == null || role == null || !role.equals("rep")) {
        response.sendRedirect("login.html");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String message = "";
    ResultSet resultSet = null;

    if (request.getParameter("question_search") != null) {
        try {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM Questions WHERE question_text LIKE ?");
            ps.setString(1, "%" + request.getParameter("question_search") + "%");
            resultSet = ps.executeQuery();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    } else if (request.getParameter("reply_question_id") != null && request.getParameter("reply_text") != null) {
        try {
            PreparedStatement ps = con.prepareStatement("UPDATE Questions SET response = ?, responder = ? WHERE question_id = ?");
            ps.setString(1, request.getParameter("reply_text"));
            ps.setString(2, repUsername);
            ps.setInt(3, Integer.parseInt(request.getParameter("reply_question_id")));
            ps.executeUpdate();
            message = "Response submitted.";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<html>
<head><title>Reply to User Questions</title></head>
<body>
<h2>Search Questions and Reply</h2>
<form method="get">
    Search: <input type="text" name="question_search">
    <input type="submit" value="Search">
</form>
<p style="color:green;"><%= message %></p>
<%
    if (resultSet != null) {
%>
        <table border="1">
            <tr><th>ID</th><th>Question</th><th>Response</th><th>Reply</th></tr>
<%
        while (resultSet.next()) {
%>
            <tr>
                <td><%= resultSet.getInt("question_id") %></td>
                <td><%= resultSet.getString("question_text") %></td>
                <td><%= resultSet.getString("response") != null ? resultSet.getString("response") : "-" %></td>
                <td>
                    <form method="post">
                        <input type="hidden" name="reply_question_id" value="<%= resultSet.getInt("question_id") %>">
                        <input type="text" name="reply_text" required>
                        <input type="submit" value="Reply">
                    </form>
                </td>
            </tr>
<%
        }
        resultSet.close();
        db.closeConnection(con);
%>
        </table>
<%
    }
%>
</body>