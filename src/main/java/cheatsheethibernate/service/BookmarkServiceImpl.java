package cheatsheethibernate.service;

import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cheatsheethibernate.entity.Bookmark;
import cheatsheethibernate.service.BookmarkService;

@Service
@Transactional
public class BookmarkServiceImpl implements BookmarkService {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void addBookmark(Integer userId, Long sheetId) {
		if (isBookmarked(userId, sheetId)) {
			return;
		}

		Session session = sessionFactory.getCurrentSession();
		Bookmark bookmark = new Bookmark();
		bookmark.setUserId(userId);
		bookmark.setSheetId(sheetId);
		bookmark.setCreatedAt(new Date());
		session.save(bookmark);
	}

	@Override
	public void removeBookmark(Integer userId, Long sheetId) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("DELETE FROM Bookmark b WHERE b.userId = :userId AND b.sheetId = :sheetId");
		query.setParameter("userId", userId);
		query.setParameter("sheetId", sheetId);
		query.executeUpdate();
	}

	@Override
	public void removeBookmark(Long bookmarkId) {
		Session session = sessionFactory.getCurrentSession();
		Bookmark bookmark = session.get(Bookmark.class, bookmarkId);
		if (bookmark != null) {
			session.delete(bookmark);
		}
	}

	@Override
	public List<Bookmark> getBookmarksByUser(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query<Bookmark> query = session
				.createQuery("FROM Bookmark b WHERE b.userId = :userId ORDER BY b.createdAt DESC", Bookmark.class);
		query.setParameter("userId", userId);
		return query.list();
	}

	@Override
	public Bookmark getBookmarkById(Long id) {
		Session session = sessionFactory.getCurrentSession();
		return session.get(Bookmark.class, id);
	}

	@Override
	public boolean isBookmarked(Integer userId, Long sheetId) {
		Session session = sessionFactory.getCurrentSession();
		Query<Long> query = session.createQuery(
				"SELECT COUNT(b) FROM Bookmark b WHERE b.userId = :userId AND b.sheetId = :sheetId", Long.class);
		query.setParameter("userId", userId);
		query.setParameter("sheetId", sheetId);
		return query.uniqueResult() > 0;
	}

	@Override
	public int getBookmarkCount(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query<Long> query = session.createQuery("SELECT COUNT(b) FROM Bookmark b WHERE b.userId = :userId", Long.class);
		query.setParameter("userId", userId);
		return query.uniqueResult().intValue();
	}
}