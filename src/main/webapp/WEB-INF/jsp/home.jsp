<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CheatSheet - Home</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        /* ===== RESET & BASE ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: #ffffff;
            color: #1a1a1a;
            min-height: 100vh;
        }

        /* ===== NAVBAR ===== */
        .navbar-custom {
            background: #ffffff;
            padding: 18px 0;
            border-bottom: 1px solid #f0f0f0;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
        }

        .navbar-custom .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.5px;
            text-decoration: none;
        }

        .navbar-custom .navbar-brand i {
            color: #1a1a1a;
        }

        .navbar-custom .nav-link {
            color: #555555;
            font-weight: 500;
            font-size: 0.95rem;
            padding: 8px 16px;
            transition: color 0.2s;
            text-decoration: none;
        }

        .navbar-custom .nav-link:hover {
            color: #1a1a1a;
        }

        .navbar-custom .nav-link.active {
            color: #1a1a1a;
            font-weight: 600;
        }

        .btn-nav-primary {
            background: #1a1a1a;
            color: #ffffff;
            border: none;
            border-radius: 30px;
            padding: 10px 28px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-nav-primary:hover {
            background: #333333;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn-nav-outline {
            background: transparent;
            color: #1a1a1a;
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            padding: 10px 28px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-nav-outline:hover {
            background: #f5f5f5;
            border-color: #1a1a1a;
            color: #1a1a1a;
        }

        /* ===== HERO SECTION ===== */
        .hero-section {
            padding: 80px 0 60px;
            text-align: center;
            background: linear-gradient(180deg, #fafafa 0%, #ffffff 100%);
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 800;
            letter-spacing: -1.5px;
            line-height: 1.1;
            color: #1a1a1a;
        }

        .hero-section h1 .highlight {
            background: linear-gradient(135deg, #1a1a1a, #4a4a4a);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-section p {
            font-size: 1.2rem;
            color: #6c757d;
            max-width: 600px;
            margin: 20px auto 30px;
            line-height: 1.6;
        }

        .hero-section .btn-hero {
            background: #1a1a1a;
            color: #ffffff;
            border: none;
            border-radius: 30px;
            padding: 14px 40px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .hero-section .btn-hero:hover {
            background: #333333;
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            color: #ffffff;
        }

        .hero-section .btn-hero-outline {
            background: transparent;
            color: #1a1a1a;
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            padding: 14px 40px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-left: 12px;
        }

        .hero-section .btn-hero-outline:hover {
            background: #f5f5f5;
            border-color: #1a1a1a;
            transform: translateY(-3px);
        }

        /* ===== CATEGORIES SECTION ===== */
        .categories-section {
            padding: 60px 0 80px;
            background: #ffffff;
        }

        .categories-section .section-title {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #1a1a1a;
        }

        .categories-section .section-subtitle {
            color: #6c757d;
            font-size: 1.05rem;
            margin-bottom: 40px;
        }

        /* Category Card */
        .category-card {
            background: #ffffff;
            border: 1px solid #f0f0f0;
            border-radius: 20px;
            padding: 32px 24px;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
            text-decoration: none;
            color: inherit;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .category-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
            border-color: #e0e0e0;
        }

        .category-card .category-icon {
            width: 72px;
            height: 72px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 2rem;
            transition: all 0.3s;
        }

        .category-card:hover .category-icon {
            transform: scale(1.05);
        }

        .category-icon.color-1 { background: #f3f0ff; color: #7c5cfc; }
        .category-icon.color-2 { background: #e8f4fd; color: #3b82f6; }
        .category-icon.color-3 { background: #e6f7ed; color: #22c55e; }
        .category-icon.color-4 { background: #fef3e8; color: #f59e0b; }
        .category-icon.color-5 { background: #fdf2f8; color: #ec4899; }
        .category-icon.color-6 { background: #e6f9f8; color: #14b8a6; }
        .category-icon.color-7 { background: #fee9e7; color: #ef4444; }
        .category-icon.color-8 { background: #eef2ff; color: #6366f1; }

        .category-card .category-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .category-card .category-count {
            font-size: 0.85rem;
            color: #9c9c9c;
        }

        .category-card .category-arrow {
            position: absolute;
            bottom: 16px;
            right: 20px;
            color: #d0d0d0;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .category-card:hover .category-arrow {
            color: #1a1a1a;
            transform: translateX(4px);
        }

        .empty-state {
            padding: 60px 20px;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            color: #d0d0d0;
            margin-bottom: 20px;
        }

        /* ============================================================
           🆕 ABOUT SECTION
           ============================================================ */
        .about-section {
            padding: 80px 0;
            background: #f8f9fa;
        }

        .about-section .section-title {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #1a1a1a;
        }

        .about-section .section-subtitle {
            color: #6c757d;
            font-size: 1.05rem;
            margin-bottom: 40px;
        }

        .team-card {
            background: #ffffff;
            border: 1px solid #f0f0f0;
            border-radius: 20px;
            padding: 24px 20px;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
        }

        .team-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
            border-color: #e0e0e0;
        }

        .team-card .team-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 16px;
            border: 3px solid #f0f0f0;
            transition: all 0.3s;
        }

        .team-card:hover .team-avatar {
            border-color: #1a1a1a;
            transform: scale(1.05);
        }

        .team-card .team-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .team-card .team-role {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .team-card .team-role i {
            color: #1a1a1a;
            margin-right: 4px;
        }

        /* ===== FOOTER ===== */
        .footer-custom {
            background: #fafafa;
            padding: 40px 0 30px;
            border-top: 1px solid #f0f0f0;
        }

        .footer-custom .footer-brand {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a1a1a;
            text-decoration: none;
        }

        .footer-custom .footer-brand i {
            color: #1a1a1a;
        }

        .footer-custom .footer-text {
            color: #9c9c9c;
            font-size: 0.9rem;
        }

        .footer-custom .footer-link {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .footer-custom .footer-link:hover {
            color: #1a1a1a;
        }

        .footer-custom .social-link {
            color: #9c9c9c;
            font-size: 1.1rem;
            margin-left: 16px;
            transition: color 0.2s;
        }

        .footer-custom .social-link:hover {
            color: #1a1a1a;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.2rem;
            }
            .hero-section p {
                font-size: 1rem;
            }
            .hero-section {
                padding: 50px 0 40px;
            }
            .categories-section .section-title {
                font-size: 1.6rem;
            }
            .about-section .section-title {
                font-size: 1.6rem;
            }
            .navbar-custom .navbar-brand {
                font-size: 1.2rem;
            }
            .btn-hero, .btn-hero-outline {
                width: 100%;
                margin-left: 0 !important;
                margin-top: 10px;
                text-align: center;
            }
            .team-card .team-avatar {
                width: 80px;
                height: 80px;
            }
        }

        @media (max-width: 576px) {
            .hero-section h1 {
                font-size: 1.8rem;
            }
            .category-card {
                padding: 24px 16px;
            }
        }
    </style>
</head>
<body>

    <!-- ============================================================
    NAVBAR
    ============================================================ -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fa-solid fa-feather-pointed me-2"></i>CheatSheet
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="btn-nav-outline" href="${pageContext.request.contextPath}/login">Log In</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn-nav-primary" href="${pageContext.request.contextPath}/register">Get Started</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ============================================================
    HERO SECTION
    ============================================================ -->
    <section class="hero-section">
        <div class="container">
            <h1>
                Transform How You<br />
                <span class="highlight">Organize Code & Knowledge</span>
            </h1>
            <p>
                Discover, share, and manage cheat sheets effortlessly.
                Streamline your learning with categorized code snippets,
                tips, and tricks—all in one place.
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/register" class="btn-hero">
                    <i class="fa-solid fa-rocket me-2"></i>Get Started Free
                </a>
                <a href="#categories" class="btn-hero-outline">
                    <i class="fa-regular fa-compass me-2"></i>Explore Categories
                </a>
            </div>
        </div>
    </section>

    <!-- ============================================================
    CATEGORIES SECTION
    ============================================================ -->
    <section class="categories-section" id="categories">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">Browse Categories</h2>
                <p class="section-subtitle">
                    Find the perfect cheat sheet for your needs
                </p>
            </div>

            <div class="row g-4">
                <c:forEach items="${categories}" var="category" varStatus="status">
                    <div class="col-md-6 col-lg-3">
                        <a href="${pageContext.request.contextPath}/cheatsheets/category/${category.name}" 
                           class="category-card">
                            <div class="category-icon color-${(status.index % 8) + 1}">
                                <i class="fa-solid fa-folder"></i>
                            </div>
                            <div class="category-name">${category.name}</div>
                            <div class="category-count">
                                ${category.sheetCount} cheat sheet${category.sheetCount > 1 ? 's' : ''}
                            </div>
                            <div class="category-arrow">
                                <i class="fa-solid fa-arrow-right"></i>
                            </div>
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty categories}">
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fa-regular fa-folder-open"></i>
                            <h5>No Categories Found</h5>
                            <p class="text-muted">Please add some categories to get started.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <!-- ============================================================
    🆕 ABOUT SECTION - Team Members
    ============================================================ -->
    <section class="about-section" id="about">
        <div class="container">
            <div class="text-center">
                <h2 class="section-title">Merge Conflict Masters</h2>
                <p class="section-subtitle">
                    The passionate developers behind CheatSheet
                </p>
            </div>

            <div class="row g-4 justify-content-center">
                
                <!-- ===== Team Member 1 ===== -->
               <div class="col-md-6 col-lg-3">
    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/nyi-nyi-min-khant.jpg" 
             alt="Nyi Nyi Min Khant" 
             class="team-avatar"
             onerror="this.src='https://ui-avatars.com/api/?name=Nyi+Nyi+Min+Khant&background=1a1a1a&color=fff&size=100'" />
        <div class="team-name">Nyi Nyi Min Khant</div>
        <div class="team-role">
            <i class="fa-solid fa-crown"></i> Admin / Project Lead
        </div>
        <div class="team-role" style="font-size:0.75rem; color:#9c9c9c; margin-top:4px;">
            <i class="fa-solid fa-star"></i> Team's unofficial Error Solver
        </div>
    </div>
</div>

                <!-- ===== Team Member 2 ===== -->
               <!-- ===== Team Member: Aung Pyae Hein (Team 2 - CRUD) ===== -->
<div class="col-md-6 col-lg-3">
    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/aung-pyae-hein.jpg" 
             alt="Aung Pyae Hein" 
             class="team-avatar"
             onerror="this.src='https://ui-avatars.com/api/?name=Aung+Pyae+Hein&background=1a1a1a&color=fff&size=100&bold=true'" />
        <div class="team-name">Aung Pyae Hein</div>
        <div class="team-role">
            <i class="fa-solid fa-code"></i> CRUD Operations
        </div>
        <div class="team-role" style="font-size:0.75rem; color:#9c9c9c; margin-top:4px;">
            <i class="fa-solid fa-users"></i> Member2
        </div>
    </div>
</div>

                <!-- ===== Team Member 3 ===== -->
                <div class="col-md-6 col-lg-3">
    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/su-thet-hlyar.jpg" 
             alt="Su Thet Hlyar" 
             class="team-avatar"
             onerror="this.src='https://ui-avatars.com/api/?name=Su+Thet+Hlyar&background=1a1a1a&color=fff&size=100&bold=true'" />
        <div class="team-name">Su Thet Hlyar</div>
        <div class="team-role">
            <i class="fa-solid fa-crown"></i> Admin
        </div>
        <div class="team-role" style="font-size:0.75rem; color:#9c9c9c; margin-top:4px;">
            <i class="fa-solid fa-users"></i> Member 3
        </div>
    </div>
</div>
                <!-- ===== Team Member 4 ===== -->
                <!-- ===== Team Member: Yan Lin Aung (Team 4 - CRUD) ===== -->
<div class="col-md-6 col-lg-3">
    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/yan-lin-aung.jpg" 
             alt="Yan Lin Aung" 
             class="team-avatar"
             onerror="this.src='https://ui-avatars.com/api/?name=Yan+Lin+Aung&background=1a1a1a&color=fff&size=100&bold=true'" />
        <div class="team-name">Yan Lin Aung</div>
        <div class="team-role">
            <i class="fa-solid fa-code"></i> CRUD Operations
        </div>
        <div class="team-role" style="font-size:0.75rem; color:#9c9c9c; margin-top:4px;">
            <i class="fa-solid fa-users"></i> Member 4
        </div>
    </div>
</div>

            </div>
        </div>
    </section>

    <!-- ============================================================
    FOOTER
    ============================================================ -->
    <footer class="footer-custom">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-4 text-center text-md-start mb-3 mb-md-0">
                    <a href="${pageContext.request.contextPath}/" class="footer-brand">
                        <i class="fa-solid fa-feather-pointed me-2"></i>CheatSheet
                    </a>
                    <p class="footer-text mt-1 mb-0">
                        &copy; 2026 CheatSheet. All rights reserved.
                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <a href="#" class="footer-link me-3">About</a>
                    <a href="#" class="footer-link me-3">Privacy</a>
                    <a href="#" class="footer-link">Contact</a>
                </div>
                <div class="col-md-4 text-center text-md-end">
                    <a href="#" class="social-link"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#" class="social-link"><i class="fa-brands fa-github"></i></a>
                    <a href="#" class="social-link"><i class="fa-brands fa-linkedin"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>