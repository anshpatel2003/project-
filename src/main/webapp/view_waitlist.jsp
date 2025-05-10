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
    String waitlistMessage = "";
    ResultSet waitlistResults = null;

    if (request.getParameter("flight_id_waitlist") != null) {
        try {
            String query = "SELECT c.customer_id, c.username, t.ticket_id FROM Waiting_List w JOIN Customer c ON w.customer_id = c.customer_id JOIN Ticket t ON w.ticket_id = t.ticket_id WHERE t.flight_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(request.getParameter("flight_id_waitlist")));
            waitlistResults = ps.executeQuery();
        } catch (Exception e) {
            waitlistMessage = "Error: " + e.getMessage();
        }
    }
%>
<html>
<head><title>View Flight Waiting List</title></head>
<body>
<h2>Flight Waiting List</h2>
<form method="get">
    Enter Flight ID: <input type="text" name="flight_id_waitlist" required>
    <input type="submit" value="View Waiting List">
</form>
<p style="color:red;"><%= waitlistMessage %></p>
<%
    if (waitlistResults != null) {
%>
        <table border="1">
            <tr><th>Customer ID</th><th>Username</th><th>Ticket ID</th></tr>
<%
        while (waitlistResults.next()) {
%>
            <tr>
                <td><%= waitlistResults.getInt("customer_id") %></td>
                <td><%= waitlistResults.getString("username") %></td>
                <td><%= waitlistResults.getInt("ticket_id") %></td>
            </tr>
<%
        }
        waitlistResults.close();
    }
    db.closeConnection(con);
%>
        </table>
<%
    }
%>
</body>
</html>
