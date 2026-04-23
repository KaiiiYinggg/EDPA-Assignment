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
        </style>
    </head>
    <body>
        <div class="sidebar bg-manager">
            <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
            <a href="${pageContext.request.contextPath}/ManageStaff"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
            <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet" class="active"><i class="fas fa-clock me-2"></i> Business Hour</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="card-custom">
                <h2 class="fw-bold mb-4"><i class="fas fa-calendar-day me-2 text-primary"></i>Business Hour Control</h2>

                <c:choose>
                    <c:when test="${param.success == 'added'}">
                        <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-plus-circle me-2"></i> New setting added successfully! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                        </c:when>
                        <c:when test="${param.success == 'updated'}">
                        <div class="alert alert-info alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i> Settings updated! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                        </c:when>
                        <c:when test="${param.success == 'deleted'}">
                        <div class="alert alert-warning alert-dismissible fade show"><i class="fas fa-trash-alt me-2"></i> Setting removed. <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                        </c:when>
                    </c:choose>

                <form id="bhForm" action="BusinessHourServlet" method="post" class="row g-3">
                    <input type="hidden" name="action" id="formAction" value="save">

                    <div class="col-md-6">
                        <label class="form-label">Select Date</label>
                        <input type="date" name="date" id="datePicker" class="form-control" required onchange="onDateChange(this.value)">
                        <div id="statusInfo" class="mt-2 p-2 rounded small fw-bold"></div>
                        <div id="conflictAlert" class="mt-2 alert alert-danger d-none">
                            <i class="fas fa-exclamation-triangle me-2"></i> <strong>Conflict!</strong> This day has <span id="apptNum">0</span> bookings.
                            <br><small id="customerEmails"></small>
                        </div>
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
                            <tr><th>Date</th><th>Status</th><th>Hours</th><th>Note</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="bh" items="${allSettings}">
                                <tr>
                                    <td class="fw-bold">${bh.businessDate}</td>
                                    <td><span class="badge ${bh.isIsClosed() ? 'bg-danger' : 'bg-warning text-dark'}">${bh.isIsClosed() ? 'CLOSED' : 'CUSTOM'}</span></td>
                                    <td>${bh.isIsClosed() ? '---' : bh.openTime.toString().concat(' - ').concat(bh.closeTime)}</td>
                                    <td class="text-muted">${bh.note}</td>
                                    <td><button class="btn btn-sm btn-outline-primary" onclick="editSetting('${bh.businessDate}')"><i class="fas fa-edit"></i> Edit</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const todayStr = new Date().toISOString().split("T")[0];
                const datePicker = document.getElementById('datePicker');
                if (datePicker)
                    datePicker.min = todayStr;

                if (window.history.replaceState) {
                    const url = new URL(window.location.href);
                    url.searchParams.delete('success');
                    url.searchParams.delete('error');
                    window.history.replaceState({path: url.href}, '', url.href);
                }
            });

            function checkSubmitButtonStatus() {
                const datePicker = document.getElementById('datePicker');
                const submitBtn = document.querySelector('button[type="submit"]');
                const apptCount = parseInt(datePicker.dataset.apptCount || "0");

                if (apptCount > 0) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = "<i class='fas fa-ban me-2'></i> Cannot Modify (Bookings Exist)";
                    submitBtn.classList.remove('btn-primary');
                    submitBtn.classList.add('btn-secondary');
                } else {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = "<i class='fas fa-save me-2'></i> Save Changes";
                    submitBtn.classList.remove('btn-secondary');
                    submitBtn.classList.add('btn-primary');
                }
            }

            function toggleTimeInputs(isClosed) {
                document.getElementById('openInput').disabled = isClosed;
                document.getElementById('closeInput').disabled = isClosed;
                checkSubmitButtonStatus();
            }

            function onDateChange(date) {
                document.getElementById('formAction').value = "save";
                loadDateSettings(date);
            }

            function loadDateSettings(date) {
                if (!date)
                    return;
                fetch('BusinessHourServlet?date=' + date)
                        .then(r => r.json())
                        .then(data => {
                            const statusInfo = document.getElementById('statusInfo');
                            const conflictAlert = document.getElementById('conflictAlert');
                            const datePicker = document.getElementById('datePicker');

                            datePicker.dataset.apptCount = data.apptCount || 0;
                            if (data.apptCount > 0) {
                                conflictAlert.classList.remove('d-none');
                                document.getElementById('apptNum').innerText = data.apptCount;
                                document.getElementById('customerEmails').innerText = "Customers: " + data.customerList;
                            } else {
                                conflictAlert.classList.add('d-none');
                            }

                            if (data.type === 'normal') {
                                statusInfo.className = "mt-2 p-2 rounded small fw-bold bg-light text-success";
                                statusInfo.innerHTML = "Default Hours Available";
                                document.getElementById('noteInput').value = "";
                                document.getElementById('openInput').value = "10:00";
                                document.getElementById('closeInput').value = "18:00";
                                document.getElementById('isClosedCheck').checked = false;
                                document.getElementById('deleteBtn').style.display = "none";
                            } else {
                                statusInfo.className = "mt-2 p-2 rounded small fw-bold bg-light text-warning";
                                statusInfo.innerHTML = "Custom Setting Exists";
                                document.getElementById('noteInput').value = data.message || "";
                                document.getElementById('isClosedCheck').checked = (data.type === 'holiday');
                                if (data.type !== 'holiday') {
                                    document.getElementById('openInput').value = data.openTime;
                                    document.getElementById('closeInput').value = data.closeTime;
                                }
                                document.getElementById('deleteBtn').style.display = "inline-block";
                            }
                            toggleTimeInputs(document.getElementById('isClosedCheck').checked);
                            checkSubmitButtonStatus();
                        });
            }

            function editSetting(date) {
                const todayStr = new Date().toISOString().split("T")[0];
                if (date < todayStr) {
                    alert("Cannot modify past records.");
                    return;
                }
                document.getElementById('formAction').value = "update";
                document.getElementById('datePicker').value = date;
                loadDateSettings(date);
                window.scrollTo({top: 0, behavior: 'smooth'});
            }

            function deleteSetting() {
                if (confirm("Remove this setting?")) {
                    document.getElementById('formAction').value = "delete";
                    document.getElementById('bhForm').submit();
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>