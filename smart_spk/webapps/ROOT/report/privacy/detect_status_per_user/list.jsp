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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
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
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/development-bundle/ui/i18n/jquery.ui.datepicker-ko.js"></script>

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

	<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
	<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

	<script type="text/javascript" src="/js/jstree-v.pre1.0/jquery.jstree.js"></script>

	<script type="text/javascript" src="/js/jquery.pagination.js"></script>

	<script type="text/javascript" src="/js/checkparam.js"></script>
	<script type="text/javascript" src="/js/commparam.js"></script>
	<script type="text/javascript" src="/js/types.js"></script>
	<script type="text/javascript" src="/js/dateutil.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all" />
	<script type="text/javascript" src="/js/layout.js"></script>

	<script type="text/javascript">
	<!--
		$(document).ready(function() {
			outerLayout = $("body").layout(outerDefaultLayoutOptions);
			showInnerLayout("innerDefault");
		});

		reloadDefaultLayout = function() {
			var layoutHeight = $('.treeview-pannel').parent().height();
			var paddingTop = parseInt($('.treeview-pannel').css("padding-top"));
			var paddingBottom = parseInt($('.treeview-pannel').css("padding-bottom"));
			if ($('.treeview-pannel').length) {
				$('.treeview-pannel').height(layoutHeight - paddingTop - paddingBottom);
				$('.treeview-pannel').mCustomScrollbar('update');
			}
			$('.inner-center .ui-layout-content').mCustomScrollbar('update');
		};
	//-->
	</script>
</head>
<body>
	<div class="ui-layout-north">
		<%@ include file ="/top.jsp"%>
<!-- 		<div class="site-map-path"> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-folder-open"></span></li></ul> -->
<!-- 			<span class="parent-path">리포트</span> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-carat-1-e"></span></li></ul> -->
<!-- 			<span class="parent-path">검출 현황</span> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-carat-1-e"></span></li></ul> -->
<!-- 			<span class="current-path">사용자별 검출 현황</span> -->
<!-- 		</div> -->
	</div>
	<div class="ui-layout-center">
		<div id="innerDefault" class="inner-layout-container">
			<%@ include file ="listbody.jsp"%>
		</div>
	</div>
<!-- 	<div class="ui-layout-south"> -->
<%-- 		<%@ include file ="/bottom.jsp"%> --%>
<!-- 	</div> -->
</body>
</html>