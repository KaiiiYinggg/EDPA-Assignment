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

            .status-badge {
                font-size: 0.8rem;
                padding: 5px 10px;
                border-radius: 20px;
            }
            .status-pending {
                background: #e3f2fd;
                color: #1976d2;
            }
            .status-completed {
                background: #e8f5e9;
                color: #2e7d32;
            }
            .status-paid {
                background: #fff3e0;
                color: #ef6c00;
            }
            .status-badge {
                min-width: 90px;
                display: inline-block;
                text-align: center;
            }
        </style>
    </head>
    <body>

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

        <div class="main-content">
            <div class="appt-card">
                <h3 class="fw-bold mb-4" style="color: #2c3e50;">Manage Appointments: ${customer.username}</h3>

                <form action="AppointmentServlet" method="GET" class="row g-3 mb-4 align-items-end p-3 bg-light rounded shadow-sm border">
                    <input type="hidden" name="customerEmail" value="${customer.email}">

                    <div class="col-md-3">
                        <label class="small fw-bold text-muted mb-2">
                            <i class="fas fa-calendar-alt me-1"></i> Filter Date
                        </label>
                        <input type="date" name="searchDate" class="form-control shadow-sm" value="${param.searchDate}">
                    </div>

                    <div class="col-md-3">
                        <label class="small fw-bold text-muted mb-2">
                            <i class="fas fa-hashtag me-1"></i> Search ID
                        </label>
                        <input type="text" name="searchId" class="form-control shadow-sm" placeholder="Appointment ID" value="${param.searchId}" maxlength="15">
                    </div>

                    <div class="col-md-6">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-dark px-4 shadow-sm flex-grow-1">
                                <i class="fas fa-search me-2"></i>Apply Search
                            </button>
                            <a href="AppointmentServlet?customerEmail=${customer.email}" class="btn btn-outline-secondary px-4 shadow-sm">
                                <i class="fas fa-sync-alt me-2"></i>Reset
                            </a>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover border align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th><th>Car Plate</th><th>Service Type</th><th>Date</th><th>Start Time</th><th>Status</th><th>Technician</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${appList}">
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
                                    <td>
                                        <c:set var="statusClass" value="status-pending" />
                                        <c:if test="${app.appointment_status == 'Completed'}"><c:set var="statusClass" value="status-completed" /></c:if>
                                        <c:if test="${app.appointment_status == 'Paid'}"><c:set var="statusClass" value="status-paid" /></c:if>
                                        <span class="status-badge ${statusClass}">${app.appointment_status}</span>
                                    </td>
                                    <td class="small text-muted">${empty app.technician_email ? 'Not Assigned' : app.technician_email}</td>
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

        <button class="add-btn" onclick="openAddModal()" title="New Appointment">+</button>

        <div id="addModal" class="modal">
            <div class="modal-content">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-calendar-plus me-2"></i>New Appointment</h4>
                <div class="alert alert-info py-2 shadow-sm mb-4" style="max-height: 150px; overflow-y: auto;">
                    <h6 class="fw-bold mb-1"><i class="fas fa-bullhorn me-1"></i> Business Hour Notices:</h6>
                    <ul class="list-unstyled mb-0 small">
                        <c:forEach var="bh" items="${specialHours}">
                            <li class="mb-1 border-bottom pb-1">
                                <span class="badge ${bh.isIsClosed() ? 'bg-danger' : 'bg-warning text-dark'} me-1">
                                    ${bh.businessDate}
                                </span>
                                <c:choose>
                                    <c:when test="${bh.isIsClosed()}">
                                        <b>CLOSED</b> - ${bh.note}
                                    </c:when>
                                    <c:otherwise>
                                        <b>Open: ${bh.openTime} - ${bh.closeTime}</b>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                        <c:if test="${empty specialHours}">
                            <li class="text-muted">No special changes for the next 30 days.</li>
                            </c:if>
                    </ul>
                </div>
                <form action="AppointmentServlet" method="POST" onsubmit="return validateForm('add')">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="customerEmail" value="${customer.email}">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Select Car</label>
                        <select name="carPlateNumber" class="form-select" required>
                            <option value="">-- Choose registered car --</option>
                            <c:forEach var="car" items="${cars}">
                                <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Service Type</label>
                        <select name="serviceId" id="addService" class="form-select" required onchange="calculateEndTime('add')">
                            <option value="">-- Select Service --</option>
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
                            <input type="time" name="time" id="addTime" class="form-control" min="10:00" max="18:00" required onchange="calculateEndTime('add')">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Expected End Time</label>
                        <input type="time" id="addEndTimeDisplay" class="time-display" readonly disabled>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-primary">Assign Technician</label>
                        <select name="technicianEmail" id="addTechSelect" class="form-select border-primary" required>
                            <option value="">-- Select date/time first --</option>
                        </select>
                        <small id="addTechLoading" style="display:none;" class="text-primary"><i class="fas fa-spinner fa-spin"></i> Checking availability...</small>
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
                    <i class="fas fa-lock me-2"></i> <b>LOCKED:</b> Completed/Paid records cannot be changed.
                </div>
                <form action="AppointmentServlet" method="POST" id="updateForm" onsubmit="return validateForm('up')">
                    <input type="hidden" name="action" id="upAction" value="update">
                    <input type="hidden" name="appointmentId" id="upId">
                    <input type="hidden" name="customerEmail" value="${customer.email}">

                    <div id="formInputArea">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Car Plate</label>
                            <select name="carPlateNumber" id="upPlate" class="form-select" required>
                                <c:forEach var="car" items="${cars}">
                                    <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Service</label>
                            <select name="serviceId" id="upService" class="form-select" required onchange="calculateEndTime('up')">
                                <c:forEach var="svc" items="${services}">
                                    <option value="${svc.service_id}" data-hours="${svc.serviceHour}">${svc.serviceType}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Date</label>
                                <input type="date" name="date" id="upDate" class="form-control" required onchange="calculateEndTime('up')">
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Time</label>
                                <input type="time" name="time" id="upTime" class="form-control" min="10:00" max="18:00" required onchange="calculateEndTime('up')">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Expected End Time</label>
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
                            <button type="submit"
                                    formnovalidate
                                    onclick="document.getElementById('upAction').value = 'delete'; return confirm('DANGER: Delete this appointment permanently?')"
                                    class="btn btn-outline-danger">
                                Delete
                            </button>
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
            document.addEventListener("DOMContentLoaded", function () {
                const urlParams = new URLSearchParams(window.location.search);
                const error = urlParams.get('error');
                const custEmail = urlParams.get('customerEmail');

                // show error alerts if registration fails
                if (error) {
                    let msg = "";
                    if (error === "holiday") {
                        msg = "❌ REGISTRATION FAILED!\n\nReason: The shop is CLOSED on the selected date. Please check the 'Business Hour Notices' box above the form.";
                    } else if (error === "outOfRange") {
                        msg = "❌ REGISTRATION FAILED!\n\nReason: The selected time is outside the business hours for that day. Please check the special opening/closing times.";
                    }

                    if (msg) {
                        alert(msg)
                        // clean up url after showing alert
                        const cleanUrl = window.location.pathname + "?customerEmail=" + encodeURIComponent(custEmail);
                        window.history.replaceState({}, document.title, cleanUrl);
                    }
                }

                // set min and max booking range (today to +5 days)
                const today = new Date();
                const maxDate = new Date();
                maxDate.setDate(today.getDate() + 5);

                const minStr = today.toISOString().split("T")[0];
                const maxStr = maxDate.toISOString().split("T")[0];

                const addDateInput = document.getElementById('addDate');
                const upDateInput = document.getElementById('upDate');

                if (addDateInput) {
                    addDateInput.min = minStr;
                    addDateInput.max = maxStr;
                }
                if (upDateInput) {
                    upDateInput.min = minStr;
                    upDateInput.max = maxStr;
                }
            });

            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
            }

            function closeModal(m) {
                document.getElementById(m).style.display = 'none';
            }

            async function checkBusinessHour(prefix, selectedDate) {
                const timeInput = document.getElementById(prefix + 'Time');
                const endTimeDisplay = document.getElementById(prefix + 'EndTimeDisplay');
                const techSelect = document.getElementById(prefix + 'TechSelect');

                try {
                    // get business hours for picked date
                    const response = await fetch("BusinessHourServlet?date=" + encodeURIComponent(selectedDate));
                    const data = await response.json();

                    if (data.type === "holiday") {
                        alert("Sorry, we are CLOSED on " + selectedDate + ". \nReason: " + (data.message || "Public Holiday"));
                        timeInput.value = "";
                        timeInput.disabled = true;
                        endTimeDisplay.value = "CLOSED";
                        techSelect.innerHTML = '<option value="">-- Shop Closed --</option>';
                        return null;
                    } else {
                        timeInput.disabled = false;
                        timeInput.min = data.openTime;
                        timeInput.max = data.closeTime;
                        return data;
                    }
                } catch (err) {
                    console.error("Error fetching business hours:", err);
                    timeInput.disabled = false;
                    timeInput.min = "10:00";
                    timeInput.max = "18:00";
                    return {openTime: "10:00", closeTime: "18:00"};
                }
            }

            async function calculateEndTime(prefix) {
                const dateInput = document.getElementById(prefix + 'Date');
                const startTimeInput = document.getElementById(prefix + 'Time');
                const endTimeDisplay = document.getElementById(prefix + 'EndTimeDisplay');
                const serviceSelect = document.getElementById(prefix + 'Service');

                if (!dateInput.value)
                    return;

                const businessConfig = await checkBusinessHour(prefix, dateInput.value);

                if (!businessConfig || !startTimeInput.value || !serviceSelect.value)
                    return;

                // check if start time is within operating hours
                const selectedStartTime = startTimeInput.value;
                if (selectedStartTime < businessConfig.openTime || selectedStartTime > businessConfig.closeTime) {
                    alert("Invalid Time! Business hours for this day are " + businessConfig.openTime + " to " + businessConfig.closeTime);
                    startTimeInput.value = "";
                    return;
                }

                // calculate duration
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                const serviceHours = parseFloat(selectedOption.getAttribute('data-hours'));
                const [h, m] = startTimeInput.value.split(':').map(Number);

                let d = new Date();
                d.setHours(h);
                d.setMinutes(m + Math.round(serviceHours * 60));

                const [closeH, closeM] = businessConfig.closeTime.split(':').map(Number);
                const endTotalMinutes = d.getHours() * 60 + d.getMinutes();
                const closeTotalMinutes = closeH * 60 + closeM;

                // make sure service doesnt end after shop closes
                if (endTotalMinutes > closeTotalMinutes) {
                    alert("This service takes " + serviceHours + " hour(s) and will exceed closing time (" + businessConfig.closeTime + ")!");
                    startTimeInput.value = "";
                    endTimeDisplay.value = "";
                    return;
                }

                const endTimeStr = String(d.getHours()).padStart(2, '0') + ":" + String(d.getMinutes()).padStart(2, '0');
                endTimeDisplay.value = endTimeStr;
                // find who is free for this time slot
                fetchAvailableTechs(prefix, dateInput.value, startTimeInput.value, endTimeStr);
            }

            function fetchAvailableTechs(prefix, date, start, end) {
                const techSelect = document.getElementById(prefix + 'TechSelect');
                const loader = document.getElementById(prefix + 'TechLoading');
                if (loader)
                    loader.style.display = 'inline';

                // get tech list from server
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
                        })
                        .catch(err => {
                            console.error("Fetch error:", err);
                            techSelect.innerHTML = '<option value="">Error loading technicians</option>';
                        });
            }

            function validateForm(prefix) {
                // skip validation if deleting
                const actionInput = document.getElementById('upAction');
                if (prefix === 'up' && actionInput && actionInput.value === 'delete')
                    return true;

                const timeInput = document.getElementById(prefix + 'Time');
                const techSelect = document.getElementById(prefix + 'TechSelect');

                const minVal = timeInput.getAttribute('min') || "10:00";
                const maxVal = timeInput.getAttribute('max') || "18:00";

                // last check before submit
                if (timeInput.value < minVal || timeInput.value > maxVal) {
                    alert("Error: Selected time must be between " + minVal + " and " + maxVal + ".");
                    return false;
                }
                if (!techSelect.value || techSelect.value === "") {
                    alert("Please select a technician.");
                    return false;
                }
                return true;
            }

            function openUpdateModal(id, plate, svcId, date, time, currentTech, status) {
                // fill up modal fields
                document.getElementById('upId').value = id;
                document.getElementById('upPlate').value = plate;
                document.getElementById('upService').value = svcId;
                document.getElementById('upDate').value = date;
                document.getElementById('upTime').value = time;
                window.currentAssignedTech = currentTech;

                const editGroup = document.getElementById('editModeButtons');
                const readOnlyGroup = document.getElementById('readOnlyModeButtons');
                const notice = document.getElementById('statusNotice');
                const inputs = document.querySelectorAll('#formInputArea select, #formInputArea input');

                const currentStatus = (status || "").trim().toLowerCase();

                // lock fields if already paid or done
                if (currentStatus === 'paid' || currentStatus === 'completed') {
                    inputs.forEach(i => i.disabled = true);
                    editGroup.style.setProperty("display", "none", "important");
                    readOnlyGroup.style.display = 'block';
                    notice.style.display = 'block';
                } else {
                    inputs.forEach(i => i.disabled = false);
                    editGroup.style.setProperty("display", "flex", "important");
                    readOnlyGroup.style.display = 'none';
                    notice.style.display = 'none';
                    calculateEndTime('up');
                }
                document.getElementById('updateModal').style.display = 'block';
            }

            // close modal if user clicks outside of it
            window.onclick = function (e) {
                if (e.target.className === 'modal')
                    e.target.style.display = "none";
            };
        </script>
    </body>
</html>