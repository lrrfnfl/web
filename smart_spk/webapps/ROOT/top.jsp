<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ page import="com.spk.util.Util" %>
<%@ page import="com.spk.util.DbUtil" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%
String serverTypeString = "";
String versionString = "1.0.0.0";
String imageTitle = "top_logo_spk.png";
String oemString = "";
String webTitleString = CommonConstant.SERVER_TITLE;

//****************************************************************************
// 관리자의 로그인 상태 정보를 읽어옴
//****************************************************************************
HashMap<String, String> mapLoginStatus = DbUtil.getAdminLoginStatus(session);
if (!mapLoginStatus.isEmpty()) {
	//************************************************************************
	// 사업장 생성이후 최초 관리자 로그인시 main.jsp에서 랜딩 설정 Dialog 팝업
	//************************************************************************
	if (OptionType.OPTION_TYPE_NO.equals((String) session.getAttribute("ISFIRSTLOGINADMINOFCOMPANY"))) {
		//************************************************************************
		// 관리자 생성 후 비밀번호를 변경하지 않은 관리자인 경우 - 비밀번호 변경 페이지로 이동
		//************************************************************************
		if (!AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String) session.getAttribute("ADMINTYPE")) &&
				ChangeFirstPasswordState.CHANGE_FIRST_PASSWORD_STATE_NONE.equals((String) session.getAttribute("CHANGEFIRSTPASSWORDFLAG"))) {
			if (!request.getRequestURI().equals("/manage/account/admin_manage/manage.jsp")) {
				response.sendRedirect("/manage/account/admin_manage/manage.jsp");
			}
		}

		//************************************************************************
		// 비밀번호 유효기간이 만료된 경우 - 비밀번호 변경 페이지로 이동
		//************************************************************************
		if (OptionType.OPTION_TYPE_YES.equals((String) session.getAttribute("NEEDCHANGEPASSWORDFLAG"))) {
			if (!request.getRequestURI().equals("/manage/account/admin_manage/manage.jsp")) {
				response.sendRedirect("/manage/account/admin_manage/manage.jsp");
			}
		}
	}

	//************************************************************************
	// 서버 정보를 읽어옴
	//************************************************************************
	HashMap<String, String> mapTopServerConfig = DbUtil.getServerConfig(session);
	if (!mapTopServerConfig.isEmpty()) {
		ServerType serverType = new ServerType();
		serverTypeString = serverType.getTypeValue(mapTopServerConfig.get("servertype"));
		versionString = mapTopServerConfig.get("version");
		oemString = mapTopServerConfig.get("oem").toUpperCase();
		if ("MEDISAFER".equals(oemString)) {
			webTitleString = CommonConstant.MEDISAFER_SERVER_TITLE;
			imageTitle = "top_logo_medisafer.png";
		} else if ("BIZSAFER".equals(oemString)) {
			webTitleString = CommonConstant.BIZSAFER_SERVER_TITLE;
			imageTitle = "top_logo_bizsafer.png";
		}
	}
} else {
	response.sendRedirect("/login/login.jsp");
}
%>
<script type="text/javascript">
	document.title = "<%=webTitleString%>";

