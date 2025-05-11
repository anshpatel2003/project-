<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="project336.ApplicationDB" %>
<h3>
<%
String type = request.getParameter("type");
String userIdStr = request.getParameter("userId");
if ("upcoming".equals(type)) {
    out.print("Upcoming Reservations");
} else {
    out.print("Past Reservations");
}
%>
</h3>

<%
if (type != null && userIdStr != null && (type.equals("past") || type.equals("upcoming"))) {
    try {
        int userId = Integer.parseInt(userIdStr);

        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String comparison = type.equals("upcoming") ? ">=" : "<";
        String query = "SELECT f.flight_number, fs.flight_date, f.departure_airport, f.arrival_airport " +
                       "FROM Tickets t " +
                       "JOIN Ticket_Flights tf ON t.ticket_id = tf.ticket_id " +
                       "JOIN Flight_Schedule fs ON tf.schedule_id = fs.schedule_id " +
                       "JOIN Flights f ON fs.flight_id = f.flight_id " +
                       "WHERE t.user_id = ? AND fs.flight_date " + comparison + " CURDATE() " +
                       "ORDER BY fs.flight_date DESC";

        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        boolean hasResults = false;
%>
        <table border="1">
            <tr><th>Flight</th><th>Date</th><th>From</th><th>To</th></tr>
<%
        while (rs.next()) {
            hasResults = true;
%>
            <tr>
                <td><%= rs.getString("flight_number") %></td>
                <td><%= rs.getDate("flight_date") %></td>
                <td><%= rs.getString("departure_airport") %></td>
                <td><%= rs.getString("arrival_airport") %></td>
            </tr>
<%
        }
        rs.close();
        ps.close();
        con.close();

        if (!hasResults) {
            out.println("<tr><td colspan='4' style='color:red;'>No " + type + " reservations found.</td></tr>");
        }
%>
        </table>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error retrieving reservations: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
} else {
    out.println("<p style='color:red;'>Invalid request: missing user ID or reservation type.</p>");
}
%>

<a href="user_portal.jsp">Back</a>