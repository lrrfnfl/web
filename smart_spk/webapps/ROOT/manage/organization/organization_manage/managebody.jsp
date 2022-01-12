<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="dept-dialog.jsp"%>
<%@ include file ="user-dialog.jsp"%>
<%@ include file ="resetuserpassword-dialog.jsp"%>
<%@ include file ="batchupdateuserdept-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objUserList;

	var g_htUserTypeList = new Hashtable();
	var g_htInstallStateList = new Hashtable();
	var g_htServiceStateList = new Hashtable();
	var g_htTargetUserTypeList = new Hashtable();
	var g_htCompanyList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objUserList = $('#user-list');

		$( document).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnNewDept"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDeptInfo"]').button({ icons: {primary: "ui-icon-info"} });
		$('button[name="btnBatchUpdateUserDept"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnBatchDeleteUser"]').button({ icons: {primary: "ui-icon-trash"} });
		$('button[name="btnNewUser"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htUserTypeList = loadTypeList("USER_TYPE");
		if (g_htUserTypeList.isEmpty()) {
			displayAlertDialog("사용자 유형 조회", "사용자 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htInstallStateList = loadTypeList("INSTALL_STATE");
		if (g_htInstallStateList.isEmpty()) {
			displayAlertDialog("설치상태 유형 조회", "설치상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htServiceStateList = loadTypeList("SERVICE_STATE");
		if (g_htServiceStateList.isEmpty()) {
			displayAlertDialog("서비스 상태 유형 조회", "서비스 상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htTargetUserTypeList = loadTypeList("TARGET_USER_TYPE");
		if (g_htTargetUserTypeList.isEmpty()) {
			displayAlertDialog("대상 유형 조회", "대상 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objUserList.find('#search-condition').find('select[name="searchusertype"]'), g_htUserTypeList, null, "전체");
		fillDropdownList(g_objUserList.find('#search-condition').find('select[name="searchinstallflag"]'), g_htInstallStateList, null, "전체");
		fillDropdownList(g_objUserList.find('#search-condition').find('select[name="searchservicestate"]'), g_htServiceStateList, null, "전체");

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnNewDept') {
				openNewDeptDialog();
			} else if ($(this).attr('id') == 'btnDeptInfo') {
				openDeptInfoDialog();
			} else if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadUserList();
			} else if ($(this).attr('id') == 'btnBatchUpdateUserDept') {
				if (g_objUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').length == 0) {
					displayAlertDialog("부서 변경", "부서를 변경할 사용자를 선택해 주세요.", "");
				} else {
					openBatchUpdateUserDeptDialog();
				}
			} else if ($(this).attr('id') == 'btnBatchDeleteUser') {
				if (g_objUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').length == 0) {
					displayAlertDialog("사용자 삭제", "삭제할 사용자를 선택해 주세요.", "");
				} else {
					displayConfirmDialog("사용자 삭제", "선택한 사용자들을 삭제 하시겠습니까?", "", function() { batchDeleteUser(); });
				}
			} else if ($(this).attr('id') == 'btnNewUser') {
				openNewUserDialog();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadUserList();
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
			if ($(this).is(":checked")) {
				var objTreeReference = $.jstree._reference(g_objOrganizationTree);
				if (objTreeReference.get_selected().attr('node_type') == "dept") {
					objTreeReference.open_all(objTreeReference.get_selected());
				}
			}
			loadUserList();
		});

		$('#search-condition').find('input').keyup( function() {
			$('button[name="btnDownload"]').hide();
		});

		$('#search-condition').find('select').change( function() {
			$('button[name="btnDownload"]').hide();
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });

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
				}
				if (!g_htList.isEmpty()) g_htList.clear();
				$(data).find('record').each( function() {
					g_htList.put($(this).find('deptcode').text(), $(this).find('deptname').text());
				});
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
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadUserList();
				}
			}
			if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
				$('button[name="btnNewDept"]').show();
				$('button[name="btnNewUser"]').show();
				if (typeof data.rslt.obj.attr('deptcode') != typeof undefined) {
					$('button[name="btnDeptInfo"]').show();
				} else {
					$('button[name="btnDeptInfo"]').hide();
				}
			} else {
				$('button[name="btnNewDept"]').hide();
				$('button[name="btnNewUser"]').hide();
				$('button[name="btnDeptInfo"]').hide();
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
		});
	};

	loadUserList = function() {

		var objSearchCondition = g_objUserList.find('#search-condition');
		var objSearchResult = g_objUserList.find('#search-result');

		var objSearchUserName = objSearchCondition.find('input[name="searchusername"]');
		var objSearchUserType = objSearchCondition.find('select[name="searchusertype"]');
		var objSearchInstallFlag = objSearchCondition.find('select[name="searchinstallflag"]');
		var objSearchServiceState = objSearchCondition.find('select[name="searchservicestate"]');

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
		}

		if (objSearchUserName.val().length > 0) {
			if (!isValidParam(objSearchUserName, PARAM_TYPE_SEARCH_KEYWORD, "사용자 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchUserName.hasClass('ui-state-error'))
				objSearchUserName.removeClass('ui-state-error');
		}

		var postData = getRequestUserListParam(
				targetCompanyId,
				arrTargetDeptList,
				objSearchUserName.val(),
				objSearchUserType.val(),
				objSearchInstallFlag.val(),
				objSearchServiceState.val(),
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
					displayAlertDialog("사용자 목록 조회", "사용자 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="40" class="ui-state-default" style="text-align: center;">';
				if (resultRecordCount > 0) {
					htmlContents += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur()">';
				} else {
					htmlContents += '&nbsp;';
				}
				htmlContents += '</th>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th id="DEPTNAME" class="ui-state-default">부서</th>';
				htmlContents += '<th id="USERID" class="ui-state-default">사용자 ID</th>';
				htmlContents += '<th id="USERNAME" class="ui-state-default">사용자 명</th>';
				htmlContents += '<th id="USERTYPE" class="ui-state-default">사용자 유형</th>';
				htmlContents += '<th id="INSTALLFLAG" class="ui-state-default">설치 상태</th>';
				htmlContents += '<th id="SERVICESTATEFLAG" class="ui-state-default">서비스 상태</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

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
						var userId = $(this).find('userid').text();
						var userName = $(this).find('username').text();
						var deptName = $(this).find('deptname').text();
						var userType = $(this).find('usertype').text();
						var installFlag = $(this).find('installflag').text();
						var serviceStateFlag = $(this).find('servicestateflag').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
						htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" userid="' + userId + '" style="border: 0;"></td>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userId + '</td>';
						htmlContents += '<td>' + userName + '</td>';
						htmlContents += '<td style="text-align: center;">' + g_htUserTypeList.get(userType) + '</td>';
						htmlContents += '<td style="text-align: center;">' + g_htInstallStateList.get(installFlag) + '</td>';
						if (serviceStateFlag == "<%=ServiceState.SERVICE_STATE_STOP%>") {
							htmlContents += '<td class="state-abnormal" style="text-align: center;">' + g_htServiceStateList.get(serviceStateFlag) + '</td>';
						} else {
							htmlContents += '<td style="text-align: center;">' + g_htServiceStateList.get(serviceStateFlag) + '</td>';
						}
						htmlContents += '</tr>';
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objUserList.find('.list-table thead tr th:first-child').click( function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });";
					inlineScriptText += "g_objUserList.find('.list-table tbody tr td:first-child').click( function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; e.stopPropagation(); });";
					inlineScriptText += "g_objUserList.find('.list-table tbody tr').click( function () { openUserInfoDialog($(this).attr('seqno')); });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objResultList.append(inlineScript);

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
								loadUserList();
							}
						});
					} else {
						objPagination.hide();
					}

					if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
						$('button[name="btnBatchUpdateUserDept"]').show();
						$('button[name="btnBatchDeleteUser"]').show();
						$('button[name="btnDownload"]').show();
					} else {
						$('button[name="btnBatchUpdateUserDept"]').hide();
						$('button[name="btnBatchDeleteUser"]').hide();
						$('button[name="btnDownload"]').hide();
					}
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="8" align="center"><div style="padding: 10px 0; text-align: center;">등록된 사용자가 없습니다.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="7" align="center"><div style="padding: 10px 0; text-align: center;">등록된 사용자가 없습니다.</div></td>';
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnBatchUpdateUserDept"]').hide();
					$('button[name="btnBatchDeleteUser"]').hide();
					$('button[name="btnDownload"]').hide();
				}

				if (objTreeReference.get_selected().attr("node_type") == 'company') {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					$('.inner-center .pane-header').text('사업장 사용자 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
<% } else { %>
					$('.inner-center .pane-header').text('전체 사용자 목록');
<% } %>
				} else if (objTreeReference.get_selected().attr("node_type") == 'dept') {
					$('.inner-center .pane-header').text('부서 사용자 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 사업장 사용자 목록');
				}

				g_objUserList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 목록 조회", "사용자 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	batchDeleteUser = function() {

		var arrTargetUserList = new Array();

		g_objUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').each( function () {
			var arrTargetUser = new Array();
			arrTargetUser.push($(this).attr('companyid'));
			arrTargetUser.push($(this).attr('userid'));
			arrTargetUserList.push(arrTargetUser);
		});

		var postData = getRequestBatchDeleteUserParam('<%=(String)session.getAttribute("ADMINID")%>', arrTargetUserList);

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
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 삭제", "사용자 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					objTreeReference.deselect_node(selectedNode);
					objTreeReference.select_node(selectedNode);
					displayInfoDialog("사용자 삭제", "정상 처리되었습니다.", "정상적으로 사용자가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 삭제", "사용자 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadUserList = function() {

		var objSearchCondition = g_objUserList.find('#search-condition');

		var objSearchUserName = objSearchCondition.find('input[name="searchusername"]');
		var objSearchUserType = objSearchCondition.find('select[name="searchusertype"]');
		var objSearchInstallFlag = objSearchCondition.find('select[name="searchinstallflag"]');
		var objSearchServiceState = objSearchCondition.find('select[name="searchservicestate"]');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		if (objSearchUserName.val().length > 0) {
			if (!isValidParam(objSearchUserName, PARAM_TYPE_SEARCH_KEYWORD, "사용자 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchUserName.hasClass('ui-state-error'))
				objSearchUserName.removeClass('ui-state-error');
		}

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

		var postData = getRequestCreateUserListFileParam(
				targetCompanyId,
				arrTargetDeptList,
				objSearchUserName.val(),
				objSearchUserType.val(),
				objSearchInstallFlag.val(),
				objSearchServiceState.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		openDownloadDialog("사용자 목록", "사용자 목록", postData);
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
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnNewDept" name="btnNewDept" class="normal-button" style="display: none;">신규 부서</button>
			<button type="button" id="btnDeptInfo" name="btnDeptInfo" class="normal-button" style="display: none;">부서 정보</button>
		</div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 사업장 사용자 목록</div>
	<div class="ui-layout-content">
		<div id="user-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사용자 명
				<input type="text" id="searchusername" name="searchusername" class="text ui-widget-content" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사용자 유형
				<select id="searchusertype" name="searchusertype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>설치 상태
				<select id="searchinstallflag" name="searchinstallflag" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>서비스 상태
				<select id="searchservicestate" name="searchservicestate" class="ui-widget-content"></select>
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button>
				</span>
			</div>
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
			<button type="button" id="btnNewUser" name="btnNewUser" class="normal-button" style="display: none;">신규 사용자</button>
			<button type="button" id="btnBatchUpdateUserDept" name="btnBatchUpdateUserDept" class="normal-button" style="display: none;">부서 변경</button>
			<button type="button" id="btnBatchDeleteUser" name="btnBatchDeleteUser" class="normal-button" style="display: none;">사용자 삭제</button>
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">사용자 목록 다운로드</button>
		</div>
	</div>
</div>
