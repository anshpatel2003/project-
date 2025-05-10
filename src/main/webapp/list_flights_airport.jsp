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
    ResultSet resultSet = null;

    if (request.getParameter("airport_id") != null) {
        try {
            String query = "SELECT * FROM Flight WHERE departure_airport_id = ? OR arrival_airport_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            String airportId = request.getParameter("airport_id");
            ps.setString(1, airportId);
            ps.setString(2, airportId);
            resultSet = ps.executeQuery();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<html>
<head><title>Flights by Airport</title></head>
<body>
<h2>List of Flights for a Given Airport</h2>
<form method="get">
    Enter Airport ID: <input type="text" name="airport_id" required>
    <input type="submit" value="Search Flights">
</form>
<p style="color:red;"><%= message %></p>
<%
    if (resultSet != null) {
%>
        <table border="1">
            <tr>
                <th>Flight ID</th>
                <th>Aircraft ID</th>
                <th>Airline ID</th>
                <th>Departure Airport</th>
                <th>Arrival Airport</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
                <th>Type</th>
            </tr>
<%
        while (resultSet.next()) {
%>
            <tr>
                <td><%= resultSet.getInt("flight_id") %></td>
                <td><%= resultSet.getInt("aircraft_id") %></td>
                <td><%= resultSet.getString("airline_id") %></td>
                <td><%= resultSet.getString("departure_airport_id") %></td>
                <td><%= resultSet.getString("arrival_airport_id") %></td>
                <td><%= resultSet.getString("departure_time") %></td>
                <td><%= resultSet.getString("arrival_time") %></td>
                <td><%= resultSet.getString("flight_type") %></td>
            </tr>
<%
        }
        resultSet.close();
        db.closeConnection(con);
%>
        </table>
<%
    }
%>
</body>
</html>