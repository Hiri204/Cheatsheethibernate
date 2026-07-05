package cheatsheethibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.Table;

import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "announcements")
@Data
@NoArgsConstructor
public class Announcement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "created_by")
    private String createdBy;

    // 🎯 FIX: Use Boolean wrapper class instead of boolean primitive
    @Column(name = "is_active", columnDefinition = "BOOLEAN DEFAULT TRUE")
    private Boolean isActive = true;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.message == null || this.message.trim().isEmpty()) {
            this.message = this.content != null ? this.content : "📢 New announcement from admin";
        }
        // 🎯 FIX: Set default value if null
        if (this.isActive == null) {
            this.isActive = true;
        }
    }

    // Getter with null safety
    public String getMessage() {
        if (message != null && !message.trim().isEmpty()) {
            return message;
        }
        return content != null ? content : "📢 New announcement from admin";
    }

    public void setMessage(String message) {
        this.message = message != null ? message : "📢 New announcement from admin";
    }

    public String getTitle() {
        return title != null ? title : "Announcement";
    }

    public String getContent() {
        return content != null ? content : "";
    }

    // 🎯 FIX: Boolean getter with null safety
    public Boolean getIsActive() {
        return isActive != null ? isActive : true;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive != null ? isActive : true;
    }

    // 🎯 FIX: For JSP usage (JSTL expects isActive() method)
    public boolean isActive() {
        return isActive != null ? isActive : true;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }
}