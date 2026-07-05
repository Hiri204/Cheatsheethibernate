<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<title>My Bookmarks · Floe</title>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
body {
	background: #f0f2f5;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
		Helvetica, Arial, sans-serif;
	color: #1a1a1a;
	min-height: 100vh;
}

.main-content {
	margin-left: 260px;
	padding: 40px 50px;
	min-height: 100vh;
	background: #f0f2f5;
}

.page-title {
	font-size: 1.8rem;
	font-weight: 700;
	letter-spacing: -0.5px;
	color: #1a1a1a;
}

.bookmark-card {
	background: #ffffff;
	border-radius: 20px;
	border: none;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	overflow: hidden;
}

.bookmark-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
}

.bookmark-item {
	padding: 16px 24px;
	border-bottom: 1px solid #f0f0f0;
	transition: background 0.2s;
}

.bookmark-item:hover {
	background: #fafafa;
}

.bookmark-item:last-child {
	border-bottom: none;
}

.btn-remove-bookmark {
	background: transparent;
	color: #dc3545;
	border: none;
	padding: 4px 10px;
	border-radius: 6px;
	transition: all 0.2s;
}

.btn-remove-bookmark:hover {
	background: #ffebee;
}

.empty-state {
	padding: 80px 20px;
	text-align: center;
}

.empty-state i {
	font-size: 4rem;
	color: #d0d0d0;
	margin-bottom: 20px;
}

.empty-state h5 {
	color: #757575;
	font-weight: 600;
}

.btn-primary-custom {
	background: #1a1a1a;
	color: #ffffff;
	border: none;
	border-radius: 20px;
	padding: 10px 24px;
	font-weight: 600;
	transition: all 0.2s;
	text-decoration: none;
}

.btn-primary-custom:hover {
	background: #333333;
	color: #ffffff;
}

@media ( max-width : 992px) {
	.main-content {
		margin-left: 0;
		padding: 20px;
	}
}

@media ( max-width : 768px) {
	.main-content {
		padding: 15px;
	}
	.page-title {
		font-size: 1.2rem;
	}
}
</style>
</head>
<body>

	<jsp:include page="sidebar.jsp">
		<jsp:param name="activePage" value="bookmarks" />
	</jsp:include>

	<div class="main-content">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h3 class="page-title">
					<i class="fa-solid fa-bookmark me-2"></i>My Bookmarks
				</h3>
				<p class="text-muted small mt-1">
					<i class="fa-regular fa-bookmark me-1"></i> သင့်ရဲ့ save လုပ်ထားတဲ့
					Cheat Sheets များ <span
						class="badge bg-secondary-subtle text-dark fw-bold px-2 rounded-pill">${bookmarkCount}</span>
					ခု
				</p>
			</div>
			<a href="${pageContext.request.contextPath}/dashboard"
				class="btn btn-outline-secondary rounded-pill px-3"> <i
				class="fa-solid fa-arrow-left me-1"></i> Back
			</a>
		</div>

		<div class="bookmark-card">
			<c:choose>
				<c:when test="${not empty bookmarks}">
					<c:forEach items="${bookmarks}" var="bookmark">
						<div
							class="bookmark-item d-flex justify-content-between align-items-center">
							<div>
								<h6 class="fw-bold mb-1">
									<a
										href="${pageContext.request.contextPath}/cheatsheets/view/${bookmark.sheetId}"
										class="text-dark text-decoration-none">
										${bookmark.sheetTitle} </a>
								</h6>
								<div class="d-flex gap-3 small text-muted">
									<span><i class="fa-regular fa-folder me-1"></i>${bookmark.sheetCategory}</span>
									<span><i class="fa-regular fa-user me-1"></i>${bookmark.sheetAuthor}</span>
									<span><i class="fa-regular fa-heart me-1"></i>${bookmark.likeCount}</span>
									<span><i class="fa-regular fa-clock me-1"></i> <fmt:formatDate
											value="${bookmark.createdAt}" pattern="dd MMM yyyy" /> </span>
								</div>
							</div>
							<div>
								<a
									href="${pageContext.request.contextPath}/cheatsheets/view/${bookmark.sheetId}"
									class="btn btn-sm btn-outline-secondary me-2 rounded-pill">
									<i class="fa-regular fa-eye me-1"></i> View
								</a>
								<form
									action="${pageContext.request.contextPath}/bookmarks/remove/${bookmark.id}"
									method="POST" style="display: inline;">
									<button type="submit" class="btn-remove-bookmark"
										title="Remove bookmark">
										<i class="fa-solid fa-xmark"></i>
									</button>
								</form>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<i class="fa-regular fa-bookmark"></i>
						<h5>No bookmarks yet</h5>
						<p class="text-muted small">Cheat Sheets များကို bookmark
							လုပ်ပြီး သိမ်းဆည်းထားနိုင်ပါတယ်။</p>
						<a href="${pageContext.request.contextPath}/dashboard"
							class="btn btn-primary-custom mt-3"> <i
							class="fa-solid fa-house me-2"></i> Go to Dashboard
						</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
		
	</script>
</body>
</html>