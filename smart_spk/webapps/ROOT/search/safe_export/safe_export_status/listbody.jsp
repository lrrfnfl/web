<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="safeexport-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objSafeExportList;

	var g_htOptionTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objSafeExportList = $('#safeexport-list');

		$( document ).tooltip();

		$('input:button, input:submit, button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

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

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("?????? ?????? ??????", "?????? ?????? ?????? ??? ????????? ?????????????????????.", "????????? ????????? ????????? ??????????????? ????????? ????????????.");
		}

		fillDropdownList(g_objSafeExportList.find('#search-condition').find('select[name="searchdecodestatus"]'), g_htOptionTypeList, null, "??????");

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadSafeExportList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadSafeExportList();
			}
		});

		$('input[name="includechilddept"]:checkbox').click( function() {
			loadSafeExportList();
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
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('seqno') != typeof undefined) { openSafeExportInfoDialog($(this).attr('seqno')); } });
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
					displayAlertDialog("????????? ?????? ??????", "????????? ?????? ?????? ??? ????????? ?????????????????????.", $(data).find('errormsg').text());
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
					displayAlertDialog("????????? ?????? ??????", "????????? ?????? ?????? ??? ????????? ?????????????????????.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
		xmlTreeData += '<content><name><![CDATA[?????? ?????????]]></name></content>';
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
							displayAlertDialog("?????? ????????? ??????", "?????? ????????? ?????? ??? ????????? ?????????????????????.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("?????? ????????? ??????", "?????? ????????? ?????? ??? ????????? ?????????????????????.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') != "company_category") {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadSafeExportList();
				}
			}
		});
	};

	loadSafeExportList = function() {

		var objSearchCondition = g_objSafeExportList.find('#search-condition');
		var objSearchResult = g_objSafeExportList.find('#search-result');

		var objSearchReveiver = objSearchCondition.find('input[name="searchreceiver"]');
		var objSearchDecodeStatus = objSearchCondition.find('select[name="searchdecodestatus"]');
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
		}

		var targetUserId = "";
		if (typeof objTreeReference.get_selected().attr('userid') != typeof undefined) {
			targetUserId = objTreeReference.get_selected().attr('userid');
		}

		if (objSearchReveiver.val().length > 0) {
			if (!isValidParam(objSearchReveiver, PARAM_TYPE_SEARCH_KEYWORD, "?????????", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchReveiver.hasClass('ui-state-error'))
			objSearchReveiver.removeClass('ui-state-error');
		}

		var postData = getRequestSafeExportListParam(targetCompanyId,
			arrTargetDeptList,
			targetUserId,
			objSearchReveiver.val(),
			objSearchDecodeStatus.val(),
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
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> ?????????...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("???????????? ?????? ??????", "???????????? ?????? ?????? ??? ????????? ?????????????????????.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">?????????</th>';
<% } %>
				htmlContents += '<th id="DEPTNAME" class="ui-state-default">??????</th>';
				htmlContents += '<th id="USERNAME" class="ui-state-default">?????????</th>';
				htmlContents += '<th id="RECEIVER" class="ui-state-default">?????????</th>';
				htmlContents += '<th id="RECEIVEREMAIL" class="ui-state-default">????????? Email</th>';
				htmlContents += '<th id="EXPORTFILESCOUNT" class="ui-state-default">?????? ?????? ???</th>';
				htmlContents += '<th id="DECODESTATUS" class="ui-state-default">????????? ??????</th>';
				htmlContents += '<th id="CREATEDATETIME" class="ui-state-default">?????? ????????????</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ ?????? ????????? ???: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " ??? ]");

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
						var receiver = $(this).find('receiver').text();
						var receiverEmail = $(this).find('receiveremail').text();
						var exportFilesCount = $(this).find('exportfilescount').text();
						var decodeStatus = $(this).find('decodestatus').text();
						var createDatetime = $(this).find('createdatetime').text();

						if (exportFilesCount.length == 0)
							exportFilesCount = 0;

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userName + '</td>';
						htmlContents += '<td title="' + receiver + '">' + receiver + '</td>';
						htmlContents += '<td title="' + receiverEmail + '">' + receiverEmail + '</td>';
						htmlContents += '<td style="text-align: right;">' + exportFilesCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
						htmlContents += '<td style="text-align: center;">' + g_htOptionTypeList.get(decodeStatus) + '</td>';
						htmlContents += '<td style="text-align: center;">' + createDatetime + '</td>';
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
								loadSafeExportList();
							}
						});
					} else {
						objPagination.hide();
					}
					$('button[name="btnDownload"]').show();
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="8" align="center"><div style="padding: 10px 0; text-align: center;">????????? ???????????? ????????? ???????????? ????????????.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="7" align="center"><div style="padding: 10px 0; text-align: center;">????????? ???????????? ????????? ???????????? ????????????.</div></td>';
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDownload"]').hide();
				}

				if (objTreeReference.get_selected().attr("node_type") == 'company') {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					$('.inner-center .pane-header').text('????????? ???????????? ?????? - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
<% } else { %>
					$('.inner-center .pane-header').text('?????? ???????????? ??????');
<% } %>
				} else if (objTreeReference.get_selected().attr("node_type") == 'dept') {
					$('.inner-center .pane-header').text('?????? ???????????? ?????? - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else if (objTreeReference.get_selected().attr("node_type") == 'user') {
					$('.inner-center .pane-header').text('????????? ???????????? ?????? - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('?????? ????????? ???????????? ??????');
				}

				g_objSafeExportList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("???????????? ?????? ??????", "???????????? ?????? ?????? ??? ????????? ?????????????????????.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadSafeExportList = function() {

		var objSearchCondition = g_objSafeExportList.find('#search-condition');

		var objSearchReveiver = objSearchCondition.find('input[name="searchreceiver"]');
		var objSearchDecodeStatus = objSearchCondition.find('select[name="searchdecodestatus"]');
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
		}

		var targetUserId = "";
		if (typeof objTreeReference.get_selected().attr('userid') != typeof undefined) {
			targetUserId = objTreeReference.get_selected().attr('userid');
		}

		if (objSearchReveiver.val().length > 0) {
			if (!isValidParam(objSearchReveiver, PARAM_TYPE_SEARCH_KEYWORD, "?????????", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchReveiver.hasClass('ui-state-error'))
			objSearchReveiver.removeClass('ui-state-error');
		}

		var postData = getRequestCreateSafeExportListFileParam(targetCompanyId,
			arrTargetDeptList,
			targetUserId,
			objSearchReveiver.val(),
			objSearchDecodeStatus.val(),
			objSearchDateFrom.val(),
			objSearchDateTo.val(),
			g_searchListOrderByName,
			g_searchListOrderByDirection);

		openDownloadDialog("???????????? ??????", postData);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header ui-widget-header ui-corner-top">
		<div style="float: left; font-weight: bold;">?????? ?????????</div>
		<div style="float: right; font-weight: normal;"><input type="checkbox" id="includechilddept" name="includechilddept" style="vertical-align: top; width: 12px; height: 12px;"/><label for="includechilddept"> ???????????? ??????</label></div>
		<div class="clear"></div>
	</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom" style="padding: 0;">
		<div id="organization-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header ui-widget-header ui-corner-top">?????? ????????? ???????????? ??????</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom">
		<div id="safeexport-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>?????????
				<input type="text" id="searchreceiver" name="searchreceiver" class="text ui-widget-content ui-corner-all" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>????????? ??????
				<select id="searchdecodestatus" name="searchdecodestatus" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>?????? ??????
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">??? ???</button>
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
	<div class="ui-state-default pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">?????? ????????????</button>
		</div>
	</div>
</div>
