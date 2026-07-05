<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password | CheatSheet</title>
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

    .input-group .form-control {
        border-radius: 12px 0 0 12px;
    }

    .input-group-text {
        background: #f8f9fa;
        border: 2px solid #e9ecef;
        border-left: none;
        border-radius: 0 12px 12px 0;
        color: #6c757d;
        cursor: pointer;
        transition: all 0.2s;
    }

    .input-group-text:hover {
        background: #e9ecef;
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

    @media (max-width: 480px) {
        .login-card {
            padding: 32px 24px;
        }
    }
</style>
</head>
<body>

    <div class="login-card">
        <!-- ===== Alert Messages ===== -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show alert-custom" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show alert-custom" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Client-side error placeholder -->
        <div id="jsError" class="alert alert-danger alert-custom d-none" role="alert"></div>

        <c:choose>
            <%-- ===== Step 2: Code Verified → Show New Password Form ===== --%>
            <c:when test="${codeVerified == true}">
                <h2 class="text-center">New Password</h2>
                <p class="text-center subtitle">Enter and confirm your new password.</p>

                <form action="${pageContext.request.contextPath}/reset-password" method="POST"
                      onsubmit="return validatePasswords()">
                    <input type="hidden" name="email" value="${email}">
                    <input type="hidden" name="code" value="${code}">

                    <!-- New Password Field -->
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="newPassword" name="newPassword"
                                   placeholder="Enter new password" required>
                            <span class="input-group-text" onclick="togglePassword('newPassword', 'eyeIcon1')">
                                <i class="fa-solid fa-eye-slash" id="eyeIcon1"></i>
                            </span>
                        </div>
                        <div class="form-text text-muted small">Password must be at least 6 characters.</div>
                    </div>

                    <!-- Confirm Password Field -->
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="confirmPassword"
                                   placeholder="Confirm new password" required>
                            <span class="input-group-text" onclick="togglePassword('confirmPassword', 'eyeIcon2')">
                                <i class="fa-solid fa-eye-slash" id="eyeIcon2"></i>
                            </span>
                        </div>
                    </div>

                    <button type="submit" class="btn-action mb-3">Save Password</button>

                    <div class="text-center small">
                        <a href="${pageContext.request.contextPath}/login" class="back-link">
                            <i class="fa-solid fa-arrow-left me-1"></i> Back to Login
                        </a>
                    </div>
                </form>
            </c:when>

            <%-- ===== Step 1: Enter Verification Code ===== --%>
            <c:otherwise>
                <h2 class="text-center">Verify Code</h2>
                <p class="text-center subtitle">Enter the 6-digit code sent to your email.</p>

                <form action="${pageContext.request.contextPath}/verify-code" method="POST">
                    <input type="hidden" name="email" value="${email}">

                    <div class="mb-3">
                        <label for="code" class="form-label">Verification Code</label>
                        <input type="text" class="form-control" id="code" name="code"
                               placeholder="Enter 6-digit code" maxlength="6"
                               pattern="[0-9]{6}" title="Please enter exactly 6 digits"
                               required autocomplete="off">
                    </div>

                    <button type="submit" class="btn-action mb-3">Verify Code</button>

                    <div class="text-center small">
                        <p class="mb-1">Didn't receive the code?</p>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="back-link">
                            Resend Code
                        </a>
                        <br>
                        <a href="${pageContext.request.contextPath}/login" class="back-link mt-2 d-inline-block">
                            <i class="fa-solid fa-arrow-left me-1"></i> Back to Login
                        </a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        /**
         * Toggle password visibility (show/hide)
         */
        function togglePassword(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon = document.getElementById(iconId);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            }
        }

        /**
         * Validate passwords match and meet requirements before form submission
         */
        function validatePasswords() {
            var newPwd = document.getElementById("newPassword").value;
            var confirmPwd = document.getElementById("confirmPassword").value;
            var errorDiv = document.getElementById("jsError");

            // Check if passwords match
            if (newPwd !== confirmPwd) {
                errorDiv.innerHTML = '<i class="fa-solid fa-circle-exclamation me-2"></i> Passwords do not match. Please try again.';
                errorDiv.classList.remove("d-none");
                return false;
            }

            // Check minimum length
            if (newPwd.length < 6) {
                errorDiv.innerHTML = '<i class="fa-solid fa-circle-exclamation me-2"></i> Password must be at least 6 characters.';
                errorDiv.classList.remove("d-none");
                return false;
            }

            errorDiv.classList.add("d-none");
            return true;
        }

        /**
         * Restrict code input to digits only
         */
        document.addEventListener('DOMContentLoaded', function() {
            var codeInput = document.getElementById('code');
            if (codeInput) {
                codeInput.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '');
                });
            }

            // Auto-dismiss alerts after 5 seconds
            var alerts = document.querySelectorAll('.alert:not(#jsError)');
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