package cheatsheethibernate.service;

import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.repository.NotificationSettingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class NotificationSettingServiceImpl implements NotificationSettingService {

    @Autowired
    private NotificationSettingRepository notificationSettingRepository;

    @Override
    public NotificationSetting getSettingsByUser(User user) {
        if (user == null) return null;
        NotificationSetting setting = notificationSettingRepository.findByUser(user);
        if (setting == null) {
            setting = createDefaultSetting(user);
        }
        return setting;
    }

    @Override
    public void saveSettings(NotificationSetting settings) {
        if (settings != null) {
            notificationSettingRepository.save(settings);
        }
    }

    @Override
    public void updateSettings(User user, boolean like, boolean comment, boolean reply,
                               boolean review, boolean follow, boolean announcement,
                               boolean ban, boolean report, boolean newSheet, boolean email) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        
        NotificationSetting setting = getSettingsByUser(user);
        setting.setLikeNotifications(like);
        setting.setCommentNotifications(comment);
        setting.setReplyNotifications(reply);
        setting.setReviewNotifications(review);
        setting.setFollowNotifications(follow);
        setting.setAnnouncementNotifications(announcement);
        setting.setBanNotifications(ban);
        setting.setReportNotifications(report);
        setting.setNewSheetNotifications(newSheet);
        setting.setEmailNotifications(email);
        notificationSettingRepository.save(setting);
    }

    @Override
    public void updateSetting(User user, String settingName, boolean value) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        
        NotificationSetting setting = getSettingsByUser(user);
        
        switch (settingName.toLowerCase()) {
            case "like": setting.setLikeNotifications(value); break;
            case "comment": setting.setCommentNotifications(value); break;
            case "reply": setting.setReplyNotifications(value); break;
            case "review": setting.setReviewNotifications(value); break;
            case "follow": setting.setFollowNotifications(value); break;
            case "announcement": setting.setAnnouncementNotifications(value); break;
            case "ban": setting.setBanNotifications(value); break;
            case "report": setting.setReportNotifications(value); break;
            case "newsheet": setting.setNewSheetNotifications(value); break;
            case "email": setting.setEmailNotifications(value); break;
            default: throw new IllegalArgumentException("Unknown setting: " + settingName);
        }
        notificationSettingRepository.save(setting);
    }

    @Override
    public boolean isNotificationEnabled(User user, String type) {
        if (user == null) return true;
        
        NotificationSetting setting = getSettingsByUser(user);
        if (setting == null) return true;

        switch (type.toUpperCase()) {
            case "LIKE": return setting.isLikeNotifications();
            case "COMMENT": return setting.isCommentNotifications();
            case "REPLY": return setting.isReplyNotifications();
            case "REVIEW": return setting.isReviewNotifications();
            case "FOLLOW": return setting.isFollowNotifications();
            case "ANNOUNCEMENT": return setting.isAnnouncementNotifications();
            case "BAN": return setting.isBanNotifications();
            case "REPORT": return setting.isReportNotifications();
            case "NEW_SHEET": return setting.isNewSheetNotifications();
            default: return true;
        }
    }

    @Override
    public void createDefaultSettings(User user) {
        if (user == null) return;
        
        NotificationSetting existing = notificationSettingRepository.findByUser(user);
        if (existing != null) return;
        
        NotificationSetting setting = new NotificationSetting();
        setting.setUser(user);
        setting.setLikeNotifications(true);
        setting.setCommentNotifications(true);
        setting.setReplyNotifications(true);
        setting.setReviewNotifications(true);
        setting.setFollowNotifications(true);
        setting.setAnnouncementNotifications(true);
        setting.setBanNotifications(true);
        setting.setReportNotifications(true);
        setting.setNewSheetNotifications(true);
        setting.setEmailNotifications(true);
        notificationSettingRepository.save(setting);
    }

    @Override
    public void deleteSettingsByUser(User user) {
        if (user == null) return;
        notificationSettingRepository.deleteByUser(user);
    }

    private NotificationSetting createDefaultSetting(User user) {
        NotificationSetting setting = new NotificationSetting();
        setting.setUser(user);
        setting.setLikeNotifications(true);
        setting.setCommentNotifications(true);
        setting.setReplyNotifications(true);
        setting.setReviewNotifications(true);
        setting.setFollowNotifications(true);
        setting.setAnnouncementNotifications(true);
        setting.setBanNotifications(true);
        setting.setReportNotifications(true);
        setting.setNewSheetNotifications(true);
        setting.setEmailNotifications(true);
        notificationSettingRepository.save(setting);
        return setting;
    }
}