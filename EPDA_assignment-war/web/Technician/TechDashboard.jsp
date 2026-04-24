<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Technician Workspace | Car Service Center</title>

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
            .bg-tech {
                background: #273746;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            .task-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
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
                padding: 18px 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }

            .done-btn {
                background: #10b981;
                color: white;
                border: none;
                padding: 8px 20px;
                border-radius: 6px;
                font-weight: bold;
                transition: 0.2s;
                box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
            }
            .done-btn:hover {
                background: #059669;
                transform: translateY(-1px);
                box-shadow: 0 4px 6px rgba(16, 185, 129, 0.3);
            }

            .status-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: bold;
                background: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .plate-badge {
                background: #334155;
                color: white;
                font-family: monospace;
                font-size: 0.9rem;
                letter-spacing: 1px;
            }

            .ticker-wrapper {
                background: #d3e1f0;
                overflow: hidden;
                white-space: nowrap;
                position: relative;
            }

            .ticker {
                display: flex;
                width: max-content;
                animation: scroll-left 25s linear infinite;
            }

            .ticker:hover {
                animation-play-state: paused;
            }

            .ticker-content {
                display: flex;
                white-space: nowrap;
            }

            @keyframes scroll-left {
                0% {
                    transform: translateX(0);
                }
                100% {
                    transform: translateX(-50%);
                }
            }
        </style>
    </head>
    <body>

        <div class="sidebar bg-tech">
            <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-info"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet" class="active"><i class="fas fa-home me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;">
                <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
            </div>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Active Jobs</h2>
                    <p class="text-muted small">Welcome back, <strong><c:out value="${sessionScope.user.username}"/></strong>. Here are your assigned tasks.</p>
                </div>
                <div class="bg-white px-4 py-3 rounded-3 shadow-sm text-center">
                    <small class="text-muted d-block text-uppercase fw-bold" style="font-size: 0.65rem;">Pending Work</small>
                    <span class="h4 fw-bold text-primary">
                        <c:set var="pendingCount" value="0" />
                        <c:forEach var="item" items="${taskList}"><c:if test="${item.appointment_status == 'Approved'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if></c:forEach>
                        ${pendingCount}
                    </span>
                </div>
            </div>
            <c:if test="${not empty businessHours}">
                <div class="notice-bar shadow-sm mb-4">

                    <div class="notice-label">
                        <i class="fas fa-bullhorn me-2"></i> Notice
                    </div>
                    <%-- display holiday date --%>
                    <div class="ticker-wrapper">
                        <div class="ticker">
                            <c:forEach var="b" items="${businessHours}">
                                <span class="ticker-item me-5 px-3">
                                    <i class="far fa-calendar-alt me-1"></i>
                                    ${b.businessDate} :

                                    <c:choose>
                                        <c:when test="${b.isClosed}">
                                            <span class="text-danger fw-bold">Closed (Holiday)</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="text-info">
                                                Open ${b.openTime} - ${b.closeTime}
                                            </span>

                                            <c:if test="${not empty b.note}">
                                                <span class="text-muted"> - ${b.note}</span>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </c:forEach>

                            <c:forEach var="b" items="${businessHours}">
                                <span class="ticker-item me-5 px-3">
                                    <i class="far fa-calendar-alt me-1"></i>
                                    ${b.businessDate} :

                                    <c:choose>
                                        <c:when test="${b.isClosed}">
                                            <span class="text-danger fw-bold">Closed (Holiday)</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="text-info">
                                                Open ${b.openTime} - ${b.closeTime}
                                            </span>

                                            <c:if test="${not empty b.note}">
                                                <span class="text-muted"> - ${b.note}</span>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </c:forEach>

                        </div>
                    </div>
                </div>
            </c:if>
            <h3 class="h6 fw-bold mb-3 text-secondary text-uppercase"><i class="fas fa-wrench me-2"></i>Current Assignments</h3>

            <div class="table-responsive">
                <table class="task-table table-hover">
                    <thead>
                        <tr>
                            <th>Appt ID</th>
                            <th>Car Plate</th>
                            <th>Service Category</th>
                            <th>Customer</th>
                            <th>Progress</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${taskList}">
                            <c:if test="${app.appointment_status == 'Approved'}">
                                <tr>
                                    <td class="fw-bold text-muted">#${app.appointment_id}</td>
                                    <td><span class="badge plate-badge px-3 py-2 shadow-sm">${app.car.carPlateNumber}</span></td>
                                    <td>
                                        <div class="fw-bold text-dark">${app.service.serviceType}</div>
                                        <small class="text-muted">${app.appointment_date} | ${app.appointment_time}</small>
                                    </td>
                                    <td><c:out value="${app.customer.username}"/></td>
                                    <td><span class="status-badge"><i class="fas fa-spinner fa-spin me-1"></i> In Service</span></td>
                                    <td class="text-center">
                                        <form action="TechnicianServlet" method="POST" class="m-0">
                                            <input type="hidden" name="appointmentId" value="${app.appointment_id}">
                                            <input type="hidden" name="status" value="Completed">
                                            <button type="submit" class="done-btn" onclick="return confirm('Confirm completion for car ${app.car.carPlateNumber}?')">
                                                <i class="fas fa-check-circle me-1"></i> Mark as Done
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>

                        <c:if test="${pendingCount == 0}">
                            <tr>
                                <td colspan="6" class="text-center p-5">
                                    <div class="py-4">
                                        <i class="fas fa-mug-hot fa-3x mb-3 text-muted opacity-25"></i>
                                        <h5 class="text-muted">No pending jobs found.</h5>
                                        <p class="text-muted small">You're all caught up! Time for a short break.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>