<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Customer Representative Dashboard</title>
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
    <h1>Welcome, <%= username %> (Customer Representative)</h1>
    <ul>
        <li><a href="make_reservation.jsp">Make Reservation on Behalf of User</a></li>
        <li><a href="edit_reservation.jsp">Edit Customer Reservation</a></li>
        <li><a href="manage_flights.jsp">Add/Edit/Delete Aircrafts, Airports, Flights</a></li>
        <li><a href="view_waitlist.jsp">View Flight Waiting List</a></li>
        <li><a href="list_flights_airport.jsp">List Flights for an Airport</a></li>
        <li><a href="respond_questions.jsp">Reply to User Questions</a></li>
    </ul>
</body>
</html>
