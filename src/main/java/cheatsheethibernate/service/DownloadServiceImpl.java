package cheatsheethibernate.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cheatsheethibernate.entity.DownloadHistory;
import cheatsheethibernate.service.DownloadService;

@Service
@Transactional
public class DownloadServiceImpl implements DownloadService {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void saveDownloadHistory(DownloadHistory history) {
		Session session = sessionFactory.getCurrentSession();
		history.setDownloadDate(new Date());
		session.saveOrUpdate(history);
	}

	@Override
	public List<DownloadHistory> getUserDownloadHistory(Integer userId, int page, int size) {
		Session session = sessionFactory.getCurrentSession();
		Query<DownloadHistory> query = session.createQuery(
				"FROM DownloadHistory d WHERE d.userId = :userId ORDER BY d.downloadDate DESC", DownloadHistory.class);
		query.setParameter("userId", userId);
		query.setFirstResult((page - 1) * size);
		query.setMaxResults(size);
		return query.list();
	}

	@Override
	public List<DownloadHistory> getUserDownloadHistory(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query<DownloadHistory> query = session.createQuery(
				"FROM DownloadHistory d WHERE d.userId = :userId ORDER BY d.downloadDate DESC", DownloadHistory.class);
		query.setParameter("userId", userId);
		return query.list();
	}

	@Override
	public DownloadHistory getDownloadHistory(Long id) {
		Session session = sessionFactory.getCurrentSession();
		return session.get(DownloadHistory.class, id);
	}

	@Override
	public int getTotalCount(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query<Long> query = session.createQuery("SELECT COUNT(d) FROM DownloadHistory d WHERE d.userId = :userId",
				Long.class);
		query.setParameter("userId", userId);
		return query.uniqueResult().intValue();
	}

	@Override
	public int getRecentDownloadCount(Integer userId) {
		Session session = sessionFactory.getCurrentSession();

		// Get count from last 30 days
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, -30);
		Date thirtyDaysAgo = cal.getTime();

		Query<Long> query = session.createQuery(
				"SELECT COUNT(d) FROM DownloadHistory d WHERE d.userId = :userId AND d.downloadDate >= :date",
				Long.class);
		query.setParameter("userId", userId);
		query.setParameter("date", thirtyDaysAgo);
		return query.uniqueResult().intValue();
	}

	@Override
	public boolean deleteDownloadHistory(Long id, Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		DownloadHistory history = session.get(DownloadHistory.class, id);

		if (history != null && history.getUserId().equals(userId)) {
			session.delete(history);
			return true;
		}
		return false;
	}

	@Override
	public void clearAllHistory(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("DELETE FROM DownloadHistory d WHERE d.userId = :userId");
		query.setParameter("userId", userId);
		query.executeUpdate();
	}

	@Override
	public List<DownloadHistory> getDownloadHistoryByStatus(Integer userId, String status) {
		Session session = sessionFactory.getCurrentSession();
		Query<DownloadHistory> query = session.createQuery(
				"FROM DownloadHistory d WHERE d.userId = :userId AND d.status = :status ORDER BY d.downloadDate DESC",
				DownloadHistory.class);
		query.setParameter("userId", userId);
		query.setParameter("status", status);
		return query.list();
	}

	@Override
	public List<DownloadHistory> getDownloadHistoryByDateRange(Integer userId, Date startDate, Date endDate) {
		Session session = sessionFactory.getCurrentSession();
		Query<DownloadHistory> query = session.createQuery(
				"FROM DownloadHistory d WHERE d.userId = :userId AND d.downloadDate BETWEEN :startDate AND :endDate ORDER BY d.downloadDate DESC",
				DownloadHistory.class);
		query.setParameter("userId", userId);
		query.setParameter("startDate", startDate);
		query.setParameter("endDate", endDate);
		return query.list();
	}

	@Override
	public long getCountByStatus(Integer userId, String status) {
		Session session = sessionFactory.getCurrentSession();
		Query<Long> query = session.createQuery(
				"SELECT COUNT(d) FROM DownloadHistory d WHERE d.userId = :userId AND d.status = :status", Long.class);
		query.setParameter("userId", userId);
		query.setParameter("status", status);
		return query.uniqueResult();
	}

	@Override
	public int getTodayDownloadCount(Integer userId) {
		Session session = sessionFactory.getCurrentSession();

		// Get today's date at 00:00:00
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		Date startOfDay = cal.getTime();

		// Get end of day (23:59:59)
		cal.set(Calendar.HOUR_OF_DAY, 23);
		cal.set(Calendar.MINUTE, 59);
		cal.set(Calendar.SECOND, 59);
		cal.set(Calendar.MILLISECOND, 999);
		Date endOfDay = cal.getTime();

		Query<Long> query = session.createQuery(
				"SELECT COUNT(d) FROM DownloadHistory d WHERE d.userId = :userId AND d.downloadDate BETWEEN :start AND :end AND d.status = 'success'",
				Long.class);
		query.setParameter("userId", userId);
		query.setParameter("start", startOfDay);
		query.setParameter("end", endOfDay);
		return query.uniqueResult().intValue();
	}

	@Override
	public List<DownloadHistory> getDownloadsByCategory(Integer userId, String categoryName) {
		Session session = sessionFactory.getCurrentSession();
		Query<DownloadHistory> query = session.createQuery(
				"FROM DownloadHistory d WHERE d.userId = :userId AND d.categoryName = :categoryName ORDER BY d.downloadDate DESC",
				DownloadHistory.class);
		query.setParameter("userId", userId);
		query.setParameter("categoryName", categoryName);
		return query.list();
	}

	@Override
	public void updateDownloadStatus(Long id, String status) {
		Session session = sessionFactory.getCurrentSession();
		DownloadHistory history = session.get(DownloadHistory.class, id);
		if (history != null) {
			history.setStatus(status);
			session.update(history);
		}
	}

	@Override
	public void deleteOldHistory(Integer userId, int days) {
		Session session = sessionFactory.getCurrentSession();
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, -days);
		Date cutoffDate = cal.getTime();

		Query query = session
				.createQuery("DELETE FROM DownloadHistory d WHERE d.userId = :userId AND d.downloadDate < :cutoffDate");
		query.setParameter("userId", userId);
		query.setParameter("cutoffDate", cutoffDate);
		query.executeUpdate();
	}
}