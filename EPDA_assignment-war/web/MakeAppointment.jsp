<%-- 
    Document   : MakeAppointment
    Created on : 13 Mar 2026, 3:18:53 pm
    Author     : Kai Ying
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Appointments - ${customer.username}</title>
        <style>
            .modal {
                display: none;
                position: fixed;
                z-index: 100;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.4);
            }
            .modal-content {
                background: #fff;
                margin: 10% auto;
                padding: 20px;
                width: 450px;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            .clickable-row {
                cursor: pointer;
            }
            .clickable-row:hover {
                background-color: #f1f7ff;
            }
            .add-btn {
                display: block;
                width: 50px;
                height: 50px;
                background: #4CAF50;
                color: white;
                text-align: center;
                line-height: 50px;
                border-radius: 50%;
                font-size: 30px;
                cursor: pointer;
                margin: 20px auto;
                border:none;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }
            .warning-badge {
                display: inline-block;
                width: 20px;
                height: 20px;
                background: #ff4d4d;
                color: white;
                text-align: center;
                line-height: 20px;
                border-radius: 50%;
                font-weight: bold;
                cursor: help;
                margin-right: 5px;
            }
            .time-display {
                background-color: #f0f0f0;
                color: #333;
                font-weight: bold;
                border: 1px solid #ccc;
                padding: 5px;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>

        <h2>Manage Appointments: ${customer.username}</h2>

        <form action="AppointmentServlet" method="GET" style="margin-bottom: 20px;">
            <input type="hidden" name="customerEmail" value="${customer.email}">
            Date: <input type="date" name="searchDate" value="${param.searchDate}">
            ID: <input type="text" name="searchId" placeholder="Appointment ID" value="${param.searchId}" style="width:100px;">
            <button type="submit">Search</button>
            <a href="AppointmentServlet?customerEmail=${customer.email}" style="font-size: 0.8em; margin-left: 10px;">Reset</a>
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Car Plate</th>
                    <th>Service Type</th>
                    <th>Date</th>
                    <th>Start Time</th>
                    <th>Status</th>
                    <th>Technician</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="app" items="${appList}">
                    <tr class="clickable-row" onclick="openUpdateModal('${app.appointment_id}', '${app.car.carPlateNumber}', '${app.service.service_id}', '${app.appointment_date}', '${app.appointment_time}', '${app.technician_email}')">
                        <td>
                            <c:if test="${empty app.technician_email}">
                                <span class="warning-badge" title="Technician not yet assigned!">!</span>
                            </c:if>
                            ${app.appointment_id}
                        </td>
                        <td>${app.car.carPlateNumber}</td>
                        <td>${app.service.serviceType}</td>
                        <td>${app.appointment_date}</td>
                        <td>${app.appointment_time}</td>
                        <td>${app.appointment_status}</td>
                        <td>${app.technician_email}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <button class="add-btn" onclick="openAddModal()">+</button>

        <div id="addModal" class="modal">
            <div class="modal-content">
                <h3>New Appointment</h3>
                <form action="AppointmentServlet" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="customerEmail" value="${customer.email}">

                    <p>Car Plate:<br>
                        <select name="carPlateNumber" required style="width:100%;">
                            <c:forEach var="car" items="${cars}">
                                <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                            </c:forEach>
                        </select>
                    </p>

                    <p>Service Type:<br>
                        <select name="serviceId" id="addService" required onchange="calculateEndTime('add')" style="width:100%;">
                            <option value="">-- Select --</option>
                            <c:forEach var="svc" items="${services}">
                                <option value="${svc.service_id}" data-hours="${svc.serviceHour}">${svc.serviceType} (${svc.serviceHour} hrs)</option>
                            </c:forEach>
                        </select>
                    </p>

                    <p>Date: <input type="date" name="date" required id="addDate" onchange="calculateEndTime('add')" style="width:95%;"></p>
                    <p>Start Time: <input type="time" name="time" id="addTime" required onchange="calculateEndTime('add')" style="width:95%;"></p>

                    <p>Expected End Time:<br>
                        <input type="time" id="addEndTimeDisplay" class="time-display" disabled style="width:95%;">
                    </p>

                    <p>Assign Technician:<br>
                        <select name="technicianEmail" id="addTechSelect" required style="width:100%;">
                            <option value="">-- Select Time First --</option>
                        </select>
                        <small id="addTechLoading" style="display:none; color:blue;">Checking...</small>
                    </p>

                    <div style="text-align:right; margin-top:20px;">
                        <button type="button" onclick="closeModal('addModal')">Cancel</button>
                        <button type="submit" style="background:#4CAF50; color:white; border:none; padding:8px 15px; border-radius:4px;">Confirm Booking</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="updateModal" class="modal">
            <div class="modal-content">
                <h3>Appointment Details</h3>
                <form action="AppointmentServlet" method="POST">
                    <input type="hidden" name="action" id="upAction" value="update">
                    <input type="hidden" name="appointmentId" id="upId">
                    <input type="hidden" name="customerEmail" value="${customer.email}">

                    <p>Car Plate:<br>
                        <select name="carPlateNumber" id="upPlate" style="width:100%;">
                            <c:forEach var="car" items="${cars}">
                                <option value="${car.carPlateNumber}">${car.carPlateNumber}</option>
                            </c:forEach>
                        </select>
                    </p>

                    <p>Service:<br>
                        <select name="serviceId" id="upService" onchange="calculateEndTime('up')" style="width:100%;">
                            <c:forEach var="svc" items="${services}">
                                <option value="${svc.service_id}" data-hours="${svc.serviceHour}">${svc.serviceType}</option>
                            </c:forEach>
                        </select>
                    </p>

                    <p>Date: <input type="date" name="date" id="upDate" onchange="calculateEndTime('up')" style="width:95%;"></p>
                    <p>Start Time: <input type="time" name="time" id="upTime" onchange="calculateEndTime('up')" style="width:95%;"></p>

                    <p>Expected End Time:<br>
                        <input type="time" id="upEndTimeDisplay" class="time-display" disabled style="width:95%;">
                    </p>

                    <p>Assign Technician:<br>
                        <select name="technicianEmail" id="upTechSelect" required style="width:100%;">
                            <option value="">-- Checking Availability --</option>
                        </select>
                        <small id="upTechLoading" style="display:none; color:blue;">Checking...</small>
                    </p>

                    <div style="text-align:right; margin-top:20px;">
                        <button type="button" onclick="closeModal('updateModal')">Cancel</button>
                        <button type="submit" onclick="document.getElementById('upAction').value = 'delete'; return confirm('Delete this record?')" style="background:#f44336; color:white; border:none; padding:8px 15px; border-radius:4px;">Delete</button>
                        <button type="submit" style="background:#2196F3; color:white; border:none; padding:8px 15px; border-radius:4px;">Save Update</button>
                    </div>
                </form>
            </div>
        </div>

        <script>

            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
            }

            function openUpdateModal(id, plate, svcId, date, time, currentTech) {

                document.getElementById('upId').value = id;
                document.getElementById('upPlate').value = plate;
                document.getElementById('upService').value = svcId;
                document.getElementById('upDate').value = date;
                document.getElementById('upTime').value = time;

                document.getElementById('updateModal').style.display = 'block';

                window.currentAssignedTech = currentTech;

                calculateEndTime('up');
            }

            function closeModal(m) {
                document.getElementById(m).style.display = 'none';
            }

            function calculateEndTime(prefix) {

                const serviceSelect = document.getElementById(prefix + 'Service');
                const startTimeInput = document.getElementById(prefix + 'Time');
                const endTimeDisplay = document.getElementById(prefix + 'EndTimeDisplay');
                const dateInput = document.getElementById(prefix + 'Date');

                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];

                const hoursStr = selectedOption ? selectedOption.getAttribute('data-hours') : null;
                const startTimeStr = startTimeInput.value;
                const dateStr = dateInput.value;

                if (!hoursStr || !startTimeStr || !dateStr) {
                    return;
                }

                const serviceHours = parseFloat(hoursStr);
                const [h, m] = startTimeStr.split(':').map(Number);

                let d = new Date();

                d.setHours(h);
                d.setMinutes(m + Math.round(serviceHours * 60));

                const endH = String(d.getHours()).padStart(2, '0');
                const endM = String(d.getMinutes()).padStart(2, '0');

                const endTimeStr = endH + ":" + endM;

                endTimeDisplay.value = endTimeStr;

                fetchAvailableTechs(prefix, dateStr, startTimeStr, endTimeStr);
            }

            function fetchAvailableTechs(prefix, date, start, end) {

                if (!date || !start || !end) {
                    return;
                }

                const techSelect = document.getElementById(prefix + 'TechSelect');
                const loader = document.getElementById(prefix + 'TechLoading');

                loader.style.display = 'inline';

                techSelect.innerHTML = '<option value="">Loading...</option>';

                fetch("AppointmentServlet?action=getAvailableTechs"
                        + "&date=" + encodeURIComponent(date)
                        + "&startTime=" + encodeURIComponent(start)
                        + "&endTime=" + encodeURIComponent(end))

                        .then(response => {

                            if (!response.ok) {
                                throw new Error("Server error " + response.status);
                            }

                            return response.json();
                        })

                        .then(data => {

                            techSelect.innerHTML = '<option value="">-- Select Technician --</option>';

                            data.forEach(tech => {

                                let opt = new Option(tech.username, tech.email);

                                if (prefix === 'up' && tech.email === window.currentAssignedTech) {
                                    opt.selected = true;
                                }

                                techSelect.add(opt);
                            });

                            loader.style.display = 'none';
                        })

                        .catch(err => {

                            console.error(err);

                            techSelect.innerHTML = '<option value="">No technician available</option>';

                            loader.style.display = 'none';
                        });
            }

            document.getElementById('addDate').min = new Date().toISOString().split("T")[0];

            window.onclick = function (event) {

                if (event.target.className === 'modal') {
                    event.target.style.display = "none";
                }
            };

        </script>
    </body>
</html>
