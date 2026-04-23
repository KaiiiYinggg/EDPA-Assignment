<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>User Registration | Car Service Center</title>

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
            .bg-manager {
                background: #1a252f;
            }
            .bg-staff {
                background: #2c3e50;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }
            .register-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 900px;
                margin: auto;
            }
            .form-label {
                font-weight: 600;
                color: #495057;
                font-size: 0.9rem;
            }
            .section-title {
                border-left: 5px solid #1abc9c;
                padding-left: 15px;
                margin-bottom: 25px;
                color: #2c3e50;
            }
        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <div class="sidebar bg-manager">
                    <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="active"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                    <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> History</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:when>
            <c:when test="${sessionScope.user.role == 'counter staff'}">
                <div class="sidebar bg-staff">
                    <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet"><i class="fas fa-tachometer-alt me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="active"><i class="fas fa-user-plus me-2"></i> Registration</a>
                    <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:when>
        </c:choose>

        <div class="main-content">
            <div class="register-card">
                <h3 class="fw-bold section-title">User Registration</h3>
                <p class="text-muted mb-4">Create a new account for staff or customers.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 mb-4"><i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/></div>
                    </c:if>

                <form action="Register" method="post" enctype="multipart/form-data" onsubmit="return validateRegistration()">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" placeholder="e.g. John Doe" required minlength="3" maxlength="50">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="example@mail.com" required maxlength="100">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required minlength="4">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">IC Number (12 Digits)</label>
                            <input type="text" name="userIC" class="form-control" maxlength="12" minlength="12" pattern="[0-9]{12}" 
                                   inputmode="numeric" oninput="this.value = this.value.replace(/[^0-9]/g, '');" required placeholder="990101101234">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control" placeholder="0123456789" required 
                                   pattern="[0-9]{10,11}" title="Please enter 10-11 digits" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Gender</label>
                            <select name="gender" class="form-select">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Home Address</label>
                            <input type="text" name="address" class="form-control" placeholder="Full residential address" required maxlength="255">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-primary">Assign Role</label>
                            <select name="role" class="form-select border-primary">
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'manager'}">
                                        <option value="manager">Manager</option>
                                        <option value="counter staff">Counter Staff</option>
                                        <option value="technician" selected>Technician</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="customer" selected>Customer</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                            <small class="text-muted">Managers manage staff; Staff manage customers.</small>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Profile Photo (Optional)</label>
                            <input type="file" name="profilePic" class="form-control" accept="image/*">
                        </div>
                    </div>

                    <div class="mt-5 text-end">
                        <button type="reset" class="btn btn-light px-4 me-2">Clear Fields</button>
                        <button type="submit" class="btn btn-success px-5 py-2 fw-bold shadow-sm">
                            <i class="fas fa-user-check me-2"></i>Complete Registration
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <%
            String successMsg = (String) request.getAttribute("loginSuccessMessage");
            if (successMsg != null) {
                String safeMsg = successMsg.replace("\"", "\\\"");
        %>
        <script type="text/javascript">
            alert("<%= safeMsg%>");
        </script>
        <% }%>
        <script>
            function validateRegistration() {
                const ic = document.getElementsByName("userIC")[0].value;

                if (ic.length !== 12) {
                    alert("IC Number must be exactly 12 digits.");
                    return false;
                }

                // 获取 IC 前两位计算年龄
                const yearPart = parseInt(ic.substring(0, 2));
                const currentYear = new Date().getFullYear();
                const birthYear = (yearPart <= (currentYear % 100)) ? (2000 + yearPart) : (1900 + yearPart);

                const age = currentYear - birthYear;

                if (age < 17) {
                    alert("Validation Error: User must be at least 17 years old (Current age: " + age + ").");
                    return false;
                }

                return confirm('Confirm new account registration?');
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>