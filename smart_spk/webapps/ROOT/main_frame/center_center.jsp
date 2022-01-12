<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_centerCenterChart = null;

	$(document).ready( function() {
		$('#tab-centercenter').tabs({
			heightStyle: "auto",
			activate: function(event, ui) {
				loadCenterCenterChartData(ui.newTab.index());
			}
		});

		loadCenterCenterChartData(TAB_DAILY);
	});

	loadCenterCenterChartData = function(selectedTab) {

		var companyId = "";
<% if (AdminType.ADMIN_TYPE_COMPANY_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		companyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var searchTermType = "";
		var searchDateFrom = new Date();
		var searchDateTo = new Date();
		var searchDateFromString = "";
		var searchDateToString = "";
		if (selectedTab == TAB_DAILY) {
			searchTermType = "DAY";
			searchDateFrom.addDate("d", -6);
		} else if (selectedTab == TAB_MONTHLY) {
			searchTermType = "MONTH";
			searchDateFrom.addDate("m", -5);
		}

		if (selectedTab == TAB_DAILY) {
			searchDateFromString = searchDateFrom.formatString("yyyy-MM-dd");
			searchDateToString = searchDateTo.formatString("yyyy-MM-dd");
		} else if (selectedTab == TAB_MONTHLY) {
			var firstDay = new Date(searchDateFrom.getFullYear(), searchDateFrom.getMonth(), 1);
			var lastDay = new Date(searchDateTo.getFullYear(), searchDateTo.getMonth() + 1, 0);
			searchDateFromString = firstDay.formatString("yyyy-MM-dd");
			searchDateToString = lastDay.formatString("yyyy-MM-dd");
		}

		var postData = getRequestDetectStatusPerTermsParam(companyId,
				'',
				'',
				searchTermType,
				searchDateFromString,
				searchDateToString);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-centercenter .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('#tab-centercenter .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {

				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("검출 현황 조회", "검출 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				loadCenterCenterChart(selectedTab, $(data));
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("검출 현황 조회", "검출 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	var randomScalingFactor = function() {
		return Math.round(Math.random() * 100);
	};

	loadCenterCenterChart = function(selectedTab, responseData) {

		var arrlabel = [];
		var arrForceSearchCount = [];
		var arrRealtimeSearchCount = [];
		var arrNormalSearchCount = [];
		var arrFastSearchCount = [];
		var arrReserveSearchCount = [];

		responseData.find('record').each( function(index) {
			arrlabel.push($(this).find('date').text());
			arrForceSearchCount.push(parseInt($(this).find('forcesearchcount').text()));
			arrRealtimeSearchCount.push(parseInt($(this).find('realtimesearchcount').text()));
			arrNormalSearchCount.push(parseInt($(this).find('normalsearchcount').text()));
			arrFastSearchCount.push(parseInt($(this).find('fastsearchcount').text()));
			arrReserveSearchCount.push(parseInt($(this).find('reservesearchcount').text()));
		});

		var chartData = {
			labels: arrlabel,
			datasets: [{
				label: '강제검사',
				data: arrForceSearchCount,
// 				data: [
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor()
// 				],
				backgroundColor: 'rgba(204, 0, 0, 0.6)',
				borderColor: 'rgba(204, 0, 0, 0.6)',
				borderWidth: 1,
				bevelWidth: 3,
				bevelHighlightColor: 'rgba(255, 255, 255, 0.75)',
				bevelShadowColor: 'rgba(0, 0, 0, 0.5)',
				shadowOffsetX: 3,
				shadowOffsetY: 3,
				shadowBlur: 10,
				shadowColor: 'rgba(0, 0, 0, 0.55)'
			}, {
				label: '실시간검사',
				data: arrRealtimeSearchCount,
// 				data: [
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor()
// 				],
				backgroundColor: 'rgba(54, 162, 235, 0.6)',
				borderColor: 'rgba(54, 162, 235, 0.6)',
				borderWidth: 1,
				bevelWidth: 3,
				bevelHighlightColor: 'rgba(255, 255, 255, 0.75)',
				bevelShadowColor: 'rgba(0, 0, 0, 0.5)',
				shadowOffsetX: 3,
				shadowOffsetY: 3,
				shadowBlur: 10,
				shadowColor: 'rgba(0, 0, 0, 0.55)'
			}, {
				label: '일반검사',
				data: arrNormalSearchCount,
// 				data: [
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor()
// 				],
				backgroundColor: 'rgba(65, 105, 225, 0.6)',
				borderColor: 'rgba(65, 105, 225, 0.6)',
				borderWidth: 1,
				bevelWidth: 3,
				bevelHighlightColor: 'rgba(255, 255, 255, 0.75)',
				bevelShadowColor: 'rgba(0, 0, 0, 0.5)',
				shadowOffsetX: 3,
				shadowOffsetY: 3,
				shadowBlur: 10,
				shadowColor: 'rgba(0, 0, 0, 0.55)'
			}, {
				label: '빠른검사',
				data: arrFastSearchCount,
// 				data: [
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor()
// 				],
				backgroundColor: 'rgba(255, 140, 0, 0.6)',
				borderColor: 'rgba(255, 140, 0, 0.6)',
				borderWidth: 1,
				bevelWidth: 3,
				bevelHighlightColor: 'rgba(255, 255, 255, 0.75)',
				bevelShadowColor: 'rgba(0, 0, 0, 0.5)',
				shadowOffsetX: 3,
				shadowOffsetY: 3,
				shadowBlur: 10,
				shadowColor: 'rgba(0, 0, 0, 0.55)'
			}, {
				label: '예약검사',
				data: arrReserveSearchCount,
// 				data: [
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor(),
// 						randomScalingFactor()
// 				],
				backgroundColor: 'rgba(153, 051, 153, 0.6)',
				borderColor: 'rgba(153, 051, 153, 0.6)',
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
		if (selectedTab == TAB_DAILY) {
			ctx = document.getElementById('chart-centercenter-tab1').getContext('2d');
			titleText = "검출 현황(최근 1주일)";
		} else if (selectedTab == TAB_MONTHLY) {
			ctx = document.getElementById('chart-centercenter-tab2').getContext('2d');
			titleText = "검출 현황(최근 6개월)";
		}

		if (g_centerCenterChart != null) g_centerCenterChart.destroy();

		g_centerCenterChart = new Chart(ctx, {
			type: 'bar',
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
					position: 'top',
					display: false
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
				},
				scales: {
					xAxes: [{
						display: true,
						scaleLabel: {
							display: false
						},
						barPercentage: 0.8
					}],
					yAxes: [{
						display: true,
						scaleLabel: {
							display: false
						},
						barPercentage: 0.8
					}]
				}
			}
		});
	};
//-->
</script>

<div class="ui-layout-center zero-padding">
	<div class="pane-header">기간별 검출 현황</div>
	<div class="ui-layout-content zero-padding">
		<div id="tab-centercenter" class="styles-tab border-none">
			<ul>
				<li><a href="#tab-centercenter-1">일별 검출 현황</a></li>
				<li><a href="#tab-centercenter-2">월별 검출 현황</a></li>
			</ul>
			<div id="tab-centercenter-1">
				<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="chart-centercenter-tab1"></canvas></div>
			</div>
			<div id="tab-centercenter-2">
				<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="chart-centercenter-tab2"></canvas></div>
			</div>
		</div>
	</div>
</div>
