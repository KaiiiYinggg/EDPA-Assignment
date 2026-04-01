<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Manage Customers | Car Service Center</title>

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
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

            .bg-staff {
                background: #2c3e50;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            th {
                background-color: #f8f9fa;
                padding: 15px;
                text-align: left;
                color: #2c3e50;
                border-bottom: 2px solid #eee;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                color: #444;
                vertical-align: middle;
            }
            .clickable-row:hover {
                background-color: #f8fbff;
                cursor: pointer;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 2000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: #fefefe;
                margin: 10% auto;
                padding: 25px;
                border-radius: 15px;
                width: 450px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.2);
                border: none;
            }
            .search-box {
                padding: 12px;
                width: 350px;
                border: 1px solid #ddd;
                border-radius: 8px;
                outline: none;
            }
            .checkbox-cell {
                width: 40px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="sidebar bg-staff">
            <div class="text-center mb-4"><i class="fas fa-car-side fa-3x mb-2 text-info"></i><h5 class="fw-bold">STAFF PORTAL</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Dashboard"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/Staff/ManageCustomers?action=list" class="active"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
            <a href="${pageContext.request.contextPath}/Staff/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <<div class="main-content">
            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4">
                    <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("errorMsg"); %> 
            </c:if>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("successMsg");%>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold" style="color: #2c3e50;">Customer Management</h2>
                <div class="text-muted">Total Records: <span class="badge bg-primary rounded-pill">${userList.size()}</span></div>
            </div>
            <hr>

            <form action="ManageCustomers" method="GET" class="mb-4">
                <input type="hidden" name="action" value="list">
                <div class="d-flex gap-2">
                    <input type="text" name="searchQuery" class="search-box" placeholder="Search by name, email or phone..." value="${param.searchQuery}">
                    <button type="submit" class="btn btn-primary px-4 shadow-sm"><i class="fas fa-search me-2"></i>Search</button>
                </div>
            </form>

            <form action="ManageCustomers" method="POST" id="deleteForm" onsubmit="return validateDelete()">
                <input type="hidden" name="action" value="deleteMultiple">
                <table>
                    <thead>
                        <tr>
                            <th class="checkbox-cell"><input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"></th>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Gender</th>
                            <th>Phone</th>
                            <th>Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr class="clickable-row" onclick="openUpdateModal('${u.user_id}', '${u.username}', '${u.phoneNumber}', '${u.email}')">
                                <td class="checkbox-cell" onclick="event.stopPropagation();">
                                    <input type="checkbox" name="selectedIds" value="${u.user_id}">
                                </td>
                                <td class="fw-bold text-info"># ${u.user_id}</td>
                                <td>${u.username}</td>
                                <td>${u.gender}</td>
                                <td>${u.phoneNumber}</td>
                                <td>${u.email}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <button type="submit" class="btn btn-danger mt-4 px-4 shadow-sm">
                    <i class="fas fa-trash-alt me-2"></i>Delete Selected
                </button>
            </form>
        </div>

        <div id="myModal" class="modal">
            <div class="modal-content">
                <h4 class="fw-bold mb-3" style="color: #2c3e50; border-bottom: 2px solid #eee; padding-bottom: 10px;">Update Customer</h4>
                <form action="ManageCustomers" method="POST" onsubmit="return validateUpdateForm()">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="user_id" id="updateId">

                    <div class="mb-3">
                        <label class="small fw-bold text-muted">Username</label>
                        <input type="text" name="username" id="updateUsername" class="form-control" required minlength="2">
                    </div>

                    <div class="mb-3">
                        <label class="small fw-bold text-muted">Phone Number</label>
                        <input type="text" name="phoneNumber" id="updatePhone" class="form-control" 
                               required pattern="[0-9]{10,11}" title="Phone number must be 10-11 digits"
                               oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                    </div>

                    <div class="mb-3">
                        <label class="small fw-bold text-muted">Email Address</label>
                        <input type="email" name="email" id="updateEmail" class="form-control" required>
                    </div>

                    <div class="d-flex gap-2 mt-4">
                        <button type="button" onclick="closeModal()" class="btn btn-light border flex-grow-1">Cancel</button>
                        <button type="submit" class="btn btn-success flex-grow-1">Update</button>
                        <button type="button" onclick="goToBooking()" class="btn btn-primary" style="flex: 1.5;">Book Service</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // 1. Modal 基础控制
            function openUpdateModal(id, name, phone, email) {
                document.getElementById('updateId').value = id;
                document.getElementById('updateUsername').value = name;
                document.getElementById('updatePhone').value = phone;
                document.getElementById('updateEmail').value = email;
                document.getElementById('myModal').style.display = "block";
            }

            function closeModal() {
                document.getElementById('myModal').style.display = "none";
            }

            window.onclick = function (e) {
                if (e.target == document.getElementById('myModal'))
                    closeModal();
            }

            // 2. 批量选择 Checkbox
            function toggleSelectAll(source) {
                const checkboxes = document.getElementsByName('selectedIds');
                for (let i = 0; i < checkboxes.length; i++) {
                    checkboxes[i].checked = source.checked;
                }
            }

            // 3. 删除前的 Input Checking
            function validateDelete() {
                const checkedCount = document.querySelectorAll('input[name="selectedIds"]:checked').length;
                if (checkedCount === 0) {
                    alert("Please select at least one customer to delete.");
                    return false;
                }
                return confirm("Are you sure you want to delete " + checkedCount + " selected customer(s)?");
            }

            // 4. 更新表单的简单验证
            function validateUpdateForm() {
                const phone = document.getElementById('updatePhone').value;
                if (phone.length < 10) {
                    alert("Phone number is too short!");
                    return false;
                }
                return true;
            }

            // 5. 跳转到 Appointment 的安全逻辑
            function goToBooking() {
                const email = document.getElementById('updateEmail').value;
                if (!email) {
                    alert("Error: No customer email found.");
                    return;
                }
                // 使用动态的 ContextPath
                window.location.href = '${pageContext.request.contextPath}/AppointmentServlet?customerEmail=' + encodeURIComponent(email);
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>