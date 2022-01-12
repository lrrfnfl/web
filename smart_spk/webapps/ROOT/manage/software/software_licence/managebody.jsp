<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="softwareallocation-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objSoftwareLicenceTree;
	var g_objSoftwareLicenceList;
	var g_objSoftwareLicenceInfo;

	var g_htOptionTypeList = new Hashtable();
	
	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_selectedCompanyId = "";
	var g_selectedSoftwareLicenceSeqNo = "";

	$(document).ready(function() {

		g_objSoftwareLicenceTree = $('#softwarelicence-tree');
		g_objSoftwareLicenceList = $('#softwarelicence-list');
		g_objSoftwareLicenceInfo = $('#softwarelicence-info');

		$( document).tooltip();

		$('input:button, input:submit, button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnAllocate"]').button({ icons: {primary: "ui-icon-shuffle"} });
		$('button[name="btnInsert"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

		$('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdateto').datepicker('option', 'minDate', selectedDate);
			}
		});

		$('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
			}
		});

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadSoftwareLicenceTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadSoftwareLicenceList();
			} else if ($(this).attr('id') == 'btnNew') {
				g_objSoftwareLicenceList.hide();
				g_objSoftwareLicenceInfo.show();
				newSoftwareLicence(g_selectedCompanyId);
			} else if ($(this).attr('id') == 'btnAllocate') {
				openSoftwareAllocationDialog();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateSoftwareLicenceData(MODE_INSERT)) {
					insertSoftwareLicence();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateSoftwareLicenceData(MODE_UPDATE)) {
					displayConfirmDialog("소프트웨어 라이센스 정보 수정", "소프트웨어 라이센스 정보를 수정하시겠습니까?", "", function() { updateSoftwareLicence(g_selectedSoftwareLicenceSeqNo); });
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("소프트웨어 라이센스 삭제", "소프트웨어 라이센스를 삭제하시겠습니까?", "", function() { deleteSoftwareLicence(g_selectedCompanyId, g_selectedSoftwareLicenceSeqNo); });
			}
		});
	});

	loadSoftwareLicenceTreeView = function() {

		var postData = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		postData = getRequestSoftwareLicenceTreeInfoParam('');
<% } else { %>
		postData = getRequestSoftwareLicenceTreeInfoParam('<%=(String)session.getAttribute("COMPANYID")%>');
<% } %>

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				g_objSoftwareLicenceTree.block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				g_objSoftwareLicenceTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 트리 정보 조회", "소프트웨어 라이센스 트리 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var xmlTreeData = "";
				var companyNodeXml = "";
				var softwareNodeXml = "";

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				$(data).find('company').each(function() {
					companyNodeXml += "<item id='" + $(this).find('companyid').text() + "' parent_id='ALL' service_state='" + $(this).find('servicestateflag').text() + "' node_type='company'>";
					companyNodeXml += "<content><name>" + $(this).find('companyname').text() + "</name></content>";
					companyNodeXml += "</item>";
				});
