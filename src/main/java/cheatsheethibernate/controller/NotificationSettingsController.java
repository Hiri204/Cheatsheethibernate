package cheatsheethibernate.controller;

import cheatsheethibernate.entity.NotificationSetting;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.NotificationSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/notifications")
public class NotificationSettingsController {

    @Autowired
    private NotificationSettingService notificationSettingService;

    @GetMapping("/settings")
    public String showSettings(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        NotificationSetting settings = notificationSettingService.getSettingsByUser(loginUser);
        model.addAttribute("settings", settings);
        return "notification-settings";
    }

    @PostMapping("/settings/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateSettings(
            @RequestParam(value = "like", defaultValue = "true") boolean like,
            @RequestParam(value = "comment", defaultValue = "true") boolean comment,
            @RequestParam(value = "reply", defaultValue = "true") boolean reply,
            @RequestParam(value = "review", defaultValue = "true") boolean review,
            @RequestParam(value = "follow", defaultValue = "true") boolean follow,
            @RequestParam(value = "announcement", defaultValue = "true") boolean announcement,
            @RequestParam(value = "ban", defaultValue = "true") boolean ban,
            @RequestParam(value = "report", defaultValue = "true") boolean report,
            @RequestParam(value = "newSheet", defaultValue = "true") boolean newSheet,
            @RequestParam(value = "email", defaultValue = "true") boolean email,
            @RequestParam(value = "frequency", defaultValue = "5") Integer frequency,
            @RequestParam(value = "bannerStyle", defaultValue = "default") String bannerStyle,
            @RequestParam(value = "quietFrom", defaultValue = "22:00") String quietFrom,
            @RequestParam(value = "quietTo", defaultValue = "07:00") String quietTo,
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(401).body(response);
        }

        try {
            NotificationSetting setting = notificationSettingService.getSettingsByUser(loginUser);
            
            setting.setLikeNotifications(like);
            setting.setCommentNotifications(comment);
            setting.setReplyNotifications(reply);
            setting.setReviewNotifications(review);
            setting.setFollowNotifications(follow);
            setting.setAnnouncementNotifications(announcement);
            setting.setBanNotifications(ban);
            setting.setReportNotifications(report);
            setting.setNewSheetNotifications(newSheet);
            setting.setEmailNotifications(email);
            setting.setFrequency(frequency);
            setting.setBannerStyle(bannerStyle);
            setting.setQuietFrom(quietFrom);
            setting.setQuietTo(quietTo);
            
            notificationSettingService.saveSettings(setting);

            response.put("success", true);
            response.put("message", "Settings updated successfully!");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error updating settings: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}