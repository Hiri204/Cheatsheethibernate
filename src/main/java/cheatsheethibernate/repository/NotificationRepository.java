package cheatsheethibernate.repository;

import cheatsheethibernate.entity.Notification;
import cheatsheethibernate.entity.Notification.NotificationType;
import cheatsheethibernate.entity.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface NotificationRepository {

    // ===== Basic CRUD =====
    void save(Notification notification);
    Notification findById(Long id);
    Optional<Notification> findByIdOptional(Long id);
    List<Notification> findAll();
    void delete(Long id);
    void delete(Notification notification);
    long count();

    // ===== User-based Queries =====
    List<Notification> findByUser(User user);
    List<Notification> findByUserOrderByCreatedAtDesc(User user);
    List<Notification> findByUserAndIsRead(User user, boolean isRead);
    List<Notification> findUnreadByUser(User user);
    long countUnreadByUser(User user);
    long countByUserAndIsRead(User user, boolean isRead);

    // ===== Type-based Queries =====
    List<Notification> findByUserAndType(User user, NotificationType type);
    List<Notification> findByUserAndTypeIn(User user, List<NotificationType> types);

    // ===== Date-based Queries =====
    List<Notification> findByUserAndCreatedAtAfter(User user, LocalDateTime date);
    List<Notification> findByUserAndCreatedAtBetween(User user, LocalDateTime startDate, LocalDateTime endDate);

    // ===== Entity-based Queries =====
    List<Notification> findByEntityTypeAndEntityId(String entityType, Long entityId);
    List<Notification> findByUserAndEntityTypeAndEntityId(User user, String entityType, Long entityId);

    // ===== Bulk Operations =====
    int markAllAsReadByUser(User user);
    int markAllAsReadByUserAndType(User user, NotificationType type);
    int deleteAllByUser(User user);
    int deleteAllOlderThan(User user, LocalDateTime date);
    int deleteAllByEntityTypeAndEntityId(String entityType, Long entityId);

    // ===== Recent Queries =====
    List<Notification> getRecentByUser(User user, int limit);
    List<Notification> getRecentUnreadByUser(User user, int limit);

    // ===== Statistics =====
    List<Object[]> getNotificationStatsByUser(User user);
    List<Object[]> getNotificationStatsByType();
    long countByType(NotificationType type);
}