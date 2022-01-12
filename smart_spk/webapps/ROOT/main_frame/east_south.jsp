<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var TAB_TODAY = 0;
	var TAB_WEEK = 1;
	var TAB_MONTH = 2;

	$(document).ready(function() {
		$('#tab-eastsouth').tabs({
			activate: function( event, ui ) {
				loadEastSouthListData(ui.newTab.index());
			}
		});

		loadEastSouthListData(TAB_TODAY);
	});

	function loadEastSouthListData(selectedTab) {

		var searchDateFrom = new Date();
		var searchDateTo = new Date();

		if (selectedTab == TAB_WEEK) {
			searchDateFrom.addDate("d", -6);
		} else if (selectedTab == TAB_MONTH) {
			searchDateFrom.addDate("m", -5);
		}

		var postData = getRequestDetectStatusPerDeptListParam('<%=(String)session.getAttribute("COMPANYID")%>',
			'',
			searchDateFrom.formatString("yyyy-MM-dd"),
			searchDateTo.formatString("yyyy-MM-dd"),
			'DETECTFILECOUNT',
			'DESC',
			'10',
			'1');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-eastsouth .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('#tab-eastsouth .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {

				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 검출 파일 순위 조회", "부서 검출 파일 순위 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="40" class="ui-widget-header ui-state-default">순위</th>';
				htmlContents += '<th class="ui-widget-header ui-state-default">부서</th>';
				htmlContents += '<th width="60" class="ui-widget-header ui-state-default">사용자수</th>';
				htmlContents += '<th width="70" class="ui-widget-header ui-state-default">검출 파일수</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var recordCount = 1;
				var lineStyle;
				$(data).find('record').each(function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					var deptName = $(this).find('deptname').text();
					var userCount = $(this).find('usercount').text();
					var detectFileCount = $(this).find('detectfilecount').text();

					htmlContents += '<tr class="' + lineStyle + '">';
					htmlContents += '<td style="text-align: center;">' + recordCount + '</td>';
					htmlContents += '<td title="' + deptName + '">' + deptName + '</td>';
					if ((userCount != null) && (userCount.length > 0)) {
						htmlContents += '<td style="text-align: right;">' + userCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
					} else {
						htmlContents += '<td>&nbsp;</td>';
					}
					if ((detectFileCount != null) && (detectFileCount.length > 0)) {
						htmlContents += '<td style="text-align: right;">' + detectFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
					} else {
						htmlContents += '<td>&nbsp;</td>';
					}
					htmlContents += '</tr>';

					recordCount++;
				});

				htmlContents += '</tbody>';
				htmlContents += '</table>';

				if (selectedTab == TAB_TODAY) {
					$('#list-today-deptdetectranking').html(htmlContents);
				} else if (selectedTab == TAB_WEEK) {
					$('#list-week-deptdetectranking').html(htmlContents);
				} else if (selectedTab == TAB_MONTH) {
					$('#list-month-deptdetectranking').html(htmlContents);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 검출 파일 순위 조회", "부서 검출 파일 순위 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="ui-layout-south zero-padding">
	<div class="pane-header">부서 검출 파일 순위</div>
	<div class="ui-layout-content zero-padding">
		<div id="tab-eastsouth" class="styles-tab border-none">
			<ul>
				<li><a href="#tab-eastsouth-1">오늘</a></li>
				<li><a href="#tab-eastsouth-2">최근 1주일</a></li>
				<li><a href="#tab-eastsouth-3">최근 1개월</a></li>
			</ul>
			<div id="tab-eastsouth-1" style="padding: 5px 0;">
				<div id="list-today-deptdetectranking"></div>
			</div>
			<div id="tab-eastsouth-2" style="padding: 5px 0;">
				<div id="list-week-deptdetectranking"></div>
			</div>
			<div id="tab-eastsouth-3" style="padding: 5px 0;">
				<div id="list-month-deptdetectranking"></div>
			</div>
		</div>
	</div>
</div>
