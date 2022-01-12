<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objTabDaily;
	var g_objTabMonthly;

	var g_columnChart = null;
	var g_doughnutChart = null;

	var g_selectedTabIndex = TAB_DAILY;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objTabDaily = $('#tab-daily');
		g_objTabMonthly = $('#tab-monthly');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearchDaily"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnSearchMonthly"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		g_objTabDaily.find('#searchdailydatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				var selectSearchDateTo = new Date(selectedDate);
				selectSearchDateTo.addDate("d", 6);
				if (selectSearchDateTo.getTime() > new Date().getTime()) {
					selectSearchDateTo = new Date();
				}
				g_objTabDaily.find('#searchdailydateto').datepicker('setDate', selectSearchDateTo);
				$('button[name="btnDownload"]').hide();
			}
		});

		g_objTabDaily.find('#searchdailydateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				var selectSearchDateFrom = new Date(selectedDate);
				selectSearchDateFrom.addDate("d", -6);
				g_objTabDaily.find('#searchdailydatefrom').datepicker('setDate', selectSearchDateFrom);
				$('button[name="btnDownload"]').hide();
			}
		});

		var tmpDate = new Date();
		tmpDate.addDate("d", -6);
		g_objTabDaily.find('#searchdailydatefrom').datepicker('setDate', tmpDate);
		g_objTabDaily.find('#searchdailydateto').datepicker('setDate', new Date());

		g_objTabMonthly.find('#searchmonthlydatefrom').MonthPicker({
			Button: false,
			MonthFormat: 'yy-mm',
			MaxMonth: 0,
			SelectedMonth: '-5m',
			IsRTL: false,
			i18n: {
				year: '선택연도',
				prevYear: '이전',
				nextYear: '다음',
				next12Years: '다음',
				prev12Years: '이전',
				nextLabel: '다음',  
				prevLabel: '이전',
				jumpYears: '연도 선택',
				backTo: '되돌아가기',
				months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
			},
			OnAfterChooseMonth: function(selectedDate) {
				var selectSearchDateTo = new Date(selectedDate);
				selectSearchDateTo.addDate("m", 5);
				if (selectSearchDateTo.getTime() > new Date().getTime()) {
					selectSearchDateTo = new Date();
				}
				g_objTabMonthly.find('#searchmonthlydateto').MonthPicker('option', 'SelectedMonth', selectSearchDateTo);
				$('button[name="btnDownload"]').hide();
			}
		});

		g_objTabMonthly.find('#searchmonthlydateto').MonthPicker({
			Button: false,
			MonthFormat: 'yy-mm',
			MaxMonth: 0,
			SelectedMonth: 0,
			IsRTL: false,
			i18n: {
				year: '선택연도',
				prevYear: '이전',
				nextYear: '다음',
				next12Years: '다음',
				prev12Years: '이전',
				nextLabel: '다음',  
				prevLabel: '이전',
				jumpYears: '연도 선택',
				backTo: '되돌아가기',
				months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
			},
			OnAfterChooseMonth: function(selectedDate) {
				var selectSearchDateFrom = new Date(selectedDate);
				selectSearchDateFrom.addDate("m", -5);
				g_objTabMonthly.find('#searchmonthlydatefrom').MonthPicker('option', 'SelectedMonth', selectSearchDateFrom);
				$('button[name="btnDownload"]').hide();
			}
		});

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearchDaily') {
				loadStatisticsData();
			} else if ($(this).attr('id') == 'btnSearchMonthly') {
				loadStatisticsData();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadStatisticsData();
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
			if ($(this).is(":checked")) {
				var objTreeReference = $.jstree._reference(g_objOrganizationTree);
				if (objTreeReference.get_selected().attr('node_type') == "dept") {
					objTreeReference.open_all(objTreeReference.get_selected());
				}
			}
			loadStatisticsData();
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
	});

	loadCompanyNode = function(companyId) {

		var nodeData = ""; 
		var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', companyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					var startTag = "<root>";
					var endTag = "</root>";
					nodeData = new XMLSerializer().serializeToString(data);
					nodeData = nodeData.substr(nodeData.indexOf(startTag), nodeData.lastIndexOf(endTag)-nodeData.indexOf(startTag)+endTag.length);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return nodeData;
	};

	loadOrganizationTreeView = function() {

		var xmlTreeData = '';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		xmlTreeData += '<root>';
		xmlTreeData += '<item id="root" node_type="root" state="closed">';
		xmlTreeData += '<content><name><![CDATA[전체 사업장]]></name></content>';
		xmlTreeData += '</item>';
		xmlTreeData += '</root>';
<% } else { %>
		xmlTreeData = loadCompanyNode('<%=(String)session.getAttribute("COMPANYID")%>');
<% } %>

		g_objOrganizationTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = '<%=OptionType.OPTION_TYPE_YES%>';
							if (node.attr("node_type") == 'company_category') {
								var categoryCode = node.children('a').text().trim();
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', categoryCode, '');
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'company') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), '', includeUserNodes);
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'dept') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), node.attr('deptcode'), includeUserNodes);
								return {
									sendmsg : postData
								};
							} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', '');
