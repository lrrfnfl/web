<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objTabDaily;
	var g_objTabMonthly;

	var g_columnChartData = null;
	var g_columnChartOptions = null;
	var g_columnChart = null;

	var g_selectedTabIndex = TAB_DAILY;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	google.load("visualization", "1", {packages:["corechart"]});

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objTabDaily = $('#tab-daily');
		g_objTabMonthly = $('#tab-monthly');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearchDaily"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnSearchMonthly"]').button({ icons: {primary: "ui-icon-search"} });

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
			}
		});

		g_objTabDaily.find('#searchdailydateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				var selectSearchDateFrom = new Date(selectedDate);
				selectSearchDateFrom.addDate("d", -6);
				g_objTabDaily.find('#searchdailydatefrom').datepicker('setDate', selectSearchDateFrom);
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
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
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
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') != "company_category") {
					if (data.rslt.obj.attr('node_type') == "company") {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						$('.inner-center .pane-header').text('사업장 반출 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
<% } else { %>
						$('.inner-center .pane-header').text('전체 반출 현황');
<% } %>
					} else if (data.rslt.obj.attr('node_type') == "dept") {
						$('.inner-center .pane-header').text('부서 반출 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else if (data.rslt.obj.attr('node_type') == "user") {
						$('.inner-center .pane-header').text('사용자 반출 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else {
						$('.inner-center .pane-header').text('전체 사업장 반출 현황');
					}

					loadStatisticsData();
				}
			}
		});
	};

	loadStatisticsData = function() {

		var termType = "";
		var searchDateFrom;
		var searchDateTo;

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

		var postData = getRequestSafeExportStatusPerTermsParam(targetCompanyId,
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
					displayAlertDialog("기간별 반출 현황 조회", "기간별 반출 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$(".inline-search-condition").show();
				$(".tab-content").show();

				loadColumnChart($(data));
				loadColumnChartTable($(data));
				reloadDefaultLayout();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("기간별 반출 현황 조회", "기간별 반출 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadColumnChart = function(responseData) {

		g_columnChartData = new google.visualization.DataTable();

		if (g_selectedTabIndex == TAB_DAILY)
			g_columnChartData.addColumn('string', '년-월-일');
		else if (g_selectedTabIndex == TAB_MONTHLY)
			g_columnChartData.addColumn('string', '년-월');
		g_columnChartData.addColumn('number', '반출 요청 수');
		g_columnChartData.addColumn('number', '복호화 요청 수');

		g_columnChartData.addRows(responseData.find("record").length);

		var i = 0;
		responseData.find('record').each( function() {
			var date = $(this).find('date').text();
			var exportCount = parseInt($(this).find('exportcount').text());
			var decodedCount = parseInt($(this).find('decodedcount').text());

			g_columnChartData.setCell(i, 0, date);
			g_columnChartData.setCell(i, 1, exportCount);
			g_columnChartData.setCell(i, 2, decodedCount);

			i++;
		});

		g_columnChartOptions = { backgroundColor: { fill:'#fff' },
			chartArea:{top:10, width:"50%", height:"90%"}
		};

		if (g_selectedTabIndex == TAB_DAILY) {
			g_columnChart = new google.visualization.BarChart(document.getElementById('daily-column-chart'));
		} else if (g_selectedTabIndex == TAB_MONTHLY) {
			g_columnChart = new google.visualization.BarChart(document.getElementById('monthly-column-chart'));
		}

		drawColumnChart();
	};

	drawColumnChart = function() {
		g_columnChart.draw(g_columnChartData, g_columnChartOptions);
	};

	loadColumnChartTable = function(responseData) {

		var htmlContents = '';

		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		if (g_selectedTabIndex == TAB_DAILY)
			htmlContents += '<th class="ui-state-default">반출일자</th>';
		else if (g_selectedTabIndex == TAB_MONTHLY)
			htmlContents += '<th class="ui-state-default">반출년월</th>';
		htmlContents += '<th class="ui-state-default">반출 요청 수</th>';
		htmlContents += '<th class="ui-state-default">복호화 요청 수</th>';
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
			var exportCount = parseInt($(this).find('exportcount').text());
			var decodedCount = parseInt($(this).find('decodedcount').text());

			htmlContents += '<tr class="' + lineStyle + '">';
			htmlContents += '<td style="text-align: center;">' + date + '</td>';
			htmlContents += '<td style="text-align: right;">' + exportCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '<td style="text-align: right;">' + decodedCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
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
	<div class="pane-header">전체 사업장 반출 현황</div>
	<ul>
		<li><a href="#tab-daily">일별 반출 현황</a></li>
		<li><a href="#tab-monthly">월별 반출 현황</a></li>
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
			<div class="tab-content" style="display: none;">
				<div class="sub-category-title">일별 반출 현황</div>
				<div class="sub-category-contents">
					<div style="float: left; width: 50%;">
						<div id="daily-column-chart" class="ui-widget-content chart" style="padding: 10px 0; width: 100%; height: auto;"></div>
					</div>
					<div style="margin-left: 51%;">
						<div id="daily-column-chart-table"></div>
					</div>
					<div class="clear"></div>
				</div>
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
			<div class="tab-content" style="display: none;">
				<div class="sub-category-title">월별 반출 현황</div>
				<div class="sub-category-contents">
					<div style="float: left; width: 50%;">
						<div id="monthly-column-chart" class="ui-widget-content chart" style="padding: 10px 0; width: 100%; height: auto;"></div>
					</div>
					<div style="margin-left: 51%;">
						<div id="monthly-column-chart-table"></div>
					</div>
					<div class="clear"></div>
				</div>
			</div>
		</div>
	</div>
</div>
