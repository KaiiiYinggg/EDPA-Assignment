<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Edit Profile | Car Service Center</title>

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

            .profile-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 800px;
                margin: auto;
            }
            .profile-img-preview {
                width: 140px;
                height: 140px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #f8f9fa;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .form-label {
                font-weight: 600;
                color: #495057;
                font-size: 0.9rem;
            }
        </style>

        <script>
            function showAlert(msg) {
                if (msg && msg.trim() !== "") {
                    alert(msg);
                }
            }
        </script>
    </head>
    <body>
        <%
            String errorMsg = (String) request.getAttribute("errorMessage");
            if (errorMsg != null && !errorMsg.isEmpty()) {
                String safeMsg = errorMsg.replace("\\", "\\\\").replace("\"", "\\\"");
        %>
        <script>showAlert("<%=safeMsg%>");</script>
        <% }%>

        <c:choose>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <div class="sidebar bg-manager">
                    <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                    <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
                    <a href="${pageContext.request.contextPath}/EditProfile" class="active"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${sessionScope.user.role == 'counter staff'}">
                <div class="sidebar bg-staff">
                    <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet"><i class="fas fa-tachometer-alt me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
                    <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile" class="active"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${sessionScope.user.role == 'technician'}">
                <div class="sidebar bg-tech">
                    <div class="text-center mb-4"><i class="fas fa-tools fa-3x mb-2 text-secondary"></i><h5 class="fw-bold">TECHNICIAN</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Technician/TechnicianServlet"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> Task History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comment-dots me-2"></i> View Comments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile" class="active"><i class="fas fa-user-cog me-2"></i> My Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="sidebar bg-customer">
                    <div class="text-center mb-4"><i class="fas fa-user-circle fa-3x mb-2 text-success"></i><h5 class="fw-bold">CUSTOMER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Customer/customerDashboard.jsp"><i class="fas fa-home me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/EditProfile" class="active"><i class="fas fa-id-card me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <div class="profile-card">
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/profile_pics/${empty sessionScope.user.profilePic ? 'default.png' : sessionScope.user.profilePic}" 
                         class="profile-img-preview mb-3">
                    <h3 class="fw-bold">Account Settings</h3>
                    <p class="text-muted small">Update your personal information below</p>
                    <c:if test="${not empty message}"><div class="alert alert-success py-2">${message}</div></c:if>
                    </div>

                    <form action="${pageContext.request.contextPath}/EditProfile" method="post" enctype="multipart/form-data" onsubmit="return confirm('Update your profile details?')">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Profile Photo</label>
                            <input type="file" name="profileImage" class="form-control" accept="image/*">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" 
                                   value="${sessionScope.user.username}" 
                                   required 
                                   maxlength="50"
                                   pattern="[A-Za-z ]{3,50}" 
                                   title="Username can only contain letters and spaces (3-50 chars)">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="form-control bg-light" value="${sessionScope.user.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control" 
                                   value="${sessionScope.user.phoneNumber}" 
                                   required
                                   maxlength="15"
                                   pattern="\d{6,15}" 
                                   title="Phone number must be 6-15 digits">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Gender</label>
                            <input type="text" class="form-control bg-light" value="${sessionScope.user.gender}" disabled>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Update Password</label>
                            <input type="password" name="password" class="form-control" 
                                   placeholder="Leave blank to keep current password" 
                                   minlength="4"
                                   title="Password must be at least 4 characters if you want to change it">
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Update Profile</button>
                    </div>
                </form>

                <c:if test="${sessionScope.user.role == 'customer' || not empty carList}">
                    <hr class="my-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="fas fa-car me-2 text-primary"></i>My Registered Vehicles</h5>
                        <a href="${pageContext.request.contextPath}/AddVehicle.jsp" class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-plus me-1"></i>Add New
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${empty carList}">
                            <div class="alert alert-light border small text-center">No vehicles registered yet.</div>
                        </c:when>
                        <c:otherwise>
                            <table class="table table-sm border align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Plate Number</th>
                                        <th class="text-center" style="width: 100px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="car" items="${carList}">
                                        <tr>
                                            <td class="fw-bold">
                                                ${car.carPlateNumber}
                                                <br>
                                                <button class="btn btn-sm btn-link p-0 text-decoration-none small text-muted" 
                                                        data-bs-toggle="collapse" 
                                                        data-bs-target="#carInfo${car.carPlateNumber.replaceAll('[^a-zA-Z0-9]', '')}">
                                                    View Details
                                                </button>
                                                <div class="collapse mt-1" id="carInfo${car.carPlateNumber.replaceAll('[^a-zA-Z0-9]', '')}">
                                                    <div class="card card-body p-2 bg-light border-0 small">
                                                        <strong>Brand:</strong> ${car.carBrand}<br>
                                                        <strong>Model:</strong> ${car.carModel}<br>
                                                        <strong>Color:</strong> ${car.color}<br>
                                                        <strong>Year:</strong> ${car.year}
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/DeleteVehicle?plate=${car.carPlateNumber}" 
                                                   class="btn btn-sm text-danger"
                                                   onclick="return confirm('Remove vehicle ${car.carPlateNumber}?')">
                                                    <i class="fas fa-trash-alt"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>