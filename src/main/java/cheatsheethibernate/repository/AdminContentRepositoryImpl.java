package cheatsheethibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import cheatsheethibernate.entity.Announcement;
import cheatsheethibernate.entity.Category;
import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.Tag;

@Repository
@Transactional
public class AdminContentRepositoryImpl implements AdminContentRepository {

    @Autowired
    private SessionFactory sessionFactory;

    // ==========================================
    // 🎯 Tag အလိုက် CheatSheet ရှာရန်
    // ==========================================
    @Override
    public List<CheatSheet> findSheetsByTagName(String tagName) {
        try {
            return sessionFactory.getCurrentSession()
                .createQuery("SELECT DISTINCT c FROM CheatSheet c JOIN c.tags t WHERE LOWER(t.name) = LOWER(:tagName)", CheatSheet.class)
                .setParameter("tagName", tagName)
                .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    // ==========================================
    // Categories
    // ==========================================
    @Override
    public List<Category> findAllCategories() {
        try {
            return sessionFactory.getCurrentSession()
                    .createQuery("FROM Category ORDER BY name ASC", Category.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public Category findCategoryById(int id) {
        try {
            return sessionFactory.getCurrentSession().get(Category.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void saveCategory(Category cat) { 
        try {
            sessionFactory.getCurrentSession().saveOrUpdate(cat);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void deleteCategory(int id) {
        try {
            Category cat = sessionFactory.getCurrentSession().get(Category.class, id);
            if (cat != null) {
                sessionFactory.getCurrentSession().delete(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==========================================
    // Tags
    // ==========================================
    @Override
    public List<Tag> findAllTags() {
        try {
            return sessionFactory.getCurrentSession()
                    .createQuery("FROM Tag ORDER BY name ASC", Tag.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    @Override
    public Tag findTagById(Integer id) {
        try {
            return sessionFactory.getCurrentSession().get(Tag.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public void saveTag(Tag tag) { 
        try {
            sessionFactory.getCurrentSession().saveOrUpdate(tag);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void deleteTag(Integer id) {
        try {
            Session session = sessionFactory.getCurrentSession();
            
            // 🎯 FIX: ကြားခံ Table (cheatsheet_tags) ထဲက ဒီ tag_id နဲ့ ငြိနေတဲ့ လင့်ခ်တွေကို Native SQL ဖြင့် အရင်ဆုံး ရှင်းထုတ်ခြင်း
            session.createNativeQuery("DELETE FROM cheatsheet_tags WHERE tag_id = :tagId")
                   .setParameter("tagId", id)
                   .executeUpdate();
                   
            // 🎯 တွယ်ငြိမှုအားလုံး ကင်းစင်သွားပြီဖြစ်၍ ပင်မ Tag Object ကို ရှာဖွေပြီး အပြီးဖျက်ချခြင်း
            Tag tag = session.get(Tag.class, id);
            if (tag != null) {
                session.delete(tag);
            }
        } catch (Exception e) {
            System.err.println("❌ Error occurred while deleting Tag ID: " + id);
            e.printStackTrace();
            // Controller အထိ Exception ရောက်သွားပြီး Rollback ဖြစ်အောင် throw ပြန်လုပ်ပေးသင့်ပါတယ် ဆရာ
            throw e; 
        }
    }

    // ==========================================
    // CheatSheet_Tags Mapping
    // ==========================================
    @Override
    public void addTagToCheatSheet(Long cheatSheetId, Integer tagId) {
        try {
            CheatSheet sheet = sessionFactory.getCurrentSession().get(CheatSheet.class, cheatSheetId);
            Tag tag = sessionFactory.getCurrentSession().get(Tag.class, tagId);
            
            if (sheet != null && tag != null) {
                // 🎯 Check if tag already exists
                if (!sheet.getTags().contains(tag)) {
                    sheet.getTags().add(tag);
                    sessionFactory.getCurrentSession().saveOrUpdate(sheet);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==========================================
    // Announcements
    // ==========================================
    @Override
    public List<Announcement> findAllAnnouncements() {
        try {
            return sessionFactory.getCurrentSession()
                    .createQuery("FROM Announcement ORDER BY id DESC", Announcement.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    @Override
    public void saveAnnouncement(Announcement ann) { 
        try {
            // 🎯 FIX: Ensure isActive is not null
            if (ann != null && ann.getIsActive() == null) {
                ann.setIsActive(true);
            }
            // 🎯 FIX: Ensure message is not null
            if (ann != null && (ann.getMessage() == null || ann.getMessage().trim().isEmpty())) {
                ann.setMessage(ann.getContent() != null ? ann.getContent() : "📢 New announcement from admin");
            }
            sessionFactory.getCurrentSession().saveOrUpdate(ann);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void deleteAnnouncement(Long id) {
        try {
            Announcement ann = sessionFactory.getCurrentSession().get(Announcement.class, id);
            if (ann != null) {
                sessionFactory.getCurrentSession().delete(ann);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}