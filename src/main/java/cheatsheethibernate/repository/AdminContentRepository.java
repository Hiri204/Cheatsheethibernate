package cheatsheethibernate.repository;

import java.util.List;

import cheatsheethibernate.entity.Announcement;
import cheatsheethibernate.entity.Category;
import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.Tag;

public interface AdminContentRepository {
    // ==========================================
    // Categories
    // ==========================================
    List<Category> findAllCategories();
    Category findCategoryById(int id);
    void saveCategory(Category cat);
    void deleteCategory(int id);

    // ==========================================
    // Tags
    // ==========================================
    List<Tag> findAllTags();
    Tag findTagById(Integer id);
    void saveTag(Tag tag);
    void deleteTag(Integer id);

    // ==========================================
    // CheatSheet_Tags Mapping
    // ==========================================
    void addTagToCheatSheet(Long cheatSheetId, Integer tagId);

    // ==========================================
    // Announcements
    // ==========================================
    List<Announcement> findAllAnnouncements();
    void saveAnnouncement(Announcement ann);
    void deleteAnnouncement(Long id);
    
    // ==========================================
    // 🎯 Tag အတွက် CheatSheet ရှာရန်
    // ==========================================
    List<CheatSheet> findSheetsByTagName(String tagName);
}