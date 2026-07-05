package cheatsheethibernate.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import cheatsheethibernate.entity.User;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // ============================================================
        // 🔓 PUBLIC URLs - Login မလိုဘူး (Bypass)
        // ============================================================
        if (uri.equals(contextPath + "/") ||
            uri.equals(contextPath + "/home") ||
            uri.contains("/login") ||
            uri.contains("/register") ||
            uri.contains("/logout") ||
            uri.contains("/cheatsheets/category/") ||
            uri.contains("/cheatsheets/view/") ||
            uri.contains("/cheatsheets/tag/") ||
            uri.contains("/cheatsheets/search") ||
            uri.contains("/cheatsheets/comments/") ||
            uri.contains("/uploads/") ||
            uri.contains("/css/") ||
            uri.contains("/js/") ||
            uri.contains("/images/")) {
            return true; // ✅ Skip login check
        }
        
        // ============================================================
        // 🔒 CHECK LOGIN - ဒီနေရာရောက်ရင် Login လုပ်ထားရမယ်
        // ============================================================
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginUser");
        
        if (user == null) {
            // Login မလုပ်ရင် Login Page ကိုပို့မယ်
            response.sendRedirect(contextPath + "/login");
            return false;
        }
        
        // ============================================================
        // 🔒 ADMIN CHECK - Admin အတွက် သီးသန့်
        // ============================================================
        if (uri.contains("/admin/")) {
            // Database ထဲက တန်ဖိုးအတိုင်း အသေး/အကြီး မခွဲခြားဘဲ စစ်ဆေးပါ
            if (user.getRole() == null || !"admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(contextPath + "/dashboard?error=access_denied");
                return false;
            }
        }
        
        return true;
    }
}