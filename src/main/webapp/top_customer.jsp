<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<h3>Top Revenue-Generating Customer</h3>

<%
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

    String sql = "SELECT c.customer_id, c.first_name, c.last_name, SUM(r.ticket_price) AS total_revenue " +
                 "FROM Customers c " +
                 "JOIN Reservations r ON c.customer_id = r.customer_id " +
                 "GROUP BY c.customer_id, c.first_name, c.last_name " +
                 "ORDER BY total_revenue DESC LIMIT 1";

    PreparedStatement stmt = conn.prepareStatement(sql);
    ResultSet rs = stmt.executeQuery();

    if (rs.next()) {
        int customerId = rs.getInt("customer_id");
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        double revenue = rs.getDouble("total_revenue");

        out.println("<p>Customer ID: " + customerId + "</p>");
        out.println("<p>Name: " + firstName + " " + lastName + "</p>");
        out.println("<p>Total Revenue: $" + String.format("%.2f", revenue) + "</p>");
    } else {
        out.println("<p>No revenue data found.</p>");
    }

    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<p><a href="dashboard.jsp">Back to Dashboard</a></p>