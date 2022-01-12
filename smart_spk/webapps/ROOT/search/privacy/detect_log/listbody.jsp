<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="detectlog-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
	var g_objOrganizationTree;
	var g_objDetectLogList;

	var g_htUserTypeList = new Hashtable();
	var g_htSearchTypeList = new Hashtable();
	var g_htDetectStateList = new Hashtable();
	var g_htResultStateList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objDetectLogList = $('#detectlog-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		//$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				var selectedSearchDateFrom = new Date(selectedDate);
				var selectedSearchDateTo = new Date($('#searchdateto').val());
				if (selectedSearchDateTo.diffDays(selectedSearchDateFrom, "d") > 30) {
					var newSearchDateTo = selectedSearchDateFrom;
					newSearchDateTo.addDate("d", 30)
					$('#searchdateto').val(newSearchDateTo.formatString('yyyy-MM-dd'));
					$('#searchdatefrom').datepicker('option', 'maxDate', newSearchDateTo);
				}
				$('#searchdateto').datepicker('option', 'minDate', selectedDate);
				//$('button[name="btnDownload"]').hide();
			}
		});

		$('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				var selectedSearchDateFrom = new Date($('#searchdatefrom').val());
				var selectedSearchDateTo = new Date(selectedDate);
				if (selectedSearchDateTo.diffDays(selectedSearchDateFrom, "d") > 30) {
					var newSearchDateFrom = selectedSearchDateTo;
					newSearchDateFrom.addDate("d", -30)
					$('#searchdatefrom').val(newSearchDateFrom.formatString('yyyy-MM-dd'));
					$('#searchdateto').datepicker('option', 'minDate', newSearchDateFrom);
				}
				$('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
				//$('button[name="btnDownload"]').hide();
			}
		});

		var tmpDate = new Date();
		tmpDate.addDate("d", -6);
		$('#searchdatefrom').datepicker('setDate', tmpDate);
		$('#searchdateto').datepicker('option', 'minDate', tmpDate);
		$('#searchdateto').datepicker('setDate', new Date());

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

		g_htSearchTypeList = loadTypeList("SEARCH_TYPE");
		if (g_htSearchTypeList.isEmpty()) {
			displayAlertDialog("검사 유형 조회", "검사 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htDetectStateList = loadTypeList("DETECT_STATE");
		if (g_htDetectStateList.isEmpty()) {
			displayAlertDialog("검출 상태 유형 조회", "검출 상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htResultStateList = loadTypeList("RESULT_STATE");
		if (g_htResultStateList.isEmpty()) {
			displayAlertDialog("처리 상태 유형 조회", "처리 상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objDetectLogList.find('#search-condition').find('select[name="searchusertype"]'), g_htUserTypeList, null, "전체");
		fillDropdownList(g_objDetectLogList.find('#search-condition').find('select[name="searchsearchtype"]'), g_htSearchTypeList, null, "전체");
		fillDropdownList(g_objDetectLogList.find('#search-condition').find('select[name="searchdetectstatus"]'), g_htDetectStateList, null, "전체");
		fillDropdownList(g_objDetectLogList.find('#search-condition').find('select[name="searchresultstate"]'), g_htResultStateList, null, "전체");
		//g_objDetectLogList.find('#search-condition').find('select[name="searchresultstate"]').find('[value="' + <%=ResultState.RESULT_STATE_SEND_SERVER%> + '"]').remove();
		g_objDetectLogList.find('#search-condition').find('select[name="searchresultstate"]').find('[value="' + <%=ResultState.RESULT_STATE_PROCESS_FAIL%> + '"]').remove();
		g_objDetectLogList.find('#search-condition').find('select[name="searchresultstate"]').find('[value="' + <%=ResultState.RESULT_STATE_SEARCH_FAIL%> + '"]').remove();

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadDetectLogList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadDetectLogList();
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
			if ($(this).is(":checked")) {
				var objTreeReference = $.jstree._reference(g_objOrganizationTree);
				if (objTreeReference.get_selected().attr('node_type') == "dept") {
					objTreeReference.open_all(objTreeReference.get_selected());
				}
			}
			loadDetectLogList();
		});

		$('#search-condition').find('input').keyup( function() {
			//$('button[name="btnDownload"]').hide();
		});

		$('#search-condition').find('select').change( function() {
			//$('button[name="btnDownload"]').hide();
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('seqno') != typeof undefined) { openDetectLogInfoDialog($(this).attr('seqno')); } });
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
					loadDetectLogList();
				}
			}
		});
	};

	loadDetectLogList = function() {

		var objSearchCondition = g_objDetectLogList.find('#search-condition');
		var objSearchResult = g_objDetectLogList.find('#search-result');

		var objSearchSearchId = objSearchCondition.find('input[name="searchsearchid"]');
		var objSearchSearchType = objSearchCondition.find('select[name="searchsearchtype"]');
		var objSearchUserType = objSearchCondition.find('select[name="searchusertype"]');
		var objSearchDetectStatus = objSearchCondition.find('select[name="searchdetectstatus"]');
		var objSearchResultState = objSearchCondition.find('select[name="searchresultstate"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

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

		var postData = getRequestDetectLogListParam(
				targetCompanyId,
				arrTargetDeptList,
				targetUserId,
				objSearchSearchId.val(),
				objSearchSearchType.val(),
				objSearchUserType.val(),
				objSearchDetectStatus.val(),
				objSearchResultState.val(),
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
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
					displayAlertDialog("검출 목록 조회", "검출 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th width="12%" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th width="12%" class="ui-state-default">부서</th>';
				htmlContents += '<th width="12%" class="ui-state-default">사용자</th>';
				htmlContents += '<th width="65" class="ui-state-default">사용자 유형</th>';
				htmlContents += '<th width="65" class="ui-state-default">검사 유형</th>';
				htmlContents += '<th width="70" class="ui-state-default">검사일</th>';
				htmlContents += '<td class="ui-state-default">검출 파일</th>';
				htmlContents += '<th width="50" class="ui-state-default">검출 상태</th>';
				htmlContents += '<th width="50" class="ui-state-default">처리 상태</th>';
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
						var companyName = $(this).find('companyname').text();
						var deptName = $(this).find('deptname').text();
						var userName = $(this).find('username').text();
						var userType = $(this).find('usertype').text();
						var searchType = $(this).find('searchtype').text();
						var searchId = $(this).find('searchid').text();
						var searchDate = $(this).find('searchdate').text();
						var searchPath = $(this).find('searchpath').text();
						var searchFileName = searchPath.substring(searchPath.lastIndexOf("\\")+1,searchPath.length);
						var detectStatus = $(this).find('detectstatus').text();
						var result = $(this).find('result').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htUserTypeList.get(userType) + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htSearchTypeList.get(searchType) + '</td>';
						htmlContents += '<td style="text-align:center;">' + searchDate + '</td>';
						htmlContents += '<td title="' + searchPath + '">' + searchFileName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htDetectStateList.get(detectStatus) + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htResultStateList.get(result) + '</td>';
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
								loadDetectLogList();
							}
						});
					} else {
						objPagination.hide();
					}

					if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
						//$('button[name="btnDownload"]').show();
					} else {
						//$('button[name="btnDownload"]').hide();
					}
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="9" align="center"><div style="padding: 10px 0; text-align: center;">등록된 검출 목록이 존재하지 않습니다.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="8" align="center"><div style="padding: 10px 0; text-align: center;">등록된 검출 목록이 존재하지 않습니다.</div></td>';
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					//$('button[name="btnDownload"]').hide();
				}

				if (objTreeReference.get_selected().attr("node_type") == 'company') {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					$('.inner-center .pane-header').text('사업장 검출 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
<% } else { %>
					$('.inner-center .pane-header').text('전체 검출 목록');
<% } %>
				} else if (objTreeReference.get_selected().attr("node_type") == 'dept') {
					$('.inner-center .pane-header').text('부서 검출 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else if (objTreeReference.get_selected().attr("node_type") == 'user') {
					$('.inner-center .pane-header').text('사용자 검출 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 사업장 검출 목록');
				}

				g_objDetectLogList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("검출 목록 조회", "검출 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadDetectLogList = function() {

		var objSearchCondition = g_objDetectLogList.find('#search-condition');

		var objSearchSearchId = objSearchCondition.find('input[name="searchsearchid"]');
		var objSearchSearchType = objSearchCondition.find('select[name="searchsearchtype"]');
		var objSearchUserType = objSearchCondition.find('select[name="searchusertype"]');
		var objSearchDetectStatus = objSearchCondition.find('select[name="searchdetectstatus"]');
		var objSearchResultState = objSearchCondition.find('select[name="searchresultstate"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

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

		var postData = getRequestCreateDetectLogListFileParam(
				targetCompanyId,
				arrTargetDeptList,
				targetUserId,
				objSearchSearchId.val(),
				objSearchSearchType.val(),
				objSearchUserType.val(),
				objSearchDetectStatus.val(),
				objSearchResultState.val(),
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		var downloadFileName = "검출 목록";
		if ((objSearchDateFrom.val().length > 0) || (objSearchDateTo.val().length > 0)) {
			downloadFileName += " (" + objSearchDateFrom.val() + "~" + objSearchDateTo.val() + ")";
		}
		openDownloadDialog("검출 목록", downloadFileName, postData);
	};
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
	<div class="pane-header">전체 사업장 검출 목록</div>
	<div class="ui-layout-content">
		<div id="detectlog-list" style="display: none;">
			<div id="search-condition">
				<table class="search-condition-table">
				<colgroup>
					<col width="100" />
					<col />
					<col width="100" />
					<col />
					<col width="100" />
					<col />
				</colgroup>
				<tr>
					<td class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 ID</td>
					<td><input type="text" id="searchsearchid" name="searchsearchid" class="text ui-widget-content" /></td>
					<td class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 유형</td>
					<td><select id="searchsearchtype" name="searchsearchtype" class="ui-widget-content"></select></td>
					<td style="display: none;" class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사용자 유형</td>
					<td style="display: none;"><select id="searchusertype" name="searchusertype" class="ui-widget-content"></select></td>
				</tr>
				<tr>
					<td class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검출 상태</td>
					<td><select id="searchdetectstatus" name="searchdetectstatus" class="ui-widget-content"></select></td>
					<td class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>처리 상태</td>
					<td><select id="searchresultstate" name="searchresultstate" class="ui-widget-content"></select></td>
					<td class="ui-state-default"><ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간</td>
					<td>
						<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content input-date" readonly="readonly" />
						~ <input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content input-date" readonly="readonly" />
					</td>
				</tr>
				</table>
			</div>
			<div class="button-line" style="margin-top: 5px;">
				<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button>
			</div>


<!-- 			<div id="search-condition" class="inline-search-condition"> -->
<!-- 				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 ID -->
<!-- 				<input type="text" id="searchsearchid" name="searchsearchid" class="text ui-widget-content" /> -->
<!-- 				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 유형 -->
<!-- 				<select id="searchsearchtype" name="searchsearchtype" class="ui-widget-content"></select> -->
<!-- 				<div style="display: none;"> -->
<!-- 					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사용자 유형 -->
<!-- 					<select id="searchusertype" name="searchusertype" class="ui-widget-content"></select> -->
<!-- 				</div> -->
<!-- 				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검출 상태 -->
<!-- 				<select id="searchdetectstatus" name="searchdetectstatus" class="ui-widget-content"></select> -->
<!-- 				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>처리 상태 -->
<!-- 				<select id="searchresultstate" name="searchresultstate" class="ui-widget-content"></select> -->
<!-- 				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간 -->
<!-- 				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content" style="width: 80px; text-align: center;" readonly="readonly" /> -->
<!-- 				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content" style="width: 80px; text-align: center;" readonly="readonly" /> -->
<!-- 				<span class="search-button"> -->
<!-- 					<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button> -->
<!-- 				</span> -->
<!-- 			</div> -->
			<div id="search-result">
				<div id="result-list"></div>
				<div id="list-pagination" class="div-pagination">
					<div id="pagination" class="pagination"></div>
					<div id="totalrecordcount" class="total-record-count"></div>
				</div>
			</div>
		</div>
	</div>
<!-- 	<div class="ui-state-default pane-footer"> -->
<!-- 		<div class="button-line"> -->
<!-- 			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">목록 다운로드</button> -->
<!-- 		</div> -->
<!-- 	</div> -->
</div>
