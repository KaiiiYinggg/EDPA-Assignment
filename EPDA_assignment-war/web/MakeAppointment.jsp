<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Manage Appointments | Car Service Center</title>

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
            .bg-customer {
                background: #1e272e;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 2000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                backdrop-filter: blur(3px);
            }
            .modal-content {
                background: #fff;
                margin: 5% auto;
                padding: 30px;
                width: 500px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border: none;
            }
            .appt-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
            }
            .clickable-row {
                cursor: pointer;
                transition: 0.2s;
            }
            .clickable-row:hover {
                background-color: #f1f7ff;
            }
            .warning-badge {
                display: inline-block;
                width: 22px;
                height: 22px;
                background: #ff4d4d;
                color: white;
                text-align: center;
                line-height: 22px;
                border-radius: 50%;
                font-weight: bold;
                margin-right: 5px;
            }
            .time-display {
                background-color: #f8f9fa;
                font-weight: bold;
                border: 1px solid #dee2e6;
                padding: 8px;
                border-radius: 5px;
                display: block;
                width: 100%;
            }
            .add-btn {
                position: fixed;
                bottom: 40px;
                right: 40px;
                width: 60px;
                height: 60px;
                background: #1abc9c;
                color: white;
                border-radius: 50%;
                border: none;
                font-size: 30px;
                cursor: pointer;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                z-index: 999;
                transition: 0.3s;
            }
            .add-btn:hover {
                transform: scale(1.1);
                background: #16a085;
            }
        </style>
    </head>
    <body>

        <c:choose>
            <%-- MANAGER --%>
            <c:when test="${sessionScope.user.role == 'manager'}">
                <div class="sidebar bg-manager">
                    <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
                    <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
                    <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard" class="active"><i class="fas fa-chart-line me-2"></i> Home Page</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
                    <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
                    <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
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
                    <a href="${pageContext.request.contextPath}/Staff/ManageCustomers?action=list" class="active"><i class="fas fa-users me-2"></i> Manage Customers</a>
                    <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
                    <a href="${pageContext.request.contextPath}/Staff/PaymentServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
                    <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>
                    <div style="position: absolute; bottom: 20px; width: 100%;">
                        <a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
                    </div>
                </div>
            </c:when>
        </c:choose>

        <div class="main-content">
            <div class="appt-card">
                <h3 class="fw-bold mb-4" style="color: #2c3e50;">Manage Appointments: ${customer.username}</h3>

                <form action="AppointmentServlet" method="GET" class="row g-3 mb-4 align-items-end p-3 bg-light rounded shadow-sm">
                    <input type="hidden" name="customerEmail" value="${customer.email}">
                    <div class="col-md-4">
                        <label class="small fw-bold text-muted">Date</label>
                        <input type="date" name="searchDate" class="form-control" value="${param.searchDate}">
                    </div>
                    <div class="col-md-4">
                        <label class="small fw-bold text-muted">Appointment ID</label>
                        <input type="text" name="searchId" class="form-control" placeholder="ID" value="${param.searchId}">
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-dark w-100">Search</button>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover border">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th><th>Car Plate</th><th>Service Type</th><th>Date</th><th>Start Time</th><th>Status</th><th>Technician</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${appList}">
                                <%-- 传递 Status 到 JavaScript 函数 --%>
                                <tr class="clickable-row" onclick="openUpdateModal('${app.appointment_id}', '${app.car.carPlateNumber}', '${app.service.service_id}', '${app.appointment_date}', '${app.appointment_time}', '${app.technician_email}', '${app.appointment_status}')">
                                    <td class="fw-bold">
                                        <c:if test="${empty app.technician_email}">
                                            <span class="warning-badge" title="No Tech Assigned!">!</span>
                                        </c:if>
                                        #${app.appointment_id}
                                    </td>
                                    <td><span class="badge bg-secondary">${app.car.carPlateNumber}</span></td>
                                    <td>${app.service.serviceType}</td>
                                    <td>${app.appointment_date}</td>
                                    <td>${app.appointment_time}</td>
                                    <td><span class="badge bg-info">${app.appointment_status}</span></td>
                                    <td class="small text-muted">${app.technician_email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${empty appList}">
                    <p class="text-center text-muted mt-3">No appointments found.</p>
                </c:if>
            </div>
        </div>

        <button class="add-btn" onclick="openAddModal()">+</button>

        <div id="addModal" class="modal">
            <div class="modal-content">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-calendar-plus me-2"></i>New Appointment</h4>
                <form action="AppointmentServlet" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="customerEmail" value="${customer.email}">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Car Plate</label>
                        <select name="carPlateNumber" class="form-select" required>
                            <c:forEach var="car" items="${cars}">
                                <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Service Type</label>
                        <select name="serviceId" id="addService" class="form-select" required onchange="calculateEndTime('add')">
                            <option value="">-- Select --</option>
                            <c:forEach var="svc" items="${services}">
                                <option value="${svc.service_id}" data-hours="${svc.serviceHour}">${svc.serviceType} (${svc.serviceHour} hrs)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold">Date</label>
                            <input type="date" name="date" id="addDate" class="form-control" required onchange="calculateEndTime('add')">
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold">Start Time</label>
                            <input type="time" name="time" id="addTime" class="form-control" required onchange="calculateEndTime('add')">
                        </div>
                    </div>
                    <div class="mb-3 text-muted">
                        <label class="form-label small fw-bold">Expected End Time</label>
                        <input type="time" id="addEndTimeDisplay" class="time-display" readonly disabled>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-primary">Assign Technician</label>
                        <select name="technicianEmail" id="addTechSelect" class="form-select border-primary" required>
                            <option value="">-- Select Time First --</option>
                        </select>
                        <small id="addTechLoading" style="display:none;" class="text-primary"><i class="fas fa-spinner fa-spin"></i> Checking...</small>
                    </div>
                    <div class="d-flex gap-2 justify-content-end">
                        <button type="button" class="btn btn-light" onclick="closeModal('addModal')">Cancel</button>
                        <button type="submit" class="btn btn-success px-4">Confirm Booking</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="updateModal" class="modal">
            <div class="modal-content">
                <h4 class="fw-bold text-primary mb-3"><i class="fas fa-edit me-2"></i>Appointment Details</h4>

                <div id="statusNotice" class="alert alert-warning small py-2 mb-3" style="display:none;">
                    <i class="fas fa-lock me-2"></i> Completed/Paid appointments cannot be modified.
                </div>

                <form action="AppointmentServlet" method="POST" id="updateForm">
                    <input type="hidden" name="action" id="upAction" value="update">
                    <input type="hidden" name="appointmentId" id="upId">
                    <input type="hidden" name="customerEmail" value="${customer.email}">

                    <div id="formInputArea">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Car Plate</label>
                            <select name="carPlateNumber" id="upPlate" class="form-select">
                                <c:forEach var="car" items="${cars}">
                                    <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Service</label>
                            <select name="serviceId" id="upService" class="form-select" onchange="calculateEndTime('up')">
                                <c:forEach var="svc" items="${services}">
                                    <option value="${svc.service_id}" data-hours="${svc.serviceHour}">${svc.serviceType}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Date</label>
                                <input type="date" name="date" id="upDate" class="form-control" onchange="calculateEndTime('up')">
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Time</label>
                                <input type="time" name="time" id="upTime" class="form-control" onchange="calculateEndTime('up')">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">End Time</label>
                            <input type="time" id="upEndTimeDisplay" class="time-display" readonly disabled>
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-bold">Assign Technician</label>
                            <select name="technicianEmail" id="upTechSelect" class="form-select" required>
                                <option value="">-- Loading --</option>
                            </select>
                        </div>
                    </div>

                    <div id="buttonContainer" class="mt-4">
                        <div id="editModeButtons" style="display: none;" class="d-flex gap-2">
                            <button type="submit" onclick="document.getElementById('upAction').value = 'delete'; return confirm('Delete this record?')" class="btn btn-outline-danger">Delete</button>
                            <div class="ms-auto">
                                <button type="button" class="btn btn-light" onclick="closeModal('updateModal')">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4">Save Update</button>
                            </div>
                        </div>

                        <div id="readOnlyModeButtons" style="display: none; text-align: right;">
                            <button type="button" class="btn btn-secondary px-5" onclick="closeModal('updateModal')">Close</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
            }
            function closeModal(m) {
                document.getElementById(m).style.display = 'none';
            }

            function openUpdateModal(id, plate, svcId, date, time, currentTech, status) {
                // 1. 填入基本数据
                document.getElementById('upId').value = id;
                document.getElementById('upPlate').value = plate;
                document.getElementById('upService').value = svcId;
                document.getElementById('upDate').value = date;
                document.getElementById('upTime').value = time;
                window.currentAssignedTech = currentTech;

                // 2. 获取 UI 元素
                const editGroup = document.getElementById('editModeButtons');
                const readOnlyGroup = document.getElementById('readOnlyModeButtons');
                const notice = document.getElementById('statusNotice');
                const inputs = document.querySelectorAll('#formInputArea select, #formInputArea input');

                // 3. 💡 强化版判断逻辑 (增加 trim 和 toLowerCase 防止匹配失败)
                const currentStatus = status ? status.trim().toLowerCase() : "";

                if (currentStatus === 'paid' || currentStatus === 'completed' || currentStatus === 'successful') {
                    // --- 🔒 进入只读模式 ---
                    inputs.forEach(i => i.disabled = true);  // 禁用输入
                    editGroup.setAttribute("style", "display: none !important"); // 强制隐藏编辑按钮
                    readOnlyGroup.style.display = 'block';   // 只显示 Close
                    notice.style.display = 'block';          // 显示黄色警告
                } else {
                    // --- 🔓 进入编辑模式 ---
                    inputs.forEach(i => i.disabled = false); // 开启输入
                    editGroup.setAttribute("style", "display: flex !important"); // 强制显示编辑按钮
                    readOnlyGroup.style.display = 'none';    // 隐藏 Close
                    notice.style.display = 'none';           // 隐藏警告
                    calculateEndTime('up');                  // 运行原本的时间计算逻辑
                }

                // 4. 最后显示弹窗
                document.getElementById('updateModal').style.display = 'block';
            }

            function calculateEndTime(prefix) {
                const serviceSelect = document.getElementById(prefix + 'Service');
                const startTimeInput = document.getElementById(prefix + 'Time');
                const endTimeDisplay = document.getElementById(prefix + 'EndTimeDisplay');
                const dateInput = document.getElementById(prefix + 'Date');
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                if (!selectedOption || !startTimeInput.value || !dateInput.value)
                    return;

                const serviceHours = parseFloat(selectedOption.getAttribute('data-hours'));
                const [h, m] = startTimeInput.value.split(':').map(Number);
                let d = new Date();
                d.setHours(h);
                d.setMinutes(m + Math.round(serviceHours * 60));
                const endTimeStr = String(d.getHours()).padStart(2, '0') + ":" + String(d.getMinutes()).padStart(2, '0');
                endTimeDisplay.value = endTimeStr;
                fetchAvailableTechs(prefix, dateInput.value, startTimeInput.value, endTimeStr);
            }

            function fetchAvailableTechs(prefix, date, start, end) {
                const techSelect = document.getElementById(prefix + 'TechSelect');
                const loader = document.getElementById(prefix + 'TechLoading');
                if (loader)
                    loader.style.display = 'inline';
                fetch("AppointmentServlet?action=getAvailableTechs&date=" + encodeURIComponent(date) + "&startTime=" + encodeURIComponent(start) + "&endTime=" + encodeURIComponent(end))
                        .then(r => r.json())
                        .then(data => {
                            techSelect.innerHTML = '<option value="">-- Select Technician --</option>';
                            data.forEach(t => {
                                let opt = new Option(t.username, t.email);
                                if (prefix === 'up' && t.email === window.currentAssignedTech)
                                    opt.selected = true;
                                techSelect.add(opt);
                            });
                            if (loader)
                                loader.style.display = 'none';
                        });
            }
            document.getElementById('addDate').min = new Date().toISOString().split("T")[0];
            window.onclick = function (e) {
                if (e.target.className === 'modal')
                    e.target.style.display = "none";
            };
        </script>
    </body>
</html>