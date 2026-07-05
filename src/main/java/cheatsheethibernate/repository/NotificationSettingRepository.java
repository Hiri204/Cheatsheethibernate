package cheatsheethibernate.repository;

import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;

public interface NotificationSettingRepository {
    NotificationSetting findByUser(User user);
    void save(NotificationSetting setting);
    NotificationSetting findById(Long id);
    void deleteByUser(User user);
}