<%-- 
    Document   : viewHistory
    Created on : 12 Mar 2026, 10:40:55 am
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <a href="ViewHistory">View History</a> |
            <a href="ViewFeedback">Feedback</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>

        <h1>Appointment History</h1>  
        <fieldset style="margin-bottom: 20px; padding: 10px;">
            <legend>Search/Filter History</legend>
            <form action="ViewHistory" method="GET">
                <label>Date:</label>
                <input type="date" name="searchDate">

                <label>Service Name:</label>
                <input type="text" name="searchName" placeholder="e.g. Oil Change">

                <button type="submit">Search</button>
                <a href="ViewHistory">Reset</a>
            </form>
        </fieldset>       
        <hr>
        <table border="1" cellpadding="10">
            <tr>
                <th>Appointment ID</th>
                <th>Date</th>
                <th>Service Name</th>
                <th>Service Type</th> <th>Status</th>
                <th>Action</th> </tr>
                    <c:forEach var="row" items="${appointmentData}">
                <tr>
                    <td>${row[0].appointment_id}</td>
                    <td>${row[0].appointment_date}</td>
                    <td>${row[1]}</td> <td>${row[2]}</td> 
                    <td>${row[0].appointment_status}</td>
                    <td>
                        <c:if test="${row[0].appointment_status == 'Done'}">
                            <a href="giveFeedback.jsp?appointmentId=${row[0].appointment_id}">Give Feedback</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <h1>Payment History</h1>
        <fieldset style="margin-bottom: 20px; padding: 10px;">
            <legend>Filter Payment History</legend>
            <form action="ViewHistory" method="GET">
                <label>Payment Date:</label>
                <input type="date" name="payDate">

                <label>Method:</label>
                <select name="payMethod">
                    <option value="">All Methods</option>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Cash">Cash</option>
                    <option value="Online Banking">Online Banking</option>
                </select>

                <button type="submit">Filter Payments</button>
                <a href="ViewHistory">Reset</a>
            </form>
        </fieldset>
        <hr>
        <table border="1" cellpadding="10">
            <tr>
                <th>ID</th>
                <th>Appointment ID</th>
                <th>Method</th>
                <th>Date</th>
                <th>Amount (RM)</th>
            </tr>
            <c:forEach var="pay" items="${payments}">
                <tr>
                    <td>${pay.payment_id}</td>
                    <td>${pay.appointment_id}</td>
                    <td>${pay.payment_method}</td>
                    <td>${pay.payment_date}</td>
                    <td>${pay.payment_amount}</td>
                </tr>
            </c:forEach>
        </table>

        <script>
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('commentmessage') === 'saved') {
                alert("Comment saved successfully!");
                // Clean the URL
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        </script>
    </body>
</html>
