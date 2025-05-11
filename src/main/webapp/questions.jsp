<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="project336.ApplicationDB" %>

<h3>Post a Question</h3>
<form method="post">
  <input type="hidden" name="userId" value="<%= request.getParameter("userId") %>" />
  <textarea name="message" rows="3" cols="50" required></textarea><br/>
  <button type="submit" name="action" value="post">Post</button>
</form>

<h3>Search Questions</h3>
<form method="post">
  <input type="hidden" name="userId" value="<%= request.getParameter("userId") %>" />
  <input type="text" name="keyword" required/>
  <button type="submit" name="action" value="search">Search</button>
</form>

<%
String action = request.getParameter("action");
String userId = request.getParameter("userId");
ApplicationDB db = new ApplicationDB();
Connection con = null;

try {
    con = db.getConnection();

    // Handle posting a question
    if ("post".equals(action) && request.getParameter("message") != null && userId != null) {
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO Questions (user_id, question_text) VALUES (?, ?)"
        );
        ps.setInt(1, Integer.parseInt(userId));
        ps.setString(2, request.getParameter("message"));
        ps.executeUpdate();
        ps.close();
        out.println("<p style='color:green;'>Your question has been posted.</p>");
    }

    // Handle searching for questions
    if ("search".equals(action) && request.getParameter("keyword") != null) {
        String keyword = request.getParameter("keyword");
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM Questions WHERE question_text LIKE ? ORDER BY created_at DESC"
        );
        ps.setString(1, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();

        out.println("<h4>Search Results:</h4><ul>");
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            out.println("<li><b>User " + rs.getInt("user_id") + "</b>: " + rs.getString("question_text") + "</li>");
        }
        out.println("</ul>");

        if (!hasResults) {
            out.println("<p style='color:red;'>No questions matched your keyword.</p>");
        }

        rs.close();
        ps.close();
    }

} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    if (con != null) try { con.close(); } catch (Exception ignore) {}
}
%>

<a href="user_portal.jsp">Back to Portal</a>