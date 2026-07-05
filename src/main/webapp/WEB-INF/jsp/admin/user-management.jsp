<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>User Management | Admin</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<style>
body {
	background-color: #f4f7fe;
	font-family: 'Segoe UI', sans-serif;
}

.content-card {
	border-radius: 20px;
	border: none;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
	background: #ffffff;
	padding: 30px;
}

@media ( min-width : 769px) {
	.main-content {
		margin-left: 260px;
		width: calc(100% - 260px);
	}
}
@media ( max-width : 768px) {
	.main-content {
		margin-left: 0;
		width: 100%;
	}
}

.dropdown-item:active {
	background-color: #e9ecef;
	color: #212529;
}
.dropdown-item.danger-item:hover {
	background-color: #f8d7da;
	color: #842029;
}
.dropdown-item i {
	width: 1.2rem;
	text-align: center;
}
.action-dropdown .dropdown-toggle::after {
	margin-left: 0.4rem;
}
.action-dropdown .btn {
	min-width: 90px;
}

/* ===== SEARCH BAR ===== */
.search-wrapper {
	position: relative;
	flex: 1;
	max-width: 450px;
	min-width: 200px;
}
.search-wrapper .search-input {
	width: 100%;
	padding: 10px 45px 10px 45px;
	border-radius: 50px;
	border: 1.5px solid #e2e6ee;
	background-color: #f8f9fc;
	font-size: 0.95rem;
	transition: all 0.3s ease;
}
.search-wrapper .search-input:focus {
	outline: none;
	border-color: #1a1e2b;
	background-color: #ffffff;
	box-shadow: 0 0 0 4px rgba(26, 30, 43, 0.08);
}
.search-wrapper .search-icon {
	position: absolute;
	left: 16px;
	top: 50%;
	transform: translateY(-50%);
	color: #8e95a3;
	pointer-events: none;
	font-size: 0.95rem;
}
.search-wrapper .clear-btn {
	position: absolute;
	right: 16px;
	top: 50%;
	transform: translateY(-50%);
	background: none;
	border: none;
	color: #8e95a3;
	padding: 0;
	font-size: 1.1rem;
	display: none;
	cursor: pointer;
	z-index: 2;
	transition: color 0.2s;
}
.search-wrapper .clear-btn:hover {
	color: #dc3545;
}

