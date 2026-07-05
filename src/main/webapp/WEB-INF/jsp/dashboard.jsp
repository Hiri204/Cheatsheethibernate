<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport"
    content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<title>Dynamic Dashboard · Panel</title>

<link
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
    rel="stylesheet" />
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<style>
/* ===== GLOBAL ===== */
body {
    background-color: #fafafa;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        Helvetica, Arial, sans-serif;
    color: #1a1a1a;
}

/* ===== FOLDER STYLES ===== */
.folder-wrapper {
    position: relative;
    filter: drop-shadow(0px 4px 6px rgba(0, 0, 0, 0.02));
    cursor: pointer;
    transition: transform 0.2s ease, filter 0.2s ease;
    text-decoration: none;
    display: block;
}

.folder-wrapper:hover {
    transform: translateY(-4px);
    filter: drop-shadow(0px 8px 12px rgba(0, 0, 0, 0.05));
}

.folder-tab {
    width: 90px;
    height: 16px;
    border-top-left-radius: 12px;
    border-top-right-radius: 12px;
    position: absolute;
    top: -15px;
    left: 0;
}

.folder-body {
    border-radius: 20px;
    border-top-left-radius: 0px;
    padding: 35px 24px 25px 24px;
    min-height: 130px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.folder-dots {
    position: absolute;
    top: 15px;
    right: 20px;
    color: #757575;
    font-size: 0.85rem;
}

.folder-cat-0 .folder-tab, .folder-cat-0 .folder-body {
    background-color: #dcd9f8;
}
.folder-cat-1 .folder-tab, .folder-cat-1 .folder-body {
    background-color: #ccecfc;
}
.folder-cat-2 .folder-tab, .folder-cat-2 .folder-body {
    background-color: #f7dfce;
}
.folder-cat-3 .folder-tab, .folder-cat-3 .folder-body {
    background-color: #e2f7cb;
}

/* ===== MAIN CONTENT ===== */
.main-content {
    margin-left: 260px;
    padding: 35px 45px;
}

/* ===== SEARCH ===== */
.search-wrapper {
    position: relative;
}

.search-bar {
    border-radius: 12px;
    padding: 10px 16px 10px 42px;
    border: 1px solid #ededed;
    background: #f7f7f7;
    width: 320px;
    font-size: 0.9rem;
    transition: all 0.2s;
}

.search-bar:focus {
    outline: none;
    background: #ffffff;
    border-color: #e0e0e0;
}

.search-wrapper i {
    position: absolute;
    left: 16px;
    top: 50%;
    transform: translateY(-50%);
    color: #adadad;
}

/* ===== HEADER ===== */
.header-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
}

.user-badge {
    font-size: 0.8rem;
    color: #757575;
    background: #f3f3f3;
    padding: 4px 10px;
    border-radius: 8px;
}

/* ===== STATS CARDS ===== */
.stats-card {
    border-radius: 16px;
    border: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    padding: 20px;
    transition: transform 0.2s;
}

.stats-card:hover {
    transform: translateY(-2px);
}

.stats-icon {
    width: 50px;
    height: 50px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.3rem;
}

.stats-icon.primary {
    background: #eef2ff;
    color: #4f6ef7;
}
.stats-icon.success {
    background: #ecfdf3;
    color: #12b76a;
}
.stats-icon.warning {
    background: #fffaeb;
    color: #f79009;
}

/* ===== NOTIFICATION BELL ===== */
.bell-icon {
    position: relative;
    cursor: pointer;
    font-size: 1.2rem;
    color: #555;
    transition: color 0.2s;
    padding: 6px 8px;
    border-radius: 8px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
}

.bell-icon:hover {
    color: #1a1a1a;
    background: #f0f0f0;
}

.bell-icon.has-notif {
    color: #0d6efd;
}

.notif-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    font-size: 0.6rem;
    padding: 3px 6px;
    min-width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #dc3545;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
}

.notification-dropdown {
    width: 420px;
    max-height: 500px;
    overflow-y: auto;
    border-radius: 16px;
    border: none;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.12);
    padding: 0;
}

.notification-dropdown::-webkit-scrollbar {
    width: 4px;
}
.notification-dropdown::-webkit-scrollbar-thumb {
    background: #ddd;
    border-radius: 4px;
}

.notification-dropdown .dropdown-header {
    padding: 16px 20px;
    border-bottom: 1px solid #f0f0f0;
    background: #fafafa;
    border-radius: 16px 16px 0 0;
    position: sticky;
    top: 0;
    z-index: 10;
}

.notification-item {
    padding: 12px 20px;
    border-bottom: 1px solid #f5f5f5;
    transition: background 0.2s;
    cursor: pointer;
}

.notification-item:hover {
    background: #f8f9fa;
}

