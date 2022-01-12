<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objDetectFileProcessStatusPerDeptList;

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objDetectFileProcessStatusPerDeptList = $('#detectfileprocessstatusperdept-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		innerDefaultLayout.show("west");
		loadCompanyTreeView();
<% } else { %>
		loadDetectFileProcessStatusPerDeptList();
<% } %>

		$('button').click( function () {
			if ($(this).attr('id') == 'btnDownload') {
				downloadDetectFileProcessStatusPerDeptList();
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; loadDetectFileProcessStatusPerDeptList(); }; });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
	});

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
				if (data.rslt.obj.attr('node_type') != "company_category") {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadDetectFileProcessStatusPerDeptList();
				}
			}
		});
	};

	loadDetectFileProcessStatusPerDeptList = function() {

		var objSearchResult = g_objDetectFileProcessStatusPerDeptList.find('#search-result');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var targetCompanyId = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestDetectFileProcessStatusPerDeptListParam(
				targetCompanyId,
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
					displayAlertDialog("부서별 검출 파일 처리 현황 조회", "부서별 검출 파일 처리 현황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var oemName = $(data).find('oemname').text();

				var htmlContents = '';
				if (oemName == "MOCOMSYS") {
					htmlContents += '<table class="list-table">';
					htmlContents += '<thead>';
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<th rowspan="2" id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
					htmlContents += '<th rowspan="2" id="DEPTNAME" class="ui-state-default">부서</th>';
					htmlContents += '<th rowspan="2" id="USERCOUNT" class="ui-state-default">사용자수</th>';
					htmlContents += '<th rowspan="2" id="DETECTFILECOUNT" class="ui-state-default">전체 검출 파일수</th>';
					htmlContents += '<th rowspan="2" id="NOTPROCESSFILECOUNT" class="ui-state-default">미처리 파일수</th>';
					htmlContents += '<th colspan="4" class="ui-state-default">가상 디스크</th>';
					htmlContents += '<th rowspan="2" id="DELETEFILECOUNT" class="ui-state-default">삭제 파일수</th>';
					htmlContents += '</tr>';
					htmlContents += '<tr>';
					htmlContents += '<th id="MOVETOVITUALDISKFILECOUNT" class="ui-state-default">반입</th>';
					htmlContents += '<th id="MOVEFROMVITUALDISKFILECOUNT" class="ui-state-default">반출</th>';
					htmlContents += '<th id="MOVETOVITUALDISKFILENOTFOUNDCOUNT" class="ui-state-default">반입파일 부재</th>';
					htmlContents += '<th id="MOVEFROMVITUALDISKFILENOTFOUNDCOUNT" class="ui-state-default">반출파일 부재</th>';
					htmlContents += '</tr>';
					htmlContents += '</thead>';
					htmlContents += '<tbody>';
				} else {
					htmlContents += '<table class="list-table">';
					htmlContents += '<thead>';
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<th id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
					htmlContents += '<th id="DEPTNAME" class="ui-state-default">부서</th>';
					htmlContents += '<th id="USERCOUNT" class="ui-state-default">사용자 수</th>';
					htmlContents += '<th id="DETECTFILECOUNT" class="ui-state-default">전체 검출 파일</th>';
					htmlContents += '<th id="NOTPROCESSFILECOUNT" class="ui-state-default">미처리 파일</th>';
					htmlContents += '<th id="ENCODINGFILECOUNT" class="ui-state-default">암호화 파일</th>';
					htmlContents += '<th id="DELETEFILECOUNT" class="ui-state-default">삭제 파일</th>';
					htmlContents += '</tr>';
					htmlContents += '</thead>';
					htmlContents += '<tbody>';
				}

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

						if (oemName == "MOCOMSYS") {
							var companyName = $(this).find('companyname').text();
							var deptName = $(this).find('deptname').text();
							var userCount = $(this).find('usercount').text();
							var detectFileCount = $(this).find('detectfilecount').text();
							var notProcessFileCount = $(this).find('notprocessfilecount').text();
							var moveToVitualDiskFileCount = $(this).find('movetovitualdiskfilecount').text();
							var moveFromVitualDiskFileCount = $(this).find('movefromvitualdiskfilecount').text();
							var moveToVitualDiskFileNotFoundCount = $(this).find('movetovitualdiskfilenotfoundcount').text();
							var moveFromVitualDiskFileNotFoundCount = $(this).find('movefromvitualdiskfilenotfoundcount').text();
							var deleteFileCount = $(this).find('deletefilecount').text();

							htmlContents += '<tr class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
							htmlContents += '<td>' + companyName + '</td>';
<% } %>
							htmlContents += '<td>' + deptName + '</td>';
							htmlContents += '<td style="text-align: right;">' + userCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 명</td>';
							htmlContents += '<td style="text-align: right;">' + detectFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + notProcessFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + moveToVitualDiskFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + moveFromVitualDiskFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + moveToVitualDiskFileNotFoundCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + moveFromVitualDiskFileNotFoundCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + deleteFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '</tr>';
						} else {
							var companyName = $(this).find('companyname').text();
							var deptName = $(this).find('deptname').text();
							var userCount = $(this).find('usercount').text();
							var detectFileCount = $(this).find('detectfilecount').text();
							var notProcessFileCount = $(this).find('notprocessfilecount').text();
							var encodingFileCount = $(this).find('encodingfilecount').text();
							var deleteFileCount = $(this).find('deletefilecount').text();

							htmlContents += '<tr class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
							htmlContents += '<td>' + companyName + '</td>';
<% } %>
							htmlContents += '<td>' + deptName + '</td>';
							htmlContents += '<td style="text-align: right;">' + userCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 명</td>';
							htmlContents += '<td style="text-align: right;">' + detectFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + notProcessFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + encodingFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '<td style="text-align: right;">' + deleteFileCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
							htmlContents += '</tr>';
						}
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
								loadDetectFileProcessStatusPerDeptList();
							}
						});
					} else {
						objPagination.hide();
					}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
						$('button[name="btnDownload"]').show();
					} else {
						$('button[name="btnDownload"]').hide();
					}
