<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="revenue_summary.jsp" method="post">
    Select Type:
    <select name="type">
        <option value="flight">Flight</option>
        <option value="airline">Airline</option>
        <option value="customer">Customer</option>
    </select><br>
    ID: <input type="text" name="id"><br>
    <input type="submit" value="Get Revenue Summary">
</form>

<%
String type = request.getParameter("type");
String id = request.getParameter("id");

if (type != null && id != null) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

        String sql = "";
        if (type.equals("flight")) {
            sql = "SELECT SUM(ticket_price) AS total_revenue FROM Reservations WHERE flight_id = ?";
        } else if (type.equals("airline")) {
            sql = "SELECT SUM(r.ticket_price) AS total_revenue FROM Reservations r JOIN Flights f ON r.flight_id = f.flight_id WHERE f.airline_id = ?";
        } else if (type.equals("customer")) {
            sql = "SELECT SUM(ticket_price) AS total_revenue FROM Reservations WHERE customer_id = ?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(id));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            double revenue = rs.getDouble("total_revenue");
            out.println("<h3>Total Revenue (" + type + " ID " + id + "): $" + String.format("%.2f", revenue) + "</h3>");
        } else {
            out.println("<h3>No revenue data found.</h3>");
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