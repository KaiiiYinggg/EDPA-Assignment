<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Customer Dashboard | Car Service Center</title>

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

            /* Customer Dashboard 专用样式 */
            .car-card {
                background: white;
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
                transition: 0.3s;
            }
            .car-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            }
            .status-pending {
                color: #d97706;
                font-weight: bold;
                background: #fffbeb;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.85rem;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 10px;
                overflow: hidden;
            }
            th {
                background-color: #f8f9fa;
                padding: 15px;
                color: #2c3e50;
                border-bottom: 2px solid #eee;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="sidebar bg-customer">
            <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp" class="active"><i class="fas fa-home me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-22"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
            <div style="position: absolute; bottom: 20px; width: 100%;">
                <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
            </div>
        </div>


        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold" style="color: #2c3e50;">Welcome back, ${sessionScope.user.username}!</h2>
                <a href="${pageContext.request.contextPath}/EditProfile" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                    <i class="fas fa-cog me-1"></i>Settings
                </a>
            </div>

            <h4 class="fw-bold mb-3 text-muted"><i class="fas fa-car me-2"></i>My Registered Vehicles</h4>
            <div class="row g-3 mb-5">
                <c:choose>
                    <c:when test="${empty customerCars}">
                        <div class="col-12">
                            <div class="alert alert-light border text-center p-4">
                                <p class="mb-0 text-muted">You haven't registered any cars yet.</p>
                                <a href="${pageContext.request.contextPath}/AddVehicle.jsp" class="btn btn-primary mt-2">Add My First Car</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="car" items="${customerCars}">
                            <div class="col-md-4">
                                <div class="card car-card p-3 border-start border-info border-5">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0 me-3">
                                            <i class="fas fa-car fa-2x text-secondary opacity-50"></i>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-0">${car.carPlateNumber}</h5>
                                            <small class="text-muted">${car.carBrand} ${car.carModel}</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <h4 class="fw-bold mb-3 text-muted"><i class="fas fa-tools me-2"></i>Active Service Requests</h4>
            <div class="card shadow-sm border-0">
                <c:choose>
                    <c:when test="${empty serviceSummary}">
                        <div class="p-5 text-center text-muted">
                            <i class="fas fa-check-circle fa-3x mb-3 text-success opacity-25"></i>
                            <p>No pending service requests at the moment.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Car Plate</th>
                                        <th>Service Details</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${serviceSummary}">
                                        <tr>
                                            <td><i class="far fa-calendar-alt me-2 text-muted"></i>${row[0]}</td>
                                            <td><i class="far fa-clock me-2 text-muted"></i>${row[3]}</td>
                                            <td><span class="badge bg-light text-dark border">${empty row[4] ? 'N/A' : row[4]}</span></td>
                                            <td>
                                                <div class="fw-bold text-primary">${row[1]}</div>
                                                <small class="text-muted">Type: ${row[5]}</small>
                                            </td>
                                            <td>
                                                <%-- 只处理 Approved 状态，使用绿色打勾 Logo --%>
                                                <c:if test="${row[2] == 'Approved'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3">
                                                        <i class="fas fa-check-circle me-1"></i> Approved
                                                    </span>
                                                </c:if>
                                                <%-- 如果有其他状态但你不想给特殊颜色，可以直接显示文本 --%>
                                                <c:if test="${row[2] != 'Approved'}">
                                                    <span class="badge bg-light text-secondary border rounded-pill px-3">
                                                        ${row[2]}
                                                    </span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mt-4 p-3 bg-white rounded border-start border-warning border-4 shadow-sm">
                <p class="mb-0 small text-muted">
                    <i class="fas fa-info-circle me-1 text-warning"></i>
                    Need a full report? You can view your complete service and payment history in the 
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="fw-bold text-decoration-none">View History</a> section.
                </p>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>