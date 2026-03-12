<%-- 
    Document   : managerDashboard
    Created on : 8 Mar 2026, 4:08:45 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager Home Page(report)</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>

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

        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        
        <h3>Summary Report</h3>
    </body>
</html>
