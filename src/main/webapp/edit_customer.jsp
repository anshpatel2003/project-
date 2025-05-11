<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="edit_customer.jsp" method="post">
    Customer ID: <input type="text" name="id"><br>
    First Name: <input type="text" name="first_name"><br>
    Last Name: <input type="text" name="last_name"><br>
    Email: <input type="email" name="email"><br>
    Phone: <input type="text" name="phone"><br>
    <input type="submit" value="Update Customer">
</form>

<%
String id = request.getParameter("id");
String firstName = request.getParameter("first_name");
String lastName = request.getParameter("last_name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");

if (id != null && firstName != null && lastName != null && email != null && phone != null) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

        PreparedStatement stmt = conn.prepareStatement("UPDATE Customers SET first_name=?, last_name=?, email=?, phone=? WHERE customer_id=?");
        stmt.setString(1, firstName);
        stmt.setString(2, lastName);
        stmt.setString(3, email);
        stmt.setString(4, phone);
        stmt.setInt(5, Integer.parseInt(id));
        stmt.executeUpdate();

        out.println("Customer updated successfully!");
        stmt.close();
        conn.close();
        response.sendRedirect("dashboard.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>