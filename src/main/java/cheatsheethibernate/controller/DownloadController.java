package cheatsheethibernate.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import cheatsheethibernate.entity.DownloadHistory;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.DownloadService;

@Controller
@RequestMapping("/downloads")
public class DownloadController {

	@Autowired
	private DownloadService downloadService;

	/**
	 * View download history
	 */
	@GetMapping("/history")
	public String viewDownloadHistory(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size, HttpSession session, Model model) {

		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		// Get paginated history
		List<DownloadHistory> history = downloadService.getUserDownloadHistory(loginUser.getUserId(), page, size);
		int totalItems = downloadService.getTotalCount(loginUser.getUserId());
		int totalPages = (int) Math.ceil((double) totalItems / size);

		// Set icons for file types
		for (DownloadHistory item : history) {
			String fileType = item.getFileType();
			if ("pdf".equalsIgnoreCase(fileType)) {
				item.setIconClass("fa-file-pdf");
				item.setFileType("pdf");
			} else if ("zip".equalsIgnoreCase(fileType)) {
				item.setIconClass("fa-file-zipper");
				item.setFileType("zip");
			} else if ("doc".equalsIgnoreCase(fileType) || "docx".equalsIgnoreCase(fileType)) {
				item.setIconClass("fa-file-word");
				item.setFileType("doc");
			} else {
				item.setIconClass("fa-file");
				item.setFileType("other");
			}
		}

		// Get download count for badge
		int downloadCount = downloadService.getRecentDownloadCount(loginUser.getUserId());

		model.addAttribute("downloadHistory", history);
		model.addAttribute("downloadCount", downloadCount);
		model.addAttribute("totalItems", totalItems);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", page);
		model.addAttribute("pageSize", size);
		model.addAttribute("activePage", "download-history");

		return "download-history";
	}

	/**
	 * Download again
	 */
	@GetMapping("/again/{id}")
	public String downloadAgain(@PathVariable("id") Long id, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		DownloadHistory history = downloadService.getDownloadHistory(id);
		if (history == null || !history.getUserId().equals(loginUser.getUserId())) {
			return "redirect:/downloads/history";
		}

		// Redirect to actual download
		return "redirect:" + history.getDownloadUrl();
	}

	/**
	 * Delete a history item
	 */
	@DeleteMapping("/delete/{id}")
	public ResponseEntity<?> deleteHistory(@PathVariable("id") Long id, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}

		boolean deleted = downloadService.deleteDownloadHistory(id, loginUser.getUserId());
		return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
	}

	/**
	 * Clear all history
	 */
	@DeleteMapping("/clear-all")
	public ResponseEntity<?> clearAllHistory(HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}

		downloadService.clearAllHistory(loginUser.getUserId());
		return ResponseEntity.ok().build();
	}
}