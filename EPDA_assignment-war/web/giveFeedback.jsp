<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Give Feedback | Car Service Center</title>

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
            .bg-customer {
                background: #1e272e;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }
            .feedback-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 700px;
                margin: auto;
            }
            .info-label {
                font-weight: 600;
                color: #6c757d;
                font-size: 0.85rem;
                margin-bottom: 2px;
            }
            .readonly-box {
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                padding: 10px;
                margin-bottom: 15px;
                color: #212529;
                font-weight: 500;
            }
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
                    <a href="${pageContext.request.contextPath}/Customer/CustomerDashboardServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-id-card me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory" class="active"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <div class="feedback-card">
                <h3 class="fw-bold mb-4" style="color: #2c3e50;">
                    <i class="fas fa-pen-nib me-2 text-primary"></i>Give Feedback
                </h3>

                <form action="GiveFeedback" method="post" id="feedbackForm">
                    <input type="hidden" name="appointmentId" value="${param.appointmentId}"/>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="info-label">Appointment ID</label>
                            <div class="readonly-box">#${app.appointment_id}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Car Plate</label>
                            <div class="readonly-box">${app.car.carPlateNumber}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Service Type</label>
                            <div class="readonly-box">${app.service.serviceType}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="info-label">Service Date</label>
                            <div class="readonly-box">${app.appointment_date}</div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'technician'}">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Technician Feedback / Notes</label>
                                <textarea name="technicianNote" class="form-control" rows="5" maxlength="500" 
                                          placeholder="Enter technical details, parts replaced, or future recommendations..." required></textarea>
                                <div class="form-text">Max 500 characters. Describe the work done clearly.</div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Who are you commenting on?</label>
                                <select name="commentTarget" class="form-select">
                                    <option value="To TECHNICIAN ">Technician</option>
                                    <option value="To STAFF ">Counter Staff</option>
                                    <option value="To BOTH ">Both</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Your Comment</label>
                                <textarea name="customerComment" class="form-control" rows="4" maxlength="500"
                                          placeholder="How was our service? Your feedback helps us improve." required></textarea>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-bold">Overall Rating</label>
                                <select name="ranking" class="form-select border-primary">
                                    <option value="5">⭐⭐⭐⭐⭐ 5 - Excellent</option>
                                    <option value="4">⭐⭐⭐⭐ 4 - Good</option>
                                    <option value="3">⭐⭐⭐ 3 - Neutral</option>
                                    <option value="2">⭐⭐ 2 - Bad</option>
                                    <option value="1">⭐ 1 - Very Disappointed</option>
                                </select>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success flex-grow-1 py-2 fw-bold shadow-sm">
                            <i class="fas fa-paper-plane me-2"></i>Submit Feedback
                        </button>
                        <button type="button" onclick="window.history.back()" class="btn btn-light border px-4">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let formChanged = false;
            const feedbackForm = document.getElementById('feedbackForm');

            feedbackForm.addEventListener('input', () => {
                formChanged = true;
            });

            feedbackForm.addEventListener('submit', () => {
                formChanged = false;
            });

            window.addEventListener('beforeunload', (event) => {
                if (formChanged) {
                    event.preventDefault();
                    event.returnValue = 'You have unsaved changes. Are you sure you want to leave?';
                }
            });
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>