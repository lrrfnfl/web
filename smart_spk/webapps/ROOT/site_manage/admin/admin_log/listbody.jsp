<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="adminlog-dialog.jsp"%>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objAdminTree;
	var g_objAdminLogList;

	var g_htAdminTypeList = new Hashtable();
	var g_htJobTypeList = new Hashtable();
	var g_htJobCategoryList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objAdminTree = $('#admin-tree');
		g_objAdminLogList = $('#adminlog-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });

		g_objAdminLogList.find('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objAdminLogList.find('#searchdateto').datepicker('option', 'minDate', selectedDate);
			}
		});

		g_objAdminLogList.find('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objAdminLogList.find('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
			}
		});

		var tmpDate = new Date();
		tmpDate.addDate("d", -6);
		g_objAdminLogList.find('#searchdatefrom').datepicker('setDate', tmpDate);
		g_objAdminLogList.find('#searchdateto').datepicker('setDate', new Date());

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htAdminTypeList = loadTypeList("ADMIN_TYPE");
		if (g_htAdminTypeList.isEmpty()) {
			displayAlertDialog("관리자 유형 조회", "관리자 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htJobTypeList = loadTypeList("ADMIN_JOB_TYPE");
		if (g_htJobTypeList.isEmpty()) {
			displayAlertDialog("관리자 작업 유형 조회", "관리자 작업 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htJobCategoryList = loadTypeList("ADMIN_JOB_CATEGORY");
		if (g_htJobCategoryList.isEmpty()) {
			displayAlertDialog("관리자 작업 대상 유형 조회", "관리자 작업 대상 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objAdminLogList.find('#search-condition').find('select[name="searchjobtype"]'), g_htJobTypeList, null, "전체");
		fillDropdownList(g_objAdminLogList.find('#search-condition').find('select[name="searchjobcategory"]'), g_htJobCategoryList, null, "전체");

		innerDefaultLayout.show("west");
		loadAdminTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadAdminLogList();
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { openAdminLogInfoDialog($(this).attr('seqno')); });
	});

	loadAdminTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root'>";
		xmlTreeData += "<content><name><![CDATA[전체 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "<item id='root_siteadmin' parent_id='root' admintype='<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>' node_type='siteadmin_category' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[사이트 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "<item id='root_companyadmin' parent_id='root' admintype='<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>' node_type='companyadmin_category' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[사업장 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "</root>";

		g_objAdminTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var postData;
							if (node.attr("node_type") == 'siteadmin_category') {
	 							postData = getRequestAdminTreeNodesParam('<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>', '');
							} else if (node.attr("node_type") == 'companyadmin_category') {
								postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ADMIN%>', '', '');
							} else if (node.attr("node_type") == 'company_category') {
								postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ADMIN%>', node.children('a').text().trim(), '');
							} else if (node.attr("node_type") == 'company') {
	 							postData = getRequestAdminTreeNodesParam('<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>', node.attr('companyid'));
							}
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
							displayAlertDialog("관리자 트리 목록 조회", "관리자 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
		 			},
		 			error: function(jqXHR, textStatus, errorThrown) {
		 				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
		 					displayAlertDialog("관리자 트리 목록 조회", "관리자 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			data.inst.open_node('#root_siteadmin');
			data.inst.open_node('#root_companyadmin');
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
				} else if ($(this).attr('node_type') == "admin") {
					if ($(this).attr('lockflag') == "<%=LockState.LOCK_STATE_LOCK%>") {
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
				if ((data.rslt.obj.attr('node_type') == "root") ||
						(data.rslt.obj.attr('node_type') == "company") ||
						(data.rslt.obj.attr('node_type') == "admin")) {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadAdminLogList();
				}
			}
		});
	};

	loadAdminLogList = function() {

		var objSearchCondition = g_objAdminLogList.find('#search-condition');
		var objSearchResult = g_objAdminLogList.find('#search-result');

		var objSearchJobType = objSearchCondition.find('select[name="searchjobtype"]');
		var objSearchJobCategory = objSearchCondition.find('select[name="searchjobcategory"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objAdminTree);

		var targetAdminId;
		var targetAdminType;
		var targetCompanyId;
		if (objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') {
			targetAdminId = "";
			targetAdminType = "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>";
			targetCompanyId = "";
		} else if (objTreeReference.get_selected().attr("node_type") == 'companyadmin_category') {
			targetAdminId = "";
			targetAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
			targetCompanyId = "";
		} else if (objTreeReference.get_selected().attr("node_type") == "company") {
			targetAdminId = "";
			targetAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		} else if (objTreeReference.get_selected().attr("node_type") == "admin") {
			targetAdminId = objTreeReference.get_selected().attr('adminid');
			targetAdminType = objTreeReference.get_selected().attr('admintype');
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		} else {
			targetAdminId = "";
			targetAdminType = "";
			targetCompanyId = "";
		}

		var postData = getRequestAdminLogListParam(targetAdminId,
				targetAdminType,
				targetCompanyId,
				objSearchJobType.val(),
				objSearchJobCategory.val(),
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
					displayAlertDialog("관리자 로그 목록 조회", "관리자 로그 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="15%" class="ui-state-default">관리자</th>';
				if (targetAdminType != "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>") {
					htmlContents += '<th width="15%" class="ui-state-default">사업장</th>';
				}
				htmlContents += '<th width="10%" class="ui-state-default">작업 유형</th>';
				htmlContents += '<th width="10%" class="ui-state-default">작업 대상</th>';
				htmlContents += '<th class="ui-state-default">작업 제목</th>';
				htmlContents += '<th width="15%" class="ui-state-default">작업 일시</th>';
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
						var adminName = $(this).find('adminname').text();
						var companyName = $(this).find('companyname').text();
						var jobType = $(this).find('jobtype').text();
						var jobCategory = $(this).find('jobcategory').text();
						var jobSubject = $(this).find('jobsubject').text();
						var jobDatetime = $(this).find('jobdatetime').text();

						htmlContents += '<tr seqno=' + seqNo + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + adminName + '</td>';
						if (targetAdminType != "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>") {
							htmlContents += '<td>' + companyName + '</td>';
						}
						htmlContents += '<td style="text-align:center;">' + g_htJobTypeList.get(jobType) + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htJobCategoryList.get(jobCategory) + '</td>';
						htmlContents += '<td>' + jobSubject + '</td>';
						htmlContents += '<td style="text-align:center;">' + jobDatetime + '</td>';
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
								loadAdminLogList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					if (targetAdminType != "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>") {
						htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 관리자 로그가 존재하지 않습니다.</div></td>';
					} else {
						htmlContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">등록된 관리자 로그가 존재하지 않습니다.</div></td>';
					}
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				if (objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') {
					$('.inner-center .pane-header').text(objTreeReference.get_text(objTreeReference.get_selected()) + ' 로그 목록');
				} else if (objTreeReference.get_selected().attr("node_type") == 'companyadmin_category') {
					$('.inner-center .pane-header').text(objTreeReference.get_text(objTreeReference.get_selected()) + ' 로그 목록');
				} else if (objTreeReference.get_selected().attr('node_type') == "company") {
					$('.inner-center .pane-header').text('사업장 관리자 로그 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else if (objTreeReference.get_selected().attr('node_type') == "admin") {
					$('.inner-center .pane-header').text('관리자 로그 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 관리자 로그 목록');
				}

				g_objAdminLogList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 로그 목록 조회", "관리자 로그 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">관리자 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="admin-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center"> 
	<div class="pane-header">전체 관리자 로그 목록</div>
	<div class="ui-layout-content">
		<div id="adminlog-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>작업 유형
				<select id="searchjobtype" name="searchjobtype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>작업 대상
				<select id="searchjobcategory" name="searchjobcategory" class="ui-widget-content"></select>
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
</div>
