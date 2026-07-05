package cheatsheethibernate.controller;

import java.time.format.DateTimeFormatter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import cheatsheethibernate.entity.BannedUser;
import cheatsheethibernate.entity.User;
import cheatsheethibernate.service.CheatSheetService;
import cheatsheethibernate.service.UserService;
import cheatsheethibernate.service.FileUploadService;
import cheatsheethibernate.service.NotificationSettingService;

@Controller
public class AuthController {

    @Autowired
    private CheatSheetService cheatSheetService;

    @Autowired
    private UserService userService;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private NotificationSettingService notificationSettingService;

    // ❌ REMOVE THIS - HomeController က / ကိုထားပြီးသားမို့
    // @GetMapping("/")
    // public String redirectToLogin() {
    //     return "redirect:/login";
    // }

    /**
     * Show registration form
     * URL: /register
     */
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    /**
     * Process registration form
     * URL: /register (POST)
     */
    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user,
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("passwordHash") String passwordHash,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            HttpServletRequest request, Model model) {

        try {
            // Set user details
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(passwordHash);
            user.setRole("user");
            user.setStatus("active");

            // Handle profile image upload
            String uploadedFileName = fileUploadService.uploadProfileImage(profileImage, request);
            user.setProfileImg(uploadedFileName != null ? uploadedFileName : "default-avatar.png");

            // Register user using CheatSheetService
            cheatSheetService.registerUser(user);

            // Create default notification settings for new user
            notificationSettingService.createDefaultSettings(user);

            return "redirect:/login";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "Registration failed: " + e.getMessage());
            return "register";
        }
    }

    /**
     * Show login form
     * URL: /login
     */
    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    /**
     * Process login form
     * URL: /login (POST)
     */
    @PostMapping("/login")
    public String loginUser(@RequestParam("username") String loginId,
            @RequestParam("password") String password,
            HttpSession session, Model model) {

        // Find user by username or email using UserService
        User user = userService.findByUsernameOrEmail(loginId);

        if (user == null) {
            model.addAttribute("error", "Invalid username or password.");
            return "login";
        }

        // Verify password using CheatSheetService
        User validatedUser = userService.validateCredentials(user.getUsername(), password);
        if (validatedUser == null) {
            model.addAttribute("error", "Invalid username or password.");
            return "login";
        }

        // Check if user is suspended
        if ("suspended".equals(user.getStatus())) {
            BannedUser banInfo = userService.getBanInfo(user.getUserId());

            String reason = (banInfo != null && banInfo.getReason() != null && !banInfo.getReason().isEmpty())
                    ? banInfo.getReason()
                    : "No specific reason provided. Please contact support for more information.";

            String duration = "Permanent";
            if (banInfo != null && banInfo.getExpiresAt() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                duration = "Until " + banInfo.getExpiresAt().format(formatter);
            }

            model.addAttribute("isBanned", "true");
            model.addAttribute("banReason", reason);
            model.addAttribute("banDuration", duration);
            model.addAttribute("error", "Your account has been suspended. Please check the notification for details.");

            return "login";
        }

        // Successful login
        session.setAttribute("loginUser", user);
        return "redirect:/dashboard";
    }

    /**
     * Logout user
     * URL: /logout
     */
    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}