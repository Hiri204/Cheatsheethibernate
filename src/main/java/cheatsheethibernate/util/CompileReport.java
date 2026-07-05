package cheatsheethibernate.util;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

public class CompileReport {
    
    public static void main(String[] args) {
        try {
            // 🎯 Classpath ကနေဖတ်မယ် (WEB-INF/classes/reports/)
            InputStream jrxmlStream = CompileReport.class
                .getResourceAsStream("/reports/cheatsheet_report.jrxml");
            
            if (jrxmlStream == null) {
                System.err.println("❌ JRXML file not found in classpath!");
                System.err.println("📁 Please check: WEB-INF/classes/reports/cheatsheet_report.jrxml");
                return;
            }
            
            System.out.println("🔨 Compiling report...");
            System.out.println("📁 JRXML loaded from classpath");
            
            // 🎯 Compile လုပ်မယ် (InputStream ကနေ)
            JasperReport jasperReport = JasperCompileManager.compileReport(jrxmlStream);
            
            // 🎯 Jasper ဖိုင်ကို WEB-INF/classes/reports/ မှာ Save လုပ်မယ်
            String jasperPath = "src/main/webapp/WEB-INF/classes/reports/cheatsheet_report.jasper";
            File jasperFile = new File(jasperPath);
            
            // Folder ရှိမရှိစစ်ပြီး မရှိရင် ဆောက်မယ်
            jasperFile.getParentFile().mkdirs();
            
            // Jasper ဖိုင်ကို Save လုပ်မယ်
            try (FileOutputStream fos = new FileOutputStream(jasperFile)) {
                fos.write(JasperCompileManager.compileReportToFile(
                    "src/main/webapp/WEB-INF/classes/reports/cheatsheet_report.jrxml"
                ).getBytes());
            }
            
            // တစ်ခြားနည်းလမ်း - Jasper ကို တိုက်ရိုက် Save လုပ်
            JasperCompileManager.compileReportToFile(
                "src/main/webapp/WEB-INF/classes/reports/cheatsheet_report.jrxml",
                "src/main/webapp/WEB-INF/classes/reports/cheatsheet_report.jasper"
            );
            
            System.out.println("✅ Report compiled successfully!");
            System.out.println("📁 Jasper file: " + jasperPath);
            
        } catch (Exception e) {
            System.err.println("❌ Error compiling report: " + e.getMessage());
            e.printStackTrace();
        }
    }
}