<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Banned Accounts List | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body { background-color: #f4f7fe; font-family: 'Segoe UI', sans-serif; }
        .content-card { 
            border-radius: 20px; 
            border: none; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); 
            background: #ffffff; 
            padding: 30px; 
            border-top: 5px solid #dc3545; 
        }
        @media (min-width: 769px) {
            .main-content { margin-left: 260px; width: calc(100% - 260px); }
        }
        @media (max-width: 768px) {
            .main-content { margin-left: 0; width: 100%; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/jsp/sidebar.jsp">
    <jsp:param name="activePage" value="users" />
</jsp:include>

<div class="main-content">
    <div class="container-fluid py-5 px-4">
        <div class="row justify-content-center">
            <div class="col-md-11">
                
                <!-- HEADER -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold m-0 text-danger">
                        <i class="fa-solid fa-user-slash me-2"></i> Banned Accounts Registry
                    </h4>
                    <a href="${pageContext.request.contextPath}/user/list" class="btn btn-outline-secondary rounded-pill">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to User List
                    </a>
                </div>

                <!-- BANNED ACCOUNTS LIST CARD -->
                <div class="content-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fa-solid fa-user-lock text-danger me-2"></i> Currently Suspended Users
                        </h5>
                        <span class="badge bg-danger rounded-pill px-3 py-2">
                            <i class="fa-regular fa-user me-1"></i> ${not empty bannedUsers ? bannedUsers.size() : 0}
                        </span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light text-danger">
                                <tr>
                                    <th>No</th>
                                    <th>Username</th>
                                    <th>Banned At</th>
                                    <th>Expires</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty bannedUsers}">
                                        <c:forEach items="${bannedUsers}" var="bu" varStatus="bCount">
                                            <tr>
                                                <!-- Serial number without '#' -->
                                                <td class="text-muted fw-bold">${bCount.index + 1}</td>
                                                <td class="fw-bold text-dark">${bu.user.username}</td>
                                                <!-- Banned At: only date, no time -->
                                                <td class="text-muted small">${bu.bannedAt.toLocalDate()}</td>
                                                <!-- Expires: Permanent or date -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${bu.expiresAt == null}">
                                                            <span class="badge bg-danger">Permanent</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark">${bu.expiresAt.toLocalDate()}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <!-- Actions -->
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <!-- View Reason Button (opens modal) -->
                                                        <button type="button" class="btn btn-sm btn-warning px-3 rounded-pill fw-semibold"
                                                                onclick="viewReason('${bu.user.username}', '${bu.reason}')">
                                                            <i class="fa-solid fa-eye me-1"></i> Reason
                                                        </button>
                                                        
                                                        <!-- Unban Form -->
                                                        <form action="${pageContext.request.contextPath}/admin/user/unban" method="POST" class="d-inline">
                                                            <input type="hidden" name="userId" value="${bu.user.userId}" />
                                                            <button type="submit" class="btn btn-sm btn-success px-3 rounded-pill fw-semibold"
                                                                    onclick="return confirm('Unban this user?')">
                                                                <i class="fa-solid fa-user-check me-1"></i> Unban
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="fa-regular fa-circle-check fa-2x d-block mb-2 text-success"></i>
                                                No users are currently suspended.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- VIEW REASON MODAL -->
<div class="modal fade" id="reasonModal" tabindex="-1" aria-labelledby="reasonModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
            <div class="modal-header border-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark" id="reasonModalLabel">
                    <i class="fa-solid fa-circle-info text-warning me-2"></i> Ban Reason
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body px-4 pb-4">
                <p class="text-muted mb-2">Account Name: <strong id="displayBannedUser" class="text-dark"></strong></p>
                <div class="p-3 bg-light rounded-3 border">
                    <span id="displayBanReason" class="fw-semibold text-secondary"></span>
                </div>
            </div>
            <div class="modal-footer border-0 px-4 pb-4">
                <button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function viewReason(username, reasonText) {
    document.getElementById('displayBannedUser').innerText = username;
    document.getElementById('displayBanReason').innerText = reasonText ? reasonText : "အကြောင်းပြချက် မရှိပါ။";
    var reasonModal = new bootstrap.Modal(document.getElementById('reasonModal'));
    reasonModal.show();
}
</script>
</body>
</html>