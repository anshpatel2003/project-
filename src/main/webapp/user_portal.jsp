<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="project336.ApplicationDB" %>

<html>
<head>
  <title>User Portal</title>
</head>
<body>
<h2>Welcome, <%= session.getAttribute("username") %>!</h2>
<a href="logout.jsp">Logout</a>
<hr/>

<h3>Search Flights</h3>
<form method="post">
  <input type="hidden" name="action" value="search" />

  From:
  <select name="from">
    <%
      ApplicationDB db = new ApplicationDB();
      Connection con = db.getConnection();  // keep this connection for entire page
      Statement stFrom = con.createStatement();
      ResultSet rsFrom = stFrom.executeQuery("SELECT DISTINCT departure_airport FROM Flights");
      while (rsFrom.next()) {
        String ap = rsFrom.getString("departure_airport");
    %>
      <option value="<%= ap %>"><%= ap %></option>
    <%
      }
      rsFrom.close();
      stFrom.close();
    %>
  </select>

  To:
  <select name="to">
    <%
      Statement stTo = con.createStatement();
      ResultSet rsTo = stTo.executeQuery("SELECT DISTINCT arrival_airport FROM Flights");
      while (rsTo.next()) {
        String ap = rsTo.getString("arrival_airport");
    %>
      <option value="<%= ap %>"><%= ap %></option>
    <%
      }
      rsTo.close();
      stTo.close();
    %>
  </select>

  Date: <input type="date" name="date" required />

  Airline:
  <select name="airline">
    <option value="">All</option>
    <%
      Statement stAirline = con.createStatement();
      ResultSet rsAir = stAirline.executeQuery("SELECT DISTINCT airline_id FROM Flights");
      while (rsAir.next()) {
        String air = rsAir.getString("airline_id");
    %>
      <option value="<%= air %>"><%= air %></option>
    <%
      }
      rsAir.close();
      stAirline.close();
    %>
  </select>

  Max Price: <input type="number" step="0.01" name="maxPrice" />
  <button type="submit" name="action" value="search">Search</button>
  <button type="submit" name="action" value="listAll">List All</button>
</form>

<%
String action = request.getParameter("action");
if (action != null && (action.equals("search") || action.equals("listAll"))) {
    try {
        String sql;
        PreparedStatement ps;

        if (action.equals("listAll")) {
            sql = "SELECT f.flight_id, f.flight_number, f.airline_id, f.departure_airport, f.arrival_airport, fs.flight_date, f.departure_time, f.arrival_time FROM Flights f JOIN Flight_Schedule fs ON f.flight_id = fs.flight_id";
            ps = con.prepareStatement(sql);
        } else {
            String from = request.getParameter("from");
            String to = request.getParameter("to");
            String date = request.getParameter("date");
            String airline = request.getParameter("airline");
            String maxPrice = request.getParameter("maxPrice");

            StringBuilder query = new StringBuilder(
              "SELECT f.flight_id, f.flight_number, f.airline_id, f.departure_airport, f.arrival_airport, fs.flight_date, f.departure_time, f.arrival_time " +
              "FROM Flights f JOIN Flight_Schedule fs ON f.flight_id = fs.flight_id " +
              "WHERE f.departure_airport = ? AND f.arrival_airport = ? AND fs.flight_date = ?"
            );

            boolean hasAirline = airline != null && !airline.isEmpty();
            boolean hasMax = maxPrice != null && !maxPrice.isEmpty();

            if (hasAirline) query.append(" AND f.airline_id = ?");
            if (hasMax) query.append(" AND fs.available_seats > 0");  // adjust logic if needed

            ps = con.prepareStatement(query.toString());
            int paramIndex = 1;
            ps.setString(paramIndex++, from);
            ps.setString(paramIndex++, to);
            ps.setDate(paramIndex++, java.sql.Date.valueOf(date));
            if (hasAirline) ps.setString(paramIndex++, airline);
        }

        ResultSet rs = ps.executeQuery();
        boolean hasResults = false;
%>
        <h3>Flights Found</h3>
        <table border="1">
          <tr><th>ID</th><th>Flight#</th><th>Airline</th><th>From</th><th>To</th><th>Date</th><th>Depart</th><th>Arrive</th></tr>
<%
        while (rs.next()) {
          hasResults = true;
%>
          <tr>
            <td><%= rs.getInt("flight_id") %></td>
            <td><%= rs.getString("flight_number") %></td>
            <td><%= rs.getString("airline_id") %></td>
            <td><%= rs.getString("departure_airport") %></td>
            <td><%= rs.getString("arrival_airport") %></td>
            <td><%= rs.getDate("flight_date") %></td>
            <td><%= rs.getTime("departure_time") %></td>
            <td><%= rs.getTime("arrival_time") %></td>
          </tr>
<%
        }
        rs.close();
        ps.close();

        if (!hasResults) {
            out.println("<tr><td colspan='8' style='color:red;'>No flights found for given criteria.</td></tr>");
        }
%>
        </table>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
}
%>

<hr/>
<ul>
  <li><a href="reserve.jsp">Make Reservation</a></li>
  <li><a href="cancel.jsp">Cancel Reservation</a></li>
  <li><a href="viewReservations.jsp?type=upcoming&userId=<%= session.getAttribute("user_id") %>">Upcoming Reservations</a></li>
  <li><a href="viewReservations.jsp?type=past&userId=<%= session.getAttribute("user_id") %>">Past Reservations</a></li>
  <li><a href="questions.jsp?userId=<%= session.getAttribute("user_id") %>">Ask a Question</a></li>
</ul>

<%
if (con != null) try { con.close(); } catch (Exception ignore) {}
%>
</body>
</html>