<%-- 
    Document   : AddVehicle
    Created on : 11 Mar 2026, 11:55:59 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="Entity.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Vehicle Debug</title>
        <script>
            function showAlert(msg) {
                if (msg && msg.trim() !== "") {
                    alert(msg);
                }
            }
        </script>
    </head>
    <body>

        <%
            User user = (User) session.getAttribute("user");
            String email = (String) session.getAttribute("email");

            if (user == null) {
        %>
        <script>alert("Session user is null. You are not logged in!");</script>
        <%
        } else if (email == null) {
        %>
        <script>alert("Session email is null!");</script>
        <%
        } else {
        %>
        <script>
            alert("Session OK! User: <%=user.getUsername()%>, Email: <%=email%>");
        </script>
        <%
            }

            // 如果有错误信息传过来
            String error = (String) request.getAttribute("errorMessage");
            if (error != null && !error.isEmpty()) {
        %>
        <script>showAlert("<%=error.replace("\"", "\\\"")%>");</script>
        <%
            }
        %>

        <h2>Add Vehicle (Debug Version)</h2>
        <form action="AddVehicle" method="post">
            <label>Car Plate:</label><input type="text" name="carPlate" required /><br>
            <label>Brand:</label><input type="text" name="brand" required /><br>
            <label>Model:</label><input type="text" name="model" required /><br>
            <label>Color:</label><input type="text" name="color" /><br>
            <label>Year:</label><input type="number" name="year" /><br>
            <input type="submit" value="Add Vehicle" />
        </form>

    </body>
</html>
