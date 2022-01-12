<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>Safe.PrivacyKeeper Server</title>
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/css/darkness.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />
<% } %>

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/themes/darkness/jquery.ui.all.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/themes/default/jquery.ui.all.css" media="all" />
<% } %>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.mouse.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.button.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.draggable.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.position.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.resizable.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.dialog.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.progressbar.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.tooltip.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/i18n/jquery.ui.datepicker-ko.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/ui/jquery.ui.effect.js"></script>

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

	<link rel="stylesheet" type="text/css" href="/js/pagination/css/style.css" media="all" />
	<script type="text/javascript" src="/js/pagination/js/jquery.paginate.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

	<script type="text/javascript" src="/js/jstree-v.pre1.0/jquery.jstree.js"></script>

	<script type="text/javascript" src="/js/checkparam.js"></script>
	<script type="text/javascript" src="/js/commparam.js"></script>
	<script type="text/javascript" src="/js/types.js"></script>
	<script type="text/javascript" src="/js/dateutil.js"></script>
</head>

<body>
	<div class="page">
		<div class="ui-widget header">
		</div>
		<div class="ui-widget container">
			<div class="container-body">
				<%@ include file ="batchsendlogbody.jsp"%>
			</div>
		</div>
		<div class="ui-widget footer">
			<%@ include file ="/bottom.jsp"%>
		</div>
	</div>
</body>
</html>
