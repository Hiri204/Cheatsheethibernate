<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password | CheatSheet</title>
<link
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
    rel="stylesheet">
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* ===== Combined Styles ===== */
    body {
        background: linear-gradient(135deg, #74c3ff 0%, #3a86ff 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Segoe UI', sans-serif;
        margin: 0;
        padding: 20px;
    }

    .login-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 24px;
        padding: 48px 40px;
        width: 100%;
        max-width: 420px;
        color: #1a1a1a;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        transition: filter 0.3s ease;
    }

    .login-card h2 {
        color: #1a1a1a;
        font-weight: 700;
        font-size: 2rem;
    }

    .login-card .subtitle {
        color: #6c757d;
        font-size: 0.9rem;
        margin-bottom: 24px;
        text-align: center;
    }

    .form-control {
        background: #f8f9fa;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        padding: 12px 16px;
        transition: all 0.2s;
        color: #1a1a1a;
    }

    .form-control:focus {
        border-color: #3a86ff;
        box-shadow: 0 0 0 3px rgba(58, 134, 255, 0.1);
        background: #ffffff;
    }

    .form-label {
        color: #495057;
        font-weight: 600;
        font-size: 0.85rem;
        margin-bottom: 6px;
    }

    .btn-action {
        background: linear-gradient(135deg, #3a86ff 0%, #74c3ff 100%);
        color: white;
        border: none;
        width: 100%;
        padding: 14px;
        border-radius: 12px;
        font-weight: 600;
        font-size: 1rem;
        transition: all 0.3s;
    }

    .btn-action:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(58, 134, 255, 0.3);
        color: white;
    }

    .btn-action:disabled {
        opacity: 0.7;
        cursor: not-allowed;
        transform: none;
    }

    .back-link {
        color: #3a86ff;
        font-weight: 500;
        text-decoration: none;
        font-size: 0.9rem;
    }

    .back-link:hover {
        text-decoration: underline;
        color: #2a6fd4;
    }

    .alert-custom {
        border-radius: 12px;
        border: none;
        padding: 12px 16px;
    }

    .alert-custom i {
        margin-right: 8px;
    }

    /* Loading spinner for button */
    .spinner-border-sm {
        width: 1rem;
        height: 1rem;
        border-width: 0.15em;
    }

    @media (max-width: 480px) {
        .login-card {
            padding: 32px 24px;
        }
    }
</style>
</head>
<body>

    <div class="login-card">
        <h2 class="text-center">Forgot Password</h2>
        <p class="subtitle">Enter your email address and we'll send you a verification code to reset your password.</p>

        <!-- ===== Error Message ===== -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show alert-custom" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- ===== Success Message ===== -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show alert-custom" role="alert">
                <i class="fa-solid fa-circle-check"></i> ${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- ===== Forgot Password Form ===== -->
        <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="forgotPasswordForm">
            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="example@email.com" required
                       value="${email}" autocomplete="email">
                <div class="form-text text-muted small">We'll send a 6-digit verification code to this email.</div>
            </div>

            <button type="submit" class="btn-action mb-3" id="submitBtn">
                <span id="btnText">Send Reset Code</span>
                <span id="btnSpinner" class="d-none">
                    <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                    Sending...
                </span>
            </button>

            <div class="text-center small">
                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back to Login
                </a>
            </div>
        </form>
    </div>

    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        /**
         * Form submission with loading state
         */
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.getElementById('forgotPasswordForm');
            var submitBtn = document.getElementById('submitBtn');
            var btnText = document.getElementById('btnText');
            var btnSpinner = document.getElementById('btnSpinner');

            if (form) {
                form.addEventListener('submit', function(e) {
                    var email = document.getElementById('email').value.trim();

                    // Basic email validation
                    if (!email) {
                        e.preventDefault();
                        showError('Please enter your email address.');
                        return false;
                    }

                    // Email format validation
                    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailPattern.test(email)) {
                        e.preventDefault();
                        showError('Please enter a valid email address.');
                        return false;
                    }

                    // Show loading state on button
                    btnText.classList.add('d-none');
                    btnSpinner.classList.remove('d-none');
                    submitBtn.disabled = true;
                });
            }

            /**
             * Show error message dynamically
             */
            function showError(message) {
                var existingAlert = document.querySelector('.alert-danger.alert-custom');
                if (existingAlert) {
                    existingAlert.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> ' + message;
                    return;
                }

                var card = document.querySelector('.login-card');
                var alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-danger alert-dismissible fade show alert-custom';
                alertDiv.setAttribute('role', 'alert');
                alertDiv.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> ' + message +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';

                // Insert after h2
                var h2 = card.querySelector('h2');
                if (h2 && h2.nextSibling) {
                    card.insertBefore(alertDiv, h2.nextSibling);
                } else {
                    card.insertBefore(alertDiv, card.firstChild);
                }

                // Auto dismiss after 5 seconds
                setTimeout(function() {
                    var bsAlert = new bootstrap.Alert(alertDiv);
                    bsAlert.close();
                }, 5000);
            }

            /**
             * Auto-dismiss alerts after 5 seconds
             */
            var alerts = document.querySelectorAll('.alert:not(.alert-danger.dynamic)');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });
    </script>

</body>
</html>