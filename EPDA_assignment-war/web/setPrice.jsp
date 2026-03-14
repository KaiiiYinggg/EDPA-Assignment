<%-- 
    Document   : setPrice
    Created on : 11 Mar 2026, 10:45:28 am
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Set price Page</title>
    </head>
    <body>
        
        <h2>Hi, ${sessionScope.user.username}!</h2>
        
        <nav>
            <a href="loadManagerDashboard">Home Page</a> | 
            <a href="register.jsp">Register</a> | 
            <a href="ManageStaff">Manage Staff</a> |
            <a href="SetPrice">Set Price</a> | 
            <a href="ViewFeedback">View Feedback</a> | 
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        
        <h2>Set Service Price</h2>
        
        <form action="SetPrice" method="post">
            <table border="1" cellpadding="10">
                <tr>
                    <th>Service Name</th>
                    <th>Service Type</th>
                    <th>Price (RM)</th>
                </tr>
                <c:forEach var="s" items="${serviceList}" varStatus="status">
                    <tr>
                        <td>
                            ${s.serviceName}
                            <input type="hidden" name="serviceId_${status.index}" value="${s.service_id}">
                        </td>
                        <td>${s.serviceType}</td>
                        <td>
                            <input type="number" step="5.00" name="price_${status.index}" value="${s.price}">
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <br>
            <input type="hidden" name="totalCount" value="${serviceList.size()}">
            <input type="submit" name="updateAll" value="Update All">
        </form>            
        <br>
        <a href="managerDashboard.jsp">Back to Dashboard</a>
    </body>
</html>
