<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objMainContent;

	var g_htInstallStateList = new Hashtable();

	var g_doughnutChart = null;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objMainContent = $('#main-content');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htInstallStateList = loadTypeList("INSTALL_STATE");
		if (g_htInstallStateList.isEmpty()) {
			displayAlertDialog("설치상태 유형 조회", "설치상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnDownload') {
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
							var includeUserNodes = '<%=OptionType.OPTION_TYPE_NO%>';
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
				if ($(this).attr('node_type') == "company") {
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
						$('.inner-center .pane-header').text('사업장 설치 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
<% } else { %>
						$('.inner-center .pane-header').text('전체 설치 현황');
<% } %>
					} else if (data.rslt.obj.attr('node_type') == "dept") {
						$('.inner-center .pane-header').text('부서 설치 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else {
						$('.inner-center .pane-header').text('전체 사업장 설치 현황');
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
		}

		var postData = getRequestAgentInstallStatusParam(
				targetCompanyId,
				arrTargetDeptList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("클라이언트 설치 현황 조회", "클라이언트 설치 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				g_objMainContent.show();
				if ($(data).find('record').length > 0) {
	 				$('.inner-center .pane-footer').show();
				} else {
	 				$('.inner-center .pane-footer').hide();
				}
				loadChart($(data));
				loadChartTable($(data));
				reloadDefaultLayout();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("클라이언트 설치 현황 조회", "클라이언트 설치 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	var randomScalingFactor = function() {
		return Math.round(Math.random() * 100);
	};

	loadChart = function(responseData) {

		var arrlabel = [];
		var arrData = [];
		var arrBackgroundColor = [];
		responseData.find('record').each( function(index) {
			arrlabel.push(g_htInstallStateList.get($(this).find('installflag').text()));
			arrData.push($(this).find('statuscount').text());
		});

		var chartData = {
			labels: arrlabel,
			datasets: [{
				label: '검사 현황',
				data: arrData,
//  				data: [
//  					randomScalingFactor(),
//  					randomScalingFactor(),
//  					randomScalingFactor(),
//  				],
				backgroundColor: [
					'rgba(255, 0, 0, 0.6)',
					'rgba(0, 51, 230, 0.6)',
					'rgba(255, 215, 0, 0.9)',
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

		var ctx = document.getElementById('doughnut-chart').getContext('2d');

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
					text: '설치 현황'
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

	loadChartTable = function(responseData) {

		var htmlContents = '';

		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		htmlContents += '<th class="ui-state-default">설치상태</th>';
		htmlContents += '<th class="ui-state-default">건수</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		responseData.find('record').each( function(index) {
			var lineStyle = '';
			if (index%2 == 0)
				lineStyle = "list_odd";
			else
				lineStyle = "list_even";

			var installFlag = $(this).find('installflag').text();
			var statusCount = parseInt($(this).find('statuscount').text());

			htmlContents += '<tr class="' + lineStyle + '">';
			htmlContents += '<td style="text-align: center;">' + g_htInstallStateList.get(installFlag) + '</td>';
			htmlContents += '<td style="text-align: right;">' + statusCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
			htmlContents += '</tr>';
		});

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		$('#chart-table').html(htmlContents);
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
		}

		var postData = getRequestCreateAgentInstallStatusFileParam(
				targetCompanyId,
				arrTargetDeptList);

		openDownloadDialog("클라이언트 설치 현황", "클라이언트 설치 현황", postData);
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
<div class="inner-center">
	<div class="pane-header">조직별 클라이언트 설치 현황</div>
	<div class="ui-layout-content">
		<div id="main-content" style="padding: 10px; display: none;">
			<div class="sub-category-contents">
				<div style="float: left; width: 55%; margin-top: 1px;">
					<div class="chart-container" style="width: 100%; height: 300px;"><canvas id="doughnut-chart"></canvas></div>
				</div>
				<div style="margin-left: 56%;">
					<div id="chart-table"></div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button">목록 다운로드</button>
		</div>
	</div>
</div>
