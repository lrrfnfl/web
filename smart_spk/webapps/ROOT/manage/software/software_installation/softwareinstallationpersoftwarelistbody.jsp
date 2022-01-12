<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="softwareinstallation-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objSoftwareInstallationTree;
	var g_objSoftwareInstallationList;

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objSoftwareInstallationTree = $('#softwareinstallation-tree');
		g_objSoftwareInstallationList = $('#softwareinstallation-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		//$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdateto').datepicker('option', 'minDate', selectedDate);
				//$('button[name="btnDownload"]').hide();
			}
		});

		$('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
				//$('button[name="btnDownload"]').hide();
			}
		});

// 		var tmpDate = new Date();
// 		tmpDate.addDate("d", -6);
// 		$('#searchdatefrom').datepicker('setDate', tmpDate);
		$('#searchdateto').datepicker('setDate', new Date());

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		fillDropdownList(g_objSoftwareInstallationList.find('#search-condition').find('select[name="searchdept"]'), null, null, "전체");
<% } else { %>
		var htDeptList = new Hashtable();
		htDeptList = loadDeptList("<%=(String)session.getAttribute("COMPANYID")%>");
		fillDropdownList(g_objSoftwareInstallationList.find('select[name="searchdept"]'), htDeptList, null, "전체");
<% } %>

		innerDefaultLayout.show("west");
		loadSoftwareInstallationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadSoftwareInstallationList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadSoftwareInstallationList();
			}
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
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('seqno') != typeof undefined) { openSoftwareInstallationInfoDialog($(this).attr('seqno')); } });
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

				$(data).find('record').each(function() {
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
		var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_SOFTWARE_INSTALLATION%>', '', companyId);

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

	loadSoftwareInstallationTreeView = function() {

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

		g_objSoftwareInstallationTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							if (node.attr("node_type") == 'company_category') {
								var categoryCode = node.children('a').text().trim();
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_SOFTWARE_INSTALLATION%>', categoryCode, '');
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'company') {
								var postData = getRequestSoftwareInstallationTreeNodesParam(node.attr('companyid'));
								return {
									sendmsg : postData
								};
							} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_SOFTWARE_INSTALLATION%>', '', '');
<% } else { %>
								var postData = getRequestSoftwareInstallationTreeNodesParam('<%=(String)session.getAttribute("COMPANYID")%>');
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
							displayAlertDialog("소프트웨어 설치 구성도 조회", "소프트웨어 설치 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("소프트웨어 설치 구성도 조회", "소프트웨어 설치 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
				if (data.rslt.obj.attr('node_type') != "company_category") {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadSoftwareInstallationList();
				}
			}
			if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
				if (g_oldSelectedTreeNode.attr('companyid') != data.rslt.obj.attr('companyid')) {
					var htDeptList = new Hashtable();
					htDeptList = loadDeptList(data.rslt.obj.attr('companyid'));
					fillDropdownList(g_objSoftwareInstallationList.find('select[name="searchdept"]'), htDeptList, null, "전체");
					g_objSoftwareInstallationList.find('#search-condition').find('#row-searchdept').show();
				}
			} else {
				fillDropdownList(g_objSoftwareInstallationList.find('select[name="searchdept"]'), null, null, "전체");
				g_objSoftwareInstallationList.find('#search-condition').find('#row-searchdept').hide();
			}
		});
	};

	loadSoftwareInstallationList = function() {

		var objSearchCondition = g_objSoftwareInstallationList.find('#search-condition');
		var objSearchResult = g_objSoftwareInstallationList.find('#search-result');

		var objSearchDept = objSearchCondition.find('select[name="searchdept"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objSoftwareInstallationTree);

		var targetCompanyId = "";
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var arrTargetDeptList = new Array();
		if (objSearchDept.val().length > 0)
			arrTargetDeptList.push(objSearchDept.val());

		var targetSoftwareName = "";
		if (objTreeReference.get_selected().attr("node_type") == 'software') {
			targetSoftwareName = objTreeReference.get_text(objTreeReference.get_selected()); 
		}

		if (typeof objTreeReference.get_selected().attr('softwarename') != typeof undefined) {
			targetSoftwareName = objTreeReference.get_selected().attr('softwarename');
		}

		var postData = getRequestSoftwareInstallationListParam(
				targetCompanyId,
				arrTargetDeptList,
				"",
				targetSoftwareName,
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
					displayAlertDialog("소프트웨어 설치 목록 조회", "소프트웨어 설치 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th width="12%" id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th width="12%" id="DEPTNAME" class="ui-state-default">부서</th>';
				htmlContents += '<th width="12%" id="USERNAME" class="ui-state-default">사용자</th>';
				htmlContents += '<th id="SOFTWARENAME" class="ui-state-default">소프트웨어 명</th>';
				htmlContents += '<th width="12%" id="VERSION" class="ui-state-default">버전</th>';
				htmlContents += '<th width="15%" id="VENDOR" class="ui-state-default">공급사</th>';
				htmlContents += '<th width="80" id="INSTALLEDDATE" class="ui-state-default">설치 일자</th>';
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
						var softwarename = $(this).find('softwarename').text();
						var version = $(this).find('version').text();
						var vendor = $(this).find('vendor').text();
						var installedDate = $(this).find('installeddate').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userName + '</td>';
						htmlContents += '<td style="text-align: left;" title="' + softwarename + '">' + softwarename + '</td>';
						htmlContents += '<td>' + version + '</td>';
						htmlContents += '<td style="text-align: left;">' + vendor + '</td>';
						htmlContents += '<td>' + installedDate + '</td>';
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
								loadSoftwareInstallationList();
							}
						});
					} else {
						objPagination.hide();
					}
					//$('button[name="btnDownload"]').show();
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="7" align="center"><div style="padding: 10px 0; text-align: center;">등록된 소프트웨어 설치 목록이 존재하지 않습니다.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 소프트웨어 설치 목록이 존재하지 않습니다.</div></td>';
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
					$('.inner-center .pane-header').text('사업장 소프트웨어 설치 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
<% } else { %>
					$('.inner-center .pane-header').text('전체 소프트웨어 설치 목록');
<% } %>
				} else if (objTreeReference.get_selected().attr("node_type") == 'software') {
					$('.inner-center .pane-header').text('소프트웨어 설치 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 사업장 소프트웨어 설치 목록');
				}

				g_objSoftwareInstallationList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 설치 목록 조회", "소프트웨어 설치 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadSoftwareInstallationList = function() {

		var objSearchCondition = g_objSoftwareInstallationList.find('#search-condition');

		var objSearchDept = objSearchCondition.find('select[name="searchdept"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objTreeReference = $.jstree._reference(g_objSoftwareInstallationTree);

		var targetCompanyId = "";
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var arrTargetDeptList = new Array();
		if (objSearchDept.val().length > 0)
			arrTargetDeptList.push(objSearchDept.val());

		var targetSoftwareName = "";
		if (typeof objTreeReference.get_selected().attr('softwarename') != typeof undefined) {
			targetSoftwareName = objTreeReference.get_selected().attr('softwarename');
		}

		var postData = getRequestCreateSoftwareInstallationListFileParam(
				targetCompanyId,
				arrTargetDeptList,
				"",
				targetSoftwareName,
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		openDownloadDialog("소프트웨어 설치 목록", "소프트웨어 설치 목록", postData);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">소프트웨어 설치 구성도</div>
	<div class="ui-layout-content zero-padding">
		<div id="softwareinstallation-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 소프트웨어 설치 목록</div>
	<div class="ui-layout-content">
		<div id="softwareinstallation-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<div id="row-searchdept" style="display: inline-block;"> 
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>부서
					<select id="searchdept" name="searchdept" class="ui-widget-content"></select>
				</div>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content input-date" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content input-date" readonly="readonly" />
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
<!-- 	<div class="pane-footer"> -->
<!-- 		<div class="button-line"> -->
<!-- 			<button type="button" id="btnDownload" name="btnDownload" class="normal-button" style="display: none;">목록 다운로드</button> -->
<!-- 		</div> -->
<!-- 	</div> -->
</div>
