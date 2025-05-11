<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="reservation_list.jsp" method="post">
    Flight Number: <input type="text" name="flight_number"><br>
    Customer First Name: <input type="text" name="first_name"><br>
    Customer Last Name: <input type="text" name="last_name"><br>
    <input type="submit" value="Get Reservations">
</form>

<%
String flightNumber = request.getParameter("flight_number");
String firstName = request.getParameter("first_name");
String lastName = request.getParameter("last_name");

if ((flightNumber != null && !flightNumber.isEmpty()) || 
    (firstName != null && !firstName.isEmpty()) || 
    (lastName != null && !lastName.isEmpty())) {
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");
        
        String sql = "SELECT r.reservation_id, r.flight_id, r.reservation_date, r.seat_number, " +
                     "c.first_name, c.last_name, f.flight_number " +
                     "FROM Reservations r " +
                     "JOIN Customers c ON r.customer_id = c.customer_id " +
                     "JOIN Flights f ON r.flight_id = f.flight_id " +
                     "WHERE f.flight_number = ? OR c.first_name = ? OR c.last_name = ?";
        
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, flightNumber);
        stmt.setString(2, firstName);
        stmt.setString(3, lastName);
        
        ResultSet rs = stmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>Reservation ID</th><th>Flight ID</th><th>Date</th><th>Seat</th><th>First Name</th><th>Last Name</th><th>Flight Number</th></tr>");
        
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            out.println("<tr>");
            out.println("<td>" + rs.getInt("reservation_id") + "</td>");
            out.println("<td>" + rs.getInt("flight_id") + "</td>");
            out.println("<td>" + rs.getDate("reservation_date") + "</td>");
            out.println("<td>" + rs.getString("seat_number") + "</td>");
            out.println("<td>" + rs.getString("first_name") + "</td>");
            out.println("<td>" + rs.getString("last_name") + "</td>");
            out.println("<td>" + rs.getString("flight_number") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");

        if (!hasResults) {
            out.println("<p>No reservations found for your search.</p>");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>

<p><a href="dashboard.jsp">Back to Dashboard</a></p>