package cheatsheethibernate.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cheatsheethibernate.entity.Bookmark;
import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.BookmarkService;
import cheatsheethibernate.service.CheatSheetService;

@Controller
@RequestMapping("/bookmarks")
public class BookmarkController {

	@Autowired
	private BookmarkService bookmarkService;

	@Autowired
	private CheatSheetService cheatSheetService;

	/**
	 * View all bookmarks
	 */
	@GetMapping
	public String viewBookmarks(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		List<Bookmark> bookmarks = bookmarkService.getBookmarksByUser(loginUser.getUserId());
		int bookmarkCount = bookmarkService.getBookmarkCount(loginUser.getUserId());

		// Add sheet details to each bookmark
		for (Bookmark bookmark : bookmarks) {
			CheatSheet sheet = cheatSheetService.getCheatSheetById(bookmark.getSheetId());
			if (sheet != null) {
				bookmark.setSheetTitle(sheet.getTitle() != null ? sheet.getTitle() : "Untitled");
				bookmark.setSheetCategory(
						sheet.getCategory() != null ? sheet.getCategory().getName() : "Uncategorized");
				bookmark.setSheetAuthor(sheet.getUser() != null ? sheet.getUser().getUsername() : "Unknown");
				bookmark.setLikeCount(sheet.getLikeCount() != null ? sheet.getLikeCount() : 0);
			} else {
				bookmark.setSheetTitle("Deleted Sheet");
				bookmark.setSheetCategory("Unknown");
				bookmark.setSheetAuthor("Unknown");
				bookmark.setLikeCount(0);
			}
		}

		model.addAttribute("bookmarks", bookmarks);
		model.addAttribute("bookmarkCount", bookmarkCount);
		model.addAttribute("activePage", "bookmarks");

		return "bookmarks";
	}

	/**
	 * Toggle bookmark (AJAX) - ✅ Returns Map instead of boolean
	 */
	@PostMapping("/toggle/{sheetId}")
	@ResponseBody
	public Map<String, Object> toggleBookmark(@PathVariable("sheetId") Long sheetId, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			response.put("success", false);
			response.put("message", "Please login first");
			return response;
		}

		CheatSheet sheet = cheatSheetService.getCheatSheetById(sheetId);
		if (sheet == null) {
			response.put("success", false);
			response.put("message", "Sheet not found");
			return response;
		}

		try {
			if (bookmarkService.isBookmarked(loginUser.getUserId(), sheetId)) {
				bookmarkService.removeBookmark(loginUser.getUserId(), sheetId);
				cheatSheetService.decrementBookmarkCount(sheetId);
				response.put("success", true);
				response.put("bookmarked", false);
				response.put("message", "Bookmark removed");
			} else {
				bookmarkService.addBookmark(loginUser.getUserId(), sheetId);
				cheatSheetService.incrementBookmarkCount(sheetId);
				response.put("success", true);
				response.put("bookmarked", true);
				response.put("message", "Bookmarked successfully");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "Error: " + e.getMessage());
		}

		return response;
	}

	/**
	 * Remove bookmark
	 */
	@PostMapping("/remove/{id}")
	public String removeBookmark(@PathVariable("id") Long bookmarkId, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		Bookmark bookmark = bookmarkService.getBookmarkById(bookmarkId);
		if (bookmark != null && bookmark.getUserId().equals(loginUser.getUserId())) {
			Long sheetId = bookmark.getSheetId();
			bookmarkService.removeBookmark(bookmarkId);
			cheatSheetService.decrementBookmarkCount(sheetId);
		}

		return "redirect:/bookmarks";
	}
}