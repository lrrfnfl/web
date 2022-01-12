<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	$(document).ready(function() {
		loadEastNorthStatusData();
	});

	function loadEastNorthStatusData() {
		var postData = getRequestUserConnectionStatusParam("<%=(String)session.getAttribute("COMPANYID")%>");

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('.ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {

				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 현황 조회", "사용자 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th class="ui-widget-header ui-state-default">구분</th>';
				htmlContents += '<th class="ui-widget-header ui-state-default">사용자 수</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var userCount = $(data).find('usercount').text();
				var installCount = $(data).find('installcount').text();
				var todayLoginCount = $(data).find('todaylogincount').text();
				var currentLoginCount = $(data).find('currentlogincount').text();

				if (installCount.length == 0)	installCount = "0";
				if (todayLoginCount.length == 0)	todayLoginCount = "0";
				if (currentLoginCount.length == 0)	currentLoginCount = "0";

				htmlContents += '<tr class="list_odd">';
				htmlContents += '<td>전체 사용자 수</td>';
				htmlContents += '<td>' + userCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
				htmlContents += '</tr>';
				htmlContents += '<tr class="list_even">';
				htmlContents += '<td>설치 사용자 수</td>';
				htmlContents += '<td>' + installCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
				htmlContents += '</tr>';
				htmlContents += '<tr class="list_odd">';
				htmlContents += '<td>금일 접속자 수</td>';
				htmlContents += '<td>' + todayLoginCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
				htmlContents += '</tr>';
				htmlContents += '<tr class="list_even">';
				htmlContents += '<td>현재 접속자 수</td>';
				htmlContents += '<td>' + currentLoginCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
				htmlContents += '</tr>';

				htmlContents += '</tbody>';
				htmlContents += '</table>';

				$('#userconnectionstatus').html(htmlContents);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 현황 조회", "사용자 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="ui-layout-north zero-padding">
	<div class="pane-header">사용자 현황</div>
	<div class="ui-layout-content zero-padding">
		<div id="userconnectionstatus"></div>
	</div>
</div>
