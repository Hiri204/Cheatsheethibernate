package cheatsheethibernate.service;

import java.util.List;

import cheatsheethibernate.entity.DownloadHistory;

public interface DownloadService {

	/**
	 * Save download history
	 */
	void saveDownloadHistory(DownloadHistory history);

	/**
	 * Get user download history with pagination
	 */
	List<DownloadHistory> getUserDownloadHistory(Integer userId, int page, int size);

	/**
	 * Get user download history (all)
	 */
	List<DownloadHistory> getUserDownloadHistory(Integer userId);

	/**
	 * Get download history by ID
	 */
	DownloadHistory getDownloadHistory(Long id);

	/**
	 * Get total count of downloads for user
	 */
	int getTotalCount(Integer userId);

	/**
	 * Get recent download count for badge
	 */
	int getRecentDownloadCount(Integer userId);

	/**
	 * Delete download history
	 */
	boolean deleteDownloadHistory(Long id, Integer userId);

	/**
	 * Clear all history for user
	 */
	void clearAllHistory(Integer userId);

	/**
	 * Get download history by status
	 */
	List<DownloadHistory> getDownloadHistoryByStatus(Integer userId, String status);

	/**
	 * Get download history by date range
	 */
	List<DownloadHistory> getDownloadHistoryByDateRange(Integer userId, java.util.Date startDate,
			java.util.Date endDate);

	/**
	 * Get download history count by status
	 */
	long getCountByStatus(Integer userId, String status);

	/**
	 * Get total downloads for today
	 */
	int getTodayDownloadCount(Integer userId);

	/**
	 * Get downloads by category
	 */
	List<DownloadHistory> getDownloadsByCategory(Integer userId, String categoryName);

	/**
	 * Update download status
	 */
	void updateDownloadStatus(Long id, String status);

	/**
	 * Delete old download history (older than days)
	 */
	void deleteOldHistory(Integer userId, int days);
}