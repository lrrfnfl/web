<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_htFileTypeList = new Hashtable();

	var g_centerSouthChart = null;

	$(document).ready(function() {
		g_htFileTypeList = loadTypeList("FILE_TYPE");
		if (g_htFileTypeList.isEmpty()) {
			displayAlertDialog("파일 유형 조회", "파일 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		$('#tab-centersouth').tabs({
			heightStyle: "auto",
			activate: function( event, ui ) {
				loadCenterSouthChartData(ui.newTab.index());
			}
		});

		loadCenterSouthChartData(TAB_TODAY);
	});

	loadCenterSouthChartData = function(selectedTab) {

		var companyId = "";
<% if (AdminType.ADMIN_TYPE_COMPANY_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		companyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var searchDateFrom = new Date();
		var searchDateTo = new Date();
		if (selectedTab == TAB_WEEK) {
			searchDateFrom.addDate("d", -6);
		} else if (selectedTab == TAB_MONTH) {
			searchDateFrom.addDate("m", -5);
		}

		var postData = getRequestFileTypeDetectStatusPerOrganizationParam(companyId,
			'',
			'',
			'',
			searchDateFrom.formatString("yyyy-MM-dd"),
			searchDateTo.formatString("yyyy-MM-dd"));

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-centersouth .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('#tab-centersouth .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("파일 유형 검출 현황 조회", "파일 유형 검출 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				loadCenterSouthChart(selectedTab, $(data));

// 				g_centerSouthChartData = new google.visualization.DataTable();
// 				g_centerSouthChartData.addColumn('string', '파일유형');
// 				g_centerSouthChartData.addColumn('number', '검출건수');

// 				g_centerSouthChartData.addRows($(data).find("record").length);

// 				var i = 0;
// 				$(data).find('record').each(function() {
// 					var fileType = $(this).find('filetype').text();
// 					var detectKeywordCount = parseInt($(this).find('detectkeywordcount').text());

// 					g_centerSouthChartData.setCell(i, 0, g_htFileTypeList.get(fileType));
// 					g_centerSouthChartData.setCell(i, 1, detectKeywordCount);

// 					i++;
// 				});

// 				if (selectedTab == TAB_TODAY) {
// 					g_centerSouthChartOptions = {	title: '파일 유형 검출 현황(오늘)',
// 						chartArea:{top: 40, left: 40}
// 					};
// 					g_centerSouthChart = new google.visualization.PieChart(document.getElementById('chart-today-detectstatusperfiletype'));
// 				} else if (selectedTab == TAB_WEEK) {
// 					g_centerSouthChartOptions = {	title: '파일 유형 검출 현황(최근 1주일)',
// 						chartArea:{top: 40, left: 40}
// 					};
// 					g_centerSouthChart = new google.visualization.PieChart(document.getElementById('chart-week-detectstatusperfiletype'));
// 				} else if (selectedTab == TAB_MONTH) {
// 					g_centerSouthChartOptions = {	title: '파일 유형 검출 현황(최근 1개월)',
// 						chartArea:{top: 40, left: 40}
// 					};
// 					g_centerSouthChart = new google.visualization.PieChart(document.getElementById('chart-month-detectstatusperfiletype'));
// 				}
// 				drawDetectFileTypeStatusPerOrganizationChart();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("파일 유형 검출 현황 조회", "파일 유형 검출 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	var randomScalingFactor = function() {
		return Math.round(Math.random() * 100);
	};

	dynamicColors = function() {
		var r = Math.floor(Math.random() * 255);
		var g = Math.floor(Math.random() * 255);
		var b = Math.floor(Math.random() * 255);
		return "rgb(" + r + "," + g + "," + b + ")";
	};

	loadCenterSouthChart = function(selectedTab, responseData) {

		var arrlabel = [];
		var arrData = [];
		var arrBackgroundColor = [];
		responseData.find('record').each( function(index) {
			arrlabel.push(g_htFileTypeList.get($(this).find('filetype').text()));
			arrData.push($(this).find('detectkeywordcount').text());
			arrBackgroundColor.push(dynamicColors());
		});

		var chartData = {
			labels: arrlabel,
			datasets: [{
				label: 'Dataset 1',
				data: arrData,
				backgroundColor: arrBackgroundColor,
				borderColor: 'rgba(255, 255, 255, 1)',
				borderWidth: 1,
				bevelWidth: 3,
				bevelHighlightColor: 'rgba(255, 255, 255, 0.75)',
				bevelShadowColor: 'rgba(0, 0, 0, 0.5)',
				shadowOffsetX: 3,
				shadowOffsetY: 3,
				shadowBlur: 10,
				shadowColor: 'rgba(0, 0, 0, 0.55)'
			}]
		};

		var ctx;
		var titleText;
		if (selectedTab == TAB_TODAY) {
			ctx = document.getElementById('chart-centersouth-1').getContext('2d');
			titleText = "파일 유형 검출 현황(오늘)";
		} else if (selectedTab == TAB_WEEK) {
			ctx = document.getElementById('chart-centersouth-2').getContext('2d');
			titleText = "파일 유형 검출 현황(최근 1주일)";
		} else if (selectedTab == TAB_MONTH) {
			ctx = document.getElementById('chart-centersouth-3').getContext('2d');
			titleText = "파일 유형 검출 현황(최근 1개월)";
		}

		if (g_centerSouthChart != null) g_centerSouthChart.destroy();

		g_centerSouthChart = new Chart(ctx, {
			type: 'doughnut',
			data: chartData,
			options: {
				elements: {
					rectangle: {
						borderWidth: 10,
					}
				},
				responsive: true,
 				maintainAspectRatio: false,
				title: {
					display: true,
					text: titleText
				},
				legend: {
					position: 'right',
					display: true
				},
				tooltips: {
					mode: 'index',
					intersect: false,
				},
				hover: {
					mode: 'nearest',
					intersect: true
				},
				layout: {
					padding: {
						left: 20,
						right: 20,
						top: 10,
						bottom: 10
					}
				}
			}
		});
	};
//-->
</script>

<div class="ui-layout-south zero-padding">
	<div class="pane-header">파일 유형 검출 현황</div>
	<div class="ui-layout-content zero-padding">
		<div id="tab-centersouth" class="styles-tab border-none">
			<ul>
				<li><a href="#tab-centersouth-1">오늘</a></li>
				<li><a href="#tab-centersouth-2">최근 1주일</a></li>
				<li><a href="#tab-centersouth-3">최근 1개월</a></li>
			</ul>
			<div id="tab-centersouth-1">
				<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="chart-centersouth-1"></canvas></div>
			</div>
			<div id="tab-centersouth-2">
				<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="chart-centersouth-2"></canvas></div>
			</div>
			<div id="tab-centersouth-3">
				<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="chart-centersouth-3"></canvas></div>
			</div>
		</div>
	</div>
</div>
