<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="reservesearchpolicy-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objTargetUsersTree;
	var g_objSetupInfo;
	var g_objMainContent;
	var g_objPolicyList;

	var g_htSearchScheduleTypeList = new Hashtable();
	var g_htNthWeekTypeList = new Hashtable();
	var g_htDayOfWeekTypeList = new Hashtable();
	var g_htDeptList = new Hashtable();

	var g_htUserStateList = new Hashtable();
	var g_arrEnclosedSymbol = new Array();

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objTargetUsersTree = $('#target-users-tree');
		g_objMainContent = $('#main-content');
		g_objPolicyList = $('#policy-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnNewPolicy"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnPolicyInfo"]').button({ icons: {primary: "ui-icon-info"} });
		$('button[name="btnAddUserToPolicy"]').button({ icons: {primary: "ui-icon-arrowthickstop-1-w"} });
		$('button[name="btnRemoveUserFromPolicy"]').button({ icons: {primary: "ui-icon-arrowthickstop-1-e"} });
		$('button[name="btnSave"]').button({ icons: {primary: "ui-icon-disk"} });

		g_objPolicyList.accordion({
			header: "div.accordion-header",
			heightStyle: "content",
			collapsible: true
		});

		$('#dialog:ui-dialog').dialog('destroy');

		for (var i=9398; i<9450; i++) {
			g_arrEnclosedSymbol.push(String.fromCharCode(i));
		}

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
		$('#policy').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
		$('#policy').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htSearchScheduleTypeList = loadTypeList("SEARCH_SCHEDULE_TYPE");
		if (g_htSearchScheduleTypeList.isEmpty()) {
			displayAlertDialog("검사일정 유형 조회", "검사일정 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htNthWeekTypeList = loadTypeList("NTHWEEK_TYPE");
		if (g_htNthWeekTypeList.isEmpty()) {
			displayAlertDialog("요일 순서 유형 조회", "요일 순서 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htDayOfWeekTypeList = loadTypeList("DAYOFWEEK_TYPE");
		if (g_htDayOfWeekTypeList.isEmpty()) {
			displayAlertDialog("요일 유형 조회", "요일 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		innerDefaultLayout.show("west");
		loadCompanyTreeView();
<% } else { %>
		g_htDeptList = loadDeptList("<%=(String)session.getAttribute("COMPANYID")%>");
		loadTargetUsersTreeView("<%=(String)session.getAttribute("COMPANYID")%>");
		$('button[name="btnSave"]').show();
		g_objMainContent.show();
<% } %>

		$('button').click( function () {
			if ($(this).attr('id') == 'btnNewPolicy') {
				openNewReserveSearchPolicyDialog();
			} else if ($(this).attr('id') == 'btnPolicyInfo') {
				var htPolicyInfo = getPolicy();
				openReserveSearchPolicyInfoDialog(htPolicyInfo);
			} else if ($(this).attr('id') == 'btnAddUserToPolicy') {
				addUserToPolicy();
			} else if ($(this).attr('id') == 'btnRemoveUserFromPolicy') {
				removeUserFromPolicy();
			} else if ($(this).attr('id') == 'btnSave') {
				displayConfirmDialog("설정 저장", "설정 정보를 저장 하시겠습니까?", "", function() { saveReserveSearchInfo(); });
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("click", ".list-table thead tr th:first-child", function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function(e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; });
	});

	loadDeptList = function(companyId) {

		var g_htList = new Hashtable();
		var postData = getRequestDeptListParam(companyId, '', 'DEPTNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 목록 조회", "부서 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					if (!g_htList.isEmpty()) g_htList.clear();
					$(data).find('record').each( function() {
						g_htList.put($(this).find('deptcode').text(), $(this).find('deptname').text());
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 목록 조회", "부서 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return g_htList;
	};

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

	loadCompanyTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[전체 사업장]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "</root>";

		g_objCompanyTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var categoryCode = "";
							if (node.attr("node_type") == 'company_category') {
								categoryCode = node.children('a').text().trim();
							}
							var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_COMPANY%>', categoryCode, '');
							return {
								sendmsg : postData
							};
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') == "company") {
					$('.inner-center .pane-header').text('예약검사 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
					$('button[name="btnSave"]').show();
					g_objMainContent.show();
					$('.inner-center .ui-layout-content').unblock();

					g_htDeptList = loadDeptList(data.rslt.obj.attr('companyid'));
					loadTargetUsersTreeView(data.rslt.obj.attr('companyid'));
				} else {
					$('.inner-center .pane-header').text('예약검사 설정');
					$('button[name="btnSave"]').hide();
					g_objMainContent.hide();
					$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><span style="position:relative; bottom: -1px;line-height: 20px;">예약검사 설정을 위한 대상을 사업장해 주세요.</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '360px', 'width': '50%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
		});
	};

	loadTargetUsersTreeView = function(companyId) {

		g_htUserStateList.clear();

		var xmlTreeData = loadCompanyNode(companyId);

		g_objTargetUsersTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = "<%=OptionType.OPTION_TYPE_YES%>";
							var companyid = "";
							var deptCode = "";
							if (typeof node.attr('companyid') != typeof undefined) {
								companyid = node.attr('companyid');
							}
							if (typeof node.attr('deptcode') != typeof undefined) {
								deptCode = node.attr('deptcode');
							}
							var postData = getRequestDeptTreeNodesParam(companyid, deptCode, includeUserNodes);
							return {
								sendmsg : postData
							};
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("강제검사 대상 구성도 조회", "강제검사 대상 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("강제검사 대상 구성도 조회", "강제검사 대상 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu", "checkbox" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
			$('button[name="btnAddUserToPolicy"]').button("option", "disabled", true);
			loadReserveSearchInfo(companyId);
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
		}).bind('open_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if ($(this).attr('node_type') == "user") {
					var userKey = $(this).attr('companyid') + "_" + $(this).attr('userid');
		 			var arrUserState = new Array();
		 			g_htUserStateList.put(userKey, arrUserState);
				}
			});
		}).bind('check_node.jstree', function (event, data) {
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", false);
			}
		}).bind('uncheck_node.jstree', function (event, data) {
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", false);
			}
		}).bind('select_node.jstree', function (event, data) {
			if (!data.inst.is_checked(data.rslt.obj)) {
				data.inst.check_node(data.rslt.obj);
			} else {
				data.inst.uncheck_node(data.rslt.obj);
			}
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToPolicy"]').button("option", "disabled", false);
			}
		});
	};

	loadReserveSearchInfo = function(companyId) {

		var postData = getRequestReserveSearchInfoParam(companyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				g_objPolicyList.block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				g_objPolicyList.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("예약검사 정책 정보 조회", "예약검사 정책 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				displayPolicyInfo();

				$(data).find('policy').each( function() {
					var searchScheduleType = $(this).find("searchscheduletype").text();
					var nthWeekForMonth = $(this).find("nthweekformonth").text();
					var dayOfWeekForMonth = $(this).find("dayofweekformonth").text();
					var searchHoursForMonth = $(this).find("searchhoursformonth").text();
					var searchMinutesForMonth = $(this).find("searchminutesformonth").text();
					var dayOfWeekForWeek = $(this).find("dayofweekforweek").text();
					var searchHoursForWeek = $(this).find("searchhoursforweek").text();
					var searchMinutesForWeek = $(this).find("searchminutesforweek").text();
					var searchHoursForDay = $(this).find("searchhoursforday").text();
					var searchMinutesForDay = $(this).find("searchminutesforday").text();
					var searchSpecifiedDate = $(this).find("searchspecifieddate").text();
					var searchHoursForSpecifiedDate = $(this).find("searchhoursforspecifieddate").text();
					var searchMinutesForSpecifiedDate = $(this).find("searchminutesforspecifieddate").text();

					var htPolicyInfo = new Hashtable();
					if ((searchScheduleType != null) && (searchScheduleType.length != 0)) {
						htPolicyInfo.put('searchscheduletype', searchScheduleType);
					}
					if ((nthWeekForMonth != null) && (nthWeekForMonth.length != 0)) {
						htPolicyInfo.put('nthweekformonth', nthWeekForMonth);
					}
					if ((dayOfWeekForMonth != null) && (dayOfWeekForMonth.length != 0)) {
						htPolicyInfo.put('dayofweekformonth', dayOfWeekForMonth);
					}
					if ((searchHoursForMonth != null) && (searchHoursForMonth.length != 0)) {
						htPolicyInfo.put('searchhoursformonth', searchHoursForMonth);
					}
					if ((searchMinutesForMonth != null) && (searchMinutesForMonth.length != 0)) {
						htPolicyInfo.put('searchminutesformonth', searchMinutesForMonth);
					}
					if ((dayOfWeekForWeek != null) && (dayOfWeekForWeek.length != 0)) {
						htPolicyInfo.put('dayofweekforweek', dayOfWeekForWeek);
					}
					if ((searchHoursForWeek != null) && (searchHoursForWeek.length != 0)) {
						htPolicyInfo.put('searchhoursforweek', searchHoursForWeek);
					}
					if ((searchMinutesForWeek != null) && (searchMinutesForWeek.length != 0)) {
						htPolicyInfo.put('searchminutesforweek', searchMinutesForWeek);
					}
					if ((searchHoursForDay != null) && (searchHoursForDay.length != 0)) {
						htPolicyInfo.put('searchhoursforday', searchHoursForDay);
					}
					if ((searchMinutesForDay != null) && (searchMinutesForDay.length != 0)) {
						htPolicyInfo.put('searchminutesforday', searchMinutesForDay);
					}
					if ((searchSpecifiedDate != null) && (searchSpecifiedDate.length != 0)) {
						htPolicyInfo.put('searchspecifieddate', searchSpecifiedDate);
					}
					if ((searchHoursForSpecifiedDate != null) && (searchHoursForSpecifiedDate.length != 0)) {
						htPolicyInfo.put('searchhoursforspecifieddate', searchHoursForSpecifiedDate);
					}
					if ((searchMinutesForSpecifiedDate != null) && (searchMinutesForSpecifiedDate.length != 0)) {
						htPolicyInfo.put('searchminutesforspecifieddate', searchMinutesForSpecifiedDate);
					}

					var arrUserList = new Array(); 
					$(this).find('user').each( function() {
						var arrUser = new Array();
						arrUser.push($(this).find('companyid').text());
						arrUser.push($(this).find('deptcode').text());
						arrUser.push($(this).find('userid').text());
						arrUser.push($(this).find('username').text());
						arrUserList.push(arrUser);
					});
					addPolicy(htPolicyInfo, arrUserList);
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("예약검사 정책 정보 조회", "예약검사 정책 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveReserveSearchInfo = function() {

		var arrPolicyList = new Array();

		g_objPolicyList.find(".accordion-pannel").each( function() {
			var searchScheduleType = $(this).attr("searchscheduletype");
			var nthWeekForMonth = $(this).attr("nthweekformonth");
			var dayOfWeekForMonth = $(this).attr("dayofweekformonth");
			var searchHoursForMonth = $(this).attr("searchhoursformonth");
			var searchMinutesForMonth = $(this).attr("searchminutesformonth");
			var dayOfWeekForWeek = $(this).attr("dayofweekforweek");
			var searchHoursForWeek = $(this).attr("searchhoursforweek");
			var searchMinutesForWeek = $(this).attr("searchminutesforweek");
			var searchHoursForDay = $(this).attr("searchhoursforday");
			var searchMinutesForDay = $(this).attr("searchminutesforday");
			var searchSpecifiedDate = $(this).attr("searchspecifieddate");
			var searchHoursForSpecifiedDate = $(this).attr("searchhoursforspecifieddate");
			var searchMinutesForSpecifiedDate = $(this).attr("searchminutesforspecifieddate");

			var htPolicyInfo = new Hashtable();
			if (typeof searchScheduleType != typeof undefined) {
				htPolicyInfo.put('searchscheduletype', searchScheduleType);
			}
			if (typeof nthWeekForMonth != typeof undefined) {
				htPolicyInfo.put('nthweekformonth', nthWeekForMonth);
			}
			if (typeof dayOfWeekForMonth != typeof undefined) {
				htPolicyInfo.put('dayofweekformonth', dayOfWeekForMonth);
			}
			if (typeof searchHoursForMonth != typeof undefined) {
				htPolicyInfo.put('searchhoursformonth', searchHoursForMonth);
			}
			if (typeof searchMinutesForMonth != typeof undefined) {
				htPolicyInfo.put('searchminutesformonth', searchMinutesForMonth);
			}
			if (typeof dayOfWeekForWeek != typeof undefined) {
				htPolicyInfo.put('dayofweekforweek', dayOfWeekForWeek);
			}
			if (typeof searchHoursForWeek != typeof undefined) {
				htPolicyInfo.put('searchhoursforweek', searchHoursForWeek);
			}
			if (typeof searchMinutesForWeek != typeof undefined) {
				htPolicyInfo.put('searchminutesforweek', searchMinutesForWeek);
			}
			if (typeof searchHoursForDay != typeof undefined) {
				htPolicyInfo.put('searchhoursforday', searchHoursForDay);
			}
			if (typeof searchMinutesForDay != typeof undefined) {
				htPolicyInfo.put('searchminutesforday', searchMinutesForDay);
			}
			if (typeof searchSpecifiedDate != typeof undefined) {
				htPolicyInfo.put('searchspecifieddate', searchSpecifiedDate);
			}
			if (typeof searchHoursForSpecifiedDate != typeof undefined) {
				htPolicyInfo.put('searchhoursforspecifieddate', searchHoursForSpecifiedDate);
			}
			if (typeof searchMinutesForSpecifiedDate != typeof undefined) {
				htPolicyInfo.put('searchminutesforspecifieddate', searchMinutesForSpecifiedDate);
			}

			var arrUserList = new Array();
			$(this).find('.list-table > tbody > tr').find('input:checkbox[name="selectuser"]').each( function () {
				var arrUser = new Array();
				arrUser.push($(this).attr('userid'));
				arrUserList.push(arrUser);
			});

			htPolicyInfo.put("userlist", arrUserList);

			arrPolicyList.push(htPolicyInfo);
		});

		var targetCompanyId = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestSaveReserveSearchParam('<%=(String)session.getAttribute("ADMINID")%>',
				targetCompanyId,
				arrPolicyList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				g_objPolicyList.block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				g_objPolicyList.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("예약검사 정책 정보 저장", "예약검사 정책 정보 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("예약검사 정책 정보 저장", "정상 처리되었습니다.", "예약검사 정책 정보가 저장되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("예약검사 정책 정보 저장", "예약검사 정책 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	displayPolicyInfo = function() {

		var htmlContents = "";
		htmlContents += '<div id="policy-info" class="info">';
		htmlContents += '<ul>';
		htmlContents += '<li>예약 검사를 위한 신규 정책을 생성해주세요.</li>';
		htmlContents += '<li>정책은 최대 <%=CommonConstant.MAX_RESERVED_SEARCH_COUNT%>개까지 생성할 수 있습니다.</li>';
		htmlContents += '</ul>';
		htmlContents += '</div>';
		g_objPolicyList.html(htmlContents);
	};

	getPolicy = function() {

		var activeIndex = g_objPolicyList.accordion("option", "active");
		if (activeIndex == -1) activeIndex = 0;

		var objPolicyPannel = g_objPolicyList.find(".accordion-pannel").eq(activeIndex);

		var searchScheduleType = objPolicyPannel.attr("searchscheduletype");
		var nthWeekForMonth = objPolicyPannel.attr("nthweekformonth");
		var dayOfWeekForMonth = objPolicyPannel.attr("dayofweekformonth");
		var searchHoursForMonth = objPolicyPannel.attr("searchhoursformonth");
		var searchMinutesForMonth = objPolicyPannel.attr("searchminutesformonth");
		var dayOfWeekForWeek = objPolicyPannel.attr("dayofweekforweek");
		var searchHoursForWeek = objPolicyPannel.attr("searchhoursforweek");
		var searchMinutesForWeek = objPolicyPannel.attr("searchminutesforweek");
		var searchHoursForDay = objPolicyPannel.attr("searchhoursforday");
		var searchMinutesForDay = objPolicyPannel.attr("searchminutesforday");
		var searchSpecifiedDate = objPolicyPannel.attr("searchspecifieddate");
		var searchHoursForSpecifiedDate = objPolicyPannel.attr("searchhoursforspecifieddate");
		var searchMinutesForSpecifiedDate = objPolicyPannel.attr("searchminutesforspecifieddate");

		var htPolicyInfo = new Hashtable();
		if (typeof searchScheduleType != typeof undefined) {
			htPolicyInfo.put('searchscheduletype', searchScheduleType);
		}
		if (typeof nthWeekForMonth != typeof undefined) {
			htPolicyInfo.put('nthweekformonth', nthWeekForMonth);
		}
		if (typeof dayOfWeekForMonth != typeof undefined) {
			htPolicyInfo.put('dayofweekformonth', dayOfWeekForMonth);
		}
		if (typeof searchHoursForMonth != typeof undefined) {
			htPolicyInfo.put('searchhoursformonth', searchHoursForMonth);
		}
		if (typeof searchMinutesForMonth != typeof undefined) {
			htPolicyInfo.put('searchminutesformonth', searchMinutesForMonth);
		}
		if (typeof dayOfWeekForWeek != typeof undefined) {
			htPolicyInfo.put('dayofweekforweek', dayOfWeekForWeek);
		}
		if (typeof searchHoursForWeek != typeof undefined) {
			htPolicyInfo.put('searchhoursforweek', searchHoursForWeek);
		}
		if (typeof searchMinutesForWeek != typeof undefined) {
			htPolicyInfo.put('searchminutesforweek', searchMinutesForWeek);
		}
		if (typeof searchHoursForDay != typeof undefined) {
			htPolicyInfo.put('searchhoursforday', searchHoursForDay);
		}
		if (typeof searchMinutesForDay != typeof undefined) {
			htPolicyInfo.put('searchminutesforday', searchMinutesForDay);
		}
		if (typeof searchSpecifiedDate != typeof undefined) {
			htPolicyInfo.put('searchspecifieddate', searchSpecifiedDate);
		}
		if (typeof searchHoursForSpecifiedDate != typeof undefined) {
			htPolicyInfo.put('searchhoursforspecifieddate', searchHoursForSpecifiedDate);
		}
		if (typeof searchMinutesForSpecifiedDate != typeof undefined) {
			htPolicyInfo.put('searchminutesforspecifieddate', searchMinutesForSpecifiedDate);
		}

		return htPolicyInfo;
	};

	addPolicy = function(htPolicyInfo, arrUserList) {

		if (g_objPolicyList.find('.accordion-header').length >= <%=CommonConstant.MAX_RESERVED_SEARCH_COUNT%>) {
			displayAlertDialog("예약검사 정책", "등록할 수 있는 예약검사 수를 초과하였습니다.", "정책은 최대 <%=CommonConstant.MAX_RESERVED_SEARCH_COUNT%>개까지 생성할 수 있습니다.");
			return false;
		}

		if (g_objPolicyList.find('#policy-info').length != 0) {
			g_objPolicyList.find('#policy-info').remove();
		}

		g_htUserStateList.each( function(key, values) {
			values.push("<%=OptionType.OPTION_TYPE_NO%>");
		});

		var headerText = '[ 정책 <span class="policy_symbol" style="padding-right: 2px;">' + g_arrEnclosedSymbol[g_objPolicyList.find('.accordion-header').length] + '</span> ]  ';
		var pannelAttr = "";
		if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_MONTH%>") {
			headerText += "매월 " + g_htNthWeekTypeList.get(htPolicyInfo.get('nthweekformonth')) + " " + g_htDayOfWeekTypeList.get(htPolicyInfo.get('dayofweekformonth')) + " " + htPolicyInfo.get('searchhoursformonth') + "시 " + htPolicyInfo.get('searchminutesformonth') + "분";
			pannelAttr = ' searchscheduletype="' + htPolicyInfo.get('searchscheduletype') + '" nthweekformonth="' + htPolicyInfo.get('nthweekformonth') + '" dayofweekformonth="' + htPolicyInfo.get('dayofweekformonth') + '" searchhoursformonth="' + htPolicyInfo.get('searchhoursformonth') + '" searchminutesformonth="' + htPolicyInfo.get('searchminutesformonth') + '"';
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_WEEK%>") {
			headerText += "매주 " + g_htDayOfWeekTypeList.get(htPolicyInfo.get('dayofweekforweek')) + " " + htPolicyInfo.get('searchhoursforweek') + "시 " + htPolicyInfo.get('searchminutesforweek') + "분";
			pannelAttr = ' searchscheduletype="' + htPolicyInfo.get('searchscheduletype') + '" dayofweekforweek="' + htPolicyInfo.get('dayofweekforweek') + '" searchhoursforweek="' + htPolicyInfo.get('searchhoursforweek') + '" searchminutesforweek="' + htPolicyInfo.get('searchminutesforweek') + '"';
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_DAY%>") {
			headerText += "매일 " + htPolicyInfo.get('searchhoursforday') + "시 " + htPolicyInfo.get('searchminutesforday') + "분";
			pannelAttr = ' searchscheduletype="' + htPolicyInfo.get('searchscheduletype') + '" searchhoursforday="' + htPolicyInfo.get('searchhoursforday') + '" searchminutesforday="' + htPolicyInfo.get('searchminutesforday') + '"';
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_SPECIFIED_DATE%>") {
			headerText += htPolicyInfo.get('searchspecifieddate') + " " + htPolicyInfo.get('searchhoursforspecifieddate') + "시 " + htPolicyInfo.get('searchminutesforspecifieddate') + "분";
			pannelAttr = ' searchscheduletype="' + htPolicyInfo.get('searchscheduletype') + '" searchspecifieddate="' + htPolicyInfo.get('searchspecifieddate') + '" searchhoursforspecifieddate="' + htPolicyInfo.get('searchhoursforspecifieddate') + '" searchminutesforspecifieddate="' + htPolicyInfo.get('searchminutesforspecifieddate') + '"';
		}

		var htmlContents = "";
		htmlContents += '<div class="accordion-header">' + headerText + '</div>';
		htmlContents += '<div class="accordion-pannel"' + pannelAttr + '>';

		htmlContents += '<div class="user-list">';
		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		htmlContents += '<th width="40" class="ui-state-default" style="text-align: center;">';
		htmlContents += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur();">';
		htmlContents += '</th>';
		htmlContents += '<th class="ui-state-default">부서 명</th>';
		htmlContents += '<th class="ui-state-default">사용자 명</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		if (!$.isEmptyObject(arrUserList) && $.isArray(arrUserList) ) {
			$.each(arrUserList, function(index, arrUser) {
				var companyId = arrUser[0];
				var deptCode = arrUser[1];
				var userId = arrUser[2];
				var userName = arrUser[3];

				var lineStyle = '';
				if (index%2 == 0)
					lineStyle = "list_odd";
				else
					lineStyle = "list_even";

				htmlContents += '<tr class="' + lineStyle + '">';
				htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" deptcode="' + deptCode + '" userid="' + userId + '" style="border: 0;"></td>';
				htmlContents += '<td>' + g_htDeptList.get(deptCode) + '</td>';
				htmlContents += '<td>' + userName + '</td>';
				htmlContents += '</tr>';

				var index = g_objPolicyList.find('.accordion-header').length;
				var userKey = companyId + "_" + userId;
				var arrUserState = g_htUserStateList.get(userKey);
				if (!$.isEmptyObject(arrUserState) && $.isArray(arrUserState) ) {
					arrUserState[index] = "<%=OptionType.OPTION_TYPE_YES%>";
					g_htUserStateList.put(userKey, arrUserState);
				}

				changeTargetUserStatusOfTree(companyId, userId);
			});
		}
		htmlContents += '</tbody>';
		htmlContents += '</table>';
		htmlContents += '</div>';
		htmlContents += '</div>';

		g_objPolicyList.append(htmlContents);
		g_objPolicyList.accordion("refresh");
		g_objPolicyList.accordion('option', 'active', -1);

		if(!$('button[name="btnPolicyInfo"]').is(':visible')) {
			$('button[name="btnPolicyInfo"]').show();
		}
	};

	updatePolicy = function(htPolicyInfo) {

		var activeIndex = g_objPolicyList.accordion("option", "active");
		if (activeIndex == -1) activeIndex = 0;

		var objPolicyHeader = g_objPolicyList.find(".accordion-header").eq(activeIndex);
		var objPolicyPannel = g_objPolicyList.find(".accordion-pannel").eq(activeIndex);

		var headerText = '[ 정책 <span class="policy_symbol" style="padding-right: 2px;">' + g_arrEnclosedSymbol[activeIndex] + '</span> ]  ';

		objPolicyPannel.attr("searchscheduletype", htPolicyInfo.get('searchscheduletype'));
		if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_MONTH%>") {
			objPolicyPannel.attr("nthweekformonth", htPolicyInfo.get('nthweekformonth'));
			objPolicyPannel.attr("dayofweekformonth", htPolicyInfo.get('dayofweekformonth'));
			objPolicyPannel.attr("searchhoursformonth", htPolicyInfo.get('searchhoursformonth'));
			objPolicyPannel.attr("searchminutesformonth", htPolicyInfo.get('searchminutesformonth'));
			headerText += "매월 " + g_htNthWeekTypeList.get(htPolicyInfo.get('nthweekformonth')) + " " + g_htDayOfWeekTypeList.get(htPolicyInfo.get('dayofweekformonth')) + " " + htPolicyInfo.get('searchhoursformonth') + "시 " + htPolicyInfo.get('searchminutesformonth') + "분";
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_WEEK%>") {
			objPolicyPannel.attr("dayofweekforweek", htPolicyInfo.get('dayofweekforweek'));
			objPolicyPannel.attr("searchhoursforweek", htPolicyInfo.get('searchhoursforweek'));
			objPolicyPannel.attr("searchminutesforweek", htPolicyInfo.get('searchminutesforweek'));
			headerText += "매주 " + g_htDayOfWeekTypeList.get(htPolicyInfo.get('dayofweekforweek')) + " " + htPolicyInfo.get('searchhoursforweek') + "시 " + htPolicyInfo.get('searchminutesforweek') + "분";
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_DAY%>") {
			objPolicyPannel.attr("searchhoursforday", htPolicyInfo.get('searchhoursforday'));
			objPolicyPannel.attr("searchminutesforday", htPolicyInfo.get('searchminutesforday'));
			headerText += "매일 " + htPolicyInfo.get('searchhoursforday') + "시 " + htPolicyInfo.get('searchminutesforday') + "분";
		} else if (htPolicyInfo.get('searchscheduletype') == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_SPECIFIED_DATE%>") {
			objPolicyPannel.attr("searchspecifieddate", htPolicyInfo.get('searchspecifieddate'));
			objPolicyPannel.attr("searchhoursforspecifieddate", htPolicyInfo.get('searchhoursforspecifieddate'));
			objPolicyPannel.attr("searchminutesforspecifieddate", htPolicyInfo.get('searchminutesforspecifieddate'));
			headerText += htPolicyInfo.get('searchspecifieddate') + " " + htPolicyInfo.get('searchhoursforspecifieddate') + "시 " + htPolicyInfo.get('searchminutesforspecifieddate') + "분";
		}

		objPolicyHeader.html(headerText);
	};

	removePolicy = function() {

		var activeIndex = g_objPolicyList.accordion("option", "active");
		if (activeIndex == -1) activeIndex = 0;

		var objPolicyHeader = g_objPolicyList.find(".accordion-header").eq(activeIndex);
		var objPolicyPannel = g_objPolicyList.find(".accordion-pannel").eq(activeIndex);

		g_htUserStateList.each( function(key, values) {
			values.splice(activeIndex, 1);
		});
		changeAllUserStatusOfTree();

		objPolicyHeader.remove();
		objPolicyPannel.remove();
		g_objPolicyList.accordion("refresh");

		var indexHeader = 0;
		g_objPolicyList.find(".accordion-header").each( function() {
			$(this).find('.policy_symbol').text(g_arrEnclosedSymbol[indexHeader]);
			indexHeader++;
		});

		if (g_objPolicyList.find('.accordion-header').length == 0) {
			displayPolicyInfo();
			$('button[name="btnPolicyInfo"]').hide();
		} else {
			g_objPolicyList.accordion('option', 'active', -1);
		}

	};

	addUserToPolicy = function() {

		if (g_objPolicyList.find('.accordion-header').length == 0) {
			displayAlertDialog("예약검사 정책", "예약검사를 위한 정책이 등록되어있지 않습니다.", "예약검사를 위한 정책을 등록해주세요.");
			return false;
		}

		var activeIndex = g_objPolicyList.accordion("option", "active");
		if (activeIndex == -1) activeIndex = 0;

		var objTargetPolicyPannel = g_objPolicyList.find(".accordion-pannel").eq(activeIndex);

		var objTargetUsersTreeReference = $.jstree._reference(g_objTargetUsersTree);

		g_objTargetUsersTree.find(".jstree-checked").each( function(i, node) {
			if ($(node).attr('node_type') == "user") {
				var companyId = $(node).attr('companyid');
				var deptCode = $(node).attr('deptcode');
				var userId = $(node).attr('userid');
				var userName = objTargetUsersTreeReference.get_text($(node));

				var isAlready = false;
				objTargetPolicyPannel.find('input:checkbox[name="selectuser"]').each( function () {
					if (($(this).attr("companyid") == companyId) && ($(this).attr("deptcode") == deptCode) && ($(this).attr("userid") == userId)) {
						isAlready = true;
						return false;
					}
				});

				if (!isAlready) {
					var newRow = '';
					newRow += '<tr>';
					newRow += '<td style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" deptcode="' + deptCode + '" userid="' + userId + '" style="border: 0;"></td>';
					newRow += '<td>' + g_htDeptList.get(deptCode) + '</td>';
					newRow += '<td>' + userName.split('-')[0].trim() + '</td>';
					newRow += '</tr>';

					objTargetPolicyPannel.find('tbody').append(newRow);

					var userKey = companyId + "_" + userId;
					var arrUserState = g_htUserStateList.get(userKey);
					if (!$.isEmptyObject(arrUserState) && $.isArray(arrUserState) ) {
						arrUserState[activeIndex] = "<%=OptionType.OPTION_TYPE_YES%>";
						g_htUserStateList.put(userKey, arrUserState);
					}
					changeTargetUserStatusOfTree(companyId, userId);
				}
				g_objTargetUsersTree.jstree('uncheck_node', $(node));
			}
		});

		$('button[name="btnAddUserToPolicy"]').button("option", "disabled", true);

		refreshListTable(objTargetPolicyPannel);
	};

	removeUserFromPolicy = function() {

		var activeIndex = g_objPolicyList.accordion("option", "active");
		if (activeIndex == -1) activeIndex = 0;

		var objTargetPolicyPannel = g_objPolicyList.find(".accordion-pannel").eq(activeIndex);

		objTargetPolicyPannel.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').each( function () {
			var companyId = $(this).attr('companyid');
			var deptCode = $(this).attr('deptcode');
			var userId = $(this).attr('userid');

			var userKey = companyId + "_" + userId;
			var arrUserState = g_htUserStateList.get(userKey);
			if (!$.isEmptyObject(arrUserState) && $.isArray(arrUserState) ) {
				arrUserState[activeIndex] = "<%=OptionType.OPTION_TYPE_NO%>";
				g_htUserStateList.put(userKey, arrUserState);
			}
			changeTargetUserStatusOfTree(companyId, userId);

			$(this).closest('tr').remove();
		});

		objTargetPolicyPannel.find('.list-table thead tr').find('input:checkbox[name="All"]').filter(':checked').each( function () {
			$(this).prop('checked', false);
		});

		refreshListTable(objTargetPolicyPannel);
	};

	refreshListTable = function(objTarget) {

		objTarget.find('.list-table').each( function() {
			$(this).find('tbody > tr').each( function(index) {
				var lineStyle = '';
				if (index%2 == 0)
					lineStyle = "list_odd";
				else
					lineStyle = "list_even";

				$(this).removeClass("list_even");
				$(this).removeClass("list_odd");
				$(this).addClass(lineStyle);
			});
		});
	};

	changeTargetUserStatusOfTree = function(companyId, userId) {

		var userKey = companyId + "_" + userId;
		var arrUserState = g_htUserStateList.get(userKey);
		var userNode = g_objTargetUsersTree.find('#uid_' + userKey);
		var nodeText = userNode.children('a').text().trim();
		var userName = nodeText.split(' - ')[0].trim();

		var isAppliedPolicy = false;
		var appliedPolicyList = "";

		if (!$.isEmptyObject(arrUserState) && $.isArray(arrUserState) ) {
			$.each(arrUserState, function(colIdx, colVal) {
				if (colVal == "<%=OptionType.OPTION_TYPE_YES%>") {
					appliedPolicyList += " " + g_arrEnclosedSymbol[colIdx];
					isAppliedPolicy = true;
				}
			});
		}

		if (isAppliedPolicy) {
			userName += " - " + appliedPolicyList;
		}

		g_objTargetUsersTree.jstree('rename_node', '#uid_' + userKey, userName);
	};

	changeAllUserStatusOfTree = function() {

		g_objTargetUsersTree.find('.jstree-leaf').each( function() {
			if ($(this).attr('node_type') == "user") {
				var nodeText = $(this).children('a').text().trim();
				var userName = nodeText.split(' - ')[0].trim();
				var companyId = $(this).attr('companyid');
				var deptCode = $(this).attr('deptcode');
				var userId = $(this).attr('userid');

				var userKey = companyId + "_" + userId;
				var arrUserState = g_htUserStateList.get(userKey);

				var isAppliedPolicy = false;
				var appliedPolicyList = "";

				if (!$.isEmptyObject(arrUserState) && $.isArray(arrUserState) ) {
					$.each(arrUserState, function(colIdx, colVal) {
						if (colVal == "<%=OptionType.OPTION_TYPE_YES%>") {
							appliedPolicyList += " " + g_arrEnclosedSymbol[colIdx];
							isAppliedPolicy = true;
						}
					});
				}

				if (isAppliedPolicy) {
					userName += " - " + appliedPolicyList;
				}

				g_objTargetUsersTree.jstree('rename_node', '#uid_' + userKey, userName);
			}
		});
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">사업장 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="company-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">예약검사 설정</div>
	<div class="ui-layout-content" style="padding: 20px;">
		<div id="main-content">
			<div style="float: left; width: 55%">
				<div>
					<div class="category-title">예약검사 정책 목록</div>
					<div id="policy" class="droppable category-contents" style="padding: 10px; overflow:auto;">
						<div id="policy-list"></div>
					</div>
					<div class="button-line" style="margin-top: 4px;">
						<button type="button" id="btnRemoveUserFromPolicy" name="btnRemoveUserFromPolicy" class="normal-button">선택 사용자 제외</button>
						<button type="button" id="btnPolicyInfo" name="btnPolicyInfo" class="normal-button" style="display: none;">정책 정보</button>
						<button type="button" id="btnNewPolicy" name="btnNewPolicy" class="normal-button">신규 정책</button>
					</div>
				</div>
			</div>
			<div style="margin-left: 56%;">
				<div>
					<div class="category-title">예약검사 대상</div>
					<div id="target-users" class="draggable category-contents zero-padding">
						<div id="target-users-tree" class="treeview-pannel"></div>
					</div>
					<div class="button-line" style="margin-top: 4px;">
						<button type="button" id="btnAddUserToPolicy" name="btnAddUserToPolicy" class="normal-button">선택 사용자 추가</button>
					</div>
				</div>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnSave" name="btnSave" class="normal-button" style="display: none;">설정 저장</button>
		</div>
	</div>
</div>
