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
    String message = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        try {
            if (request.getParameter("delete_airport_id") != null) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM Airports WHERE airport_id = ?");
                ps.setString(1, request.getParameter("delete_airport_id"));
                ps.executeUpdate();
                message = "Airport deleted.";
            } else if (request.getParameter("delete_aircraft_id") != null) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM Aircraft WHERE aircraft_id = ?");
                ps.setInt(1, Integer.parseInt(request.getParameter("delete_aircraft_id")));
                ps.executeUpdate();
                message = "Aircraft deleted.";
            } else if (request.getParameter("delete_flight_id") != null) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM Flight WHERE flight_id = ?");
                ps.setInt(1, Integer.parseInt(request.getParameter("delete_flight_id")));
                ps.executeUpdate();
                message = "Flight deleted.";
            } else if (request.getParameter("edit_airport_id") != null) {
                PreparedStatement ps = con.prepareStatement("UPDATE Airports SET name = ? WHERE airport_id = ?");
                ps.setString(1, request.getParameter("edit_name"));
                ps.setString(2, request.getParameter("edit_airport_id"));
                ps.executeUpdate();
                message = "Airport updated.";
            } else if (request.getParameter("edit_aircraft_id") != null) {
                PreparedStatement ps = con.prepareStatement("UPDATE Aircraft SET capacity = ? WHERE aircraft_id = ?");
                ps.setInt(1, Integer.parseInt(request.getParameter("edit_capacity")));
                ps.setInt(2, Integer.parseInt(request.getParameter("edit_aircraft_id")));
                ps.executeUpdate();
                message = "Aircraft updated.";
            } else if (request.getParameter("edit_flight_id") != null) {
                PreparedStatement ps = con.prepareStatement("UPDATE Flight SET aircraft_id = ?, airline_id = ?, departure_airport_id = ?, arrival_airport_id = ?, departure_time = ?, arrival_time = ?, flight_type = ? WHERE flight_id = ?");
                ps.setInt(1, Integer.parseInt(request.getParameter("edit_aircraft_id")));
                ps.setString(2, request.getParameter("edit_airline_id"));
                ps.setString(3, request.getParameter("edit_departure_airport_id"));
                ps.setString(4, request.getParameter("edit_arrival_airport_id"));
                ps.setString(5, request.getParameter("edit_departure_time"));
                ps.setString(6, request.getParameter("edit_arrival_time"));
                ps.setString(7, request.getParameter("edit_flight_type"));
                ps.setInt(8, Integer.parseInt(request.getParameter("edit_flight_id")));
                ps.executeUpdate();
                message = "Flight updated.";
            } else if (request.getParameter("airport_id") != null) {
                PreparedStatement ps = con.prepareStatement("INSERT INTO Airports (airport_id, name) VALUES (?, ?)");
                ps.setString(1, request.getParameter("airport_id"));
                ps.setString(2, request.getParameter("name"));
                ps.executeUpdate();
                message = "Airport added.";
            } else if (request.getParameter("aircraft_id") != null && request.getParameter("capacity") != null) {
                PreparedStatement ps = con.prepareStatement("INSERT INTO Aircraft (aircraft_id, capacity) VALUES (?, ?)");
                ps.setInt(1, Integer.parseInt(request.getParameter("aircraft_id")));
                ps.setInt(2, Integer.parseInt(request.getParameter("capacity")));
                ps.executeUpdate();
                message = "Aircraft added.";
            } else if (request.getParameter("airline_id") != null) {
                PreparedStatement ps = con.prepareStatement("INSERT INTO Flight (aircraft_id, airline_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time, flight_type) VALUES (?, ?, ?, ?, ?, ?, ?)");
                ps.setInt(1, Integer.parseInt(request.getParameter("aircraft_id")));
                ps.setString(2, request.getParameter("airline_id"));
                ps.setString(3, request.getParameter("departure_airport_id"));
                ps.setString(4, request.getParameter("arrival_airport_id"));
                ps.setString(5, request.getParameter("departure_time"));
                ps.setString(6, request.getParameter("arrival_time"));
                ps.setString(7, request.getParameter("flight_type"));
                ps.executeUpdate();
                message = "Flight added.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            db.closeConnection(con);
        }
    }
%>
<html>
<head><title>Manage Flights</title></head>
<body>
<h2>Manage Aircrafts, Airports, and Flights</h2>
<p style="color:green;"><%= message %></p>

<h3>Add New Airport</h3>
<form method="post">
    Airport ID: <input type="text" name="airport_id" required><br>
    Name: <input type="text" name="name" required><br>
    <input type="submit" value="Add Airport">
</form>

<h3>Edit Airport</h3>
<form method="post">
    Airport ID: <input type="text" name="edit_airport_id" required><br>
    New Name: <input type="text" name="edit_name" required><br>
    <input type="submit" value="Edit Airport">
</form>

<h3>Delete Airport</h3>
<form method="post">
    Airport ID: <input type="text" name="delete_airport_id" required><br>
    <input type="submit" value="Delete Airport">
</form>

<h3>Add New Aircraft</h3>
<form method="post">
    Aircraft ID: <input type="text" name="aircraft_id" required><br>
    Capacity: <input type="number" name="capacity" required><br>
    <input type="submit" value="Add Aircraft">
</form>

<h3>Edit Aircraft</h3>
<form method="post">
    Aircraft ID: <input type="text" name="edit_aircraft_id" required><br>
    New Capacity: <input type="number" name="edit_capacity" required><br>
    <input type="submit" value="Edit Aircraft">
</form>

<h3>Delete Aircraft</h3>
<form method="post">
    Aircraft ID: <input type="text" name="delete_aircraft_id" required><br>
    <input type="submit" value="Delete Aircraft">
</form>

<h3>Add New Flight</h3>
<form method="post">
    Aircraft ID: <input type="text" name="aircraft_id" required><br>
    Airline ID: <input type="text" name="airline_id" required><br>
    Departure Airport ID: <input type="text" name="departure_airport_id" required><br>
    Arrival Airport ID: <input type="text" name="arrival_airport_id" required><br>
    Departure Time: <input type="datetime-local" name="departure_time" required><br>
    Arrival Time: <input type="datetime-local" name="arrival_time" required><br>
    Flight Type: <select name="flight_type">
        <option value="domestic">Domestic</option>
        <option value="international">International</option>
    </select><br>
    <input type="submit" value="Add Flight">
</form>

<h3>Edit Flight</h3>
<form method="post">
    Flight ID: <input type="text" name="edit_flight_id" required><br>
    Aircraft ID: <input type="text" name="edit_aircraft_id" required><br>
    Airline ID: <input type="text" name="edit_airline_id" required><br>
    Departure Airport ID: <input type="text" name="edit_departure_airport_id" required><br>
    Arrival Airport ID: <input type="text" name="edit_arrival_airport_id" required><br>
    Departure Time: <input type="datetime-local" name="edit_departure_time" required><br>
    Arrival Time: <input type="datetime-local" name="edit_arrival_time" required><br>
    Flight Type: <select name="edit_flight_type">
        <option value="domestic">Domestic</option>
        <option value="international">International</option>
    </select><br>
    <input type="submit" value="Edit Flight">
</form>

<h3>Delete Flight</h3>
<form method="post">
    Flight ID: <input type="text" name="delete_flight_id" required><br>
    <input type="submit" value="Delete Flight">
</form>
</body>
</html>
