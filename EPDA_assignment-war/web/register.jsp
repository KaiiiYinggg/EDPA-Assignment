<%-- 
    Document   : register
    Created on : 8 Mar 2026, 3:57:26 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
    </head>
    <body>
        
        <h2>Hi, ${sessionScope.user.username}!</h2>

        <nav>
            <a href="loadManagerDashboard">Home Page</a> | 
            <a href="register.jsp">Register</a> | 
            <a href="ManageStaff">Manage Staff</a> |
            <a href="SetPrice">Set Price</a> | 
            <a href="viewFeedback.jsp">View Feedback</a> | 
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        
        <h2>User Registration</h2>
        
        <form action="Register" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td>Profile Picture (Optional):</td>
                    <td><input type="file" name="profilePic" accept="image/*"/></td>
                </tr>
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="username" size="20"/></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" size="20"/></td>
                </tr>           
                <tr>
                    <td>Email:</td>
                    <td><input type="text" name="email" size="20"/></td>
                </tr>
                <tr>
                    <td>Phone Number:</td>
                    <td><input type="text" name="phoneNumber" size="20"/></td>
                </tr>
                <tr>
                    <td>Gender:</td>
                    <td>
                        <select name="gender">
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                    </td>
                </tr>
                <tr>
                    <td>Role:</td>
                    <td><select name="role">
                            <option value="manager">Manager</option>
                            <option value="counter staff">Counter Staff</option>
                            <option value="technician">Technician</option>
                        </select>
                    </td>
                </tr>
            </table>
            <p><input type="submit" value="Register"/></p>
        </form>
        
        <c:if test="${not empty error}">
            <p style="color: red; font-weight: bold;">${error}</p>
        </c:if>

        <%
            String successMsg = (String) request.getAttribute("loginSuccessMessage");
            if (successMsg != null) {
        %>
            <script type="text/javascript">
                alert("<%= successMsg %>");
            </script>
        <%
            }
        %>
    </body>
</html>
