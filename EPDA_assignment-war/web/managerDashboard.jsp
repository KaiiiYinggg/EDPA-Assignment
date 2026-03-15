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
        <title>Manager Home Page (Reports)</title>
        <style>
            .summary-container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                margin-bottom: 30px;
            }
            .card {
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 8px;
                flex: 1;
                text-align: center;
            }
            table {
                width: 80%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            th {
                background-color: #f4f4f4;
                text-align: left;
            }
            h3 {
                color: #333;
                border-left: 5px solid #1e40af;
                padding-left: 10px;
            }
        </style>
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

        <%-- 报表 1 & 2: 核心指标卡片 --%>
        <div class="summary-container">
            <div class="card" style="background: #f0fdf4;">
                <h4>Total Revenue</h4>
                <p style="font-size: 24px; font-weight: bold; color: #166534;">
                    RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                </p>
            </div>
            <div class="card" style="background: #eff6ff;">
                <h4>Total Registered Users</h4>
                <p style="font-size: 24px; font-weight: bold; color: #1e40af;">${totalUsers}</p>
            </div>
        </div>

        <%-- 报表 3: 服务流行度 --%>
        <h3>1. Service Distribution (Popularity)</h3>
        <table border="1" cellpadding="10">
            <tr><th>Service Name</th><th>Total Appointments</th></tr>
                    <c:forEach var="stat" items="${serviceStats}">
                <tr><td>${stat[0]}</td><td>${stat[1]}</td></tr>
            </c:forEach>
        </table>

        <%-- 报表 4: 技术人员绩效 --%>
        <h3>2. Technician Performance</h3>
        <table border="1" cellpadding="10">
            <tr><th>Technician Email</th><th>Tasks Completed</th></tr>
                    <c:forEach var="tech" items="${technicianPerformance}">
                <tr><td>${tech[0]}</td><td>${tech[1]}</td></tr>
            </c:forEach>
        </table>
        
        <h3>3. Counter Staff Performance</h3>
        <table border="1" cellpadding="10">
            <tr><th>Counter Staff Email</th><th>Tasks Completed</th></tr>
                    <c:forEach var="staff" items="${staffPerformance}">
                <tr><td>${staff[0]}</td><td>${staff[1]}</td></tr>
            </c:forEach>
        </table>

        <%-- 报表 5: 服务质量满意度 --%>
        <h3>4. Service Customer Satisfaction</h3>
        <table border="1" cellpadding="10">
            <tr><th>Service Name</th><th>Average Rating</th></tr>
                    <c:forEach var="rate" items="${serviceRatings}">
                <tr>
                    <td>${rate[0]}</td>
                    <td><fmt:formatNumber value="${rate[1]}" maxFractionDigits="1"/> / 5.0</td>
                </tr>
            </c:forEach>
        </table>

        <%-- 补充报表建议: 月度收入趋势 (需在 Servlet 中放入 monthlyRevenue) --%>
        <c:if test="${not empty monthlyRevenue}">
            <h3>5. Monthly Revenue Trend</h3>
            <table border="1" cellpadding="10">
                <tr><th>Month Index</th><th>Monthly Revenue (RM)</th></tr>
                        <c:forEach var="m" items="${monthlyRevenue}">
                    <tr><td>Month ${m[0]}</td><td>RM <fmt:formatNumber value="${m[1]}" pattern="#,##0.00"/></td></tr>
                </c:forEach>
            </table>
        </c:if>

    </body>
</html>