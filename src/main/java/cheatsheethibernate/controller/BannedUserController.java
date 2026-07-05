package cheatsheethibernate.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.entity.BannedUser;
import cheatsheethibernate.service.BannedUserService;
import cheatsheethibernate.service.UserService;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/user")
public class BannedUserController {

    @Autowired
    private BannedUserService bannedUserService;

    @Autowired
    private UserService userService;

    // =================================================================
    // 🎯 ၁။ Banned Users စာရင်းအား စာမျက်နှာအသစ်သီးသန့်ဖြင့် ပြသရန်
    // URL: GET /admin/user/banned-list
    // =================================================================
    @GetMapping("/banned-list")
    public String showBannedListPage(Model model, HttpSession session) {
        User admin = (User) session.getAttribute("loginUser");
        if (admin == null) {
            return "redirect:/login";
        }

        // Database ထဲမှ Banned ဖြစ်နေသော အသုံးပြုသူများစာရင်းကို ဆွဲထုတ်ပြီး Model ထဲထည့်ခြင်း
        List<BannedUser> bannedUsers = bannedUserService.getAllActiveBans();
        model.addAttribute("bannedUsers", bannedUsers);

        return "admin/banned-list"; // admin/banned-list.jsp စာမျက်နှာသစ်သို့ ညွှန်းဆိုခြင်း
    }

    // =================================================================
    // 🎯 ၂။ User အား Ban လိုက်သည့်ပုံစံ ချက်ချင်းပြောင်းလဲသွားစေရန်
    // URL: POST /admin/user/ban
    // =================================================================
    @PostMapping("/ban")
    public String banUser(
            @RequestParam("userId") Integer userId,
            @RequestParam("reason") String reason,
            @RequestParam("banDuration") String banDuration,
            HttpSession session) {

        User admin = (User) session.getAttribute("loginUser");
        if (admin == null) {
            return "redirect:/login";
        }
        Integer adminId = admin.getUserId();

        try {
            // 1. Update user status to 'suspended'
            User targetUser = userService.getById(userId);
            if (targetUser != null) {
                targetUser.setStatus("suspended");
                targetUser.setSuspensionReason(reason);
                userService.updateUser(targetUser);
            }

            // 2. Calculate expiry date based on duration
            LocalDateTime expiresAt = null;
            if ("3 Days".equals(banDuration)) {
                expiresAt = LocalDateTime.now().plusDays(3);
            } else if ("7 Days".equals(banDuration)) {
                expiresAt = LocalDateTime.now().plusDays(7);
            } else if ("30 Days".equals(banDuration)) {
                expiresAt = LocalDateTime.now().plusDays(30);
            } else if ("Permanent".equals(banDuration)) {
                // 💡 Permanent အတွက် နှစ် ၁၀၀ ပေါင်းထည့်လိုက်ပါ
                expiresAt = LocalDateTime.now().plusYears(100);
            }

            // 3. Save ban record
            bannedUserService.banUser(userId, adminId, reason, banDuration, expiresAt);

        } catch (Exception e) {
            System.out.println("Error during banning user: " + e.getMessage());
            e.printStackTrace();
        }

        return "redirect:/user/list";
    }

    // =================================================================
    // 🎯 ၃။ User အား Unban လိုက်လျှင် List မှ ချက်ချင်းပျောက်သွားစေရန်
    // URL: POST /admin/user/unban
    // =================================================================
    @PostMapping("/unban")
    public String unbanUser(@RequestParam("userId") Integer userId, HttpSession session) {

        User admin = (User) session.getAttribute("loginUser");
        if (admin == null) {
            return "redirect:/login";
        }

        try {
            // 1. Update user status to 'active'
            User targetUser = userService.getById(userId);
            if (targetUser != null) {
                targetUser.setStatus("active");
                targetUser.setSuspensionReason(null);
                userService.updateUser(targetUser);
            }

            // 2. Unban the user (soft delete)
            bannedUserService.unbanUser(userId);

        } catch (Exception e) {
            System.out.println("Error during unbanning user: " + e.getMessage());
            e.printStackTrace();
        }

        return "redirect:/user/list";
    }
}