package cheatsheethibernate.repository;

import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class NotificationSettingRepositoryImpl implements NotificationSettingRepository {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public NotificationSetting findByUser(User user) {
        try {
            String hql = "FROM NotificationSetting ns WHERE ns.user = :user";
            return getCurrentSession()
                    .createQuery(hql, NotificationSetting.class)
                    .setParameter("user", user)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void save(NotificationSetting setting) {
        getCurrentSession().saveOrUpdate(setting);
    }

    @Override
    public NotificationSetting findById(Long id) {
        return getCurrentSession().get(NotificationSetting.class, id);
    }

    @Override
    public void deleteByUser(User user) {
        String hql = "DELETE FROM NotificationSetting ns WHERE ns.user = :user";
        getCurrentSession().createQuery(hql)
                .setParameter("user", user)
                .executeUpdate();
    }
}