<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.error.CommonError" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title><%=CommonConstant.SERVER_TITLE%></title>

	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>

	<script type="text/javascript">
	<!--
		var g_objDivMessage;

		$(document).ready(function() {
			g_objDivMessage = $('#div-message');
			g_objDivMessage.centerToWindow();

			$(window).resize(function() {
				g_objDivMessage.centerToWindow();
			});
		});

		$.fn.centerToWindow = function() {
			var obj = $(this);
			var obj_width = $(this).outerWidth(true);
			var obj_height = $(this).outerHeight(true);
			var window_width = window.innerWidth ? window.innerWidth : $(window).width();
			var window_height = window.innerHeight ? window.innerHeight : $(window).height();

			obj.css({
				"position" : "fixed",
				"top" : ((window_height / 2) - (obj_height / 2))+"px",
				"left" : ((window_width / 2) - (obj_width / 2))+"px"
			});
		};
	//-->
	</script>
</head>

<body style="background-color: #fff">
	<div id="div-message" class="ui-widget" style="width: 50%; text-align: center; border: 4px double #922727; border-radius: 12px; -webkit-box-shadow:0px 0px 5px 5px #922727; -moz-box-shadow:0px 0px 5px 5px #922727; box-shadow:0px 0px 5px 5px #922727;">
		<div style="margin: 20px auto;">
			<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
				<div style="font-size: 14px;"><strong>처리중 오류가 발생하셨습니다.</strong></div>
				<div style="margin-top: 8px; font-size: 12px;"><span><%=CommonError.getErrorMessage(request.getParameter("ErrorCode"))%>(<%=request.getParameter("ErrorCode")%>)</span></div>
			</div>
		</div>

	</div>
</body>
</html>
