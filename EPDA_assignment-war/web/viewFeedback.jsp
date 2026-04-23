<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Feedback Overview | Car Service Center</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --sidebar-width: 260px;
            }
            body {
                background-color: #f4f7f6;
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', sans-serif;
            }
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                color: white;
                padding-top: 20px;
                z-index: 1000;
                transition: 0.3s;
            }
            .sidebar a {
                padding: 15px 25px;
                display: block;
                color: #bdc3c7;
                text-decoration: none;
                transition: 0.3s;
            }
            .sidebar a:hover {
                background: rgba(255,255,255,0.1);
                color: white;
                border-left: 4px solid #1abc9c;
            }
            .sidebar .active {
                background: #1abc9c !important;
                color: white !important;
                border-left: 4px solid #1abc9c;
            }
            .bg-manager {
                background: #1a252f;
            }
            .bg-tech {
                background: #273746;
            }
            .bg-customer {
                background: #1e272e;
            }

            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }
            .feedback-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                background: white;
                padding: 20px;
            }

            th {
                background-color: #f8f9fa;
                padding: 15px;
                color: #2c3e50;
                border-bottom: 2px solid #eee;
                font-size: 0.85rem;
                text-transform: uppercase;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
                font-size: 0.85rem;
            }

            .rating-badge {
                background: #fffde7;
                color: #fbc02d;
                padding: 4px 10px;
                border-radius: 20px;
                font-weight: bold;
                border: 1px solid #fff59d;
            }

            .comment-text {
                max-width: 200px;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                cursor: help;
            }
            .tech-note-box {
                background: #f1f8e9;
                color: #2e7d32;
                padding: 8px;
                border-radius: 6px;
                border-left: 3px solid #81c784;
                max-width: 250px;
            }
        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <div class="sidebar bg-manager">
                    <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                    <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback" class="active"><i class="fas fa-comments me-2"></i> View Feedback</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:when>
            <c:when test="${sessionScope.user.role == 'technician'}">
                <div class="sidebar bg-tech">
                    <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-secondary"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback" class="active"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sidebar bg-customer">
                    <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback" class="active"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <h2 class="fw-bold mb-4" style="color: #2c3e50;">
                <i class="fas fa-comments me-2 text-primary"></i>
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'manager'}">Global Customer Feedback</c:when>
                    <c:when test="${sessionScope.user.role == 'technician'}">My Service Ratings</c:when>
                    <c:otherwise>My Feedback History</c:otherwise>
                </c:choose>
            </h2>

            <div class="feedback-card table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Feedback ID</th>
                            <c:if test="${sessionScope.user.role == 'manager'}"><th>Customer</th></c:if>
                                <th>Car & Service</th>
                                <th>Staff & Tech</th>
                                <th>Customer Comments</th>
                                <th class="text-center">Rating</th>
                                <th>Technician's Note</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="row" items="${feedbackData}">
                            <tr>
                                <td class="text-muted">#${row[0].feedback_id}<br><small>Appt #${row[0].appointment.appointment_id}</small></td>

                                <c:if test="${sessionScope.user.role == 'manager'}">
                                    <td class="fw-bold"><c:out value="${row[7]}"/></td>
                                </c:if>

                                <td>
                                    <span class="fw-bold text-dark">${row[1]}</span>
                                </td>

                                <td>
                                    <div class="small">
                                        <i class="fas fa-user-tie me-1 text-muted"></i> Staff: ${empty row[4] ? '-' : row[4]}<br>
                                        <i class="fas fa-wrench me-1 text-muted"></i> Tech: ${empty row[5] ? '-' : row[5]}
                                    </div>
                                </td>

                                <td>
                                    <div class="comment-text" title="To Tech: ${row[0].customerCommentToTech} | To Staff: ${row[0].customerCommentToStaff}">
                                        <span class="text-primary">T:</span> <c:out value="${empty row[0].customerCommentToTech ? 'None' : row[0].customerCommentToTech}"/><br>
                                        <span class="text-secondary">S:</span> <c:out value="${empty row[0].customerCommentToStaff ? 'None' : row[0].customerCommentToStaff}"/>
                                    </div>
                                </td>

                                <td class="text-center">
                                    <span class="rating-badge">
                                        <i class="fas fa-star me-1"></i>${row[0].ranking}
                                    </span>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${empty row[0].technician_feedback}">
                                            <span class="text-muted fst-italic small">No record</span>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="tech-note-box small">
                                                <c:out value="${row[0].technician_feedback}"/>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty feedbackData}">
                    <div class="text-center p-5">
                        <i class="fas fa-comment-slash fa-3x mb-3 text-muted opacity-25"></i>
                        <p class="text-muted">No feedback records available at the moment.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>