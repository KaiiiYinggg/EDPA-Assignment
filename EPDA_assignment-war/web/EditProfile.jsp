<%-- 
    Document   : EditProfile
    Created on : 11 Mar 2026, 3:09:23 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <style>
        body{font-family:Arial;background:#f5f5f5;}
        .container{width:400px;margin:auto;margin-top:40px;padding:20px;background:white;border-radius:10px;box-shadow:0px 0px 10px rgba(0,0,0,0.1);text-align:center;}
        .profile-img{width:150px;height:150px;border-radius:50%;object-fit:cover;border:3px solid #007bff;margin-bottom:15px;}
        input{width:100%;padding:8px;margin-top:5px;margin-bottom:15px;}
        button{background:#28a745;color:white;padding:10px;border:none;width:100%;cursor:pointer;border-radius:5px;}
        .msg{color:green;font-weight:bold;}
    </style>
</head>
<body>
<div class="container">

    <h2>Edit Profile</h2>

    <img src="${pageContext.request.contextPath}/profile_pics/${empty sessionScope.user.profilePic ? 'default.png' : sessionScope.user.profilePic}" class="profile-img">

    <c:if test="${not empty message}">
        <p class="msg">${message}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/EditProfile" method="post" enctype="multipart/form-data">

        <label>Upload New Photo</label>
        <input type="file" name="profileImage" accept="image/*">

        <label>Username</label>
        <input type="text" name="username" value="${sessionScope.user.username}" required>

        <label>Email</label>
        <input type="email" value="${sessionScope.user.email}" readonly style="background-color:#eee;">

        <label>Phone Number</label>
        <input type="text" name="phoneNumber" value="${sessionScope.user.phoneNumber}" required>

        <label>New Password</label>
        <input type="password" name="password" placeholder="Leave blank if no change">

        <button type="submit">Save Changes</button>
    </form>

    <br>
    <c:choose>
        <c:when test="${sessionScope.user.role == 'manager'}">
            <a href="${pageContext.request.contextPath}/managerDashboard.jsp">Back to Dashboard</a>
        </c:when>
        <c:when test="${sessionScope.user.role == 'technician'}">
            <a href="technicianDashboard.jsp">Back to Dashboard</a>
        </c:when>
        <c:when test="${sessionScope.user.role == 'counter staff'}">
            <a href="${pageContext.request.contextPath}/Staff/StaffDashboard.jsp">Back to Dashboard</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/customerDashboard.jsp">Back to Dashboard</a>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>