.notification-item.unread {
    background: #f0f7ff;
    border-left: 3px solid #0d6efd;
}

.notification-item .notif-icon {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.notification-item .notif-icon.like {
    background: #ffebee;
    color: #e74c3c;
}
.notification-item .notif-icon.comment {
    background: #e3f2fd;
    color: #1976d2;
}
.notification-item .notif-icon.reply {
    background: #f3e5f5;
    color: #7b1fa2;
}
.notification-item .notif-icon.review {
    background: #fff3e0;
    color: #e65100;
}
.notification-item .notif-icon.follow {
    background: #e8f5e9;
    color: #2e7d32;
}
.notification-item .notif-icon.announcement {
    background: #fff8e1;
    color: #f57f17;
}
.notification-item .notif-icon.ban {
    background: #fce4ec;
    color: #c62828;
}
.notification-item .notif-icon.report {
    background: #fbe9e7;
    color: #bf360c;
}
.notification-item .notif-icon.new_sheet {
    background: #e8f5e9;
    color: #388e3c;
}

.notification-item .notif-time {
    font-size: 0.7rem;
    color: #9e9e9e;
}

.dropdown-footer {
    padding: 12px 20px;
    border-top: 1px solid #f0f0f0;
    text-align: center;
    background: #fafafa;
    border-radius: 0 0 16px 16px;
}

.dropdown-footer a {
    color: #0d6efd;
    text-decoration: none;
    font-weight: 500;
    font-size: 0.85rem;
}

.dropdown-footer a:hover {
    text-decoration: underline;
}

.notification-empty {
    padding: 40px 20px;
    text-align: center;
    color: #999;
}

.notification-empty i {
    font-size: 2.5rem;
    margin-bottom: 12px;
    display: block;
    color: #ddd;
}

.mark-read-btn {
    border-radius: 50%;
    width: 28px;
    height: 28px;
    padding: 0;
    font-size: 0.6rem;
    border: 1px solid #e0e0e0;
    background: transparent;
    color: #999;
    transition: all 0.2s;
}

.mark-read-btn:hover {
    background: #0d6efd;
    color: white;
    border-color: #0d6efd;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
    .main-content {
        margin-left: 0;
        padding: 20px;
    }
    .search-bar {
        width: 200px;
    }
}
</style>
</head>
<body>

    <!-- ===== SIDEBAR ===== -->
    <jsp:include page="sidebar.jsp" />

    <!-- ===== MAIN CONTENT ===== -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h4 class="fw-bold mb-1" style="letter-spacing: -0.5px;">My
                    Workflows</h4>
            </div>

            <div class="d-flex gap-3 align-items-center">
                <form action="${pageContext.request.contextPath}/cheatsheets/search"
                    method="GET" class="d-none d-md-block">
                    <div class="search-wrapper">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="keyword" class="search-bar" placeholder="Search...">
                    </div>
                </form>

                <div class="d-flex align-items-center gap-3 ms-2">
                    <!-- ===== NOTIFICATION BELL ===== -->
                    <div class="dropdown">
                        <a href="#" class="bell-icon ${unreadCount > 0 ? 'has-notif' : ''}"
                           id="notificationDropdown" data-bs-toggle="dropdown"
                           aria-expanded="false" title="Notifications">
                            <i class="fa-regular fa-bell"></i>
                            <c:if test="${unreadCount > 0}">
                                <span class="notif-badge" id="unreadBadge">${unreadCount}</span>
                            </c:if>
                        </a>

                        <div class="dropdown-menu dropdown-menu-end notification-dropdown"
                             aria-labelledby="notificationDropdown" id="notificationMenu">
                            <div class="dropdown-header d-flex justify-content-between align-items-center">
                                <span class="fw-bold">
                                    <i class="fa-regular fa-bell me-2"></i>Notifications
                                    <span class="badge bg-primary ms-2" id="notifCountBadge">${unreadCount}</span>
                                </span>
                                <div>
                                    <button class="btn btn-sm btn-outline-secondary me-1" id="markAllReadBtn"
                                            style="border-radius: 20px; font-size: 0.7rem;">
                                        <i class="fa-regular fa-check-circle"></i> Read all
                                    </button>
                                    <a href="${pageContext.request.contextPath}/notifications/settings"
                                       class="btn btn-sm btn-outline-secondary" style="border-radius: 20px; font-size: 0.7rem;">
                                        <i class="fa-solid fa-gear"></i>
                                    </a>
                                </div>
                            </div>

                            <div id="notificationList">
                                <!-- Notifications will be loaded via AJAX -->
                                <div class="text-center py-4 text-muted">
                                    <div class="spinner-border spinner-border-sm text-secondary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    <div class="mt-2 small">Loading notifications...</div>
                                </div>
                            </div>

                            <div class="dropdown-footer">
                                <a href="${pageContext.request.contextPath}/notifications">View all notifications</a>
                            </div>
                        </div>
                    </div>

                    <span class="user-badge">${sessionScope.loginUser.role}</span>
                    <a href="${pageContext.request.contextPath}/profile/view">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loginUser.profileImg and sessionScope.loginUser.profileImg ne 'default-avatar.png'}">
                                <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loginUser.profileImg}?v=${pageContext.session.lastAccessedTime}"
                                     class="header-avatar" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.loginUser.username}&background=e8e8e8&color=555555&bold=true"
                                     class="header-avatar" alt="Default Avatar">
                            </c:otherwise>
                        </c:choose>
                    </a>
                </div>
            </div>
        </div>

        <!-- ===== STATS CARDS (Admin Only) ===== -->
        <c:if test="${sessionScope.loginUser.role eq 'admin'}">
            <div class="row g-4 mb-5">
                <!-- User Count Card -->
                <div class="col-md-4">
                    <div class="stats-card bg-white">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon primary me-3">
                                <i class="fa-solid fa-users"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Total Users</h6>
                                <h4 class="fw-bold mb-0">${userCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Category Count Card -->
                <div class="col-md-4">
                    <div class="stats-card bg-white">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon success me-3">
                                <i class="fa-solid fa-folder-tree"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Total Categories</h6>
                                <h4 class="fw-bold mb-0">${categoryCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CheatSheet Count Card -->
                <div class="col-md-4">
                    <div class="stats-card bg-white">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon warning me-3">
                                <i class="fa-solid fa-file-lines"></i>
                            </div>
                            <div>
                                <h6 class="text-muted mb-0 small">Total CheatSheets</h6>
                                <h4 class="fw-bold mb-0">${sheetCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===== FOLDERS ===== -->
        <div class="d-flex align-items-center gap-2 mb-4">
            <h6 class="text-secondary fw-semibold mb-0"
                style="color: #1a1a1a !important; font-size: 1.05rem;">Folders</h6>
            <span class="badge rounded-pill bg-light text-muted border px-2 py-1"
                style="font-size: 0.75rem;">${categories.size()}</span>
        </div>

        <div class="row g-4 mb-5" style="margin-top: 5px;">
            <c:forEach items="${categories}" var="cat" varStatus="status">
                <div class="col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/cheatsheets/category/${cat.name}"
                       class="folder-wrapper folder-cat-${status.index % 4}">
                        <div class="folder-tab"></div>
                        <div class="folder-body">
                            <div class="folder-dots">
                                <i class="fa-solid fa-ellipsis-vertical"></i>
                            </div>
                            <h6 class="fw-bold text-dark mb-0"
                                style="font-size: 1.05rem; letter-spacing: -0.3px;">${cat.name}</h6>
                            <small class="text-muted"
                                style="font-size: 0.8rem; opacity: 0.8;">View resources</small>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- ===== SCRIPTS ===== -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Dashboard loaded, loading notifications...');
            loadNotifications();

            var markAllBtn = document.getElementById('markAllReadBtn');
            if (markAllBtn) {
                markAllBtn.addEventListener('click', function() {
                    markAllAsRead();
                });
            }

            // Auto refresh every 30 seconds
            setInterval(loadNotifications, 30000);
        });

        /**
         * Load notifications from server
         */
        function loadNotifications() {
            var url = '${pageContext.request.contextPath}/notifications/recent?limit=10';
            console.log('Fetching notifications from:', url);
            
            fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                },
                credentials: 'same-origin'
            })
            .then(function(response) {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                console.log('Notifications data:', data);
                if (data.authenticated && data.success) {
                    renderNotifications(data.notifications, data.unreadCount);
                    updateBadge(data.unreadCount);
                } else {
                    console.log('Error loading notifications:', data.message);
                    document.getElementById('notificationList').innerHTML = 
                        '<div class="text-center py-4 text-danger">' +
                        '<i class="fa-regular fa-circle-exclamation"></i>' +
                        '<p class="mb-0">' + (data.message || 'Failed to load notifications') + '</p>' +
                        '</div>';
                }
            })
            .catch(function(error) {
                console.error('Error loading notifications:', error);
                document.getElementById('notificationList').innerHTML = 
                    '<div class="text-center py-4 text-danger">' +
                    '<i class="fa-regular fa-circle-exclamation"></i>' +
                    '<p class="mb-0">Failed to load notifications</p>' +
                    '<small>' + error.message + '</small>' +
                    '</div>';
            });
        }

        /**
         * Render notifications in the dropdown
         */
        function renderNotifications(notifications, unreadCount) {
            var container = document.getElementById('notificationList');
            var badge = document.getElementById('notifCountBadge');

            if (badge) {
                badge.textContent = unreadCount;
                badge.style.display = unreadCount > 0 ? 'inline-block' : 'none';
            }

            if (!notifications || notifications.length === 0) {
                container.innerHTML = '<div class="notification-empty">' +
                    '<i class="fa-regular fa-bell-slash"></i>' +
                    '<p class="mb-0">No notifications yet</p>' +
                    '<small class="text-muted">You\'ll see notifications here when someone interacts with your content</small>' +
                    '</div>';
                return;
            }

            var html = '';
            var iconMap = {
                'LIKE': 'fa-regular fa-heart like',
                'COMMENT': 'fa-regular fa-comment comment',
                'REPLY': 'fa-regular fa-comment-dots reply',
                'REVIEW': 'fa-regular fa-star review',
                'FOLLOW': 'fa-regular fa-user-plus follow',
                'ANNOUNCEMENT': 'fa-regular fa-bullhorn announcement',
                'BAN': 'fa-solid fa-ban ban',
                'REPORT': 'fa-regular fa-flag report',
                'NEW_SHEET': 'fa-regular fa-file-lines new_sheet'
            };

            for (var i = 0; i < notifications.length; i++) {
                var notif = notifications[i];
                var iconClass = iconMap[notif.type] || 'fa-regular fa-circle';
                var isUnread = !notif.read;
                var time = new Date(notif.createdAt);
                var timeStr = time.toLocaleString('en-US', {
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                });
                var iconParts = iconClass.split(' ');
                var iconName = iconParts[0];
                var iconType = iconParts.length > 1 ? iconParts[1] : '';

                var unreadClass = isUnread ? 'unread' : '';
                var boldClass = isUnread ? 'fw-bold' : '';
                var readBadge = !isUnread ? '<span class="badge bg-secondary ms-1" style="font-size: 0.5rem;">Read</span>' : '';
                var markBtn = isUnread ? '<button class="mark-read-btn" data-id="' + notif.id + '" title="Mark as read"><i class="fa-regular fa-check"></i></button>' : '';

                html += '<div class="notification-item ' + unreadClass + '" data-id="' + notif.id + '">' +
                    '<div class="d-flex align-items-start gap-3">' +
                    '<div class="notif-icon ' + iconType + '">' +
                    '<i class="' + iconName + '"></i>' +
                    '</div>' +
                    '<div class="flex-grow-1">' +
                    '<div class="' + boldClass + '" style="font-size: 0.9rem;">' + notif.message + '</div>' +
                    '<small class="notif-time">' +
                    '<i class="fa-regular fa-clock me-1"></i>' + timeStr +
                    '</small>' +
                    readBadge +
                    '</div>' +
                    '<div>' + markBtn + '</div>' +
                    '</div>' +
                    '</div>';
            }

            container.innerHTML = html;

            // Add event listeners for mark as read buttons
            var readBtns = container.querySelectorAll('.mark-read-btn');
            for (var j = 0; j < readBtns.length; j++) {
                readBtns[j].addEventListener('click', function(e) {
                    e.stopPropagation();
                    var id = this.getAttribute('data-id');
                    markAsRead(id);
                });
            }

            // Click on notification to view details
            var items = container.querySelectorAll('.notification-item');
            for (var k = 0; k < items.length; k++) {
                items[k].addEventListener('click', function() {
                    var id = this.getAttribute('data-id');
                    window.location.href = '${pageContext.request.contextPath}/notifications/view/' + id;
                });
            }
        }

        /**
         * Mark a notification as read
         */
        function markAsRead(id) {
            fetch('${pageContext.request.contextPath}/notifications/mark-read/' + id, {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    loadNotifications();
                }
            })
            .catch(function(error) {
                console.error('Error marking as read:', error);
            });
        }

        /**
         * Mark all notifications as read
         */
        function markAllAsRead() {
            fetch('${pageContext.request.contextPath}/notifications/mark-all-read', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    loadNotifications();
                }
            })
            .catch(function(error) {
                console.error('Error marking all as read:', error);
            });
        }

        /**
         * Update the notification badge count
         */
        function updateBadge(count) {
            var badge = document.getElementById('unreadBadge');
            var bell = document.querySelector('.bell-icon');

            if (count > 0) {
                if (badge) {
                    badge.textContent = count;
                    badge.style.display = 'flex';
                } else {
                    var newBadge = document.createElement('span');
                    newBadge.className = 'notif-badge';
                    newBadge.id = 'unreadBadge';
                    newBadge.textContent = count;
                    document.querySelector('.bell-icon').appendChild(newBadge);
                }
                if (bell) {
                    bell.classList.add('has-notif');
                }
            } else {
                if (badge) {
                    badge.style.display = 'none';
                }
                if (bell) {
                    bell.classList.remove('has-notif');
                }
            }
        }
    </script>
</body>
</html>