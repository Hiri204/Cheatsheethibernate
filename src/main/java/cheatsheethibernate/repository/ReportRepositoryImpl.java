package cheatsheethibernate.repository;

import cheatsheethibernate.entity.Report;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ReportRepositoryImpl implements ReportRepository {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    // ==========================================
    // 1. Report အသစ်တင်ရန် (ClassCastException ကိုဖြေရှင်းပြီး)
    // ==========================================
    @Override
    public Integer createReport(Integer cheatsheetId, Integer reportedBy, String reason) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_create_report(:p_cheatsheet_id, :p_reported_by, :p_reason)"
        );
        query.setParameter("p_cheatsheet_id", cheatsheetId);
        query.setParameter("p_reported_by", reportedBy);
        query.setParameter("p_reason", reason);
        
        // 🎯 BigInteger ကို Integer ပြောင်းမယ်
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }

    // ==========================================
    // 2. Report အားလုံးကိုပြရန်
    // ==========================================
    @Override
    public List<Report> getAllReports() {
        NativeQuery<Report> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_all_reports()", Report.class
        );
        return query.getResultList();
    }

    // ==========================================
    // 3. Report တစ်ခုကိုပြရန်
    // ==========================================
    @Override
    public Report getReportById(Integer reportId) {
        NativeQuery<Report> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_report_by_id(:p_report_id)", Report.class
        );
        query.setParameter("p_report_id", reportId);
        return query.getSingleResult();
    }

    // ==========================================
    // 4. Report ကို Resolve လုပ်ရန်
    // ==========================================
    @Override
    public Integer resolveReport(Integer reportId, String notes, Integer adminId) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_resolve_report(:p_report_id, :p_resolution_notes, :p_resolved_by)"
        );
        query.setParameter("p_report_id", reportId);
        query.setParameter("p_resolution_notes", notes);
        query.setParameter("p_resolved_by", adminId);
        
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }

    // ==========================================
    // 5. Report ကို Reject လုပ်ရန်
    // ==========================================
    @Override
    public Integer rejectReport(Integer reportId, String notes, Integer adminId) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_reject_report(:p_report_id, :p_resolution_notes, :p_resolved_by)"
        );
        query.setParameter("p_report_id", reportId);
        query.setParameter("p_resolution_notes", notes);
        query.setParameter("p_resolved_by", adminId);
        
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }

    // ==========================================
    // 6. Report ကနေ Ban လုပ်ရန်
    // ==========================================
    @Override
    public Integer banFromReport(Integer reportId, String notes, Integer adminId, String banReason, String banExpiresAt) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_ban_from_report(:p_report_id, :p_resolution_notes, :p_resolved_by, :p_ban_reason, :p_ban_expires_at)"
        );
        query.setParameter("p_report_id", reportId);
        query.setParameter("p_resolution_notes", notes);
        query.setParameter("p_resolved_by", adminId);
        query.setParameter("p_ban_reason", banReason);
        query.setParameter("p_ban_expires_at", banExpiresAt);
        
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }

    // ==========================================
    // 7. Report ကို Under Review ထားရန်
    // ==========================================
    @Override
    public Integer reviewReport(Integer reportId, String notes) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_review_report(:p_report_id, :p_resolution_notes)"
        );
        query.setParameter("p_report_id", reportId);
        query.setParameter("p_resolution_notes", notes);
        
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }

    // ==========================================
    // 8. Status အလိုက်ရှာရန်
    // ==========================================
    @Override
    public List<Report> getReportsByStatus(String status) {
        NativeQuery<Report> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_reports_by_status(:p_status)", Report.class
        );
        query.setParameter("p_status", status);
        return query.getResultList();
    }

    // ==========================================
    // 9. Report Count ယူရန်
    // ==========================================
    @Override
    public Long getReportCountByStatus(String status) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_report_count_by_status(:p_status)"
        );
        query.setParameter("p_status", status);
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).longValue();
        }
        return Long.parseLong(result.toString());
    }

    // ==========================================
    // 10. Report ဖျက်ရန်
    // ==========================================
    @Override
    public void deleteReport(Integer reportId) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_delete_report(:p_report_id)"
        );
        query.setParameter("p_report_id", reportId);
        query.executeUpdate();
    }

    // ==========================================
    // 11. Pending Report အကုန်ပြရန်
    // ==========================================
    @Override
    public List<Report> getPendingReports() {
        NativeQuery<Report> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_pending_reports()", Report.class
        );
        return query.getResultList();
    }

    // ==========================================
    // 12. Report Statistics ယူရန်
    // ==========================================
    @Override
    public Object[] getReportStatistics() {
        NativeQuery<Object[]> query = getCurrentSession().createNativeQuery(
            "CALL sp_get_report_statistics()", Object[].class
        );
        return query.getSingleResult();
    }

    // ==========================================
    // 13. Report ကိုပြန်ဖွင့်ရန်
    // ==========================================
    @Override
    public Integer reopenReport(Integer reportId) {
        NativeQuery<?> query = getCurrentSession().createNativeQuery(
            "CALL sp_reopen_report(:p_report_id)"
        );
        query.setParameter("p_report_id", reportId);
        
        Object result = query.getSingleResult();
        if (result instanceof Number) {
            return ((Number) result).intValue();
        }
        return Integer.parseInt(result.toString());
    }
}