<% } else { %>
					$('button[name="btnDownload"]').show();
<% } %>
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					if (oemName == "MOCOMSYS") {
						htmlContents += '<td colspan="10" align="center"><div style="padding: 10px 0; text-align: center;">등록된 부서별 검출 파일 처리 현황이 존재하지 않습니다.</div></td>';
					} else {
						htmlContents += '<td colspan="7" align="center"><div style="padding: 10px 0; text-align: center;">등록된 부서별 검출 파일 처리 현황이 존재하지 않습니다.</div></td>';
					}
<% } else { %>
					if (oemName == "MOCOMSYS") {
						htmlContents += '<td colspan="9" align="center"><div style="padding: 10px 0; text-align: center;">등록된 부서별 검출 파일 처리 현황이 존재하지 않습니다.</div></td>';
					} else {
						htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 부서별 검출 파일 처리 현황이 존재하지 않습니다.</div></td>';
					}
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDownload"]').hide();
				}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				if (objTreeReference.get_selected().attr("node_type") == 'company') {
					$('.inner-center .pane-header').text('사업장 부서별 검출 파일 처리 현황 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 사업장 부서별 검출 파일 처리 현황');
				}
<% } else { %>
				$('.inner-center .pane-header').text('부서별 검출 파일 처리 현황');
<% } %>
				g_objDetectFileProcessStatusPerDeptList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서별 검출 파일 처리 현황 조회", "부서별 검출 파일 처리 현황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadDetectFileProcessStatusPerDeptList = function() {

		var targetCompanyId = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestCreateDetectFileProcessStatusPerDeptListFileParam(
				targetCompanyId,
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		openDownloadDialog("부서별 검출 파일 처리 현황", "부서별 검출 파일 처리 현황", postData);
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
	<div class="pane-header">전체 사업장 부서별 검출 파일 처리 현황</div>
	<div class="ui-layout-content">
		<div id="detectfileprocessstatusperdept-list" style="display: none;">
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
