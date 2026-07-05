<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport"
    content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<title>Register · CheatSheet</title>

<link
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
    rel="stylesheet" />
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    /* ===== Combined Styles ===== */
    body {
        background: #f4f7fe;
        font-family: 'Segoe UI', sans-serif;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        padding: 20px;
    }

    .reg-card {
        background: white;
        border-radius: 24px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        width: 950px;
        max-width: 100%;
        display: flex;
        transition: all 0.3s;
    }

    /* ===== Left Side - Terms ===== */
    .terms-side {
        background: linear-gradient(145deg, #f1f5f9 0%, #e9edf2 100%);
        padding: 48px 40px;
        width: 35%;
        color: #64748b;
    }

    .terms-side h4 {
        color: #1e293b;
        font-weight: 700;
        font-size: 1.3rem;
    }

    .terms-side small {
        font-size: 0.85rem;
        line-height: 2;
        display: block;
    }

    .terms-side small i {
        color: #5e72e4;
        margin-right: 8px;
        width: 18px;
    }

    /* ===== Right Side - Form ===== */
    .form-side {
        padding: 48px 40px;
        width: 65%;
    }

    .form-side h3 {
        color: #1e293b;
        font-weight: 700;
        font-size: 1.6rem;
    }

    .form-side .subtitle {
        color: #94a3b8;
        font-size: 0.9rem;
        margin-bottom: 28px;
    }

    .form-control {
        border-radius: 12px;
        padding: 12px 16px;
        border: 2px solid #e2e8f0;
        transition: all 0.2s;
        background: #f8fafc;
        color: #1e293b;
    }

    .form-control:focus {
        border-color: #5e72e4;
        box-shadow: 0 0 0 4px rgba(94, 114, 228, 0.1);
        background: #ffffff;
    }

    .form-label {
        color: #475569;
        font-weight: 600;
        font-size: 0.85rem;
        margin-bottom: 6px;
    }

    /* ===== Input Group (Password with Eye) ===== */
    .input-group .form-control {
        border-radius: 12px 0 0 12px;
        border-right: none;
    }

    .input-group .form-control:focus {
        border-right: none;
    }

    .input-group-text {
        background: #f8fafc;
        border: 2px solid #e2e8f0;
        border-left: none;
        border-radius: 0 12px 12px 0;
        color: #5e72e4;
        cursor: pointer;
        transition: all 0.2s;
        padding: 0 16px;
    }

    .input-group-text:hover {
        background: #e2e8f0;
        color: #4e62d4;
    }

    /* ===== Button ===== */
    .btn-primary {
        background: linear-gradient(135deg, #5e72e4 0%, #4e62d4 100%);
        border: none;
        padding: 14px 30px;
        border-radius: 12px;
        font-weight: 600;
        font-size: 1rem;
        letter-spacing: 0.5px;
        transition: all 0.3s;
        width: 100%;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 30px rgba(94, 114, 228, 0.35);
        background: linear-gradient(135deg, #4e62d4 0%, #3d51c4 100%);
    }

    .btn-primary:active {
        transform: translateY(0);
    }

    /* ===== Profile Image Preview ===== */
    .preview-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px dashed #ced4da;
        display: none;
        margin-bottom: 12px;
        transition: all 0.3s;
    }

    .preview-avatar.show {
        display: inline-block;
        border-color: #5e72e4;
    }

    /* ===== Alerts ===== */
    .alert-custom {
        border-radius: 12px;
        border: none;
        padding: 12px 16px;
    }

    .alert-custom i {
        margin-right: 8px;
    }

    /* ===== Responsive ===== */
    @media (max-width: 768px) {
        .reg-card {
            flex-direction: column;
            border-radius: 20px;
        }

        .terms-side {
            width: 100%;
            padding: 24px 30px;
            border-radius: 20px 20px 0 0;
        }

        .terms-side small {
            line-height: 1.8;
            font-size: 0.8rem;
        }

        .form-side {
            width: 100%;
            padding: 30px 24px;
        }

        .form-side h3 {
            font-size: 1.4rem;
        }
    }

    @media (max-width: 480px) {
        .form-side {
            padding: 24px 16px;
        }

        .terms-side {
            padding: 20px;
        }

        .preview-avatar {
            width: 60px;
            height: 60px;
        }
    }
</style>
</head>
<body>

    <div class="reg-card">
        <!-- ===== Left Side: Terms & Conditions ===== -->
        <div class="terms-side d-none d-md-block">
            <h4 class="mb-4">
                <i class="fa-solid fa-file-lines me-2 text-primary"></i> Terms & Conditions
            </h4>
            <small>
                <i class="fa-solid fa-check-circle text-success"></i> By registering, you agree to our terms of service.<br>
                <i class="fa-solid fa-shield-halved text-primary"></i> Your data is handled with privacy and care.<br>
                <i class="fa-solid fa-lock text-warning"></i> Keep your account credentials secure.<br>
                <i class="fa-solid fa-pen-to-square text-info"></i> We reserve the right to modify these terms at any time.
            </small>
            <hr class="my-4">
            <small class="text-muted">
                <i class="fa-solid fa-envelope me-1"></i> support@cheatsheet.com
            </small>
        </div>

        <!-- ===== Right Side: Registration Form ===== -->
        <div class="form-side">
            <h3>Create Account</h3>
            <p class="subtitle">Complete the fields below to get started with your avatar.</p>

            <!-- ===== Server Error Message ===== -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show alert-custom" role="alert">
                    <i class="fa-solid fa-circle-exclamation"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- ===== Client-side Error (for password validation) ===== -->
            <div id="jsError" class="alert alert-danger alert-custom d-none" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i> <span id="jsErrorMsg"></span>
            </div>

            <!-- ===== Registration Form ===== -->
            <form:form action="${pageContext.request.contextPath}/register"
                method="POST" modelAttribute="user" enctype="multipart/form-data"
                id="registerForm" onsubmit="return validateForm()">

                <!-- Profile Picture -->
                <div class="mb-3 text-center text-md-start">
                    <label class="form-label d-block">Profile Picture</label>
                    <img id="avatarPreview" class="preview-avatar" src="#" alt="Preview">
                    <input type="file" name="profileImage" id="profileImageInput"
                        class="form-control" accept="image/*"
                        aria-label="Upload profile picture" />
                    <small class="text-muted d-block mt-1">Upload a profile image (optional)</small>
                </div>

                <!-- Username -->
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <form:input path="username" class="form-control"
                        placeholder="Enter username" required="required"
                        autocomplete="username" />
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <form:input path="email" type="email" class="form-control"
                        placeholder="example@mail.com" required="required"
                        autocomplete="email" />
                </div>

                <!-- Password (with eye toggle) -->
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <div class="input-group">
                        <form:password path="passwordHash" class="form-control"
                            id="password" placeholder="Create a password"
                            required="required" autocomplete="new-password" />
                        <span class="input-group-text"
                            onclick="togglePassword('password', 'eyeIcon1')"
                            role="button" aria-label="Toggle password visibility">
                            <i class="fa-solid fa-eye-slash" id="eyeIcon1"></i>
                        </span>
                    </div>
                    <small class="text-muted">Must be at least 6 characters</small>
                </div>

                <!-- Confirm Password (with eye toggle) -->
                <div class="mb-4">
                    <label class="form-label">Confirm Password</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="confirmPassword"
                            placeholder="Confirm your password" required
                            autocomplete="new-password" />
                        <span class="input-group-text"
                            onclick="togglePassword('confirmPassword', 'eyeIcon2')"
                            role="button" aria-label="Toggle password visibility">
                            <i class="fa-solid fa-eye-slash" id="eyeIcon2"></i>
                        </span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary shadow-sm">
                    <i class="fa-solid fa-user-plus me-2"></i> CREATE ACCOUNT
                </button>
            </form:form>

            <div class="text-center mt-4">
                <small class="text-muted">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login"
                        class="text-primary fw-semibold text-decoration-none">
                        <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Sign in
                    </a>
                </small>
            </div>
        </div>
    </div>

    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        /**
         * Profile Image Preview
         * Show preview immediately after selecting an image
         */
        document.getElementById('profileImageInput').onchange = function(evt) {
            var tgt = evt.target || window.event.srcElement;
            var files = tgt.files;

            if (FileReader && files && files.length) {
                var fr = new FileReader();
                fr.onload = function() {
                    var img = document.getElementById('avatarPreview');
                    img.src = fr.result;
                    img.classList.add('show');
                }
                fr.readAsDataURL(files[0]);
            }
        }

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
         * Client-side form validation
         * - Check if passwords match
         * - Check minimum length (6 characters)
         */
        function validateForm() {
            var password = document.getElementById('password').value;
            var confirm = document.getElementById('confirmPassword').value;
            var errorDiv = document.getElementById('jsError');
            var errorMsg = document.getElementById('jsErrorMsg');

            // Check if passwords match
            if (password !== confirm) {
                errorMsg.textContent = "Passwords do not match. Please try again.";
                errorDiv.classList.remove('d-none');
                return false;
            }

            // Check minimum length
            if (password.length < 6) {
                errorMsg.textContent = "Password must be at least 6 characters.";
                errorDiv.classList.remove('d-none');
                return false;
            }

            errorDiv.classList.add('d-none');
            return true;
        }

        /**
         * Auto-dismiss alerts after 5 seconds
         */
        document.addEventListener('DOMContentLoaded', function() {
            var alerts = document.querySelectorAll('.alert:not(#jsError)');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Reset error when user starts typing
            var password = document.getElementById('password');
            var confirm = document.getElementById('confirmPassword');
            var errorDiv = document.getElementById('jsError');

            if (password && confirm) {
                password.addEventListener('input', function() {
                    errorDiv.classList.add('d-none');
                });
                confirm.addEventListener('input', function() {
                    errorDiv.classList.add('d-none');
                });
            }
        });
    </script>

</body>
</html>