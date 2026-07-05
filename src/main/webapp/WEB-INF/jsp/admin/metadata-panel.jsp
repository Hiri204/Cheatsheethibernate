<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Metadata Management | Admin</title>
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
	padding: 28px 32px;
	margin-bottom: 28px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.03);
	transition: box-shadow 0.3s ease;
}
.content-card:hover {
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
}
.table-custom {
	font-size: 0.9rem;
}
.table-custom thead th {
	background: #f8f9fc;
	color: #6b7280;
	font-weight: 600;
	text-transform: uppercase;
	font-size: 0.7rem;
	letter-spacing: 0.4px;
	padding: 12px 14px;
	border-bottom: 2px solid #f1f3f7;
}
.table-custom tbody td {
	padding: 12px 14px;
	vertical-align: middle;
	border-bottom: 1px solid #f1f3f7;
}
.table-custom tbody tr:hover {
	background: #f8f9fc;
}
.btn-edit {
	background: #e0e7ff;
	color: #3730a3;
	border: none;
	border-radius: 40px;
	padding: 4px 14px;
	font-weight: 600;
	font-size: 0.75rem;
	transition: all 0.2s ease;
}
.btn-edit:hover {
	background: #3730a3;
	color: white;
}
.btn-delete {
	background: #fee2e2;
	color: #991b1b;
	border: none;
	border-radius: 40px;
	padding: 4px 14px;
	font-weight: 600;
	font-size: 0.75rem;
	transition: all 0.2s ease;
}
.btn-delete:hover {
	background: #991b1b;
	color: white;
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
.input-group .form-control {
	border-radius: 14px 0 0 14px;
	border: 1.5px solid #e2e6ee;
	background: #fafbfc;
	padding: 10px 16px;
	font-size: 0.95rem;
}
.input-group .form-control:focus {
	border-color: #8e95a3;
	box-shadow: 0 0 0 4px rgba(26, 30, 43, 0.04);
	outline: none;
}
.btn-add {
	background: #1a1e2b;
	color: white;
	border-radius: 0 14px 14px 0;
	border: none;
	padding: 0 24px;
	font-weight: 600;
	transition: all 0.2s ease;
}
.btn-add:hover {
	background: #2c3347;
	color: white;
}
.modal-content-custom {
	border-radius: 28px;
	border: none;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
	overflow: hidden;
}
.modal-header-custom {
	padding: 20px 28px;
	border-bottom: 1px solid #f1f3f7;
	background: #fafbfc;
}
.modal-body-custom {
	padding: 28px;
}
.modal-footer-custom {
	padding: 16px 28px 28px;
	border-top: 1px solid #f1f3f7;
	background: #fafbfc;
}
@media (max-width: 992px) {
	.main-content { margin-left: 0; padding: 24px 20px 40px; }
}
@media (max-width: 768px) {
	.main-content { padding: 16px 14px 32px; }
	.content-card { padding: 16px; }
}
</style>
</head>
<body>

	<!-- Sidebar -->
	<jsp:include page="/WEB-INF/jsp/sidebar.jsp">
		<jsp:param name="activePage" value="categories" />
	</jsp:include>

	<!-- Main Content -->
	<div class="main-content">

		<!-- Page Header -->
		<div
			class="d-flex flex-wrap justify-content-between align-items-center mb-4">
			<div>
				<h3 class="page-title">
					<i class="fa-solid fa-list-ul text-primary me-2"></i> Metadata
					Configuration
				</h3>
				<p class="page-subtitle">
					<i class="fa-regular fa-circle-info me-1"></i> Manage categories
					and tags for your cheat sheets
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

		<!-- Two Columns -->
		<div class="row g-4">

			<!-- Categories -->
			<div class="col-lg-6">
				<div class="content-card h-100">
					<h5 class="fw-bold mb-3" style="color: #1a1e2b;">
						<i class="fa-solid fa-folder text-primary me-2"></i> Categories
					</h5>

					<form:form
						action="${pageContext.request.contextPath}/admin/metadata/category/save"
						method="post" modelAttribute="newCategory" class="mb-3">
						<div class="input-group">
							<form:input path="name" class="form-control"
								placeholder="New Category Name..." required="true" />
							<button type="submit" class="btn btn-add">Add</button>
						</div>
					</form:form>

					<div class="table-responsive">
						<table class="table table-custom table-hover align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Name</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="cat" items="${categories}">
									<tr>
										<td><span class="badge bg-light text-dark rounded-pill px-3">#${cat.categoryId}</span></td>
										<td class="fw-semibold text-dark">${cat.name}</td>
										<td class="text-end">
											<button type="button" class="btn btn-edit"
												data-bs-toggle="modal" data-bs-target="#editCategoryModal"
												data-id="${cat.categoryId}" data-name="${cat.name}">
												<i class="fa-solid fa-pen me-1"></i> Edit
											</button>
											<a
												href="${pageContext.request.contextPath}/admin/metadata/category/delete/${cat.categoryId}"
												class="btn btn-delete"
												onclick="return confirm('Delete this category?')">
												<i class="fa-solid fa-trash-can me-1"></i> Delete
											</a>
										</td>
									</tr>
								</c:forEach>
								<c:if test="${empty categories}">
									<tr>
										<td colspan="3" class="text-center text-muted py-3">No
											categories yet.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!-- Tags -->
			<div class="col-lg-6">
				<div class="content-card h-100">
					<h5 class="fw-bold mb-3" style="color: #1a1e2b;">
						<i class="fa-solid fa-tags text-primary me-2"></i> Meta Tags
					</h5>

					<form:form
						action="${pageContext.request.contextPath}/admin/metadata/tag/save"
						method="post" modelAttribute="newTag" class="mb-3">
						<div class="input-group">
							<form:input path="name" class="form-control"
								placeholder="New Tag Name..." required="true" />
							<button type="submit" class="btn btn-add">Add Tag</button>
						</div>
					</form:form>

					<div class="table-responsive">
						<table class="table table-custom table-hover align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Name</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="tag" items="${tags}">
									<tr>
										<td><span class="badge bg-light text-dark rounded-pill px-3">#${tag.tagId}</span></td>
										<td class="fw-semibold text-dark">${tag.name}</td>
										<td class="text-end">
											<button type="button" class="btn btn-edit"
												data-bs-toggle="modal" data-bs-target="#editTagModal"
												data-id="${tag.tagId}" data-name="${tag.name}">
												<i class="fa-solid fa-pen me-1"></i> Edit
											</button>
											<a
												href="${pageContext.request.contextPath}/admin/metadata/tag/delete/${tag.tagId}"
												class="btn btn-delete"
												onclick="return confirm('Delete this tag?')">
												<i class="fa-solid fa-trash-can me-1"></i> Delete
											</a>
										</td>
									</tr>
								</c:forEach>
								<c:if test="${empty tags}">
									<tr>
										<td colspan="3" class="text-center text-muted py-3">No
											tags yet.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>

	</div>

	<!-- Edit Category Modal -->
	<div class="modal fade" id="editCategoryModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content modal-content-custom">
				<div class="modal-header modal-header-custom">
					<h5 class="modal-title fw-bold">
						<i class="fa-solid fa-pen-to-square text-primary me-2"></i> Edit
						Category
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form id="editCategoryForm" action="" method="post">
					<div class="modal-body modal-body-custom">
						<div class="mb-3">
							<label class="form-label fw-semibold">Category Name</label> <input
								type="text" name="name" id="editCategoryName"
								class="form-control" required />
						</div>
					</div>
					<div class="modal-footer modal-footer-custom">
						<button type="button" class="btn btn-light rounded-pill px-4"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit"
							class="btn btn-dark rounded-pill px-4 fw-bold">Update
							Category</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- Edit Tag Modal -->
	<div class="modal fade" id="editTagModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content modal-content-custom">
				<div class="modal-header modal-header-custom">
					<h5 class="modal-title fw-bold">
						<i class="fa-solid fa-pen-to-square text-primary me-2"></i> Edit
						Meta Tag
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form id="editTagForm" action="" method="post">
					<div class="modal-body modal-body-custom">
						<div class="mb-3">
							<label class="form-label fw-semibold">Tag Name</label> <input
								type="text" name="name" id="editTagName" class="form-control"
								required />
						</div>
					</div>
					<div class="modal-footer modal-footer-custom">
						<button type="button" class="btn btn-light rounded-pill px-4"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit"
							class="btn btn-dark rounded-pill px-4 fw-bold">Update Tag</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
	</script>
	<script>
		const ctxPath = "${pageContext.request.contextPath}";

		// Category Edit Modal
		const editCategoryModal = document.getElementById('editCategoryModal');
		editCategoryModal.addEventListener('show.bs.modal', function(event) {
			const button = event.relatedTarget;
			const catId = button.getAttribute('data-id');
			const catName = button.getAttribute('data-name');
			document.getElementById('editCategoryForm').action = ctxPath
					+ "/admin/metadata/category/update/" + catId;
			document.getElementById('editCategoryName').value = catName;
		});

		// Tag Edit Modal
		const editTagModal = document.getElementById('editTagModal');
		editTagModal.addEventListener('show.bs.modal', function(event) {
			const button = event.relatedTarget;
			const tagId = button.getAttribute('data-id');
			const tagName = button.getAttribute('data-name');
			document.getElementById('editTagForm').action = ctxPath
					+ "/admin/metadata/tag/update/" + tagId;
			document.getElementById('editTagName').value = tagName;
		});
	</script>
</body>
</html>