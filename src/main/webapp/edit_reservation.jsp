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
%>
<html>
<head><title>Edit Reservation</title></head>
<body>
<h2>Edit Existing Reservation</h2>
<form action="update_reservation.jsp" method="post">
    <label for="reservationId">Reservation ID:</label><br>
    <input type="text" id="reservationId" name="reservationId" required><br><br>

    <label for="flightDate">New Flight Date:</label><br>
    <input type="date" id="flightDate" name="flightDate"><br><br>

    <label for="seat">New Seat Number:</label><br>
    <input type="text" id="seat" name="seat"><br><br>

    <label for="class">New Class:</label><br>
    <select id="class" name="class">
        <option value="economy">Economy</option>
        <option value="business">Business</option>
        <option value="first">First</option>
    </select><br><br>

    <input type="submit" value="Update Reservation">
</form>
</body>
</html>