// 	if (session.getId().equals(mapLoginStatus.get("loginsessionid"))) {
// 		if (!LoginState.LOGIN_STATE_LOGIN.equals(mapLoginStatus.get("loginflag"))) {
// 	alert("연결이 종료되었습니다. 다시 접속해 주세요.");
// 	location.href = "/login/login.jsp";
// 		}
// 	} else {
// 		if (LoginState.LOGIN_STATE_FORCED_LOGOUT.equals(mapLoginStatus.get("loginflag"))) {
// 	alert("다른 관리자의 접속으로 현재의 연결이 종료되었습니다.");
// 	location.href = "/login/login.jsp";
// 		} else {
// 	alert("연결이 종료되었습니다. 다시 접속해 주세요.");
// 	location.href = "/login/login.jsp";
// 		}
// 	}
<%-- %> --%>
	var g_timeoutHandle;
	var g_isWorking = false;

	$(document).ready(function($){
		setBrowserTimeout();

		$(window.document).click( function() {
			clearBrowserTimeout();
			setBrowserTimeout();
		});

		showMenu();

		window.onbeforeunload = function () {
			if (isBrowserClosed()) {
				logout();
			}
		};

		$('button[name="btnHelp"]').button({ icons: {primary: "ui-icon-disk"} });

		$('#btnLogout').click(function() {
			logout();
		});

<% if ("darkness".equals((String) session.getAttribute("THEMENAME"))) { %>
		$('select[name="selecttheme"] option[value="darkness"]').prop("selected", "selected");
<% } else { %>
		$('select[name="selecttheme"] option[value="default"]').prop("selected", "selected");
<% } %>
		$('select[name="selecttheme"]').change( function() {
			changeTheme($(this).val());
		});
	});

	showMenu = function() {
		var rowItemsCount = '1';
		var maximizeWidth = false;
		if ($(window).height() < 800) {
			rowItemsCount = '4';
			//maximizeWidth = true;
		}
		$('#mega-menu-1').show();
		$('#mega-menu-1').dcMegaMenu({
			rowItems: rowItemsCount,
			fullWidth: maximizeWidth,
			speed: 'fast',
			effect: 'fade',
			fullWidth: false
		});
	};

	isBrowserClosed = function() {
		var browserWindowWidth = 0;
		//var browserWindowHeight = 0;

		// gets the width and height of the browser window
		if (parseInt(navigator.appVersion) > 3) {
			if (navigator.appName == "Netscape") {
				browserWindowWidth = window.innerWidth;
				//browserWindowHeight = window.innerHeight;
			}

			if (navigator.appName.indexOf("Microsoft") !=- 1) {
				browserWindowWidth = top.window.document.body.offsetWidth;
				//browserWindowHeight = top.window.document.body.offsetHeight;
			}
		}

		// checks if the X button was closed
		// if event.clientY < 0, then click was on the browser menu area
		// if event.screenX > (browserWindowWidth - 25), the X button was clicked
		// use screenX if working with multiple frames

		return (event.clientY < 0 && event.screenX > (browserWindowWidth - 25)) ? true : false;
	};

	setBrowserTimeout = function() {
		if (!g_isWorking) {
			g_timeoutHandle = setTimeout("logout()", <%=session.getMaxInactiveInterval()*1000%>);
		}
	};

	clearBrowserTimeout = function() {
		clearTimeout(g_timeoutHandle);
	};
	
	logout = function() {
		location.href = "/login/logout.jsp";
	};
/*
	changeTheme = function(themeName) {
		var postData = getRequestChangeThemeParam(themeName);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("THEME 변경", "THEME 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					window.location.reload(true);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("THEME 변경", "THEME 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
*/
</script>

<div class="top_status_bar">
	<%=(String) session.getAttribute("ADMINID")%> 님&nbsp;
	<input type="button" id="btnLogout" class="logout-button" value="LOGOUT" />
</div>
<div class="top_menu_bar">
	<div class="first_block">
		<div class="logo-display">
			<span><a href="/main.jsp" onFocus="this.blur();"><img src="/images/<%=imageTitle%>" /></a></span>
		</div>
	</div>
	<div class="second_block">
		<ul id="mega-menu-1" class="mega-menu">
			<li><a href="#">관리</a>
				<ul>
					<li><a href="#">조직 관리</a>
						<ul>
							<li><a href="/manage/organization/organization_manage/manage.jsp">부서/사용자 관리</a></li>
							<li><a href="/manage/organization/batch_user_regist/manage.jsp">사용자 배치 등록</a></li>
<% if (AdminType.ADMIN_TYPE_COMPANY_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
	<% if ("TRUE".equals(session.getServletContext().getInitParameter("activate_user_synchronization").toUpperCase())) { %>
							<li><a href="/manage/organization/user_synchronization/manage.jsp">사용자 동기화</a></li>
	<% } %>
<% } %>
						</ul>
					</li>
<% if (AdminType.ADMIN_TYPE_COMPANY_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
					<li><a href="#">사업장/계정 관리</a>
						<ul>
							<li><a href="/manage/account/company_manage/manage.jsp">사업장 관리</a></li>
							<li><a href="/manage/account/admin_manage/manage.jsp">계정 관리</a></li>
						</ul>
					</li>
<% } %>
					<li><a href="#">공지 관리</a>
						<ul>
							<li><a href="/manage/user_notice/user_notice_manage/manage.jsp">사용자 공지</a></li>
						</ul>
					</li>
