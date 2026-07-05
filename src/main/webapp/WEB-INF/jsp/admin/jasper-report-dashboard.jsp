<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Jasper Report Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h3><i class="fas fa-file-pdf"></i> Jasper Report - CheatSheet</h3>
            </div>
            <div class="card-body">
                
                <div class="row">
                    <div class="col-md-6 offset-md-3">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h5><i class="fas fa-calendar-alt"></i> Select Month</h5>
                            </div>
                            <div class="card-body">
                                
                                <!-- 🎯 တစ်ချက်နှိပ်ရင် PDF တန်းရောက် -->
                                <form action="${pageContext.request.contextPath}/admin/jasper-report/pdf" 
                                      method="get" target="_blank">
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Year:</label>
                                        <select name="year" class="form-select">
                                            <c:forEach var="i" begin="2020" end="${currentYear + 1}">
                                                <option value="${i}" ${i == currentYear ? 'selected' : ''}>${i}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Month:</label>
                                        <select name="month" class="form-select">
                                            <option value="1">January</option>
                                            <option value="2">February</option>
                                            <option value="3">March</option>
                                            <option value="4">April</option>
                                            <option value="5">May</option>
                                            <option value="6">June</option>
                                            <option value="7" ${7 == currentMonth ? 'selected' : ''}>July</option>
                                            <option value="8">August</option>
                                            <option value="9">September</option>
                                            <option value="10">October</option>
                                            <option value="11">November</option>
                                            <option value="12">December</option>
                                        </select>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-success w-100" style="padding: 12px; font-size: 18px;">
                                        <i class="fas fa-file-pdf"></i> Download PDF Report
                                    </button>
                                </form>
                                
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
</body>
</html>