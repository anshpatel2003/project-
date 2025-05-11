<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<form action="add_customer.jsp" method="post">
    First_Name: <input type="text" name="first_name"><br>
    Last_Name: <input type="text" name="last_name"><br>
    Email: <input type="email" name="email"><br>
    Phone: <input type="text" name="phone"><br>
    <input type="submit" value="Add Customer">
</form>

<%
String firstName = request.getParameter("first_name");
String lastName = request.getParameter("last_name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");

if (firstName != null && lastName != null && email != null && phone != null) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Admin_project", "root", "Superstar0!26");

        PreparedStatement stmt = conn.prepareStatement("INSERT INTO Customers (first_name, last_name, email, phone) VALUES (?, ?, ?, ?)");
        stmt.setString(1, firstName);
        stmt.setString(2, lastName);
        stmt.setString(3, email);
        stmt.setString(4, phone);
        stmt.executeUpdate();

        out.println("Customer added successfully!");
        stmt.close();
        conn.close();
        response.sendRedirect("dashboard.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>