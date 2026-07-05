package cheatsheethibernate.controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import cheatsheethibernate.entity.Category;
import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.Comment;
import cheatsheethibernate.entity.Review;
import cheatsheethibernate.entity.Tag;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.AdminContentService;
import cheatsheethibernate.service.CheatSheetService;
import cheatsheethibernate.service.NotificationService;

/**
 * Controller for managing CheatSheet operations including CRUD, 
 * reviews, comments, likes, bookmarks, search, and PDF export.
 */
@Controller
@RequestMapping("/cheatsheets")
public class CheatSheetController {

    @Autowired
    private CheatSheetService cheatSheetService;

    @Autowired
    private AdminContentService adminContentService;

    @Autowired
    private NotificationService notificationService;

    // ============================================================
    // INIT BINDER
    // ============================================================

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(CheatSheet.Status.class, new java.beans.PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text != null) {
                    try {
                        setValue(CheatSheet.Status.valueOf(text.toLowerCase().trim()));
                    } catch (IllegalArgumentException e) {
                        setValue(CheatSheet.Status.draft);
                    }
                }
            }
        });
    }

    // ============================================================
    // 🔓 PUBLIC VIEW MAPPINGS - No login required
    // ============================================================

    /**
     * 🔓 PUBLIC - Display cheat sheets by category with pagination
     * Anyone can view this page without login
     */
    @GetMapping("/category/{name}")
    public String getCategorySheets(@PathVariable("name") String name,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "12") int size, Model model) {

        List<CheatSheet> allSheets = cheatSheetService.getCheatSheetsByCategory(name);

        int totalItems = allSheets.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        int currentPage = Math.max(1, Math.min(page, totalPages > 0 ? totalPages : 1));

        int fromIndex = (currentPage - 1) * size;
        int toIndex = Math.min(fromIndex + size, totalItems);

        List<CheatSheet> pagedSheets = allSheets.subList(fromIndex, toIndex);

        model.addAttribute("sheets", pagedSheets);
        model.addAttribute("categoryName", name);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("pageSize", size);

        return "category-list";
    }

    /**
     * 🔓 PUBLIC - Display cheat sheets by tag name
     * Anyone can view this page without login
     */
    @GetMapping("/tag/{name}")
    public String viewCheatSheetsByTag(@PathVariable("name") String tagName, Model model) {
        List<CheatSheet> cheatSheets = cheatSheetService.getCheatSheetsByTagName(tagName);
        
        model.addAttribute("sheets", cheatSheets);
        model.addAttribute("selectedTag", tagName);
        model.addAttribute("categoryName", "Tag: #" + tagName);
        
        return "tag-cheatsheets";
    }

    /**
     * 🔓 PUBLIC - Display cheat sheets by tag (alternative mapping)
     * Anyone can view this page without login
     */
    @GetMapping("/tag/{tagName}")
    public String getSheetsByTag(@PathVariable("tagName") String tagName, Model model) {
        model.addAttribute("sheets", cheatSheetService.getCheatSheetsByTag(tagName));
        model.addAttribute("categoryName", "Tag: #" + tagName);
        return "category-list";
    }

    /**
     * 🔓 PUBLIC - View cheat sheet details with reviews and comments
     * Anyone can view this page without login
     */
    @GetMapping("/view/{id}")
    public String viewCheatSheetDetails(@PathVariable("id") Long id, Model model, HttpSession session) {
        CheatSheet cheatSheet = cheatSheetService.getCheatSheetDetailsById(id);
        if (cheatSheet == null) {
            return "redirect:/";
        }

        Double avgRating = cheatSheetService.getAverageRating(id);
        List<Review> reviews = cheatSheetService.getReviewsByCheatSheet(id);
        List<Comment> comments = cheatSheetService.getMainCommentsByCheatSheet(id);

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser != null) {
            Review currentReview = null;
            for (Review r : reviews) {
                if (r.getUser().getUserId().equals(loginUser.getUserId())) {
                    currentReview = r;
                    break;
                }
            }
            model.addAttribute("currentReview", currentReview);
        }

        model.addAttribute("sheet", cheatSheet);
        model.addAttribute("avgRating", Math.round(avgRating * 10) / 10.0);
        model.addAttribute("reviews", reviews);
        model.addAttribute("comments", comments);

        return "cheatsheet-detail";
    }

    // ============================================================
    // 🔓 PUBLIC - Search
    // ============================================================

    /**
     * 🔓 PUBLIC - Search cheat sheets by keyword
     * Anyone can search without login
     */
    @GetMapping("/search")
    public String searchCheatSheets(@RequestParam("keyword") String keyword, 
            HttpSession session, Model model) {

        List<CheatSheet> searchResults = cheatSheetService.searchCheatSheets(keyword);

        List<Category> categories = adminContentService.getAllCategories();
        User loginUser = (User) session.getAttribute("loginUser");
        int unreadCount = 0;
        if (loginUser != null) {
            unreadCount = (int) notificationService.getUnreadCount(loginUser);
        }

        model.addAttribute("searchResults", searchResults);
        model.addAttribute("sheets", searchResults);
        model.addAttribute("categories", categories);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryName", "Search Results for: " + keyword);
        model.addAttribute("isSearchResult", true);

        return "dashboard";
    }

    // ============================================================
    // VIEW MAPPINGS - User Sheets (Login Required)
    // ============================================================

    /**
     * 🔒 Display user's own cheat sheets - Login required
     */
    @GetMapping("/my-cheatsheets")
    public String getMyCheatSheets(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        List<CheatSheet> mySheets = cheatSheetService.getCheatSheetsByUser(loginUser);
        model.addAttribute("sheets", mySheets);
        model.addAttribute("categoryName", "My Personal Cheat Sheets");
        return "my-cheatsheets-list";
    }

    // ============================================================
    // CREATE / EDIT / DELETE (Login Required)
    // ============================================================

    /**
     * 🔒 Show create form for new cheat sheet - Login required
     */
    @GetMapping("/new")
    public String showCreateForm(Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("cheatSheet", new CheatSheet());
        model.addAttribute("categories", adminContentService.getAllCategories());
        model.addAttribute("tags", adminContentService.getAllTags());
        return "create-form";
    }

    /**
     * 🔒 Show edit form for existing cheat sheet - Login required
     */
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null)
            return "redirect:/login";

        CheatSheet cheatSheet = cheatSheetService.getCheatSheetById(id);
        if (cheatSheet == null || !cheatSheet.getUser().getUserId().equals(loginUser.getUserId())) {
            return "redirect:/cheatsheets/my-cheatsheets";
        }

        model.addAttribute("cheatSheet", cheatSheet);
        model.addAttribute("categories", adminContentService.getAllCategories());
        model.addAttribute("tags", adminContentService.getAllTags());
        return "edit-form";
    }

    /**
     * 🔒 Save or update cheat sheet - Login required
     */
    @PostMapping("/save")
    public String saveCheatSheet(@ModelAttribute("cheatSheet") CheatSheet formSheet,
            @RequestParam(value = "categoryId", required = false) Integer categoryId,
            @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            HttpSession session,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        CheatSheet targetSheet;

        if (formSheet.getId() != null) {
            targetSheet = cheatSheetService.getCheatSheetById(formSheet.getId());
            if (targetSheet == null) {
                redirectAttributes.addFlashAttribute("errorMsg", "Cheat sheet not found.");
                return "redirect:/cheatsheets/my-cheatsheets";
            }
        } else {
            targetSheet = new CheatSheet();
        }

        targetSheet.setTitle(formSheet.getTitle());
        targetSheet.setContent(formSheet.getContent());
        targetSheet.setStatus(formSheet.getStatus());
        targetSheet.setUser(loginUser);

        // Handle image upload
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String uploadRootPath = request.getServletContext().getRealPath("/uploads/");
                if (uploadRootPath == null) {
                    uploadRootPath = System.getProperty("user.dir") + File.separator + "src" + File.separator + "main"
                            + File.separator + "webapp" + File.separator + "uploads";
                }
                File uploadDir = new File(uploadRootPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String cleanName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8)
                        + extension;

                File serverFile = new File(uploadDir.getAbsolutePath() + File.separator + cleanName);
                imageFile.transferTo(serverFile);

                targetSheet.setFileUrl(cleanName);

            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("errorMsg", "Failed to upload image: " + e.getMessage());
            }
        }

        // Set category
        if (categoryId != null) {
            Category category = adminContentService.findCategoryById(categoryId);
            if (category != null) {
                targetSheet.setCategory(category);
            }
        }

        // Set tags
        List<Tag> selectedTags = new ArrayList<>();
        if (tagIds != null && !tagIds.isEmpty()) {
            for (Integer tagId : tagIds) {
                Tag tag = adminContentService.findTagById(tagId);
                if (tag != null)
                    selectedTags.add(tag);
            }
        }
        targetSheet.setTags(selectedTags);

        try {
            boolean isNewPublished = (formSheet.getId() == null && 
                                     targetSheet.getStatus() == CheatSheet.Status.published);
            
            cheatSheetService.saveCheatSheet(targetSheet);

            if (isNewPublished) {
                System.out.println("📢 New sheet published: " + targetSheet.getTitle() + " by " + loginUser.getUsername());
            }

            redirectAttributes.addFlashAttribute("successMsg", "Cheat sheet saved successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "Error saving cheat sheet: " + e.getMessage());
        }

        return "redirect:/cheatsheets/my-cheatsheets";
    }

    /**
     * 🔒 Delete cheat sheet - Login required
     */
    @GetMapping("/delete/{id}")
    public String deleteCheatSheet(@PathVariable("id") Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        CheatSheet cheatSheet = cheatSheetService.getCheatSheetById(id);

        if (cheatSheet != null) {
            if (cheatSheet.getUser().getUserId().equals(loginUser.getUserId())) {
                try {
                    cheatSheetService.deleteCheatSheet(cheatSheet);
                } catch (Exception e) {
                    System.err.println("❌ Error occurred while deleting CheatSheet ID: " + id);
                    e.printStackTrace();
                }
            }
        }
        return "redirect:/cheatsheets/my-cheatsheets";
    }

    // ============================================================
    // VIEW COMMENTS & RATE (Public)
    // ============================================================

    /**
     * 🔓 PUBLIC - View comments page for a cheat sheet
     */
    @GetMapping("/comments/{id}")
    public String viewComments(@PathVariable("id") Long id, Model model, HttpSession session) {
        CheatSheet sheet = cheatSheetService.getCheatSheetById(id);
        if (sheet == null) {
            return "redirect:/";
        }

        List<Comment> comments = cheatSheetService.getMainCommentsByCheatSheet(id);
        model.addAttribute("sheet", sheet);
        model.addAttribute("comments", comments);
        return "comments-page";
    }

    /**
     * 🔒 Show rate sheet page - Login required
     */
    @GetMapping("/rate/{id}")
    public String rateSheet(@PathVariable("id") Long id, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        CheatSheet sheet = cheatSheetService.getCheatSheetById(id);
        if (sheet == null) {
            return "redirect:/";
        }

        model.addAttribute("sheet", sheet);
        return "rate-sheet";
    }

    // ============================================================
    // REVIEWS & COMMENTS (Login Required)
    // ============================================================

    /**
     * 🔒 Submit review for a cheat sheet - Login required
     */
    @PostMapping("/view/{id}/review")
    public String submitReview(@PathVariable("id") Long id,
            @RequestParam("rating") Integer rating,
            @RequestParam("reviewText") String reviewText,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        cheatSheetService.addOrUpdateReview(id, loginUser, rating, reviewText);
        return "redirect:/cheatsheets/view/" + id;
    }

    /**
     * 🔒 Submit comment for a cheat sheet - Login required
     */
    @PostMapping("/view/{id}/comment")
    public String submitComment(@PathVariable("id") Long id,
            @RequestParam("content") String content,
            @RequestParam(value = "parentId", required = false) Integer parentId,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        cheatSheetService.addComment(id, loginUser, content, parentId);
        return "redirect:/cheatsheets/view/" + id;
    }

    /**
     * 🔒 Submit rating for a cheat sheet - Login required
     */
    @PostMapping("/rate/{id}")
    public String submitRating(@PathVariable("id") Long id,
            @RequestParam("rating") Integer rating,
            @RequestParam(value = "reviewText", required = false) String reviewText,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        cheatSheetService.addOrUpdateReview(id, loginUser, rating, reviewText);
        return "redirect:/cheatsheets/view/" + id;
    }

    // ============================================================
    // LIKE & BOOKMARK (AJAX) - Login Required
    // ============================================================

    /**
     * 🔒 Like/Unlike a cheat sheet with notification - Login required
     */
    @PostMapping("/like/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable("id") Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(401).body(response);
        }

        try {
            CheatSheet sheet = cheatSheetService.getCheatSheetById(id);
            if (sheet == null) {
                response.put("success", false);
                response.put("message", "Sheet not found");
                return ResponseEntity.status(404).body(response);
            }

            boolean isLiked = false;

            if (isLiked) {
                cheatSheetService.decrementLikeCount(id);
                response.put("liked", false);
            } else {
                cheatSheetService.incrementLikeCount(id);

                if (sheet.getUser() != null && !sheet.getUser().getUserId().equals(loginUser.getUserId())) {
                    notificationService.notifyLike(sheet.getUser(), loginUser, "cheat sheet", id);
                }

                response.put("liked", true);
            }

            CheatSheet updatedSheet = cheatSheetService.getCheatSheetById(id);
            response.put("success", true);
            response.put("likeCount", updatedSheet.getLikeCount());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 🔒 Bookmark/Unbookmark a cheat sheet - Login required
     */
    @PostMapping("/bookmark/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBookmark(@PathVariable("id") Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(401).body(response);
        }

        try {
            CheatSheet sheet = cheatSheetService.getCheatSheetById(id);
            if (sheet == null) {
                response.put("success", false);
                response.put("message", "Sheet not found");
                return ResponseEntity.status(404).body(response);
            }

            boolean isBookmarked = false;

            if (isBookmarked) {
                cheatSheetService.decrementBookmarkCount(id);
                response.put("bookmarked", false);
            } else {
                cheatSheetService.incrementBookmarkCount(id);
                response.put("bookmarked", true);
            }

            CheatSheet updatedSheet = cheatSheetService.getCheatSheetById(id);
            response.put("success", true);
            response.put("bookmarkCount", updatedSheet.getBookmarkCount());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    // ============================================================
    // PDF EXPORT
    // ============================================================

    /**
     * 🔒 Download all sheets in a category as PDF - Login required
     */
    @GetMapping("/download-all")
    public ResponseEntity<byte[]> downloadAllSheets(@RequestParam("category") String categoryName, 
            HttpSession session) throws IOException {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<CheatSheet> sheets = cheatSheetService.getCheatSheetsByCategory(categoryName);

        if (sheets == null || sheets.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        byte[] pdfBytes = generateCategoryPDF(categoryName, sheets, loginUser);

        HttpHeaders headers = new HttpHeaders();
        String filename = categoryName.replaceAll("[^a-zA-Z0-9]", "_") + "_cheatsheets.pdf";
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", filename);
        headers.setContentLength(pdfBytes.length);

        return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);
    }

    /**
     * Generate PDF for category sheets - Each sheet on its own page
     */
    private byte[] generateCategoryPDF(String categoryName, List<CheatSheet> sheets, User loginUser) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, baos);
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font subHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.ITALIC);
            Font codeFont = FontFactory.getFont(FontFactory.COURIER, 11);

            // Cover Page
            Paragraph title = new Paragraph("📁 Category: " + categoryName, titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            Paragraph subTitle = new Paragraph("Cheat Sheets Collection", headerFont);
            subTitle.setAlignment(Element.ALIGN_CENTER);
            subTitle.setSpacingAfter(30);
            document.add(subTitle);

            Paragraph totalPara = new Paragraph("Total: " + sheets.size() + " cheatsheets", normalFont);
            totalPara.setAlignment(Element.ALIGN_CENTER);
            totalPara.setSpacingAfter(40);
            document.add(totalPara);

            Paragraph tocTitle = new Paragraph("📑 Table of Contents", subHeaderFont);
            tocTitle.setAlignment(Element.ALIGN_LEFT);
            tocTitle.setSpacingAfter(15);
            document.add(tocTitle);

            int index = 1;
            for (CheatSheet sheet : sheets) {
                String author = sheet.getUser() != null ? sheet.getUser().getUsername() : "Unknown";
                Paragraph tocEntry = new Paragraph(index + ". " + sheet.getTitle() + " — by " + author, normalFont);
                tocEntry.setSpacingAfter(5);
                document.add(tocEntry);
                index++;
            }

            Paragraph footer = new Paragraph("Generated on: " + new Date() + " | © DevSheets", smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(30);
            document.add(footer);

            // Each sheet on new page
            int sheetIndex = 1;
            for (CheatSheet sheet : sheets) {
                document.newPage();

                Paragraph sheetTitle = new Paragraph(sheetIndex + ". " + sheet.getTitle(), headerFont);
                sheetTitle.setSpacingAfter(10);
                document.add(sheetTitle);

                Paragraph divider = new Paragraph("─────────────────────────────────");
                divider.setSpacingAfter(10);
                document.add(divider);

                Paragraph metaInfo = new Paragraph(
                        "✍️ Author: " + (sheet.getUser() != null ? sheet.getUser().getUsername() : "Unknown")
                                + "  |  📌 Status: " + sheet.getStatus() + "  |  📂 Category: "
                                + (sheet.getCategory() != null ? sheet.getCategory().getName() : "Uncategorized"),
                        smallFont);
                metaInfo.setSpacingAfter(8);
                document.add(metaInfo);

                if (sheet.getTags() != null && !sheet.getTags().isEmpty()) {
                    StringBuilder tagsStr = new StringBuilder("🏷️ Tags: ");
                    for (Tag tag : sheet.getTags()) {
                        tagsStr.append("#").append(tag.getName()).append("  ");
                    }
                    Paragraph tagsPara = new Paragraph(tagsStr.toString(), smallFont);
                    tagsPara.setSpacingAfter(12);
                    document.add(tagsPara);
                }

                String content = sheet.getContent() != null ? sheet.getContent() : "No content available";

                if (content.contains("public") || content.contains("function") || content.contains("def ")
                        || content.contains("class ") || content.contains("SELECT") || content.contains("import")
                        || (content.contains("{") && content.contains("}"))) {
                    Paragraph contentPara = new Paragraph(content, codeFont);
                    contentPara.setSpacingAfter(10);
                    document.add(contentPara);
                } else {
                    Paragraph contentPara = new Paragraph(content, normalFont);
                    contentPara.setSpacingAfter(10);
                    document.add(contentPara);
                }

                Paragraph statsPara = new Paragraph(
                        "❤️ " + (sheet.getLikeCount() != null ? sheet.getLikeCount() : 0) + " likes  |  🔖 "
                                + (sheet.getBookmarkCount() != null ? sheet.getBookmarkCount() : 0) + " bookmarks",
                        smallFont);
                statsPara.setSpacingAfter(20);
                document.add(statsPara);

                Paragraph pageFooter = new Paragraph("Page " + document.getPageNumber() + " | " + sheet.getTitle(),
                        smallFont);
                pageFooter.setAlignment(Element.ALIGN_CENTER);
                pageFooter.setSpacingBefore(20);
                document.add(pageFooter);

                sheetIndex++;
            }

            document.close();
            return baos.toByteArray();

        } catch (DocumentException e) {
            e.printStackTrace();
            return new byte[0];
        }
    }
}