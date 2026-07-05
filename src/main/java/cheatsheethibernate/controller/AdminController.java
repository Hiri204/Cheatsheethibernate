package cheatsheethibernate.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import cheatsheethibernate.entity.Announcement;
import cheatsheethibernate.entity.Category;
import cheatsheethibernate.entity.Tag;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.AdminContentService;
import cheatsheethibernate.service.NotificationService;
import cheatsheethibernate.service.UserService;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class AdminController {

    @Autowired
    private AdminContentService contentService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private UserService userService;

    // =================================================================
    // 👤 USER ROLE MANAGEMENT
    // =================================================================

    @PostMapping("/admin/user/toggle-role")
    public String toggleRole(@RequestParam Integer userId) {
        User user = userService.getById(userId);
        if (user != null) {
            if ("admin".equals(user.getRole())) {
                user.setRole("user");
            } else {
                user.setRole("admin");
            }
            userService.updateUser(user);
        }
        return "redirect:/user/list";
    }

    // =================================================================
    // 📢 ၁။ BROADCAST / ANNOUNCEMENT MANAGEMENT
    // =================================================================

    @GetMapping("/admin/broadcast/panel")
    public String showBroadcastPanel(Model model) {
        model.addAttribute("announcements", contentService.getAllAnnouncements());
        model.addAttribute("newAnnouncement", new Announcement());
        return "admin/broadcast-panel";
    }

    @PostMapping("/admin/broadcast/announcement/save")
    public String saveAnnouncement(@ModelAttribute("newAnnouncement") Announcement ann, HttpSession session) {
        // 🎯 Ensure announcement message is not null
        if (ann == null) {
            ann = new Announcement();
        }

        if (ann.getMessage() == null || ann.getMessage().trim().isEmpty()) {
            ann.setMessage(ann.getContent() != null ? ann.getContent() : "📢 New announcement from admin");
        }

        if (ann.getTitle() == null || ann.getTitle().trim().isEmpty()) {
            ann.setTitle("Announcement");
        }

        contentService.saveAnnouncement(ann);

        // 🎯 NOTIFICATION: Notify all users about the announcement
        User admin = (User) session.getAttribute("loginUser");
        List<User> allUsers = userService.getAllUsers();

        String message = ann.getMessage() != null ? ann.getMessage() : "📢 New announcement from admin";

        for (User user : allUsers) {
            if (user != null && (admin == null || !user.getUserId().equals(admin.getUserId()))) {
                notificationService.notifyAnnouncement(user, message);
            }
        }

        return "redirect:/admin/broadcast/panel";
    }

    @GetMapping("/admin/broadcast/announcement/delete/{id}")
    public String deleteAnnouncement(@PathVariable("id") Long id) {
        contentService.deleteAnnouncement(id);
        return "redirect:/admin/broadcast/panel";
    }

    // =================================================================
    // 📂 ၂။ METADATA (CATEGORY & TAG) MANAGEMENT
    // =================================================================

    @GetMapping("/admin/metadata/panel")
    public String showMetadataPanel(Model model) {
        model.addAttribute("categories", contentService.getAllCategories());
        model.addAttribute("tags", contentService.getAllTags());
        model.addAttribute("newCategory", new Category());
        model.addAttribute("newTag", new Tag());
        return "admin/metadata-panel";
    }

    @PostMapping("/admin/metadata/category/save")
    public String saveCategory(@ModelAttribute("newCategory") Category category) {
        contentService.saveCategory(category);
        return "redirect:/admin/metadata/panel";
    }

    @GetMapping("/admin/metadata/category/delete/{id}")
    public String deleteCategory(@PathVariable("id") int id) {
        contentService.deleteCategory(id);
        return "redirect:/admin/metadata/panel";
    }

    @PostMapping("/admin/metadata/tag/save")
    public String saveTag(@ModelAttribute("newTag") Tag tag) {
        contentService.saveTag(tag);
        return "redirect:/admin/metadata/panel";
    }

    @GetMapping("/admin/metadata/tag/delete/{id}")
    public String deleteTag(@PathVariable("id") Integer id) {
        contentService.deleteTag(id);
        return "redirect:/admin/metadata/panel";
    }

    @PostMapping("/admin/metadata/map-tag")
    public String mapTagToSheet(@RequestParam("sheetId") Long sheetId, @RequestParam("tagId") Integer tagId) {
        contentService.assignTagToCheatSheet(sheetId, tagId);
        return "redirect:/admin/metadata/panel";
    }

    // =================================================================
    // 📝 ၃။ METADATA UPDATE (EDIT) MAPPINGS
    // =================================================================

    @PostMapping("/admin/metadata/category/update/{id}")
    public String updateCategory(@PathVariable("id") int id, @RequestParam("name") String name) {
        Category category = contentService.findCategoryById(id);
        if (category != null) {
            category.setName(name);
            contentService.saveCategory(category);
        }
        return "redirect:/admin/metadata/panel";
    }

    @PostMapping("/admin/metadata/tag/update/{id}")
    public String updateTag(@PathVariable("id") Integer id, @RequestParam("name") String name) {
        Tag tag = contentService.findTagById(id);
        if (tag != null) {
            tag.setName(name);
            contentService.saveTag(tag);
        }
        return "redirect:/admin/metadata/panel";
    }

    // =================================================================
    // 🏷️ ၄။ TAG CLICK HANDLING
    // =================================================================

    @GetMapping("/admin/cheatsheets/tag/{tagName}")
    public String getAdminSheetsByTag(@PathVariable("tagName") String tagName, Model model) {
        model.addAttribute("sheets", contentService.findSheetsByTagName(tagName));
        model.addAttribute("categoryName", "Admin Tag: #" + tagName);
        return "category-list";
    }
}