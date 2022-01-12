<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="softwarecopyright-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objSoftwareCopyrightList;

	var g_htSoftwareTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	$(document).ready(function() {
		g_objSoftwareCopyrightList = $('#softwarecopyright-list');

		$( document ).tooltip();

		$('input:button, input:submit, button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htSoftwareTypeList = loadTypeList("SOFTWARE_TYPE");
		if (g_htSoftwareTypeList.isEmpty()) {
			displayAlertDialog("소프트웨어 유형 조회", "소프트웨어 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objSoftwareCopyrightList.find('#search-condition').find('select[name="searchsoftwaretype"]'), g_htSoftwareTypeList, null, "전체");

		loadSoftwareCopyrightList();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadSoftwareCopyrightList();
			}
		});
	});

	loadSoftwareCopyrightList = function() {

		var objSearchCondition = g_objSoftwareCopyrightList.find('#search-condition');
		var objSearchResult = g_objSoftwareCopyrightList.find('#search-result');

		var objSearchSoftwareName = objSearchCondition.find('input[name="searchsoftwarename"]');
		var objSearchSoftwareType = objSearchCondition.find('select[name="searchsoftwaretype"]');
		var objSearchManufacturer = objSearchCondition.find('input[name="searchmanufacturer"]');
		var objSearchVendor = objSearchCondition.find('input[name="searchvendor"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var postData = getRequestSoftwareCopyrightListParam(objSearchSoftwareName.val(),
			objSearchSoftwareType.val(),
			objSearchManufacturer.val(),
			objSearchVendor.val(),
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
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("저작권 목록 조회", "저작권 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$('.inline-search-condition').show();

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="SOFTWARENAME" class="ui-state-default">소프트웨어 명</th>';
				htmlContents += '<th width="10%" id="SOFTWARETYPE" class="ui-state-default">소프트웨어 유형</th>';
				htmlContents += '<th width="15%" id="MANUFACTURER" class="ui-state-default">제조사</th>';
				htmlContents += '<th width="15%" id="VENDOR" class="ui-state-default">공급사</th>';
				htmlContents += '<th width="15%" id="FILENAME" class="ui-state-default">파일 명</th>';
				htmlContents += '<th width="8%" id="FILESIZE" class="ui-state-default">파일 크기</th>';
				htmlContents += '<th width="8%" id="PRICE" class="ui-state-default">가격</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var seqNo = $(this).find('seqno').text();
						var softwareName = $(this).find('softwarename').text();
						var fileName = $(this).find('filename').text();
						var fileSize = $(this).find('filesize').text();
						var softwareType = $(this).find('softwaretype').text();
						var price = $(this).find('price').text();
						var manufacturer = $(this).find('manufacturer').text();
						var vendor = $(this).find('vendor').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
						htmlContents += '<td title="' + softwareName + '">' + softwareName + '</td>';
						htmlContents += '<td style="text-align: center;">' + g_htSoftwareTypeList.get(softwareType) + '</td>';
						htmlContents += '<td>' + manufacturer + '</td>';
						htmlContents += '<td>' + vendor + '</td>';
						htmlContents += '<td>' + fileName + '</td>';
						if ((fileSize != null) && fileSize.length > 0) {
							htmlContents += '<td style="text-align: right;">' + fileSize.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">&nbsp;</td>';
						}
						if ((price != null) && price.length > 0) {
							htmlContents += '<td style="text-align: right;">' + price.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">&nbsp;</td>';
						}
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objSoftwareCopyrightList.find('.list-table th').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objSoftwareCopyrightList.find('.list-table th').click(function() { if( $(this).attr('id') != null) { g_searchListOrderByName = $(this).attr('id'); if( g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; loadSoftwareCopyrightList(); } });";
					inlineScriptText += "g_objSoftwareCopyrightList.find('.list-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objSoftwareCopyrightList.find('.list-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
					inlineScriptText += "g_objSoftwareCopyrightList.find('.list-table tbody tr').click( function () { openSoftwareCopyrightInfoDialog($(this).attr('seqno')); });";

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
								loadSoftwareCopyrightList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="7" align="center"><div style="padding: 10px 0; text-align: center;">등록된 저작권 정보가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("저작권 목록 조회", "저작권 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="inner-center">
	<div class="pane-header ui-widget-header ui-corner-top">저작권 목록</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom">
		<div id="softwarecopyright-list">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>소프트웨어 명
				<input type="text" id="searchsoftwarename" name="searchsoftwarename" class="text ui-widget-content ui-corner-all" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>소프트웨어 유형
				<select id="searchsoftwaretype" name="searchsoftwaretype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>제조사
				<input type="text" id="searchmanufacturer" name="searchmanufacturer" class="text ui-widget-content ui-corner-all" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>공급사
				<input type="text" id="searchvendor" name="searchvendor" class="text ui-widget-content ui-corner-all" />
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
