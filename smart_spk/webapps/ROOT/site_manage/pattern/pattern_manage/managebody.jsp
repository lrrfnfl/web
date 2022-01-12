<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objPatternTree;
	var g_objPatternList;
	var g_objPatternInfo;

	var g_htOptionTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objPatternTree = $('#pattern-tree');
		g_objPatternList = $('#pattern-list');
		g_objPatternInfo = $('#pattern-info');

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

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList($('#search-condition').find('select[name="searchdefaultsearch"]'), g_htOptionTypeList, null, "전체");

		innerDefaultLayout.show("west");
		loadPatternTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadPatternList();
			} else if ($(this).attr('id') == 'btnNew') {
				newPattern();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validatePatternData(MODE_INSERT)) {
					insertPattern();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validatePatternData(MODE_UPDATE)) {
					displayConfirmDialog("패턴 정보 수정", "패턴 정보를 수정하시겠습니까?", "", function() { updatePattern(); });
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("패턴 삭제", "패턴을 삭제하시겠습니까?", "", function() { deletePattern(); });
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { onClickTr($(this)); });

		if (!String.prototype.startsWith) {
			String.prototype.startsWith = function(searchString, position) {
				position = position || 0;
				return this.substr(position, searchString.length) === searchString;
			};
		}
	});

	onClickTr = function(objTr) {
		var objTree = $.jstree._reference(g_objPatternTree); 
		var patternId = objTr.attr('patternid');
		var patternSubId = objTr.attr('patternsubid');
		objTree.deselect_node(objTree.get_selected());
		if (objTree._get_node('#psid_' + patternSubId).length) {
			objTree.select_node('#psid_' + patternSubId);
		} else {
			if (objTree._get_node('#pid_' + patternId).length) {
				objTree.open_node('#pid_' + patternId);
			}
			if (objTree._get_node('#psid_' + patternSubId).length) {
				objTree.select_node('#psid_' + patternSubId);
			}
		}
	};

	loadPatternTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[전체 패턴]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "</root>";

		g_objPatternTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var patternId = "";
							if (typeof node.attr('patternid') != typeof undefined) {
								patternId = node.attr('patternid');
							}
							var postData = getRequestPatternTreeNodesParam(patternId);
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
							displayAlertDialog("패턴 트리 목록 조회", "패턴 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("패턴 트리 목록 조회", "패턴 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') == "pattern") {
					loadPatternInfo(data.rslt.obj.attr('patternid'), data.rslt.obj.attr('patternsubid'));
				} else {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadPatternList();
				}
			}
		});
	};

	loadPatternList = function() {

		var objSearchCondition = g_objPatternList.find('#search-condition');
		var objSearchResult = g_objPatternList.find('#search-result');

		var objSearchPatternName = objSearchCondition.find('input[name="searchpatternname"]');
		var objSearchDefaultSearch = objSearchCondition.find('select[name="searchdefaultsearch"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objPatternTree);

		if (objSearchPatternName.val().length > 0) {
			if (!isValidParam(objSearchPatternName, PARAM_TYPE_SEARCH_KEYWORD, "패턴 소분류 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchPatternName.hasClass('ui-state-error'))
				objSearchPatternName.removeClass('ui-state-error');
		}

		var targetPatternId = "";
		if (objTreeReference.get_selected().attr("node_type") == 'pattern_category') {
			targetPatternId = objTreeReference.get_selected().attr('patternid');
		}

		var postData = getRequestPatternListParam(targetPatternId,
			objSearchPatternName.val(),
			objSearchDefaultSearch.val(),
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
					displayAlertDialog("패턴 목록 조회", "패턴 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="15%" id="PATTERNID" class="ui-state-default">패턴 대분류 ID</th>';
				htmlContents += '<th id="PATTERNCATEGORYNAME" class="ui-state-default">패턴 대분류 명</th>';
				htmlContents += '<th width="15%" id="PATTERNSUBID" class="ui-state-default">패턴 소분류 ID</th>';
				htmlContents += '<th id="PATTERNNAME" class="ui-state-default">패턴 소분류 명</th>';
				htmlContents += '<th width="15%" id="DEFAULTSEARCHFLAG" class="ui-state-default">기본검사 설정</th>';
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

						var patternId = $(this).find('patternid').text();
						var patternCategoryName = $(this).find('patterncategoryname').text();
						var patternSubId = $(this).find('patternsubid').text();
						var patternName = $(this).find('patternname').text();
						var defaultSearchFlag = $(this).find('defaultsearchflag').text();

						htmlContents += '<tr patternid=' + patternId + ' patternsubid=' + patternSubId + ' class="' + lineStyle + '">';
						htmlContents += '<td style="text-align:center;">' + patternId + '</td>';
						htmlContents += '<td>' + patternCategoryName + '</td>';
						htmlContents += '<td style="text-align:center;">' + patternSubId + '</td>';
						htmlContents += '<td>' + patternName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htOptionTypeList.get(defaultSearchFlag) + '</td>';
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
								loadPatternList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">등록된 패턴이 존재하지 않습니다.</div></td>';
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

				if (objTreeReference.get_selected().attr("node_type") == 'pattern_category') {
					$('.inner-center .pane-header').text('패턴 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 패턴 목록');
				}
				g_objPatternList.show();
				g_objPatternInfo.hide();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 목록 조회", "패턴 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadPatternInfo = function(targetPatternId, targetPatternSubId) {

		var objPatternId = g_objPatternInfo.find('input[name="patternid"]');
		var objPatternCategoryName = g_objPatternInfo.find('input[name="patterncategoryname"]');
		var objPatternSubId = g_objPatternInfo.find('input[name="patternsubid"]');
		var objPatternName = g_objPatternInfo.find('input[name="patternname"]');
		var objPatternText = g_objPatternInfo.find('input[name="patterntext"]');
		var objDefaultSearch = g_objPatternInfo.find('select[name="defaultsearch"]');

		g_objPatternInfo.find('#validateTips').hide();
		g_objPatternInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objPatternInfo.find('select').each(function() {
			$(this).val('');
		});

		var postData = getRequestPatternInfoByIdParam(targetPatternId, targetPatternSubId);

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
					displayAlertDialog("패턴 정보 조회", "패턴 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var patternId = $(data).find('patternid').text();
				var patternCategoryName = $(data).find('patterncategoryname').text();
				var patternSubId = $(data).find('patternsubid').text();
				var patternName = $(data).find('patternname').text();
				var patternText = $(data).find('patterntext').text();
				var updateLockFlag = $(data).find('updatelockflag').text();
				var defaultSearchFlag = $(data).find('defaultsearchflag').text();

				objPatternId.val(patternId);
				objPatternCategoryName.val(patternCategoryName);
				objPatternSubId.val(patternSubId);
				objPatternName.val(patternName);
				objPatternText.val(patternText);
				fillDropdownList(objDefaultSearch, g_htOptionTypeList, defaultSearchFlag, "선택");

				objPatternId.attr('readonly', true);
				objPatternId.blur();
				objPatternId.addClass('ui-priority-secondary');
				objPatternCategoryName.attr('readonly', true);
				objPatternCategoryName.blur();
				objPatternCategoryName.addClass('ui-priority-secondary');
				objPatternSubId.attr('readonly', true);
				objPatternSubId.blur();
				objPatternSubId.addClass('ui-priority-secondary');

				$('button[name="btnNew"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				if (updateLockFlag == '<%=UpdateType.UPDATE_TYPE_POSSIBLE%>') {
					$('button[name="btnDelete"]').show();
				} else {
					$('button[name="btnDelete"]').hide();
				}

				$('.inner-center .pane-header').text('패턴 정보 - [' + patternName + ']');
				g_objPatternList.hide();
				g_objPatternInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 정보 조회", "패턴 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newPattern = function() {

		var objPatternId = g_objPatternInfo.find('input[name="patternid"]');
		var objPatternCategoryName = g_objPatternInfo.find('input[name="patterncategoryname"]');
		var objPatternSubId = g_objPatternInfo.find('input[name="patternsubid"]');
		var objDefaultSearch = g_objPatternInfo.find('select[name="defaultsearch"]');

		var objTreeReference = $.jstree._reference(g_objPatternTree);

		g_objPatternInfo.find('#validateTips').hide();
		g_objPatternInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objPatternInfo.find('select').each(function() {
			$(this).val('');
		});

		if (objTreeReference.get_selected().attr("node_type") == 'pattern_category') {
			objPatternId.val(objTreeReference.get_selected().attr('patternid'));
			objPatternCategoryName.val(objTreeReference.get_text(objTreeReference.get_selected()));
			objPatternId.attr('readonly', true);
			objPatternId.addClass('ui-priority-secondary');
			objPatternId.blur();
			objPatternCategoryName.attr('readonly', true);
			objPatternCategoryName.addClass('ui-priority-secondary');
			objPatternCategoryName.blur();
		} else if (objTreeReference.get_selected().attr("node_type") == 'pattern') {
			var parentNode = objTreeReference._get_parent(objTreeReference.get_selected());
			objPatternId.val(parentNode.attr('patternid'));
			objPatternCategoryName.val(parentNode.children('a').text().trim());
			objPatternId.attr('readonly', true);
			objPatternId.addClass('ui-priority-secondary');
			objPatternId.blur();
			objPatternCategoryName.attr('readonly', true);
			objPatternCategoryName.addClass('ui-priority-secondary');
			objPatternCategoryName.blur();
		} else {
			objPatternId.attr('readonly', false);
			objPatternId.removeClass('ui-priority-secondary');
			objPatternCategoryName.attr('readonly', false);
			objPatternCategoryName.removeClass('ui-priority-secondary');
		}

		objPatternSubId.attr('readonly', false);
		objPatternSubId.removeClass('ui-priority-secondary');
		fillDropdownList(objDefaultSearch, g_htOptionTypeList, null, "선택");

		$('button[name="btnNew"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 패턴');
		g_objPatternList.hide();
		g_objPatternInfo.show();
	};

	insertPattern = function() {

		var postData = getRequestInsertPatternParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objPatternInfo.find('input[name="patternid"]').val(),
			g_objPatternInfo.find('input[name="patterncategoryname"]').val(),
			g_objPatternInfo.find('input[name="patternsubid"]').val(),
			g_objPatternInfo.find('input[name="patternname"]').val(),
			g_objPatternInfo.find('input[name="patterntext"]').val(),
			g_objPatternInfo.find('select[name="defaultsearch"]').val());

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
					displayAlertDialog("패턴 등록", "패턴 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objPatternTree);
					var objTargetNode = null;
					if (objTreeReference.get_selected().attr("node_type") == "pattern") {
						objTargetNode = objTreeReference._get_parent(objTreeReference.get_selected());
					} else {
						objTargetNode = objTreeReference.get_selected();
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
					}
					displayInfoDialog("패턴 등록", "정상 처리되었습니다.", "정상적으로 패턴이 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 등록", "패턴 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updatePattern = function() {

		var postData = getRequestUpdatePatternParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objPatternInfo.find('input[name="patternid"]').val(),
			g_objPatternInfo.find('input[name="patterncategoryname"]').val(),
			g_objPatternInfo.find('input[name="patternsubid"]').val(),
			g_objPatternInfo.find('input[name="patternname"]').val(),
			g_objPatternInfo.find('input[name="patterntext"]').val(),
			g_objPatternInfo.find('select[name="defaultsearch"]').val());

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
					displayAlertDialog("패턴 정보 변경", "패턴 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objPatternTree);
					var objTargetNode = null;
					if (objTreeReference.get_selected().attr("node_type") == "pattern") {
						objTargetNode = objTreeReference._get_parent(objTreeReference.get_selected());
					} else {
						objTargetNode = objTreeReference.get_selected();
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
					}
					displayInfoDialog("패턴 정보 변경", "정상 처리되었습니다.", "정상적으로 패턴 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 정보 변경", "패턴 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deletePattern = function() {

		var postData = getRequestDeletePatternParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objPatternInfo.find('input[name="patternid"]').val(),
				g_objPatternInfo.find('input[name="patternsubid"]').val());

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
					displayAlertDialog("패턴 삭제", "패턴 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objPatternTree);
					var objParentNode = objTreeReference._get_parent(objTreeReference.get_selected());
					var objTargetNode = null;
					if (objTreeReference._get_children(objParentNode).length == 1) {
						objTargetNode = objTreeReference._get_parent(objParentNode);
					} else {
						objTargetNode = objParentNode;
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
					}
					displayInfoDialog("패턴 삭제", "정상 처리되었습니다.", "정상적으로 패턴이 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 삭제", "패턴 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validatePatternData = function(mode) {

		var objPatternId = g_objPatternInfo.find('input[name="patternid"]');
		var objPatternCategoryName = g_objPatternInfo.find('input[name="patterncategoryname"]');
		var objPatternSubId = g_objPatternInfo.find('input[name="patternsubid"]');
		var objPatternName = g_objPatternInfo.find('input[name="patternname"]');
		var objDefaultSearch = g_objPatternInfo.find('select[name="defaultsearch"]');
		var objValidateTips = g_objPatternInfo.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (!isValidParam(objPatternId, PARAM_TYPE_NUMBER, "패턴 대분류 ID", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			}
			if (!isValidParam(objPatternSubId, PARAM_TYPE_NUMBER, "패턴 소분류 ID", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			}
			if (!objPatternSubId.val().startsWith(objPatternId.val())) {
				updateTips(objValidateTips, "패턴 소분류 ID는 패턴 대분류 ID로 시작해야합니다.");
				return false;
			}
		}

		if (!isValidParam(objPatternCategoryName, PARAM_TYPE_NAME, "패턴 대분류 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (!isValidParam(objPatternName, PARAM_TYPE_NAME, "패턴 소분류 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objDefaultSearch.val().length == 0) {
			updateTips(objValidateTips, "기본검사 설정 유형을 선택해 주세요.");
			objDefaultSearch.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">패턴 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="pattern-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 패턴 목록</div>
	<div class="ui-layout-content">
		<div id="pattern-list" style="display:none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>패턴 소분류 명
				<input type="text" id="searchpatternname" name="searchpatternname" class="text ui-widget-content" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>기본검사 설정
				<select id="searchdefaultsearch" name="searchdefaultsearch" class="ui-widget-content"></select>
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
		<div id="pattern-info" class="info-form">
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
				<div id="row-patternid" class="field-line">
					<div class="field-title">패턴 대분류 ID<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="patternid" name="patternid" class="text ui-widget-content" /></div>
				</div>
				<div id="row-patterncategoryname" class="field-line">
					<div class="field-title">패턴 대분류 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="patterncategoryname" name="patterncategoryname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-patternsubid" class="field-line">
					<div class="field-title">패턴 소분류 ID<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="patternsubid" name="patternsubid" class="text ui-widget-content" /></div>
				</div>
				<div id="row-patternname" class="field-line">
					<div class="field-title">패턴 소분류 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="patternname" name="patternname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-patterntext" class="field-line">
					<div class="field-title">패턴 정규식<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="patterntext" name="patterntext" class="text ui-widget-content" /></div>
				</div>
				<div id="row-defaultsearch" class="field-line">
					<div class="field-title">기본검사 설정<span class="required_field">*</span></div>
					<div class="field-value"><select id="defaultsearch" name="defaultsearch" class="ui-widget-content"></select></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 패턴</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">패턴 등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">패턴 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">패턴 삭제</button>
		</div>
	</div>
</div>
