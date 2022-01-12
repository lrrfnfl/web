<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objDetectFileExpirationExtendHistoryDialog;

	var g_searchHistoryListOrderByName = "";
	var g_searchHistoryListOrderByDirection = "";

	$(document).ready(function() {
		g_objDetectFileExpirationExtendHistoryDialog = $('#dialog-detectfileexpirationextendhistory');
	});

	openDetectFileExpirationExtendHistoryDialog = function(objDetectFileInfoDialog) {

		loadDetectFileExpirationExtendHistory(objDetectFileInfoDialog);

		g_objDetectFileExpirationExtendHistoryDialog.find('.scroll-table').scrolltable({
			stripe: true,
			oddClass: 'odd'
		});

		g_objDetectFileExpirationExtendHistoryDialog.dialog({
			autoOpen: false,
			width: 800,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().focus();
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				g_searchHistoryListOrderByName = "";
				g_searchHistoryListOrderByDirection = "";
			},
			resizeStop: function(event, ui) {
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			}
		})
		.dialogExtend({
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
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			}
		});

		g_objDetectFileExpirationExtendHistoryDialog.dialog('open');
	};

	loadDetectFileExpirationExtendHistory = function(objDetectFileInfoDialog) {

		var objSearchResult = g_objDetectFileExpirationExtendHistoryDialog.find('#search-result');
		var objResultList = objSearchResult.find('#result-list');

		var postData = getRequestDetectFileExpirationExtendHistoryParam(
				objDetectFileInfoDialog.find('input[name="companyid"]').val(),
				objDetectFileInfoDialog.find('input[name="deptcode"]').val(),
				objDetectFileInfoDialog.find('#userid').text(),
				objDetectFileInfoDialog.find('#lastsearchid').text(),
				objDetectFileInfoDialog.find('input[name="lastsearchseqno"]').val(),
				g_searchHistoryListOrderByName,
				g_searchHistoryListOrderByDirection,
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
					displayAlertDialog("파일 보관 만료일 변경 내역 조회", "파일 보관 만료일 변경 내역 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var dialogContents = '';
				dialogContents += '<table class="ui-widget-content scroll-table">';
				dialogContents += '<thead>';
				dialogContents += '<tr>';
				dialogContents += '<th width="15%" id="REQUESTERNAME">요청자</th>';
				dialogContents += '<th width="10%" id="REQUESTTYPE">요청자 유형</th>';
				dialogContents += '<th id="REASON">요청 사유</th>';
				dialogContents += '<th width="90" id="EXTENDDATE">파일 보관 만료일</th>';
				dialogContents += '<th width="110" id="REPORTINGDATETIME">요청일</th>';
				dialogContents += '</tr>';
				dialogContents += '</thead>';
				dialogContents += '<tbody>';

				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var requesterType = $(this).find('requestertype').text();
						var requesterName = $(this).find('requestername').text();
						var reason = $(this).find('reason').text();
						var extendDate = $(this).find('extenddate').text();
						var reportingDatetime = $(this).find('reportingdatetime').text();

						dialogContents += '<tr class="' + lineStyle + '">';
						dialogContents += '<td>' + requesterName + '</td>';
						dialogContents += '<td>' + g_htRequesterTypeList.get(requesterType) + '</td>';
						dialogContents += '<td title="' + reason + '">' + reason + '</td>';
						dialogContents += '<td>' + extendDate + '</td>';
						dialogContents += '<td>' + reportingDatetime + '</td>';
						dialogContents += '</tr>';

						recordCount++;
					});
					dialogContents += '</tbody>';
					dialogContents += '</table>';

					objResultList.html(dialogContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objDetectFileExpirationExtendHistoryDialog.find('.scroll-table th').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objDetectFileExpirationExtendHistoryDialog.find('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objDetectFileExpirationExtendHistoryDialog.find('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objResultList.append(inlineScript);
				} else {
					dialogContents += '<tr>';
					dialogContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">파일 보관 만료일 변경 내역이 존재하지 않습니다.</div></td>';
					dialogContents += '</tr>';
					dialogContents += '</tbody>';
					dialogContents += '</table>';

					objResultList.html(dialogContents);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("파일 보관 만료일 변경 내역 조회", "파일 보관 만료일 변경 내역 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-detectfileexpirationextendhistory" title="파일 보관 만료일 변경 내역" class="dialog-form">
	<div class="dialog-contents">
		<div id="search-result">
			<div id="result-list"></div>
		</div>
	</div>
</div>
