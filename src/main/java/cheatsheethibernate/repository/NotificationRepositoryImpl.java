package cheatsheethibernate.repository;

import cheatsheethibernate.entity.Notification;
import cheatsheethibernate.entity.Notification.NotificationType;
import cheatsheethibernate.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class NotificationRepositoryImpl implements NotificationRepository {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    // ===== Basic CRUD =====

    @Override
    public void save(Notification notification) {
        if (notification != null) {
            if (notification.getMessage() == null || notification.getMessage().trim().isEmpty()) {
                notification.setMessage("New notification");
            }
            if (notification.getType() == null) {
                notification.setType(NotificationType.ANNOUNCEMENT);
            }
            if (notification.getCreatedAt() == null) {
                notification.setCreatedAt(LocalDateTime.now());
            }
        }
        getCurrentSession().saveOrUpdate(notification);
    }

    @Override
    public Notification findById(Long id) {
        try {
            return getCurrentSession().get(Notification.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Optional<Notification> findByIdOptional(Long id) {
        return Optional.ofNullable(findById(id));
    }

    @Override
    public List<Notification> findAll() {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user ORDER BY n.createdAt DESC", Notification.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public void delete(Long id) {
        Notification notification = findById(id);
        if (notification != null) {
            getCurrentSession().delete(notification);
        }
    }

    @Override
    public void delete(Notification notification) {
        if (notification != null) {
            getCurrentSession().delete(notification);
        }
    }

    @Override
    public long count() {
        try {
            return getCurrentSession()
                    .createQuery("SELECT COUNT(n) FROM Notification n", Long.class)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ===== User-based Queries =====

    @Override
    public List<Notification> findByUser(User user) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> findByUserOrderByCreatedAtDesc(User user) {
        return findByUser(user);
    }

    @Override
    public List<Notification> findByUserAndIsRead(User user, boolean isRead) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.isRead = :isRead ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("isRead", isRead)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> findUnreadByUser(User user) {
        return findByUserAndIsRead(user, false);
    }

    @Override
    public long countUnreadByUser(User user) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT COUNT(n) FROM Notification n WHERE n.user = :user AND n.isRead = false", Long.class)
                    .setParameter("user", user)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public long countByUserAndIsRead(User user, boolean isRead) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT COUNT(n) FROM Notification n WHERE n.user = :user AND n.isRead = :isRead", Long.class)
                    .setParameter("user", user)
                    .setParameter("isRead", isRead)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ===== Type-based Queries =====

    @Override
    public List<Notification> findByUserAndType(User user, NotificationType type) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.type = :type ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("type", type)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> findByUserAndTypeIn(User user, List<NotificationType> types) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.type IN (:types) ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("types", types)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    // ===== Date-based Queries =====

    @Override
    public List<Notification> findByUserAndCreatedAtAfter(User user, LocalDateTime date) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.createdAt > :date ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("date", date)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> findByUserAndCreatedAtBetween(User user, LocalDateTime startDate, LocalDateTime endDate) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.createdAt BETWEEN :startDate AND :endDate ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    // ===== Entity-based Queries =====

    @Override
    public List<Notification> findByEntityTypeAndEntityId(String entityType, Long entityId) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.entityType = :entityType AND n.entityId = :entityId ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("entityType", entityType)
                    .setParameter("entityId", entityId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> findByUserAndEntityTypeAndEntityId(User user, String entityType, Long entityId) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT DISTINCT n FROM Notification n LEFT JOIN FETCH n.user WHERE n.user = :user AND n.entityType = :entityType AND n.entityId = :entityId ORDER BY n.createdAt DESC", Notification.class)
                    .setParameter("user", user)
                    .setParameter("entityType", entityType)
                    .setParameter("entityId", entityId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    // ===== Bulk Operations =====

    @Override
    public int markAllAsReadByUser(User user) {
        try {
            return getCurrentSession()
                    .createQuery("UPDATE Notification n SET n.isRead = true WHERE n.user = :user")
                    .setParameter("user", user)
                    .executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int markAllAsReadByUserAndType(User user, NotificationType type) {
        try {
            return getCurrentSession()
                    .createQuery("UPDATE Notification n SET n.isRead = true WHERE n.user = :user AND n.type = :type")
                    .setParameter("user", user)
                    .setParameter("type", type)
                    .executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int deleteAllByUser(User user) {
        try {
            return getCurrentSession()
                    .createQuery("DELETE FROM Notification n WHERE n.user = :user")
                    .setParameter("user", user)
                    .executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int deleteAllOlderThan(User user, LocalDateTime date) {
        try {
            return getCurrentSession()
                    .createQuery("DELETE FROM Notification n WHERE n.user = :user AND n.createdAt < :date")
                    .setParameter("user", user)
                    .setParameter("date", date)
                    .executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int deleteAllByEntityTypeAndEntityId(String entityType, Long entityId) {
        try {
            return getCurrentSession()
                    .createQuery("DELETE FROM Notification n WHERE n.entityType = :entityType AND n.entityId = :entityId")
                    .setParameter("entityType", entityType)
                    .setParameter("entityId", entityId)
                    .executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ===== Recent Queries =====

    @Override
    public List<Notification> getRecentByUser(User user, int limit) {
        try {
            String hql = "SELECT DISTINCT n FROM Notification n " +
                         "LEFT JOIN FETCH n.user " +
                         "WHERE n.user = :user " +
                         "ORDER BY n.createdAt DESC";
            return getCurrentSession()
                    .createQuery(hql, Notification.class)
                    .setParameter("user", user)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Notification> getRecentUnreadByUser(User user, int limit) {
        try {
            String hql = "SELECT DISTINCT n FROM Notification n " +
                         "LEFT JOIN FETCH n.user " +
                         "WHERE n.user = :user AND n.isRead = false " +
                         "ORDER BY n.createdAt DESC";
            return getCurrentSession()
                    .createQuery(hql, Notification.class)
                    .setParameter("user", user)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    // ===== Statistics =====

    @Override
    public List<Object[]> getNotificationStatsByUser(User user) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT n.type, COUNT(n) FROM Notification n WHERE n.user = :user GROUP BY n.type", Object[].class)
                    .setParameter("user", user)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Object[]> getNotificationStatsByType() {
        try {
            return getCurrentSession()
                    .createQuery("SELECT n.type, COUNT(n) FROM Notification n GROUP BY n.type", Object[].class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public long countByType(NotificationType type) {
        try {
            return getCurrentSession()
                    .createQuery("SELECT COUNT(n) FROM Notification n WHERE n.type = :type", Long.class)
                    .setParameter("type", type)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}