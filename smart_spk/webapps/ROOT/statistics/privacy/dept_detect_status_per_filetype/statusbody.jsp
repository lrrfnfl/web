<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objFileTypeTree;
	var g_objMainContent;

	var g_htFileTypeList = new Hashtable();
	var g_htSearchTypeList = new Hashtable();
	var g_htCompanyList = new Hashtable();

	var g_doughnutChart = null;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objFileTypeTree = $('#filetype-tree');
		g_objMainContent = $('#main-content');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		g_objMainContent.find('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objMainContent.find('#searchdateto').datepicker('option', 'minDate', selectedDate);
				$('button[name="btnDownload"]').hide();
			}
		});

		g_objMainContent.find('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objMainContent.find('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
				$('button[name="btnDownload"]').hide();
			}
		});

		var tmpDate = new Date();
		tmpDate.addDate("d", -6);
		g_objMainContent.find('#searchdatefrom').datepicker('setDate', tmpDate);
		g_objMainContent.find('#searchdateto').datepicker('setDate', new Date());

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htSearchTypeList = loadTypeList("SEARCH_TYPE");
		if (g_htSearchTypeList.isEmpty()) {
			displayAlertDialog("검사 유형 조회", "검사 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		g_htCompanyList = loadCompanyList("");
		fillDropdownList(g_objMainContent.find('#search-condition').find('select[name="searchcompany"]'), g_htCompanyList, null, null);
<% } %>

		fillDropdownList(g_objMainContent.find('#search-condition').find('select[name="searchsearchtype"]'), g_htSearchTypeList, null, "전체");

		g_htFileTypeList = loadTypeList("FILE_TYPE");
		if (g_htFileTypeList.isEmpty()) {
			displayAlertDialog("파일 유형 조회", "파일 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadFileTypeTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				loadStatisticsData();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadStatisticsData();
			}
		});

		$('#search-condition').find('select').change( function() {
			$('button[name="btnDownload"]').hide();
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
	});

	loadCompanyList = function(companyId) {

		var htList = new Hashtable();
		var postData = getRequestCompanyListParam(companyId, '', '', 'COMPANYNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$(data).find('record').each( function() {
					htList.put($(this).find('companyid').text(), $(this).find('companyname').text());
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
		return htList;
	};

	loadFileTypeTreeView = function() {

		var xmlTreeData = "";
		var patternNodeXml = "";

		if (!g_htFileTypeList.isEmpty()) {
			g_htFileTypeList.each( function(value, name) {
				patternNodeXml += "<item id='" + value + "' parent_id='ALL'  node_type='filetype'>";
				patternNodeXml += "<content><name>" + name + "</name></content>";
				patternNodeXml += "</item>";
			});
		}

		xmlTreeData += "<root>";
		xmlTreeData += "<item id='ALL' node_type='ROOT'>";
		xmlTreeData += "<content><name>전체 파일 유형</name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += patternNodeXml;
		xmlTreeData += "</root>";

		g_objFileTypeTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData
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
				//   this.css("color", "red")
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
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') == "filetype") {
					$('.inner-center .pane-header').text('파일 유형 검출 현황 - [' + data.rslt.obj.children('a').text().trim() + ']');
				} else {
					$('.inner-center .pane-header').text('전체 파일 유형 검출 현황');
				}

				loadStatisticsData();
			}
		});
	};

	loadStatisticsData = function() {

		var objSearchCompany = g_objMainContent.find('#searchcompany');
		var objSearchType = g_objMainContent.find('#searchsearchtype');
		var objSearchDateFrom = g_objMainContent.find('#searchdatefrom');
		var objSearchDateTo = g_objMainContent.find('#searchdateto');

		var objTreeReference = $.jstree._reference(g_objFileTypeTree);

		var targetFileType = "";
		if (objTreeReference.get_selected().attr("node_type") == 'filetype') {
			targetFileType = objTreeReference.get_selected().attr('id');
		}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var companyId = objSearchCompany.val();
<% } else { %>
		var companyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestDeptDetectStatusPerFileTypeParam(
				targetFileType,
				companyId,
				objSearchType.val(),
				objSearchDateFrom.val(),
				objSearchDateTo.val());

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
					displayAlertDialog("파일 유형별 부서 검출 현황 조회", "파일 유형별 부서 검출 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				g_objMainContent.show();
				if ($(data).find('record').length > 0) {
	 				$('button[name="btnDownload"]').show();
				} else {
	 				$('button[name="btnDownload"]').hide();
				}
				loadChart($(data));
				loadChartTable($(data));
				reloadDefaultLayout();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("파일 유형별 부서 검출 현황 조회", "파일 유형별 부서 검출 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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

	loadChart = function(responseData) {

		var arrlabel = [];
		var arrData = [];
		var arrBackgroundColor = [];
		var etcCount = 0;
		responseData.find('record').each( function(index) {
			if (index < 10) {
				arrlabel.push($(this).find('deptname').text());
				arrData.push($(this).find('detectkeywordcount').text());
				arrBackgroundColor.push(dynamicColors());
			} else {
				etcCount += parseInt($(this).find('detectkeywordcount').text());
			}
		});

		if (etcCount > 0) {
			arrlabel.push("기타");
			arrData.push(etcCount.toString());
			arrBackgroundColor.push(dynamicColors());
		}

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
		htmlContents += '<th class="ui-state-default">부서</th>';
		htmlContents += '<th class="ui-state-default">검출건수</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		if (responseData.find('record').length > 0) {
			responseData.find('record').each( function(index) {
				var lineStyle = '';
				if (index%2 == 0)
					lineStyle = "list_odd";
				else
					lineStyle = "list_even";

				var deptName = $(this).find('deptname').text();
				var detectKeywordCount = parseInt($(this).find('detectkeywordcount').text());

				htmlContents += '<tr class="' + lineStyle + '">';
				htmlContents += '<td style="text-align: center;">' + deptName + '</td>';
				htmlContents += '<td style="text-align: right;">' + detectKeywordCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
				htmlContents += '</tr>';
			});
		} else {
			htmlContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">검출 정보가 존재하지 않습니다.</div></td>';
		}

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		$('#chart-table').html(htmlContents);
	};

	downloadStatisticsData = function() {

		var objSearchCompany = g_objMainContent.find('#searchcompany');
		var objSearchType = g_objMainContent.find('#searchsearchtype');
		var objSearchDateFrom = g_objMainContent.find('#searchdatefrom');
		var objSearchDateTo = g_objMainContent.find('#searchdateto');

		var objTreeReference = $.jstree._reference(g_objFileTypeTree);

		var targetFileType = "";
		if (objTreeReference.get_selected().attr("node_type") == 'filetype') {
			targetFileType = objTreeReference.get_selected().attr('id');
		}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var companyId = objSearchCompany.val();
<% } else { %>
		var companyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestCreateDeptDetectStatusPerFileTypeFileParam(
				targetFileType,
				companyId,
				objSearchType.val(),
				objSearchDateFrom.val(),
				objSearchDateTo.val());

		var downloadFileName = "파일 유형별 부서 검출 현황";
		downloadFileName += " (" + objSearchDateFrom.val() + "~" + objSearchDateTo.val() + ")";

		openDownloadDialog("파일 유형별 부서 검출 현황", downloadFileName, postData);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">파일 유형 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="filetype-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 파일 유형 검출 현황</div>
	<div class="ui-layout-content">
		<div id="main-content" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사업장
				<select id="searchcompany" name="searchcompany" class="ui-widget-content"></select>
<% } %>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 유형
				<select id="searchsearchtype" name="searchsearchtype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content input-date" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content input-date" readonly="readonly" />
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button>
				</span>
			</div>
			<div class="clear"></div>
			<div class="sub-category-contents">
				<div style="float: left; width: 55%;">
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
