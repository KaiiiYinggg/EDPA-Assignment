<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>History | Car Service Center</title>

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

            /* History 页面特有样式 */
            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
                background: white;
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

            .status-tag {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: bold;
            }
            .already-done {
                background: #e8f5e9;
                color: #2e7d32;
            } /* Green */
            .in-progress {
                background: #e3f2fd;
                color: #1565c0;
            }  /* Blue */
            .awaiting {
                background: #fff3e0;
                color: #ef6c00;
            }     /* Orange */
        </style>
    </head>
    <body>
        <c:choose>
            <%-- TECHNICIAN --%>
            <c:when test="${sessionScope.user.role == 'technician'}">
                <div class="sidebar bg-tech">
                    <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-secondary"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="active"><i class="fas fa-history me-2"></i> Task History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>

            <%-- CUSTOMER --%>
            <c:otherwise>
                <div class="sidebar bg-customer">
                    <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-22"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="active"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <h2 class="fw-bold mb-4" style="color: #2c3e50;">
                <i class="fas fa-history me-2 text-primary"></i>
                ${sessionScope.user.role == 'technician' ? 'Work Record History' : 'Service & Payment History'}
            </h2>

            <div class="card p-3 mb-4">
                <form action="ViewHistory" method="GET" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="small fw-bold text-muted">Service Date</label>
                        <input type="date" name="searchDate" class="form-control" value="${param.searchDate}">
                    </div>
                    <div class="col-md-4">
                        <label class="small fw-bold text-muted">Service Type</label>
                        <select name="searchName" class="form-select">
                            <option value="">-- All Services --</option>
                            <c:forEach var="svc" items="${allServices}">
                                <option value="${svc.serviceType}" ${param.searchName == svc.serviceType ? 'selected' : ''}>
                                    ${svc.serviceType}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary px-4"><i class="fas fa-filter me-2"></i>Filter</button>
                        <a href="ViewHistory" class="btn btn-light border ms-2">Reset</a>
                    </div>
                </form>
            </div>

            <div class="card mb-5">
                <div class="card-header bg-white fw-bold py-3 border-bottom">
                    <i class="fas fa-calendar-check me-2 text-info"></i>Appointment Records
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Car Plate</th>
                                <th>Date & Time</th>
                                <th>Service Type</th>
                                <th>${sessionScope.user.role == 'customer' ? 'Technician' : 'Customer'}</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${appointmentData}">
                                <tr>
                                    <td class="fw-bold">#${app.appointment_id}</td>
                                    <td><span class="badge bg-secondary">${empty app.car ? 'N/A' : app.car.carPlateNumber}</span></td>
                                    <td class="small">${app.appointment_date}<br><span class="text-muted">${app.appointment_time}</span></td>
                                    <td>${app.service.serviceType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sessionScope.user.role == 'customer'}">
                                                <span class="small">${empty app.technician_email ? 'Assigning...' : app.technician_email}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="small">${app.customer.email}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-tag 
                                              ${app.appointment_status == 'Completed' || app.appointment_status == 'Paid' ? 'already-done' : ''}
                                              ${app.appointment_status == 'Approved' ? 'in-progress' : ''}
                                              ${app.appointment_status == 'Pending' ? 'awaiting' : ''}">
                                            ${app.appointment_status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <%-- 1. 技术员：如果任务还在 Approved 状态，显示 Finish 按钮 --%>
                                            <c:when test="${sessionScope.user.role == 'technician' && app.appointment_status == 'Approved'}">
                                                <a href="UpdateAppointmentStatus?id=${app.appointment_id}&status=Completed" class="btn btn-sm btn-success">✅ Finish</a>
                                            </c:when>

                                            <%-- 2. 反馈检查逻辑：Paid 或 Completed 才能操作 --%>
                                            <c:when test="${app.appointment_status == 'Paid' || app.appointment_status == 'Completed'}">
                                                
                                                <%-- 设置标记变量 --%>
                                                <c:set var="isTechDone" value="false" />
                                                <c:set var="isCustDone" value="false" />

                                                <%-- 检查这个 Appt 下面的反馈 --%>
                                                <c:forEach var="fb" items="${app.feedbacks}">
                                                    <c:if test="${not empty fb.technician_feedback && fb.technician_feedback != 'Pending' && fb.technician_feedback != ''}">
                                                        <c:set var="isTechDone" value="true" />
                                                    </c:if>
                                                    <c:if test="${fb.ranking > 0}">
                                                        <c:set var="isCustDone" value="true" />
                                                    </c:if>
                                                </c:forEach>

                                                <c:choose>
                                                    <%-- 技术员已经写过笔记了 --%>
                                                    <c:when test="${sessionScope.user.role == 'technician' && isTechDone}">
                                                        <span class="badge bg-light text-success border border-success"><i class="fas fa-check-double"></i> Note Saved</span>
                                                    </c:when>

                                                    <%-- 客户已经给过评分了 --%>
                                                    <c:when test="${sessionScope.user.role == 'customer' && isCustDone}">
                                                        <span class="badge bg-light text-primary border border-primary"><i class="fas fa-check-circle"></i> Rated</span>
                                                    </c:when>

                                                    <%-- 还没写过，才显示按钮 --%>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/GiveFeedback?appointmentId=${app.appointment_id}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-comment-dots me-1"></i>
                                                            ${sessionScope.user.role == 'technician' ? 'Write Note' : 'Feedback'}
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="text-muted small">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <c:if test="${sessionScope.user.role != 'technician'}">
                <div class="card">
                    <div class="card-header bg-white fw-bold py-3 border-bottom">
                        <i class="fas fa-receipt me-2 text-success"></i>Payment History
                    </div>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Receipt ID</th>
                                    <th>Appt Ref</th>
                                    <th>Method</th>
                                    <th>Payment Date</th>
                                    <th>Total (RM)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pay" items="${payments}">
                                    <tr>
                                        <td class="text-success fw-bold">#REC-${pay.payment_id}</td>
                                        <td class="text-muted">#${pay.appointment.appointment_id}</td>
                                        <td><span class="badge bg-light text-dark border">${pay.payment_method}</span></td>
                                        <td>${pay.payment_date}</td>
                                        <td class="fw-bold">RM ${pay.total_price}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>

        <script>
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('commentmessage') === 'saved')
                alert("Feedback saved successfully!");
            if (urlParams.get('error') === 'already_commented')
                alert("You already provided feedback for this service.");
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>