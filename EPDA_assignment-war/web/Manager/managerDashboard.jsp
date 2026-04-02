<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Manager Dashboard | Car Service Center</title>

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
                padding: 40px;
            }

            /* 报表专用样式 - 仿照你的 feedback-card */
            .report-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                margin-bottom: 30px;
            }
            .stat-box {
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                text-align: center;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th {
                background-color: #f8f9fa;
                padding: 12px;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
                color: #495057;
                font-size: 0.9rem;
            }
            td {
                padding: 12px;
                border-bottom: 1px solid #eee;
                color: #212529;
            }

            .section-header {
                border-left: 5px solid #1e40af;
                padding-left: 15px;
                margin: 30px 0 20px 0;
                color: #1e40af;
                font-weight: bold;
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
            <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>
        
        <div class="main-content">
            <div class="report-card">
                <h2 class="fw-bold mb-4" style="color: #2c3e50;">
                    <i class="fas fa-chart-line me-2 text-primary"></i>Manager Dashboard
                </h2>
                <p class="text-muted">Welcome back, ${sessionScope.user.username}. Here is the business performance summary.</p>

                <div class="row g-4 mt-2">
                    <div class="col-md-6">
                        <div class="stat-box" style="background: #f0fdf4; border: 1px solid #bbf7d0;">
                            <h6 class="text-success fw-bold">TOTAL REVENUE</h6>
                            <h2 class="fw-bold" style="color: #166534;">
                                RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                            </h2>
                            <i class="fas fa-money-bill-wave fa-2x text-success opacity-25"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="stat-box" style="background: #eff6ff; border: 1px solid #bfdbfe;">
                            <h6 class="text-primary fw-bold">REGISTERED USERS</h6>
                            <h2 class="fw-bold" style="color: #1e40af;">${totalUsers}</h2>
                            <i class="fas fa-users fa-2x text-primary opacity-25"></i>
                        </div>
                    </div>
                </div>

                <hr class="my-5">

                <h4 class="section-header">1. Service Distribution (Popularity)</h4>
                <div class="table-responsive mb-5">
                    <table class="table align-middle">
                        <thead>
                            <tr><th>Service Name</th><th>Total Appointments</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stat" items="${serviceStats}">
                                <tr>
                                    <td class="fw-bold">${stat[0]}</td>
                                    <td><span class="badge bg-info px-3 rounded-pill">${stat[1]}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <h4 class="section-header">2. Technician Performance</h4>
                        <table class="table small">
                            <thead><tr><th>Email</th><th>Tasks</th></tr></thead>
                            <tbody>
                                <c:forEach var="tech" items="${technicianPerformance}">
                                    <tr><td>${tech[0]}</td><td class="fw-bold">${tech[1]}</td></tr>
                                    </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h4 class="section-header">3. Counter Staff Performance</h4>
                        <table class="table small">
                            <thead><tr><th>Email</th><th>Processed</th></tr></thead>
                            <tbody>
                                <c:forEach var="staff" items="${staffPerformance}">
                                    <tr><td>${staff[0]}</td><td class="fw-bold">${staff[1]}</td></tr>
                                    </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <h4 class="section-header">4. Service Customer Satisfaction</h4>
                <table class="table">
                    <thead><tr><th>Service Name</th><th>Average Rating</th></tr></thead>
                    <tbody>
                        <c:forEach var="rate" items="${serviceRatings}">
                            <tr>
                                <td>${rate[0]}</td>
                                <td class="fw-bold text-warning">
                                    <i class="fas fa-star me-1"></i>
                                    <fmt:formatNumber value="${rate[1]}" maxFractionDigits="1"/> / 5.0
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${not empty monthlyRevenue}">
                    <h4 class="section-header">5. Monthly Revenue Trend</h4>
                    <table class="table table-hover border">
                        <thead class="table-light"><tr><th>Month</th><th>Revenue</th></tr></thead>
                        <tbody>
                            <c:forEach var="m" items="${monthlyRevenue}">
                                <tr>
                                    <td>Month ${m[0]}</td>
                                    <td class="fw-bold text-success">RM <fmt:formatNumber value="${m[1]}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>