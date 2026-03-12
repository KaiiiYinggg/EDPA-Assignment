<%-- 
    Document   : viewHistory
    Created on : 12 Mar 2026, 10:40:55 am
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View History Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>
        
        <nav>
            <a href="customerDashboard.jsp">Home Page</a> |
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="viewHistory.jsp">View History</a> |
            <a href="viewFeedback.jsp">Feedback</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        
        <h1>Appointment History</h1>
        <table>
            
        </table>
        <a href="giveFeedback.jsp">Give Feedback</a>
        
        <h1>Payment History</h1>
        <table>
            
        </table>
    </body>
</html>
