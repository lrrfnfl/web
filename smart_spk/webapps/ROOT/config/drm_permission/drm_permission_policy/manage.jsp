<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title><%=CommonConstant.SERVER_TITLE%></title>

	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/development-bundle/ui/i18n/jquery.ui.datepicker-ko.js"></script>
	<script type="text/javascript" src="/js/jquery-dialogextend-master/build/jquery.dialogextend.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-layout/layout-default-latest.css" />
	<script type="text/javascript" src="/js/jquery-ui-layout/jquery.layout-latest.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/menu/css/dcmegamenu.css" media="all" />
	<link rel="stylesheet" type="text/css" href="/js/menu/css/skins/black.css" media="all" />
	<script type='text/javascript' src="/js/menu/js/jquery.hoverIntent.minified.js"></script>
	<script type='text/javascript' src="/js/menu/js/jquery.dcmegamenu.1.3.3.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
	<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

	<script type="text/javascript" src="/js/jstree-v.pre1.0/jquery.jstree.js"></script>

	<script type="text/javascript" src="/js/jquery.scrolltable.js"></script>

	<script type="text/javascript" src="/js/autoNumeric-min.js"></script>
	<script type="text/javascript" src="/js/checkparam.js"></script>
	<script type="text/javascript" src="/js/commparam.js"></script>
	<script type="text/javascript" src="/js/types.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all" />
	<script type="text/javascript" src="/js/layout.js"></script>
	<script type="text/javascript" src="/js/uiutil.js"></script>
	<script type="text/javascript">
	<!--
		$(document).ready(function() {
			outerLayout = $("body").layout(outerDefaultLayoutOptions);
			showInnerLayout("innerDefault");
		});

		reloadDefaultLayout = function() {

			var layoutHeight = $('#drm-permission-policy-tree').parent().height();
			var paddingTop = parseInt($('#drm-permission-policy-tree').css("padding-top"));
			var paddingBottom = parseInt($('#drm-permission-policy-tree').css("padding-bottom"));
			if ($('#drm-permission-policy-tree').length) {
				$('#drm-permission-policy-tree').height(layoutHeight - paddingTop - paddingBottom);
				$('#drm-permission-policy-tree').mCustomScrollbar('update');
			}

			var layoutContentHeight = $('.inner-center .ui-layout-content').height();
			var mainContentPaddingTop = parseInt($('#main-content').css("padding-top"));
			var mainContentPaddingBottom = parseInt($('#main-content').css("padding-bottom"));
			var categoryTitleHeight = $('.category-sub-title').outerHeight(true);
			var buttonLineHeight = $('.button-line').outerHeight(true);
			if ($('.droppable').length) {
				$('.droppable').outerHeight(layoutContentHeight - categoryTitleHeight - buttonLineHeight - mainContentPaddingTop - mainContentPaddingBottom);
				$('.draggable').outerHeight(layoutContentHeight - categoryTitleHeight - buttonLineHeight - mainContentPaddingTop - mainContentPaddingBottom);
				$('#target-users-tree').outerHeight($('.draggable').height());
				$('#target-users-tree').mCustomScrollbar('update');
				$('#drm-permission-policy').mCustomScrollbar('update');
			}
		};
	//-->
	</script>
</head>
<body>
	<div class="ui-layout-north">
		<%@ include file ="/top.jsp"%>
<!-- 		<div class="site-map-path"> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-folder-open"></span></li></ul> -->
<!-- 			<span class="parent-path">??????</span> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-carat-1-e"></span></li></ul> -->
<!-- 			<span class="parent-path">???????????? ??????</span> -->
<!-- 			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-carat-1-e"></span></li></ul> -->
<!-- 			<span class="current-path">?????? ??????</span> -->
<!-- 		</div> -->
	</div>
	<div class="ui-layout-center">
		<div id="innerDefault" class="inner-layout-container">
			<%@ include file ="managebody.jsp"%>
		</div>
	</div>
<!-- 	<div class="ui-layout-south"> -->
<%-- 		<%@ include file ="/bottom.jsp"%> --%>
<!-- 	</div> -->
</body>
</html>
