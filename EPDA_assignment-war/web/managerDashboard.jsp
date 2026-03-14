<%-- 
    Document   : managerDashboard
    Created on : 8 Mar 2026, 4:08:45 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager Home Page(report)</title>
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

        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <div style="display: flex; gap: 20px; margin-top: 20px;">
            <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; flex: 1; background: #f0fdf4;">
                <h4>Total Revenue</h4>
                <p style="font-size: 24px; font-weight: bold; color: #166534;">
                    RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                </p>
            </div>

            <div style="border: 1px solid #ccc; padding: 20px; border-radius: 8px; flex: 1; background: #eff6ff;">
                <h4>Total Registered Users</h4>
                <p style="font-size: 24px; font-weight: bold; color: #1e40af;">${totalUsers}</p>
            </div>
        </div>

        <h3>Service Distribution</h3>
        <table border="1" cellpadding="10" style="width: 50%; border-collapse: collapse;">
            <tr style="background-color: #f4f4f4;">
                <th>Service Name</th>
                <th>Total Appointments</th>
            </tr>
            <c:forEach var="stat" items="${serviceStats}">
                <tr>
                    <td>${stat[0]}</td>
                    <td>${stat[1]}</td>
                </tr>
            </c:forEach>
        </table>
    </body>
</html>
