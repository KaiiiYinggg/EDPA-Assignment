<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard | APU Automotive Center</title>

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
            .bg-staff {
                background: #2c3e50;
            }
            .bg-manager {
                background: #1a252f;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            .stat-card {
                border: none;
                border-radius: 12px;
                transition: 0.3s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            }
            .user-info-pill {
                background: white;
                padding: 8px 20px;
                border-radius: 50px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .announcement-scroll {
                max-height: 550px;
                overflow-y: auto;
            }
            .bg-unpaid {
                background-color: #fff8e1 !important;
                border-left: 4px solid #ff9800 !important;
            }
        </style>
        <meta http-equiv="refresh" content="60">
    </head>
    <body>

        <c:set var="roleClass" value="${sessionScope.user.role == 'manager' ? 'bg-manager' : 'bg-staff'}" />
        <div class="sidebar ${roleClass}">
            <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet" class="active"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
            <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold" style="color: #2c3e50;">Operation Overview</h2>
                <div class="user-info-pill d-flex align-items-center">
                    <div class="me-3 text-end d-none d-md-block">
                        <small class="text-muted d-block">Active Customers</small>
                        <span class="fw-bold text-dark">${totalCust != null ? totalCust : '0'}</span>
                    </div>
                    <div class="vr me-3 d-none d-md-block"></div>
                    <span class="text-muted small me-2">Logged in as:</span> 
                    <span class="fw-bold text-primary"><c:out value="${sessionScope.user.username}"/></span>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="card stat-card border-0 shadow-sm bg-white border-start border-info border-5">
                                <div class="card-body p-4">
                                    <h6 class="text-uppercase text-muted small fw-bold">Service Type A</h6>
                                    <h5 class="fw-bold mb-1">Normal Maintenance</h5>
                                    <span class="badge rounded-pill bg-info-subtle text-info px-3">Est: 1.0 Hour</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card stat-card border-0 shadow-sm bg-white border-start border-danger border-5">
                                <div class="card-body p-4">
                                    <h6 class="text-uppercase text-muted small fw-bold">Service Type B</h6>
                                    <h5 class="fw-bold mb-1">Major Inspection</h5>
                                    <span class="badge rounded-pill bg-danger-subtle text-danger px-3">Est: 3.0 Hours</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 rounded-3 mb-4">
                        <div class="card-header bg-white py-3 fw-bold border-0"><i class="fas fa-bolt me-2 text-warning"></i>Quick Actions</div>
                        <div class="card-body pt-0">
                            <div class="row g-3">
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'manager'}">
                                        <div class="col-md-6">
                                            <a href="ManageStaff" class="btn btn-outline-primary w-100 py-3"><i class="fas fa-users-cog d-block mb-2 fa-lg"></i> Manage Staff Team</a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="SetPrice" class="btn btn-outline-dark w-100 py-3"><i class="fas fa-tags d-block mb-2 fa-lg"></i> Update Pricing</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-success w-100 py-3 shadow-sm">
                                                <i class="fas fa-user-plus d-block mb-2 fa-lg"></i> Register New Client
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/PaymentServlet" class="btn btn-outline-warning w-100 py-3 shadow-sm text-dark">
                                                <i class="fas fa-cash-register d-block mb-2 fa-lg"></i> Collect Payment
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                        <div class="card-header bg-dark text-white py-3 fw-bold d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-bell me-2 text-warning"></i> Live Monitor</span>
                            <small class="fw-normal opacity-75">Auto-refreshes</small>
                        </div>
                        <div class="list-group list-group-flush announcement-scroll">
                            <c:forEach var="app" items="${todayApps}">
                                <div class="list-group-item p-3">
                                    <div class="d-flex w-100 justify-content-between align-items-center mb-1">
                                        <span class="text-primary fw-bold small"><i class="far fa-clock me-1"></i>${app.appointment_time}</span>
                                        <span class="badge bg-primary-subtle text-primary border-primary-subtle border">${app.appointment_status}</span>
                                    </div>
                                    <h6 class="mb-1 fw-bold">Plate: ${app.car.carPlateNumber}</h6>
                                    <p class="mb-0 small text-muted">${app.service.serviceType}</p>
                                </div>
                            </c:forEach>

                            <c:forEach var="unpaid" items="${unpaidApps}">
                                <div class="list-group-item p-3 bg-unpaid">
                                    <div class="d-flex w-100 justify-content-between align-items-center mb-1">
                                        <span class="text-danger fw-bold small"><i class="fas fa-exclamation-triangle me-1"></i> PENDING PAYMENT</span>
                                        <a href="${pageContext.request.contextPath}/PaymentServlet" class="btn btn-xs btn-danger py-0 px-2 small">Pay</a>
                                    </div>
                                    <h6 class="mb-1 fw-bold">Cust: <c:out value="${unpaid.customer.username}"/></h6>
                                    <p class="mb-0 small text-muted">Ref: #${unpaid.appointment_id}</p>
                                </div>
                            </c:forEach>

                            <c:if test="${empty todayApps && empty unpaidApps}">
                                <div class="p-5 text-center text-muted">
                                    <i class="fas fa-couch fa-3x mb-3 opacity-25"></i>
                                    <p class="small">All caught up!<br>No urgent tasks at this time.</p>
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