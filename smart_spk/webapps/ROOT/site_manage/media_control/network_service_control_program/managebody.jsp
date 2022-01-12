<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objProgramTree;
	var g_objProgramList;
	var g_objProgramInfo;

	var g_htProgramTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objProgramTree = $('#program-tree');
		g_objProgramList = $('#program-list');
		g_objProgramInfo = $('#program-info');

		$( document).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnInsert"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htProgramTypeList = loadTypeList("PROGRAM_TYPE");
		if (g_htProgramTypeList.isEmpty()) {
			displayAlertDialog("프로그램 유형 조회", "프로그램 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadProgramTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadProgramList();
			} else if ($(this).attr('id') == 'btnNew') {
				newProgram();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateProgramData(MODE_INSERT)) {
					insertProgram();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateProgramData(MODE_UPDATE)) {
					displayConfirmDialog("네트워크 서비스 제어 프로그램 정보 수정", "네트워크 서비스 제어 프로그램 정보를 수정하시겠습니까?", "", function() { updateProgram(); });
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("네트워크 서비스 제어 프로그램 삭제", "네트워크 서비스 제어 프로그램을 삭제하시겠습니까?", "", function() { deleteProgram(); });
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { onClickTr($(this)); });
	});

	onClickTr = function(objTr) {
		var objTree = $.jstree._reference(g_objProgramTree); 
		var seqNo = objTr.attr('seqno');
		objTree.deselect_node(objTree.get_selected());
		if (objTree._get_node('#program_' + seqNo).length) {
			objTree.select_node('#program_' + seqNo);
		}
	};

	loadProgramTreeView = function() {

		var postData = getRequestNetworkServiceControlProgramListParam('',
				'',
				'PROGRAMTYPE, PROGRAMNAME',
				'ASC',
				'',
				'');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				g_objProgramTree.block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				g_objProgramTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("네트워크 서비스 제어 프로그램 목록 조회", "네트워크 서비스 제어 프로그램 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var xmlTreeData = "";
				var programTypeNodeXml = "";
				var programNodeXml = "";

				g_htProgramTypeList.each( function(value, name) {
					programTypeNodeXml += "<item id='type_" + value + "' parent_id='ALL'" + " programtype='" + value + "' filename='' node_type='program_type'>";
					programTypeNodeXml += "<content><name>" + name + "</name></content>";
					programTypeNodeXml += "</item>";
				});

				$(data).find('record').each( function() {
					programNodeXml += "<item id='program_" + $(this).find('seqno').text() + "' parent_id='type_" + $(this).find('programtype').text() + "' programtype='" + $(this).find('programtype').text() + "' filename='" + $(this).find('filename').text() + "' node_type='program'>";
					programNodeXml += "<content><name>" + $(this).find('programname').text() + "</name></content>";
					programNodeXml += "</item>";
				});

				xmlTreeData += "<root>";
				xmlTreeData += "<item id='ALL'>";
				xmlTreeData += "<content><name>전체 네트워크 서비스 제어 프로그램</name></content>";
				xmlTreeData += "</item>";
				xmlTreeData += programTypeNodeXml;
				xmlTreeData += programNodeXml;
				xmlTreeData += "</root>";

				g_objProgramTree.jstree({
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
						if (data.rslt.obj.attr('node_type') == "program") {
							loadProgramInfo(data.rslt.obj.attr('filename'));
						} else {
							g_searchListPageNo = 1;
							loadProgramList();
						}
					}
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 목록 조회", "네트워크 서비스 제어 프로그램 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadProgramList = function() {

		var objSearchCondition = g_objProgramList.find('#search-condition');
		var objSearchResult = g_objProgramList.find('#search-result');

		var objSearchProgramName = objSearchCondition.find('input[name="searchprogramname"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objProgramTree);

		if (objSearchProgramName.val().length > 0) {
			if (!isValidParam(objSearchProgramName, PARAM_TYPE_SEARCH_KEYWORD, "프로그램 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchProgramName.hasClass('ui-state-error'))
				objSearchProgramName.removeClass('ui-state-error');
		}

		var targetProgramType;
		if (typeof objTreeReference.get_selected().attr('programtype') != typeof undefined) {
			targetProgramType = objTreeReference.get_selected().attr('programtype');
		} else {
			targetProgramType = "";
		}

		var postData = getRequestNetworkServiceControlProgramListParam(objSearchProgramName.val(),
				targetProgramType,
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
					displayAlertDialog("네트워크 서비스 제어 프로그램 목록 조회", "네트워크 서비스 제어 프로그램 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="PROGRAMNAME" class="ui-state-default">프로그램 명</th>';
				htmlContents += '<th id="FILENAME" class="ui-state-default">파일 명</th>';
				htmlContents += '<th width="20%" id="PROGRAMTYPE" class="ui-state-default">프로그램 유형</th>';
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
						var programName = $(this).find('programname').text();
						var fileName = $(this).find('filename').text();
						var programType = $(this).find('programtype').text();

						htmlContents += '<tr seqno=' + seqNo + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + programName + '</td>';
						htmlContents += '<td>' + fileName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htProgramTypeList.get(programType) + '</td>';
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
								loadProgramList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="3" align="center"><div style="padding: 10px 0; text-align: center;">등록된 네트워크 서비스 제어 프로그램이 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				$('button[name="btnNew"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();

				if (objTreeReference.get_selected().attr("node_type") == 'program_type') {
					$('.inner-center .pane-header').text('네트워크 서비스 제어 프로그램 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 네트워크 서비스 제어 프로그램 목록');
				}
				g_objProgramList.show();
				g_objProgramInfo.hide();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 목록 조회", "네트워크 서비스 제어 프로그램 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadProgramInfo = function(targetFileName) {

		var objProgramName = g_objProgramInfo.find('input[name="programname"]');
		var objFileName = g_objProgramInfo.find('input[name="filename"]');
		var objProgramType = g_objProgramInfo.find('select[name="programtype"]');

		var objTreeReference = $.jstree._reference(g_objProgramTree);

		g_objProgramInfo.find('#validateTips').hide();
		g_objProgramInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objProgramInfo.find('select').each(function() {
			$(this).val('');
		});

		var postData = getRequestNetworkServiceControlProgramInfoByFileNameParam(targetFileName);

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
					displayAlertDialog("네트워크 서비스 제어 프로그램 정보 조회", "네트워크 서비스 제어 프로그램 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var programName = $(data).find('programname').text();
				var fileName = $(data).find('filename').text();
				var programType = $(data).find('programtype').text();

				objProgramName.val(programName);
				objFileName.val(fileName);
				fillDropdownList(objProgramType, g_htProgramTypeList, programType, null);

				objFileName.attr('readonly', true);
				objFileName.blur();
				objFileName.addClass('ui-priority-secondary');

				$('button[name="btnNew"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();

				$('.inner-center .pane-header').text('네트워크 서비스 제어 프로그램 정보 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				g_objProgramList.hide();
				g_objProgramInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 정보 조회", "네트워크 서비스 제어 프로그램 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newProgram = function() {

		var objProgramName = g_objProgramInfo.find('input[name="programname"]');
		var objFileName = g_objProgramInfo.find('input[name="filename"]');
		var objProgramType = g_objProgramInfo.find('select[name="programtype"]');

		var objTreeReference = $.jstree._reference(g_objProgramTree);

		g_objProgramInfo.find('#validateTips').hide();
		g_objProgramInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objProgramInfo.find('select').each(function() {
			$(this).val('');
		});

		objFileName.attr('readonly', false);
		objFileName.removeClass('ui-priority-secondary');

		var programType = "";
		if (typeof objTreeReference.get_selected().attr('programtype') != typeof undefined) {
			programType = objTreeReference.get_selected().attr('programtype');
		}
		fillDropdownList(objProgramType, g_htProgramTypeList, programType, "선택");

		objTreeReference.deselect_node(objTreeReference.get_selected());

		$('button[name="btnNew"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 네트워크 서비스 제어 프로그램');
		g_objProgramList.hide();
		g_objProgramInfo.show();
	};

	insertProgram = function() {

		var postData = getRequestInsertNetworkServiceControlProgramParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objProgramInfo.find('input[name="programname"]').val(),
				g_objProgramInfo.find('input[name="filename"]').val(),
				g_objProgramInfo.find('select[name="programtype"]').val());

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
					displayAlertDialog("네트워크 서비스 제어 프로그램 등록", "네트워크 서비스 제어 프로그램 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadProgramTreeView();
					displayInfoDialog("네트워크 서비스 제어 프로그램 등록", "정상 처리되었습니다.", "정상적으로 네트워크 서비스 제어 프로그램이 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 등록", "네트워크 서비스 제어 프로그램 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateProgram = function() {

		var postData = getRequestUpdateNetworkServiceControlProgramParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objProgramInfo.find('input[name="programname"]').val(),
				g_objProgramInfo.find('input[name="filename"]').val(),
				g_objProgramInfo.find('select[name="programtype"]').val());

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
					displayAlertDialog("네트워크 서비스 제어 프로그램 정보 변경", "네트워크 서비스 제어 프로그램 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadProgramTreeView();
					displayInfoDialog("네트워크 서비스 제어 프로그램 정보 변경", "정상 처리되었습니다.", "정상적으로 네트워크 서비스 제어 프로그램 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 정보 변경", "네트워크 서비스 제어 프로그램 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteProgram = function() {

		var postData = getRequestDeleteNetworkServiceControlProgramParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objProgramInfo.find('input[name="filename"]').val());

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
					displayAlertDialog("네트워크 서비스 제어 프로그램 삭제", "네트워크 서비스 제어 프로그램 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadProgramTreeView();
					displayInfoDialog("네트워크 서비스 제어 프로그램 삭제", "정상 처리되었습니다.", "정상적으로 네트워크 서비스 제어 프로그램이 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 삭제", "네트워크 서비스 제어 프로그램 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateProgramData = function(mode) {

		var objProgramName = g_objProgramInfo.find('input[name="programname"]');
		var objFileName = g_objProgramInfo.find('input[name="filename"]');
		var objProgramType = g_objProgramInfo.find('select[name="programtype"]');
		var objValidateTips = g_objProgramInfo.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (!isValidParam(objFileName, PARAM_TYPE_NAME, "파일 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (!isValidParam(objProgramName, PARAM_TYPE_NAME, "프로그램 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objProgramType.val().length == 0) {
			updateTips(objValidateTips, "프로그램 유형을 선택해 주세요.");
			objProgramType.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">네트워크 서비스 제어 프로그램</div>
	<div class="ui-layout-content zero-padding">
		<div id="program-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center"> 
	<div class="pane-header">전체 네트워크 서비스 제어 프로그램 목록</div>
	<div class="ui-layout-content">
		<div id="program-list" style="display:none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>프로그램 명
				<input type="text" id="searchprogramname" name="searchprogramname" class="text ui-widget-content" />
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
		<div id="program-info" class="info-form">
			<div class="info">
				<ul class="infolist">
					<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
				</ul>
			</div>
			<div id="validateTips" class="validateTips">
				<div class="icon-message-holder">
					<div class="icon-holder"><span id="alert-icon" class="ui-icon ui-icon-alert"></span></div>
					<div class="message-holder">
						<div class="icon-message"><strong>입력오류:</strong>&nbsp;<span id="validateMsg"></span></div>
					</div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="form-contents">
				<div id="row-programname" class="field-line">
					<div class="field-title">프로그램 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="programname" name="programname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-filename" class="field-line">
					<div class="field-title">파일 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="filename" name="filename" class="text ui-widget-content" /></div>
				</div>
				<div id="row-programtype" class="field-line">
					<div class="field-title">프로그램 유형<span class="required_field">*</span></div>
					<div class="field-value"><select id="programtype" name="programtype" class="ui-widget-content"></select></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 프로그램</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">프로그램 등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">프로그램 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">프로그램 삭제</button>
		</div>
	</div>
</div>
