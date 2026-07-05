package cheatsheethibernate.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "notifications", indexes = {
    @Index(name = "idx_notification_user", columnList = "user_id"),
    @Index(name = "idx_notification_is_read", columnList = "is_read"),
    @Index(name = "idx_notification_created_at", columnList = "created_at")
})
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Long id;

    // 🎯 FIX: LAZY ကနေ EAGER ပြောင်းပါ
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "type", nullable = false)
    @Enumerated(EnumType.STRING)
    private NotificationType type;

    @Column(name = "message", nullable = false, columnDefinition = "TEXT")
    private String message;

    @Column(name = "is_read", nullable = false)
    private boolean isRead = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "entity_type", length = 50)
    private String entityType;

    @Column(name = "entity_id")
    private Long entityId;

    @Column(name = "actor_id")
    private Integer actorId;

    @Column(name = "link_url", length = 255)
    private String linkUrl;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.message == null) {
            this.message = "New notification";
        }
        if (this.type == null) {
            this.type = NotificationType.ANNOUNCEMENT;
        }
    }

    public Notification(User user, NotificationType type, String message) {
        this.user = user;
        this.type = type;
        this.message = message != null ? message : "New notification";
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
    }

    public Notification(User user, NotificationType type, String message, String entityType, Long entityId, Integer actorId, String linkUrl) {
        this.user = user;
        this.type = type;
        this.message = message != null ? message : "New notification";
        this.entityType = entityType;
        this.entityId = entityId;
        this.actorId = actorId;
        this.linkUrl = linkUrl;
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
    }

    public enum NotificationType {
        LIKE, COMMENT, REPLY, REVIEW, NEW_SHEET, ANNOUNCEMENT, BAN, REPORT, FOLLOW
    }

    public boolean isUnread() {
        return !isRead;
    }

    public void markAsRead() {
        this.isRead = true;
    }

    public void markAsUnread() {
        this.isRead = false;
    }

    @Override
    public String toString() {
        return String.format("Notification{id=%d, type=%s, user=%s, isRead=%s, createdAt=%s}",
                id, type, user != null ? user.getUsername() : "null", isRead, createdAt);
    }
}