<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Feedback Overview | Car Service Center</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* 【2. 统一核心布局 CSS】 */
            :root { --sidebar-width: 260px; }
            body { background-color: #f4f7f6; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }

            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; color: white; padding-top: 20px; z-index: 1000; transition: 0.3s; }
            .sidebar a { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; transition: 0.3s; }
            .sidebar a:hover { background: rgba(255,255,255,0.1); color: white; border-left: 4px solid #1abc9c; }
            .sidebar .active { background: #1abc9c !important; color: white !important; border-left: 4px solid #1abc9c; }

            /* 角色背景色 */
            .bg-manager { background: #1a252f; }
            .bg-staff { background: #2c3e50; }
            .bg-tech { background: #273746; }
            .bg-customer { background: #1e272e; }

            .main-content { margin-left: var(--sidebar-width); padding: 30px; }

            /* Feedback 页面特有样式 */
            .feedback-card { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background: white; }
            table { width: 100%; border-collapse: collapse; margin-top: 0; }
            th { background-color: #f8f9fa; padding: 15px; color: #2c3e50; border-bottom: 2px solid #eee; font-size: 0.85rem; text-transform: uppercase; }
            td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 0.9rem; }
            
            .rating-badge { background: #fff9c4; color: #fbc02d; padding: 3px 8px; border-radius: 5px; font-weight: bold; border: 1px solid #fdd835; }
            .comment-box { max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: pointer; }
            .comment-box:hover { white-space: normal; position: absolute; background: white; z-index: 10; border: 1px solid #ddd; padding: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        </style>
    </head>
    <body>

    <c:choose>
        <%-- MANAGER --%>
        <c:when test="${sessionScope.user.role == 'manager'}">
            <div class="sidebar bg-manager">
                <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
                <a href="register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                <a href="ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                <a href="SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                <a href="ViewFeedback" class="active"><i class="fas fa-comments me-2"></i> View Feedback</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:when>

        <%-- COUNTER STAFF --%>
        <c:when test="${sessionScope.user.role == 'counter staff'}">
            <div class="sidebar bg-staff">
                <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Dashboard"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/Staff/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
                <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
                <a href="${pageContext.request.contextPath}/Staff/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:when>

        <%-- TECHNICIAN --%>
        <c:when test="${sessionScope.user.role == 'technician'}">
            <div class="sidebar bg-tech">
                <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-secondary"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
                <a href="ViewFeedback" class="active"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:when>

        <%-- CUSTOMER --%>
        <c:otherwise>
            <div class="sidebar bg-customer">
                <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp"><i class="fas fa-home me-2"></i> Home Page</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
                <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
                <a href="ViewFeedback" class="active"><i class="fas fa-star me-2"></i> Feedback</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="main-content">
        <h2 class="fw-bold mb-4" style="color: #2c3e50;">
            <i class="fas fa-comments me-2 text-primary"></i>
            ${sessionScope.user.role == 'manager' ? 'Customer Feedback Overview' : 'Service Feedback History'}
        </h2>

        <div class="feedback-card table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Appt</th>
                        <c:if test="${sessionScope.user.role == 'manager'}">
                            <th>Customer</th>
                        </c:if>
                        <th>Car</th>
                        <th>Service</th>
                        <th>Staff / Tech</th>
                        <th>Comments (Tech/Staff)</th>
                        <th>Rating</th>
                        <th>Tech Note</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${feedbackData}">
                        <tr>
                            <td class="text-muted small">#${row[0].feedback_id}</td>
                            <td class="fw-bold">#${row[0].appointment.appointment_id}</td>
                            
                            <c:if test="${sessionScope.user.role == 'manager'}">
                                <td class="small">${row[8]}</td> 
                            </c:if>

                            <td><span class="badge bg-light text-dark border">${empty row[7] ? 'N/A' : row[7]}</span></td>
                            <td><span class="small d-block fw-bold">${row[1]}</span><small class="text-muted">${row[2]}</small></td>
                            <td>
                                <small class="d-block text-muted">S: ${empty row[5] ? '-' : row[5]}</small>
                                <small class="d-block text-muted">T: ${empty row[6] ? '-' : row[6]}</small>
                            </td>
                            <td>
                                <div class="comment-box text-primary small">Tech: ${empty row[0].customerCommentToTech ? '-' : row[0].customerCommentToTech}</div>
                                <div class="comment-box text-secondary small">Staff: ${empty row[0].customerCommentToStaff ? '-' : row[0].customerCommentToStaff}</div>
                            </td>
                            <td><span class="rating-badge"><i class="fas fa-star me-1"></i>${row[0].ranking}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty row[0].technician_feedback}">
                                        <span class="text-muted italic small">No note</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="small text-success">${row[0].technician_feedback}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty feedbackData}">
                        <tr><td colspan="10" class="text-center p-5 text-muted">No feedback records found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>