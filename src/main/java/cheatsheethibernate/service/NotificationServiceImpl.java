package cheatsheethibernate.service;

import cheatsheethibernate.entity.Notification;
import cheatsheethibernate.entity.Notification.NotificationType;
import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private NotificationSettingService notificationSettingService;

    // ===== Notification Creation =====

    @Override
    public void createNotification(User user, NotificationType type, String message,
                                   String entityType, Long entityId, Integer actorId) {
        createNotification(user, type, message, entityType, entityId, actorId, null);
    }

    @Override
    public void createNotification(User user, NotificationType type, String message,
                                   String entityType, Long entityId, Integer actorId, String linkUrl) {
        if (user == null) {
            return;
        }

        // 🎯 CHECK: Check if user has this notification type enabled
        if (!notificationSettingService.isNotificationEnabled(user, type.name())) {
            return;
        }

        // Don't notify if actor is the same as the target user (self-action)
        if (actorId != null && actorId.equals(user.getUserId())) {
            return;
        }

        // 🎯 FIX: Ensure message is not null
        if (message == null || message.trim().isEmpty()) {
            message = "You have a new notification";
        }

        // Check if duplicate notification already exists (within last 5 minutes)
        if (hasRecentNotification(user, entityType, entityId, 5)) {
            return;
        }

        Notification notification = new Notification();
        notification.setUser(user);
        notification.setType(type);
        notification.setMessage(message.trim());
        notification.setEntityType(entityType);
        notification.setEntityId(entityId);
        notification.setActorId(actorId);
        notification.setLinkUrl(linkUrl);
        notification.setRead(false);
        notification.setCreatedAt(LocalDateTime.now());

        notificationRepository.save(notification);
    }

    private boolean hasRecentNotification(User user, String entityType, Long entityId, int minutes) {
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(minutes);
        List<Notification> existing = notificationRepository
                .findByUserAndEntityTypeAndEntityId(user, entityType, entityId);
        return existing.stream().anyMatch(n -> n.getCreatedAt().isAfter(cutoff));
    }

    // ===== Specific Notification Creators =====

    @Override
    public void notifyLike(User targetUser, User actor, String entityType, Long entityId) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " liked your " + entityType;
        createNotification(targetUser, NotificationType.LIKE, message, entityType, entityId, actor.getUserId());
    }

    @Override
    public void notifyComment(User targetUser, User actor, String entityType, Long entityId) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " commented on your " + entityType;
        createNotification(targetUser, NotificationType.COMMENT, message, entityType, entityId, actor.getUserId());
    }

    @Override
    public void notifyReply(User targetUser, User actor, String entityType, Long entityId) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " replied to your comment on " + entityType;
        createNotification(targetUser, NotificationType.REPLY, message, entityType, entityId, actor.getUserId());
    }

    @Override
    public void notifyReview(User targetUser, User actor, String entityType, Long entityId) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " reviewed your " + entityType;
        createNotification(targetUser, NotificationType.REVIEW, message, entityType, entityId, actor.getUserId());
    }

    @Override
    public void notifyNewSheet(User targetUser, User actor, String entityType, Long entityId) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " published a new " + entityType;
        createNotification(targetUser, NotificationType.NEW_SHEET, message, entityType, entityId, actor.getUserId());
    }

    @Override
    public void notifyAnnouncement(User targetUser, String message) {
        if (targetUser == null) return;
        if (message == null || message.trim().isEmpty()) {
            message = "New announcement from admin";
        }
        createNotification(targetUser, NotificationType.ANNOUNCEMENT, message, "announcement", null, null);
    }

    @Override
    public void notifyBan(User targetUser, String reason) {
        if (targetUser == null) return;
        String message = "Your account has been suspended. Reason: " + (reason != null ? reason : "No reason provided");
        createNotification(targetUser, NotificationType.BAN, message, "account", null, null);
    }

    @Override
    public void notifyReport(User targetUser, String reportReason) {
        if (targetUser == null) return;
        String message = "A report has been submitted: " + (reportReason != null ? reportReason : "No reason provided");
        createNotification(targetUser, NotificationType.REPORT, message, "report", null, null);
    }

    @Override
    public void notifyFollow(User targetUser, User actor) {
        if (targetUser == null || actor == null) return;
        String message = actor.getUsername() + " started following you";
        createNotification(targetUser, NotificationType.FOLLOW, message, "follow", null, actor.getUserId());
    }

    // ===== Notification Retrieval =====

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getNotificationsByUser(User user) {
        return notificationRepository.findByUser(user);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getUnreadNotificationsByUser(User user) {
        return notificationRepository.findUnreadByUser(user);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getRecentNotificationsByUser(User user, int limit) {
        return notificationRepository.getRecentByUser(user, limit);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getRecentUnreadByUser(User user, int limit) {
        return notificationRepository.getRecentUnreadByUser(user, limit);
    }

    @Override
    @Transactional(readOnly = true)
    public Notification getNotificationById(Long id) {
        if (id == null) {
            return null;
        }
        return notificationRepository.findById(id);
    }

    // 🎯 FIX: getUnreadCount() with settings filter
    @Override
    @Transactional(readOnly = true)
    public long getUnreadCount(User user) {
        if (user == null) return 0;
        
        // Get all unread notifications
        List<Notification> unreadNotifications = notificationRepository.findUnreadByUser(user);
        if (unreadNotifications.isEmpty()) {
            return 0;
        }
        
        // 🎯 Get user's notification settings
        NotificationSetting settings = notificationSettingService.getSettingsByUser(user);
        if (settings == null) {
            return unreadNotifications.size(); // Default: show all
        }
        
        // 🎯 Filter based on settings
        long count = 0;
        for (Notification notif : unreadNotifications) {
            if (shouldSendNotification(settings, notif.getType())) {
                count++;
            }
        }
        
        return count;
    }

    // 🎯 Helper method to check if notification should be sent
    private boolean shouldSendNotification(NotificationSetting settings, NotificationType type) {
        if (settings == null) {
            return true;
        }
        
        switch (type) {
            case LIKE:
                return settings.isLikeNotifications();
            case COMMENT:
                return settings.isCommentNotifications();
            case REPLY:
                return settings.isReplyNotifications();
            case REVIEW:
                return settings.isReviewNotifications();
            case FOLLOW:
                return settings.isFollowNotifications();
            case ANNOUNCEMENT:
                return settings.isAnnouncementNotifications();
            case BAN:
                return settings.isBanNotifications();
            case REPORT:
                return settings.isReportNotifications();
            case NEW_SHEET:
                return settings.isNewSheetNotifications();
            default:
                return true;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount(User user) {
        if (user == null) return 0;
        return notificationRepository.countByUserAndIsRead(user, false) +
               notificationRepository.countByUserAndIsRead(user, true);
    }

    // ===== Notification Management =====

    @Override
    public void markAsRead(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId);
        if (notification != null) {
            notification.markAsRead();
            notificationRepository.save(notification);
        }
    }

    @Override
    public void markAllAsRead(User user) {
        if (user != null) {
            notificationRepository.markAllAsReadByUser(user);
        }
    }

    @Override
    public void markAllAsReadByType(User user, NotificationType type) {
        if (user != null && type != null) {
            notificationRepository.markAllAsReadByUserAndType(user, type);
        }
    }

    @Override
    public void deleteNotification(Long notificationId) {
        notificationRepository.delete(notificationId);
    }

    @Override
    public void deleteAllByUser(User user) {
        if (user != null) {
            notificationRepository.deleteAllByUser(user);
        }
    }

    @Override
    public void deleteOldNotifications(User user, int daysOld) {
        if (user != null) {
            LocalDateTime cutoff = LocalDateTime.now().minusDays(daysOld);
            notificationRepository.deleteAllOlderThan(user, cutoff);
        }
    }

    // ===== Statistics =====

    @Override
    @Transactional(readOnly = true)
    public Map<NotificationType, Long> getNotificationStats(User user) {
        if (user == null) return new HashMap<>();
        List<Object[]> results = notificationRepository.getNotificationStatsByUser(user);
        return results.stream()
                .collect(Collectors.toMap(
                        arr -> (NotificationType) arr[0],
                        arr -> (Long) arr[1]
                ));
    }

    @Override
    @Transactional(readOnly = true)
    public Map<NotificationType, Long> getGlobalNotificationStats() {
        List<Object[]> results = notificationRepository.getNotificationStatsByType();
        return results.stream()
                .collect(Collectors.toMap(
                        arr -> (NotificationType) arr[0],
                        arr -> (Long) arr[1]
                ));
    }

    // ===== Validation =====

    @Override
    @Transactional(readOnly = true)
    public boolean hasNotification(User user, String entityType, Long entityId) {
        if (user == null) return false;
        return !notificationRepository.findByUserAndEntityTypeAndEntityId(user, entityType, entityId).isEmpty();
    }
}