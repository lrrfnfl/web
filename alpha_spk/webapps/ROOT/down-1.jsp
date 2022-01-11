<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.error.*" %>
<%@ page import="com.spk.type.*" %>
<%@ page import="com.spk.util.Util" %>
<%@ page import="com.spk.util.DbUtil" %>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1")) {
		response.setHeader("Cache-Control","no-cache");
	}

	String oemString = "";
	String webTitleString = CommonConstant.SERVER_TITLE;
	String imageTitle = "main_logo_spk.png";
	/*************************************************************************
	 * 서버 설정 정보 조회
	 ************************************************************************/
	 HashMap<String, String> mapServerConfig = DbUtil.getServerConfig(session);
	if (!mapServerConfig.isEmpty()) {
		if ("MEDISAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			oemString = "MEDISAFER";
			webTitleString = CommonConstant.MEDISAFER_SERVER_TITLE;
			imageTitle = "main_logo_medisafer.png";
		} else if ("BIZSAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			oemString = "BIZSAFER";
			webTitleString = CommonConstant.BIZSAFER_SERVER_TITLE;
			imageTitle = "main_logo_bizsafer.png";
		}
	}

	/*************************************************************************
	 * 사이트 관리자가 접근 가능한 주소인지 검사
	 ************************************************************************/
// 	if (!DbUtil.isSAAccessableAddress(Util.getClientIpAddr(request), session)) {
// 		response.sendRedirect("/login/error_accessdenied.jsp");
// 	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title><%=webTitleString%></title>

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/css/darkness.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />
<% } %>

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/themes/darkness/jquery.ui.all.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
<% } %>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>

	<script type="text/javascript">
	<!--
		$(document).ready(function() {
			$('#btnDownload').click( function () {
				location.href="/downfiles/client/zwMacLearnBaseX.exe";
			});
		});
	//-->
	</script>
</head>

<body style="background-color: #1e1f23;">
	<div class="centered-main">
		<div class="download-container">
			<div class="main_logo"><img src="/images/<%=imageTitle%>" /></div>
			<div style="margin-top: 45px;">
				<div class="field-line">
					<div class="info-message">아래 버튼을 클릭하여<br />설치 프로그램을 다운로드할 수 있습니다.</div>
				</div>
			</div>
			<div class="button-line">
				<input type="button" id="btnDownload" class="download-button" value="설치 프로그램 다운로드" style="width: 370px;"/>
			</div>
		</div>
	</div>
</body>
</html>
