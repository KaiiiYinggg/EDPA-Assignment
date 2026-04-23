<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Manager Dashboard | APU Automotive</title>

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
            .bg-manager {
                background: #1a252f;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }

            .report-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                margin-bottom: 30px;
            }
            .stat-box {
                border-radius: 12px;
                padding: 25px;
                text-align: left;
                position: relative;
                overflow: hidden;
                transition: 0.3s;
            }
            .stat-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            }
            .stat-box i {
                position: absolute;
                right: 20px;
                bottom: 20px;
                font-size: 3rem;
                opacity: 0.15;
            }

            th {
                background-color: #f8f9fa;
                padding: 12px;
                color: #495057;
                font-size: 0.85rem;
                text-transform: uppercase;
                border-bottom: 2px solid #dee2e6;
            }
            td {
                padding: 12px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }

            .section-header {
                border-left: 5px solid #1e40af;
                padding-left: 15px;
                margin: 40px 0 20px 0;
                color: #1e40af;
                font-weight: bold;
                font-size: 1.25rem;
            }
            .progress {
                height: 8px;
                border-radius: 10px;
            }
        </style>
    </head>
    <body>
        <div class="sidebar bg-manager">
            <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard" class="active"><i class="fas fa-chart-line me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
            <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
            <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="report-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-1" style="color: #2c3e50;">Business Analytics</h2>
                        <p class="text-muted">Welcome back, <strong><c:out value="${sessionScope.user.username}"/></strong>. Summary of center operations.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="stat-box" style="background: #f0fdf4; border: 1px solid #bbf7d0;">
                            <h6 class="text-success fw-bold small text-uppercase">Total Revenue Generated</h6>
                            <h2 class="fw-bold mb-0" style="color: #166534;">
                                RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                            </h2>
                            <i class="fas fa-money-bill-trend-up"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="stat-box" style="background: #eff6ff; border: 1px solid #bfdbfe;">
                            <h6 class="text-primary fw-bold small text-uppercase">User Base Growth</h6>
                            <h2 class="fw-bold mb-0" style="color: #1e40af;">${totalUsers} Users</h2>
                            <i class="fas fa-user-group"></i>
                        </div>
                    </div>
                </div>

                <h4 class="section-header">Service Utilization</h4>
                <div class="table-responsive mb-4">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr><th>Service Type</th><th style="width: 200px;">Popularity Rate</th><th>Total Appointments</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stat" items="${serviceStats}">
                                <tr>
                                    <td class="fw-bold">${stat[0]}</td>
                                    <td>
                                        <div class="progress"><div class="progress-bar bg-info" style="width: ${stat[1]}%"></div></div>
                                    </td>
                                    <td><span class="badge bg-dark px-3 rounded-pill">${stat[1]}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <h4 class="section-header">Technician Efficiency</h4>
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered">
                                <thead class="table-light"><tr><th>Technician Email</th><th class="text-center">Tasks Done</th></tr></thead>
                                <tbody>
                                    <c:forEach var="tech" items="${technicianPerformance}">
                                        <tr><td><small>${tech[0]}</small></td><td class="text-center fw-bold text-primary">${tech[1]}</td></tr>
                                        </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h4 class="section-header">Staff Processing</h4>
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered">
                                <thead class="table-light"><tr><th>Staff Email</th><th class="text-center">Bills Issued</th></tr></thead>
                                <tbody>
                                    <c:forEach var="staff" items="${staffPerformance}">
                                        <tr><td><small>${staff[0]}</small></td><td class="text-center fw-bold text-success">${staff[1]}</td></tr>
                                        </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <h4 class="section-header">Service Satisfaction (NPS)</h4>
                <div class="row row-cols-1 row-cols-md-3 g-3">
                    <c:forEach var="rate" items="${serviceRatings}">
                        <div class="col">
                            <div class="p-3 border rounded bg-light text-center shadow-sm">
                                <h6 class="small fw-bold text-truncate">${rate[0]}</h6>
                                <div class="text-warning">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="${i <= rate[1] ? 'fas' : 'far'} fa-star"></i>
                                    </c:forEach>
                                </div>
                                <div class="fw-bold mt-1 text-dark"><fmt:formatNumber value="${rate[1]}" maxFractionDigits="1"/> / 5.0</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${not empty monthlyRevenue}">
                    <h4 class="section-header">Financial Trends</h4>
                    <div class="table-responsive">
                        <table class="table table-hover border">
                            <thead class="table-light"><tr><th>Month Index</th><th class="text-end">Monthly Revenue</th></tr></thead>
                            <tbody>
                                <c:forEach var="m" items="${monthlyRevenue}">
                                    <tr>
                                        <td>Month ${m[0]}</td>
                                        <td class="text-end fw-bold text-success">RM <fmt:formatNumber value="${m[1]}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>