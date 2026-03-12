<%-- 
    Document   : viewFeedback
    Created on : 11 Mar 2026, 1:20:37 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Feedback Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>
        <!--if role = manager -->
        <nav>
            <a href="managerDashboard.jsp">Home Page</a> | 
            <a href="register.jsp">Register</a> | 
            <a href="ManageStaff">Manage Staff</a> |
            <a href="SetPrice">Set Price</a> | 
            <a href="viewFeedback.jsp">View Feedback</a> | 
            <a href="EditProfile.jsp">My Profile</a> | 
            <a href="Logout">Logout</a>
        </nav>        
        <hr>
        <!--if role=customer-->
        <nav>
            <a href="customerDashboard.jsp">Home Page</a> |
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="viewHistory.jsp">View History</a> |
            <a href="viewFeedback.jsp">Feedback</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        <h2>View Feedback</h2>
        
        <h2>My Feedback</h2>
        
        <h2>Others Feedback</h2>
    </body>
</html>
