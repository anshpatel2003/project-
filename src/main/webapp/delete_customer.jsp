<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="delete_customer.jsp" method="post">
    Customer ID: <input type="text" name="id"><br>
    <input type="submit" value="Delete Customer">
</form>

<%
String id = request.getParameter("id");

if (id != null) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

        PreparedStatement stmt = conn.prepareStatement("DELETE FROM Customers WHERE customer_id=?");
        stmt.setInt(1, Integer.parseInt(id));
        stmt.executeUpdate();

        out.println("Customer deleted successfully!");
        stmt.close();
        conn.close();
        response.sendRedirect("dashboard.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>