<% if ((session.getAttribute("DBPROTECTIONOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("DBPROTECTIONOPTION"))) { %>
					<li><a href="#">DB 보안 관리</a>
						<ul>
							<li><a href="/manage/db_protection/db_protection_manage/manage.jsp">DB 보안 설정</a></li>
							<li><a href="/manage/db_protection/db_protection_log/list.jsp">DB 보안 로그</a></li>
						</ul>
					</li>
<% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("DBPROTECTIONOPTION"))) { %>
					<li><a href="#">DB 보안 관리</a>
						<ul>
							<li><a href="javascript:void(0);.jsp" class="disabled">DB 보안 설정</a></li>
							<li><a href="javascript:void(0);" class="disabled">DB 보안 로그</a></li>
						</ul>
					</li>
<% } %>
<% if ((session.getAttribute("SOFTWAREMANAGEOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("SOFTWAREMANAGEOPTION"))) { %>
					<li><a href="#">소프트웨어 관리</a>
						<ul>
							<li><a href="/manage/software/software_installation/softwareinstallationperorganizationlist.jsp">조직별 설치 내역</a></li>
							<li><a href="/manage/software/software_installation/softwareinstallationpersoftwarelist.jsp">소프트웨어별 설치 내역</a></li>
						</ul>
					</li>
<% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("SOFTWAREMANAGEOPTION"))) { %>
					<li><a href="#">소프트웨어 관리</a>
						<ul>
							<li><a href="javascript:void(0);" class="disabled">조직별 설치 내역</a></li>
							<li><a href="javascript:void(0);" class="disabled">소프트웨어별 설치 내역</a></li>
						</ul>
					</li>
<% } %>

				</ul>
			</li>
			<li><a href="#">설정</a>
				<ul>
					<li><a href="#">에이전트</a>
						<ul>
							<li><a href="/config/agent/agent_config/manage.jsp">에이전트 설정</a></li>
							<li><a href="/config/agent/agent_config_status/list.jsp">에이전트 설정 현황</a></li>
						</ul>
					</li>
					<li><a href="#">검사</a>
						<ul>
							<li><a href="/config/search/force_search/manage.jsp">강제검사</a></li>
							<li><a href="/config/search/reserve_search/manage.jsp">예약검사</a></li>
						</ul>
					</li>
					<li><a href="#">결재</a>
						<ul>
							<li><a href="/config/approval/approvator_manage/manage.jsp">결재자 설정</a></li>
						</ul>
					</li>
					<li style="display: none;"><a href="#">문서보안 권한</a>
						<ul>
							<li><a href="/config/drm_permission/drm_permission_policy/manage.jsp">정책 설정</a></li>
							<li><a href="/config/drm_permission/user_belongs_drm_permission_policy_status/list.jsp">사용자별 소속 정책 현황</a></li>
						</ul>
					</li>
				</ul>
			</li>
			<li><a href="#">조회</a>
				<ul>
					<li><a href="#">에이전트</a>
						<ul>
							<li><a href="/search/agent/user_log/list.jsp">사용자 로그</a></li>
						</ul>
					</li>
					<li><a href="#">개인정보</a>
						<ul>
							<li><a href="/search/privacy/search_log/list.jsp">검사 내역</a></li>
							<li><a href="/search/privacy/detect_log/list.jsp">검출 내역</a></li>
							<li><a href="/search/privacy/realtime_observation_log/list.jsp">실시간 파일 감시 내역</a></li>
						</ul>
					</li>
<% if (((session.getAttribute("MEDIACONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) ||
		((session.getAttribute("NETWORKSERVICECONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION")))) { %>
					<li><a href="#">정보 유출 방지</a>
						<ul>
<% if (((session.getAttribute("MEDIACONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) ||
		((session.getAttribute("NETWORKSERVICECONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION")))) { %>
							<li><a href="/search/media_control/media_control_log/list.jsp">매체/네트워크 제어 내역</a></li>
<!-- 							<li><a href="/search/url_block/url_block_log/list.jsp">URL 차단 내역</a></li> -->
<% } else if ((SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) &&
		(SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION")))) { %>
							<li><a href="javascript:void(0);" class="disabled">매체/네트워크 제어 내역</a></li>
<!-- 							<li><a href="javascript:void(0);" class="disabled">URL 차단 내역</a></li> -->
<% } %>
						</ul>
					</li>
<% } %>
					<li><a href="#">결재</a>
						<ul>
							<li><a href="/search/approval/approval_status/list.jsp">결재 목록</a></li>
						</ul>
					</li>
<!-- 					<li><a href="#">안전반출</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/search/safe_export/safe_export_staus/list.jsp">안전반출 목록</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<% if ("MEDISAFER".equalsIgnoreCase(oemString) || "BIZSAFER".equalsIgnoreCase(oemString)) { %>
	<% if ((session.getAttribute("RANSOMWAREDETECTIONOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("RANSOMWAREDETECTIONOPTION"))) { %>
					<li><a href="#">랜섬웨어</a>
						<ul>
							<li><a href="/search/ransomware/ransomware_detect_log/list.jsp">검출 목록</a></li>
						</ul>
					</li>
	<% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("RANSOMWAREDETECTIONOPTION"))) { %>
					<li><a href="#">랜섬웨어</a>
						<ul>
							<li><a href="javascript:void(0);" class="disabled">검출 목록</a></li>
						</ul>
					</li>
	<% } %>
<% } %>
					<li style="display: none;"><a href="#">문서보안 권한</a>
						<ul>
							<li><a href="/search/drm_permission/drm_permission_settings_log/list.jsp">설정 내역</a></li>
						</ul>
					</li>
<%-- <% if ((session.getAttribute("PRINTCONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">출력</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/search/print/print_log/list.jsp">출력 목록</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
					
<%-- <% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">출력</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="javascript:void(0);" class="disabled">출력 목록</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% } %> --%>
				</ul>
			</li>
			<li><a href="#">통계</a>
				<ul>
					<li><a href="#">에이전트</a>
						<ul>
							<li><a href="/statistics/agent/agent_install_status/status.jsp">에이전트 설치 현황</a></li>
						</ul>
					</li>
					<li><a href="#">개인정보</a>
						<ul>
							<li><a href="/statistics/privacy/search_status_per_terms/status.jsp">기간별 검사 현황</a></li>
							<li><a href="/statistics/privacy/detect_status_per_terms/status.jsp">기간별 검출 현황</a></li>
							<li><a href="/statistics/privacy/pattern_detect_status_per_organization/status.jsp">조직별 패턴 검출 현황</a></li>
							<li><a href="/statistics/privacy/filetype_detect_status_per_organization/status.jsp">조직별 파일 유형 검출 현황</a></li>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
							<li><a href="/statistics/privacy/company_detect_status_per_pattern/status.jsp">패턴별 사업장 검출 현황</a></li>
<% } %>
							<li><a href="/statistics/privacy/dept_detect_status_per_pattern/status.jsp">패턴별 부서 검출 현황</a></li>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
							<li><a href="/statistics/privacy/company_detect_status_per_filetype/status.jsp">파일 유형별 사업장 검출 현황</a></li>
<% } %>
							<li><a href="/statistics/privacy/dept_detect_status_per_filetype/status.jsp">파일 유형별 부서 검출 현황</a></li>
						</ul>
					</li>
<!-- 					<li><a href="#">안전반출</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/statistics/safe_export/safe_export_status_per_terms/status.jsp">기간별 반출 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<% if ("MEDISAFER".equalsIgnoreCase(oemString) || "BIZSAFER".equalsIgnoreCase(oemString)) { %>
	<% if ((session.getAttribute("RANSOMWAREDETECTIONOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("RANSOMWAREDETECTIONOPTION"))) { %>
					<li><a href="#">랜섬웨어</a>
						<ul>
							<li><a href="/statistics/ransomware/ransomware_detect_status_per_terms/status.jsp">기간별 검출 현황</a></li>
						</ul>
					</li>
	<% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("RANSOMWAREDETECTIONOPTION"))) { %>
					<li><a href="#">랜섬웨어</a>
						<ul>
							<li><a href="javascript:void(0);" class="disabled">기간별 검출 목록</a></li>
						</ul>
					</li>
	<% } %>
<% } %>
<%-- <% if ((session.getAttribute("PRINTCONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">출력</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/statistics/print/print_status_per_terms/status.jsp">기간별 출력 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">출력</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="javascript:void(0);" class="disabled">기간별 출력 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% } %> --%>
				</ul>
			</li>
			<li><a href="#">리포트</a>
				<ul>
					<li><a href="#">개인정보</a>
						<ul>
							<li><a href="/report/privacy/user_not_executed_search/list.jsp">검사 미실행 사용자 목록</a></li>
							<li><a href="/report/privacy/detect_status_per_user/list.jsp">사용자별 검출 현황</a></li>
							<li><a href="/report/privacy/detect_status_per_dept/list.jsp">부서별 검출 현황</a></li>
							<li><a href="/report/privacy/detect_file_list/list.jsp">검출 파일 목록</a></li>
							<li><a href="/report/privacy/detect_file_process_status_per_user/list.jsp">사용자별 검출 파일 처리 현황</a></li>
							<li><a href="/report/privacy/detect_file_process_status_per_dept/list.jsp">부서별 검출 파일 처리 현황</a></li>
						</ul>
					</li>
<!-- 					<li><a href="#">안전반출</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/report/safe_export/safe_export_status_per_user/list.jsp">사용자별 반출 현황</a></li> -->
<!-- 							<li><a href="/report/safe_export/safe_export_status_per_dept/list.jsp">부서별 반출 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% if ((session.getAttribute("PRINTCONTROLOPTION") == null) || SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">프린트</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="/report/print/print_status_per_user/list.jsp">사용자별 출력 현황</a></li> -->
<!-- 							<li><a href="/report/print/print_status_per_dept/list.jsp">부서별 출력 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% } else if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_DEACTIVATE.equals((String) session.getAttribute("PRINTCONTROLOPTION"))) { %> --%>
<!-- 					<li><a href="#">프린트</a> -->
<!-- 						<ul> -->
<!-- 							<li><a href="javascript:void(0);" class="disabled">사용자별 출력 현황</a></li> -->
<!-- 							<li><a href="javascript:void(0);" class="disabled">부서별 출력 현황</a></li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<%-- <% } %> --%>
					<li><a href="#">보안정책 현황</a>
						<ul>
							<li><a href="/report/security_status/monthly_report/list.jsp">월별 보안정책 현황</a></li>
						</ul>
					</li>
				</ul>
			</li>
			<li><a href="#">모니터링</a>
				<ul>
					<li><a href="#">에이전트</a>
						<ul>
							<li><a href="/monitor/agent/agent_access_status/list.jsp">사용자 접속 현황</a></li>
							<li><a href="/monitor/agent/agent_system_status/list.jsp">사용자 시스템 현황</a></li>
						</ul>
					</li>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
					<li><a href="#">서버</a>
						<ul>
							<li><a href="/monitor/server/server_system_status/status.jsp">서버 시스템 정보</a></li>
						</ul>
					</li>
<% } %>
				</ul>
			</li>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String) session.getAttribute("ADMINTYPE"))) { %>
			<li><a href="#">사이트 관리</a>
				<ul>
	<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
					<li><a href="#">서비스</a>
						<ul>
							<li><a href="/site_manage/service/application/manage.jsp">서비스 신청</a></li>
						</ul>
					</li>
	<% } %>
					<li><a href="#">사업장</a>
						<ul>
							<li><a href="/site_manage/company/company_manage/manage.jsp">사업장 관리</a></li>
	<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
							<li><a href="/site_manage/licence/licence_manage/manage.jsp">라이센스 관리</a></li>
							<li><a href="/site_manage/licence/licence_renewal_history/list.jsp">라이센스 갱신 목록</a></li>
<!-- 							<li><a href="/site_manage/payment/payment_history/list.jsp">결제 내역 목록</a></li> -->
	<% } %>
						</ul>
					</li>
					<li><a href="#">관리자</a>
						<ul>
							<li><a href="/site_manage/admin/admin_manage/manage.jsp">관리자 관리</a></li>
							<li><a href="/site_manage/admin/admin_log/list.jsp">관리자 로그</a></li>
						</ul>
					</li>
					<li><a href="#">패턴</a>
						<ul>
							<li><a href="/site_manage/pattern/pattern_manage/manage.jsp">패턴 관리</a></li>
						</ul>
					</li>
					<li><a href="#">네트워크</a>
						<ul>
							<li><a href="/site_manage/media_control/network_service_control_program/manage.jsp">서비스 제어 프로그램 관리</a></li>
						</ul>
					</li>
<% if ("MEDISAFER".equalsIgnoreCase(oemString) || "BIZSAFER".equalsIgnoreCase(oemString)) { %>
					<li><a href="#">랜섬웨어</a>
						<ul>
							<li><a href="/site_manage/ransomware/ransomware_credential_exception_manage/manage.jsp">신뢰정보 예외 관리</a></li>
							<li><a href="/site_manage/ransomware/ransomware_behavior_profile_exception_manage/manage.jsp">행위분석 예외 관리</a></li>
						</ul>
					</li>
<% } %>
					<li><a href="#">API</a>
						<ul>
							<li><a href="/site_manage/api/api_callable_address_manage/manage.jsp">API 호출 가능 주소 관리</a></li>
						</ul>
					</li>
					<li><a href="#">에이전트</a>
						<ul>
							<li><a href="/site_manage/agent/agent_update_manage/manage.jsp">업데이트 관리</a></li>
						</ul>
					</li>
				</ul>
			</li>
<% } %>
		</ul>
	</div>
	<div class="clear"></div>
</div>
