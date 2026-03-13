<%-- 
    Document   : customerGiveFeedback
    Created on : 11 Mar 2026, 4:08:04 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Give Feedback Page</title>
    </head>
    <body>
        <h2>Hi, ${sessionScope.user.username}!</h2>

        <c:choose>
            <c:when test="${sessionScope.user.role == 'technician'}">
                <nav>
                    <a href="Technician/TechDashboard.jsp">Home Page</a> | 
                    <a href="${pageContext.request.contextPath}/ViewHistory">Task History</a> | 
                    <a href="${pageContext.request.contextPath}/UpdateTask.jsp">Update Tasks</a> |
                    <a href="${pageContext.request.contextPath}/ViewFeedback">View Comments</a> | 
                    <a href="${pageContext.request.contextPath}/EditProfile.jsp">My Profile</a> | 
                    <a href="${pageContext.request.contextPath}/Logout">Logout</a>
                </nav>
            </c:when>
            <c:otherwise>
                <nav>
                    <a href="customerDashboard.jsp">Home Page</a> | 
                    <a href="EditProfile.jsp">My Profile</a> |
                    <a href="ViewHistory">View History</a> |
                    <a href="ViewFeedback">Feedback</a> |
                    <a href="Logout">Logout</a>
                </nav>
            </c:otherwise>
        </c:choose>
        <hr>
        <h2>Give Feedback</h2>

        <form action="GiveFeedback" method="post">
            <input type="hidden" name="appointmentId" value="${param.appointmentId}"/>

            <table border="0">
                <%-- 公共显示的只读部分 --%>
                <tr>
                    <td>Appointment ID:</td>
                    <td><input type="text" value="${app.appointment_id}" readonly style="background-color: #eee;"></td>
                </tr>
                <tr>
                    <td>Car Plate:</td>
                    <td><input type="text" value="${app.car.carPlateNumber}" readonly style="background-color: #eee;"></td>
                </tr>
                <tr>
                    <td>Service Name:</td>
                    <td><input type="text" value="${app.service.serviceName}" readonly style="background-color: #eee;"></td>
                </tr>
                <tr>
                    <td>Service Type:</td>
                    <td><input type="text" value="${app.service.serviceType}" readonly style="background-color: #eee;"></td>
                </tr>
                <tr>
                    <td>Date:</td>
                    <td><input type="text" value="${app.appointment_date}" readonly style="background-color: #eee;"></td>
                </tr>

                <c:choose>
                    <%-- 技术人员看到的视图 --%>
                    <c:when test="${sessionScope.user.role == 'technician'}">
                        <tr>
                            <td>Technician Feedback:</td>
                            <td>
                                <textarea name="technicianNote" rows="4" cols="40" placeholder="Technical details..." required></textarea>
                            </td>
                        </tr>
                    </c:when>

                    <%-- 客户看到的视图 [cite: 47, 49, 51] --%>
                    <c:otherwise>
                        <tr>
                            <td>Comment target:</td>
                            <td>
                                <select name="commentTarget">
                                    <option value="To TECHNICIAN: ">Technician</option>
                                    <option value="To STAFF: ">Counter Staff</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Comment:</td>
                            <td><textarea name="customerComment" required></textarea></td>
                        </tr>
                        <tr>
                            <td>Ranking:</td>
                            <td>
                                <select name="ranking">
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Neutral</option>
                                    <option value="2">2 - Bad</option>
                                    <option value="1">1 - Very Disappointed</option>
                                </select>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
            <p>
                <input type="submit" value="Save"/> <button type="button" onclick="window.location.href = 'ViewHistory'">Cancel</button>
            </p>
        </form>

        <script>
            // Unsaved Changes Warning Logic
            let formChanged = false;
            const feedbackForm = document.querySelector('form[action="GiveFeedback"]');

            // Track if user types anything or changes dropdowns
            feedbackForm.addEventListener('input', () => {
                formChanged = true;
            });

            // Reset the flag when the user actually clicks "Save"
            feedbackForm.addEventListener('submit', () => {
                formChanged = false;
            });

            // Browser intercept when leaving the page
            window.addEventListener('beforeunload', (event) => {
                if (formChanged) {
                    event.preventDefault(); // Standard for modern browsers
                    event.returnValue = ''; // Required for Chrome/Firefox
                }
            });
        </script>
    </body>
</html>
