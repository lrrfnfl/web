<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<style>
	#tab-decodingapprovalinfo > .ui-widget-header { 
		border: none;
		background: #aaa url(/js/jquery-ui-1.10.3/css/custom-theme/images/ui-bg_highlight-soft_75_e0e0e0_1x100.png) 50% 50% repeat-x;
		border-top-left-radius: 0px;
		border-top-right-radius: 0px;
		border-bottom-left-radius: 0px;
		border-bottom-right-radius: 0px;
	}
</style>
<script type="text/javascript">
<!--
	var g_dialogWidth = 800;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;
	var g_requestInfoHeight = 0;
	var g_selectedTabPannel;

	openDecodingApprovalInfoDialog = function(seqNo) {

		var postData = getRequestDecodingApprovalInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결재 정보 조회", "결재 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var dialogOptions = {
					"minWidth" : 450,
					"maxWidth" : $(document).width(),
					"width" : g_dialogWidth,
					"height" : g_dialogHeight,
					"minHeight" : 240,
					"maxHeight" : $(document).height(),
					"resizable" : true,
					"draggable" : true,
					"open" : function(event, ui) {
						$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
		 					icons: { primary: 'ui-icon-circle-check' }
						});
						$(this).parent().focus();
					},
					"resizeStop" : function(event, ui) {
						g_dialogWidth = $(this).dialog("option", "width");
						g_dialogHeight = $(this).dialog("option", "height");
						var tabPannel = $(this).find('.ui-tabs-panel:eq(' + $(this).find('#tab-decodingapprovalinfo').tabs('option', 'active') + ')');
						if (tabPannel.find('#requestinfo').length) {
							resizeDialogElement($(this), $(this).find('#reason'));
							$(this).find('#requestinfo').mCustomScrollbar('update');
						} else if (tabPannel.find('.scroll-table').length) {
							resizeDialogElement($(this), tabPannel.find('.scroll-table'));

							var inlineScriptText = "";
							inlineScriptText += "$('.scroll-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
							inlineScriptText += "$('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
							inlineScriptText += "$('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
							var inlineScript   = document.createElement("script");
							inlineScript.type  = "text/javascript";
							inlineScript.text  = inlineScriptText;
							tabPannel.append(inlineScript);
						}
					},
					"dragStop" : function(event, ui) {
						g_lastDialogPosition = ui.position;
					},
					"buttons" : {
						"확인": function() {
							$(this).dialog('close');
						}
					},
					"close" : function() {
					}
				};

				var dialogExtendOptions = {
					"closable" : false,
					"maximizable" : true,
					"minimizable" : true,
					"collapsable" : true,
					"dblclick" : "collapse",
					"load" : function(event, dialog){ },
					"beforeCollapse" : function(event, dialog){ },
					"beforeMaximize" : function(event, dialog){ },
					"beforeMinimize" : function(event, dialog){ },
					"beforeRestore" : function(event, dialog){ },
					"collapse" : function(event, dialog){ },
					"maximize" : function(event, dialog){
						var tabPannel = $(this).find('.ui-tabs-panel:eq(' + $(this).find('#tab-decodingapprovalinfo').tabs('option', 'active') + ')');
						if (tabPannel.find('#requestinfo').length) {
							resizeDialogElement($(this), $(this).find('#reason'));
							$(this).find('#requestinfo').mCustomScrollbar('update');
						} else if (tabPannel.find('.scroll-table').length) {
							resizeDialogElement($(this), tabPannel.find('.scroll-table'));
						}
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog) {
						var tabPannel = $(this).find('.ui-tabs-panel:eq(' + $(this).find('#tab-decodingapprovalinfo').tabs('option', 'active') + ')');
						if (tabPannel.find('#requestinfo').length) {
							resizeDialogElement($(this), $(this).find('#reason'));
							$(this).find('#requestinfo').mCustomScrollbar('update');
						} else if (tabPannel.find('.scroll-table').length) {
							resizeDialogElement($(this), tabPannel.find('.scroll-table'));
						}
					}
				};

				var reason = $(data).find('reason').text();
				reason = reason.replace(/\n/g, "<br />");
				reason = reason.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogContents = "";
				dialogContents = '<div title="결재 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="tab-decodingapprovalinfo" class="styles-tab" style="border: none;">';
				dialogContents += '<ul>';
				dialogContents += '<li><a href="#tab-requestinfo">요청 정보</a></li>';
				dialogContents += '<li><a href="#tab-fileinfo">요청 파일</a></li>';
				dialogContents += '<li><a href="#tab-approvalstatusinfo">결재 상황</a></li>';
				dialogContents += '<li><a href="#tab-requesthistory">요청 내역</a></li>';
				dialogContents += '</ul>';
				dialogContents += '<div id="tab-requestinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<div id="requestinfo">';
				dialogContents += '<input type="hidden" id="companyid" name="companyid" value="' + $(data).find('companyid').text() + '" />';
				dialogContents += '<input type="hidden" id="deptcode" name="deptcode" value="' + $(data).find('deptcode').text() + '" />';
				dialogContents += '<input type="hidden" id="approvalid" name="approvalid" value="' + $(data).find('approvalid').text() + '" />';
				dialogContents += '<div id="row-companyname" class="field-line">';
				dialogContents += '<div class="field-title">사업장</div>';
				dialogContents += '<div class="field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-deptname" class="field-line">';
				dialogContents += '<div class="field-title">부서</div>';
				dialogContents += '<div class="field-value"><span id="deptname">' + $(data).find('deptname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-userid" class="field-line">';
				dialogContents += '<div class="field-title">사용자 ID</div>';
				dialogContents += '<div class="field-value"><span id="userid">' + $(data).find('userid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-username" class="field-line">';
				dialogContents += '<div class="field-title">사용자 명</div>';
				dialogContents += '<div class="field-value"><span id="username">' + $(data).find('username').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-approvalkind" class="field-line">';
				dialogContents += '<div class="field-title">결재 종류</div>';
				dialogContents += '<div class="field-value"><span id="approvalkind">' + g_htDecodingApprovalKindList.get($(data).find('approvalkind').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-approvaltype" class="field-line">';
				dialogContents += '<div class="field-title">결재 유형</div>';
				dialogContents += '<div class="field-value"><span id="approvaltype">' + g_htDecodingApprovalTypeList.get($(data).find('approvaltype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-approvalpriority" class="field-line">';
				dialogContents += '<div class="field-title">결재 순위</div>';
				dialogContents += '<div class="field-value"><span id="approvalpriority">' + $(data).find('approvalpriority').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-reason" class="field-line">';
				dialogContents += '<div class="field-title">요청 사유</div>';
				dialogContents += '<div class="field-contents"><div id="reason" style="width: 98%; height: 20px; overflow: auto; white-space: normal;">' + reason + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-originfileipaddress" class="field-line">';
				dialogContents += '<div class="field-title">요청 파일 주소</div>';
				dialogContents += '<div class="field-value"><span id="originfileipaddress">' + $(data).find('originfileipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-requestdatetime" class="field-line">';
				dialogContents += '<div class="field-title">요청 일시</div>';
				dialogContents += '<div class="field-value"><span id="requestdatetime">' + $(data).find('requestdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-priorityinprogress" class="field-line">';
				dialogContents += '<div class="field-title">결재 진행 순위</div>';
				dialogContents += '<div class="field-value"><span id="priorityinprogress">' + $(data).find('priorityinprogress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-approvalstate" class="field-line">';
				dialogContents += '<div class="field-title">결재 상태</div>';
				dialogContents += '<div class="field-value"><span id="approvalstate">' + g_htDecodingApprovalStateList.get($(data).find('approvalstate').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastmodifieddatetime" class="field-line">';
				dialogContents += '<div class="field-title">최종 변경 일시</div>';
				dialogContents += '<div class="field-value"><span id="lastmodifieddatetime">' + $(data).find('lastmodifieddatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="field-title">등록 일시</div>';
				dialogContents += '<div class="field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-fileinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-approvalstatusinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-requesthistory" style="padding: 8px 2px 0 2px;">';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				newDialog.find('#requestinfo').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

				g_requestInfoHeight = newDialog.find('#requestinfo').height();

				newDialog.find('#tab-decodingapprovalinfo').tabs({
					heightStyle: "content",
					active: 0,
					activate: function(event, ui) {
						if (ui.newTab.index() == 0) {
							resizeDialogElement(newDialog, ui.newPanel.find('#reason'));
						} else if (ui.newTab.index() == 1) {
							loadDecodingApprovalFileList(newDialog, ui.newPanel);
						} else if (ui.newTab.index() == 2) {
							loadDecodingApprovalStatusInfo(newDialog, ui.newPanel);
						} else if (ui.newTab.index() == 3) {
							loadDecodingApprovalHistory(newDialog, ui.newPanel);
						}
						g_selectedTabPannel = ui.newPanel;
					}
				});

				if (!$.isEmptyObject(g_lastDialogPosition)) {
					newDialog.closest('.ui-dialog').offset({ top: g_lastDialogPosition.top+15, left: g_lastDialogPosition.left+15});
				} else {
					newDialog.dialog("option", "position", { my: "center", at: "center" } );
				}

				if ((newDialog.closest('.ui-dialog').offset().top + newDialog.closest('.ui-dialog').outerHeight(true)) >= $(window).height()) {
					newDialog.closest('.ui-dialog').offset({ top: 0, left: newDialog.closest('.ui-dialog').offset.left});
				}

				g_lastDialogPosition = newDialog.closest('.ui-dialog').offset();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결재 정보 조회", "결재 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadDecodingApprovalFileList = function(objDialog, objTabPannel) {

		var postData = getRequestDecodingApprovalFileListParam(
				objDialog.find('input[name="companyid"]').val(),
				objDialog.find('input[name="deptcode"]').val(),
				objDialog.find('#userid').text(),
				objDialog.find('input[name="approvalid"]').val(),
				"",
				"",
				"",
				"");

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결재 요청 파일 리스트 조회", "결재 요청 파일 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var pannelContents = '';
				pannelContents += '<table class="scroll-table">';
				pannelContents += '<thead>';
				pannelContents += '<tr>';
				pannelContents += '<th width="40">순번</th>';
				pannelContents += '<th>파일 경로</th>';
				pannelContents += '</tr>';
				pannelContents += '</thead>';
				pannelContents += '<tbody>';

				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						pannelContents += '<tr class="' + lineStyle + '">';
						pannelContents += '<td style="text-align: center;">' + recordCount + '</td>';
						pannelContents += '<td>' + $(this).find('filepath').text() + '</td>';
						pannelContents += '</tr>';

						recordCount++;
			  		});

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				} else {
					pannelContents += '<tr>';
					pannelContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">요청한 파일이 없습니다.</div></td>';
					pannelContents += '</tr>';

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				}

				objTabPannel.html(pannelContents);

				var inlineScriptText = "";
				inlineScriptText += "$('.scroll-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
				inlineScriptText += "$('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
				inlineScriptText += "$('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
				var inlineScript   = document.createElement("script");
				inlineScript.type  = "text/javascript";
				inlineScript.text  = inlineScriptText;
				objTabPannel.append(inlineScript);

				objTabPannel.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: g_requestInfoHeight - 28
				});

				resizeDialogElement(objDialog, objTabPannel.find('.scroll-table'));
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결재 요청 파일 리스트 조회", "결재 요청 파일 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadDecodingApprovalStatusInfo = function(objDialog, objTabPannel) {

		var postData = getRequestDecodingApprovalStatusInfoParam(
				objDialog.find('input[name="companyid"]').val(),
				objDialog.find('input[name="deptcode"]').val(),
				objDialog.find('#userid').text(),
				objDialog.find('input[name="approvalid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결재 상황 정보 조회", "결재 상황 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var pannelContents = '';
				pannelContents += '<table class="scroll-table">';
				pannelContents += '<thead>';
				pannelContents += '<tr>';
				pannelContents += '<th width="50">결재 순위</th>';
				pannelContents += '<th width="90">결재자</th>';
				pannelContents += '<th width="70">결재자 유형</th>';
				pannelContents += '<th width="70">결재 상태</th>';
				pannelContents += '<th>코멘트</th>';
				pannelContents += '<th width="125">결재 일시</th>';
				pannelContents += '</tr>';
				pannelContents += '</thead>';
				pannelContents += '<tbody>';

				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var comment = $(this).find('comment').text();
						comment = comment.replace(/\n/g, "<br />");
						comment = comment.replace(/\t/g, "&nbsp;&nbsp;");

						pannelContents += '<tr class="' + lineStyle + '">';
						pannelContents += '<td style="text-align: center;">' + $(this).find('approbatorpriority').text() + '</td>';
						pannelContents += '<td style="text-align: center;">' + $(this).find('approbatorusername').text() + '</td>';
						pannelContents += '<td style="text-align: center;">' + g_htDecodingApprobatorTypeList.get($(this).find('approbatortype').text()) + '</td>';
						pannelContents += '<td style="text-align: center;">' + g_htDecodingApprovalStateList.get($(this).find('approvalstate').text()) + '</td>';
						pannelContents += '<td title="' + comment + '">' + comment + '</td>';
						pannelContents += '<td><span style="text-align: center; white-space: normal">' + $(this).find('completedatetime').text() + '</span></td>';
						pannelContents += '</tr>';

						recordCount++;
					});

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				} else {
					pannelContents += '<tr>';
					pannelContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">결재 상황 정보이 존재하지 않습니다.</div></td>';
					pannelContents += '</tr>';

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				}

				objTabPannel.html(pannelContents);

				var inlineScriptText = "";
				inlineScriptText += "$('.scroll-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
				inlineScriptText += "$('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
				inlineScriptText += "$('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
				var inlineScript   = document.createElement("script");
				inlineScript.type  = "text/javascript";
				inlineScript.text  = inlineScriptText;
				objTabPannel.append(inlineScript);

				objTabPannel.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: g_requestInfoHeight - 28
				});

				resizeDialogElement(objDialog, objTabPannel.find('.scroll-table'));
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결재 상황 정보 조회", "결재 상황 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadDecodingApprovalHistory = function(objDialog, objTabPannel) {

		var postData = getRequestDecodingApprovalHistoryParam(
				objDialog.find('input[name="companyid"]').val(),
				objDialog.find('input[name="deptcode"]').val(),
				objDialog.find('#userid').text(),
				objDialog.find('input[name="approvalid"]').val(),
				"",
				"",
				"",
				"");

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결재 요청 내역 조회", "결재 요청 내역 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var pannelContents = '';
				pannelContents += '<table class="scroll-table">';
				pannelContents += '<thead>';
				pannelContents += '<tr>';
				pannelContents += '<th width="100">결재 종류</th>';
				pannelContents += '<th width="100">결재 유형</th>';
				pannelContents += '<th width="80">결재 순위</th>';
				pannelContents += '<th>요청 사유</th>';
				pannelContents += '<th width="125">요청 일시</th>';
				pannelContents += '</tr>';
				pannelContents += '</thead>';
				pannelContents += '<tbody>';

				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var reason = $(data).find('reason').text();
						reason = reason.replace(/\n/g, "<br />");
						reason = reason.replace(/\t/g, "&nbsp;&nbsp;");

						pannelContents += '<tr class="' + lineStyle + '">';
						pannelContents += '<td style="text-align: center;">' + g_htDecodingApprovalKindList.get($(this).find('approvalkind').text()) + '</td>';
						pannelContents += '<td style="text-align: center;">' + g_htDecodingApprovalTypeList.get($(this).find('approvaltype').text()) + '</td>';
						pannelContents += '<td style="text-align: center;">' + $(this).find('approvalpriority').text() + '</td>';
						pannelContents += '<td title="' + reason + '">' + reason + '</td>';
						pannelContents += '<td style="text-align: center;"><span style="text-align: center; white-space: normal">' + $(this).find('requestdatetime').text() + '</span></td>';
						pannelContents += '</tr>';

						recordCount++;
					});

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				} else {
					pannelContents += '<tr>';
					pannelContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">결재 요청 내역이 존재하지 않습니다.</div></td>';
					pannelContents += '</tr>';

					pannelContents += '</tbody>';
					pannelContents += '</table>';
				}

				objTabPannel.html(pannelContents);

				var inlineScriptText = "";
				inlineScriptText += "$('.scroll-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
				inlineScriptText += "$('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
				inlineScriptText += "$('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
				var inlineScript   = document.createElement("script");
				inlineScript.type  = "text/javascript";
				inlineScript.text  = inlineScriptText;
				objTabPannel.append(inlineScript);

				objTabPannel.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: g_requestInfoHeight - 28
				});

				resizeDialogElement(objDialog, objTabPannel.find('.scroll-table'));
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결재 요청 내역 조회", "결재 요청 내역 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
