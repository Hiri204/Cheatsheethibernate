package cheatsheethibernate.service;

import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;

public interface NotificationSettingService {
    NotificationSetting getSettingsByUser(User user);
    void saveSettings(NotificationSetting settings);
    void updateSettings(User user, boolean like, boolean comment, boolean reply,
                        boolean review, boolean follow, boolean announcement,
                        boolean ban, boolean report, boolean newSheet, boolean email);
    void updateSetting(User user, String settingName, boolean value);
    boolean isNotificationEnabled(User user, String type);
    void createDefaultSettings(User user);
    void deleteSettingsByUser(User user);
}