<% } else { %>
								var postData = getRequestDeptTreeNodesParam('<%=(String)session.getAttribute("COMPANYID")%>', '', includeUserNodes);
<% } %>
								return {
									sendmsg : postData
								};
							}
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
						}
					}
				}
			},
			"themes": {
				"theme": "<%=(String)session.getAttribute("THEMENAME")%>",
				"dots": true,
				"icons": false
			},
			"ui": {
				"select_limit": 1,
				"select_multiple_modifier": "none"
			},
			"types": {
				"AM": {
					"hover_node": false,
					"select_node": false
				},
				"AF": {
					"hover_node": false,
					"select_node": false
				},
				"Role": {
				// i dont know if possible to be done here? add class?
				// this.css("color", "red")
				//{ font-weight:bold}
				}
			},
			"contextmenu" : {
				"items" : null
			},
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('load_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if (($(this).attr('node_type') == "company") || ($(this).attr('node_type') == "user")) {
					if ($(this).attr('servicestate') == <%=ServiceState.SERVICE_STATE_STOP%>) {
						if (!$(this).find('a').first().hasClass('state-abnormal')) {
							$(this).find('a').first().addClass('state-abnormal');
						}
					} else {
						if (!$(this).find('a').first().hasClass('state-abnormal')) {
							$(this).find('a').first().removeClass('state-abnormal');
						}
					}
				}
			});
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if ($('input[name="includechilddept"]:checkbox').is(":checked")) {
				if (data.rslt.obj.attr('node_type') == "dept") {
					data.inst.open_all(data.rslt.obj);
				}
			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') != "company_category") {
					if (data.rslt.obj.attr('node_type') == "company") {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						$('.inner-center .pane-header').text('사업장 검사 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
<% } else { %>
						$('.inner-center .pane-header').text('전체 검사 현황');
<% } %>
					} else if (data.rslt.obj.attr('node_type') == "dept") {
						$('.inner-center .pane-header').text('부서 검사 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else if (data.rslt.obj.attr('node_type') == "user") {
						$('.inner-center .pane-header').text('사용자 검사 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else {
						$('.inner-center .pane-header').text('전체 사업장 검사 현황');
					}

					loadStatisticsData();
				}
			}
		});
	};

	loadStatisticsData = function() {

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		var targetCompanyId = ""; 
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var arrTargetDeptList = new Array();
		if (objTreeReference.get_selected().attr('node_type') == "dept") {
			arrTargetDeptList.push(objTreeReference.get_selected().attr('deptcode'));
			if ($('input:checkbox[name="includechilddept"]').is(':checked') == true) {
				objTreeReference.get_selected().find("li").each( function(idx, listItem) {
					if ($(this).attr('node_type') == 'dept') {
						arrTargetDeptList.push($(this).attr('deptcode'));
					}
				});
			}
		} else if (objTreeReference.get_selected().attr('node_type') == "user") {
			arrTargetDeptList.push(objTreeReference.get_selected().attr('deptcode'));
		}

		var targetUserId = "";
		if (typeof objTreeReference.get_selected().attr('userid') != typeof undefined) {
			targetUserId = objTreeReference.get_selected().attr('userid');
		}

		var termType = "";
		var searchDateFrom;
		var searchDateTo;
		if (g_selectedTabIndex == TAB_DAILY) {
			termType = "DAY";
			searchDateFrom = new Date(g_objTabDaily.find('#searchdailydatefrom').datepicker('getDate'));
			searchDateTo = new Date(g_objTabDaily.find('#searchdailydateto').datepicker('getDate'));
			if (searchDateTo.diffDays(searchDateFrom, "d") >= 7) {
				displayAlertDialog("기간 선택 오류", "일별 조회 기간은 7일을 초과할 수 없습니다.", null);
				return false;
			}
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			termType = "MONTH";
			searchDateFrom = new Date(g_objTabMonthly.find('#searchmonthlydatefrom').MonthPicker('GetSelectedDate'));
			searchDateTo = new Date(g_objTabMonthly.find('#searchmonthlydateto').MonthPicker('GetSelectedDate'));
			searchDateTo = new Date(searchDateTo.getFullYear(), searchDateTo.getMonth() + 1, 0);
			if (searchDateTo.diffDays(searchDateFrom, "m") >= 6) {
				displayAlertDialog("기간 선택 오류", "월별 조회 기간은 6개월을 초과할 수 없습니다.", null);
				return false;
			}
		}

		var postData = getRequestSearchStatusPerTermsParam(targetCompanyId,
			arrTargetDeptList,
			targetUserId,
			termType,
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
				$('#tab-main .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('#tab-main .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("기간별 검사 현황 조회", "기간별 검사 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				loadColumnChart($(data));
				loadColumnChartTable($(data));
				loadDoughnutChart($(data));
				loadDoughnutChartTable($(data));

 				$('button[name="btnDownload"]').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("기간별 검사 현황 조회", "기간별 검사 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	var randomScalingFactor = function() {
		return Math.round(Math.random() * 100);
	};

	loadColumnChart = function(responseData) {

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
		if (g_selectedTabIndex == TAB_DAILY) {
			ctx = document.getElementById('daily-column-chart').getContext('2d');
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			ctx = document.getElementById('monthly-column-chart').getContext('2d');
		}

		if (g_columnChart != null) g_columnChart.destroy();

		g_columnChart = new Chart(ctx, {
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
					display: false,
					text: '검사 현황'
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

	loadColumnChartTable = function(responseData) {

		var htmlContents = '';

		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		if (g_selectedTabIndex == TAB_DAILY)
			htmlContents += '<th width="70" class="ui-state-default">검사일자</th>';
		else if (g_selectedTabIndex == TAB_MONTHLY)
			htmlContents += '<th width="70" class="ui-state-default">검사년월</th>';
		htmlContents += '<th class="ui-state-default">강제검사</th>';
		htmlContents += '<th class="ui-state-default">실시간검사</th>';
		htmlContents += '<th class="ui-state-default">일반검사</th>';
		htmlContents += '<th class="ui-state-default">빠른검사</th>';
		htmlContents += '<th class="ui-state-default">예약검사</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		responseData.find('record').each( function(index) {
			var lineStyle = '';
			if (index%2 == 0)
				lineStyle = "list_odd";
			else
				lineStyle = "list_even";

			var date = $(this).find('date').text();
			var forceSearchCount = parseInt($(this).find('forcesearchcount').text());
			var realtimeSearchCount = parseInt($(this).find('realtimesearchcount').text());
			var normalSearchCount = parseInt($(this).find('normalsearchcount').text());
			var fastSearchCount = parseInt($(this).find('fastsearchcount').text());
			var reserveSearchCount = parseInt($(this).find('reservesearchcount').text());

			htmlContents += '<tr class="' + lineStyle + '">';
			htmlContents += '<td style="text-align: center;">' + date + '</td>';
			htmlContents += '<td style="text-align: right;">' + forceSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '<td style="text-align: right;">' + realtimeSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '<td style="text-align: right;">' + normalSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '<td style="text-align: right;">' + fastSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '<td style="text-align: right;">' + reserveSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '</tr>';
		});

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		if (g_selectedTabIndex == TAB_DAILY) {
			$('#daily-column-chart-table').html(htmlContents);
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			$('#monthly-column-chart-table').html(htmlContents);
		}
	};

	loadDoughnutChart = function(responseData) {

		var forceSearchCount = 0;
		var realtimeSearchCount = 0;
		var normalSearchCount = 0;
		var fastSearchCount = 0;
		var reserveSearchCount = 0;

		responseData.find('record').each( function() {
			forceSearchCount += parseInt($(this).find('forcesearchcount').text());
			realtimeSearchCount += parseInt($(this).find('realtimesearchcount').text());
			normalSearchCount += parseInt($(this).find('normalsearchcount').text());
			fastSearchCount += parseInt($(this).find('fastsearchcount').text());
			reserveSearchCount += parseInt($(this).find('reservesearchcount').text());
		});

		var arrlabel = ["강제검사", "실시간검사", "일반검사", "빠른검사", "예약검사"];
		var arrData = [];
		arrData.push(forceSearchCount.toString());
		arrData.push(realtimeSearchCount.toString());
		arrData.push(normalSearchCount.toString());
		arrData.push(fastSearchCount.toString());
		arrData.push(reserveSearchCount.toString());

		var chartData = {
			labels: arrlabel,
			datasets: [{
				label: '검사 현황',
				data: arrData,
// 				data: [
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 					randomScalingFactor(),
// 				],
				backgroundColor: [
					'rgba(204, 0, 0, 0.6)',
					'rgba(54, 162, 235, 0.6)',
					'rgba(65, 105, 225, 0.6)',
					'rgba(255, 140, 0, 0.6)',
					'rgba(153, 051, 153, 0.6)',
				],
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
		if (g_selectedTabIndex == TAB_DAILY) {
			ctx = document.getElementById('daily-doughnut-chart').getContext('2d');
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			ctx = document.getElementById('monthly-doughnut-chart').getContext('2d');
		}

		if (g_doughnutChart != null) g_doughnutChart.destroy();

		g_doughnutChart = new Chart(ctx, {
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
					display: false,
					text: '검사 현황'
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

	loadDoughnutChartTable = function(responseData) {

		var htmlContents = '';

		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		htmlContents += '<th class="ui-state-default">강제검사</th>';
		htmlContents += '<th class="ui-state-default">실시간검사</th>';
		htmlContents += '<th class="ui-state-default">일반검사</th>';
		htmlContents += '<th class="ui-state-default">빠른검사</th>';
		htmlContents += '<th class="ui-state-default">예약검사</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		var forceSearchCount = 0;
		var realtimeSearchCount = 0;
		var normalSearchCount = 0;
		var fastSearchCount = 0;
		var reserveSearchCount = 0;

		responseData.find('record').each( function() {
			forceSearchCount += parseInt($(this).find('forcesearchcount').text());
			realtimeSearchCount += parseInt($(this).find('realtimesearchcount').text());
			normalSearchCount += parseInt($(this).find('normalsearchcount').text());
			fastSearchCount += parseInt($(this).find('fastsearchcount').text());
			reserveSearchCount += parseInt($(this).find('reservesearchcount').text());
		});

		htmlContents += '<tr class=list-odd">';
		htmlContents += '<td style="text-align: right;">' + forceSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
		htmlContents += '<td style="text-align: right;">' + realtimeSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
		htmlContents += '<td style="text-align: right;">' + normalSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
		htmlContents += '<td style="text-align: right;">' + fastSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
		htmlContents += '<td style="text-align: right;">' + reserveSearchCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
		htmlContents += '</tr>';

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		if (g_selectedTabIndex == TAB_DAILY)
			$('#daily-doughnut-chart-table').html(htmlContents);
		else if (g_selectedTabIndex == TAB_MONTHLY)
			$('#monthly-doughnut-chart-table').html(htmlContents);
	};

	downloadStatisticsData = function() {

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		var targetCompanyId = ""; 
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var arrTargetDeptList = new Array();
		if (objTreeReference.get_selected().attr('node_type') == "dept") {
			arrTargetDeptList.push(objTreeReference.get_selected().attr('deptcode'));
			if ($('input:checkbox[name="includechilddept"]').is(':checked') == true) {
				objTreeReference.get_selected().find("li").each( function(idx, listItem) {
					if ($(this).attr('node_type') == 'dept') {
						arrTargetDeptList.push($(this).attr('deptcode'));
					}
				});
			}
		} else if (objTreeReference.get_selected().attr('node_type') == "user") {
			arrTargetDeptList.push(objTreeReference.get_selected().attr('deptcode'));
		}

		var targetUserId = "";
		if (typeof objTreeReference.get_selected().attr('userid') != typeof undefined) {
			targetUserId = objTreeReference.get_selected().attr('userid');
		}

		var termType = "";
		var searchDateFrom;
		var searchDateTo;
		if (g_selectedTabIndex == TAB_DAILY) {
			termType = "DAY";
			searchDateFrom = new Date(g_objTabDaily.find('#searchdailydatefrom').datepicker('getDate'));
			searchDateTo = new Date(g_objTabDaily.find('#searchdailydateto').datepicker('getDate'));
			if (searchDateTo.diffDays(searchDateFrom, "d") >= 7) {
				displayAlertDialog("기간 선택 오류", "일별 조회 기간은 7일을 초과할 수 없습니다.", null);
				return false;
			}
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			termType = "MONTH";
			searchDateFrom = new Date(g_objTabMonthly.find('#searchmonthlydatefrom').MonthPicker('GetSelectedDate'));
			searchDateTo = new Date(g_objTabMonthly.find('#searchmonthlydateto').MonthPicker('GetSelectedDate'));
			searchDateTo = new Date(searchDateTo.getFullYear(), searchDateTo.getMonth() + 1, 0);
			if (searchDateTo.diffDays(searchDateFrom, "m") >= 6) {
				displayAlertDialog("기간 선택 오류", "월별 조회 기간은 6개월을 초과할 수 없습니다.", null);
				return false;
			}
		}

		var postData = getRequestCreateSearchStatusPerTermsFileParam(targetCompanyId,
			arrTargetDeptList,
			targetUserId,
			termType,
			searchDateFrom.formatString("yyyy-MM-dd"),
			searchDateTo.formatString("yyyy-MM-dd"));

		var downloadFileName = "";
		if (g_selectedTabIndex == TAB_DAILY) {
			downloadFileName += "일별 검사 현황";
			downloadFileName += " (" + searchDateFrom.formatString("yyyy-MM-dd") + "~" + searchDateTo.formatString("yyyy-MM-dd") + ")";
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			downloadFileName += "월별 검사 현황";
			downloadFileName += " (" + searchDateFrom.formatString("yyyy-MM") + "~" + searchDateTo.formatString("yyyy-MM") + ")";
		}

		openDownloadDialog("검사 현황", downloadFileName, postData);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">
		<div style="float: left;">조직 구성도</div>
		<div style="float: right; font-weight: normal;"><input type="checkbox" id="includechilddept" name="includechilddept" style="vertical-align: middle; width: 12px; height: 12px;"/><label for="includechilddept"> 하위부서 포함</label></div>
		<div class="clear"></div>
	</div>
	<div class="ui-layout-content zero-padding">
		<div id="organization-tree" class="treeview-pannel"></div>
	</div>
</div>
<div id="tab-main" class="inner-center styles-tab">
	<div class="pane-header">전체 사업장 검사 현황</div>
	<ul>
		<li><a href="#tab-daily">일별 검사 현황</a></li>
		<li><a href="#tab-monthly">월별 검사 현황</a></li>
	</ul>
	<div class="ui-layout-content">
		<div id="tab-daily" class="zero-padding">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchdailydatefrom" name="searchdailydatefrom" class="text ui-widget-content input-date" readonly="readonly" />
				~<input type="text" id="searchdailydateto" name="searchdailydateto" class="text ui-widget-content input-date" readonly="readonly" />
				<span class="search-button">
					<button type="button" id="btnSearchDaily" name="btnSearchDaily" class="small-button">조 회</button>
				</span>
			</div>
			<div class="clear"></div>
			<div class="sub-category-contents">
				<div style="float: left; width: 50%;">
					<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="daily-column-chart"></canvas></div>
				</div>
				<div style="margin-left: 51%;">
					<div id="daily-column-chart-table"></div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="sub-category-contents" style="margin-top: 15px;">
				<div style="float: left; width: 50%;">
					<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="daily-doughnut-chart"></canvas></div>
				</div>
				<div style="margin-left: 51%;">
					<div id="daily-doughnut-chart-table"></div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div id="tab-monthly" class="zero-padding">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchmonthlydatefrom" name="searchmonthlydatefrom" class="text ui-widget-content input-month" readonly="readonly" />
				~<input type="text" id="searchmonthlydateto" name="searchmonthlydateto" class="text ui-widget-content input-month" readonly="readonly" />
				<span class="search-button">
					<button type="button" id="btnSearchMonthly" name="btnSearchMonthly" class="small-button">조 회</button>
				</span>
			</div>
			<div class="clear"></div>
			<div class="sub-category-contents">
				<div style="float: left; width: 50%;">
					<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="monthly-column-chart"></canvas></div>
				</div>
				<div style="margin-left: 51%;">
					<div id="monthly-column-chart-table"></div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="sub-category-contents" style="margin-top: 15px;">
				<div style="float: left; width: 50%;">
					<div class="chart-container" style="width: 100%; height: 240px;"><canvas id="monthly-doughnut-chart"></canvas></div>
				</div>
				<div style="margin-left: 51%;">
					<div id="monthly-doughnut-chart-table"></div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">목록 다운로드</button>
		</div>
	</div>
</div>
