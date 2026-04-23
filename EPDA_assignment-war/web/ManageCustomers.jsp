<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Manage Customers | Car Service Center</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --sidebar-width: 260px;
            }
            body {
                background: #f4f7f6;
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                padding: 0;
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
            .bg-staff {
                background: #2c3e50;
            }
            .bg-manager {
                background: #1a252f;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }
            table {
                width: 100%;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            th {
                background: #f8f9fa;
                padding: 15px;
                color: #2c3e50;
                border-bottom: 2px solid #eee;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
            }
            .clickable-row:hover {
                background: #f8fbff;
                cursor: pointer;
            }
            .search-box {
                padding: 10px 15px;
                width: 350px;
                border: 1px solid #ddd;
                border-radius: 8px;
            }
            .checkbox-cell {
                width: 40px;
                text-align: center;
            }
            .modal-content {
                border-radius: 15px;
                border: none;
                box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            }
        </style>
    </head>

    <body>

        <div class="sidebar bg-staff">
            <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
            <hr style="border-color:rgba(255,255,255,0.1);margin:0 15px;">
            <a href="${pageContext.request.contextPath}/Staff/StaffDashboardServlet"><i class="fas fa-tachometer-alt me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/ManageCustomers?action=list" class="active"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
            <a href="${pageContext.request.contextPath}/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
            <div style="position:absolute;bottom:20px;width:100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <h2 class="fw-bold" style="color:#2c3e50;">Customer Management</h2>
            <hr>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMsg" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMsg" scope="session" />
            </c:if>

            <form action="ManageCustomers" method="GET" class="mb-4">
                <input type="hidden" name="action" value="list">
                <div class="d-flex gap-2">
                    <input type="text" name="searchQuery" class="search-box" placeholder="Search name, email or phone..." value="${param.searchQuery}">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search me-1"></i> Search</button>
                    <a href="ManageCustomers?action=list" class="btn btn-light border"><i class="fas fa-sync"></i></a>
                </div>
            </form>

            <form action="ManageCustomers" method="POST" id="deleteForm" onsubmit="return validateDelete()">
                <input type="hidden" name="action" value="deleteMultiple">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th class="checkbox-cell"><input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"></th>
                            <th>ID</th><th>Username</th><th>Gender</th><th>Phone</th><th>Email</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr class="clickable-row" onclick="openUpdateModal('${u.user_id}', '${u.username}', '${u.phoneNumber}', '${u.email}')">
                                <td onclick="event.stopPropagation();" class="text-center">
                                    <input type="checkbox" name="selectedIds" value="${u.user_id}">
                                </td>
                                <td class="fw-bold text-info">#${u.user_id}</td>
                                <td>${u.username}</td>
                                <td>${u.gender}</td>
                                <td>${u.phoneNumber}</td>
                                <td>${u.email}</td>
                                <td onclick="event.stopPropagation();">
                                    <div class="d-flex gap-1">
                                        <a class="btn btn-sm btn-success" title="Add Vehicle" href="${pageContext.request.contextPath}/AddVehicle?customerId=${u.user_id}">
                                            <i class="fas fa-plus"></i>
                                        </a>
                                        <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#vehicleDetails-${u.user_id}">
                                            Vehicles <i class="fas fa-chevron-down"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <tr class="collapse" id="vehicleDetails-${u.user_id}">
                                <td colspan="7" class="bg-light p-0">
                                    <div class="p-3 border-start border-4 border-primary">
                                        <h6 class="fw-bold text-primary mb-2"><i class="fas fa-car me-2"></i>Registered Vehicles</h6>
                                        <table class="table table-sm table-bordered bg-white mb-0 shadow-sm">
                                            <thead class="table-dark small">
                                                <tr>
                                                    <th>Plate</th><th>Brand</th><th>Model</th><th>Color</th><th>Year</th><th class="text-center">Del</th>
                                                </tr>
                                            </thead>
                                            <tbody class="small">
                                                <c:choose>
                                                    <c:when test="${not empty u.carList}">
                                                        <c:forEach var="car" items="${u.carList}">
                                                            <tr>
                                                                <td class="fw-bold">${car.carPlateNumber}</td>
                                                                <td>${car.carBrand}</td><td>${car.carModel}</td><td>${car.color}</td><td>${car.year}</td>
                                                                <td class="text-center">
                                                                    <a href="${pageContext.request.contextPath}/DeleteVehicle?plate=${car.carPlateNumber}" 
                                                                       class="text-danger" onclick="return confirm('Delete vehicle ${car.carPlateNumber}?')">
                                                                        <i class="fas fa-times"></i>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr><td colspan="6" class="text-center text-muted py-3">No vehicles registered.</td></tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="mt-4">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-trash me-1"></i> Delete Selected</button>
                </div>
            </form>
        </div>

        <div class="modal fade" id="updateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Update Customer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="ManageCustomers" method="POST" onsubmit="return validateUpdateForm()">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="user_id" id="updateId">

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Username</label>
                                <input type="text" name="username" id="updateUsername" class="form-control" required minlength="2" maxlength="50">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Phone Number</label>
                                <input type="text" name="phoneNumber" id="updatePhone" class="form-control" 
                                       required pattern="[0-9]{10,11}" title="Phone number must be 10-11 digits"
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                                <small class="text-muted">Example: 0123456789</small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Email Address</label>
                                <input type="email" name="email" id="updateEmail" class="form-control bg-light" readonly>
                            </div>

                            <div class="d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-success flex-grow-1">Save Changes</button>
                                <button type="button" onclick="goToBooking()" class="btn btn-primary" style="flex: 1.5;">Book New Appointment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleSelectAll(source) {
                const checkboxes = document.getElementsByName('selectedIds');
                checkboxes.forEach(cb => cb.checked = source.checked);
            }

            function validateDelete() {
                const checkedCount = document.querySelectorAll('input[name="selectedIds"]:checked').length;
                if (checkedCount === 0) {
                    alert("Please select at least one customer to delete.");
                    return false;
                }
                return confirm("Are you sure you want to delete " + checkedCount + " selected customer(s)?");
            }

            function openUpdateModal(id, name, phone, email) {
                document.getElementById('updateId').value = id;
                document.getElementById('updateUsername').value = name;
                document.getElementById('updatePhone').value = phone;
                document.getElementById('updateEmail').value = email;

                const modalEl = document.getElementById('updateModal');
                const modal = new bootstrap.Modal(modalEl);
                modal.show();
            }

            function validateUpdateForm() {
                const phone = document.getElementById('updatePhone').value;
                if (phone.length < 10 || phone.length > 11) {
                    alert("Phone number must be 10 or 11 digits!");
                    return false;
                }
                return true;
            }

            function goToBooking() {
                const email = document.getElementById('updateEmail').value;
                if (email) {
                    window.location.href = '${pageContext.request.contextPath}/AppointmentServlet?customerEmail=' + encodeURIComponent(email);
                }
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>