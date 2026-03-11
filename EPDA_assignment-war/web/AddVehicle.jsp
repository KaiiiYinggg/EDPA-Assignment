<%-- 
    Document   : AddVehicle
    Created on : 11 Mar 2026, 11:55:59 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="AddVehicleServlet" method="post">
    <label>Car Plate:</label><input type="text" name="carPlate" required /><br>
    <label>Brand:</label><input type="text" name="brand" required /><br>
    <label>Model:</label><input type="text" name="model" required /><br>
    <label>Color:</label><input type="text" name="color" /><br>
    <label>Year:</label><input type="number" name="year" /><br>
    <input type="submit" value="Add Vehicle" />
</form>
    </body>
</html>
