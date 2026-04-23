<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Service Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
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
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }
            .card-custom {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                margin-bottom: 30px;
            }
            .form-label {
                font-weight: bold;
                color: #2c3e50;
            }
            .table thead th {
                background-color: #f8f9fa;
                text-transform: uppercase;
                font-size: 0.85rem;
                color: #6c757d;
            }
        </style>
    </head>

    <body>

        <!-- SIDEBAR -->
        <div class="sidebar bg-manager">
            <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
            <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
            <a href="${pageContext.request.contextPath}/SetPrice" class="active"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <!-- MAIN -->
        <div class="main-content">

            <div class="card-box">

                <h3 class="mb-3">Service Management</h3>

                <!-- ================= ADD SERVICE ================= -->
                <form action="SetPrice" method="post" class="row g-2 mb-4">

                    <input type="hidden" name="action" value="add">

                    <div class="col-md-3">
                        <input type="text" name="serviceType" class="form-control"
                               placeholder="Service Name" required>
                    </div>

                    <div class="col-md-2">
                        <input type="number" name="serviceHour" class="form-control"
                               placeholder="Hours" required>
                    </div>

                    <div class="col-md-3">
                        <input type="number" step="0.01" name="price" class="form-control"
                               placeholder="Price (RM)" required>
                    </div>

                    <div class="col-md-2">
                        <button class="btn btn-success w-100">
                            <i class="fas fa-plus"></i> Add
                        </button>
                    </div>

                </form>

                <form action="SetPrice" method="post">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Service Name</th>
                                <th style="width: 150px;">Duration (hr)</th>
                                <th style="width: 200px;">Price (RM)</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="s" items="${serviceList}" varStatus="status">
                                <tr>
                                    <td>
                                        <input type="text" name="serviceName_${status.index}" 
                                               value="${s.serviceType}" class="form-control" required>
                                        <input type="hidden" name="serviceId_${status.index}" value="${s.service_id}">
                                    </td>

                                    <td>
                                        <div class="input-group">
                                            <input type="number" name="serviceHour_${status.index}" 
                                                   value="${s.serviceHour}" class="form-control" required min="1">
                                            <span class="input-group-text">hr</span>
                                        </div>
                                    </td>

                                    <td>
                                        <div class="input-group">
                                            <span class="input-group-text">RM</span>
                                            <input type="number" step="0.01" name="price_${status.index}" 
                                                   value="${s.price}" class="form-control" required>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <input type="hidden" name="totalCount" value="${serviceList.size()}">

                    <div class="text-end">
                        <button class="btn btn-warning px-5 py-2 fw-bold" name="updateAll" value="1">
                            <i class="fas fa-save me-2"></i>Save All Changes
                        </button>
                    </div>
                </form>

            </div>

        </div>

    </body>
</html>