<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Notifications · DevSheets</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
body {
    background-color: #f8f9fa;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

.main-content {
    margin-left: 260px;
    padding: 40px 50px;
    min-height: 100vh;
}

.notification-card {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
    overflow: hidden;
}

.notification-card .card-header {
    background: transparent;
    border-bottom: 1px solid #f0f0f0;
    padding: 20px 24px;
}

.notification-item {
    padding: 16px 24px;
    border-bottom: 1px solid #f5f5f5;
    transition: background 0.2s;
    cursor: pointer;
}

.notification-item:hover {
    background: #f8f9fa;
}

.notification-item.unread {
    background: #f0f7ff;
    border-left: 4px solid #0d6efd;
}

.notification-item .notif-icon {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    font-size: 1rem;
}

.notif-icon.like { background: #ffebee; color: #e74c3c; }
.notif-icon.comment { background: #e3f2fd; color: #1976d2; }
.notif-icon.reply { background: #f3e5f5; color: #7b1fa2; }
.notif-icon.review { background: #fff3e0; color: #e65100; }
.notif-icon.follow { background: #e8f5e9; color: #2e7d32; }
.notif-icon.announcement { background: #fff8e1; color: #f57f17; }
.notif-icon.ban { background: #fce4ec; color: #c62828; }
.notif-icon.report { background: #fbe9e7; color: #bf360c; }
.notif-icon.new_sheet { background: #e8f5e9; color: #388e3c; }

.notif-time {
    font-size: 0.75rem;
    color: #9e9e9e;
}

.btn-reply {
    border-radius: 20px;
    font-size: 0.75rem;
    padding: 4px 16px;
}

.notification-empty {
    padding: 60px 20px;
    text-align: center;
    color: #999;
}

.notification-empty i {
    font-size: 3rem;
    margin-bottom: 16px;
    display: block;
    color: #ddd;
}

.filter-btn {
    border-radius: 20px;
    font-size: 0.8rem;
    padding: 6px 18px;
}

.filter-btn.active {
    background: #0d6efd;
    color: white;
    border-color: #0d6efd;
}

.reply-box {
    display: none;
    margin-top: 12px;
    padding: 12px;
    background: #f8f9fa;
    border-radius: 12px;
}

.reply-box.show {
    display: block;
}

/* Loading spinner */
.spinner-overlay {
    display: none;
    text-align: center;
    padding: 30px;
}

.spinner-overlay.show {
    display: block;
}
</style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="notifications" />
    </jsp:include>

    <div class="main-content">
        <!-- Page Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="fa-regular fa-bell me-2"></i>Notifications
                </h4>
                <p class="text-muted small mb-0">
                    Stay updated with all your activity
                    <span class="badge bg-secondary ms-2" id="totalCount">${fn:length(notifications)}</span>
                </p>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary btn-sm rounded-pill px-3" id="markAllReadBtn">
                    <i class="fa-regular fa-check-circle me-1"></i> Mark all as read
                </button>
                <button class="btn btn-outline-danger btn-sm rounded-pill px-3" id="clearAllBtn">
                    <i class="fa-regular fa-trash-can me-1"></i> Clear all
                </button>
            </div>
        </div>

        <!-- Filters -->
        <div class="d-flex flex-wrap gap-2 mb-4">
            <button class="filter-btn btn btn-outline-secondary active" data-filter="all">All</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="unread">Unread</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="LIKE">Likes</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="COMMENT">Comments</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="REPLY">Replies</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="REVIEW">Reviews</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="FOLLOW">Follows</button>
            <button class="filter-btn btn btn-outline-secondary" data-filter="ANNOUNCEMENT">Announcements</button>
        </div>

        <!-- Notification List -->
        <div class="notification-card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span class="fw-semibold">
                    <i class="fa-regular fa-clock me-2"></i>Recent Activity
                </span>
                <div>
                    <select class="form-select form-select-sm" id="sortSelect" style="width: auto; border-radius: 20px;">
                        <option value="newest">Newest first</option>
                        <option value="oldest">Oldest first</option>
                    </select>
                </div>
            </div>

            <div id="notificationList">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="notification-empty">
                            <i class="fa-regular fa-bell-slash"></i>
                            <h5 class="fw-bold">No notifications yet</h5>
                            <p class="text-muted small">You'll see notifications here when someone interacts with your content</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${notifications}" var="notif">
                            <div class="notification-item ${notif.unread ? 'unread' : ''}" 
                                 data-id="${notif.id}" data-type="${notif.type}" data-read="${notif.unread ? 'false' : 'true'}">
                                <div class="d-flex align-items-start gap-3">
                                    <div class="notif-icon ${fn:toLowerCase(notif.type)}">
                                        <c:choose>
                                            <c:when test="${notif.type == 'LIKE'}"><i class="fa-regular fa-heart"></i></c:when>
                                            <c:when test="${notif.type == 'COMMENT'}"><i class="fa-regular fa-comment"></i></c:when>
                                            <c:when test="${notif.type == 'REPLY'}"><i class="fa-regular fa-comment-dots"></i></c:when>
                                            <c:when test="${notif.type == 'REVIEW'}"><i class="fa-regular fa-star"></i></c:when>
                                            <c:when test="${notif.type == 'FOLLOW'}"><i class="fa-regular fa-user-plus"></i></c:when>
                                            <c:when test="${notif.type == 'ANNOUNCEMENT'}"><i class="fa-regular fa-bullhorn"></i></c:when>
                                            <c:when test="${notif.type == 'BAN'}"><i class="fa-solid fa-ban"></i></c:when>
                                            <c:when test="${notif.type == 'REPORT'}"><i class="fa-regular fa-flag"></i></c:when>
                                            <c:otherwise><i class="fa-regular fa-circle"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="${notif.unread ? 'fw-bold' : ''}" style="font-size: 0.95rem;">
                                            ${notif.message}
                                        </div>
                                        <div class="d-flex align-items-center gap-2 mt-1">
                                            <span class="notif-time">
                                                <i class="fa-regular fa-clock me-1"></i>
                                                <%-- 🎯 FIX: Use EL to display LocalDateTime directly --%>
                                                ${notif.createdAt}
                                            </span>
                                            <c:if test="${notif.unread}">
                                                <span class="badge bg-primary" style="font-size: 0.6rem;">New</span>
                                            </c:if>
                                        </div>

                                        <!-- Reply/Interaction buttons based on type -->
                                        <c:if test="${notif.type == 'COMMENT' or notif.type == 'REPLY'}">
                                            <button class="btn btn-sm btn-outline-primary btn-reply mt-2 reply-toggle"
                                                    data-id="${notif.id}">
                                                <i class="fa-regular fa-reply me-1"></i> Reply
                                            </button>
                                            <div class="reply-box" id="replyBox_${notif.id}">
                                                <form class="reply-form" data-id="${notif.id}">
                                                    <div class="d-flex gap-2">
                                                        <input type="text" class="form-control form-control-sm"
                                                               placeholder="Write a reply..." name="replyContent"
                                                               style="border-radius: 20px;">
                                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill">
                                                            <i class="fa-regular fa-paper-plane me-1"></i>Send
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div>
                                        <c:if test="${notif.unread}">
                                            <button class="btn btn-sm btn-outline-secondary mark-read-btn"
                                                    style="border-radius: 50%; width: 30px; height: 30px; padding: 0; font-size: 0.65rem;"
                                                    data-id="${notif.id}" title="Mark as read">
                                                <i class="fa-regular fa-check"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn btn-sm btn-outline-danger delete-btn"
                                                style="border-radius: 50%; width: 30px; height: 30px; padding: 0; font-size: 0.65rem;"
                                                data-id="${notif.id}" title="Delete">
                                            <i class="fa-regular fa-xmark"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Load More -->
            <div class="text-center py-3 border-top" id="loadMoreSection">
                <button class="btn btn-outline-secondary rounded-pill px-4" id="loadMoreBtn">
                    <i class="fa-regular fa-arrow-down me-1"></i> Load more
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        let currentFilter = 'all';
        let currentSort = 'newest';
        let page = 0;
        const limit = 20;

        document.addEventListener('DOMContentLoaded', function() {
            console.log('Notifications page loaded');

            // Filter buttons
            document.querySelectorAll('.filter-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    document.querySelectorAll('.filter-btn').forEach(function(b) {
                        b.classList.remove('active');
                    });
                    this.classList.add('active');
                    currentFilter = this.dataset.filter;
                    page = 0;
                    loadNotifications();
                });
            });

            // Sort select
            document.getElementById('sortSelect').addEventListener('change', function() {
                currentSort = this.value;
                page = 0;
                loadNotifications();
            });

            // Mark all as read
            document.getElementById('markAllReadBtn').addEventListener('click', function() {
                markAllAsRead();
            });

            // Clear all
            document.getElementById('clearAllBtn').addEventListener('click', function() {
                if (confirm('Are you sure you want to delete all notifications?')) {
                    deleteAllNotifications();
                }
            });

            // Load more
            document.getElementById('loadMoreBtn').addEventListener('click', function() {
                page++;
                loadNotifications(true);
            });

            // Initial load
            loadNotifications();
        });

        function loadNotifications(append) {
            var url = '${pageContext.request.contextPath}/notifications/recent?limit=' + limit + '&page=' + page;

            fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                },
                credentials: 'same-origin'
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                if (data.success && data.authenticated) {
                    renderNotifications(data.notifications, data.unreadCount, append);
                    updateTotalCount(data.totalCount);
                } else {
                    console.log('Error loading notifications:', data.message);
                }
            })
            .catch(function(error) {
                console.error('Error loading notifications:', error);
            });
        }

        function renderNotifications(notifications, unreadCount, append) {
            var container = document.getElementById('notificationList');
            var badge = document.getElementById('notifCountBadge');

            if (badge) {
                badge.textContent = unreadCount;
                badge.style.display = unreadCount > 0 ? 'inline-block' : 'none';
            }

            if (!notifications || notifications.length === 0) {
                if (!append) {
                    container.innerHTML = '<div class="notification-empty">' +
                        '<i class="fa-regular fa-bell-slash"></i>' +
                        '<h5 class="fw-bold">No notifications yet</h5>' +
                        '<p class="text-muted small">You\'ll see notifications here when someone interacts with your content</p>' +
                        '</div>';
                } else {
                    document.getElementById('loadMoreBtn').style.display = 'none';
                }
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

            var iconNames = {
                'LIKE': 'fa-regular fa-heart',
                'COMMENT': 'fa-regular fa-comment',
                'REPLY': 'fa-regular fa-comment-dots',
                'REVIEW': 'fa-regular fa-star',
                'FOLLOW': 'fa-regular fa-user-plus',
                'ANNOUNCEMENT': 'fa-regular fa-bullhorn',
                'BAN': 'fa-solid fa-ban',
                'REPORT': 'fa-regular fa-flag',
                'NEW_SHEET': 'fa-regular fa-file-lines'
            };

            for (var i = 0; i < notifications.length; i++) {
                var notif = notifications[i];
                var iconClass = iconMap[notif.type] || 'fa-regular fa-circle';
                var isUnread = !notif.read;
                var timeStr = notif.createdAt || '';
                var iconParts = iconClass.split(' ');
                var iconName = iconParts[0] || 'fa-regular fa-circle';
                var iconType = iconParts.length > 1 ? iconParts[1] : '';

                var unreadClass = isUnread ? 'unread' : '';
                var boldClass = isUnread ? 'fw-bold' : '';
                var readBadge = !isUnread ? '<span class="badge bg-secondary ms-1" style="font-size: 0.5rem;">Read</span>' : '';
                var markBtn = isUnread ? '<button class="btn btn-sm btn-outline-secondary mark-read-btn" style="border-radius: 50%; width: 30px; height: 30px; padding: 0; font-size: 0.65rem;" data-id="' + notif.id + '" title="Mark as read"><i class="fa-regular fa-check"></i></button>' : '';

                html += '<div class="notification-item ' + unreadClass + '" data-id="' + notif.id + '">' +
                    '<div class="d-flex align-items-start gap-3">' +
                    '<div class="notif-icon ' + iconType + '">' +
                    '<i class="' + iconName + '"></i>' +
                    '</div>' +
                    '<div class="flex-grow-1">' +
                    '<div class="' + boldClass + '" style="font-size: 0.95rem;">' + notif.message + '</div>' +
                    '<div class="d-flex align-items-center gap-2 mt-1">' +
                    '<span class="notif-time">' +
                    '<i class="fa-regular fa-clock me-1"></i>' + timeStr +
                    '</span>' +
                    readBadge +
                    '</div>' +
                    '</div>' +
                    '<div>' + markBtn +
                    '<button class="btn btn-sm btn-outline-danger delete-btn" style="border-radius: 50%; width: 30px; height: 30px; padding: 0; font-size: 0.65rem;" data-id="' + notif.id + '" title="Delete"><i class="fa-regular fa-xmark"></i></button>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (append) {
                container.innerHTML += html;
            } else {
                container.innerHTML = html;
            }

            // Add event listeners for mark as read buttons
            document.querySelectorAll('.mark-read-btn').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    var id = this.dataset.id;
                    markAsRead(id);
                });
            });

            // Add event listeners for delete buttons
            document.querySelectorAll('.delete-btn').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    var id = this.dataset.id;
                    if (confirm('Delete this notification?')) {
                        deleteNotification(id);
                    }
                });
            });

            // Click on notification to view details
            document.querySelectorAll('.notification-item').forEach(function(item) {
                item.addEventListener('click', function() {
                    var id = this.dataset.id;
                    window.location.href = '${pageContext.request.contextPath}/notifications/view/' + id;
                });
            });

            // Reply toggle
            document.querySelectorAll('.reply-toggle').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    var replyBox = document.getElementById('replyBox_' + this.dataset.id);
                    if (replyBox) {
                        replyBox.classList.toggle('show');
                    }
                });
            });

            // Reply form submit
            document.querySelectorAll('.reply-form').forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var id = this.dataset.id;
                    var content = this.querySelector('input[name="replyContent"]').value.trim();
                    if (content) {
                        submitReply(id, content);
                    }
                });
            });

            // Check if more notifications to load
            if (notifications.length < limit) {
                document.getElementById('loadMoreBtn').style.display = 'none';
            } else {
                document.getElementById('loadMoreBtn').style.display = 'inline-block';
            }
        }

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

        function deleteNotification(id) {
            fetch('${pageContext.request.contextPath}/notifications/delete/' + id, {
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
                console.error('Error deleting notification:', error);
            });
        }

        function deleteAllNotifications() {
            fetch('${pageContext.request.contextPath}/notifications/delete-all', {
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
                console.error('Error deleting all notifications:', error);
            });
        }

        function submitReply(id, content) {
            fetch('${pageContext.request.contextPath}/notifications/reply/' + id, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'content=' + encodeURIComponent(content)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    var replyBox = document.getElementById('replyBox_' + id);
                    if (replyBox) {
                        replyBox.classList.remove('show');
                        replyBox.querySelector('input[name="replyContent"]').value = '';
                    }
                    loadNotifications();
                }
            })
            .catch(function(error) {
                console.error('Error submitting reply:', error);
            });
        }

        function updateTotalCount(count) {
            var totalCount = document.getElementById('totalCount');
            if (totalCount) {
                totalCount.textContent = count;
            }
        }
    </script>
</body>
</html>