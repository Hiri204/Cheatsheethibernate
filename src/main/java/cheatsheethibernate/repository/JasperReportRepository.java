package cheatsheethibernate.repository;

import java.util.List;

public interface JasperReportRepository {
    
    /**
     * Stored Procedure ကနေ Report Data ယူမယ်
     */
    List<Object[]> getReportData(Integer year, Integer month);
    
    /**
     * Stored Procedure ကနေ Report Summary ယူမယ်
     */
    Object[] getReportSummary(Integer year, Integer month);
}