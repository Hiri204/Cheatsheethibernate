package cheatsheethibernate.service;

import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.Report;
import cheatsheethibernate.entity.Report.ReportStatus;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.repository.CheatSheetRepository;
import cheatsheethibernate.repository.ReportRepository;
import cheatsheethibernate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Service
@Transactional
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportRepository reportRepository;

    @Autowired
    private CheatSheetRepository cheatSheetRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NotificationService notificationService;

    // ==========================================
    // 🎯 Report Submission (Stored Procedure ခေါ်မယ်)
    // ==========================================

    @Override
    @Transactional
    public void submitReport(Integer userId, Long cheatSheetId, String reason) {
        // User နဲ့ CheatSheet ရှိမရှိစစ်မယ်
        User user = userRepository.getById(userId);
        CheatSheet cheatSheet = cheatSheetRepository.findById(cheatSheetId);

        if (user == null) {
            throw new IllegalArgumentException("User not found with ID: " + userId);
        }
        if (cheatSheet == null) {
            throw new IllegalArgumentException("CheatSheet not found with ID: " + cheatSheetId);
        }

        // 🎯 Stored Procedure ကိုခေါ်ပြီး Report ထည့်မယ် (၃ ကြောင်းပဲ)
        Integer reportId = reportRepository.createReport(
            cheatSheetId.intValue(),
            userId,
            reason
        );

        // Notification (Optional)
        if (cheatSheet.getUser() != null && !cheatSheet.getUser().getUserId().equals(userId)) {
            notificationService.notifyReport(cheatSheet.getUser(), reason);
        }
    }

    @Override
    @Transactional
    public void submitReportWithNotes(Integer userId, Long cheatSheetId, String reason, String additionalNotes) {
        String fullReason = reason;
        if (additionalNotes != null && !additionalNotes.trim().isEmpty()) {
            fullReason = reason + "\n\nAdditional Notes: " + additionalNotes;
        }
        submitReport(userId, cheatSheetId, fullReason);
    }

    // ==========================================
    // 🎯 Report Retrieval (Stored Procedure ခေါ်မယ်)
    // ==========================================

    @Override
    @Transactional(readOnly = true)
    public List<Report> getAllReports() {
        return reportRepository.getAllReports();  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getAllReportsWithDetails() {
        return reportRepository.getAllReports();  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public Report getReportById(Integer id) {
        if (id == null) {
            return null;
        }
        return reportRepository.getReportById(id);  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return reportRepository.getReportsByStatus(status);  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByStatus(ReportStatus status) {
        if (status == null) {
            return new ArrayList<>();
        }
        return getReportsByStatus(status.getValue());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByCheatSheet(Long cheatSheetId) {
        // CheatSheet ID နဲ့ ရှာဖို့ Stored Procedure မရှိသေးရင်
        // အကုန်ယူပြီး Filter လုပ်
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .filter(r -> r.getCheatSheet() != null && r.getCheatSheet().getId().equals(cheatSheetId))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByUser(Integer userId) {
        if (userId == null) {
            return new ArrayList<>();
        }
        // User ID နဲ့ ရှာဖို့ Stored Procedure မရှိသေးရင်
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .filter(r -> r.getReportedBy() != null && r.getReportedBy().getUserId().equals(userId))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByCheatSheetAndStatus(Long cheatSheetId, String status) {
        List<Report> reports = getReportsByCheatSheet(cheatSheetId);
        return reports.stream()
            .filter(r -> r.getStatus().equals(status))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByStatusIn(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return new ArrayList<>();
        }
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .filter(r -> statuses.contains(r.getStatus()))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        if (startDate == null || endDate == null) {
            return new ArrayList<>();
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date must be before end date");
        }
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .filter(r -> r.getCreatedAt() != null && 
                   !r.getCreatedAt().isBefore(startDate) && 
                   !r.getCreatedAt().isAfter(endDate))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getRecentReports(int limit) {
        if (limit <= 0) {
            return new ArrayList<>();
        }
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
            .limit(limit)
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> searchReports(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        String lowerKeyword = keyword.toLowerCase();
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .filter(r -> r.getReason() != null && 
                   r.getReason().toLowerCase().contains(lowerKeyword))
            .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getReportsNeedingAttention() {
        return reportRepository.getPendingReports();  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public List<Report> getPendingReportsOlderThan(int days) {
        if (days <= 0) {
            return new ArrayList<>();
        }
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        List<Report> pendingReports = reportRepository.getPendingReports();
        return pendingReports.stream()
            .filter(r -> r.getCreatedAt() != null && r.getCreatedAt().isBefore(cutoff))
            .collect(java.util.stream.Collectors.toList());
    }

    // ==========================================
    // 🎯 Report Administration (Stored Procedure ခေါ်မယ်)
    // ==========================================

    @Override
    @Transactional
    public void actionReport(Integer reportId, String status) {
        if (reportId == null || status == null) {
            throw new IllegalArgumentException("Report ID and status cannot be null");
        }

        Report report = reportRepository.getReportById(reportId);
        if (report == null) {
            throw new IllegalArgumentException("Report not found with ID: " + reportId);
        }

        // Status အလိုက် Stored Procedure ခေါ်မယ်
        switch (status) {
            case "resolved":
                reportRepository.resolveReport(reportId, "Resolved by admin", 1);
                break;
            case "rejected":
                reportRepository.rejectReport(reportId, "Rejected by admin", 1);
                break;
            case "under_review":
                reportRepository.reviewReport(reportId, "Under review by admin");
                break;
            default:
                throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    @Override
    @Transactional
    public void actionReport(Integer reportId, String status, String adminNotes, Integer adminId) {
        if (adminId == null) {
            throw new IllegalArgumentException("Admin ID cannot be null");
        }

        switch (status) {
            case "resolved":
                reportRepository.resolveReport(reportId, adminNotes, adminId);
                break;
            case "rejected":
                reportRepository.rejectReport(reportId, adminNotes, adminId);
                break;
            case "under_review":
                reportRepository.reviewReport(reportId, adminNotes);
                break;
            default:
                throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    @Override
    @Transactional
    public void resolveReport(Integer reportId, String resolutionNotes, Integer adminId) {
        if (reportId == null || adminId == null) {
            throw new IllegalArgumentException("Report ID and Admin ID cannot be null");
        }
        reportRepository.resolveReport(reportId, resolutionNotes, adminId);  // Stored Procedure
    }

    @Override
    @Transactional
    public void rejectReport(Integer reportId, String rejectionReason, Integer adminId) {
        if (reportId == null || adminId == null) {
            throw new IllegalArgumentException("Report ID and Admin ID cannot be null");
        }
        reportRepository.rejectReport(reportId, rejectionReason, adminId);  // Stored Procedure
    }

    @Override
    @Transactional
    public int bulkUpdateStatus(List<Integer> reportIds, String status, Integer adminId) {
        if (reportIds == null || reportIds.isEmpty()) {
            return 0;
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        if (adminId == null) {
            throw new IllegalArgumentException("Admin ID cannot be null");
        }

        int count = 0;
        for (Integer reportId : reportIds) {
            switch (status) {
                case "resolved":
                    reportRepository.resolveReport(reportId, "Bulk resolved by admin", adminId);
                    count++;
                    break;
                case "rejected":
                    reportRepository.rejectReport(reportId, "Bulk rejected by admin", adminId);
                    count++;
                    break;
                case "under_review":
                    reportRepository.reviewReport(reportId, "Bulk under review by admin");
                    count++;
                    break;
                default:
                    throw new IllegalArgumentException("Invalid status: " + status);
            }
        }
        return count;
    }

    // ==========================================
    // 🎯 Validation and Checks
    // ==========================================

    @Override
    @Transactional(readOnly = true)
    public boolean hasUserReportedSheet(Integer userId, Long cheatSheetId) {
        if (userId == null || cheatSheetId == null) {
            return false;
        }
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.stream()
            .anyMatch(r -> r.getReportedBy() != null && 
                    r.getReportedBy().getUserId().equals(userId) &&
                    r.getCheatSheet() != null &&
                    r.getCheatSheet().getId().equals(cheatSheetId));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasPendingReports(Long cheatSheetId) {
        if (cheatSheetId == null) {
            return false;
        }
        List<Report> pendingReports = reportRepository.getPendingReports();
        return pendingReports.stream()
            .anyMatch(r -> r.getCheatSheet() != null && 
                    r.getCheatSheet().getId().equals(cheatSheetId));
    }

    @Override
    @Transactional(readOnly = true)
    public long countByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return 0;
        }
        return reportRepository.getReportCountByStatus(status);  // Stored Procedure
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalReportCount() {
        List<Report> allReports = reportRepository.getAllReports();
        return allReports.size();
    }

    // ==========================================
    // 🎯 Statistics and Analytics
    // ==========================================

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getReportStatusDistribution() {
        Object[] stats = reportRepository.getReportStatistics();  // Stored Procedure
        Map<String, Long> distribution = new HashMap<>();
        
        // stats array: [total, pending, resolved, rejected, under_review, unique_cheatsheets, unique_reporters]
        if (stats != null && stats.length >= 5) {
            distribution.put("pending", ((Number) stats[1]).longValue());
            distribution.put("resolved", ((Number) stats[2]).longValue());
            distribution.put("rejected", ((Number) stats[3]).longValue());
            distribution.put("under_review", ((Number) stats[4]).longValue());
        }
        return distribution;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getDailyReportStats(LocalDateTime startDate, LocalDateTime endDate) {
        if (startDate == null || endDate == null) {
            return new ArrayList<>();
        }
        // Stored Procedure မရှိသေးရင်
        List<Report> reports = getReportsByDateRange(startDate, endDate);
        Map<LocalDateTime, Long> dailyStats = new HashMap<>();
        for (Report r : reports) {
            LocalDateTime date = r.getCreatedAt().toLocalDate().atStartOfDay();
            dailyStats.put(date, dailyStats.getOrDefault(date, 0L) + 1);
        }
        List<Object[]> result = new ArrayList<>();
        for (Map.Entry<LocalDateTime, Long> entry : dailyStats.entrySet()) {
            result.add(new Object[]{entry.getKey(), entry.getValue()});
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<Long, Long> getReportStatsByCheatSheet() {
        List<Report> allReports = reportRepository.getAllReports();
        Map<Long, Long> stats = new HashMap<>();
        for (Report r : allReports) {
            if (r.getCheatSheet() != null) {
                Long id = r.getCheatSheet().getId();
                stats.put(id, stats.getOrDefault(id, 0L) + 1);
            }
        }
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<Integer, Long> getReportStatsByUser() {
        List<Report> allReports = reportRepository.getAllReports();
        Map<Integer, Long> stats = new HashMap<>();
        for (Report r : allReports) {
            if (r.getReportedBy() != null) {
                Integer id = r.getReportedBy().getUserId();
                stats.put(id, stats.getOrDefault(id, 0L) + 1);
            }
        }
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public Double getAverageResolutionTime() {
        // Stored Procedure မရှိသေးရင်
        List<Report> resolvedReports = reportRepository.getReportsByStatus("resolved");
        if (resolvedReports.isEmpty()) {
            return null;
        }
        long totalHours = 0;
        int count = 0;
        for (Report r : resolvedReports) {
            if (r.getResolvedAt() != null && r.getCreatedAt() != null) {
                long hours = java.time.Duration.between(r.getCreatedAt(), r.getResolvedAt()).toHours();
                totalHours += hours;
                count++;
            }
        }
        return count > 0 ? (double) totalHours / count : null;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getTopReportedSheets(int limit) {
        if (limit <= 0) {
            return new ArrayList<>();
        }
        Map<Long, Long> stats = getReportStatsByCheatSheet();
        List<Object[]> result = new ArrayList<>();
        for (Map.Entry<Long, Long> entry : stats.entrySet()) {
            result.add(new Object[]{entry.getKey(), entry.getValue()});
        }
        result.sort((a, b) -> ((Long) b[1]).compareTo((Long) a[1]));
        return result.stream().limit(limit).collect(java.util.stream.Collectors.toList());
    }

    // ==========================================
    // 🎯 Report Management
    // ==========================================

    @Override
    @Transactional
    public void deleteReport(Integer reportId, Integer adminId) {
        if (reportId == null || adminId == null) {
            throw new IllegalArgumentException("Report ID and Admin ID cannot be null");
        }
        reportRepository.deleteReport(reportId);  // Stored Procedure
    }

    @Override
    @Transactional
    public int deleteReportsByCheatSheet(Long cheatSheetId, Integer adminId) {
        if (cheatSheetId == null || adminId == null) {
            throw new IllegalArgumentException("CheatSheet ID and Admin ID cannot be null");
        }
        List<Report> allReports = reportRepository.getAllReports();
        List<Integer> reportIds = allReports.stream()
            .filter(r -> r.getCheatSheet() != null && r.getCheatSheet().getId().equals(cheatSheetId))
            .map(Report::getId)
            .collect(java.util.stream.Collectors.toList());
        
        for (Integer id : reportIds) {
            reportRepository.deleteReport(id);
        }
        return reportIds.size();
    }

    @Override
    @Transactional
    public int deleteOldReports(int daysOld, Integer adminId) {
        if (daysOld <= 0 || adminId == null) {
            throw new IllegalArgumentException("Days old must be positive and Admin ID cannot be null");
        }
        LocalDateTime cutoff = LocalDateTime.now().minusDays(daysOld);
        List<Report> allReports = reportRepository.getAllReports();
        List<Integer> reportIds = allReports.stream()
            .filter(r -> r.getCreatedAt() != null && r.getCreatedAt().isBefore(cutoff))
            .map(Report::getId)
            .collect(java.util.stream.Collectors.toList());
        
        for (Integer id : reportIds) {
            reportRepository.deleteReport(id);
        }
        return reportIds.size();
    }

    @Override
    @Transactional
    public int archiveOldResolvedReports(int daysOld, Integer adminId) {
        if (daysOld <= 0 || adminId == null) {
            throw new IllegalArgumentException("Days old must be positive and Admin ID cannot be null");
        }
        LocalDateTime cutoff = LocalDateTime.now().minusDays(daysOld);
        List<Report> allReports = reportRepository.getAllReports();
        List<Integer> reportIds = allReports.stream()
            .filter(r -> r.getStatus().equals("resolved") && 
                   r.getResolvedAt() != null && r.getResolvedAt().isBefore(cutoff))
            .map(Report::getId)
            .collect(java.util.stream.Collectors.toList());
        
        for (Integer id : reportIds) {
            reportRepository.reopenReport(id);  // Reopen လုပ်ပြီး Archived လို့သတ်မှတ်
        }
        return reportIds.size();
    }
}