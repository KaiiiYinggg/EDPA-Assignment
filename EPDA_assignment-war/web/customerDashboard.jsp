<%-- 
    Document   : customerDashboard
    Created on : 11 Mar 2026, 4:05:00 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>

        <nav>
            <a href="customerDashboard.jsp">Home Page</a> |
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="ViewHistory">View History</a> |
            <a href="ViewFeedback">Feedback</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        
        <!--display car information-->
        <h1>My Car</h1>
    </body>
</html>
