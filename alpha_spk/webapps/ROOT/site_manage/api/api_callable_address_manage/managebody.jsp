<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objAPICallableAddressList;
	var g_objAPICallableAddressInfo;

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	$(document).ready(function() {
		g_objAPICallableAddressList = $('#apicallableaddress-list');
		g_objAPICallableAddressInfo = $('#apicallableaddress-info');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnList"]').button({ icons: {primary: "ui-icon-note"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnInsert"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

		$('#dialog:ui-dialog').dialog('destroy');

		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		loadAPICallableAddressList();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadAPICallableAddressList();
			} else if ($(this).attr('id') == 'btnList') {
				loadAPICallableAddressList();
			} else if ($(this).attr('id') == 'btnNew') {
				newAPICallableAddress();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateAPICallableAddressData()) {
					insertAPICallableAddress();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateAPICallableAddressData()) {
					displayConfirmDialog("API 호출 가능 주소 정보 변경", "API 호출 가능 주소 정보를 변경하시겠습니까?", "", function() { updateAPICallableAddress(); } );
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("API 호출 가능 주소 삭제", "API 호출 가능 주소를 삭제하시겠습니까?", "", function() { deleteAPICallableAddress(); } );
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('seqno') != typeof undefined) { loadAPICallableAddressInfo($(this).attr('seqno')); } });
	});

	loadAPICallableAddressList = function() {

		var objSearchCondition = g_objAPICallableAddressList.find('#search-condition');
		var objSearchResult = g_objAPICallableAddressList.find('#search-result');

		var objIpAddress = objSearchCondition.find('input[name="searchipaddress"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		if (objIpAddress.val().length > 0) {
			if (!isValidParam(objIpAddress, PARAM_TYPE_SEARCH_KEYWORD, "주소", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objIpAddress.hasClass('ui-state-error') )
			objIpAddress.removeClass('ui-state-error');
		}

		var postData = getRequestAPICallableAddressListParam(
				objIpAddress.val(),
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
					displayAlertDialog("API 호출 가능 주소 목록 조회", "API 호출 가능 주소 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="IPADDRESS" class="ui-state-default">주소</th>';
				htmlContents += '<th id="CALLERNAME" class="ui-state-default">호출자명</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " ]");

				if (resultRecordCount > 0) {
					$(data).find('record').each( function(index) {
						var lineStyle = '';
						if (index%2 == 0)
							lineStyle = "list_odd";
						else
							lineStyle = "list_even";

						var seqNo = $(this).find('seqno').text();
						var ipAddress = $(this).find('ipaddress').text();
						var callerName = $(this).find('callername').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
						htmlContents += '<td style="text-align:center">' + ipAddress + '</td>';
						htmlContents += '<td style="text-align:center">' + callerName + '</td>';
						htmlContents += '</tr>';
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
								loadAPICallableAddressList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">등록된 API 호출 가능 주소가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				$('button[name="btnList"]').hide();
				$('button[name="btnNew"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();

				$('.inner-center .pane-header').text('전체 API 호출 가능 주소 목록');

				g_objAPICallableAddressInfo.hide();
				g_objAPICallableAddressList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("API 호출 가능 주소 목록 조회", "API 호출 가능 주소 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadAPICallableAddressInfo = function(seqNo) {

		var objIpAddress = g_objAPICallableAddressInfo.find('input[name="ipaddress"]');
		var objCallerName = g_objAPICallableAddressInfo.find('input[name="callername"]');

		g_objAPICallableAddressInfo.find('#validateTips').hide();
		g_objAPICallableAddressInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		var postData = getRequestAPICallableAddressInfoParam(seqNo);

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
					displayAlertDialog("API 호출 가능 주소 정보 조회", "API 호출 가능 주소 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var ipAddress = $(data).find('ipaddress').text();
				var callerName = $(data).find('callername').text();

				objIpAddress.val(ipAddress);
				objCallerName.val(callerName);

				objIpAddress.attr('readonly', true);
				objIpAddress.blur();
				objIpAddress.addClass('ui-priority-secondary');
				objIpAddress.tooltip({ disabled: true });

				$('button[name="btnList"]').show();
				$('button[name="btnNew"]').show();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();

				$('.inner-center .pane-header').text('API 호출 가능 주소 정보');
				g_objAPICallableAddressList.hide();
				g_objAPICallableAddressInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("API 호출 가능 주소 정보 조회", "API 호출 가능 주소 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newAPICallableAddress = function() {

		var objIpAddress = g_objAPICallableAddressInfo.find('input[name="ipaddress"]');
		var objCallerName = g_objAPICallableAddressInfo.find('input[name="callername"]');

		g_objAPICallableAddressInfo.find('#validateTips').hide();
		g_objAPICallableAddressInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		objIpAddress.val("");
		objCallerName.val("");

		objIpAddress.attr('readonly', false);
		objIpAddress.removeClass('ui-priority-secondary');
		objIpAddress.tooltip({ disabled: false });

		$('button[name="btnNew"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 API 호출 가능 주소');
		g_objAPICallableAddressList.hide();
		g_objAPICallableAddressInfo.show();
	};

	insertAPICallableAddress = function() {

		var postData = getRequestInsertAPICallableAddressParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objAPICallableAddressInfo.find('input[name="ipaddress"]').val(),
				g_objAPICallableAddressInfo.find('input[name="callername"]').val());

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
					displayAlertDialog(" API 호출 가능 주소 등록", "API 호출 가능 주소 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAPICallableAddressList();
					displayInfoDialog(" API 호출 가능 주소 등록", "정상 처리되었습니다.", "정상적으로 API 호출 가능 주소가 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog(" API 호출 가능 주소 등록", "API 호출 가능 주소 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateAPICallableAddress = function() {

		var postData = getRequestUpdateAPICallableAddressParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objAPICallableAddressInfo.find('input[name="ipaddress"]').val(),
				g_objAPICallableAddressInfo.find('input[name="callername"]').val());

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
					displayAlertDialog("API 호출 가능 주소 정보 변경", "API 호출 가능 주소 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAPICallableAddressList();
					displayInfoDialog("API 호출 가능 주소 정보 변경", "정상 처리되었습니다.", "정상적으로 API 호출 가능 주소 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("API 호출 가능 주소 정보 변경", "API 호출 가능 주소 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteAPICallableAddress = function() {

		var postData = getRequestDeleteAPICallableAddressParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objAPICallableAddressInfo.find('input[name="ipaddress"]').val());

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
					displayAlertDialog("API 호출 가능 주소 삭제", "API 호출 가능 주소 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAPICallableAddressList();
					displayInfoDialog("API 호출 가능 주소 삭제", "정상 처리되었습니다.", "정상적으로 API 호출 가능 주소가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("API 호출 가능 주소 삭제", "API 호출 가능 주소 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateAPICallableAddressData = function() {

		var objIpAddress = g_objAPICallableAddressInfo.find('input[name="ipaddress"]');
		var objCallerName = g_objAPICallableAddressInfo.find('input[name="callername"]');
		var objValidateTips = g_objAPICallableAddressInfo.find('#validateTips');

		if (objIpAddress.val() == '') {
			updateTips(objValidateTips, "IPv4 주소를 입력해주세요.");
			objIpAddress.focus();
			return false;
		} else {
			if (!isValidParam(objIpAddress, PARAM_TYPE_IPV4_ADDRESS, "주소", PARAM_IPV4_ADDRESS_MIN_LEN, PARAM_IPV4_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCallerName.val().length == 0) {
			updateTips(objValidateTips, "호출자 명을 입력해주세요.");
			objCallerName.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
</div>
<div class="inner-center">
	<div class="pane-header">전체 API 호출 가능 주소 목록</div>
	<div class="ui-layout-content">
		<div id="apicallableaddress-list" style="display:none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>주소
				<input type="text" id="searchipaddress" name="searchipaddress" class="text ui-widget-content" style="width: 140px" />
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
		<div id="apicallableaddress-info" class="info-form">
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
				<div id="row-ipaddress" class="field-line">
					<div class="field-title">주소<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="ipaddress" name="ipaddress" class="text ui-widget-content" /></div>
				</div>
				<div id="row-callername" class="field-line">
					<div class="field-title">호출자명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="callername" name="callername" class="text ui-widget-content" /></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnList" name="btnList" class="normal-button" style="display: none;">목록</button>
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">삭제</button>
		</div>
	</div>
</div>
