<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ page import="com.spk.util.Util" %>
<%@ page import="com.spk.util.DbUtil" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

	//***************************************************************************************
	// 사이트 관리자는 사업장 관리 페이지로 이동
	//***************************************************************************************//
	if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE")) && AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) {
		response.sendRedirect("/site_manage/company/company_manage/manage.jsp");
	}

	String webTitle = CommonConstant.SERVER_TITLE;
	/*************************************************************************
	 * 서버 설정 정보 조회
	 ************************************************************************/
	 HashMap<String, String> mapServerConfig = DbUtil.getServerConfig(session);
	if (!mapServerConfig.isEmpty()) {
		if ("MEDISAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			webTitle = CommonConstant.MEDISAFER_SERVER_TITLE;
		} else if ("BIZSAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			webTitle = CommonConstant.BIZSAFER_SERVER_TITLE;
		}
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title><%=webTitle%></title>

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

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-layout/layout-default-latest.css" />
	<script type="text/javascript" src="/js/jquery-ui-layout/jquery.layout-latest.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/menu/css/dcmegamenu.css" media="all" />
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/js/menu/css/skins/black.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/js/menu/css/skins/black.css" media="all" />
<% } %>
	<script type='text/javascript' src="/js/menu/js/jquery.hoverIntent.minified.js"></script>
	<script type='text/javascript' src="/js/menu/js/jquery.dcmegamenu.1.3.3.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

<!--[if lt IE 11]>
	<script type="text/javascript" src="/js/chartjs/classList.js"></script>
<![endif]-->
	<script type="text/javascript" src="/js/chartjs/Chart.bundle.js"></script>
	<script type="text/javascript" src="/js/chartjs/chartjs-plugin-style.js"></script>

	<script type="text/javascript" src="/js/checkparam.js"></script>
	<script type="text/javascript" src="/js/commparam.js"></script>
	<script type="text/javascript" src="/js/types.js"></script>
	<script type="text/javascript" src="/js/dateutil.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all" />
	<script type="text/javascript" src="/js/layout.js"></script>

	<script type="text/javascript">
	<!--
		var TAB_DAILY = 0;
		var TAB_MONTHLY = 1;
		var TAB_TODAY = 0;
		var TAB_WEEK = 1;
		var TAB_MONTH = 2;

		$(document).ready(function() {
			$('button').button();
			$( document ).tooltip();

			outerLayout = $("body").layout(outerMainLayoutOptions);
			showInnerLayout("innerMain");
		});

		reloadMainLayout = function() {
		};
	//-->
	</script>
	<style>
		.styles-tab > .ui-widget-header { 
			border: none;
			background: #aaa url(/js/jquery-ui-1.10.3/css/custom-theme/images/ui-bg_highlight-soft_75_e0e0e0_1x100.png) 50% 50% repeat-x;
			border-top-left-radius: 0px;
			border-top-right-radius: 0px;
			border-bottom-left-radius: 0px;
			border-bottom-right-radius: 0px;
		}
	</style>
</head>
<body>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>

	<div class="ui-layout-north"> 
		<%@ include file ="/top.jsp"%>
	</div> 
	<div class="ui-layout-center"> 
		<div id="innerMain" class="inner-layout-container"> 
			<div class="inner-west border-none">
				<%@ include file ="/main_frame/west_center.jsp"%>
				<%@ include file ="/main_frame/west_south.jsp"%>
			</div> 
			<div class="inner-center border-none">
				<%@ include file ="/main_frame/center_center.jsp"%>
				<%@ include file ="/main_frame/center_south.jsp"%>
			</div> 
			<div class="inner-east border-none">
				<%@ include file ="/main_frame/east_north.jsp"%>
				<%@ include file ="/main_frame/east_center.jsp"%>
				<%@ include file ="/main_frame/east_south.jsp"%>
			</div> 
		</div> 
	</div> 
<!-- 	<div class="ui-layout-south">  -->
<%-- 		<%@ include file ="/bottom.jsp"%> --%>
<!-- 	</div> -->

<% if (OptionType.OPTION_TYPE_YES.equals((String) session.getAttribute("ISFIRSTLOGINADMINOFCOMPANY"))) { %>
	<%@ include file ="/main_frame/landing-dialog.jsp"%>
<% } %>
</body>
</html>
