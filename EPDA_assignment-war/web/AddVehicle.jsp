<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="Entity.User"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Add New Vehicle | Car Service Center</title>

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
                padding: 40px;
            }

            /* 表单卡片样式 */
            .form-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 600px;
                margin: auto;
            }
            .form-label {
                font-weight: 600;
                color: #495057;
                font-size: 0.9rem;
            }
            .section-title {
                border-left: 5px solid #3b82f6;
                padding-left: 15px;
                margin-bottom: 25px;
                color: #2c3e50;
            }
            /* 车牌自动大写显示 */
            .plate-input {
                text-transform: uppercase;
                font-weight: bold;
                letter-spacing: 1px;
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
            User currentUser = (User) session.getAttribute("user");
            String userEmail = (String) session.getAttribute("email");

            if (currentUser == null) {
        %>
        <script>alert("Session expired. Please log in again."); window.location.href = "../login.jsp";</script>
        <%
            }

            String errorMsg = (String) request.getAttribute("errorMessage");
            if (errorMsg != null && !errorMsg.isEmpty()) {
                // 安全转义处理，防止 XSS
                String safeMsg = errorMsg.replace("\\", "\\\\").replace("\"", "\\\"");
        %>
        <script>showAlert("<%=safeMsg%>");</script>
        <%
            }
        %>

        <c:choose>
            <%-- MANAGER --%>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <div class="sidebar bg-manager">
                    <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageCustomers?action=list" class="active"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
                    <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>
            <%-- COUNTER STAFF --%>
            <c:when test="${sessionScope.user.role == 'counter staff'}">
                <div class="sidebar bg-staff">
                    <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet"><i class="fas fa-tachometer-alt me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/ManageCustomers?action=list" class="active"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
                    <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
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
                    <a href="${pageContext.request.contextPath}/EditProfile" class="active"><i class="fas fa-id-card me-2"></i> My Profile</a>
                    <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-file-alt me-2"></i> View History</a>
                    <a href="ViewFeedback"><i class="fas fa-star me-2"></i> Feedback</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <div class="form-card">
                <h3 class="fw-bold section-title">Add New Vehicle</h3>
                <p class="text-muted mb-4 small">Please provide the details of your vehicle to register it in our system.</p>

                <%
                    Object viewObj = request.getAttribute("viewOnly");
                    boolean viewOnly = (viewObj != null) ? (Boolean) viewObj : false;
                    Entity.Car car = (Entity.Car) request.getAttribute("car");
                %>

                <form action="AddVehicle" method="post" onsubmit="return confirm('Confirm vehicle registration?')">
                    <input type="hidden" name="customerId" value="${customerId}">

                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Car Plate Number</label>
                            <input type="text" name="carPlate" class="form-control plate-input" 
                                   value="<%= car != null ? car.getCarPlateNumber() : ""%>" 
                                   placeholder="e.g. ABC 1234" 
                                   pattern="[A-Z0-9 ]{3,15}" 
                                   title="3-15 characters, letters and numbers only"
                                   oninput="this.value = this.value.toUpperCase()"
                                   maxlength="15"
                                   required
                                   <%= viewOnly ? "readonly" : ""%>>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Brand</label>
                            <input type="text" name="brand" class="form-control" 
                                   value="<%= car != null ? car.getCarBrand() : ""%>" 
                                   placeholder="e.g. Toyota"
                                   maxlength="50"
                                   required
                                   <%= viewOnly ? "readonly" : ""%>>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Model</label>
                            <input type="text" name="model" class="form-control" 
                                   value="<%= car != null ? car.getCarModel() : ""%>" 
                                   placeholder="e.g. Vios"
                                   maxlength="50"
                                   required
                                   <%= viewOnly ? "readonly" : ""%>>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Color</label>
                            <input type="text" name="color" class="form-control" 
                                   value="<%= car != null ? car.getColor() : ""%>" 
                                   placeholder="e.g. Pearl White"
                                   maxlength="30"
                                   required
                                   <%= viewOnly ? "readonly" : ""%>>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Year of Manufacture</label>
                            <input type="number" name="year" class="form-control" 
                                   value="<%= car != null ? car.getYear() : ""%>" 
                                   min="1950" max="2026" 
                                   required
                                   <%= viewOnly ? "readonly" : ""%>>
                        </div>
                    </div>

                    <% if (!viewOnly) { %>
                    <div class="mt-5 d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1 py-2 fw-bold shadow-sm">
                            <i class="fas fa-plus-circle me-2"></i> Register Vehicle
                        </button>
                        <button type="button" onclick="window.location.href = 'EditProfile'" class="btn btn-light border px-4">
                            Cancel
                        </button>
                    </div>
                    <% } else { %>
                    <div class="mt-5 d-flex gap-2">
                        <button type="button" onclick="window.history.back()" class="btn btn-light border px-4">
                            Close
                        </button>
                    </div>
                    <% }%>
                </form>
            </div>

            <div class="text-center mt-4">
                <small class="text-muted">Logged in as (operator):<strong><%= currentUser != null ? currentUser.getUsername() : "Guest"%></strong></small>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>