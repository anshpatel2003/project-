<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, project336.ApplicationDB" %>

<h3>Make Reservation</h3>
<form method="post">
  <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>" />
  <label>Schedule ID:</label> <input type="number" name="flightId" required /><br/>
  <label>Class:</label>
  <select name="seatClass">
    <option value="economy">Economy</option>
    <option value="business">Business</option>
    <option value="first">First</option>
  </select><br/>
  <button type="submit">Reserve</button>
</form>

<%
if (request.getParameter("flightId") != null) {
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        int userId = Integer.parseInt(request.getParameter("userId"));
        int scheduleId = Integer.parseInt(request.getParameter("flightId"));
        String seatClass = request.getParameter("seatClass");

        PreparedStatement ps1 = con.prepareStatement("INSERT INTO Tickets (user_id, total_fare, booking_fee) VALUES (?, ?, ?)");
        ps1.setInt(1, userId);
        ps1.setBigDecimal(2, new java.math.BigDecimal("250.00"));
        ps1.setBigDecimal(3, new java.math.BigDecimal("10.00"));
        ps1.executeUpdate();
        ps1.close();

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT MAX(ticket_id) AS ticket_id FROM Tickets WHERE user_id = " + userId);
        int ticketId = -1;
        if (rs.next()) {
            ticketId = rs.getInt("ticket_id");
        }
        rs.close(); st.close();

        if (ticketId != -1) {
            PreparedStatement ps2 = con.prepareStatement("INSERT INTO Ticket_Flights (ticket_id, schedule_id, seat_class, seat_number) VALUES (?, ?, ?, 'A1')");
            ps2.setInt(1, ticketId);
            ps2.setInt(2, scheduleId);
            ps2.setString(3, seatClass);
            ps2.executeUpdate();
            ps2.close();
            out.println("<p style='color:green;'>Reservation successful. Ticket ID: " + ticketId + "</p>");
        } else {
            out.println("<p style='color:red;'>Could not retrieve ticket ID.</p>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Reservation failed: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
}
%>

<a href="user_portal.jsp">Back to Portal</a>
