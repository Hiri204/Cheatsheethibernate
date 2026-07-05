package cheatsheethibernate.controller;

import cheatsheethibernate.entity.Notification;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/notifications")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    /**
     * Get all notifications for the current user
     * URL: GET /notifications
     */
    @GetMapping
    public String getNotifications(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        List<Notification> notifications = notificationService.getNotificationsByUser(loginUser);
        long unreadCount = notificationService.getUnreadCount(loginUser);

        model.addAttribute("notifications", notifications);
        model.addAttribute("unreadCount", unreadCount);

        return "notifications";
    }

    /**
     * Get unread notifications count (AJAX)
     * URL: GET /notifications/unread-count
     */
    @GetMapping("/unread-count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUnreadCount(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("count", 0);
            response.put("authenticated", false);
            return ResponseEntity.ok(response);
        }

        long count = notificationService.getUnreadCount(loginUser);
        response.put("count", count);
        response.put("authenticated", true);

        return ResponseEntity.ok(response);
    }

    /**
     * Get recent notifications for dropdown (AJAX)
     * URL: GET /notifications/recent
     */
    @GetMapping("/recent")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getRecentNotifications(
            @RequestParam(value = "limit", defaultValue = "10") int limit,
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("authenticated", false);
            response.put("success", false);
            response.put("message", "User not logged in");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            List<Notification> notifications = notificationService.getRecentNotificationsByUser(loginUser, limit);
            long unreadCount = notificationService.getUnreadCount(loginUser);

            // 🎯 Convert to safe DTO format for JSON
            List<Map<String, Object>> notifList = new ArrayList<>();
            for (Notification n : notifications) {
                Map<String, Object> notifMap = new HashMap<>();
                notifMap.put("id", n.getId());
                notifMap.put("type", n.getType().name());
                notifMap.put("message", n.getMessage());
                notifMap.put("read", n.isRead());
                notifMap.put("createdAt", n.getCreatedAt() != null ? n.getCreatedAt().toString() : null);
                notifMap.put("entityType", n.getEntityType());
                notifMap.put("entityId", n.getEntityId());
                notifMap.put("actorId", n.getActorId());
                notifMap.put("linkUrl", n.getLinkUrl());
                notifList.add(notifMap);
            }

            response.put("authenticated", true);
            response.put("success", true);
            response.put("notifications", notifList);
            response.put("unreadCount", unreadCount);
            response.put("totalCount", notificationService.getTotalCount(loginUser));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("authenticated", false);
            response.put("success", false);
            response.put("message", "Error loading notifications: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Mark a notification as read
     * URL: POST /notifications/mark-read/{id}
     */
    @PostMapping("/mark-read/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markAsRead(@PathVariable("id") Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            notificationService.markAsRead(id);
            long unreadCount = notificationService.getUnreadCount(loginUser);

            response.put("success", true);
            response.put("unreadCount", unreadCount);
            response.put("message", "Notification marked as read");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Mark all notifications as read
     * URL: POST /notifications/mark-all-read
     */
    @PostMapping("/mark-all-read")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markAllAsRead(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            notificationService.markAllAsRead(loginUser);
            response.put("success", true);
            response.put("message", "All notifications marked as read");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Delete a notification
     * URL: POST /notifications/delete/{id}
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteNotification(@PathVariable("id") Long id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            notificationService.deleteNotification(id);
            response.put("success", true);
            response.put("message", "Notification deleted");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Delete all notifications for the current user
     * URL: POST /notifications/delete-all
     */
    @PostMapping("/delete-all")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteAllNotifications(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            notificationService.deleteAllByUser(loginUser);
            response.put("success", true);
            response.put("message", "All notifications deleted");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * View a single notification
     * URL: GET /notifications/view/{id}
     */
    @GetMapping("/view/{id}")
    public String viewNotification(@PathVariable("id") Long id, HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Notification notification = notificationService.getNotificationById(id);
        if (notification == null) {
            return "redirect:/notifications";
        }

        // Mark as read when viewed
        if (notification.isUnread()) {
            notificationService.markAsRead(id);
        }

        model.addAttribute("notification", notification);
        return "notification-detail";
    }
}