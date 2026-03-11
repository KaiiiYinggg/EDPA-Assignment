<%-- 
    Document   : login
    Created on : 8 Mar 2026, 9:40:57 am
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        
        <h2>Login</h2>
        
        <form action="Login" method="post">
            <table>
                <tr>
                    <td>Email:</td>
                    <td><input type="text" name="email" size="20"/></td>
                </tr><br>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" size="20"/></td>
                </tr><br>
            </table>
            <p><input type="submit" value="Login"/></p>
        </form>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
    </body>
</html>
