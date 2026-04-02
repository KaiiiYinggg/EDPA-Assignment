<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Set Service Price | Car Service Center</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* 【2. 统一核心布局 CSS】 */
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
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }

            /* 设置价格专用卡片样式 */
            .price-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 800px;
                margin: auto;
            }
            .section-title {
                border-left: 5px solid #f1c40f;
                padding-left: 15px;
                margin-bottom: 25px;
                color: #2c3e50;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th {
                background-color: #f8f9fa;
                padding: 15px;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
                color: #495057;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }

            .price-input {
                max-width: 150px;
                font-weight: bold;
                color: #2e7d32;
            }
        </style>
    </head>
    <body>

        <div class="sidebar bg-manager">
            <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
            <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
            <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/SetPrice" class="active"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>


        <div class="main-content">
            <div class="price-card">
                <h3 class="fw-bold section-title">Set Service Price</h3>
                <p class="text-muted mb-4 small">Update the standard pricing for all automotive services offered.</p>

                <form action="SetPrice" method="post">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th><i class="fas fa-tools me-2"></i>Service Type</th>
                                    <th><i class="fas fa-hand-holding-usd me-2"></i>Price (RM)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${serviceList}" varStatus="status">
                                    <tr>
                                        <td class="fw-bold text-secondary">${s.serviceType}</td>
                                        <td>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light text-success fw-bold">RM</span>
                                                <input type="number" step="0.01" name="price_${status.index}" 
                                                       value="${s.price}" class="form-control price-input" required>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard" class="text-decoration-none text-muted small">
                            <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
                        </a>
                        <input type="hidden" name="totalCount" value="${serviceList.size()}">
                        <button type="submit" name="updateAll" value="Update All" class="btn btn-success px-5 py-2 fw-bold shadow-sm">
                            <i class="fas fa-save me-2"></i>Update All Prices
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>