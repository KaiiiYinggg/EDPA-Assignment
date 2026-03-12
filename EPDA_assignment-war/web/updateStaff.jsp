<%-- 
    Document   : updateStaff
    Created on : 10 Mar 2026, 9:18:55 pm
    Author     : teech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Staff Page</title>
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
        
        <h2>Update Staff</h2>
        
        <form action="UpdateStaff" method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="oldEmail" value="${staff.email}">
            <input type="hidden" name="profilePic" value="${staff.profilePic}">
            
            <table>
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="username"value="${staff.username}" size="20"/></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password"value="${staff.password}" size="20"/></td>
                </tr>           
                <tr>
                    <td>Email:</td>
                    <td><input type="text" name="newEmail"value="${staff.email}" size="20"/></td>
                </tr>
                <tr>
                    <td>Phone Number:</td>
                    <td><input type="text" name="phoneNumber"value="${staff.phoneNumber}" size="20"/></td>
                </tr>
                <tr>
                    <td>Gender:</td>
                    <td>
                        <select name="gender">
                            <option value="Male"${staff.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female"${staff.gender == 'Female' ? 'selected' : ''}>Female</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Role:</td>
                    <td><select name="role">
                            <option value="manager"${staff.role == 'manager' ? 'selected' : ''}>Manager</option>
                            <option value="counter staff"${staff.role == 'counter staff' ? 'selected' : ''}>Counter Staff</option>
                            <option value="technician"${staff.role == 'technician' ? 'selected' : ''}>Technician</option>
                        </select>
                    </td>
                </tr>
            </table>
    
            <div style="margin-top: 15px;">
                <label>Current Profile Photo:</label><br>
            
                <img src="${pageContext.request.contextPath}/profile_pics/${empty staff.profilePic ? 'default.png' : staff.profilePic}" 
                     style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 1px solid #ccc;">
                <br>
                <label>Upload New Photo:</label>
                <input type="file" name="newProfilePic" accept="image/*">
            </div>
            
            <p><input type="submit" value="Save Change" onclick="disableWarning()"/></p>
            
            <button type="button" onclick="disableWarning(); confirmCancel();">Cancel</button>
            
            <c:if test="${not empty error}">
                <p style="color:red;">${error}</p>
            </c:if>
                
        </form>
        <script>
            let formChanged = false;

            // detect if user modifies the form
            window.onload = function() {
                const form = document.querySelector("form");
                const inputs = form.querySelectorAll("input, select");

                inputs.forEach(function(input){
                    input.addEventListener("change", function(){
                        formChanged = true;
                    });
                });

                // detect leaving page
                window.addEventListener("beforeunload", function(e){
                    if(formChanged){
                        e.preventDefault();
                        e.returnValue = "Are you sure not to save change?";
                    }
                });
            };

            // disable warning if Save button clicked
            function disableWarning(){
                formChanged = false;
            }
        </script>
        <script>
            function confirmCancel(){
                if(confirm("Are you sure not to save change?")){
                    window.location.href="ManageStaff";
                }
            }
        </script>
    </body>
</html>
