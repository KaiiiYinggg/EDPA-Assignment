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
            .bg-customer {
                background: #1e272e;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            .car-card {
                background: white;
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            th {
                background-color: #f8f9fa;
                padding: 15px;
                color: #2c3e50;
                border-bottom: 2px solid #eee;
                font-size: 0.85rem;
                text-transform: uppercase;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
                font-size: 0.9rem;
            }

            .status-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: bold;
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
        <div class="sidebar bg-customer">
            <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Customer/CustomerDashboardServlet" class="active"><i class="fas fa-home me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
            <div style="position: absolute; bottom: 20px; width: 100%;">
                <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
            </div>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold" style="color: #2c3e50;">Welcome back, <c:out value="${sessionScope.user.username}"/>!</h2>
                <a href="${pageContext.request.contextPath}/EditProfile" class="btn btn-outline-primary btn-sm rounded-pill px-3 shadow-sm">
                    <i class="fas fa-user-cog me-1"></i>Edit Profile
                </a>
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

            <h5 class="fw-bold mb-3 text-secondary"><i class="fas fa-tools me-2"></i>Active Service Requests</h5>
            <div class="card car-card overflow-hidden">
                <c:choose>
                    <c:when test="${empty serviceSummary}">
                        <div class="p-5 text-center text-muted">
                            <i class="fas fa-clipboard-list fa-3x mb-3 opacity-25"></i>
                            <p>You have no active service requests at the moment.</p>
                            <a href="${pageContext.request.contextPath}/AddVehicle.jsp" class="btn btn-sm btn-primary">Add vehicle to start</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Service Date</th>
                                        <th>Time Slot</th>
                                        <th>Car Plate</th>
                                        <th>Service Details</th>
                                        <th class="text-center">Current Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${serviceSummary}">
                                        <tr>
                                            <td><i class="far fa-calendar-alt me-2 text-primary"></i>${row[0]}</td>
                                            <td><i class="far fa-clock me-2 text-info"></i>${row[3]}</td>
                                            <td><span class="badge bg-dark px-2 py-2">${empty row[4] ? 'N/A' : row[4]}</span></td>
                                            <td>
                                                <div class="fw-bold text-dark">${row[1]}</div>
                                                <small class="text-muted text-uppercase" style="font-size: 0.7rem;">Category: ${row[5]}</small>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${row[2] == 'Approved'}">
                                                        <span class="status-badge bg-success-subtle text-success border border-success-subtle">
                                                            <i class="fas fa-check-circle me-1"></i> Approved
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${row[2] == 'Pending'}">
                                                        <span class="status-badge bg-warning-subtle text-warning border border-warning-subtle">
                                                            <i class="fas fa-hourglass-half me-1"></i> Pending
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${row[2] == 'Completed' || row[2] == 'Paid'}">
                                                        <span class="status-badge bg-primary-subtle text-primary border border-primary-subtle">
                                                            <i class="fas fa-flag-checkered me-1"></i> Finished
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge bg-light text-secondary border">
                                                            ${row[2]}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mt-4 p-3 bg-white rounded border-start border-info border-4 shadow-sm d-flex align-items-center">
                <div class="me-3 text-info"><i class="fas fa-lightbulb fa-2x"></i></div>
                <div>
                    <p class="mb-0 small text-muted">
                        <strong>Quick Tip:</strong> You can track your past invoices and technician feedback in the 
                        <a href="${pageContext.request.contextPath}/ViewHistory" class="text-info fw-bold">View History</a> page.
                    </p>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>