<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Business Hour Control | APU Automotive</title>
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
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }
            .card-custom {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                margin-bottom: 30px;
            }
            .form-label {
                font-weight: bold;
                color: #2c3e50;
            }
            .table thead th {
                background-color: #f8f9fa;
                text-transform: uppercase;
                font-size: 0.85rem;
                color: #6c757d;
            }
        </style>
    </head>
    <body>
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
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet" class="active"><i class="fas fa-clock me-2"></i> Business Hour</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="card-custom">
                <h2 class="fw-bold mb-4" style="color: #2c3e50;"><i class="fas fa-calendar-day me-2 text-primary"></i>Business Hour Control</h2>

                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i> Operation successful!
                    </div>
                </c:if>

                <form id="bhForm" action="BusinessHourServlet" method="post" class="row g-3">
                    <input type="hidden" name="action" id="formAction" value="save">

                    <div class="col-md-6">
                        <label class="form-label">Select Date</label>
                        <input type="date" name="date" id="datePicker" class="form-control" required onchange="loadDateSettings(this.value)">
                        <div id="statusInfo" class="mt-2 small fw-bold text-primary"></div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Note / Holiday Name</label>
                        <input type="text" name="note" id="noteInput" class="form-control" placeholder="e.g. Hari Raya, Short Shift">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Open Time</label>
                        <input type="time" name="openTime" id="openInput" class="form-control" value="10:00">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Close Time</label>
                        <input type="time" name="closeTime" id="closeInput" class="form-control" value="18:00">
                    </div>

                    <div class="col-md-4 d-flex align-items-center pt-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isClosed" id="isClosedCheck" onchange="toggleTimeInputs(this.checked)">
                            <label class="form-check-label fw-bold text-danger">Mark as CLOSED</label>
                        </div>
                    </div>

                    <div class="col-12 mt-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-5"><i class="fas fa-save me-2"></i>Save Changes</button>
                        <button type="button" onclick="deleteSetting()" id="deleteBtn" class="btn btn-outline-danger px-4" style="display: none;"><i class="fas fa-trash me-2"></i>Remove Setting</button>
                    </div>
                </form>
            </div>

            <div class="card-custom">
                <h4 class="fw-bold mb-4"><i class="fas fa-list me-2 text-info"></i>Current Special Settings</h4>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Hours</th>
                                <th>Note</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="bh" items="${allSettings}">
                                <tr>
                                    <td class="fw-bold">${bh.businessDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bh.isIsClosed()}">
                                                <span class="badge bg-danger">CLOSED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">CUSTOM</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bh.isIsClosed()}">---</c:when>
                                            <c:otherwise>${bh.openTime} - ${bh.closeTime}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted">${bh.note}</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" onclick="editSetting('${bh.businessDate}')">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allSettings}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">No special settings found. All dates using default 10:00-18:00.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            // 页面加载时的初始化
            document.addEventListener("DOMContentLoaded", function () {
                const todayStr = new Date().toISOString().split("T")[0];
                const datePicker = document.getElementById('datePicker');

                // ✨ 设置日历：只能选今天及以后的日期
                if (datePicker) {
                    datePicker.min = todayStr;
                }

                // 处理错误弹窗
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('error') === 'pastDate') {
                    alert("❌ Operation Failed: You cannot modify business hours for past dates.");
                }
            });

            // 切换时间输入框状态
            function toggleTimeInputs(isClosed) {
                document.getElementById('openInput').disabled = isClosed;
                document.getElementById('closeInput').disabled = isClosed;
            }

            // 自动加载已存设置
            function loadDateSettings(date) {
                if (!date)
                    return;

                fetch('BusinessHourServlet?date=' + date)
                        .then(r => r.json())
                        .then(data => {
                            const statusInfo = document.getElementById('statusInfo');
                            const deleteBtn = document.getElementById('deleteBtn');

                            if (data.type === 'normal') {
                                statusInfo.innerText = "✨ Currently using DEFAULT (10am-6pm)";
                                document.getElementById('noteInput').value = "";
                                document.getElementById('openInput').value = "10:00";
                                document.getElementById('closeInput').value = "18:00";
                                document.getElementById('isClosedCheck').checked = false;
                                deleteBtn.style.display = "none";
                            } else {
                                statusInfo.innerText = "📌 Current Status: CUSTOM SETTING";
                                document.getElementById('noteInput').value = data.message || "";
                                document.getElementById('isClosedCheck').checked = (data.type === 'holiday');
                                if (data.type !== 'holiday') {
                                    document.getElementById('openInput').value = data.openTime;
                                    document.getElementById('closeInput').value = data.closeTime;
                                }
                                deleteBtn.style.display = "inline-block";
                            }
                            toggleTimeInputs(document.getElementById('isClosedCheck').checked);
                        });
            }

            // ✨ 修改 Edit 函数：增加过去日期拦截
            function editSetting(date) {
                const todayStr = new Date().toISOString().split("T")[0];

                // 如果点击的是过去的日期，弹出警告并拦截
                if (date < todayStr) {
                    alert("⚠️ Archived Record: Business hours for past dates cannot be modified.");
                    return;
                }

                document.getElementById('datePicker').value = date;
                loadDateSettings(date);
                window.scrollTo({top: 0, behavior: 'smooth'});
            }

            function deleteSetting() {
                if (confirm("Are you sure you want to remove this setting? The date will revert to default hours.")) {
                    document.getElementById('formAction').value = "delete";
                    document.getElementById('bhForm').submit();
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>