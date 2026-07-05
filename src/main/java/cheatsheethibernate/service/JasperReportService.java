package cheatsheethibernate.service;

import java.util.List;
import java.util.Map;

public interface JasperReportService {
    
    /**
     * Report Data ကိုယူမယ်
     */
    List<Object[]> getReportData(Integer year, Integer month);
    
    /**
     * Report Summary ကိုယူမယ်
     */
    Map<String, Object> getReportSummary(Integer year, Integer month);
    
    /**
     * PDF Report ထုတ်မယ် (တစ်ချက်နှိပ်ရင် တန်းရောက်)
     */
    byte[] generateCheatSheetReportPDF(Integer year, Integer month);
}