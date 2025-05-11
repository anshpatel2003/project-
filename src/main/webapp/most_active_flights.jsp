<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<h3>Most Active Flights (Most Tickets Sold)</h3>

<%
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

    String sql = "SELECT f.flight_id, f.flight_number, COUNT(r.reservation_id) AS tickets_sold " +
                 "FROM Flights f " +
                 "JOIN Reservations r ON f.flight_id = r.flight_id " +
                 "GROUP BY f.flight_id, f.flight_number " +
                 "ORDER BY tickets_sold DESC";

    PreparedStatement stmt = conn.prepareStatement(sql);
    ResultSet rs = stmt.executeQuery();

    out.println("<table border='1'>");
    out.println("<tr><th>Flight ID</th><th>Flight Number</th><th>Tickets Sold</th></tr>");

    while (rs.next()) {
        int flightId = rs.getInt("flight_id");
        String flightNumber = rs.getString("flight_number");
        int ticketsSold = rs.getInt("tickets_sold");

        out.println("<tr><td>" + flightId + "</td><td>" + flightNumber + "</td><td>" + ticketsSold + "</td></tr>");
    }

    out.println("</table>");

    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<p><a href="dashboard.jsp">Back to Dashboard</a></p>