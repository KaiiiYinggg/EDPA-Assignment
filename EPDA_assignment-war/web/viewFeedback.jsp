<%-- 
    Document   : viewFeedback
    Created on : 11 Mar 2026, 1:20:37 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Feedback Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>

        <c:choose>
            <%-- Manager View --%>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <nav>
                    <a href="managerDashboard.jsp">Home Page</a> | 
                    <a href="register.jsp">Register</a> | 
                    <a href="ManageStaff">Manage Staff</a> |
                    <a href="SetPrice">Set Price</a> | 
                    <a href="ViewFeedback">View Feedback</a> | 
                    <a href="EditProfile.jsp">My Profile</a> | 
                    <a href="Logout">Logout</a>
                </nav>
                <hr>
                <h1>Customer Feedback Overview</h1>
            </c:when>

            <%-- Customer View --%>
            <c:otherwise>
                <nav>
                    <a href="customerDashboard.jsp">Home Page</a> |
                    <a href="EditProfile.jsp">My Profile</a> |
                    <a href="ViewHistory">View History</a> |
                    <a href="ViewFeedback">Feedback</a> |
                    <a href="Logout">Logout</a>
                </nav>
                <hr>
                <h1>My Feedback History</h1>
            </c:otherwise>
        </c:choose>

        <table border="1" cellpadding="10">
            <tr>
                <th>Feedback ID</th>
                <th>Appointment ID</th>
                    <%-- Manager can see customer email, customer cannot --%>
                    <c:if test="${sessionScope.user.role == 'manager'}">
                    <th>Customer Email</th>
                    </c:if>
                <th>Car Plate</th>
                <th>Service Name (Type)</th>
                <th>Date / Time</th>
                <th>Staff</th>
                <th>Technician</th>
                <th>Comment</th>
                <th>Ranking</th>
                <th>Technician feedback</th>
            </tr>

            <c:forEach var="row" items="${feedbackData}">
                <tr>
                    <td>${row[0].feedback_id}</td>
                    <td>${row[0].appointment_id}</td>

                    <c:if test="${sessionScope.user.role == 'manager'}">
                        <td>${row[8]}</td> </c:if>

                        <td>${empty row[7] ? 'No Car' : row[7]}</td> 
                    <td>${row[1]} (${row[2]})</td>
                    <td>${row[3]} / ${row[4]}</td>
                    <td>${empty row[5] ? 'N/A' : row[5]}</td> <td>${empty row[6] ? 'N/A' : row[6]}</td> <td>${row[0].customer_comment}</td>
                    <td>${row[0].ranking} / 5</td>
                    <td>${empty row[0].technician_feedback ? 'Pending' : row[0].technician_feedback}</td>
                </tr>
            </c:forEach>
        </table>
    </body>
</html>
