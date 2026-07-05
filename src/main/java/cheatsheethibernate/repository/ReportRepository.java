package cheatsheethibernate.repository;

import cheatsheethibernate.entity.Report;
import java.util.List;

public interface ReportRepository {
    
    // ==========================================
    // Stored Procedure ကိုခေါ်မယ် (Code ၃ ကြောင်းပဲ)
    // ==========================================
    
    // 1. Report အသစ်တင်ရန်
    Integer createReport(Integer cheatsheetId, Integer reportedBy, String reason);
    
    // 2. Report အားလုံးကိုပြရန်
    List<Report> getAllReports();
    
    // 3. Report တစ်ခုကိုပြရန်
    Report getReportById(Integer reportId);
    
    // 4. Report ကို Resolve လုပ်ရန်
    Integer resolveReport(Integer reportId, String notes, Integer adminId);
    
    // 5. Report ကို Reject လုပ်ရန်
    Integer rejectReport(Integer reportId, String notes, Integer adminId);
    
    // 6. Report ကနေ Ban လုပ်ရန်
    Integer banFromReport(Integer reportId, String notes, Integer adminId, String banReason, String banExpiresAt);
    
    // 7. Report ကို Under Review ထားရန်
    Integer reviewReport(Integer reportId, String notes);
    
    // 8. Status အလိုက်ရှာရန်
    List<Report> getReportsByStatus(String status);
    
    // 9. Report Count ယူရန်
    Long getReportCountByStatus(String status);
    
    // 10. Report ဖျက်ရန်
    void deleteReport(Integer reportId);
    
    // 11. Pending Report အကုန်ပြရန်
    List<Report> getPendingReports();
    
    // 12. Report Statistics ယူရန်
    Object[] getReportStatistics();
    
    // 13. Report ကိုပြန်ဖွင့်ရန်
    Integer reopenReport(Integer reportId);
}