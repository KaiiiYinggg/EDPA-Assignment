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
            :root { --sidebar-width: 260px; }
            body { background-color: #f4f7f6; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; color: white; padding-top: 20px; z-index: 1000; transition: 0.3s; }
            .sidebar a { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; transition: 0.3s; }
            .sidebar a:hover { background: rgba(255,255,255,0.1); color: white; border-left: 4px solid #1abc9c; }
            .sidebar .active { background: #1abc9c !important; color: white !important; border-left: 4px solid #1abc9c; }
            .bg-tech { background: #273746; }
            .bg-customer { background: #1e272e; }
            .main-content { margin-left: var(--sidebar-width); padding: 30px; }

            .card { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background: white; }
            th { background-color: #f8f9fa; padding: 15px; color: #2c3e50; border-bottom: 2px solid #eee; font-size: 0.85rem; text-transform: uppercase; }
            td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 0.9rem; }

            .status-tag { padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; }
            .tag-done { background: #e8f5e9; color: #2e7d32; }
            .tag-progress { background: #e3f2fd; color: #1565c0; }
            .tag-waiting { background: #fff3e0; color: #ef6c00; }
            
            .feedback-done { font-size: 0.75rem; color: #1abc9c; font-weight: 600; }
        </style>
    </head>
    <body>
        <c:choose>
            <c:when test="${sessionScope.user.role == 'technician'}">
                <div class="sidebar bg-tech">
                    <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-secondary"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="active"><i class="fas fa-history me-2"></i> Task History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="sidebar bg-customer">
                    <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="active"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <h2 class="fw-bold mb-4" style="color: #2c3e50;">
                <i class="fas fa-history me-2 text-primary"></i>
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'technician'}">Work Task History</c:when>
                    <c:otherwise>My Service & Payment Records</c:otherwise>
                </c:choose>
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
                            <option value="">-- All Categories --</option>
                            <c:forEach var="svc" items="${allServices}">
                                <option value="${svc.serviceType}" ${param.searchName == svc.serviceType ? 'selected' : ''}>
                                    ${svc.serviceType}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary px-4 shadow-sm"><i class="fas fa-filter me-2"></i>Apply Filter</button>
                        <a href="ViewHistory" class="btn btn-light border ms-2">Reset</a>
                    </div>
                </form>
            </div>

            <div class="card mb-5 overflow-hidden">
                <div class="card-header bg-white fw-bold py-3 border-bottom">
                    <i class="fas fa-calendar-check me-2 text-info"></i>Appointment Logs
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Car Plate</th>
                                <th>Date & Time</th>
                                <th>Service</th>
                                <th>${sessionScope.user.role == 'customer' ? 'Assigned Tech' : 'Customer Email'}</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${appointmentData}">
                                <tr>
                                    <td class="fw-bold text-primary">#${app.appointment_id}</td>
                                    <td><span class="badge bg-secondary">${empty app.car ? 'N/A' : app.car.carPlateNumber}</span></td>
                                    <td><span class="d-block small">${app.appointment_date}</span><small class="text-muted">${app.appointment_time}</small></td>
                                    <td>${app.service.serviceType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sessionScope.user.role == 'customer'}">
                                                <small>${empty app.technician_email ? 'Pending Assign' : app.technician_email}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <small>${app.customer.email}</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="tagClass" value="tag-waiting" />
                                        <c:if test="${app.appointment_status == 'Approved'}"><c:set var="tagClass" value="tag-progress" /></c:if>
                                        <c:if test="${app.appointment_status == 'Completed' || app.appointment_status == 'Paid'}"><c:set var="tagClass" value="tag-done" /></c:if>
                                        <span class="status-tag ${tagClass}">${app.appointment_status}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${sessionScope.user.role == 'technician' && app.appointment_status == 'Approved'}">
                                                <a href="UpdateAppointmentStatus?id=${app.appointment_id}&status=Completed" 
                                                   class="btn btn-sm btn-success shadow-sm" onclick="return confirm('Confirm completion of this task?')">
                                                   <i class="fas fa-check me-1"></i>Finish
                                                </a>
                                            </c:when>

                                            <c:when test="${app.appointment_status == 'Paid' || app.appointment_status == 'Completed'}">
                                                <c:set var="isFbDone" value="false" />
                                                <c:forEach var="fb" items="${app.feedbacks}">
                                                    <c:if test="${(sessionScope.user.role == 'technician' && not empty fb.technician_feedback && fb.technician_feedback != 'Pending') || (sessionScope.user.role == 'customer' && fb.ranking > 0)}">
                                                        <c:set var="isFbDone" value="true" />
                                                    </c:if>
                                                </c:forEach>

                                                <c:choose>
                                                    <c:when test="${isFbDone}">
                                                        <span class="feedback-done"><i class="fas fa-check-circle me-1"></i>Processed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/GiveFeedback?appointmentId=${app.appointment_id}" class="btn btn-sm btn-outline-primary px-3">
                                                            <i class="fas fa-edit me-1"></i>${sessionScope.user.role == 'technician' ? 'Notes' : 'Feedback'}
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise><span class="text-muted small">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <c:if test="${sessionScope.user.role == 'customer'}">
                <div class="card overflow-hidden">
                    <div class="card-header bg-white fw-bold py-3 border-bottom">
                        <i class="fas fa-receipt me-2 text-success"></i>Transaction History
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Receipt ID</th><th>Appt Ref</th><th>Method</th><th>Date</th><th class="text-end">Total Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pay" items="${payments}">
                                    <tr>
                                        <td class="text-success fw-bold">#REC-${pay.payment_id}</td>
                                        <td class="text-muted">#${pay.appointment.appointment_id}</td>
                                        <td><span class="badge bg-light text-dark border font-weight-normal">${pay.payment_method}</span></td>
                                        <td class="small">${pay.payment_date}</td>
                                        <td class="text-end fw-bold">RM ${pay.total_price}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty payments}">
                                    <tr><td colspan="5" class="text-center p-4 text-muted">No payment records found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>

        <script>
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('commentmessage') === 'saved') alert("Feedback has been successfully recorded.");
            if (urlParams.get('error') === 'already_commented') alert("Note: Feedback for this service has already been submitted.");
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>