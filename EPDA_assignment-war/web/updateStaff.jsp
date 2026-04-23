<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Update Staff | Car Service Center</title>

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
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 40px;
            }

            .update-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                padding: 30px;
                max-width: 850px;
                margin: auto;
            }
            .section-title {
                border-left: 5px solid #3b82f6;
                padding-left: 15px;
                margin-bottom: 25px;
                color: #2c3e50;
            }
            .form-label {
                font-weight: 600;
                color: #495057;
                font-size: 0.85rem;
                text-transform: uppercase;
            }

            .staff-img-preview {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #f8f9fa;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="sidebar bg-manager">
            <div class="text-center mb-4"><i class="fas fa-user-shield fa-3x mb-2 text-warning"></i><h5 class="fw-bold">MANAGER</h5></div>
            <hr style="border-color: rgba(255,255,255,0.1); margin: 0 15px;">
            <a href="${pageContext.request.contextPath}/Manager/loadManagerDashboard"><i class="fas fa-chart-line me-2"></i> Home Page</a>
            <a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus me-2"></i> Register Staff</a>
            <a href="${pageContext.request.contextPath}/ManageStaff" class="active"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
            <a href="${pageContext.request.contextPath}/SetPrice"><i class="fas fa-tags me-2"></i> Set Price</a>
            <a href="${pageContext.request.contextPath}/ViewHistory"><i class="fas fa-history me-2"></i> History</a>
            <a href="${pageContext.request.contextPath}/ViewFeedback"><i class="fas fa-comments me-2"></i> View Feedback</a>
            <a href="${pageContext.request.contextPath}/EditProfile"><i class="fas fa-user-edit me-2"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/Manager/BusinessHourServlet"><i class="fas fa-user-edit me-2"></i> Business Hour</a>
            <div style="position: absolute; bottom: 20px; width: 100%;"><a href="${pageContext.request.contextPath}/Logout" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></div>
        </div>

        <div class="main-content">
            <div class="update-card">
                <h3 class="fw-bold section-title">Update Staff Member</h3>
                <p class="text-muted mb-4 small">Modifying account details for <strong><c:out value="${staff.username}"/></strong>.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 small shadow-sm mb-4"><i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/></div>
                    </c:if>

                <form action="UpdateStaff" method="post" enctype="multipart/form-data" id="updateStaffForm">
                    <input type="hidden" name="oldEmail" value="${staff.email}">
                    <input type="hidden" name="profilePic" value="${staff.profilePic}">

                    <div class="row">
                        <div class="col-md-8">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label text-primary">Username</label>
                                    <input type="text" name="username" class="form-control" value="${staff.username}" required minlength="3" maxlength="50">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Password</label>
                                    <input type="text" name="password" class="form-control" value="${staff.password}" required minlength="4">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">IC Number (Identity Locked)</label>
                                    <input type="text" name="userIC" class="form-control bg-light" value="${staff.userIC}" readonly>
                                    <small class="text-muted">Staff identity records cannot be changed.</small>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="newEmail" class="form-control" value="${staff.email}" required maxlength="100">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" name="phoneNumber" class="form-control" value="${staff.phoneNumber}" 
                                           required pattern="[0-9]{10,11}" 
                                           oninput="this.value = this.value.replace(/[^0-9]/g, '');"
                                           title="Phone number must be 10-11 digits">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Gender</label>

                                    <select class="form-select" disabled>
                                        <option value="Male" ${staff.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${staff.gender == 'Female' ? 'selected' : ''}>Female</option>
                                    </select>
                                    <input type="hidden" name="gender" value="${staff.gender}">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Home Address</label>
                                    <input type="text" name="address" class="form-control" value="${staff.address}" required maxlength="255">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label text-warning">Assign Role</label>
                                    <select name="role" class="form-select border-warning-subtle">
                                        <option value="manager" ${staff.role == 'manager' ? 'selected' : ''}>Manager</option>
                                        <option value="counter staff" ${staff.role == 'counter staff' ? 'selected' : ''}>Counter Staff</option>
                                        <option value="technician" ${staff.role == 'technician' ? 'selected' : ''}>Technician</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 text-center border-start ps-4">
                            <label class="form-label mb-3 d-block">Staff Photo</label>
                            <img src="${pageContext.request.contextPath}/profile_pics/${empty staff.profilePic ? 'default.png' : staff.profilePic}" 
                                 class="staff-img-preview" id="previewImg">
                            <div class="mt-3">
                                <input type="file" name="newProfilePic" id="fileInput" class="form-control form-control-sm" accept="image/*">
                                <small class="text-muted mt-2 d-block">Recommended: Square JPG/PNG</small>
                            </div>
                        </div>
                    </div>

                    <div class="mt-5 d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-5 py-2 fw-bold shadow-sm" onclick="disableWarning()">
                            <i class="fas fa-save me-2"></i>Update Staff Info
                        </button>
                        <button type="button" class="btn btn-light border px-4" onclick="disableWarning(); confirmCancel();">
                            Cancel
                        </button>
                        <button type="reset" class="btn btn-outline-secondary ms-auto">Reset Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let formChanged = false;

            window.onload = function () {
                const form = document.getElementById("updateStaffForm");
                const inputs = form.querySelectorAll("input, select");

                inputs.forEach(input => {
                    input.addEventListener("input", () => {
                        formChanged = true;
                    });
                });

                document.getElementById('fileInput').onchange = evt => {
                    const [file] = document.getElementById('fileInput').files;
                    if (file) {
                        formChanged = true;
                        document.getElementById('previewImg').src = URL.createObjectURL(file);
                    }
                };

                window.addEventListener("beforeunload", (e) => {
                    if (formChanged) {
                        e.preventDefault();
                        e.returnValue = "You have unsaved changes. Are you sure you want to exit?";
                    }
                });
            };

            function disableWarning() {
                formChanged = false;
            }

            function confirmCancel() {
                if (formChanged) {
                    if (confirm("Discard all unsaved changes and return to staff list?")) {
                        window.location.href = "ManageStaff";
                    }
                } else {
                    window.location.href = "ManageStaff";
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>