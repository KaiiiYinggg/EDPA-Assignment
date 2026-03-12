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

        <nav>
            <a href="customerDashboard.jsp">Home Page</a> |
            <a href="EditProfile.jsp">My Profile</a> |
            <a href="ViewHistory">View History</a> |
            <a href="ViewFeedback">Feedback</a> |
            <a href="Logout">Logout</a>
        </nav>
        <hr>
        <h2>Give Feedback</h2>

        <form action="GiveFeedback" method="post">
            <input type="hidden" name="appointmentId" value="${param.appointmentId}"/>

            <table>
                <tr>
                    <td>Comment target:</td>
                    <td>
                        <select name="commentTarget">
                            <option value="To TECHNICIAN: ">Technician</option>
                            <option value="To STAFF: ">Counter Staff</option>
                            <option value="To BOTH: ">Both</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Your Comment:</td>
                    <td>
                        <textarea name="customerComment" rows="4" cols="40" placeholder="Enter your feedback here..." required></textarea>
                    </td>
                </tr>
                <tr>
                    <td>Ranking (1-5 Stars):</td>
                    <td>
                        <select name="ranking">
                            <option value="5">5 - Excellent</option>
                            <option value="4">4 - Good</option>
                            <option value="3">3 - Average</option>
                            <option value="2">2 - Poor</option>
                            <option value="1">1 - Very Bad</option>
                        </select>
                    </td>
                </tr>
            </table>
            <p>
                <input type="submit" value="Save"/> <button type="button" onclick="window.location.href='ViewHistory'">Cancel</button>
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
