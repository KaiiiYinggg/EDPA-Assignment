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

            th {
                background-color: #f8f9fa;
                padding: 15px;
                color: #495057;
                border-bottom: 2px solid #dee2e6;
                font-size: 0.85rem;
                text-transform: uppercase;
            }
            td {
                padding: 15px;
                vertical-align: middle;
                border-bottom: 1px solid #eee;
            }

            .price-input {
                max-width: 150px;
                font-weight: bold;
                color: #2e7d32;
                border-left: none;
            }
            .input-group-text {
                border-right: none;
            }
            .form-control:focus {
                border-color: #ced4da;
                box-shadow: none;
                background-color: #fffdec;
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
                <h3 class="fw-bold section-title">Service Pricing Management</h3>
                <p class="text-muted mb-4 small">Update the standard rates for car services. These changes will reflect immediately on new appointments.</p>

                <form action="SetPrice" method="post" onsubmit="return confirm('Are you sure you want to update all service prices? This will affect all new bookings.')">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th><i class="fas fa-wrench me-2 text-muted"></i>Service Category</th>
                                    <th><i class="fas fa-tag me-2 text-muted"></i>Unit Price (RM)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${serviceList}" varStatus="status">
                                    <tr>
                                        <td class="fw-bold text-dark">${s.serviceType}</td>
                                        <td>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light text-success fw-bold">RM</span>
                                                <input type="number" step="0.01" min="0" name="price_${status.index}" 
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
                            <i class="fas fa-chevron-left me-1"></i> Return to Dashboard
                        </a>
                        <input type="hidden" name="totalCount" value="${serviceList.size()}">
                        <button type="submit" name="updateAll" value="Update All" class="btn btn-warning px-5 py-2 fw-bold shadow-sm">
                            <i class="fas fa-check-circle me-2"></i>Apply Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>