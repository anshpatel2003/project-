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

    String customerUsername = request.getParameter("customerUsername");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    String flightDate = request.getParameter("flightDate");
    String seatClass = request.getParameter("class");
    String seat = request.getParameter("seat");

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    try {
        // Example: insert into reservations table, assuming structure
        String sql = "INSERT INTO reservations (customer_username, departure_airport, arrival_airport, flight_date, seat_class, seat_number, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, customerUsername);
        ps.setString(2, departure);
        ps.setString(3, arrival);
        ps.setString(4, flightDate);
        ps.setString(5, seatClass);
        ps.setString(6, seat);
        ps.setString(7, repUsername);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.println("<p>Reservation successfully made for user: " + customerUsername + "</p>");
        } else {
            out.println("<p>Reservation failed. Try again.</p>");
        }

        ps.close();
        db.closeConnection(con);
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
