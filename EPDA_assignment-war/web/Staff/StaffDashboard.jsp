<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard | Car Service Center</title>

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
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* 侧边栏基础样式 */
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                color: white;
                padding-top: 20px;
                z-index: 1000;
                transition: all 0.3s;
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

            /* 角色背景色 */
            .bg-manager {
                background: #1a252f;
            }
            .bg-staff {
                background: #2c3e50;
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

            /* Dashboard 特有组件 */
            .stat-card {
                border: none;
                border-radius: 10px;
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .user-info {
                background: white;
                padding: 10px 20px;
                border-radius: 50px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .announcement-scroll {
                max-height: 500px;
                overflow-y: auto;
            }
            .bg-unpaid {
                background-color: #fff3cd;
            }
        </style>
        <%-- 每 60 秒自动刷新一次，保持数据实时 --%>
        <meta http-equiv="refresh" content="60">
    </head>
    <body>

        <div class="sidebar bg-staff">
            <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet" class="active"><i class="fas fa-tachometer-alt me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/Staff/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
            <a href="${pageContext.request.contextPath}/Staff/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold" style="color: #2c3e50;">Overview</h2>
                <div class="user-info d-flex align-items-center">
                    <div class="me-3 text-end d-none d-md-block">
                        <small class="text-muted d-block">Total Customers</small>
                        <span class="fw-bold text-dark">${totalCust != null ? totalCust : '0'}</span>
                    </div>
                    <div class="vr me-3 d-none d-md-block"></div>
                    <span class="text-muted small me-1">Welcome,</span> 
                    <span class="fw-bold text-primary">${sessionScope.user.username}</span>
                    <span class="badge bg-secondary ms-2">${sessionScope.user.role}</span>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="card stat-card border-0 shadow-sm bg-white border-start border-info border-5">
                                <div class="card-body p-4">
                                    <h5 class="fw-bold mb-1">Normal Service</h5>
                                    <p class="text-muted small">Standard Maintenance</p>
                                    <span class="badge rounded-pill bg-info text-dark">1 Hour</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card stat-card border-0 shadow-sm bg-white border-start border-danger border-5">
                                <div class="card-body p-4">
                                    <h5 class="fw-bold mb-1">Major Service</h5>
                                    <p class="text-muted small">Full Inspection</p>
                                    <span class="badge rounded-pill bg-danger">3 Hours</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 rounded-3 mb-4">
                        <div class="card-header bg-white py-3 fw-bold border-0">Quick Actions</div>
                        <div class="card-body pt-0">
                            <div class="row g-3">
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'manager'}">
                                        <div class="col-md-6">
                                            <a href="ManageStaff" class="btn btn-outline-primary w-100 py-3 shadow-sm">
                                                <i class="fas fa-users-cog d-block mb-2"></i> Manage Team
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="SetPrice" class="btn btn-outline-warning w-100 py-3 shadow-sm text-dark">
                                                <i class="fas fa-dollar-sign d-block mb-2"></i> Pricing Policy
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-success w-100 py-3 shadow-sm">
                                                <i class="fas fa-user-plus d-block mb-2"></i> New Customer
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/Staff/PaymentServlet" class="btn btn-outline-warning w-100 py-3 shadow-sm text-dark">
                                                <i class="fas fa-file-invoice-dollar d-block mb-2"></i> Collect Payment
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm border-0 h-100 rounded-3">
                        <div class="card-header bg-dark text-white py-3 fw-bold">
                            <i class="fas fa-bell me-2 text-warning"></i> Real-time Alerts
                        </div>
                        <div class="list-group list-group-flush announcement-scroll">
                            <c:forEach var="app" items="${todayApps}">
                                <div class="list-group-item border-0 border-bottom p-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <small class="text-primary fw-bold">TODAY - ${app.appointment_time}</small>
                                        <span class="badge bg-light text-primary border">${app.appointment_status}</span>
                                    </div>
                                    <h6 class="mb-1 fw-bold mt-1">Car: ${app.car.carPlateNumber}</h6>
                                    <p class="mb-0 small text-muted">Service: ${app.service.serviceType}</p>
                                </div>
                            </c:forEach>

                            <c:forEach var="unpaid" items="${unpaidApps}">
                                <div class="list-group-item border-0 border-bottom p-3 bg-unpaid">
                                    <div class="d-flex w-100 justify-content-between">
                                        <small class="text-danger fw-bold"><i class="fas fa-exclamation-circle"></i> UNPAID</small>
                                        <a href="${pageContext.request.contextPath}/Staff/PaymentServlet?id=${unpaid.appointment_id}" class="badge bg-danger text-decoration-none">Pay RM</a>
                                    </div>
                                    <h6 class="mb-1 fw-bold mt-1">Cust: ${unpaid.customer.username}</h6>
                                    <p class="mb-0 small text-muted">Plate: ${unpaid.car.carPlateNumber}</p>
                                </div>
                            </c:forEach>

                            <c:if test="${empty todayApps && empty unpaidApps}">
                                <div class="p-5 text-center text-muted">
                                    <i class="fas fa-coffee fa-3x mb-3 opacity-25"></i>
                                    <p>No urgent tasks.<br>System is idle.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>