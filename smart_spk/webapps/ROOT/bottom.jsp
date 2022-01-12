<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	$(document).ready(function () {
		$("#privacyhandlingpolicy").click(function () {
			//window.open("/privacy_handling_policy/index.html", "_blank", "width=990,height=600,menubar=no,status=no,toolbar=no,scrollbars=yes");
			window.open("http://www.skbroadband.com/footer/Page.do?retUrl=/footer/PrivacyStatement", "_blank", "width=990,height=600,menubar=no,status=no,toolbar=no,scrollbars=yes");
		});
	});
//-->
</script>
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<div style="width:100%; height:33px; background: #fff url(/images/img_copy_right.png) no-repeat center center;">
		<% if ("MEDISAFER".equals((String) session.getAttribute("OEM")) || "BIZSAFER".equals((String) session.getAttribute("OEM"))) { %>
		<div id="privacyhandlingpolicy" title="개인정보처리방침" style="float: right; padding: 10px; color: #F05000; cursor: pointer;">개인정보처리방침</div>
		<% } %>
	</div>
<% } else { %>
	<div style="width:100%; height:33px; background: #fff url(/images/copy_text.gif) no-repeat center center;">
		<% if ("MEDISAFER".equals((String) session.getAttribute("OEM")) || "BIZSAFER".equals((String) session.getAttribute("OEM"))) { %>
		<div id="privacyhandlingpolicy" title="개인정보처리방침" style="float: right; padding: 10px; color: #F05000; cursor: pointer;">개인정보처리방침</div>
		<% } %>
	</div>
<% } %>
