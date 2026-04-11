<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Login | Car Service Center</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f4f7f6;
                display: flex;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
            }
            .login-container {
                background: white;
                padding: 0;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                overflow: hidden;
                max-width: 900px;
            }
            .login-illustration {
                background-color: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .img-fluid {
                max-height: 400px;
                object-fit: contain;
            }
            .login-form-section {
                padding: 50px;
            }
            .form-control:focus {
                border-color: #1abc9c;
                box-shadow: 0 0 0 0.25rem rgba(26, 188, 156, 0.25);
            }
        </style>
    </head>
    <body>
        <div class="container login-container">
            <div class="row g-0">
                <div class="col-md-6 d-none d-md-flex login-illustration border-end">
                    <img
                        class="img-fluid"
                        src="${pageContext.request.contextPath}/profile_pics/logo.png" 
                        alt="Company Logo"
                        />
                </div>

                <div class="col-md-6 col-sm-12 login-form-section">
                    <div class="text-center text-md-start">
                        <h2 class="fw-bold mb-1">Welcome Back!</h2>
                        <p class="text-muted mb-4">Please enter your details to login.</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small mb-4">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <form action="Login" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted">
                                    <i class="fas fa-envelope"></i>
                                </span>
                                <input
                                    name="email"
                                    class="form-control border-start-0"
                                    type="email"
                                    placeholder="name@example.com"
                                    required
                                    autocomplete="username"
                                    />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted">
                                    <i class="fas fa-lock"></i>
                                </span>
                                <input
                                    name="password"
                                    class="form-control border-start-0"
                                    type="password"
                                    placeholder="••••••••"
                                    required
                                    minlength="4"
                                    autocomplete="current-password"
                                    />
                            </div>
                        </div>

                        <div class="d-grid">
                            <button class="btn btn-success btn-lg fw-bold shadow-sm" type="submit">
                                Sign In
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>