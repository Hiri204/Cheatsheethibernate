<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reports Management | DevSheets</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
/* ===== Reset & Base ===== */
body {
	background: #f2f4f8;
	font-family: -apple-system, BlinkMacSystemFont, "Inter", "Segoe UI", Roboto,
		sans-serif;
	color: #1a1e2b;
	min-height: 100vh;
}

/* ===== Main Layout ===== */
.main-content {
	margin-left: 260px;
	padding: 40px 48px 60px;
	min-height: 100vh;
	background: #f2f4f8;
}

/* ===== Typography ===== */
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

/* ===== Cards ===== */
.content-card {
	background: #ffffff;
	border-radius: 28px;
	border: none;
	padding: 24px 28px;
	margin-bottom: 28px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.03);
	transition: box-shadow 0.3s ease;
}
.content-card:hover {
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
}
.content-card .card-header-custom {
	padding: 0 0 16px 0;
	border-bottom: 1px solid #f1f3f7;
	margin-bottom: 16px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	background: transparent;
}

/* ===== Stats Badges ===== */
.stats-badge {
	font-size: 0.75rem;
	padding: 6px 16px;
	border-radius: 40px;
	font-weight: 600;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background: #f0f2f6;
	color: #1a1e2b;
}
.stats-badge.bg-pending {
	background: #fef3c7;
	color: #92400e;
}
.stats-badge.bg-resolved {
	background: #d1fae5;
	color: #065f46;
}
.stats-badge.bg-banned {
	background: #fee2e2;
	color: #991b1b;
}
.stats-badge.bg-total {
	background: #e0e7ff;
	color: #3730a3;
}

/* ===== Tables ===== */
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
.banned-row {
	background: #fef2f2;
	border-left: 4px solid #dc3545;
}
.banned-row:hover {
	background: #fee2e2 !important;
}

/* ===== Buttons ===== */
.btn-action {
	border-radius: 40px;
	padding: 6px 18px;
	font-weight: 600;
	font-size: 0.8rem;
	transition: all 0.2s ease;
}
.btn-action:hover {
	transform: translateY(-2px);
}
.btn-outline-custom {
	background: transparent;
	color: #1a1e2b;
	border: 1.5px solid #e2e6ee;
	border-radius: 40px;
	padding: 6px 18px;
	font-weight: 600;
	font-size: 0.8rem;
	transition: all 0.2s ease;
}
.btn-outline-custom:hover {
	background: #f0f2f6;
	border-color: #c5cad6;
	transform: translateY(-2px);
}

/* ===== Links ===== */
.sheet-link {
	color: #4f46e5;
	text-decoration: none;
	font-weight: 600;
}
.sheet-link:hover {
	text-decoration: underline;
	color: #4338ca;
}

/* ===== Truncate ===== */
.truncate-text {
	max-width: 200px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	display: inline-block;
}

