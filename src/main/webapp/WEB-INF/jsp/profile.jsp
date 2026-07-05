<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport"
    content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<title>My Profile · DevSheets</title>

<!-- Bootstrap 5 CSS -->
<link
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
    rel="stylesheet" />
<!-- Font Awesome -->
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    /* ===== Combined Styles ===== */
    body {
        background: #f2f4f8;
        font-family: -apple-system, BlinkMacSystemFont, "Inter", "Segoe UI", Roboto, sans-serif;
        color: #1a1e2b;
        min-height: 100vh;
    }

    .main-content {
        margin-left: 260px;
        padding: 40px 48px 60px;
        min-height: 100vh;
        background: #f2f4f8;
    }

    .page-title {
        font-size: 1.8rem;
        font-weight: 700;
        letter-spacing: -0.02em;
        color: #1a1e2b;
    }

    .page-subtitle {
        font-size: 0.95rem;
        color: #6b7280;
        margin-top: 4px;
    }

    /* ─── Profile Card ─── */
    .profile-card {
        background: #ffffff;
        border-radius: 28px;
        border: none;
        padding: 32px 36px;
        margin-bottom: 28px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.03);
        transition: box-shadow 0.3s ease;
    }

    .profile-card:hover {
        box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
    }

    /* ─── Avatar ─── */
    .avatar-circle {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(135deg, #1a1e2b, #3b4252);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.8rem;
        font-weight: 600;
        border: 6px solid #ffffff;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.10);
        flex-shrink: 0;
    }

    .avatar-img {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 6px solid #ffffff;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.10);
    }

    .user-info .username {
        font-size: 1.9rem;
        font-weight: 700;
        letter-spacing: -0.02em;
        margin: 0;
        color: #1a1e2b;
    }

    .user-info .user-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 16px 24px;
        margin-top: 4px;
        color: #6b7280;
        font-size: 0.95rem;
    }

    .user-info .user-meta i {
        width: 1.2rem;
        color: #8e95a3;
    }

    .user-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        align-items: center;
    }

    /* ─── Stats ─── */
    .stats-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 24px 48px;
        padding: 16px 0 0;
        margin-top: 16px;
        border-top: 1px solid #f1f3f7;
    }

    .stat-item {
        display: flex;
        align-items: baseline;
        gap: 6px;
        cursor: pointer;
    }

    .stats-bar a.stat-item {
        text-decoration: none;
        color: inherit;
        transition: opacity 0.2s ease;
    }

    .stats-bar a.stat-item:hover {
        opacity: 0.7;
    }

    .stat-number {
        font-size: 1.3rem;
        font-weight: 700;
        color: #1a1e2b;
    }

    .stat-label {
        font-size: 0.8rem;
        color: #8e95a3;
        text-transform: uppercase;
        letter-spacing: 0.4px;
        font-weight: 500;
    }

    /* ─── Buttons ─── */
    .btn-edit-profile {
        background: #1a1e2b;
        color: #fff;
        border: none;
        border-radius: 40px;
        padding: 10px 28px;
        font-weight: 600;
        font-size: 0.95rem;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(26, 30, 43, 0.15);
    }

    .btn-edit-profile:hover {
        background: #2c3347;
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(26, 30, 43, 0.2);
    }

    .btn-admin-panel {
        background: #4f46e5;
        color: #fff;
        border: none;
        border-radius: 40px;
        padding: 10px 28px;
        font-weight: 600;
        font-size: 0.95rem;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
    }

    .btn-admin-panel:hover {
        background: #4338ca;
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(79, 70, 229, 0.3);
    }

    .btn-outline-action {
        background: transparent;
        color: #1a1e2b;
        border: 1.5px solid #e2e6ee;
        border-radius: 40px;
        padding: 8px 20px;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all 0.2s ease;
    }

    .btn-outline-action:hover {
        background: #f0f2f6;
        border-color: #c5cad6;
        transform: translateY(-2px);
    }

    .btn-danger-soft {
        background: #fee2e2;
        color: #b91c1c;
        border: none;
        border-radius: 40px;
        padding: 8px 20px;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all 0.2s ease;
    }

    .btn-danger-soft:hover {
        background: #fecaca;
        color: #991b1b;
        transform: translateY(-2px);
    }

    /* ─── Info Rows ─── */
    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid #f1f3f7;
    }

    .info-row:last-of-type {
        border-bottom: none;
    }

    .info-label {
        color: #6b7280;
        font-size: 0.9rem;
        font-weight: 500;
    }

    .info-value {
        font-weight: 600;
        color: #1a1e2b;
    }

    /* ─── Modal ─── */
    .modal-content-custom {
        border-radius: 32px;
        border: none;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
        overflow: hidden;
    }

    .modal-header-custom {
        padding: 28px 32px 16px;
        border-bottom: 1px solid #f1f3f7;
        background: #fafbfc;
    }

    .modal-body-custom {
        padding: 32px 32px 24px;
    }

    .modal-footer-custom {
        padding: 16px 32px 28px;
        border-top: 1px solid #f1f3f7;
        background: #fafbfc;
    }

    .modal-form-label {
        font-weight: 600;
        font-size: 0.85rem;
        color: #374151;
        margin-bottom: 6px;
    }

    .modal-form-control {
        border-radius: 14px;
        border: 1.5px solid #e2e6ee;
        background: #fafbfc;
        padding: 10px 16px;
        font-size: 0.95rem;
        color: #1a1e2b;
        transition: all 0.2s ease;
    }

    .modal-form-control:focus {
        background: #ffffff;
        border-color: #8e95a3;
        box-shadow: 0 0 0 4px rgba(26, 30, 43, 0.04);
        outline: none;
    }

    .modal-form-control.is-invalid {
        border-color: #ef4444;
        background: #fef2f2;
    }

    .btn-modal-cancel {
        background: #f1f3f7;
        color: #4b5563;
        border: none;
        border-radius: 40px;
        padding: 10px 28px;
        font-weight: 600;
        transition: all 0.2s ease;
    }

    .btn-modal-cancel:hover {
        background: #e5e7eb;
        color: #1a1e2b;
    }

    .btn-modal-save {
        background: #1a1e2b;
        color: #fff;
        border: none;
        border-radius: 40px;
        padding: 10px 28px;
        font-weight: 600;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(26, 30, 43, 0.15);
    }

    .btn-modal-save:hover {
        background: #2c3347;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(26, 30, 43, 0.2);
    }

    .avatar-container {
        position: relative;
        width: 120px;
        height: 120px;
        margin: 0 auto 20px;
    }

    .profile-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid #ffffff;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
    }

    .upload-badge {
        position: absolute;
        bottom: 0;
        right: 0;
        background: #1a1e2b;
        color: #fff;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 3px solid #ffffff;
        cursor: pointer;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
    }

    .upload-badge:hover {
        background: #2c3347;
        transform: scale(1.05);
    }

    /* ─── Alerts ─── */
    .alert-custom {
        border-radius: 18px;
        border: none;
        padding: 16px 24px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        animation: slideDown 0.4s ease-out;
    }

    @keyframes slideDown {
        0% { opacity: 0; transform: translateY(-16px); }
        100% { opacity: 1; transform: translateY(0); }
    }

    /* ─── Loading Overlay ─── */
    .loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.75);
        backdrop-filter: blur(2px);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.3s ease;
    }

    .loading-overlay.show {
        opacity: 1;
        pointer-events: all;
    }

    .spinner-custom {
        width: 48px;
        height: 48px;
        border: 4px solid #e2e6ee;
        border-top-color: #1a1e2b;
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    /* ─── Responsive ─── */
    @media (max-width: 992px) {
        .main-content {
            margin-left: 0;
            padding: 24px 20px 40px;
        }
    }

    @media (max-width: 768px) {
        .main-content {
            padding: 16px 14px 32px;
        }
        .profile-card {
            padding: 20px 16px;
        }
        .avatar-circle, .avatar-img {
            width: 80px;
            height: 80px;
            font-size: 2rem;
        }
        .user-info .username {
            font-size: 1.4rem;
        }
        .user-info .user-meta {
            font-size: 0.85rem;
            gap: 8px 16px;
        }
        .stats-bar {
            gap: 16px 24px;
            justify-content: center;
        }
        .user-actions {
            justify-content: center;
            width: 100%;
        }
    }
</style>
</head>
<body>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner-custom"></div>
    </div>

    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="profile" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">

        <!-- Page Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
            <div>
                <h3 class="page-title">
                    <i class="fa-regular fa-user me-2"></i>My Profile
                </h3>
                <p class="page-subtitle">
                    <i class="fa-solid fa-circle-info me-1"></i> Manage your account information and preferences
                </p>
            </div>
            <div class="d-flex gap-2 mt-2 mt-md-0">
                <a href="${pageContext.request.contextPath}/dashboard"
                    class="btn btn-outline-secondary btn-sm rounded-pill px-4 fw-semibold">
                    <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
                </a>
                <button onclick="location.reload()"
                    class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                    <i class="fa-solid fa-rotate me-1"></i> Refresh
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty user}">
                <div class="alert alert-warning shadow-sm mb-4 alert-custom" role="alert">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation text-warning fs-5"></i>
                        <span>User information not available. Please <a href="${pageContext.request.contextPath}/login" class="alert-link fw-semibold">login</a> again.</span>
                    </div>
                </div>
            </c:when>
            <c:otherwise>

                <!-- ===== Alerts ===== -->
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4 alert-custom" role="alert">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fa-solid fa-circle-check text-success fs-5"></i>
                            <span class="fw-semibold">${successMsg}</span>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successMsg"); %>
                </c:if>

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4 alert-custom" role="alert">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fa-solid fa-circle-exclamation text-danger fs-5"></i>
                            <span class="fw-semibold">${errorMsg}</span>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("errorMsg"); %>
                </c:if>

                <!-- ===== PROFILE CARD ===== -->
                <div class="profile-card">
                    <div class="row align-items-center g-4">
                        <!-- Avatar -->
                        <div class="col-md-auto text-center text-md-start">
                            <c:choose>
                                <c:when test="${not empty user.profileImg && user.profileImg ne 'default-avatar.png'}">
                                    <img src="${pageContext.request.contextPath}/uploads/${user.profileImg}"
                                        class="avatar-img" alt="${user.username}"
                                        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                    <div class="avatar-circle" style="display: none;">
                                        ${fn:toUpperCase(fn:substring(user.username, 0, 1))}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-circle">
                                        ${fn:toUpperCase(fn:substring(user.username, 0, 1))}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- User Info -->
                        <div class="col-md">
                            <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                                <h2 class="username">${user.username}</h2>
                                <span class="badge ${user.role eq 'admin' ? 'bg-primary' : 'bg-secondary'} rounded-pill px-3 py-1.5 text-uppercase"
                                    style="font-size: 0.7rem; font-weight: 600;">
                                    ${not empty user.role ? user.role : 'User'}
                                </span>
                                <c:if test="${user.status eq 'suspended'}">
                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-1.5 text-uppercase"
                                        style="font-size: 0.7rem; font-weight: 600;">
                                        <i class="fa-solid fa-ban me-1"></i> Suspended
                                    </span>
                                </c:if>
                            </div>
                            <div class="user-meta">
                                <span><i class="fa-regular fa-envelope"></i> ${user.email}</span>
                                <c:if test="${not empty user.phone}">
                                    <span><i class="fa-solid fa-phone"></i> ${user.phone}</span>
                                </c:if>
                                <c:if test="${user.status eq 'suspended' and not empty user.suspensionReason}">
                                    <span class="text-warning"><i class="fa-solid fa-circle-exclamation"></i> Reason: ${user.suspensionReason}</span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="col-md-auto text-center text-md-end">
                            <div class="user-actions">
                                <button type="button" class="btn-edit-profile" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fa-regular fa-pen-to-square me-2"></i>Edit Profile
                                </button>
                                <c:if test="${user.role eq 'admin'}">
                                    <button type="button" class="btn-admin-panel"
                                        onclick="window.location.href='${pageContext.request.contextPath}/admin/dashboard'">
                                        <i class="fa-solid fa-shield-halved me-2"></i>Admin Panel
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- ===== Stats ===== -->
                    <div class="stats-bar">
                        <div class="stat-item">
                            <span class="stat-number">${sheetCount != null ? sheetCount : 0}</span>
                            <span class="stat-label">Sheets</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/user/followers/${user.userId}" class="stat-item">
                            <span class="stat-number">${followerCount != null ? followerCount : 0}</span>
                            <span class="stat-label">Followers</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/user/following/${user.userId}" class="stat-item">
                            <span class="stat-number">${followingCount != null ? followingCount : 0}</span>
                            <span class="stat-label">Following</span>
                        </a>
                    </div>
                </div>

                <!-- ===== ACCOUNT INFORMATION ===== -->
                <div class="profile-card">
                    <h5 class="fw-bold mb-3" style="font-size: 1.05rem; color: #1a1e2b;">
                        <i class="fa-regular fa-clock me-2"></i>Account Information
                    </h5>
                    <div class="row g-0">
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label"><i class="fa-regular fa-calendar-plus me-2"></i>Member Since</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty user.createdAt}">
                                            <fmt:parseDate value="${user.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreated" />
                                            <fmt:formatDate value="${parsedCreated}" pattern="dd MMM yyyy" />
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label"><i class="fa-regular fa-circle-check me-2"></i>Account Status</span>
                                <span class="info-value ${user.status eq 'active' ? 'text-success' : 'text-warning'}">
                                    <i class="fa-solid ${user.status eq 'active' ? 'fa-circle-check' : 'fa-ban'} me-1"></i>
                                    ${user.status eq 'active' ? 'Active' : user.status}
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label"><i class="fa-regular fa-id-card me-2"></i>User ID</span>
                                <span class="info-value">#${user.userId}</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label"><i class="fa-regular fa-file-lines me-2"></i>Total Sheets</span>
                                <span class="info-value">${sheetCount != null ? sheetCount : 0}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== QUICK ACTIONS ===== -->
                <div class="profile-card">
                    <h5 class="fw-bold mb-3" style="font-size: 1.05rem; color: #1a1e2b;">
                        <i class="fa-solid fa-bolt me-2"></i>Quick Actions
                    </h5>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/cheatsheets/new" class="btn btn-outline-action">
                            <i class="fa-solid fa-plus me-2"></i>Create Sheet
                        </a>
                        <a href="${pageContext.request.contextPath}/cheatsheets/my-sheets" class="btn btn-outline-action">
                            <i class="fa-regular fa-file-lines me-2"></i>My Sheets
                        </a>
                        <a href="${pageContext.request.contextPath}/user/followers/${user.userId}" class="btn btn-outline-action">
                            <i class="fa-solid fa-user-group me-2"></i>Followers
                        </a>
                        <a href="${pageContext.request.contextPath}/user/following/${user.userId}" class="btn btn-outline-action">
                            <i class="fa-solid fa-users me-2"></i>Following
                        </a>
                        <button type="button" class="btn btn-danger-soft"
                            onclick="if(confirm('Are you sure you want to delete your account? This action cannot be undone.')) { document.getElementById('deleteAccountForm').submit(); }">
                            <i class="fa-solid fa-trash-can me-2"></i>Delete Account
                        </button>
                    </div>
                    <form id="deleteAccountForm" action="${pageContext.request.contextPath}/profile/delete-account" method="POST" style="display: none;">
                        <input type="hidden" name="confirm" value="true" />
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ===== EDIT PROFILE MODAL ===== -->
    <div class="modal fade" id="editProfileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title fw-bold" id="editProfileModalLabel">
                        <i class="fa-solid fa-user-gear me-2"></i>Account Settings
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <form id="editProfileForm" action="${pageContext.request.contextPath}/profile/update" method="POST" enctype="multipart/form-data" onsubmit="return validateProfileForm()">
                    <div class="modal-body modal-body-custom">
                        <!-- Avatar Upload -->
                        <div class="text-center mb-4">
                            <div class="avatar-container">
                                <c:choose>
                                    <c:when test="${not empty user.profileImg && user.profileImg ne 'default-avatar.png'}">
                                        <img id="profilePreview" src="${pageContext.request.contextPath}/uploads/${user.profileImg}" class="profile-avatar" alt="Profile" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="firstLetter" value="${fn:substring(user.username, 0, 1)}" />
                                        <img id="profilePreview" src="https://ui-avatars.com/api/?name=${fn:toUpperCase(firstLetter)}&background=1a1e2b&color=fff&size=120&bold=true" class="profile-avatar" alt="Default Profile" />
                                    </c:otherwise>
                                </c:choose>
                                <label for="profileImageInput" class="upload-badge" title="Change photo">
                                    <i class="fa-solid fa-camera small"></i>
                                </label>
                                <input type="file" name="profileImage" id="profileImageInput" accept="image/*" class="d-none" />
                            </div>
                            <h5 class="fw-bold mb-1">${user.username}</h5>
                            <span class="badge ${user.role eq 'admin' ? 'bg-primary' : 'bg-secondary'} rounded-pill px-3 py-1.5 text-uppercase" style="font-size: 0.7rem; font-weight: 600;">
                                ${not empty user.role ? user.role : 'User'}
                            </span>
                            <p class="text-muted small mt-2 mb-0">
                                <i class="fa-solid fa-circle-info me-1"></i> Click the camera icon to change your photo (Max 5MB)
                            </p>
                        </div>

                        <!-- Form Fields -->
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="modal-form-label"><i class="fa-regular fa-user me-1"></i>Username</label>
                                <input type="text" name="username" id="editUsername" class="form-control modal-form-control" value="${user.username}" required />
                                <div class="invalid-feedback">Username is required</div>
                            </div>
                            <div class="col-12">
                                <label class="modal-form-label"><i class="fa-regular fa-envelope me-1"></i>Email Address</label>
                                <input type="email" name="email" id="editEmail" class="form-control modal-form-control" value="${user.email}" required />
                                <div class="invalid-feedback">Please enter a valid email</div>
                            </div>
                            <div class="col-12">
                                <label class="modal-form-label"><i class="fa-solid fa-phone me-1"></i>Phone Number</label>
                                <input type="text" name="phone" id="editPhone" class="form-control modal-form-control" value="${user.phone}" placeholder="Enter your phone number" />
                            </div>
                            <div class="col-12">
                                <label class="modal-form-label">
                                    <i class="fa-solid fa-lock me-1"></i>New Password
                                    <span class="text-muted fw-normal">(leave blank to keep current)</span>
                                </label>
                                <input type="password" name="password" id="editPassword" class="form-control modal-form-control" placeholder="Enter new password (min 6 characters)" />
                                <div class="form-text"><i class="fa-solid fa-circle-info me-1"></i> Password must be at least 6 characters</div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer modal-footer-custom">
                        <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal"><i class="fa-solid fa-xmark me-1"></i>Cancel</button>
                        <button type="submit" class="btn-modal-save" id="saveProfileBtn"><i class="fa-regular fa-floppy-disk me-1"></i>Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
        /**
         * Show loading overlay
         */
        function showLoading() {
            document.getElementById('loadingOverlay').classList.add('show');
        }

        /**
         * Hide loading overlay
         */
        function hideLoading() {
            document.getElementById('loadingOverlay').classList.remove('show');
        }

        /**
         * Image preview for profile upload
         */
        document.getElementById('profileImageInput').addEventListener('change', function(evt) {
            var tgt = evt.target || window.event.srcElement;
            var files = tgt.files;
            if (FileReader && files && files.length) {
                var file = files[0];
                // Validate file size (max 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('⚠️ Image size exceeds 5MB limit. Please choose a smaller image.');
                    this.value = '';
                    return;
                }
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('⚠️ Please select an image file.');
                    this.value = '';
                    return;
                }
                var fr = new FileReader();
                fr.onload = function() {
                    document.getElementById('profilePreview').src = fr.result;
                }
                fr.readAsDataURL(file);
            }
        });

        /**
         * Validate profile form before submission
         */
        function validateProfileForm() {
            var username = document.getElementById('editUsername');
            var email = document.getElementById('editEmail');
            var password = document.getElementById('editPassword');
            var isValid = true;

            // Reset validation
            username.classList.remove('is-invalid');
            email.classList.remove('is-invalid');
            password.classList.remove('is-invalid');

            // Validate username
            if (!username.value.trim()) {
                username.classList.add('is-invalid');
                isValid = false;
            }

            // Validate email
            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!email.value.trim() || !emailPattern.test(email.value.trim())) {
                email.classList.add('is-invalid');
                isValid = false;
            }

            // Validate password (if provided)
            if (password.value.trim() && password.value.trim().length < 6) {
                password.classList.add('is-invalid');
                isValid = false;
                alert('⚠️ Password must be at least 6 characters.');
            }

            if (!isValid) {
                alert('⚠️ Please fix the highlighted fields.');
                return false;
            }

            // Show loading overlay
            showLoading();
            return true;
        }

        /**
         * Auto-dismiss alerts after 5 seconds and handle form submission
         */
        document.addEventListener('DOMContentLoaded', function() {
            var alerts = document.querySelectorAll('.alert:not(.alert-custom)');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Handle form submission completion
            var form = document.getElementById('editProfileForm');
            if (form) {
                form.addEventListener('submit', function() {
                    var submitBtn = document.getElementById('saveProfileBtn');
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i>Saving...';
                });
            }

            console.log('Profile page initialized successfully');
        });
    </script>
</body>
</html>