/* Right side actions */
.header-actions {
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: wrap;
}
.header-actions .btn-banned {
	background: #dc3545;
	color: white;
	border-radius: 40px;
	padding: 7px 20px;
	font-weight: 600;
	font-size: 0.85rem;
	border: none;
	text-decoration: none;
	transition: 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 6px;
}
.header-actions .btn-banned:hover {
	background: #b02a37;
	color: white;
}
.header-actions .total-badge {
	background: #1a1e2b;
	color: white;
	border-radius: 40px;
	padding: 7px 18px;
	font-weight: 600;
	font-size: 0.85rem;
	display: inline-flex;
	align-items: center;
	gap: 6px;
}
.header-actions .total-badge i {
	font-size: 0.8rem;
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/jsp/sidebar.jsp">
		<jsp:param name="activePage" value="users" />
	</jsp:include>

	<div class="main-content">
		<div class="container-fluid py-5 px-4">
			<div class="row justify-content-center">
				<div class="col-md-11">

					<!-- HEADER -->
					<div
						class="d-flex flex-wrap justify-content-between align-items-center mb-4">
						<h4 class="fw-bold m-0">
							<i class="fa-solid fa-users-gear text-primary me-2"></i>
							Registered Users Management
						</h4>
						<a href="${pageContext.request.contextPath}/dashboard"
							class="btn btn-outline-secondary rounded-pill"> <i
							class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
						</a>
					</div>

					<!-- REGISTERED USERS CARD -->
					<div class="content-card mb-5">
						<!-- Title + Search + Actions -->
						<div
							class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
							<h5 class="fw-bold text-dark mb-0">
								<i class="fa-solid fa-users text-primary me-2"></i> Registered
								Users
							</h5>

							<div class="header-actions">
								<!-- 🔍 SEARCH BAR -->
								<div class="search-wrapper">
									<i class="fa-solid fa-magnifying-glass search-icon"></i> <input
										type="text" id="searchInput" class="search-input"
										placeholder="Search by username..."
										onkeyup="if(event.key === 'Enter') performSearch();" />
									<button id="clearSearchBtn" class="clear-btn"
										onclick="clearSearch()" title="Clear search">
										<i class="fa-solid fa-xmark"></i>
									</button>
								</div>

								<a href="${pageContext.request.contextPath}/admin/user/banned-list"
									class="btn-banned"> <i class="fa-solid fa-user-slash"></i>
									Banned List
								</a> <span class="total-badge" id="totalUsersBadge"> <i
									class="fa-regular fa-user"></i> ${not empty users ? users.size() : 0}
								</span>
							</div>
						</div>

						<!-- TABLE -->
						<div class="table-responsive">
							<table class="table table-hover align-middle" id="userTable">
								<thead class="table-light">
									<tr>
										<th>No</th>
										<th>Username</th>
										<th>Role</th>
										<th>Status</th>
										<th class="text-center" style="min-width: 110px;">Action</th>
									</tr>
								</thead>
								<tbody id="userTableBody">
									<c:choose>
										<c:when test="${not empty users}">
											<c:forEach items="${users}" var="user" varStatus="count">
												<tr data-user-id="${user.userId}">
													<td class="text-muted fw-bold">${count.index + 1}</td>
													<td>
														<div class="d-flex align-items-center">
															<c:choose>
																<c:when test="${not empty user.profileImg && user.profileImg ne 'default-avatar.png'}">
																	<img
																		src="${pageContext.request.contextPath}/uploads/${user.profileImg}"
																		class="rounded-circle me-2" width="40" height="40"
																		style="object-fit: cover;"
																		onerror="this.src='https://ui-avatars.com/api/?name=${user.username}'" />
																</c:when>
																<c:otherwise>
																	<img
																		src="https://ui-avatars.com/api/?name=${user.username}&background=e8e8e8&color=555555&bold=true"
																		class="rounded-circle me-2" width="40" height="40"
																		style="object-fit: cover;" />
																</c:otherwise>
															</c:choose>
															<span class="fw-bold text-dark">${user.username}</span>
														</div>
													</td>
													<td><span
														class="badge ${user.role eq 'admin' ? 'bg-primary' : 'bg-secondary'} rounded-pill">
															${user.role} </span></td>
													<td><span
														class="badge ${user.status eq 'active' ? 'bg-success' : (user.status eq 'suspended' ? 'bg-danger' : 'bg-secondary')} rounded-pill">
															${user.status} </span></td>
													<td class="text-center">
														<!-- Action Dropdown -->
														<div class="dropdown action-dropdown d-inline-block">
															<button
																class="btn btn-outline-secondary btn-sm dropdown-toggle rounded-pill px-3"
																type="button" data-bs-toggle="dropdown"
																aria-expanded="false">
																<i class="fa-solid fa-sliders-h me-1"></i> Actions
															</button>
															<ul class="dropdown-menu dropdown-menu-end shadow-sm"
																style="border-radius: 14px; border: none; padding: 0.3rem 0;">
																<li><a class="dropdown-item py-2"
																	href="${pageContext.request.contextPath}/user/profile/${user.userId}">
																		<i class="fa-regular fa-eye text-primary"></i>
																		View Profile
																</a></li>
																<li>
																	<form
																		action="${pageContext.request.contextPath}/admin/user/toggle-role"
																		method="POST" class="d-inline w-100">
																		<input type="hidden" name="userId"
																			value="${user.userId}" />
																		<button type="submit" class="dropdown-item py-2">
																			<i
																				class="fa-solid fa-user-tag ${user.role eq 'admin' ? 'text-warning' : 'text-info'}"></i>
																			${user.role eq 'admin' ? 'Remove Admin' : 'Make Admin'}
																		</button>
																	</form>
																</li>
																<c:choose>
																	<c:when
																		test="${user.userId != sessionScope.loginUser.userId && user.status != 'suspended'}">
																		<li>
																			<button class="dropdown-item py-2"
																				onclick="openBanModal('${user.userId}', '${user.username}', '${user.status}')">
																				<i class="fa-solid fa-ban text-warning"></i>
																				Ban User
																			</button>
																		</li>
																	</c:when>
																	<c:when test="${user.status == 'suspended'}">
																		<li>
																			<form
																				action="${pageContext.request.contextPath}/admin/user/unban"
																				method="POST" class="d-inline w-100">
																				<input type="hidden" name="userId"
																					value="${user.userId}" />
																				<button type="submit" class="dropdown-item py-2"
																					onclick="return confirm('Unban this user?')">
																					<i class="fa-solid fa-user-check text-success"></i>
																					Unban User
																				</button>
																			</form>
																		</li>
																	</c:when>
																</c:choose>
																<c:if test="${user.status == 'suspended'}">
																	<li>
																		<button type="button" class="dropdown-item py-2"
																			data-username="<c:out value='${user.username}'/>"
																			data-reason="<c:out value='${user.suspensionReason}'/>"
																			onclick="viewReason(this)">
																			<i class="fa-solid fa-circle-info text-secondary"></i>
																			View Reason
																		</button>
																	</li>
																</c:if>
																<c:if test="${user.userId != sessionScope.loginUser.userId}">
																	<li><hr class="dropdown-divider" /></li>
																	<li>
																		<form
																			action="${pageContext.request.contextPath}/user/admin/delete"
																			method="POST" class="d-inline w-100">
																			<input type="hidden" name="userId"
																				value="${user.userId}" />
																			<button type="submit" class="dropdown-item py-2 text-danger danger-item"
																				onclick="return confirm('Permanently delete this user? This action cannot be undone.')">
																				<i class="fa-solid fa-trash-can text-danger"></i>
																				Delete Account
																			</button>
																		</form>
																	</li>
																</c:if>
															</ul>
														</div>
													</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr id="noUsersRow">
												<td colspan="5" class="text-center text-muted py-4">No
													users found.</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- BAN MODAL -->
	<div class="modal fade" id="banModal" tabindex="-1"
		aria-labelledby="banModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content"
				style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);">
				<form action="${pageContext.request.contextPath}/admin/user/ban"
					method="POST">
					<div class="modal-header border-0 pt-4 px-4">
						<h5 class="modal-title fw-bold text-danger" id="banModalLabel">
							<i class="fa-solid fa-user-lock me-2"></i> Ban User: <span
								id="targetUsername" class="text-dark"></span>
						</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body px-4">
						<input type="hidden" id="modalUserId" name="userId" /> <input
							type="hidden" id="modalCurrentStatus" name="currentStatus" /> <input
							type="hidden" name="adminId"
							value="${sessionScope.loginUser.userId}" />
						<div class="mb-3">
							<label for="banDuration"
								class="form-label fw-semibold text-secondary">Ban
								Duration</label> <select class="form-select" id="banDuration"
								name="banDuration" style="border-radius: 12px;" required>
								<option value="3 Days">3 Days</option>
								<option value="7 Days">7 Days</option>
								<option value="30 Days">30 Days</option>
								<option value="Permanent" selected>Permanent</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="reason" class="form-label fw-semibold text-secondary">Reason</label>
							<textarea class="form-control" id="reason" name="reason" rows="3"
								required style="border-radius: 12px;"
								placeholder="Please provide a valid reason..."></textarea>
						</div>
					</div>
					<div class="modal-footer border-0 pb-4 px-4 gap-2">
						<button type="button" class="btn btn-light px-4 rounded-pill"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit"
							class="btn btn-danger px-4 rounded-pill fw-bold">Confirm
							Ban</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- REASON MODAL -->
	<div class="modal fade" id="reasonModal" tabindex="-1"
		aria-labelledby="reasonModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content"
				style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);">
				<div class="modal-header border-0 pt-4 px-4">
					<h5 class="modal-title fw-bold text-dark" id="reasonModalLabel">
						<i class="fa-solid fa-circle-info text-warning me-2"></i> Ban
						Reason
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body px-4 pb-4">
					<p class="text-muted mb-2">
						Account Name: <strong id="displayBannedUser" class="text-dark"></strong>
					</p>
					<div class="p-3 bg-light rounded-3 border">
						<span id="displayBanReason" class="fw-semibold text-secondary"></span>
					</div>
				</div>
				<div class="modal-footer border-0 px-4 pb-4">
					<button type="button" class="btn btn-secondary px-4 rounded-pill"
						data-bs-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
		
	</script>
	<script>
		// ============================================
		// GLOBALS
		// ============================================
		var contextPath = '${pageContext.request.contextPath}';
		var currentUserId = '${sessionScope.loginUser.userId}';

		// ============================================
		// 1. SEARCH FUNCTIONS
		// ============================================
		function performSearch() {
			var input = document.getElementById('searchInput');
			var query = input.value.trim();
			var clearBtn = document.getElementById('clearSearchBtn');

			if (query === '') {
				clearSearch();
				return;
			}

			clearBtn.style.display = 'block';

			fetch(contextPath + '/user/search?query='
					+ encodeURIComponent(query), {
				method: 'GET',
				headers : {
					'Accept' : 'application/json'
				}
			}).then(function(response) {
				if (!response.ok)
					throw new Error('Search failed');
				return response.json();
			}).then(function(users) {
				updateTable(users);
				var badge = document.getElementById('totalUsersBadge');
				badge.innerHTML = '<i class="fa-regular fa-user me-1"></i> '
						+ users.length;
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Search failed. Please try again.');
			});
		}

		function clearSearch() {
			document.getElementById('searchInput').value = '';
			document.getElementById('clearSearchBtn').style.display = 'none';
			window.location.reload();
		}

		// ============================================
		// 2. UPDATE TABLE (STRING CONCATENATION)
		// ============================================
		function updateTable(users) {
			var tbody = document.getElementById('userTableBody');
			tbody.innerHTML = '';

			if (!users || users.length === 0) {
				tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">No users found.</td></tr>';
				return;
			}

			var html = '';

			for (var i = 0; i < users.length; i++) {
				var user = users[i];
				var serial = i + 1;
				var roleBadgeClass = user.role === 'admin' ? 'bg-primary'
						: 'bg-secondary';
				var statusBadgeClass = user.status === 'active' ? 'bg-success'
						: (user.status === 'suspended' ? 'bg-danger'
								: 'bg-secondary');
				var avatarUrl = user.profileImg ? contextPath + '/uploads/'
						+ user.profileImg : 'https://ui-avatars.com/api/?name='
						+ user.username;

				html += '<tr data-user-id="' + user.userId + '">';
				html += '<td class="text-muted fw-bold">' + serial + '</td>';
				html += '<td><div class="d-flex align-items-center"><img src="'
						+ avatarUrl
						+ '" class="rounded-circle me-2" width="40" height="40" style="object-fit: cover;" onerror="this.src=\'https://ui-avatars.com/api/?name='
						+ user.username
						+ '\'"><span class="fw-bold text-dark">'
						+ user.username + '</span></div></td>';
				html += '<td><span class="badge ' + roleBadgeClass
						+ ' rounded-pill">' + user.role + '</span></td>';
				html += '<td><span class="badge ' + statusBadgeClass
						+ ' rounded-pill">' + user.status + '</span></td>';
				html += '<td class="text-center"><div class="dropdown action-dropdown d-inline-block">';
				html += '<button class="btn btn-outline-secondary btn-sm dropdown-toggle rounded-pill px-3" type="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fa-solid fa-sliders-h me-1"></i> Actions</button>';
				html += '<ul class="dropdown-menu dropdown-menu-end shadow-sm" style="border-radius: 14px; border: none; padding: 0.3rem 0;">';
				html += '<li><a class="dropdown-item py-2" href="'
						+ contextPath + '/user/profile/' + user.userId
						+ '"><i class="fa-regular fa-eye text-primary"></i> View Profile</a></li>';
				html += '<li><form action="'
						+ contextPath
						+ '/admin/user/toggle-role" method="POST" class="d-inline w-100"><input type="hidden" name="userId" value="'
						+ user.userId
						+ '" /><button type="submit" class="dropdown-item py-2"><i class="fa-solid fa-user-tag '
						+ (user.role === 'admin' ? 'text-warning'
								: 'text-info')
						+ '"></i> '
						+ (user.role === 'admin' ? 'Remove Admin'
								: 'Make Admin')
						+ '</button></form></li>';

				// Ban / Unban
				if (user.userId != currentUserId && user.status !== 'suspended') {
					html += '<li><button class="dropdown-item py-2" onclick="openBanModal(\''
							+ user.userId
							+ '\', \''
							+ user.username
							+ '\', \''
							+ user.status
							+ '\')"><i class="fa-solid fa-ban text-warning"></i> Ban User</button></li>';
				} else if (user.status === 'suspended') {
					html += '<li><form action="'
							+ contextPath
							+ '/admin/user/unban" method="POST" class="d-inline w-100"><input type="hidden" name="userId" value="'
							+ user.userId
							+ '" /><button type="submit" class="dropdown-item py-2" onclick="return confirm(\'Unban this user?\')"><i class="fa-solid fa-user-check text-success"></i> Unban User</button></form></li>';
				}

				// View Reason
				if (user.status === 'suspended') {
					var reason = user.suspensionReason || 'အကြောင်းပြချက် မရှိပါ။';
					html += '<li><button type="button" class="dropdown-item py-2" data-username="'
							+ user.username
							+ '" data-reason="'
							+ reason
							+ '" onclick="viewReason(this)"><i class="fa-solid fa-circle-info text-secondary"></i> View Reason</button></li>';
				}

				// Delete
				if (user.userId != currentUserId) {
					html += '<li><hr class="dropdown-divider" /></li>';
					html += '<li><form action="'
							+ contextPath
							+ '/user/admin/delete" method="POST" class="d-inline w-100"><input type="hidden" name="userId" value="'
							+ user.userId
							+ '" /><button type="submit" class="dropdown-item py-2 text-danger danger-item" onclick="return confirm(\'Permanently delete this user? This action cannot be undone.\')"><i class="fa-solid fa-trash-can text-danger"></i> Delete Account</button></form></li>';
				}

				html += '</ul></div></td></tr>';
			}

			tbody.innerHTML = html;
		}

		// ============================================
		// 3. MODAL FUNCTIONS
		// ============================================
		function openBanModal(userId, username, currentStatus) {
			document.getElementById('modalUserId').value = userId;
			document.getElementById('targetUsername').innerText = username;
			document.getElementById('modalCurrentStatus').value = currentStatus;
			var myModal = new bootstrap.Modal(document
					.getElementById('banModal'));
			myModal.show();
		}

		function viewReason(element) {
			var username = element.getAttribute('data-username');
			var reasonText = element.getAttribute('data-reason');
			document.getElementById('displayBannedUser').innerText = username;
			if (reasonText && reasonText.trim() !== '' && reasonText !== 'null') {
				document.getElementById('displayBanReason').innerText = reasonText;
			} else {
				document.getElementById('displayBanReason').innerText = "အကြောင်းပြချက် မရှိပါ။";
			}
			var reasonModal = new bootstrap.Modal(document
					.getElementById('reasonModal'));
			reasonModal.show();
		}
	</script>
</body>
</html>