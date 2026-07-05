package cheatsheethibernate.service;

import cheatsheethibernate.repository.JasperReportRepository;
import cheatsheethibernate.service.JasperReportService;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.*;

@Service
@Transactional
public class JasperReportServiceImpl implements JasperReportService {

    @Autowired
    private JasperReportRepository reportRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getReportData(Integer year, Integer month) {
        return reportRepository.getReportData(year, month);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getReportSummary(Integer year, Integer month) {
        Object[] row = reportRepository.getReportSummary(year, month);
        
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalCheatsheets", ((Number) row[0]).longValue());
        summary.put("totalRatings", ((Number) row[1]).longValue());
        summary.put("totalLikes", ((Number) row[2]).longValue());
        summary.put("totalViews", ((Number) row[3]).longValue());
        
        Object avgRatingObj = row[4];
        if (avgRatingObj instanceof BigDecimal) {
            summary.put("overallAvgRating", ((BigDecimal) avgRatingObj).doubleValue());
        } else if (avgRatingObj instanceof Double) {
            summary.put("overallAvgRating", avgRatingObj);
        } else if (avgRatingObj instanceof Number) {
            summary.put("overallAvgRating", ((Number) avgRatingObj).doubleValue());
        } else {
            summary.put("overallAvgRating", 0.0);
        }
        
        return summary;
    }

    @Override
    public byte[] generateCheatSheetReportPDF(Integer year, Integer month) {
        try {
            // 1. Data ကိုယူမယ်
            List<Object[]> dataList = getReportData(year, month);
            Map<String, Object> summary = getReportSummary(year, month);
            
            if (dataList.isEmpty()) {
                throw new RuntimeException("No data found for " + month + "/" + year);
            }
            
            // 2. Object[] ကို Map List အဖြစ်ပြောင်းမယ်
            Collection<Map<String, ?>> dataMaps = new ArrayList<>();
            for (Object[] row : dataList) {
                Map<String, Object> map = new HashMap<>();
                map.put("author", row[0]);
                map.put("createdDate", row[1]);
                map.put("cheatsheetTitle", row[2]);
                map.put("ratingCount", row[3]);
                map.put("likeCount", row[4]);
                map.put("viewCount", row[5]);
                
                Object avgRatingObj = row[6];
                if (avgRatingObj instanceof BigDecimal) {
                    map.put("avgRating", ((BigDecimal) avgRatingObj).doubleValue());
                } else if (avgRatingObj instanceof Double) {
                    map.put("avgRating", avgRatingObj);
                } else if (avgRatingObj instanceof Number) {
                    map.put("avgRating", ((Number) avgRatingObj).doubleValue());
                } else {
                    map.put("avgRating", 0.0);
                }
                
                map.put("status", row[7]);
                map.put("categoryName", row[8]);
                dataMaps.add(map);
            }
            
            // 🎯 3. JRXML Template ကို WEB-INF/classes/reports/ ကနေဖတ်မယ်
            InputStream reportStream = getClass().getResourceAsStream("/reports/cheatsheet_report.jrxml");
            if (reportStream == null) {
                throw new RuntimeException("Report template not found! Please add cheatsheet_report.jrxml to WEB-INF/classes/reports/");
            }
            
            // 4. Compile Report
            JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);
            
            // 5. Data Source
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(dataMaps);
            
            // 6. Parameters
            Map<String, Object> parameters = new HashMap<>();
            parameters.put("reportTitle", "CheatSheet Report - " + getMonthName(month) + " " + year);
            parameters.put("year", year);
            parameters.put("month", month);
            parameters.put("monthName", getMonthName(month));
            parameters.put("totalCheatsheets", summary.get("totalCheatsheets"));
            parameters.put("totalRatings", summary.get("totalRatings"));
            parameters.put("totalLikes", summary.get("totalLikes"));
            parameters.put("totalViews", summary.get("totalViews"));
            parameters.put("overallAvgRating", summary.get("overallAvgRating"));
            parameters.put("generatedDate", new java.util.Date());
            
            // 7. Fill Report
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);
            
            // 8. PDF Export
            return JasperExportManager.exportReportToPdf(jasperPrint);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error generating PDF: " + e.getMessage());
        }
    }

    private String getMonthName(int month) {
        String[] monthNames = {"January", "February", "March", "April", "May", "June",
                               "July", "August", "September", "October", "November", "December"};
        return monthNames[month - 1];
    }
}