/* ===== Modal ===== */
.ban-modal .modal-content {
	border-radius: 28px;
	border: none;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
	overflow: hidden;
}
.ban-modal .modal-header {
	background: linear-gradient(135deg, #dc3545 0%, #b91c1c 100%);
	color: white;
	padding: 20px 28px;
	border-bottom: none;
}
.ban-modal .modal-header .btn-close {
	filter: brightness(0) invert(1);
}
.ban-modal .modal-body {
	padding: 28px;
}
.ban-modal .modal-footer {
	padding: 16px 28px 28px;
	border-top: none;
}
.ban-duration-btn {
	padding: 6px 16px;
	border-radius: 40px;
	border: 1.5px solid #e2e6ee;
	background: transparent;
	transition: all 0.2s;
	font-weight: 500;
	font-size: 0.8rem;
	cursor: pointer;
}
.ban-duration-btn:hover {
	border-color: #dc3545;
	background: #fef2f2;
}
.ban-duration-btn.active {
	border-color: #dc3545;
	background: #dc3545;
	color: white;
}
.ban-duration-btn.permanent.active {
	background: #dc3545;
	color: white;
	border-color: #dc3545;
}
.ban-reason-textarea {
	border-radius: 14px;
	border: 1.5px solid #e2e6ee;
	padding: 12px 16px;
	transition: all 0.2s;
}
.ban-reason-textarea:focus {
	border-color: #dc3545;
	box-shadow: 0 0 0 4px rgba(220, 53, 69, 0.08);
	outline: none;
}

/* ===== Alert ===== */
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

/* ===== Responsive ===== */
@media (max-width: 992px) {
	.main-content {
		margin-left: 0;
		padding: 24px 20px 40px;
	}
}
@media (max-width: 768px) {
	.main-content {
		padding: 16px 14px 32px;
	}
	.content-card {
		padding: 16px;
	}
	.table-custom {
		font-size: 0.8rem;
	}
}
</style>
</head>
<body>

	<!-- Sidebar -->
	<jsp:include page="/WEB-INF/jsp/sidebar.jsp">
		<jsp:param name="activePage" value="reports" />
	</jsp:include>

	<!-- Main Content -->
	<div class="main-content">

		<!-- Page Header -->
		<div
			class="d-flex flex-wrap justify-content-between align-items-center mb-4">
			<div>
				<h3 class="page-title">
					<i class="fa-solid fa-shield-halved text-primary me-2"></i> Report
					Management
				</h3>
				<p class="page-subtitle">
					<i class="fa-regular fa-circle-info me-1"></i> Review and manage
					user-reported cheat sheets
				</p>
			</div>
			<div class="d-flex gap-2 mt-2 mt-md-0">
				<a href="${pageContext.request.contextPath}/dashboard"
					class="btn btn-outline-secondary btn-sm rounded-pill px-4 fw-semibold">
					<i class="fa-solid fa-arrow-left me-1"></i> Dashboard
				</a>
				<button onclick="location.reload()"
					class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
					<i class="fa-solid fa-rotate me-1"></i> Refresh
				</button>
			</div>
		</div>

		<!-- Alert Container -->
		<div id="alertContainer"></div>

		<!-- Session Alerts -->
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

		<!-- Stats Row -->
		<div class="d-flex flex-wrap gap-2 mb-4">
			<span class="stats-badge bg-pending"> <i
				class="fa-regular fa-hourglass-half"></i> Pending:
				${pendingCount != null ? pendingCount : 0}
			</span>
			<span class="stats-badge bg-resolved"> <i
				class="fa-regular fa-circle-check"></i> Resolved:
				${resolvedCount != null ? resolvedCount : 0}
			</span>
			<span class="stats-badge bg-banned"> <i
				class="fa-solid fa-ban"></i> Banned:
				${fn:length(bannedSheets)}
			</span>
			<span class="stats-badge bg-total"> <i
				class="fa-regular fa-file-lines"></i> Total:
				${fn:length(reports)}
			</span>
		</div>

		<!-- ===== BANNED SHEETS CARD ===== -->
		<c:if test="${not empty bannedSheets}">
			<div class="content-card mb-4" style="border-top: 5px solid #dc3545;">
				<div class="card-header-custom">
					<h5 class="fw-bold text-danger mb-0">
						<i class="fa-solid fa-ban me-2"></i> Banned Cheat Sheets
						<span class="badge bg-danger rounded-pill ms-2">${fn:length(bannedSheets)}</span>
					</h5>
					<span class="badge bg-light text-danger border rounded-pill px-3 py-1">
						<i class="fa-regular fa-clock me-1"></i> Requires Attention
					</span>
				</div>
				<div class="table-responsive">
					<table class="table table-custom table-hover align-middle">
						<thead>
							<tr>
								<th>Sheet Title</th>
								<th>Author</th>
								<th>Ban Reason</th>
								<th>Banned At</th>
								<th>Expires</th>
								<th class="text-center">Action</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="sheet" items="${bannedSheets}">
								<tr class="banned-row">
									<td><a
										href="${pageContext.request.contextPath}/cheatsheets/view/${sheet.id}"
										class="sheet-link" target="_blank"> <i
											class="fa-regular fa-file-code me-1"></i> <c:out
												value="${sheet.title}" />
									</a></td>
									<td><i class="fa-regular fa-user text-muted me-1"></i>
										<c:out
											value="${sheet.user != null ? sheet.user.username : 'Unknown'}" />
									</td>
									<td><span class="truncate-text"
										title="<c:out value='${sheet.banReason}'/>"> <c:out
												value="${sheet.banReason}" />
									</span></td>
									<td><c:if test="${not empty sheet.bannedAt}">
											<fmt:formatDate value="${sheet.bannedAt}" pattern="dd MMM yyyy" />
										</c:if> <c:if test="${empty sheet.bannedAt}">
											<span class="text-muted">N/A</span>
										</c:if></td>
									<td><c:choose>
											<c:when test="${empty sheet.banExpiresAt}">
												<span class="badge bg-danger">Permanent</span>
											</c:when>
											<c:otherwise>
												<fmt:formatDate value="${sheet.banExpiresAt}" pattern="dd MMM yyyy" />
												<c:if test="${sheet.banExpiresAt < now}">
													<span class="badge bg-success ms-1">Expired</span>
												</c:if>
												<c:if test="${sheet.banExpiresAt >= now}">
													<span class="badge bg-warning text-dark ms-1">Active</span>
												</c:if>
											</c:otherwise>
										</c:choose></td>
									<td class="text-center">
										<form
											action="${pageContext.request.contextPath}/reports/admin/unban/${sheet.id}"
											method="post" style="display: inline;">
											<button type="submit" class="btn btn-success btn-action btn-sm"
												onclick="return confirm('Are you sure you want to unban this sheet?')">
												<i class="fa-solid fa-unlock me-1"></i> Unban
											</button>
										</form>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</c:if>

		<!-- ===== ALL REPORTS CARD ===== -->
		<div class="content-card">
			<div class="card-header-custom">
				<h5 class="fw-bold mb-0">
					<i class="fa-regular fa-flag me-2"></i> All Reports
					<span class="badge bg-secondary rounded-pill ms-2">${fn:length(reports)}</span>
				</h5>
				<select class="form-select form-select-sm" id="statusFilter"
					onchange="filterReports()"
					style="width: auto; border-radius: 40px; border-color: #e2e6ee; font-weight: 500;">
					<option value="all">All Status</option>
					<option value="pending">Pending</option>
					<option value="reviewed">Reviewed</option>
					<option value="resolved">Resolved</option>
					<option value="rejected">Rejected</option>
				</select>
			</div>

			<div class="table-responsive">
				<table class="table table-custom table-hover align-middle" id="reportsTable">
					<thead>
						<tr>
							<th>ID</th>
							<th>Sheet Info</th>
							<th>Reported By</th>
							<th>Reason</th>
							<th>Status</th>
							<th>Date</th>
							<th class="text-center">Actions</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="report" items="${reports}">
							<tr class="report-row" data-status="${report.status}">
								<td class="fw-bold">#${report.id}</td>

								<td><c:choose>
										<c:when test="${not empty report.cheatSheet}">
											<a
												href="${pageContext.request.contextPath}/cheatsheets/view/${report.cheatSheet.id}"
												class="sheet-link" target="_blank"> <i
												class="fa-regular fa-file-code me-1"></i> <c:out
													value="${report.cheatSheet.title}" />
											</a>
											<small class="text-muted d-block"> <i
												class="fa-regular fa-folder me-1"></i> <c:out
													value="${report.cheatSheet.category != null ? report.cheatSheet.category.name : 'Uncategorized'}" />
												<c:if test="${report.cheatSheet.status == 'banned'}">
													<span class="badge bg-danger ms-1">BANNED</span>
												</c:if>
											</small>
										</c:when>
										<c:otherwise>
											<span class="text-muted">Sheet not found</span>
										</c:otherwise>
									</c:choose></td>

								<td><i class="fa-regular fa-user text-muted me-1"></i>
									<c:choose>
										<c:when test="${not empty report.reportedBy}">
											<c:out value="${report.reportedBy.username}" />
										</c:when>
										<c:otherwise>Unknown</c:otherwise>
									</c:choose></td>

								<td><span class="truncate-text"
									title="<c:out value='${report.reason}'/>"> <c:out
											value="${report.reason}" />
								</span></td>

								<td><span
									class="badge rounded-pill px-3 py-1 
										${report.status eq 'pending' ? 'bg-warning text-dark' : 
										  report.status eq 'resolved' ? 'bg-success text-white' : 
										  report.status eq 'reviewed' ? 'bg-info text-white' : 
										  report.status eq 'rejected' ? 'bg-secondary text-white' : 'bg-secondary'}">
										<i
										class="fa-regular ${report.status eq 'pending' ? 'fa-hourglass-half' : 
														report.status eq 'resolved' ? 'fa-circle-check' : 
														report.status eq 'reviewed' ? 'fa-eye' : 
														report.status eq 'rejected' ? 'fa-circle-xmark' : 'fa-circle'} me-1"></i>
										${report.status}
								</span></td>

								<td><c:if test="${not empty report.createdAt}">
										<fmt:formatDate value="${report.createdAt}" pattern="dd MMM yyyy" />
									</c:if> <c:if test="${empty report.createdAt}">
										<span class="text-muted">N/A</span>
									</c:if></td>

								<td class="text-center"><c:if
										test="${report.status eq 'pending'}">
										<div class="d-flex justify-content-center gap-1 flex-wrap">
											<a
												href="${pageContext.request.contextPath}/reports/admin/action/${report.id}?status=reviewed"
												class="btn btn-info btn-action btn-sm"> <i
												class="fa-regular fa-eye me-1"></i> Review
											</a> <a
												href="${pageContext.request.contextPath}/reports/admin/action/${report.id}?status=resolved"
												class="btn btn-success btn-action btn-sm"> <i
												class="fa-regular fa-circle-check me-1"></i> Resolve
											</a>
											<button type="button"
												class="btn btn-danger btn-action btn-sm"
												onclick="openBanModal(${report.id}, '${fn:escapeXml(report.cheatSheet.title)}')">
												<i class="fa-solid fa-ban me-1"></i> Ban
											</button>
										</div>
									</c:if> <c:if test="${report.status ne 'pending'}">
										<span class="text-muted small"> <i
											class="fa-regular fa-check-circle text-success me-1"></i>
											Processed
										</span>
										<c:if test="${not empty report.resolvedAt}">
											<br>
											<small class="text-muted">
												<fmt:formatDate value="${report.resolvedAt}" pattern="dd MMM yyyy" />
											</small>
										</c:if>
									</c:if></td>
							</tr>
						</c:forEach>

						<c:if test="${empty reports}">
							<tr>
								<td colspan="7" class="text-center py-5 text-muted">
									<i class="fa-regular fa-clipboard fa-3x mb-3 d-block text-light"></i>
									<h5 class="fw-semibold">No reports found</h5>
									<p class="small">All reports will appear here once users
										submit them.</p>
								</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>

	</div>

	<!-- Ban Modal -->
	<div class="modal fade ban-modal" id="banModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fa-solid fa-ban me-2"></i> Ban Cheat Sheet
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form id="banForm" method="post">
					<div class="modal-body">
						<p class="text-muted">
							<i class="fa-regular fa-file-code me-1"></i> Banning: <strong
								id="banSheetTitle" class="text-dark"></strong>
						</p>
						<input type="hidden" id="banReportId" name="reportId" value="" />

						<div class="mb-3">
							<label class="form-label fw-semibold" for="banReason"> <i
								class="fa-regular fa-pen-to-square me-1"></i> Ban Reason
							</label>
							<textarea class="form-control ban-reason-textarea" id="banReason"
								name="banReason" rows="3"
								placeholder="Enter reason for banning this sheet..." required></textarea>
							<div class="form-text">
								<i class="fa-regular fa-circle-info me-1"></i> Provide a clear
								reason (min 10 characters)
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label fw-semibold"> <i
								class="fa-regular fa-clock me-1"></i> Ban Duration
							</label>
							<div class="d-flex flex-wrap gap-2">
								<button type="button" class="ban-duration-btn"
									data-duration="1day">1 Day</button>
								<button type="button" class="ban-duration-btn"
									data-duration="3days">3 Days</button>
								<button type="button" class="ban-duration-btn"
									data-duration="7days">7 Days</button>
								<button type="button" class="ban-duration-btn"
									data-duration="30days">30 Days</button>
								<button type="button" class="ban-duration-btn permanent active"
									data-duration="permanent">Permanent</button>
							</div>
							<input type="hidden" id="banDuration" name="banDuration"
								value="permanent" />
						</div>

						<div class="alert alert-info small">
							<i class="fa-regular fa-circle-info me-1"></i> <strong>Note:</strong>
							The sheet will be hidden from regular users. Admins can still
							view and unban it.
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">
							<i class="fa-regular fa-xmark me-1"></i> Cancel
						</button>
						<button type="submit" class="btn btn-danger">
							<i class="fa-solid fa-ban me-1"></i> Ban Sheet
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
	</script>

	<script>
		// ============================================
		// 1. SHOW ALERT (dynamic)
		// ============================================
		function showAlert(type, message) {
			var container = document.getElementById('alertContainer');
			if (!container) {
				container = document.createElement('div');
				container.id = 'alertContainer';
				document.querySelector('.main-content').prepend(container);
			}
			var iconClass = type === 'success' ? 'fa-circle-check text-success'
					: 'fa-circle-exclamation text-danger';
			var alertClass = type === 'success' ? 'alert-success'
					: 'alert-danger';
			var html = '<div class="alert '
					+ alertClass
					+ ' alert-dismissible fade show shadow-sm mb-4 alert-custom" role="alert">'
					+ '<div class="d-flex align-items-center gap-2">'
					+ '<i class="fa-solid ' + iconClass + ' fs-5"></i>'
					+ '<span class="fw-semibold">' + message + '</span>'
					+ '</div>'
					+ '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'
					+ '</div>';
			container.innerHTML = html;
			setTimeout(function() {
				var alert = container.querySelector('.alert');
				if (alert) {
					var bsAlert = new bootstrap.Alert(alert);
					bsAlert.close();
				}
			}, 5000);
		}

		// ============================================
		// 2. BAN MODAL
		// ============================================
		function openBanModal(reportId, sheetTitle) {
			var form = document.getElementById('banForm');
			form.action = '${pageContext.request.contextPath}/reports/admin/ban/'
					+ reportId;
			document.getElementById('banReportId').value = reportId;
			document.getElementById('banSheetTitle').innerText = sheetTitle
					|| 'Unknown Sheet';
			document.getElementById('banReason').value = '';
			document.getElementById('banDuration').value = 'permanent';

			document.querySelectorAll('.ban-duration-btn').forEach(function(btn) {
				btn.classList.remove('active');
			});
			document.querySelector('.ban-duration-btn.permanent').classList
					.add('active');

			var modal = new bootstrap.Modal(document.getElementById('banModal'));
			modal.show();
		}

		// ============================================
		// 3. FILTER REPORTS
		// ============================================
		function filterReports() {
			var filter = document.getElementById('statusFilter').value;
			var rows = document.querySelectorAll('.report-row');
			rows.forEach(function(row) {
				if (filter === 'all' || row.getAttribute('data-status') === filter) {
					row.style.display = '';
				} else {
					row.style.display = 'none';
				}
			});
		}

		// ============================================
		// 4. INIT
		// ============================================
		document.addEventListener('DOMContentLoaded', function() {
			// Duration buttons
			document.querySelectorAll('.ban-duration-btn').forEach(function(btn) {
				btn.addEventListener('click', function() {
					document.querySelectorAll('.ban-duration-btn')
							.forEach(function(b) {
								b.classList.remove('active');
							});
					this.classList.add('active');
					document.getElementById('banDuration').value = this
							.getAttribute('data-duration');
				});
			});

			// Ban form validation
			document.getElementById('banForm').addEventListener('submit',
					function(e) {
						var reason = document.getElementById('banReason').value
								.trim();
						if (reason.length < 10) {
							e.preventDefault();
							showAlert('danger',
									'Please provide a detailed reason (at least 10 characters)');
							return false;
						}
						if (reason.length > 500) {
							e.preventDefault();
							showAlert('danger',
									'Reason cannot exceed 500 characters');
							return false;
						}
						return true;
					});
		});
	</script>
</body>
</html>