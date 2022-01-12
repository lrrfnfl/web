<%@ page contentType = "text/html; charset=UTF-8"%>
<%@ page import="com.spk.type.*" %>
<%
	String adminType = (String) session.getAttribute("ADMINTYPE");
	session.invalidate();
	if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals(adminType)) {
		response.sendRedirect("/login/sa_login.jsp");
	} else {
		response.sendRedirect("/login/login.jsp");
	}
%>
