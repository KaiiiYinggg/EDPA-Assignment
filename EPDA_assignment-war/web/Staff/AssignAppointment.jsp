<%-- 
    Document   : AssignAppointment
    Created on : 9 Mar 2026, 12:41:14 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head><title>Assign Appointments</title></head>
<body>
    <h2>Assign Service Appointments</h2>
    <table border="1">
        <tr>
            <th>Appt ID</th><th>Customer</th><th>Service Type</th><th>Date</th><th>Assign To Technician</th>
        </tr>
        <c:forEach var="appt" items="${pendingAppts}">
            <form action="AppointmentController" method="POST">
                <input type="hidden" name="action" value="assign">
                <input type="hidden" name="apptId" value="${appt.id}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.customerName}</td>
                    <td>${appt.serviceType} (1h/3h) [cite: 11]</td>
                    <td>${appt.date}</td>
                    <td>
                        <select name="techId">
                            <c:forEach var="tech" items="${availableTechs}">
                                <option value="${tech.username}">${tech.name}</option>
                            </c:forEach>
                        </select>
                        <input type="submit" value="Assign">
                    </td>
                </tr>
            </form>
        </c:forEach>
    </table>
</body>
</html>