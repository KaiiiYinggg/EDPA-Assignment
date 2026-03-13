<%-- 
    Document   : TechDashboard
    Created on : 9 Mar 2026, 1:01:35 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Technician Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>

        <nav>
            <a href="TechDashboard.jsp">Home Page</a> | 
            <a href="GiveFeedback.jsp">Add Feedback</a> | 
            <a href="UpdateTask.jsp">Update Tasks</a> |
            <a href="ViewFeedback">View Comments</a> | 
            <a href="EditProfile.jsp">My Profile</a> | 
            <a href="Logout">Logout</a>
        </nav>
        <hr>
    </body>
</html>
