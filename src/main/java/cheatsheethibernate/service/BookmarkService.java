package cheatsheethibernate.service;

import java.util.List;

import cheatsheethibernate.entity.Bookmark;

public interface BookmarkService {

	void addBookmark(Integer userId, Long sheetId);

	void removeBookmark(Integer userId, Long sheetId);

	void removeBookmark(Long bookmarkId);

	List<Bookmark> getBookmarksByUser(Integer userId);

	Bookmark getBookmarkById(Long id);

	boolean isBookmarked(Integer userId, Long sheetId);

	int getBookmarkCount(Integer userId);
}