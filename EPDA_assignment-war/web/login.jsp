<%-- 
    Document   : login
    Created on : 8 Mar 2026, 9:40:57 am
    Author     : teech
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Login Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <style>
            body {
                background-color: #f8f9fa;
                display: flex;
                align-items: center;
                min-height: 100vh;
            }
            .login-container {
                background: white;
                padding: 30px;
                border-radius: 15px;
                shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            .img-fluid {
                border-radius: 15px;
                object-fit: cover;
                height: 100%;
            }
        </style>
    </head>
    <body>
        <div class="container login-container">
            <div class="row align-items-center">
                <div class="col-md-6 d-none d-md-block">
                    <img
                        class="img-fluid"
                        src="${pageContext.request.contextPath}/profile_pics/logo.png" 
                        alt="Login Illustration"
                        />
                </div>

                <div class="col-md-6 col-sm-12">
                    <h2 class="fw-bold mb-3">Nice To See You !</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                        </div>
                    </c:if>

                    <form action="Login" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address:</label>
                            <div class="input-group">
                                <span class="input-group-text">@</span>
                                <input
                                    name="email"
                                    class="form-control"
                                    type="email"
                                    placeholder="example@mail.com"
                                    required
                                    />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Password:</label>
                            <div class="input-group">
                                <span class="input-group-text">🔒</span>
                                <input
                                    name="password"
                                    class="form-control"
                                    type="password"
                                    placeholder="Enter your password"
                                    required
                                    />
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button class="btn btn-success btn-lg" type="submit">
                                Login
                            </button>
                        </div>
                    </form>

                    <p class="mt-3 text-center text-muted">
                        Don't have an account? <a href="register.jsp">Register here</a>
                    </p>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
