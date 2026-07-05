package cheatsheethibernate.controller;

import cheatsheethibernate.service.JasperReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/jasper-report")
public class JasperReportController {

    @Autowired
    private JasperReportService jasperReportService;

    /**
     * Report Dashboard Page
     */
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        LocalDate now = LocalDate.now();
        model.addAttribute("currentYear", now.getYear());
        model.addAttribute("currentMonth", now.getMonthValue());
        return "admin/jasper-report-dashboard";
    }

    /**
     * 🎯 PDF Report တစ်ချက်နှိပ်ရင် တန်းရောက် (Download)
     */
    @GetMapping("/pdf")
    public ResponseEntity<byte[]> generatePDF(
            @RequestParam(value = "year", required = false) Integer year,
            @RequestParam(value = "month", required = false) Integer month) {
        
        // Default: လက်ရှိလ
        if (year == null || month == null) {
            LocalDate now = LocalDate.now();
            year = now.getYear();
            month = now.getMonthValue();
        }
        
        try {
            byte[] pdfBytes = jasperReportService.generateCheatSheetReportPDF(year, month);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", 
                "CheatSheet_Report_" + year + "_" + month + ".pdf");
            headers.setContentLength(pdfBytes.length);
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfBytes);
                    
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}