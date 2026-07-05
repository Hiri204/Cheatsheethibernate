package cheatsheethibernate.repository;

import java.time.LocalDateTime;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import cheatsheethibernate.entity.BannedUser;

@Repository
@Transactional
public class BannedUserRepositoryImpl implements BannedUserRepository {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(BannedUser banUser) {
        getCurrentSession().saveOrUpdate(banUser);
    }

    @Override
    public BannedUser findActiveBanByUserId(Integer userId) {
        String hql = "FROM BannedUser b " +
                     "WHERE b.user.userId = :userId " +
                     "AND (b.expiresAt > :now OR b.expiresAt IS NULL)";

        try {
            Query<BannedUser> query = getCurrentSession().createQuery(hql, BannedUser.class);
            query.setParameter("userId", userId);
            query.setParameter("now", LocalDateTime.now());
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<BannedUser> findAllActiveBans() {
        // Only return bans where expiresAt is in the future and user is still suspended
        String hql = "SELECT b FROM BannedUser b " +
                     "JOIN FETCH b.user u " +
                     "WHERE b.expiresAt > :now " +
                     "AND u.status = 'suspended'";  // User က suspended ဖြစ်နေမှပြမယ်

        try {
            Query<BannedUser> query = getCurrentSession().createQuery(hql, BannedUser.class);
            query.setParameter("now", LocalDateTime.now());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<BannedUser> findExpiredBans() {
        String hql = "FROM BannedUser b WHERE b.expiresAt IS NOT NULL AND b.expiresAt < :now";

        try {
            Query<BannedUser> query = getCurrentSession().createQuery(hql, BannedUser.class);
            query.setParameter("now", LocalDateTime.now());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public void delete(Integer id) {
        try {
            BannedUser bannedUser = getCurrentSession().get(BannedUser.class, id);
            if (bannedUser != null) {
                getCurrentSession().delete(bannedUser);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}