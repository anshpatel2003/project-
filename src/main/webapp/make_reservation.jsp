<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Make Reservation - Customer Rep</title>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null || !role.equals("rep")) {
        response.sendRedirect("login.html");
        return;
    }
%>
<h2>Make Flight Reservation on Behalf of User</h2>
<form action="submit_reservation.jsp" method="post">
    <label for="customerUsername">Customer Username:</label><br>
    <input type="text" id="customerUsername" name="customerUsername" required><br><br>

    <label for="departure">Departure Airport:</label><br>
    <input type="text" id="departure" name="departure" required><br><br>

    <label for="arrival">Arrival Airport:</label><br>
    <input type="text" id="arrival" name="arrival" required><br><br>

    <label for="flightDate">Flight Date:</label><br>
    <input type="date" id="flightDate" name="flightDate" required><br><br>

    <label for="class">Class:</label><br>
    <select id="class" name="class">
        <option value="economy">Economy</option>
        <option value="business">Business</option>
        <option value="first">First</option>
    </select><br><br>

    <label for="seat">Preferred Seat #:</label><br>
    <input type="text" id="seat" name="seat"><br><br>

    <input type="submit" value="Reserve">
</form>
</body>
</html>