<% } %>
				
				$(data).find('software').each(function() {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					softwareNodeXml += "<item id='" + $(this).find('seqno').text() + "' parent_id='" + $(this).find('companyid').text() + "' companyid='" + $(this).find('companyid').text() + "' node_type='software'>";
					softwareNodeXml += "<content><name>" + $(this).find('softwarename').text() + "</name></content>";
					softwareNodeXml += "</item>";
<% } else { %>
					softwareNodeXml += "<item id='" + $(this).find('seqno').text() + "' parent_id='ALL' companyid='<%=(String)session.getAttribute("COMPANYID")%>' node_type='software'>";
					softwareNodeXml += "<content><name>" + $(this).find('softwarename').text() + "</name></content>";
					softwareNodeXml += "</item>";
<% } %>
				});

				xmlTreeData += "<root>";
				xmlTreeData += "<item id='ALL' node_type='ROOT'>";
				xmlTreeData += "<content><name>전체 소프트웨어</name></content>";
				xmlTreeData += "</item>";
				xmlTreeData += companyNodeXml + softwareNodeXml;
				xmlTreeData += "</root>";

				g_objSoftwareLicenceTree.jstree({
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
						// this.css("color", "red")
						//{ font-weight:bold}
						}
					},
					"contextmenu" : {
						"items" : treeContextMenu
					},
					"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu" ]

				}).bind('loaded.jstree', function (event, data) {
					//data.inst.open_all(-1); // -1 opens all nodes in the container

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					// ROOT 자식 노드(사업장) 의 서비스 상태에 따라 사업장 명 색상 변경 
					data.inst._get_children(data.inst._get_node('ul > li:first')).each(function() {
						if ($(this).attr('service_state') == <%=ServiceState.SERVICE_STATE_STOP%>) {
							data.inst.get_container().find('li[id=' + $(this).attr('id') + '] a').first().addClass('state-abnormal');
						} else {
							data.inst.get_container().find('li[id=' + $(this).attr('id') + '] a').first().removeClass('state-abnormal');
						}
					});
<% } %>

					// 이전 선택된 노드 Select
					if (g_selectedSoftwareLicenceSeqNo.length > 0) {
						data.inst.select_node('#' + g_selectedSoftwareLicenceSeqNo);
					} else if (g_selectedCompanyId.length > 0) {
						data.inst.select_node('#' + g_selectedCompanyId);
					} else {
						data.inst.select_node('ul > li:first');
					}

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
					data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
					data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
				}).bind('select_node.jstree', function (event, data) {
					data.inst.open_node(data.rslt.obj);

					if (data.rslt.obj.attr('node_type') == "company") {
						g_selectedCompanyId = data.rslt.obj.attr('id');
						g_selectedSoftwareLicenceSeqNo = "";
						$('.inner-center .pane-header').text('사업장 소프트웨어 라이센스 목록 - [' + data.rslt.obj.children('a').text().trim() + ']');
						g_objSoftwareLicenceList.show();
						g_objSoftwareLicenceInfo.hide();
						g_searchListPageNo = 1;
						loadSoftwareLicenceList();
					} else if (data.rslt.obj.attr('node_type') == "software") {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedSoftwareLicenceSeqNo = data.rslt.obj.attr('id');
						$('.inner-center .pane-header').text('소프트웨어 라이센스 정보 - [' + data.rslt.obj.children('a').text().trim() + ']');
						g_objSoftwareLicenceList.hide();
						g_objSoftwareLicenceInfo.show();
						loadSoftwareLicenceInfo();
					} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						g_selectedCompanyId = "";
<% } else { %>
						g_selectedCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>
						g_selectedSoftwareLicenceSeqNo = "";
						$('.inner-center .pane-header').text('전체 소프트웨어 라이센스 목록');
						g_objSoftwareLicenceList.show();
						g_objSoftwareLicenceInfo.hide();
						g_searchListPageNo = 1;
						loadSoftwareLicenceList();
					}
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 트리 정보 조회", "소프트웨어 라이센스 트리 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	function treeContextMenu(node) {

		var items = {
			"listItem": {
				"label" : "소프트웨어 라이센스 목록",
				"action" : function () {
					g_objSoftwareLicenceTree.jstree('deselect_all');
					g_objSoftwareLicenceTree.jstree('select_node', $('#' + $(node).attr('id')));
				}
			},
			"newItem": {
				"label" : "신규 소프트웨어 라이센스",
				"action" : function () {
					g_objSoftwareLicenceList.hide();
					g_objSoftwareLicenceInfo.show();
					newSoftwareLicence($(node).attr('id'));
				},
				"separator_before"  : true
			},
			"infoItem": {
				"label" : "소프트웨어 라이센스 정보",
				"action" : function () {
					g_objSoftwareLicenceTree.jstree('deselect_all');
					g_objSoftwareLicenceTree.jstree('select_node', $('#' + $(node).attr('id')));
				}
			},
			"deleteItem": {
				"label" : "소프트웨어 라이센스 삭제",
				"action" : function () {
					displayConfirmDialog("소프트웨어 라이센스 삭제", "소프트웨어 라이센스를 삭제하시겠습니까?", "", function() { deleteSoftwareLicence($(node).attr('companyid'), $(node).attr('id')); });
				},
				"separator_before"  : true
			}
		};

		if ($(node).attr('node_type') == "company") {
			delete items.infoItem;
			delete items.deleteItem;
		} else if ($(node).attr('node_type') == "software") {
			delete items.listItem;
			delete items.newItem;
		} else {
			delete items.newItem;
			delete items.infoItem;
			delete items.deleteItem;
		}

		return items;
	};

	loadSoftwareLicenceList = function() {

		var objSearchCondition = g_objSoftwareLicenceList.find('#search-condition');
		var objSearchResult = g_objSoftwareLicenceList.find('#search-result');

		var objSearchSoftwareName = objSearchCondition.find('input[name="searchsoftwarename"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var postData = getRequestSoftwareLicenceListParam(g_selectedCompanyId,
				objSearchSoftwareName.val(),
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
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" />처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 목록 조회", "소프트웨어 라이센스 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$('.inline-search-condition').show();

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th width="15%" id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th id="SOFTWARENAME" class="ui-state-default">소프트웨어 명</th>';
				htmlContents += '<th width="10%" id="LICENCECOUNT" class="ui-state-default">라이센스 수</th>';
				htmlContents += '<th width="15%" id="MANUFACTURER" class="ui-state-default">제조사</th>';
				htmlContents += '<th width="15%" id="VENDOR" class="ui-state-default">공급사</th>';
				htmlContents += '<th width="110" id="CREATEDATETIME" class="ui-state-default">등록 일시</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var seqNo = $(this).find('seqno').text();
						var companyName = $(this).find('companyname').text();
						var softwarename = $(this).find('softwarename').text();
						var licenceCount = $(this).find('licencecount').text();
						var manufacturer = $(this).find('manufacturer').text();
						var vendor = $(this).find('vendor').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td title="' + softwarename + '">' + softwarename + '</td>';
						if ((licenceCount != null) && licenceCount.length > 0) {
							htmlContents += '<td style="text-align: right;">' + licenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">&nbsp;</td>';
						}
						htmlContents += '<td>' + manufacturer + '</td>';
						htmlContents += '<td>' + vendor + '</td>';
						htmlContents += '<td style="text-align: center;">' + createDatetime + '</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objSoftwareLicenceList.find('.list-table th').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objSoftwareLicenceList.find('.list-table th').click(function() { if( $(this).attr('id') != null) { g_searchListOrderByName = $(this).attr('id'); if( g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; loadSoftwareLicenceList(); } });";
					inlineScriptText += "g_objSoftwareLicenceList.find('.list-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objSoftwareLicenceList.find('.list-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
					inlineScriptText += "g_objSoftwareLicenceList.find('.list-table tbody tr').click( function () { g_objSoftwareLicenceTree.jstree('deselect_all'); g_objSoftwareLicenceTree.jstree('select_node', $('#' + $(this).attr('seqno'))); });";

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
							current: g_searchUserListPageNo,
							max: totalPageCount,
							onclick: function(e, page){
								g_searchListPageNo = selectPageNo;
								loadSoftwareLicenceList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 소프트웨어 라이센스가 존재하지 않습니다.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">등록된 소프트웨어 라이센스가 존재하지 않습니다.</div></td>';
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				if (g_selectedCompanyId.length > 0) {
					$('button[name="btnNew"]').show();
				} else {
					$('button[name="btnNew"]').hide();
				}
				$('button[name="btnAllocate"]').hide();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 목록 조회", "소프트웨어 라이센스 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadSoftwareLicenceInfo = function() {

		var objCompanyId = g_objSoftwareLicenceInfo.find('input[name="companyid"]');
		var objCompanyName = g_objSoftwareLicenceInfo.find('#companyname');
		var objSoftwareName = g_objSoftwareLicenceInfo.find('input[name="softwarename"]');
		var objLicenceKey = g_objSoftwareLicenceInfo.find('input[name="licencekey"]');
		var objLicenceCount = g_objSoftwareLicenceInfo.find('input[name="licencecount"]');
		var objManufacturer = g_objSoftwareLicenceInfo.find('input[name="manufacturer"]');
		var objVendor = g_objSoftwareLicenceInfo.find('input[name="vendor"]');
		var objVendorEmail = g_objSoftwareLicenceInfo.find('input[name="vendoremail"]');
		var objVendorPhone = g_objSoftwareLicenceInfo.find('input[name="vendorphone"]');
		var objVendorFax = g_objSoftwareLicenceInfo.find('input[name="vendorfax"]');
		var objAllocationCount = g_objSoftwareLicenceInfo.find('#allocationcount');
		var objLastModifiedDatetime = g_objSoftwareLicenceInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objSoftwareLicenceInfo.find('#createdatetime');

		var objRowAllocationCount = g_objSoftwareLicenceInfo.find('#row-allocationcount');
		var objRowLastModifiedDatetime = g_objSoftwareLicenceInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objSoftwareLicenceInfo.find('#row-createdatetime');

		var postData = getRequestSoftwareLicenceInfoParam(g_selectedSoftwareLicenceSeqNo);

		g_objSoftwareLicenceInfo.find('#validateTips').hide();
		g_objSoftwareLicenceInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 정보 조회", "소프트웨어 라이센스 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var softwareName = $(data).find('softwarename').text();
				var licenceKey = $(data).find('licencekey').text();
				var licenceCount = $(data).find('licencecount').text();
				var manufacturer = $(data).find('manufacturer').text();
				var vendor = $(data).find('vendor').text();
				var vendorEmail = $(data).find('vendoremail').text();
				var vendorPhone = $(data).find('vendorphone').text();
				var vendorFax = $(data).find('vendorfax').text();
				var allocationCount = $(data).find('allocationcount').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				objCompanyId.val(companyId);
				objCompanyName.text(companyName);
				objSoftwareName.val(softwareName);
				objSoftwareName.attr('readonly', true);
				objSoftwareName.blur();
				objSoftwareName.addClass('ui-priority-secondary');
				objSoftwareName.tooltip({ disabled: true });
				objLicenceKey.val(licenceKey);
				objLicenceCount.val(licenceCount);
				objManufacturer.val(manufacturer);
				objVendor.val(vendor);
				objVendorEmail.val(vendorEmail);
				objVendorPhone.val(vendorPhone);
				objVendorFax.val(vendorFax);
				if ((allocationCount != null) && (allocationCount.length > 0)) {
					objAllocationCount.text(allocationCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				} else {
					objAllocationCount.text("0");
				}
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objRowAllocationCount.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				$('button[name="btnNew"]').hide();
				$('button[name="btnAllocate"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 정보 조회", "소프트웨어 라이센스 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newSoftwareLicence = function(companyId) {

		var objCompanyId = g_objSoftwareLicenceInfo.find('input[name="companyid"]');
		var objCompanyName = g_objSoftwareLicenceInfo.find('#companyname');
		var objSoftwareName = g_objSoftwareLicenceInfo.find('input[name="softwarename"]');
		var objLicenceKey = g_objSoftwareLicenceInfo.find('input[name="licencekey"]');
		var objLicenceCount = g_objSoftwareLicenceInfo.find('input[name="licencecount"]');
		var objManufacturer = g_objSoftwareLicenceInfo.find('input[name="manufacturer"]');
		var objVendor = g_objSoftwareLicenceInfo.find('input[name="vendor"]');
		var objVendorEmail = g_objSoftwareLicenceInfo.find('input[name="vendoremail"]');
		var objVendorPhone = g_objSoftwareLicenceInfo.find('input[name="vendorphone"]');
		var objVendorFax = g_objSoftwareLicenceInfo.find('input[name="vendorfax"]');

		var objRowAllocationCount = g_objSoftwareLicenceInfo.find('#row-allocationcount');
		var objRowLastModifiedDatetime = g_objSoftwareLicenceInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objSoftwareLicenceInfo.find('#row-createdatetime');

		g_objSoftwareLicenceInfo.find('#validateTips').hide();
		g_objSoftwareLicenceInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		objCompanyId.val(companyId);
		objCompanyName.text(g_objSoftwareLicenceTree.find('#' + companyId).children("a").text());
		objSoftwareName.val('');
		objSoftwareName.attr('readonly', false);
		objSoftwareName.removeClass('ui-priority-secondary');
		objSoftwareName.tooltip({ disabled: false });
		objLicenceKey.val('');
		objLicenceCount.val('');
		objManufacturer.val('');
		objVendor.val('');
		objVendorEmail.val('');
		objVendorPhone.val('');
		objVendorFax.val('');

		objRowAllocationCount.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		g_objSoftwareLicenceTree.jstree('deselect_all');
		
		$('button[name="btnNew"]').hide();
		$('button[name="btnAllocate"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();
	};

	insertSoftwareLicence = function() {

		var postData = getRequestInsertSoftwareLicenceParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objSoftwareLicenceInfo.find('input[name="companyid"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="softwarename"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="licencekey"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="licencecount"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="manufacturer"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendor"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendoremail"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendorphone"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendorfax"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 등록", "소프트웨어 라이센스 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					g_selectedCompanyId = g_objSoftwareLicenceInfo.find('input[name="companyid"]').val();
					g_selectedSoftwareLicenceSeqNo = "";
					loadSoftwareLicenceTreeView();
					displayInfoDialog("소프트웨어 라이센스 등록", "정상 처리되었습니다.", "정상적으로 소프트웨어 라이센스가 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 등록", "소프트웨어 라이센스 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateSoftwareLicence = function() {

		var postData = getRequestUpdateSoftwareLicenceParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_selectedSoftwareLicenceSeqNo,
				g_objSoftwareLicenceInfo.find('input[name="licencekey"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="licencecount"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="manufacturer"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendor"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendoremail"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendorphone"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="vendorfax"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 정보 변경", "소프트웨어 라이센스 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadSoftwareLicenceTreeView();
					displayInfoDialog("소프트웨어 라이센스 정보 변경", "정상 처리되었습니다.", "정상적으로 소프트웨어 라이센스 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 정보 변경", "소프트웨어 라이센스 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteSoftwareLicence = function(companyId, seqNo) {

		var postData = getRequestDeleteSoftwareLicenceParam('<%=(String)session.getAttribute("ADMINID")%>',
				seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 라이센스 삭제", "소프트웨어 라이센스 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					g_selectedCompanyId = companyId;
					g_selectedSoftwareLicenceSeqNo = "";
					loadSoftwareLicenceTreeView();
					displayInfoDialog("소프트웨어 라이센스 삭제", "정상 처리되었습니다.", "정상적으로 소프트웨어 라이센스가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 라이센스 삭제", "소프트웨어 라이센스 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateSoftwareLicenceData = function(mode) {

		var objSoftwareName = g_objSoftwareLicenceInfo.find('input[name="softwarename"]');
		var objLicenceKey = g_objSoftwareLicenceInfo.find('input[name="licencekey"]');
		var objLicenceCount = g_objSoftwareLicenceInfo.find('input[name="licencecount"]');
		var objManufacturer = g_objSoftwareLicenceInfo.find('input[name="manufacturer"]');
		var objVendor = g_objSoftwareLicenceInfo.find('input[name="vendor"]');
		var objVendorEmail = g_objSoftwareLicenceInfo.find('input[name="vendoremail"]');
		var objVendorPhone = g_objSoftwareLicenceInfo.find('input[name="vendorphone"]');
		var objVendorFax = g_objSoftwareLicenceInfo.find('input[name="vendorfax"]');
		var objValidateTips = g_objSoftwareLicenceInfo.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (objSoftwareName.val().length == 0) {
				updateTips(objValidateTips, "소프트웨어 명을 입력해 주세요.");
				objSoftwareName.focus();
				return false;
			} else {
				if (!isValidParam(objSoftwareName, PARAM_TYPE_NAME, "소프트웨어 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
					return false;
				}
			}
		}

		if (objManufacturer.val().length > 0) {
			if (!isValidParam(objManufacturer, PARAM_TYPE_NAME, "제조사", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objVendor.val().length > 0) {
			if (!isValidParam(objVendor, PARAM_TYPE_NAME, "공급사", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objLicenceKey.val().length > 0) {
			if (!isValidParam(objLicenceKey, PARAM_TYPE_SOFTWARE_LICENCE_KEY, "라이센스 키", PARAM_SOFTWARE_LICENCE_KEY_MIN_LEN, PARAM_SOFTWARE_LICENCE_KEY_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objLicenceCount.val().length > 0) {
			if (!isValidParam(objLicenceCount, PARAM_TYPE_NUMBER, "라이센스 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			} else {
				if (parseInt(objLicenceCount.val()) <= 0) {
					updateTips(objValidateTips, "정확한 라이센스 수를 압력해 주세요.");
					objLicenceCount.focus();
					return false;
				}
			}
		}

		if (objVendorEmail.val().length > 0) {
			if (!isValidParam(objVendorEmail, PARAM_TYPE_EMAIL, "공급사 E-MAIL", PARAM_EMAIL_MIN_LEN, PARAM_EMAIL_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objVendorPhone.val().length > 0) {
			if (!isValidParam(objVendorPhone, PARAM_TYPE_PHONE, "공급사 전화번호", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objVendorFax.val().length > 0) {
			if (!isValidParam(objVendorFax, PARAM_TYPE_PHONE, "공급사 FAX", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header ui-widget-header ui-corner-top">소프트웨어 라이센스</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom" style="padding: 0;">
		<div id="softwarelicence-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header ui-widget-header ui-corner-top"></div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom">
		<div id="softwarelicence-list">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>소프트웨어 명
				<input type="text" id="searchsoftwarename" name="searchsoftwarename" class="text ui-widget-content ui-corner-all" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
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
		<div id="softwarelicence-info" class="info-form">
			<div class="info">
				<div class="info-line">- <span class="required_field">*</span> 필드는 필수 입력 필드입니다.</div>
			</div>
			<div id="validateTips" class="validateTips">
				<div style="float: left; width: 18px; vertical-align: top;"><span class="ui-icon ui-icon-alert"></span></div>
				<div style="margin-left: 20px; margin-top: 2px;"><strong>입력오류:</strong>&nbsp;<span id="validateMsg"></span></div>
				<div style="clear:both;"></div>
			</div>
			<div class="form-contents">
				<input type="hidden" id="companyid" name="companyid" />
				<div id="row-companyname" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">대상 사업장</div>
					<div class="ui-corner-right field-value"><span id="companyname"></span></div>
				</div>
				<div id="row-softwarename" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">소프트웨어 명<span class="required_field">*</span></div>
					<div class="ui-corner-right field-value"><input type="text" id="softwarename" name="softwarename" class="text ui-widget-content" /></div>
				</div>
				<div id="row-licencekey" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">라이센스 키</div>
					<div class="ui-corner-right field-value"><input type="text" id="licencekey" name="licencekey" class="text ui-widget-content" /></div>
				</div>
				<div id="row-licencecount" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">라이센스 수</div>
					<div class="ui-corner-right field-value"><input type="text" id="licencecount" name="licencecount" value="" class="text ui-widget-content" style="text-align: right; width: 80px;" /> 명</div>
				</div>
				<div id="row-manufacturer" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">제조사</div>
					<div class="ui-corner-right field-contents"><input type="text" id="manufacturer" name="manufacturer" class="text ui-widget-content" /></div>
				</div>
				<div id="row-vendor" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">공급사</div>
					<div class="ui-corner-right field-contents"><input type="text" id="vendor" name="vendor" class="text ui-widget-content" /></div>
				</div>
				<div id="row-vendoremail" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">공급사 E-MAIL</div>
					<div class="ui-corner-right field-value"><input type="text" id="vendoremail" name="vendoremail" class="text ui-widget-content" /></div>
				</div>
				<div id="row-vendorphone" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">공급사 전화번호</div>
					<div class="ui-corner-right field-value"><input type="text" id="vendorphone" name="vendorphone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-vendorfax" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">공급사 FAX</div>
					<div class="ui-corner-right field-value"><input type="text" id="vendorfax" name="vendorfax" class="text ui-widget-content" /></div>
				</div>
				<div id="row-allocationcount" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">배정 사용자 수</div>
					<div class="ui-corner-right field-value"><span id="allocationcount"></span></div>
				</div>
				<div id="row-lastmodifieddatetime" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">최종 변경 일시</div>
					<div class="ui-corner-right field-value"><span id="lastmodifieddatetime"></span></div>
				</div>
				<div id="row-createdatetime" class="field-line">
					<div class="ui-state-default ui-corner-left field-title">등록 일시</div>
					<div class="ui-corner-right field-value"><span id="createdatetime"></span></div>
				</div>
			</div>
		</div>
	</div>
	<div class="ui-state-default pane-footer">
		<div class="button-line">
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 소프트웨어 라이센스</button>
			<button type="button" id="btnAllocate" name="btnAllocate" class="normal-button" style="display: none;">소프트웨어 사용자 배정</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">소프트웨어 라이센스 등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">소프트웨어 라이센스 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">소프트웨어 라이센스 삭제</button>
		</div>
	</div>
</div>
