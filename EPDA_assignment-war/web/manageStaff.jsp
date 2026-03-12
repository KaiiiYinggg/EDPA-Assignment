<%-- 
    Document   : manageStaff
    Created on : 9 Mar 2026, 8:57:09 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Staff Page</title>
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
        
        <h2>Staff Management</h2>
        
        <form action="ManageStaff" method="get">
            <input type="text" name="searchQuery" placeholder="Search by username..."value="${param.searchQuery}">
            <input type="submit" value="Search">
        </form>
        <br>
        
        <table border="1" cellpadding="10">
            <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Phone(+60)</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            <c:forEach items="${staffList}" var="staff">
                <tr>
                    <td>${staff.username}</td>
                    <td>${staff.email}</td>
                    <td>${staff.phoneNumber}</td>
                    <td>${staff.role}</td>
                    <td>
                        <a href="UpdateStaff?email=${staff.email}">Update</a> | 
                        <a href="DeleteUser?email=${staff.email}" 
                           onclick="return confirm('Are you sure to delete ${staff.username} with email ${staff.email}?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
        
        <c:if test="${empty staffList}">
            <p>No staff members found.</p>
        </c:if>
        
    </body>
</html>
