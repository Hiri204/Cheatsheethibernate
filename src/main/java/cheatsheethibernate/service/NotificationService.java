package cheatsheethibernate.service;

import cheatsheethibernate.entity.Notification;
import cheatsheethibernate.entity.Notification.NotificationType;
import cheatsheethibernate.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface NotificationService {

    // ===== Notification Creation =====
    void createNotification(User user, NotificationType type, String message, String entityType, Long entityId, Integer actorId);
    void createNotification(User user, NotificationType type, String message, String entityType, Long entityId, Integer actorId, String linkUrl);

    // ===== Specific Notification Creators =====
    void notifyLike(User targetUser, User actor, String entityType, Long entityId);
    void notifyComment(User targetUser, User actor, String entityType, Long entityId);
    void notifyReply(User targetUser, User actor, String entityType, Long entityId);
    void notifyReview(User targetUser, User actor, String entityType, Long entityId);
    void notifyNewSheet(User targetUser, User actor, String entityType, Long entityId);
    void notifyAnnouncement(User targetUser, String message);
    void notifyBan(User targetUser, String reason);
    void notifyReport(User targetUser, String reportReason);
    void notifyFollow(User targetUser, User actor);

    // ===== Notification Retrieval =====
    List<Notification> getNotificationsByUser(User user);
    List<Notification> getUnreadNotificationsByUser(User user);
    List<Notification> getRecentNotificationsByUser(User user, int limit);
    List<Notification> getRecentUnreadByUser(User user, int limit);
    Notification getNotificationById(Long id);  // 🎯 ADD THIS METHOD
    long getUnreadCount(User user);
    long getTotalCount(User user);

    // ===== Notification Management =====
    void markAsRead(Long notificationId);
    void markAllAsRead(User user);
    void markAllAsReadByType(User user, NotificationType type);
    void deleteNotification(Long notificationId);
    void deleteAllByUser(User user);
    void deleteOldNotifications(User user, int daysOld);

    // ===== Statistics =====
    Map<NotificationType, Long> getNotificationStats(User user);
    Map<NotificationType, Long> getGlobalNotificationStats();

    // ===== Validation =====
    boolean hasNotification(User user, String entityType, Long entityId);
}