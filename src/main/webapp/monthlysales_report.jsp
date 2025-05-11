<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="monthlysales_report.jsp" method="post">
    Month (1-12): <input type="text" name="month"><br>
    Year (e.g., 2025): <input type="text" name="year"><br>
    <input type="submit" value="Get Sales Report">
</form>

<%
String month = request.getParameter("month");
String year = request.getParameter("year");

if (month != null && year != null) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

        String sql = "SELECT COUNT(*) AS total_reservations " +
                     "FROM Reservations " +
                     "WHERE MONTH(reservation_date) = ? AND YEAR(reservation_date) = ?";

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(month));
        stmt.setInt(2, Integer.parseInt(year));

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int totalReservations = rs.getInt("total_reservations");
            out.println("<h3>Total Reservations in " + month + "/" + year + ": " + totalReservations + "</h3>");
        } else {
            out.println("<h3>No reservations found for this period.</h3>");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>

<form action="dashboard.jsp" method="get">
    <input type="submit" value="Back to Dashboard">
</form>