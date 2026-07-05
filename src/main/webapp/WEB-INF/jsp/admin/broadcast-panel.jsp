<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Broadcast Management | Admin</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
body {
	background: #f2f4f8;
	font-family: -apple-system, BlinkMacSystemFont, "Inter", "Segoe UI", Roboto,
		sans-serif;
	color: #1a1e2b;
	min-height: 100vh;
}
.main-content {
	margin-left: 260px;
	padding: 40px 48px 60px;
	min-height: 100vh;
	background: #f2f4f8;
}
.page-title {
	font-size: 1.8rem;
	font-weight: 700;
	letter-spacing: -0.02em;
	color: #1a1e2b;
}
.page-subtitle {
	font-size: 0.95rem;
	color: #6b7280;
	margin-top: 4px;
}
.content-card {
	background: #ffffff;
	border-radius: 28px;
	border: none;
	padding: 32px 36px;
	margin-bottom: 28px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.03);
	transition: box-shadow 0.3s ease;
}
.content-card:hover {
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
}
.form-label {
	font-weight: 600;
	font-size: 0.85rem;
	color: #374151;
	margin-bottom: 6px;
}
.form-control {
	border-radius: 14px;
	border: 1.5px solid #e2e6ee;
	background: #fafbfc;
	padding: 10px 16px;
	font-size: 0.95rem;
	color: #1a1e2b;
	transition: all 0.2s ease;
}
.form-control:focus {
	background: #ffffff;
	border-color: #8e95a3;
	box-shadow: 0 0 0 4px rgba(26, 30, 43, 0.04);
	outline: none;
}
.btn-primary-custom {
	background: #1a1e2b;
	color: #fff;
	border: none;
	border-radius: 40px;
	padding: 10px 28px;
	font-weight: 600;
	font-size: 0.95rem;
	transition: all 0.2s ease;
	box-shadow: 0 4px 12px rgba(26, 30, 43, 0.15);
}
.btn-primary-custom:hover {
	background: #2c3347;
	color: #fff;
	transform: translateY(-2px);
	box-shadow: 0 8px 20px rgba(26, 30, 43, 0.2);
}
.btn-outline-custom {
	background: transparent;
	color: #1a1e2b;
	border: 1.5px solid #e2e6ee;
	border-radius: 40px;
	padding: 6px 18px;
	font-weight: 600;
	font-size: 0.85rem;
	transition: all 0.2s ease;
}
.btn-outline-custom:hover {
	background: #f0f2f6;
	border-color: #c5cad6;
	transform: translateY(-2px);
}
.alert-custom {
	border-radius: 18px;
	border: none;
	padding: 16px 24px;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
	animation: slideDown 0.4s ease-out;
}
@keyframes slideDown {
	0% { opacity: 0; transform: translateY(-16px); }
	100% { opacity: 1; transform: translateY(0); }
}
@media (max-width: 992px) {
	.main-content { margin-left: 0; padding: 24px 20px 40px; }
}
@media (max-width: 768px) {
	.main-content { padding: 16px 14px 32px; }
	.content-card { padding: 20px 16px; }
}
</style>
</head>
<body>

	<!-- Sidebar -->
	<jsp:include page="/WEB-INF/jsp/sidebar.jsp">
		<jsp:param name="activePage" value="broadcast" />
	</jsp:include>

	<!-- Main Content -->
	<div class="main-content">

		<!-- Page Header -->
		<div
			class="d-flex flex-wrap justify-content-between align-items-center mb-4">
			<div>
				<h3 class="page-title">
					<i class="fa-solid fa-bullhorn text-primary me-2"></i> Broadcast
					Management
				</h3>
				<p class="page-subtitle">
					<i class="fa-regular fa-circle-info me-1"></i> Create and manage
					announcements for all users
				</p>
			</div>
			<div class="d-flex gap-2 mt-2 mt-md-0">
				<a href="${pageContext.request.contextPath}/dashboard"
					class="btn btn-outline-custom">
					<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
				</a>
				<button onclick="location.reload()"
					class="btn btn-outline-custom">
					<i class="fa-solid fa-rotate me-1"></i> Refresh
				</button>
			</div>
		</div>

		<!-- Alerts -->
		<c:if test="${not empty successMsg}">
			<div
				class="alert alert-success alert-dismissible fade show shadow-sm mb-4 alert-custom"
				role="alert">
				<div class="d-flex align-items-center gap-2">
					<i class="fa-solid fa-circle-check text-success fs-5"></i> <span
						class="fw-semibold">${successMsg}</span>
				</div>
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			<% session.removeAttribute("successMsg"); %>
		</c:if>
		<c:if test="${not empty errorMsg}">
			<div
				class="alert alert-danger alert-dismissible fade show shadow-sm mb-4 alert-custom"
				role="alert">
				<div class="d-flex align-items-center gap-2">
					<i class="fa-solid fa-circle-exclamation text-danger fs-5"></i> <span
						class="fw-semibold">${errorMsg}</span>
				</div>
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			<% session.removeAttribute("errorMsg"); %>
		</c:if>

		<!-- Form Card -->
		<div class="content-card">
			<h5 class="fw-bold mb-3" style="color: #1a1e2b;">
				<i class="fa-regular fa-pen-to-square me-2"></i> Publish New
				Announcement
			</h5>
			<form:form
				action="${pageContext.request.contextPath}/admin/broadcast/announcement/save"
				method="post" modelAttribute="newAnnouncement">
				<div class="mb-3">
					<label class="form-label">Title</label>
					<form:input path="title" class="form-control"
						placeholder="Enter announcement title" required="true" />
				</div>
				<div class="mb-4">
					<label class="form-label">Message Content</label>
					<form:textarea path="content" class="form-control" rows="6"
						placeholder="Write the announcement details here..."
						required="true" />
				</div>
				<button type="submit" class="btn btn-primary-custom w-100">
					<i class="fa-solid fa-paper-plane me-2"></i> Publish Announcement
				</button>
			</form:form>
		</div>

		<!-- Existing Announcements (optional) -->
		<c:if test="${not empty announcements}">
			<div class="content-card">
				<h5 class="fw-bold mb-3" style="color: #1a1e2b;">
					<i class="fa-regular fa-clock me-2"></i> Recent Announcements
				</h5>
				<div class="table-responsive">
					<table class="table table-hover align-middle" style="font-size: 0.9rem;">
						<thead>
							<tr>
								<th>Title</th>
								<th>Content</th>
								<th>Created</th>
								<th class="text-center">Action</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ann" items="${announcements}">
								<tr>
									<td class="fw-bold">${ann.title}</td>
									<td class="text-muted small">${ann.content}</td>
									<td><fmt:formatDate value="${ann.createdAt}" pattern="dd MMM yyyy" /></td>
									<td class="text-center">
										<a href="${pageContext.request.contextPath}/admin/broadcast/announcement/delete/${ann.id}"
											class="btn btn-danger btn-sm rounded-pill"
											onclick="return confirm('Delete this announcement?')">
											<i class="fa-solid fa-trash-can me-1"></i> Delete
										</a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</c:if>
	</div>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
	</script>
</body>
</html>