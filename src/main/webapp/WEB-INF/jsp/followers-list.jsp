<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Followers · DevSheets</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
body {
	background: #f2f4f8;
	font-family: -apple-system, BlinkMacSystemFont, "Inter", "Segoe UI", Roboto, sans-serif;
	color: #1a1e2b;
	min-height: 100vh;
}
.main-content {
	margin-left: 260px;
	padding: 40px 48px 60px;
	min-height: 100vh;
}
.page-title {
	font-size: 1.8rem;
	font-weight: 700;
	letter-spacing: -0.02em;
}
.connection-card {
	background: #ffffff;
	border-radius: 20px;
	padding: 20px 24px;
	margin-bottom: 16px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.01), 0 1px 2px rgba(0, 0, 0, 0.02);
	transition: all 0.2s ease;
	border: 1px solid #f1f3f7;
}
.connection-card:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
}
.list-avatar-circle {
	width: 56px;
	height: 56px;
	border-radius: 50%;
	background: linear-gradient(135deg, #1a1e2b, #3b4252);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.4rem;
	font-weight: 600;
}
.list-avatar-img {
	width: 56px;
	height: 56px;
	border-radius: 50%;
	object-fit: cover;
}
.nav-pills-custom .nav-link {
	color: #6b7280;
	font-weight: 600;
	padding: 10px 24px;
	border-radius: 40px;
	transition: all 0.2s ease;
}
.nav-pills-custom .nav-link.active {
	background-color: #1a1e2b;
	color: #ffffff;
}
.btn-view-profile {
	background: transparent;
	color: #1a1e2b;
	border: 1.5px solid #e2e6ee;
	border-radius: 40px;
	padding: 6px 18px;
	font-weight: 600;
	font-size: 0.85rem;
	text-decoration: none;
	transition: all 0.2s ease;
}
.btn-view-profile:hover {
	background: #1a1e2b;
	color: #fff;
	border-color: #1a1e2b;
}
@media (max-width: 992px) {
	.main-content { margin-left: 0; padding: 24px 20px; }
}
</style>
</head>
<body>

	<jsp:include page="sidebar.jsp">
		<jsp:param name="activePage" value="profile" />
	</jsp:include>

	<div class="main-content">
		
		<div class="mb-4">
			<c:choose>
				<%-- ကိုယ့်အကောင့်ရဲ့ Follower list ကိုကြည့်နေတာဆိုရင် My Profile Dashboard (ပုံစံ ၁) ကိုသွားမယ် --%>
				<c:when test="${user.userId eq currentUser.userId}">
					<a href="${pageContext.request.contextPath}/profile/view" class="btn btn-sm btn-outline-secondary rounded-pill px-3 mb-3">
						<i class="fa-solid fa-arrow-left me-1"></i> Back to Profile
					</a>
				</c:when>
				<%-- သူများအကောင့်ရဲ့ Follower list ကိုကြည့်နေတာဆိုရင် Public Profile (ပုံစံ ၂) ကိုသွားမယ် --%>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/user/profile/${user.userId}" class="btn btn-sm btn-outline-secondary rounded-pill px-3 mb-3">
						<i class="fa-solid fa-arrow-left me-1"></i> Back to Profile
					</a>
				</c:otherwise>
			</c:choose>
			<h3 class="page-title text-capitalize">${user.username}'s Network</h3>
		</div>

		<!-- Nav Tabs -->
		<div class="d-flex justify-content-start mb-4">
			<ul class="nav nav-pills nav-pills-custom gap-2 p-1 bg-white rounded-pill shadow-sm">
				<li class="nav-item">
					<a class="nav-link active" href="${pageContext.request.contextPath}/user/followers/${user.userId}">
						<i class="fa-solid fa-users me-1"></i> Followers <span class="badge bg-light text-dark ms-1">${followerCount}</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="${pageContext.request.contextPath}/user/following/${user.userId}">
						<i class="fa-solid fa-user-plus me-1"></i> Following <span class="badge bg-light text-dark ms-1">${followingCount}</span>
					</a>
				</li>
			</ul>
		</div>

		<!-- Followers List -->
		<div class="row">
			<div class="col-lg-9 col-xl-8">
				<c:choose>
					<c:when test="${empty followers}">
						<div class="text-center py-5 bg-white rounded-4 border border-dashed">
							<i class="fa-solid fa-user-group text-muted mb-3" style="font-size: 3rem; opacity: 0.4;"></i>
							<h5 class="text-muted fw-semibold">No Followers yet</h5>
							<p class="text-muted small">When users follow this account, they will appear here.</p>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="fUser" items="${followers}">
							<div class="connection-card d-flex align-items-center justify-content-between flex-wrap gap-3">
								<div class="d-flex align-items-center gap-3">
									<c:choose>
										<c:when test="${not empty fUser.profileImg && fUser.profileImg ne 'default-avatar.png'}">
											<img src="${pageContext.request.contextPath}/uploads/${fUser.profileImg}" class="list-avatar-img" alt="${fUser.username}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
											<div class="list-avatar-circle" style="display: none;">
												${fn:toUpperCase(fn:substring(fUser.username, 0, 1))}
											</div>
										</c:when>
										<c:otherwise>
											<div class="list-avatar-circle">
												${fn:toUpperCase(fn:substring(fUser.username, 0, 1))}
											</div>
										</c:otherwise>
									</c:choose>

									<div>
										<h6 class="mb-0 fw-bold">
											${fUser.username}
											<c:if test="${fUser.userId eq currentUser.userId}">
												<span class="badge bg-secondary rounded-pill ms-1" style="font-size: 0.65rem;">You</span>
											</c:if>
										</h6>
										<small class="text-muted d-block">${fUser.email}</small>
									</div>
								</div>
								
								<div>
									<a href="${pageContext.request.contextPath}/user/profile/${fUser.userId}" class="btn-view-profile">
										View Profile
									</a>
								</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

	</div>

</body>
</html>