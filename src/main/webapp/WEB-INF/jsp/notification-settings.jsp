<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Notification Settings · DevSheets</title>

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

.settings-card {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
    overflow: hidden;
    max-width: 700px;
}

.settings-card .card-header {
    background: transparent;
    border-bottom: 1px solid #f0f0f0;
    padding: 24px 30px;
}

.settings-card .card-header h5 {
    font-weight: 700;
    font-size: 1.2rem;
}

.settings-card .card-header p {
    font-size: 0.9rem;
    color: #757575;
    margin-bottom: 0;
}

.settings-card .card-body {
    padding: 30px;
}

/* Setting Item */
.setting-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 0;
    border-bottom: 1px solid #f5f5f5;
}

.setting-item:last-child {
    border-bottom: none;
}

.setting-item .setting-info {
    display: flex;
    align-items: center;
    gap: 14px;
    flex: 1;
}

.setting-item .setting-icon {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.9rem;
    flex-shrink: 0;
}

.setting-item .setting-icon.like { background: #ffebee; color: #e74c3c; }
.setting-item .setting-icon.comment { background: #e3f2fd; color: #1976d2; }
.setting-item .setting-icon.reply { background: #f3e5f5; color: #7b1fa2; }
.setting-item .setting-icon.review { background: #fff3e0; color: #e65100; }
.setting-item .setting-icon.follow { background: #e8f5e9; color: #2e7d32; }
.setting-item .setting-icon.announcement { background: #fff8e1; color: #f57f17; }
.setting-item .setting-icon.ban { background: #fce4ec; color: #c62828; }
.setting-item .setting-icon.report { background: #fbe9e7; color: #bf360c; }
.setting-item .setting-icon.new_sheet { background: #e8f5e9; color: #388e3c; }
.setting-item .setting-icon.email { background: #e3f2fd; color: #1565c0; }

.setting-item .setting-name {
    font-weight: 500;
    font-size: 0.95rem;
    color: #1a1a1a;
}

.setting-item .setting-desc {
    font-size: 0.75rem;
    color: #999;
    margin-top: 2px;
}

/* Toggle Switch */
.switch {
    position: relative;
    display: inline-block;
    width: 48px;
    height: 26px;
    flex-shrink: 0;
}

.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: .3s;
    border-radius: 34px;
}

.slider:before {
    position: absolute;
    content: "";
    height: 18px;
    width: 18px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: .3s;
    border-radius: 50%;
}

input:checked + .slider {
    background-color: #1a1a1a;
}

input:checked + .slider:before {
    transform: translateX(22px);
}

.settings-section {
    margin-bottom: 24px;
}

.section-title {
    font-weight: 600;
    font-size: 1rem;
    color: #1a1a1a;
    margin-bottom: 4px;
}

.section-desc {
    font-size: 0.85rem;
    color: #9c9c9c;
    margin-bottom: 14px;
}

/* 🎯 REMOVED: toast-container and toast-message styles */

@media (max-width: 992px) {
    .main-content { margin-left: 0; padding: 20px; }
}

@media (max-width: 768px) {
    .main-content { padding: 15px; }
    .settings-card .card-header { padding: 20px; }
    .settings-card .card-body { padding: 20px; }
    .setting-item { flex-wrap: wrap; gap: 8px; }
}
</style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="settings" />
    </jsp:include>

    <div class="main-content">
        <!-- 🎯 REMOVED: toast-container -->

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="fa-regular fa-bell me-2"></i>Edit notifications
                </h4>
                <p class="text-muted small mb-0">Manage your notification preferences</p>
            </div>
            <a href="${pageContext.request.contextPath}/notifications" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                <i class="fa-regular fa-arrow-left me-1"></i> Back
            </a>
        </div>

        <div class="settings-card">
            <div class="card-header">
                <h5><i class="fa-regular fa-sliders me-2"></i>Notification Settings</h5>
                <p>Select the kinds of notifications you get about your activities and recommendations.</p>
            </div>

            <div class="card-body">
                <form id="settingsForm">
                    
                    <!-- EMAIL SECTION -->
                    <div class="settings-section">
                        <div class="section-title">
                            <i class="fa-regular fa-envelope me-2"></i>Email
                        </div>
                        <p class="section-desc">The latest update that enhances your experience and improves functionality of email notifications.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon email">
                                    <i class="fa-regular fa-envelope"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Email Notifications</div>
                                    <div class="setting-desc">Receive notifications via email</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="email" ${settings.emailNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- NOTIFICATION FREQUENCY -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-regular fa-clock me-2"></i>Notification Frequency
                        </div>
                        <p class="section-desc">Choose how often you receive notifications, ensuring you stay updated without being overwhelmed.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">Frequency</div>
                                    <div class="setting-desc">How often to receive notifications</div>
                                </div>
                            </div>
                            <select class="form-select form-select-sm" style="width: auto; border-radius: 20px; min-width: 100px;" id="frequencySelect">
                                <option value="5" ${settings.frequency == 5 ? 'selected' : ''}>5 min</option>
                                <option value="15" ${settings.frequency == 15 ? 'selected' : ''}>15 min</option>
                                <option value="30" ${settings.frequency == 30 ? 'selected' : ''}>30 min</option>
                                <option value="60" ${settings.frequency == 60 ? 'selected' : ''}>1 hour</option>
                                <option value="120" ${settings.frequency == 120 ? 'selected' : ''}>2 hours</option>
                            </select>
                        </div>
                    </div>

                    <!-- PRIORITY ALERTS -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-solid fa-circle-exclamation me-2"></i>Priority Alerts
                        </div>
                        <p class="section-desc">Select which types of notifications are most important for you to stay informed about.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon like">
                                    <i class="fa-regular fa-heart"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Likes</div>
                                    <div class="setting-desc">When someone likes your content</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="like" ${settings.likeNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon comment">
                                    <i class="fa-regular fa-comment"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Comments</div>
                                    <div class="setting-desc">When someone comments on your content</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="comment" ${settings.commentNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon reply">
                                    <i class="fa-regular fa-comment-dots"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Replies</div>
                                    <div class="setting-desc">When someone replies to your comment</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="reply" ${settings.replyNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon review">
                                    <i class="fa-regular fa-star"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Reviews</div>
                                    <div class="setting-desc">When someone reviews your content</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="review" ${settings.reviewNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon follow">
                                    <i class="fa-regular fa-user-plus"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Follows</div>
                                    <div class="setting-desc">When someone follows you</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="follow" ${settings.followNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon announcement">
                                    <i class="fa-regular fa-bullhorn"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Announcements</div>
                                    <div class="setting-desc">Admin announcements and updates</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="announcement" ${settings.announcementNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon ban">
                                    <i class="fa-solid fa-ban"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Bans</div>
                                    <div class="setting-desc">When your content or account is banned</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="ban" ${settings.banNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon report">
                                    <i class="fa-regular fa-flag"></i>
                                </div>
                                <div>
                                    <div class="setting-name">Reports</div>
                                    <div class="setting-desc">When your content is reported</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="report" ${settings.reportNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div class="setting-icon new_sheet">
                                    <i class="fa-regular fa-file-lines"></i>
                                </div>
                                <div>
                                    <div class="setting-name">New Sheets</div>
                                    <div class="setting-desc">When someone publishes a new cheat sheet</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="newSheet" ${settings.newSheetNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- QUIET HOURS -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-regular fa-moon me-2"></i>Quiet Hours
                        </div>
                        <p class="section-desc">Set specific times when notifications are muted to avoid disturbances during your downtime.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">From</div>
                                    <div class="setting-desc">Start time for quiet hours</div>
                                </div>
                            </div>
                            <input type="time" class="form-control form-control-sm" style="width: auto; border-radius: 20px; min-width: 120px;" id="quietFrom" value="${settings.quietFrom != null ? settings.quietFrom : '22:00'}">
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">To</div>
                                    <div class="setting-desc">End time for quiet hours</div>
                                </div>
                            </div>
                            <input type="time" class="form-control form-control-sm" style="width: auto; border-radius: 20px; min-width: 120px;" id="quietTo" value="${settings.quietTo != null ? settings.quietTo : '07:00'}">
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">Working hours</div>
                                    <div class="setting-desc">Enable quiet hours during working hours</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="workingHours" ${settings.emailNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- CUSTOM SOUND -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-regular fa-volume-high me-2"></i>Custom Sound
                        </div>
                        <p class="section-desc">Assign a unique sound to different types of notifications for easy identification.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">Snooze</div>
                                    <div class="setting-desc">Enable snooze for notifications</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="snooze" ${settings.reviewNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- BANNER STYLE -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-regular fa-window-maximize me-2"></i>Banner Style
                        </div>
                        <p class="section-desc">Pick the visual style of notification banners that suits your preferences.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">Style</div>
                                    <div class="setting-desc">Choose banner display style</div>
                                </div>
                            </div>
                            <select class="form-select form-select-sm" style="width: auto; border-radius: 20px; min-width: 120px;" id="bannerStyle">
                                <option value="default" ${settings.bannerStyle == 'default' ? 'selected' : ''}>Default</option>
                                <option value="compact" ${settings.bannerStyle == 'compact' ? 'selected' : ''}>Compact</option>
                                <option value="expanded" ${settings.bannerStyle == 'expanded' ? 'selected' : ''}>Expanded</option>
                                <option value="minimal" ${settings.bannerStyle == 'minimal' ? 'selected' : ''}>Minimal</option>
                            </select>
                        </div>
                    </div>

                    <!-- APP-SPECIFIC -->
                    <div class="settings-section border-top pt-3">
                        <div class="section-title">
                            <i class="fa-regular fa-apps me-2"></i>App-Specific Notifications
                        </div>
                        <p class="section-desc">Tailor notifications from each app according to your preferences and needs.</p>

                        <div class="setting-item">
                            <div class="setting-info">
                                <div>
                                    <div class="setting-name">All</div>
                                    <div class="setting-desc">Enable all app notifications</div>
                                </div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" name="allApps" ${settings.announcementNotifications ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 🎯 Auto-save on any change - NO TOAST MESSAGES
            const form = document.getElementById('settingsForm');
            const inputs = form.querySelectorAll('input, select');

            // Save initial state
            let initialStates = {};
            inputs.forEach(function(input) {
                if (input.type === 'checkbox') {
                    initialStates[input.name] = input.checked;
                } else {
                    initialStates[input.id] = input.value;
                }
            });

            inputs.forEach(function(input) {
                input.addEventListener('change', function() {
                    let isChanged = false;
                    if (this.type === 'checkbox') {
                        isChanged = initialStates[this.name] !== this.checked;
                        if (isChanged) {
                            initialStates[this.name] = this.checked;
                        }
                    } else {
                        isChanged = initialStates[this.id] !== this.value;
                        if (isChanged) {
                            initialStates[this.id] = this.value;
                        }
                    }
                    if (isChanged) {
                        saveSettings();
                    }
                });
            });

            // 🎯 SILENT SAVE - No toast messages
            function saveSettings() {
                const checkboxes = form.querySelectorAll('input[type="checkbox"]');

                let like = false;
                let comment = false;
                let reply = false;
                let review = false;
                let follow = false;
                let announcement = false;
                let ban = false;
                let report = false;
                let newSheet = false;
                let email = false;

                checkboxes.forEach(function(cb) {
                    const name = cb.name;
                    const checked = cb.checked;

                    if (name === 'email' || name === 'workingHours') {
                        email = email || checked;
                    } else if (name === 'like') {
                        like = checked;
                    } else if (name === 'comment') {
                        comment = checked;
                    } else if (name === 'reply') {
                        reply = checked;
                    } else if (name === 'review' || name === 'snooze') {
                        review = review || checked;
                    } else if (name === 'follow') {
                        follow = checked;
                    } else if (name === 'announcement' || name === 'allApps') {
                        announcement = announcement || checked;
                    } else if (name === 'ban') {
                        ban = checked;
                    } else if (name === 'report') {
                        report = checked;
                    } else if (name === 'newSheet') {
                        newSheet = checked;
                    }
                });

                const frequency = document.getElementById('frequencySelect').value;
                const bannerStyle = document.getElementById('bannerStyle').value;
                const quietFrom = document.getElementById('quietFrom').value;
                const quietTo = document.getElementById('quietTo').value;

                const formData = new URLSearchParams();
                formData.append('like', like ? 'true' : 'false');
                formData.append('comment', comment ? 'true' : 'false');
                formData.append('reply', reply ? 'true' : 'false');
                formData.append('review', review ? 'true' : 'false');
                formData.append('follow', follow ? 'true' : 'false');
                formData.append('announcement', announcement ? 'true' : 'false');
                formData.append('ban', ban ? 'true' : 'false');
                formData.append('report', report ? 'true' : 'false');
                formData.append('newSheet', newSheet ? 'true' : 'false');
                formData.append('email', email ? 'true' : 'false');
                formData.append('frequency', frequency);
                formData.append('bannerStyle', bannerStyle);
                formData.append('quietFrom', quietFrom);
                formData.append('quietTo', quietTo);

                fetch('${pageContext.request.contextPath}/notifications/settings/update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    // 🎯 SILENT: Do nothing, no toast messages
                    // Just log to console for debugging
                    if (data.success) {
                        console.log('✅ Settings saved successfully');
                    } else {
                        console.error('❌ Failed to save settings:', data.message);
                    }
                })
                .catch(function(error) {
                    console.error('❌ Error saving settings:', error);
                });
            }
        });
    </script>
</body>
</html>