<%-- 
    Document   : customerDashboard
    Created on : 11 Mar 2026, 4:05:00 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Dashboard</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #f4f4f4;
            }
            .status-pending {
                color: #d97706;
                font-weight: bold;
            } /* 橙色表示等待中 */
            .car-box {
                background: #f9fafb;
                padding: 10px;
                border-left: 4px solid #3b82f6;
                margin-bottom: 5px;
            }
        </style>
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

        <h1>My Registered Vehicles</h1>
        <c:choose>
            <c:when test="${empty customerCars}">
                <p>You haven't registered any cars yet.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="car" items="${customerCars}">
                    <div class="car-box">
                        <strong>Plate:</strong> ${car.carPlateNumber} | 
                        <strong>Brand:</strong> ${car.carBrand} | 
                        <strong>Model:</strong> ${car.carModel}
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <h2>Active Service Requests (Pending)</h2>
        <c:choose>
            <c:when test="${empty serviceSummary}">
                <p>No pending service requests at the moment.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Car Plate</th>
                        <th>Service (Type)</th> <th>Status</th>
                    </tr>
                    <c:forEach var="row" items="${serviceSummary}">
                        <tr>
                            <td>${row[0]}</td> <td>${row[3]}</td> <td>${empty row[4] ? 'N/A' : row[4]}</td> <%-- 同时显示 Service Name 和 Service Type --%>
                            <td>
                                <strong>${row[1]}</strong> 
                                <br/>
                                <small style="color: gray;">Type: ${row[5]}</small>
                            </td>

                            <td>
                                <span class="status-pending">${row[2]}</span> </td> 
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>

        <p><small>* View your full service history in the "View History" section.</small></p>
    </body>
</html>