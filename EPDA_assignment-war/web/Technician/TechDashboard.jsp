<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Technician Dashboard | Car Service Center</title>

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

            /* Technician 页面特有样式 */
            .task-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            .task-table th { background-color: #f8f9fa; padding: 15px; color: #2c3e50; border-bottom: 2px solid #eee; }
            .task-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
            
            .done-btn { background: #28a745; color: white; border: none; padding: 8px 15px; border-radius: 5px; font-weight: bold; transition: 0.3s; }
            .done-btn:hover { background: #218838; transform: translateY(-2px); }
            
            .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; background: #e3f2fd; color: #0d47a1; }
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
                <a href="ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
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
                <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet" class="active"><i class="fas fa-home me-2"></i> Home Page</a>
                <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
                <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:when>

        <%-- CUSTOMER --%>
        <c:otherwise>
            <div class="sidebar bg-customer">
                <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Dashboard"><i class="fas fa-home me-2"></i> Home Page</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
                <a href="${pageContext.request.contextPath}/Customer/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
                <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-bullhorn me-2"></i> Feedback</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold" style="color: #2c3e50;">Pending Service Tasks</h2>
            <div class="user-info d-flex align-items-center bg-white px-4 py-2 rounded-pill shadow-sm">
                <span class="text-muted small me-2">Technician:</span> 
                <span class="fw-bold text-primary">${sessionScope.user.username}</span>
            </div>
        </div>
        <hr>

        <h3 class="h5 fw-bold mb-3 text-muted"><i class="fas fa-list-check me-2"></i>Job List (Approved)</h3>
        
        <table class="task-table">
            <thead>
                <tr>
                    <th>Appt ID</th>
                    <th>Car Plate</th>
                    <th>Service Type</th>
                    <th>Customer Name</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="app" items="${taskList}">
                    <c:if test="${app.appointment_status == 'Approved'}">
                        <tr>
                            <td class="fw-bold text-info">#${app.appointment_id}</td>
                            <td><span class="badge bg-secondary">${app.car.carPlateNumber}</span></td>
                            <td>${app.service.serviceType}</td>
                            <td>${app.customer.username}</td>
                            <td><span class="status-badge">${app.appointment_status}</span></td>
                            <td>
                                <form action="TechnicianServlet" method="POST" style="margin:0;">
                                    <input type="hidden" name="appointmentId" value="${app.appointment_id}">
                                    <input type="hidden" name="status" value="Completed">
                                    <button type="submit" class="done-btn" onclick="return confirm('Confirm this job is done?')">
                                        <i class="fas fa-check-double me-1"></i> Finish Job
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>

                <c:if test="${empty taskList}">
                    <tr>
                        <td colspan="6" class="text-center p-5 text-muted">
                            <i class="fas fa-mug-hot fa-3x mb-3 opacity-25"></i>
                            <p>No pending tasks. Great job!</p>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>