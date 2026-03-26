<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Payment Management | Car Service Center</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* 【2. 统一核心 CSS】 */
            :root { --sidebar-width: 260px; }
            body { background-color: #f4f7f6; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                background: #2c3e50;
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
            .sidebar a:hover { background: #34495e; color: white; border-left: 4px solid #1abc9c; }
            .sidebar .active { background: #1abc9c; color: white; border-left: 4px solid #1abc9c; }

            .main-content {
                margin-left: var(--sidebar-width);
                padding: 30px;
            }

            /* Payment 页面特有样式优化 */
            table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            th { background-color: #f8f9fa; padding: 15px; text-align: left; color: #2c3e50; border-bottom: 2px solid #eee; }
            td { padding: 15px; border-bottom: 1px solid #eee; color: #444; }
            
            .modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
            .modal-content { background-color: white; margin: 10% auto; padding: 25px; border-radius: 10px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
            
            .pay-btn { background: #FF9800; color: white; border: none; padding: 8px 16px; border-radius: 5px; font-weight: bold; transition: 0.3s; }
            .pay-btn:hover { background: #e68a00; transform: translateY(-2px); }

            @media print { .no-print { display: none !important; } .main-content { margin-left: 0; padding: 0; } }
        </style>
    </head>
    <body>

        <div class="sidebar no-print">
            <div class="text-center mb-4">
                <i class="fas fa-car-side fa-3x mb-2 text-info"></i>
                <h5 class="fw-bold" style="color: white;">CAR SERVICE</h5>
            </div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            
            <a href="${pageContext.request.contextPath}/Dashboard"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/Staff/ManageCustomers?action=list"><i class="fas fa-users me-2"></i> Manage Customers</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Registration</a>
            <a href="${pageContext.request.contextPath}/Staff/PaymentServlet" class="active"><i class="fas fa-file-invoice-dollar me-2"></i> Collect Payments</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> Edit Profile</a>

            <div style="position: absolute; bottom: 20px; width: 100%;">
                <a href="${pageContext.request.contextPath}/Logout" class="text-danger">
                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                </a>
            </div>
        </div>

        <div class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                <h2 class="fw-bold" style="color: #2c3e50;">
                    <i class="fas fa-cash-register me-2 text-primary"></i>
                    <c:out value="${view == 'history' ? 'Transaction History' : 'Payment Collection'}" />
                </h2>
                <c:choose>
                    <c:when test="${view == 'history'}">
                        <a href="PaymentServlet" class="btn btn-secondary shadow-sm"><i class="fas fa-arrow-left me-2"></i>Back to Cashier</a>
                    </c:when>
                    <c:otherwise>
                        <a href="PaymentServlet?action=viewHistory" class="btn btn-dark shadow-sm"><i class="fas fa-history me-2"></i>View History</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <%-- ================= VIEW: TRANSACTION HISTORY ================= --%>
                <c:when test="${view == 'history'}">
                    <div class="no-print">
                        <table>
                            <thead>
                                <tr>
                                    <th>Receipt ID</th>
                                    <th>Date</th>
                                    <th>Customer</th>
                                    <th>Service</th>
                                    <th>Method</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pay" items="${paymentHistory}">
                                    <tr>
                                        <td class="fw-bold text-primary">#${pay.receipt_id}</td>
                                        <td>${pay.payment_date}</td>
                                        <td>${pay.appointment.customer.username}</td>
                                        <td>${pay.appointment.service.serviceType}</td>
                                        <td><span class="badge bg-light text-dark border">${pay.payment_method}</span></td>
                                        <td><strong class="text-success">RM ${pay.total_price}</strong></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty paymentHistory}">
                                    <tr><td colspan="6" class="text-center p-5 text-muted">No transaction records found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:when>

                <%-- ================= VIEW: PENDING PAYMENTS (CASHIER) ================= --%>
                <c:otherwise>
                    <div class="search-box no-print mb-4 p-3 bg-white rounded shadow-sm border">
                        <form action="PaymentServlet" method="GET" class="d-flex align-items-center gap-3">
                            <input type="hidden" name="action" value="search">
                            <span class="fw-bold text-muted">Search Appointment:</span>
                            <input type="text" name="query" class="form-control w-25" placeholder="ID or Email..." value="${param.query}" required>
                            <button type="submit" class="btn btn-primary px-4">Search</button>
                            <a href="PaymentServlet" class="text-decoration-none small text-muted"><i class="fas fa-sync"></i> Refresh</a>
                        </form>
                    </div>

                    <h4 class="fw-bold mb-3 no-print" style="color: #34495e;">Pending Bills</h4>
                    <div class="no-print">
                        <table>
                            <thead>
                                <tr>
                                    <th>Appt ID</th>
                                    <th>Customer Name</th>
                                    <th>Car Plate</th>
                                    <th>Service Type</th>
                                    <th>Amount Due</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${appList}">
                                    <tr>
                                        <td>#${app.appointment_id}</td>
                                        <td class="fw-bold">${app.customer.username}</td>
                                        <td><span class="badge bg-secondary">${app.car.carPlateNumber}</span></td>
                                        <td>${app.service.serviceType}</td>
                                        <td class="fw-bold text-danger">RM ${app.service.price}</td>
                                        <td>
                                            <button type="button" class="pay-btn" 
                                                    onclick="openPaymentModal('${app.appointment_id}', '${app.customer.username}', '${app.service.serviceType}', '${app.service.price}')">
                                                <i class="fas fa-wallet me-2"></i>Collect RM
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty appList}">
                                    <tr><td colspan="6" class="text-center p-5 text-muted">All clear! No pending payments.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- Receipt 打印预览区域 (只有付钱成功后才显示) --%>
            <c:if test="${not empty price}">
                <div class="receipt-mode shadow-lg p-4 bg-white" style="width: 350px; margin: 20px auto; border: 1px solid #ddd; font-family: monospace;">
                    <h3 class="text-center mb-1">APU AUTOMOTIVE</h3>
                    <p class="text-center small text-muted">Official Receipt</p>
                    <hr style="border-top: 1px dashed #000;">
                    <p><strong>ID:</strong> ${transactionId}</p>
                    <p><strong>Date:</strong> ${java.time.LocalDate.now()}</p>
                    <p><strong>Cust:</strong> ${custName}</p>
                    <p><strong>Mode:</strong> ${method}</p>
                    <hr style="border-top: 1px dashed #000;">
                    <div class="d-flex justify-content-between mb-2">
                        <span>${serviceType}</span>
                        <span>RM ${price}</span>
                    </div>
                    <hr style="border-top: 1px dashed #000;">
                    <h4 class="text-end fw-bold">TOTAL: RM ${price}</h4>
                    <p class="text-center mt-4 small">*** PAID ***</p>

                    <div class="no-print text-center mt-3 d-grid gap-2">
                        <button class="btn btn-primary" onclick="window.print()"><i class="fas fa-print"></i> Print Receipt</button>
                        <button class="btn btn-outline-secondary" onclick="location.href = 'PaymentServlet'">Close</button>
                    </div>
                </div>
            </c:if>
        </div>

        <div id="payModal" class="modal no-print">
            <div class="modal-content border-0 shadow-lg">
                <h3 class="fw-bold mb-3">Finalize Bill</h3>
                <div class="bg-light p-3 rounded mb-3">
                    <p class="mb-1 small">Appt: #<span id="displayId"></span></p>
                    <p class="mb-1 small">Cust: <span id="displayCust"></span></p>
                    <h2 class="text-center text-danger fw-bold my-2">RM <span id="displayPrice"></span></h2>
                </div>

                <form action="PaymentServlet" method="POST">
                    <input type="hidden" name="action" value="confirmPayment">
                    <input type="hidden" name="appointmentId" id="inputAppId">

                    <label class="small fw-bold text-muted mb-1">Select Method:</label>
                    <select name="paymentMethod" class="form-select mb-4" required>
                        <option value="Cash">Cash</option>
                        <option value="Credit/Debit Card">Credit/Debit Card</option>
                        <option value="TNG / QR Pay">TNG / QR Pay</option>
                    </select>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold mb-2">CONFIRM & PAID</button>
                    <button type="button" class="btn btn-light w-100" onclick="closeModal()">Cancel</button>
                </form>
            </div>
        </div>

        <script>
            function openPaymentModal(id, cust, svc, price) {
                document.getElementById('displayId').innerText = id;
                document.getElementById('inputAppId').value = id;
                document.getElementById('displayCust').innerText = cust;
                document.getElementById('displayPrice').innerText = price;
                document.getElementById('payModal').style.display = 'block';
            }
            function closeModal() { document.getElementById('payModal').style.display = 'none'; }
            window.onclick = function(e) { if(e.target == document.getElementById('payModal')) closeModal(); }
        </script>
    </body>
</html>