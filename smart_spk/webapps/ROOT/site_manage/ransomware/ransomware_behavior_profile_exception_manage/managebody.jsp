<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="behaviorprofileexception-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objFileTree;
	var g_objFileList;

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objFileTree = $('#file-tree');
		g_objFileList = $('#file-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

		$('#dialog:ui-dialog').dialog('destroy');

		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		innerDefaultLayout.show("west");
		loadFileTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadBehaviorProfileExceptionFileList();
			} else if ($(this).attr('id') == 'btnNew') {
				openNewBehaviorProfileExceptionDialog();
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("랜섬웨어 행위분석 예외 파일 삭제", "랜섬웨어 행위분석 예외 파일을 삭제하시겠습니까?", "", function() { deleteRansomwareBehaviorProfileExceptionFile(); } );
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table thead tr th:first-child", function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });	
		$(document).on("click", ".list-table tbody tr", function(e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; });
	});

	loadFileTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += '<root>';
		xmlTreeData += '<item id="root" node_type="root" state="closed">';
		xmlTreeData += '<content><name>전체 랜섬웨어 행위분석 예외</name></content>';
		xmlTreeData += '</item>';
		for(var i = "A".charCodeAt(0); i <= "Z".charCodeAt(0); i++) {
			xmlTreeData += '<item id="id_' + String.fromCharCode(i) + '" parent_id="root" node_type="category">';
			xmlTreeData += '<content><name>' + String.fromCharCode(i) + '</name></content>';
			xmlTreeData += '</item>';
		}
		xmlTreeData += '<item id="id_Etc" parent_id="root" node_type="category">';
		xmlTreeData += '<content><name>Etc</name></content>';
		xmlTreeData += '</item>';
		xmlTreeData += '</root>';

		g_objFileTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData
			},
			"themes": {
				"theme": "classic",
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
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				g_searchListOrderByName = "";
				g_searchListOrderByDirection = "";
				g_searchListPageNo = 1;
				loadBehaviorProfileExceptionFileList();
			}
		});
	};

	loadBehaviorProfileExceptionFileList = function() {

		var objSearchCondition = g_objFileList.find('#search-condition');
		var objSearchResult = g_objFileList.find('#search-result');

		var objSearchFileName = objSearchCondition.find('input[name="searchfilename"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		if (objSearchFileName.val().length > 0) {
			if (!isValidParam(objSearchFileName, PARAM_TYPE_SEARCH_KEYWORD, "파일명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchFileName.hasClass('ui-state-error') )
				objSearchFileName.removeClass('ui-state-error');
		}

		var objTreeReference = $.jstree._reference(g_objFileTree);
		var categoryCode = "";
		if (objTreeReference.get_selected().attr("node_type") == 'category') {
			categoryCode = objTreeReference.get_selected().children('a').text().trim();
		}

		var postData = getRequestRansomwareBehaviorProfileExceptionFileListParam(
				categoryCode,
				objSearchFileName.val(),
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
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중 ...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("랜섬웨어 행위분석 예외 목록 조회", "랜섬웨어 행위분석 예외 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="40" class="ui-state-default" style="text-align: center;">';
				htmlContents += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur();">';
				htmlContents += '</th>';
				htmlContents += '<th class="ui-state-default">파일명</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " ]");

				if (resultRecordCount >0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var fileName = $(this).find('filename').text();

						htmlContents += '<tr class="' + lineStyle + '">';
						htmlContents += '<td><input type="checkbox" name="selectfile" filename="' + fileName + '" style="border: 0;"></td>';
						htmlContents += '<td style="text-align: left;">' + fileName + '</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var totalPageCount;
					if (totalRecordCount%<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>== 0) {
						totalPageCount = totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>;
					} else {
						totalPageCount = Math.floor(totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>) + 1;
					}

					if (totalPageCount >1) {
						objPagination.show();
						objPagination.paging({
							current: g_searchListPageNo,
							max: totalPageCount,
							onclick: function(e, page){
								g_searchListPageNo = page;
								loadBehaviorProfileExceptionFileList();
							}
						});
					} else {
						objPagination.hide();
					}

					$('button[name="btnDelete"]').show();
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">등록된 랜섬웨어 행위분석 예외가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDelete"]').hide();
				}

				$('button[name="btnNew"]').show();

				$('.inner-center .pane-header').text('전체 랜섬웨어 행위분석 예외 목록');
				g_objFileList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("랜섬웨어 행위분석 예외 목록 조회", "랜섬웨어 행위분석 예외 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteRansomwareBehaviorProfileExceptionFile = function() {

		var arrFileList = new Array();
		g_objFileList.find('.list-table tbody tr').find('input:checkbox[name="selectfile"]').filter(':checked').each( function () {
			arrFileList.push($(this).attr('filename'));
		});

		var postData = getRequestDeleteRansomwareBehaviorProfileExceptionFileParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				arrFileList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중 ...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("랜섬웨어 행위분석 예외 파일 삭제", "랜섬웨어 행위분석 예외 파일 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadFileTreeView();
					displayInfoDialog("랜섬웨어 행위분석 예외 파일 삭제", "정상 처리되었습니다.", "정상적으로 랜섬웨어 행위분석 예외 파일이 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("랜섬웨어 행위분석 예외 파일 삭제", "랜섬웨어 행위분석 예외 파일 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">랜섬웨어 행위분석 예외 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="file-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 랜섬웨어 행위분석 예외 목록</div>
	<div class="ui-layout-content">
		<div id="file-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>파일명
				<input type="text" id="searchfilename" name="searchfilename" class="text ui-widget-content" />
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">조회</button>
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
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">삭제</button>
		</div>
	</div>
</div>
