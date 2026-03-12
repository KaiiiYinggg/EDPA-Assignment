<%-- 
    Document   : StaffDashboard
    Created on : 9 Mar 2026, 12:38:50 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Staff Dashboard</title>
        <style>
            body { font-family: Arial, sans-serif; padding: 20px; }
            ul { list-style-type: none; padding: 0; }
            li { margin: 10px 0; }
            a { text-decoration: none; color: #007bff; font-weight: bold; }
            a:hover { color: #0056b3; }
        </style>
    </head>
    <body>

        <h1>Welcome, ${sessionScope.user.username} (Counter Staff)</h1>
        <hr>

        <ul>
            <li>
                <a href="ManageCustomers?action=list">
                    Manage Customers
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/EditProfile.jsp">
                     Edit My Profile
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/AssignAppointment.jsp">
                    Book Service Appointment
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/PaymentReceipt.jsp">
                    Collect Payments
                </a>
            </li>
            
            <li style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/Logout" style="color: red;">Logout</a>
            </li>
        </ul>

    </body>
</html>
