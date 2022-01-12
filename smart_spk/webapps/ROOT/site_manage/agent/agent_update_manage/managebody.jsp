<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objAgentUpdateList;
	var g_objAgentUpdateInfo;

	var g_htServiceStateList = new Hashtable();
	var g_htDownloadPathList = new Hashtable();
	var g_htCompanyList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	$(document).ready(function() {
		g_objAgentUpdateList = $('#agentupdate-list');
		g_objAgentUpdateInfo = $('#agentupdate-info');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnList"]').button({ icons: {primary: "ui-icon-note"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnStopDistribute"]').button({ icons: {primary: "ui-icon-locked"} });
		$('button[name="btnResumeDistribute"]').button({ icons: {primary: "ui-icon-unlocked"} });
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
		$('#searchdateto').datepicker('setDate', new Date());

		$('#dialog:ui-dialog').dialog('destroy');

		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		g_htServiceStateList = loadTypeList("SERVICE_STATE");
		if (g_htServiceStateList.isEmpty()) {
			displayAlertDialog("서비스 상태 유형 조회", "서비스 상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList($('#search-condition').find('select[name="searchdistributestate"]'), g_htServiceStateList, null, "전체");

		g_htCompanyList = loadCompanyList("");

		g_htDownloadPathList = loadAgentUpdateDownloadPathList();

		loadAgentUpdateList();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadAgentUpdateList();
			} else if ($(this).attr('id') == 'btnList') {
				loadAgentUpdateList();
			} else if ($(this).attr('id') == 'btnNew') {
				newAgentUpdate();
			} else if ($(this).attr('id') == 'btnStopDistribute') {
				displayConfirmDialog("업데이트 정보 배포 중지", "업데이트 정보 배포를 중지하시겠습니까?", "", function() { changeAgentUpdateDistributeState("<%=ServiceState.SERVICE_STATE_STOP%>"); } );
			} else if ($(this).attr('id') == 'btnResumeDistribute') {
				displayConfirmDialog("업데이트 정보 배포 중지 해제", "업데이트 정보 배포를 진행하시겠습니까?", "", function() { changeAgentUpdateDistributeState("<%=ServiceState.SERVICE_STATE_NORMAL%>"); } );
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateAgentUpdateData()) {
					insertAgentUpdate();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateAgentUpdateData()) {
					displayConfirmDialog("업데이트 정보 수정", "에이전트 업데이트 정보를 수정하시겠습니까?", "", function() { updateAgentUpdate(); } );
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("업데이트 정보 삭제", "업데이트 정보를 삭제하시겠습니까?", "", function() { deleteAgentUpdate(); } );
			}
		});

		g_objAgentUpdateInfo.find('select[name="downloadpath"]').change( function() {
// 			var version = $(this).children("option:selected").text();
// 			g_objAgentUpdateInfo.find('input[name="version"]').text(version);
			var htUpdateInfoFile = loadAgentUpdateInfoFileList($(this).val());
			fillDropdownList(g_objAgentUpdateInfo.find('select[name="infofilename"]'), htUpdateInfoFile, null, "선택");
			g_objAgentUpdateInfo.find('#infocontent').text('');
		});

		g_objAgentUpdateInfo.find('select[name="infofilename"]').change( function() {
			var referencePage = g_objAgentUpdateInfo.find('select[name="downloadpath"]').val() + $(this).val();
			loadInfoFileContent(referencePage, g_objAgentUpdateInfo.find('#infocontent'));
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { if (typeof $(this).attr('seqno') != typeof undefined) { loadAgentUpdateInfo($(this).attr('seqno')); } });
	});

	loadCompanyList = function(companyId) {

		var htList = new Hashtable();
		var postData = getRequestCompanyListParam('', '', '', 'COMPANYNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$(data).find('record').each( function() {
					htList.put($(this).find('companyid').text(), $(this).find('companyname').text());
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
		return htList;
	};

	loadAgentUpdateDownloadPathList = function() {

		var g_htList = new Hashtable();
		var postData = getRequestAgentUpdateDownloadPathListParam();

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("에이전트 업데이트 다운로드 경로 목록 조회", "에이전트 업데이트 다운로드 경로 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}
				if (!g_htList.isEmpty()) g_htList.clear();
				$(data).find('record').each( function() {
					g_htList.put($(this).find('downloadpath').text(), $(this).find('downloaddirname').text());
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("에이전트 업데이트 다운로드 경로 목록 조회", "에이전트 업데이트 다운로드 경로 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return g_htList;
	};

	loadAgentUpdateInfoFileList = function(downloadPath) {

		var g_htList = new Hashtable();
		var postData = getRequestAgentUpdateInfoFileListParam(downloadPath);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("에이전트 업데이트 정보 파일 목록 조회", "에이전트 업데이트 정보 파일 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}
				if (!g_htList.isEmpty()) g_htList.clear();
				$(data).find('record').each( function() {
					g_htList.put($(this).find('filename').text(), $(this).find('filename').text());
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("에이전트 업데이트 정보 파일 목록 조회", "에이전트 업데이트 정보 파일 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return g_htList;
	};

	loadAgentUpdateList = function() {

		var objSearchCondition = g_objAgentUpdateList.find('#search-condition');
		var objSearchResult = g_objAgentUpdateList.find('#search-result');

		var objSearchTitle = objSearchCondition.find('input[name="searchtitle"]');
		var objSearchContent = objSearchCondition.find('input[name="searchcontent"]');
		var objSearchDistributeState = objSearchCondition.find('select[name="searchdistributestate"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		if (objSearchTitle.val().length > 0) {
			if (!isValidParam(objSearchTitle, PARAM_TYPE_SEARCH_KEYWORD, "제목", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchTitle.hasClass('ui-state-error') )
			objSearchTitle.removeClass('ui-state-error');
		}

		if (objSearchContent.val().length > 0) {
			if (!isValidParam(objSearchContent, PARAM_TYPE_SEARCH_KEYWORD, "내용", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchContent.hasClass('ui-state-error') )
			objSearchContent.removeClass('ui-state-error');
		}

		var postData = getRequestAgentUpdateListParam(objSearchTitle.val(),
				objSearchContent.val(),
				objSearchDistributeState.val(),
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
					displayAlertDialog("에이전트 업데이트 목록 조회", "에이전트 업데이트 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="110" id="VERSION" class="ui-state-default">버전</th>';
				htmlContents += '<th id="TITLE" class="ui-state-default">제목</th>';
				htmlContents += '<th width="140" id="COMPANYID" class="ui-state-default">업데이트 대상 사업장</th>';
				htmlContents += '<th width="100" id="DISTRIBUTESTATE" class="ui-state-default">배포 상태</th>';
				htmlContents += '<th width="120" id="DISTRIBUTEDCOUNT" class="ui-state-default">배포 수</th>';
				htmlContents += '<th width="125" id="CREATEDATETIME" class="ui-state-default">등록일시</th>';
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
						var version = $(this).find('version').text();
						var title = $(this).find('title').text();
						var companyId = $(this).find('companyid').text();
						var distributeState = $(this).find('distributestate').text();
						var distributedCount = $(this).find('distributedcount').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
						htmlContents += '<td style="text-align:center">' + version + '</td>';
						htmlContents += '<td>' + title + '</td>';
						if (companyId.length > 0) {
							htmlContents += '<td style="text-align:center">' + g_htCompanyList.get(companyId) + '</td>';
						} else {
							htmlContents += '<td style="text-align:center">전체</td>';
						}
						if (distributeState == "<%=ServiceState.SERVICE_STATE_STOP%>") {
							htmlContents += '<td style="text-align:center" class="state-abnormal">' + g_htServiceStateList.get(distributeState) + '</td>';
						} else {
							htmlContents += '<td style="text-align:center">' + g_htServiceStateList.get(distributeState) + '</td>';
						}
						htmlContents += '<td style="text-align: right;">' + distributedCount.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '</td>';
						htmlContents += '<td style="text-align:center">' + createDatetime + '</td>';
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
								loadAgentUpdateList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 에이전트 업데이트 목록이 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				$('button[name="btnList"]').hide();
				$('button[name="btnNew"]').show();
				$('button[name="btnStopDistribute"]').hide();
				$('button[name="btnResumeDistribute"]').hide();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();

				$('.inner-center .pane-header').text('에이전트 업데이트 목록');

				g_objAgentUpdateInfo.hide();
				g_objAgentUpdateList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("에이전트 업데이트 목록 조회", "에이전트 업데이트 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadInfoFileContent = function(referencePage, objTarget) {
		$.ajax({
			url : referencePage,
			type : "GET",
			dataType : "text"
		}).done(function(data) {
			objTarget.text(data);
			//objTarget.text((new XMLSerializer()).serializeToString(data));
		});
	}

	loadAgentUpdateInfo = function(seqNo) {

		var objVersion = g_objAgentUpdateInfo.find('input[name="version"]');
		var objTitle = g_objAgentUpdateInfo.find('input[name="title"]');
		var objContent = g_objAgentUpdateInfo.find('textarea[name="content"]');
		var objCompanyId = g_objAgentUpdateInfo.find('select[name="companyid"]');
		var objDownloadPath = g_objAgentUpdateInfo.find('select[name="downloadpath"]');
		var objInfoFileName = g_objAgentUpdateInfo.find('select[name="infofilename"]');
		var objInfoContent = g_objAgentUpdateInfo.find('#infocontent');
		var objDistributeState = g_objAgentUpdateInfo.find('#distributestate');
		var objDistributedCount = g_objAgentUpdateInfo.find('#distributedcount');
		var objLastModifiedDatetime = g_objAgentUpdateInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objAgentUpdateInfo.find('#createdatetime');

		var objRowDistributeState = g_objAgentUpdateInfo.find('#row-distributestate');
		var objRowDistributedCount = g_objAgentUpdateInfo.find('#row-distributedcount');
		var objRowLastModifiedDatetime = g_objAgentUpdateInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objAgentUpdateInfo.find('#row-createdatetime');

		g_objAgentUpdateInfo.find('#validateTips').hide();
		g_objAgentUpdateInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		var postData = getRequestAgentUpdateInfoParam(seqNo);

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
					displayAlertDialog("에이전트 업데이트 정보 조회", "에이전트 업데이트 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var version = $(data).find('version').text();
				var title = $(data).find('title').text();
				var content = $(data).find('content').text();
				var companyId = $(data).find('companyid').text();
				var downloadPath = $(data).find('downloadpath').text();
				var infoFileName = $(data).find('infofilename').text();
				var distributeState = $(data).find('distributestate').text();
				var distributedCount = $(data).find('distributedcount').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				objVersion.val(version);
				objTitle.val(title);
				objContent.val(content);
				fillDropdownList(objCompanyId, g_htCompanyList, companyId, "전체");
				fillDropdownList(objDownloadPath, g_htDownloadPathList, downloadPath, null);
				var htUpdateInfoFile = loadAgentUpdateInfoFileList(downloadPath);
				fillDropdownList(objInfoFileName, htUpdateInfoFile, infoFileName, "선택");
				loadInfoFileContent(downloadPath + infoFileName, objInfoContent);
				objDistributeState.text(g_htServiceStateList.get(distributeState));
				if (distributeState == "<%=ServiceState.SERVICE_STATE_STOP%>") {
					objDistributeState.addClass("state-abnormal");
				} else {
					objDistributeState.removeClass("state-abnormal");
				}
				objDistributedCount.text(distributedCount.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " 건");
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objVersion.attr('readonly', true);
				objVersion.blur();
				objVersion.addClass('ui-priority-secondary');
				objVersion.tooltip({ disabled: true });

				objRowDistributeState.show();
				objRowDistributedCount.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				$('button[name="btnList"]').show();
				$('button[name="btnNew"]').show();
				if (distributeState == <%=ServiceState.SERVICE_STATE_NORMAL%>) {
					$('button[name="btnStopDistribute"]').show();
					$('button[name="btnResumeDistribute"]').hide();
				} else {
					$('button[name="btnStopDistribute"]').hide();
					$('button[name="btnResumeDistribute"]').show();
				}
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();

				$('.inner-center .pane-header').text('에이전트 업데이트 정보');
				g_objAgentUpdateList.hide();
				g_objAgentUpdateInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("에이전트 업데이트 정보 조회", "에이전트 업데이트 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newAgentUpdate = function() {

		var objVersion = g_objAgentUpdateInfo.find('input[name="version"]');
		var objTitle = g_objAgentUpdateInfo.find('input[name="title"]');
		var objContent = g_objAgentUpdateInfo.find('textarea[name="content"]');
		var objCompanyId = g_objAgentUpdateInfo.find('select[name="companyid"]');
		var objDownloadPath = g_objAgentUpdateInfo.find('select[name="downloadpath"]');
		var objInfoFileName = g_objAgentUpdateInfo.find('select[name="infofilename"]');
		var objInfoContent = g_objAgentUpdateInfo.find('#infocontent');
		var objDistributeState = g_objAgentUpdateInfo.find('#distributestate');
		var objDistributedCount = g_objAgentUpdateInfo.find('#distributedcount');
		var objLastModifiedDatetime = g_objAgentUpdateInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objAgentUpdateInfo.find('#createdatetime');

		var objRowDistributeState = g_objAgentUpdateInfo.find('#row-distributestate');
		var objRowDistributedCount = g_objAgentUpdateInfo.find('#row-distributedcount');
		var objRowLastModifiedDatetime = g_objAgentUpdateInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objAgentUpdateInfo.find('#row-createdatetime');

		g_objAgentUpdateInfo.find('#validateTips').hide();
		g_objAgentUpdateInfo.find('input:text').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		var currentDate = new Date();
		var currentDateString = currentDate.formatString("yyyyMMddhhmmss");
		objVersion.val(currentDateString);
		objTitle.val("");
		objContent.val("");
		fillDropdownList(objCompanyId, g_htCompanyList, null, "전체");
		fillDropdownList(objDownloadPath, g_htDownloadPathList, null, "선택");
		fillDropdownList(objInfoFileName, null, null, "선택");
		objInfoContent.text('');

		objVersion.attr('readonly', false);
		objVersion.removeClass('ui-priority-secondary');
		objVersion.tooltip({ disabled: false });

		objRowDistributeState.hide();
		objRowDistributedCount.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		$('button[name="btnNew"]').hide();
		$('button[name="btnStopDistribute"]').hide();
		$('button[name="btnResumeDistribute"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 에이전트 업데이트');
		g_objAgentUpdateList.hide();
		g_objAgentUpdateInfo.show();
	};

	insertAgentUpdate = function() {

		var postData = getRequestInsertAgentUpdateParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAgentUpdateInfo.find('input[name="version"]').val(),
				g_objAgentUpdateInfo.find('input[name="title"]').val(),
				g_objAgentUpdateInfo.find('textarea[name="content"]').val(),
				g_objAgentUpdateInfo.find('select[name="companyid"]').val(),
				g_objAgentUpdateInfo.find('select[name="downloadpath"]').val(),
				g_objAgentUpdateInfo.find('select[name="infofilename"]').val());

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
					displayAlertDialog("업데이트 정보 등록", "업데이트 정보 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAgentUpdateList();
					displayInfoDialog("업데이트 정보 등록", "정상 처리되었습니다.", "정상적으로 업데이트 정보가 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("업데이트 정보 등록", "업데이트 정보 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateAgentUpdate = function() {

		var postData = getRequestUpdateAgentUpdateParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAgentUpdateInfo.find('input[name="version"]').val(),
				g_objAgentUpdateInfo.find('input[name="title"]').val(),
				g_objAgentUpdateInfo.find('textarea[name="content"]').val(),
				g_objAgentUpdateInfo.find('select[name="companyid"]').val(),
				g_objAgentUpdateInfo.find('select[name="downloadpath"]').val(),
				g_objAgentUpdateInfo.find('select[name="infofilename"]').val());

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
					displayAlertDialog("업데이트 정보 변경", "업데이트 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAgentUpdateList();
					displayInfoDialog("업데이트 정보 변경", "정상 처리되었습니다.", "정상적으로 업데이트 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("업데이트 정보 변경", "업데이트 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	changeAgentUpdateDistributeState = function(distributeState) {

		var postData = getRequestChangeAgentUpdateDistributeStateParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAgentUpdateInfo.find('input[name="version"]').val(),
				distributeState);

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
					displayAlertDialog("업데이트 정보 배포 상태 변경", "업데이트 정보 배포 상태 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAgentUpdateList();
					displayInfoDialog("업데이트 정보 배포 상태 변경", "정상 처리되었습니다.", "정상적으로 업데이트 정보 배포 상태가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("업데이트 정보 배포 상태 변경", "업데이트 정보 배포 상태 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteAgentUpdate = function() {

		var postData = getRequestDeleteAgentUpdateParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAgentUpdateInfo.find('input[name="version"]').val());

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
					displayAlertDialog("업데이트 정보 삭제", "업데이트 정보 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadAgentUpdateList();
					displayInfoDialog("업데이트 정보 삭제", "정상 처리되었습니다.", "정상적으로 업데이트 정보가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("업데이트 정보 삭제", "업데이트 정보 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateAgentUpdateData = function() {

		var objTitle = g_objAgentUpdateInfo.find('input[name="title"]');
		var objDownloadPath = g_objAgentUpdateInfo.find('select[name="downloadpath"]');
		var objInfoFileName = g_objAgentUpdateInfo.find('select[name="infofilename"]');
		var objValidateTips = g_objAgentUpdateInfo.find('#validateTips');

		if (objTitle.val().length == 0) {
			updateTips(objValidateTips, "업데이트 정보 제목을 입력해주세요.");
			objTitle.focus();
			return false;
		}

		if (objDownloadPath.val().length == 0) {
			updateTips(objValidateTips, "업데이트 정보 경로를 선택해주세요.");
			objDownloadPath.focus();
			return false;
		}

		if (objInfoFileName.val().length == 0) {
			updateTips(objValidateTips, "업데이트 정보 파일을 입력해주세요.");
			objInfoFileName.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
</div>
<div class="inner-center">
	<div class="pane-header">에이전트 업데이트 목록</div>
	<div class="ui-layout-content">
		<div id="agentupdate-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>제목
				<input type="text" id="searchtitle" name="searchtitle" class="text ui-widget-content" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>내용
				<input type="text" id="searchcontent" name="searchcontent" class="text ui-widget-content" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>배포 상태
				<select id="searchdistributestate" name="searchdistributestate" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>등록 기간
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
		<div id="agentupdate-info" class="info-form">
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
				<div id="row-version" class="field-line">
					<div class="field-title">업데이트 정보 버전<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="version" name="version" class="text ui-widget-content" /></div>
				</div>
				<div id="row-title" class="field-line">
					<div class="field-title">업데이트 정보 제목<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="title" name="title" class="text ui-widget-content" /></div>
				</div>
				<div id="row-content" class="field-line">
					<div class="field-title">업데이트 정보 내용</div>
					<div class="field-contents"><textarea id="content" name="content" class="text ui-widget-content" style="height: 120px;"></textarea></div>
				</div>
				<div id="row-companyid" class="field-line">
					<div class="field-title">업데이트 대상 사업장<span class="required_field">*</span></div>
					<div class="field-value"><select id="companyid" name="companyid" class="ui-widget-content"></select></div>
				</div>
				<div id="row-downloadpath" class="field-line">
					<div class="field-title">업데이트 정보 경로<span class="required_field">*</span></div>
					<div class="field-value"><select id="downloadpath" name="downloadpath" class="ui-widget-content"></select></div>
				</div>
				<div id="row-infofilename" class="field-line">
					<div class="field-title">업데이트 정보 파일<span class="required_field">*</span></div>
					<div class="field-value"><select id="infofilename" name="infofilename" class="ui-widget-content"></select></div>
				</div>
				<div id="row-infocontent" class="field-line">
					<div class="field-title">업데이트 정보</div>
					<div class="field-contents" style="position: relative;"><div id="infocontent" style="width: 98%; height: 536px; position: relative; overflow: auto; white-space: normal;"></div></div>
				</div>
				<div id="row-distributestate" class="field-line">
					<div class="field-title">배포 상태</div>
					<div class="field-value"><span id="distributestate"></span></div>
				</div>
				<div id="row-distributedcount" class="field-line">
					<div class="field-title">배포 수</div>
					<div class="field-value"><span id="distributedcount"></span></div>
				</div>
				<div id="row-lastmodifieddatetime" class="field-line">
					<div class="field-title">최종 변경 일시</div>
					<div class="field-value"><span id="lastmodifieddatetime"></span></div>
				</div>
				<div id="row-createdatetime" class="field-line">
					<div class="field-title">등록 일시</div>
					<div class="field-value"><span id="createdatetime"></span></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnList" name="btnList" class="normal-button" style="display: none;">업데이트 목록</button>
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 업데이트</button>
			<button type="button" id="btnStopDistribute" name="btnStopDistribute" class="normal-button" style="display: none;">배포 중지</button>
			<button type="button" id="btnResumeDistribute" name="btnResumeDistribute" class="normal-button" style="display: none;">배포 진행</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">업데이트 정보 등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">업데이트 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">업데이트 정보 삭제</button>
		</div>
	</div>
</div>
