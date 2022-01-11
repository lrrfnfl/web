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

			/*****************************************************************
			 * 서비스 가능시간 검사
			 ****************************************************************/
			try {
				Date curDate = new Date();

				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
				SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmss");

				curDate = datetimeFormat.parse(datetimeFormat.format(curDate));
				long curTime = curDate.getTime();
				Date beginServiceStopDate = datetimeFormat.parse(dateFormat.format(curDate) + "082000");
				long beginServiceStopTime = beginServiceStopDate.getTime();
				Date endServiceStopDate = datetimeFormat.parse(dateFormat.format(curDate) + "093000");
				long endServiceStopTime = endServiceStopDate.getTime();

				if ((curTime >= beginServiceStopTime) && (curTime <= endServiceStopTime)) { // 서비스 중지 시간
					response.sendRedirect("/login/login_wait.jsp");
				}
			} catch (Exception e) { }

		} else if ("BIZSAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			oemString = "BIZSAFER";
			webTitleString = CommonConstant.BIZSAFER_SERVER_TITLE;
			imageTitle = "main_logo_bizsafer.png";

			/*****************************************************************
			 * 서비스 가능시간 검사
			 ****************************************************************/
			try {
				Date curDate = new Date();

				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
				SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmss");

				curDate = datetimeFormat.parse(datetimeFormat.format(curDate));
				long curTime = curDate.getTime();
				Date beginServiceStopDate = datetimeFormat.parse(dateFormat.format(curDate) + "082000");
				long beginServiceStopTime = beginServiceStopDate.getTime();
				Date endServiceStopDate = datetimeFormat.parse(dateFormat.format(curDate) + "093000");
				long endServiceStopTime = endServiceStopDate.getTime();

				if ((curTime >= beginServiceStopTime) && (curTime <= endServiceStopTime)) { // 서비스 중지 시간
					response.sendRedirect("/login/login_wait.jsp");
				}
			} catch (Exception e) { }

		}
	}
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
	var g_objDivMain;

		$(document).ready(function() {

			g_objDivMain = $('#div-main');

			// 뒤로가기 방지
			if (window.history && window.history.pushState) {
				history.pushState(null, null, location.href);
				window.onpopstate = function () {
					history.go(1);
				};
			}

			$(':input').keyup(function(event) {
				if (event.which == 13) {
					$('#btnLogin').click();
				}
			});

			$('#btnLogin').click(function() {
				var objAdminId = g_objDivMain.find('input[name="adminid"]');
				var objPwd = g_objDivMain.find('input[name="pwd"]');

				if (objAdminId.val() == "") {
					objAdminId.css("border-color","#a0522d");
					objAdminId.focus();
					displayAlertDialog("로그인", "ID를 입력해 주세요.", null);
					return false;
				} else {
					objAdminId.css("border-color","#dcdcdc");
				}
				if (objPwd.val() == "") {
					objPwd.css("border-color","#a0522d");
					objPwd.focus();
					displayAlertDialog("로그인", "비밀번호를 입력해 주세요.", null);
					return false;
				} else {
					objPwd.css("border-color","#dcdcdc");
				}
				adminLogin(0);
			});

			$("#privacyhandlingpolicy").click(function () {
				window.open("http://www.skbroadband.com/footer/Page.do?retUrl=/footer/PrivacyStatement", "_blank", "width=990,height=600,menubar=no,status=no,toolbar=no,scrollbars=yes");
			});
		});

		adminLogin = function(forcedLoginFlag) {

			// request form serialize
			var formData = $('form[name=login-form]').serialize() + "&forcedloginflag=" + forcedLoginFlag + "&admintype=" + "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";

			$.ajax({
				type: "POST",
				url: "/AdminLogin",
				data: formData,
				dataType: "xml",
				cache: false,
				async: false,
				success: function(data, textStatus, jqXHR) {
					if ($(data).find('errorcode').text() == "0000") {
						location.href = "/main.jsp";
					} else if ($(data).find('errorcode').text() == "<%=CommonError.COMM_ERROR_ADMIN_ALREADY_LOGGED_ON%>") {
						displayConfirmDialog("로그인", $(data).find('errormsg').text() + " 강제 로그인 하시겠습니까?", "", function() { adminLogin(1); });
					} else {
						displayAlertDialog("로그인", "로그인 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("로그인", "로그인 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		};
	//-->
	</script>
</head>
<body style="background-color: #1e1f23;">
	<div id="div-main" class="centered-main">
		<div class="login-container">
			<div class="main_logo"><img src="/images/<%=imageTitle%>" /></div>
			<div style="margin-top: 55px;">
				<form id="login-form" name="login-form" method="post" autocomplete="off">
					<div class="field-line">
						<div class="field-title">ID</div>
						<div class="field-value">
							<input type="text" id="adminid" name="adminid" class="field-input" />
						</div>
					</div>
					<div class="field-line">
						<div class="field-title">PASSWORD</div>
						<div class="field-value">
							<input type="password" id="pwd" name="pwd" class="field-input" />
						</div>
					</div>
				</form>
			</div>
			<div class="button-line">
				<input type="button" id="btnLogin" class="login-button" value="LOGIN" style="width: 370px;"/>
			</div>
<% if ("MEDISAFER".equals(oemString) || "BIZSAFER".equals(oemString)) { %>
			<div class="guide">
				<div id="privacyhandlingpolicy" style="float:left; width: 50%; cursor: pointer;">개인정보처리방침</div>
				<div style="margin-left: 51%; text-align: right;"><img src="/images/icon_callcenter.png" style="height: 14px;" /> 고객센터: 1670-4530</div>
				<div class="clear"></div>
			</div>
<% } %>
		</div>
	</div>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
</body>
</html>
