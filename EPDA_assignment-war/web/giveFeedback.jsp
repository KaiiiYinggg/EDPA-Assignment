<%-- 
    Document   : customerGiveFeedback
    Created on : 11 Mar 2026, 4:08:04 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Give Feedback Page</title>
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
        <h2>Give Feedback</h2>
        
        <form action="customerGiveFeedback" method="post">
            <table>
                <tr>
                    <td>Phone Number:</td>
                    <td><input type="text" name="phoneNumber" size="20"/></td>
                </tr>
                <tr>
                    <td>Give feedback to:</td>
                    <td>
                        <select name="role">
                            <option value="technician">Technician</option>
                            <option value="counter staff">Counter Staff</option>
                    </td>
                </tr>
                <tr>
                    <td>Ranking to Service:</td>
                    <td>
                        <select name="role">
                            <option value="technician">Technician</option>
                            <option value="counter staff">Counter Staff</option>
                    </td>
                </tr>
            </table>
            <p><input type="submit" value="Save"/></p>
        </form>
        <nav>
            <a href="veiwFeedback.jsp">View Feedback</a>
        </nav>
    </body>
</html>
