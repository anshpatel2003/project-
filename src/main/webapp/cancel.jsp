<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, project336.ApplicationDB" %>

<h3>Cancel Reservation</h3>
<form method="post">
  <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>" />
  <label>Reservation ID:</label>
  <input type="number" name="reservationId" required />
  <button type="submit">Cancel</button>
</form>

<%
String resIdParam = request.getParameter("reservationId");
String userIdParam = request.getParameter("userId");

if (resIdParam != null && userIdParam != null) {
    try {
        int reservationId = Integer.parseInt(resIdParam);
        int userId = Integer.parseInt(userIdParam);

        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Validate that the ticket belongs to the user
        PreparedStatement check = con.prepareStatement("SELECT ticket_id FROM Tickets WHERE ticket_id = ? AND user_id = ?");
        check.setInt(1, reservationId);
        check.setInt(2, userId);
        ResultSet rs = check.executeQuery();

        if (!rs.next()) {
            out.println("<p style='color:red;'>No reservation found with that ID for your account.</p>");
        } else {
            // Delete from Ticket_Flights first to satisfy FK constraints
            PreparedStatement delFlights = con.prepareStatement("DELETE FROM Ticket_Flights WHERE ticket_id = ?");
            delFlights.setInt(1, reservationId);
            delFlights.executeUpdate();
            delFlights.close();

            // Now delete the actual ticket
            PreparedStatement delTicket = con.prepareStatement("DELETE FROM Tickets WHERE ticket_id = ?");
            delTicket.setInt(1, reservationId);
            delTicket.executeUpdate();
            delTicket.close();

            out.println("<p style='color:green;'>Reservation cancelled successfully.</p>");
        }

        rs.close();
        check.close();
        con.close();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Failed to cancel reservation: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
}
%>

<a href="user_portal.jsp">Back</a>