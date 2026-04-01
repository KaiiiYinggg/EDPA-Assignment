<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Manage Staff | Car Service Center</title>

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

            /* 列表专用卡片样式 */
            .table-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
            }
            .search-bar {
                max-width: 400px;
                margin-bottom: 25px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }
            th {
                background-color: #f8f9fa;
                padding: 15px;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
                color: #495057;
                font-size: 0.85rem;
                text-transform: uppercase;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
                font-size: 0.9rem;
            }

            .role-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: bold;
                text-transform: capitalize;
            }
            .badge-tech {
                background: #e0f2fe;
                color: #0369a1;
            }
            .badge-staff {
                background: #fef3c7;
                color: #92400e;
            }
        </style>
    </head>
    <body>
            <div class="sidebar bg-manager">
                <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                <a href="${pageContext.request.contextPath}/ManageStaff" class = "active"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
                <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
            </div>


            <div class="main-content">
                <div class="table-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold mb-1" style="color: #2c3e50;">Staff Management</h3>
                            <p class="text-muted small">View, search, and manage all your employees here.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-sm rounded-pill px-3">
                            <i class="fas fa-plus me-1"></i>Add New Staff
                        </a>
                    </div>

                    <div class="search-bar">
                        <form action="ManageStaff" method="get">
                            <div class="input-group shadow-sm">
                                <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" name="searchQuery" class="form-control border-start-0 ps-0" 
                                       placeholder="Search by username..." value="${param.searchQuery}">
                                <button type="submit" class="btn btn-dark px-4">Search</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Username</th>
                                    <th>IC Number</th>
                                    <th>Email Address</th>
                                    <th>Phone (+60)</th>
                                    <th>Address</th>
                                    <th>Role</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${staffList}" var="staff">
                                    <tr>
                                        <td class="fw-bold">${staff.username}</td>
                                        <td class="text-muted small">${staff.userIC}</td>
                                        <td>${staff.email}</td>
                                        <td>${staff.phoneNumber}</td>
                                        <td class="small" style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                            ${staff.address}
                                        </td>
                                        <td>
                                            <span class="role-badge ${staff.role == 'technician' ? 'badge-tech' : 'badge-staff'}">
                                                ${staff.role}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group">
                                                <a href="UpdateStaff?email=${staff.email}" class="btn btn-sm btn-outline-info me-1">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="DeleteUser?email=${staff.email}" 
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('Delete staff member: ${staff.username}?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${empty staffList}">
                        <div class="text-center p-5">
                            <i class="fas fa-users-slash fa-3x mb-3 text-muted opacity-25"></i>
                            <p class="text-muted">No staff members found matching your search.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>