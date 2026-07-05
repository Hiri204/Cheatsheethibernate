package cheatsheethibernate.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import cheatsheethibernate.entity.Category;
import cheatsheethibernate.service.AdminContentService;

@Controller
public class HomeController {

    @Autowired
    private AdminContentService adminContentService;

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        // Database ကနေ Category အကုန်ယူမယ်
        List<Category> categories = adminContentService.getAllCategories();
        
        // Category တစ်ခုချင်းစီအတွက် sheet count ထည့်မယ်
        for (Category category : categories) {
            if (category.getCheatSheets() != null) {
                category.setSheetCount(category.getCheatSheets().size());
            } else {
                category.setSheetCount(0);
            }
        }
        
        model.addAttribute("categories", categories);
        return "home";  // home.jsp ကိုပြမယ်
    }
}