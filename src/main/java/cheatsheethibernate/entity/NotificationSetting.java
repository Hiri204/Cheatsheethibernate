package cheatsheethibernate.entity;

import javax.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@NoArgsConstructor
@Table(name = "notification_settings")
public class NotificationSetting {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "setting_id")
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "like_notifications", nullable = false)
    private boolean likeNotifications = true;

    @Column(name = "comment_notifications", nullable = false)
    private boolean commentNotifications = true;

    @Column(name = "reply_notifications", nullable = false)
    private boolean replyNotifications = true;

    @Column(name = "review_notifications", nullable = false)
    private boolean reviewNotifications = true;

    @Column(name = "follow_notifications", nullable = false)
    private boolean followNotifications = true;

    @Column(name = "announcement_notifications", nullable = false)
    private boolean announcementNotifications = true;

    @Column(name = "ban_notifications", nullable = false)
    private boolean banNotifications = true;

    @Column(name = "report_notifications", nullable = false)
    private boolean reportNotifications = true;

    @Column(name = "new_sheet_notifications", nullable = false)
    private boolean newSheetNotifications = true;

    @Column(name = "email_notifications", nullable = false)
    private boolean emailNotifications = true;

    // 🎯 ADD THESE MISSING FIELDS
    @Column(name = "frequency")
    private Integer frequency = 5;

    @Column(name = "banner_style", length = 20)
    private String bannerStyle = "default";

    @Column(name = "quiet_from")
    private String quietFrom = "22:00";

    @Column(name = "quiet_to")
    private String quietTo = "07:00";

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    @PrePersist
    protected void onCreate() {
        this.updatedAt = LocalDateTime.now();
        if (this.frequency == null) {
            this.frequency = 5;
        }
        if (this.bannerStyle == null) {
            this.bannerStyle = "default";
        }
        if (this.quietFrom == null) {
            this.quietFrom = "22:00";
        }
        if (this.quietTo == null) {
            this.quietTo = "07:00";
        }
    }

    // ===== Getters and Setters for new fields =====
    
    public Integer getFrequency() {
        return frequency;
    }

    public void setFrequency(Integer frequency) {
        this.frequency = frequency;
    }

    public String getBannerStyle() {
        return bannerStyle;
    }

    public void setBannerStyle(String bannerStyle) {
        this.bannerStyle = bannerStyle;
    }

    public String getQuietFrom() {
        return quietFrom;
    }

    public void setQuietFrom(String quietFrom) {
        this.quietFrom = quietFrom;
    }

    public String getQuietTo() {
        return quietTo;
    }

    public void setQuietTo(String quietTo) {
        this.quietTo = quietTo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public boolean isLikeNotifications() {
        return likeNotifications;
    }

    public void setLikeNotifications(boolean likeNotifications) {
        this.likeNotifications = likeNotifications;
    }

    public boolean isCommentNotifications() {
        return commentNotifications;
    }

    public void setCommentNotifications(boolean commentNotifications) {
        this.commentNotifications = commentNotifications;
    }

    public boolean isReplyNotifications() {
        return replyNotifications;
    }

    public void setReplyNotifications(boolean replyNotifications) {
        this.replyNotifications = replyNotifications;
    }

    public boolean isReviewNotifications() {
        return reviewNotifications;
    }

    public void setReviewNotifications(boolean reviewNotifications) {
        this.reviewNotifications = reviewNotifications;
    }

    public boolean isFollowNotifications() {
        return followNotifications;
    }

    public void setFollowNotifications(boolean followNotifications) {
        this.followNotifications = followNotifications;
    }

    public boolean isAnnouncementNotifications() {
        return announcementNotifications;
    }

    public void setAnnouncementNotifications(boolean announcementNotifications) {
        this.announcementNotifications = announcementNotifications;
    }

    public boolean isBanNotifications() {
        return banNotifications;
    }

    public void setBanNotifications(boolean banNotifications) {
        this.banNotifications = banNotifications;
    }

    public boolean isReportNotifications() {
        return reportNotifications;
    }

    public void setReportNotifications(boolean reportNotifications) {
        this.reportNotifications = reportNotifications;
    }

    public boolean isNewSheetNotifications() {
        return newSheetNotifications;
    }

    public void setNewSheetNotifications(boolean newSheetNotifications) {
        this.newSheetNotifications = newSheetNotifications;
    }

    public boolean isEmailNotifications() {
        return emailNotifications;
    }

    public void setEmailNotifications(boolean emailNotifications) {
        this.emailNotifications = emailNotifications;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}