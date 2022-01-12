<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<%@ include file ="agentconfigstatus-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objAgentConfigStatusList;

	var g_htOptionTypeList = new Hashtable();
	var g_htOptionMarkList = new Hashtable();
	var g_htJobProcessingTypeList = new Hashtable();
	var g_htPrintModeList = new Hashtable();
	var g_htControlTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objAgentConfigStatusList = $('#agentconfigstatus-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#dialog:ui-dialog').dialog('destroy');

		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htOptionMarkList = loadTypeList("OPTION_MARK");
		if (g_htOptionMarkList.isEmpty()) {
			displayAlertDialog("옵션 마크 유형 조회", "옵션 마크 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htJobProcessingTypeList = loadTypeList("JOB_PROCESSING_TYPE");
		if (g_htJobProcessingTypeList.isEmpty()) {
			displayAlertDialog("검출파일 처리 유형 조회", "검출파일 처리 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htPrintModeList = loadTypeList("PRINT_MODE");
		if (g_htPrintModeList.isEmpty()) {
			displayAlertDialog("출력 모드 유형 조회", "출력 모드 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htControlTypeList = loadTypeList("CONTROL_TYPE");
		if (g_htControlTypeList.isEmpty()) {
			displayAlertDialog("제어 유형 조회", "제어 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]'), g_htJobProcessingTypeList, null, "전체");
		g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]').find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_DECRYPT%>' + '"]').remove();
		g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]').find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_INDIVIDUAL%>' + '"]').remove();
		g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]').find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_SEND_SERVER%>' + '"]').remove();
		g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]').find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_TO_VITUALDISK%>' + '"]').remove();
		g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchjobprocessingtype"]').find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_FROM_VITUALDISK%>' + '"]').remove();
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchforcedterminationflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchdecordingpermissionflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchcontentcopypreventionflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchrealtimeobservationflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchpasswordexpirationflag"]'), g_htOptionTypeList, null, "전체");

		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchwmprintmode"]'), g_htPrintModeList, null, "전체");

		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchusbcontrolflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchcdromcontrolflag"]'), g_htOptionTypeList, null, "전체");

		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchnetworkservicecontrolflag"]'), g_htOptionTypeList, null, "전체");

		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchsystempasswordsetupflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchsystempasswordexpirationflag"]'), g_htOptionTypeList, null, "전체");
		fillDropdownList(g_objAgentConfigStatusList.find('#search-condition').find('select[name="searchscreensaveractivationflag"]'), g_htOptionTypeList, null, "전체");

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadAgentConfigStatusList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadConfigData();
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
			if ($(this).is(":checked")) {
				var objTreeReference = $.jstree._reference(g_objOrganizationTree);
				if (objTreeReference.get_selected().attr('node_type') == "dept") {
					objTreeReference.open_all(objTreeReference.get_selected());
				}
			}
			loadAgentConfigStatusList();
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('companyid') != typeof undefined) { openAgentConfigStatusInfoDialog($(this).attr('companyid'), $(this).attr('userid')); } });
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
			data.inst._get_children(data.rslt.obj).each(function() {
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
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadAgentConfigStatusList();
				}
			}
		});
	};

	loadAgentConfigStatusList = function() {

		var objSearchCondition = g_objAgentConfigStatusList.find('#search-condition');
		var objSearchResult = g_objAgentConfigStatusList.find('#search-result');

		var objSearchJobProcessingType = objSearchCondition.find('select[name="searchjobprocessingtype"]');
		var objSearchForcedTerminationFlag = objSearchCondition.find('select[name="searchforcedterminationflag"]');
		var objSearchDecordingPermissionFlag = objSearchCondition.find('select[name="searchdecordingpermissionflag"]');
		var objSearchContentCopyPreventionFlag = objSearchCondition.find('select[name="searchcontentcopypreventionflag"]');
		var objSearchRealtimeObservationFlag = objSearchCondition.find('select[name="searchrealtimeobservationflag"]');
		var objSearchPasswordExpirationFlag = objSearchCondition.find('select[name="searchpasswordexpirationflag"]');
		var objSearchWmPrintMode = objSearchCondition.find('select[name="searchwmprintmode"]');
		var objSearchUsbControlFlag = objSearchCondition.find('select[name="searchusbcontrolflag"]');
		var objSearchCdromControlFlag = objSearchCondition.find('select[name="searchcdromcontrolflag"]');
		var objSearchNetworkServiceControlFlag = objSearchCondition.find('select[name="searchnetworkservicecontrolflag"]');
		var objSearchSystemPasswordSetupFlag = objSearchCondition.find('select[name="searchsystempasswordsetupflag"]');
		var objSearchSystemPasswordExpirationFlag = objSearchCondition.find('select[name="searchsystempasswordexpirationflag"]');
		var objSearchScreenSaverActivationFlag = objSearchCondition.find('select[name="searchscreensaveractivationflag"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

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

		var postData = getRequestAgentConfigStatusListParam(
				targetCompanyId,
				arrTargetDeptList,
				targetUserId,
				objSearchJobProcessingType.val(),
				objSearchForcedTerminationFlag.val(),
				objSearchDecordingPermissionFlag.val(),
				objSearchContentCopyPreventionFlag.val(),
				objSearchRealtimeObservationFlag.val(),
				objSearchPasswordExpirationFlag.val(),
				objSearchWmPrintMode.val(),
				objSearchUsbControlFlag.val(),
				objSearchCdromControlFlag.val(),
				objSearchNetworkServiceControlFlag.val(),
				objSearchSystemPasswordSetupFlag.val(),
				objSearchSystemPasswordExpirationFlag.val(),
				objSearchScreenSaverActivationFlag.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection,
				<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>,
				g_searchListPageNo);

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
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("에이전트 설정 현황 조회", "에이전트 설정 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th rowspan="2" id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th rowspan="2" id="DEPTNAME" class="ui-state-default">부서</th>';
				htmlContents += '<th rowspan="2" id="USERNAME" class="ui-state-default">사용자 명</th>';
				htmlContents += '<th colspan="6" class="ui-state-default">기본 정책</th>';
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("WATERMARKOPTION"))) { %>
				htmlContents += '<th class="ui-state-default">워터마크</th>';
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) { %>
				htmlContents += '<th colspan="2" class="ui-state-default">매체 제어</th>';
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION"))) { %>
				htmlContents += '<th class="ui-state-default">네트워크 서비스 제어</th>';
<% } %>
				htmlContents += '<th colspan="3" class="ui-state-default">시스템 제어</th>';
				htmlContents += '</tr>';
				htmlContents += '<tr>';
				htmlContents += '<th id="JOBPROCESSINGTYPE" class="ui-state-default">검출파일<br />처리유형</th>';
				htmlContents += '<th id="FORCEDTERMINATIONFLAG" class="ui-state-default">강제종료<br />차단</th>';
				htmlContents += '<th id="DECORDINGPERMISSIONFLAG" class="ui-state-default">복호화<br />허용</th>';
				htmlContents += '<th id="CONTENTCOPYPREVENTIONFLAG" class="ui-state-default">복사 방지</th>';
				htmlContents += '<th id="REALTIMEOBSERVATIONFLAG" class="ui-state-default">실시간 감시</th>';
				htmlContents += '<th id="PASSWORDEXPIRATIONFLAG" class="ui-state-default">비밀번호<br />유효기간</th>';
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("WATERMARKOPTION"))) { %>
				htmlContents += '<th id="WMPRINTMODE" class="ui-state-default">출력 모드</th>';
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) { %>
				htmlContents += '<th id="USBCONTROLFLAG" class="ui-state-default">USB 제어</th>';
				htmlContents += '<th id="CDROMCONTROLFLAG" class="ui-state-default">CD-ROM 제어</th>';
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION"))) { %>
				htmlContents += '<th id="NETWORKSERVICECONTROLFLAG" class="ui-state-default">네트워크<br />서비스 제어</th>';
<% } %>
				htmlContents += '<th id="SYSTEMPASSWORDSETUPFLAG" class="ui-state-default">비밀번호<br />설정</th>';
				htmlContents += '<th id="SYSTEMPASSWORDEXPIRATIONFLAG" class="ui-state-default">비밀번호<br />유효기간</th>';
				htmlContents += '<th id="SCREENSAVERACTIVATIONFLAG" class="ui-state-default">화면보호기<br />설정</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				if (resultRecordCount > 0) {
					$(data).find('record').each( function(index) {
						var lineStyle = '';
						if (index%2 == 0)
							lineStyle = "list_odd";
						else
							lineStyle = "list_even";

						var seqNo = $(this).find('seqno').text();
						var companyId = $(this).find('companyid').text();
						var companyName = $(this).find('companyname').text();
						var deptCode = $(this).find('deptcode').text();
						var deptName = $(this).find('deptname').text();
						var userId = $(this).find('userid').text();
						var userName = $(this).find('username').text();
						var jobProcessingType = $(this).find('jobprocessingtype').text();
						var forcedTerminationFlag = $(this).find('forcedterminationflag').text();
						var decordingPermissionFlag = $(this).find('decordingpermissionflag').text();
						var contentCopyPreventionFlag = $(this).find('contentcopypreventionflag').text();
						var realtimeObservationFlag = $(this).find('realtimeobservationflag').text();
						var passwordExpirationFlag = $(this).find('passwordexpirationflag').text();
						var passwordExpirationPeriod = $(this).find('passwordexpirationperiod').text();
						var wmPrintMode = $(this).find('wmprintmode').text();
						var usbControlFlag = $(this).find('usbcontrolflag').text();
						var usbControlType = $(this).find('usbcontroltype').text();
						var cdromControlFlag = $(this).find('cdromcontrolflag').text();
						var cdromControlType = $(this).find('cdromcontroltype').text();
						var networkServiceControlFlag = $(this).find('networkservicecontrolflag').text();
						var systemPasswordSetupFlag = $(this).find('systempasswordsetupflag').text();
						var systemPasswordExpirationFlag = $(this).find('systempasswordexpirationflag').text();
						var systemPasswordExpirationPeriod = $(this).find('systempasswordexpirationperiod').text();
						var screenSaverActivationFlag = $(this).find('screensaveractivationflag').text();
						var screenSaverWaitingMinutes = $(this).find('screensaverwaitingminutes').text();

						htmlContents += '<tr companyid="' + companyId + '" deptcode="' + deptCode + '" userid="' + userId + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userName + '</td>';
						htmlContents += '<td>' + g_htJobProcessingTypeList.get(jobProcessingType) + '</td>';
						htmlContents += '<td>' + g_htOptionMarkList.get(forcedTerminationFlag) + '</td>';
						htmlContents += '<td>' + g_htOptionMarkList.get(decordingPermissionFlag) + '</td>';
						htmlContents += '<td>' + g_htOptionMarkList.get(contentCopyPreventionFlag) + '</td>';
						htmlContents += '<td>' + g_htOptionMarkList.get(realtimeObservationFlag) + '</td>';
						if (passwordExpirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
							htmlContents += '<td>' + passwordExpirationPeriod.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + "일" + '</td>';
						} else {
							htmlContents += '<td>' + g_htOptionMarkList.get(passwordExpirationFlag) + '</td>';
						}
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("WATERMARKOPTION"))) { %>
						htmlContents += '<td>' + g_htPrintModeList.get(wmPrintMode) + '</td>';
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) { %>
						if (usbControlFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
							htmlContents += '<td>' + g_htControlTypeList.get(usbControlType) + '</td>';
						} else {
							htmlContents += '<td>' + g_htOptionMarkList.get(usbControlFlag) + '</td>';
						}
						if (cdromControlFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
							htmlContents += '<td>' + g_htControlTypeList.get(cdromControlType) + '</td>';
						} else {
							htmlContents += '<td>' + g_htOptionMarkList.get(cdromControlFlag) + '</td>';
						}
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION"))) { %>
						htmlContents += '<td>' + g_htOptionMarkList.get(networkServiceControlFlag) + '</td>';
<% } %>
						htmlContents += '<td>' + g_htOptionMarkList.get(systemPasswordSetupFlag) + '</td>';
						if (systemPasswordExpirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
							htmlContents += '<td>' + systemPasswordExpirationPeriod.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + "일" + '</td>';
						} else {
							htmlContents += '<td>' + g_htOptionMarkList.get(systemPasswordExpirationFlag) + '</td>';
						}
						if (screenSaverActivationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
							htmlContents += '<td>' + screenSaverWaitingMinutes.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + "분" + '</td>';
						} else {
							htmlContents += '<td>' + g_htOptionMarkList.get(screenSaverActivationFlag) + '</td>';
						}
						htmlContents += '</tr>';
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var totalPageCount;
					if (totalRecordCount%<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%> == 0) {
						totalPageCount = totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>;
					} else {
						totalPageCount = Math.floor(totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>) + 1;
					}

					if (totalPageCount > 1) {
						objPagination.show();
						objPagination.paging({
							current: g_searchListPageNo,
							max: totalPageCount,
							onclick: function(e, page){
								g_searchListPageNo = page;
								loadAgentConfigStatusList();
							}
						});
					} else {
						objPagination.hide();
					}

					if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
						$('button[name="btnDownload"]').show();
					} else {
						$('button[name="btnDownload"]').hide();
					}

				} else {
					var fullTdSize = 12;
<% if (!AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					fullTdSize = fullTdSize-1;
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("WATERMARKOPTION"))) { %>
					fullTdSize = fullTdSize+1;
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) { %>
					fullTdSize = fullTdSize+2;
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION"))) { %>
					fullTdSize = fullTdSize+1;
<% } %>

					htmlContents += '<tr>';
					htmlContents += '<td colspan="' + fullTdSize + '" align="center"><div style="padding: 10px 0; text-align: center;">등록된 에이전트 설정 현황이 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDownload"]').hide();
				}

				if (objTreeReference.get_selected().attr("node_type") == 'company') {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					$('.inner-center .pane-header').text('사업장 에이전트 설정 현황 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
<% } else { %>
					$('.inner-center .pane-header').text('전체 에이전트 설정 현황');
<% } %>
				} else if (objTreeReference.get_selected().attr("node_type") == 'dept') {
					$('.inner-center .pane-header').text('부서 에이전트 설정 현황 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else if (objTreeReference.get_selected().attr("node_type") == 'user') {
					$('.inner-center .pane-header').text('에이전트 설정 현황 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 에이전트 설정 현황');
				}

				g_objAgentConfigStatusList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("에이전트 설정 현황 조회", "에이전트 설정 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadConfigData = function() {

		var objSearchCondition = g_objAgentConfigStatusList.find('#search-condition');
		var objSearchResult = g_objAgentConfigStatusList.find('#search-result');

		var objSearchJobProcessingType = objSearchCondition.find('select[name="searchjobprocessingtype"]');
		var objSearchForcedTerminationFlag = objSearchCondition.find('select[name="searchforcedterminationflag"]');
		var objSearchDecordingPermissionFlag = objSearchCondition.find('select[name="searchdecordingpermissionflag"]');
		var objSearchContentCopyPreventionFlag = objSearchCondition.find('select[name="searchcontentcopypreventionflag"]');
		var objSearchRealtimeObservationFlag = objSearchCondition.find('select[name="searchrealtimeobservationflag"]');
		var objSearchPasswordExpirationFlag = objSearchCondition.find('select[name="searchpasswordexpirationflag"]');
		var objSearchWmPrintMode = objSearchCondition.find('select[name="searchwmprintmode"]');
		var objSearchUsbControlFlag = objSearchCondition.find('select[name="searchusbcontrolflag"]');
		var objSearchCdromControlFlag = objSearchCondition.find('select[name="searchcdromcontrolflag"]');
		var objSearchNetworkServiceControlFlag = objSearchCondition.find('select[name="searchnetworkservicecontrolflag"]');
		var objSearchSystemPasswordSetupFlag = objSearchCondition.find('select[name="searchsystempasswordsetupflag"]');
		var objSearchSystemPasswordExpirationFlag = objSearchCondition.find('select[name="searchsystempasswordexpirationflag"]');
		var objSearchScreenSaverActivationFlag = objSearchCondition.find('select[name="searchscreensaveractivationflag"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

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

		var postData = getRequestCreateAgentConfigStatusListFileParam(
				targetCompanyId,
				arrTargetDeptList,
				targetUserId,
				objSearchJobProcessingType.val(),
				objSearchForcedTerminationFlag.val(),
				objSearchDecordingPermissionFlag.val(),
				objSearchContentCopyPreventionFlag.val(),
				objSearchRealtimeObservationFlag.val(),
				objSearchPasswordExpirationFlag.val(),
				objSearchWmPrintMode.val(),
				objSearchUsbControlFlag.val(),
				objSearchCdromControlFlag.val(),
				objSearchNetworkServiceControlFlag.val(),
				objSearchSystemPasswordSetupFlag.val(),
				objSearchSystemPasswordExpirationFlag.val(),
				objSearchScreenSaverActivationFlag.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		var currentDate = new Date();
		var downloadFileName = "에이전트 설정 현황 (" + currentDate.formatString("yyyy-MM-dd") + ")";

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
<div class="inner-center">
	<div class="pane-header">에이전트 설정 현황</div>
	<div class="ui-layout-content">
		<div id="agentconfigstatus-list" style="display: none;">
			<div id="search-condition">
				<table class="search-condition-table">
					<colgroup>
						<col width="120" />
						<col />
					</colgroup>
					<tr>
						<th class="ui-state-default">기본 정책</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검출파일 처리유형</td>
									<td><select id="searchjobprocessingtype" name="searchjobprocessingtype" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>강제종료 차단</td>
									<td><select id="searchforcedterminationflag" name="searchforcedterminationflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>복호화 허용</td>
									<td><select id="searchdecordingpermissionflag" name="searchdecordingpermissionflag" class="ui-widget-content"></select></td>
								</tr>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>복사 방지</td>
									<td><select id="searchcontentcopypreventionflag" name="searchcontentcopypreventionflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>실시간 감시</td>
									<td><select id="searchrealtimeobservationflag" name="searchrealtimeobservationflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>비밀번호 유효기간 설정</td>
									<td><select id="searchpasswordexpirationflag" name="searchpasswordexpirationflag" class="ui-widget-content"></select></td>
								</tr>
							</table>
						</td>
					</tr>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("WATERMARKOPTION"))) { %>
					<tr>
						<th class="ui-state-default">워터마크</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>출력 모드</td>
									<td><select id="searchwmprintmode" name="searchwmprintmode" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } else { %>
					<tr style="display: none;">
						<th class="ui-state-default">워터마크</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>출력 모드</td>
									<td><select id="searchwmprintmode" name="searchwmprintmode" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("MEDIACONTROLOPTION"))) { %>
					<tr>
						<th class="ui-state-default">매체 제어</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>USB 제어</td>
									<td><select id="searchusbcontrolflag" name="searchusbcontrolflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>CD-ROM 제어</td>
									<td><select id="searchcdromcontrolflag" name="searchcdromcontrolflag" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } else { %>
					<tr style="display: none;">
						<th class="ui-state-default">매체 제어</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>USB 제어</td>
									<td><select id="searchusbcontrolflag" name="searchusbcontrolflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>CD-ROM 제어</td>
									<td><select id="searchcdromcontrolflag" name="searchcdromcontrolflag" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } %>
<% if (SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE.equals((String) session.getAttribute("NETWORKSERVICECONTROLOPTION"))) { %>
					<tr>
						<th class="ui-state-default">네트워크 서비스 제어</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>네트워크 서비스 제어</td>
									<td><select id="searchnetworkservicecontrolflag" name="searchnetworkservicecontrolflag" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } else { %>
					<tr style="display: none;">
						<th class="ui-state-default">네트워크 서비스 제어</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>네트워크 서비스 제어</td>
									<td><select id="searchnetworkservicecontrolflag" name="searchnetworkservicecontrolflag" class="ui-widget-content"></select></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
<% } %>
					<tr>
						<th class="ui-state-default">시스템 제어</th>
						<td>
							<table class="search-condition-table">
								<colgroup>
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
									<col width="20%" />
									<col />
								</colgroup>
								<tr>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>비밀번호 설정</td>
									<td><select id="searchsystempasswordsetupflag" name="searchsystempasswordsetupflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>비밀번호 유효기간 설정</td>
									<td><select id="searchsystempasswordexpirationflag" name="searchsystempasswordexpirationflag" class="ui-widget-content"></select></td>
									<td><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>화면보호기 설정</td>
									<td><select id="searchscreensaveractivationflag" name="searchscreensaveractivationflag" class="ui-widget-content"></select></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div class="button-line" style="margin-top: 5px;">
				<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button>
			</div>
			<div class="clear"></div>
			<div id="search-result">
				<div id="result-list"></div>
				<div id="list-pagination" class="div-pagination">
					<div id="pagination" class="pagination"></div>
					<div id="totalrecordcount" class="total-record-count"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">목록 다운로드</button>
		</div>
	</div>
</div>
