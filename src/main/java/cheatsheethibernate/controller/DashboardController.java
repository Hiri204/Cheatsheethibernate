package cheatsheethibernate.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import cheatsheethibernate.entity.CheatSheet;
import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.AdminContentService;
import cheatsheethibernate.service.CheatSheetService;
import cheatsheethibernate.service.NotificationService;
import cheatsheethibernate.service.NotificationSettingService;
import cheatsheethibernate.service.UserService;

@Controller
public class DashboardController {

    @Autowired
    private AdminContentService adminContentService;

    @Autowired
    private UserService userService;

    @Autowired
    private CheatSheetService cheatSheetService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private NotificationSettingService notificationSettingService; // 🎯 Inject လုပ်ပါ

    /**
     * ၁။ မူလ Dashboard ကို ပြသပေးမည့်နေရာ
     * URL: GET /dashboard
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        // ဝင်ထားသော User ရှိမရှိ စစ်ဆေးခြင်း
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // ၂။ Categories များကို Model ထဲသို့ ထည့်သွင်းခြင်း
        model.addAttribute("categories", adminContentService.getAllCategories());

        // ၃။ Users များကို Model ထဲသို့ ထည့်သွင်းခြင်း
        model.addAttribute("users", userService.getAllUsers());

        // ၄။ Count များကို Model ထဲသို့ ထည့်သွင်းခြင်း
        model.addAttribute("userCount", userService.getTotalUserCount());
        model.addAttribute("sheetCount", cheatSheetService.getTotalSheetCount());
        model.addAttribute("categoryCount", adminContentService.getAllCategories().size());

        // ၅။ Notification data များကို Model ထဲသို့ ထည့်သွင်းခြင်း (bell icon နဲ့ sidebar အတွက်)
        // 🎯 Settings ကိုစစ်ပြီးမှ Unread Count ကိုယူမယ်
        NotificationSetting settings = notificationSettingService.getSettingsByUser(loginUser);
        
        // 🎯 Settings မရှိရင် Default ဆောက်ပေးမယ်
        if (settings == null) {
            notificationSettingService.createDefaultSettings(loginUser);
            settings = notificationSettingService.getSettingsByUser(loginUser);
        }
        
        // 🎯 Settings ကိုပါ Model ထဲထည့်မယ် (JSP မှာ သုံးဖို့)
        model.addAttribute("settings", settings);
        
        // 🎯 Unread count ကိုယူမယ် (Settings ကိုပါထည့်ပြီး)
        long unreadCount = notificationService.getUnreadCount(loginUser);
        model.addAttribute("unreadCount", unreadCount);

        return "dashboard"; // dashboard.jsp သို့ သွားမည်
    }

    // 💡 ရှင်းလင်းချက် - Ambiguous mapping (URL ထပ်ခြင်း) မဖြစ်စေရန်အတွက် 
    // ယခင်က ပါဝင်ခဲ့သော GET /profile နှင့် POST /profile/update Method များကို 
    // ဤနေရာမှ လုံးဝ (လုံးဝ) ဖယ်ထုတ်/ဖျက်ပစ်လိုက်ပြီ ဖြစ်ပါသည်ဗျာ။
    // ထိုလုပ်ဆောင်ချက်များကို ProfileController.java ထဲတွင် သီးသန့် အလုပ်လုပ်ခိုင်းထားပါသည်။
}