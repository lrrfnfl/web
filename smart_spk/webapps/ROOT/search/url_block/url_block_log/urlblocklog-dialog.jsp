<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = 480;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openUrlBlockLogInfoDialog = function(seqNo) {

		var postData = getRequestUrlBlockLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("URL 차단 정보 조회", "URL 차단 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var dialogOptions = {
					"minWidth" : 300,
					"maxWidth" : $(document).width(),
					"width" : g_dialogWidth,
					"height" : g_dialogHeight,
					"maxHeight" : $(document).height(),
					"resizable" : true,
					"draggable" : true,
					"open" : function() {
						$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
		 					icons: { primary: 'ui-icon-circle-check' }
						});
						$(this).parent().focus();
					},
					"resizeStop" : function() {
						g_dialogWidth = $(this).dialog("option", "width");
						g_dialogHeight = $(this).dialog("option", "height");
						resizeDialogElement($(this), $(this).find('#logcontents'));
					},
					"dragStop" : function( event, ui ) {
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
					"closable" : true,
					"maximizable" : true,
					"minimizable" : true,
					"collapsable" : true,
					"dblclick" : "collapse",
					"maximize" : function(event, ui) {
						resizeDialogElement($(this), $(this).find('#logcontents'));
					},
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#logcontents'));
					}
				};

				var logContents = $(data).find('logcontents').text();
				logContents = logContents.replace(/\n/g, "<br />");
				logContents = logContents.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogContents = "";
				dialogContents = '<div title="URL 차단 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="row-companyname" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">사업장</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-deptname" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">부서</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="deptname">' + $(data).find('deptname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-userid" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">사용자 ID</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="userid">' + $(data).find('userid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-username" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">사용자 명</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="username">' + $(data).find('username').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-blockurl" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">차단 URL</div>';
				dialogContents += '<div class="ui-corner-right field-contents"><span id="blockurl">' + $(data).find('blockurl').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-logcontents" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">차단 내용</div>';
				dialogContents += '<div class="ui-corner-right field-contents"><div id="logcontents" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + logContents + '</div></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-logdatetime" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">차단 일시</div>';
				dialogContents += '<div class="ui-corner-right field-contents"><span id="logdatetime">' + $(data).find('logdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-ipaddress" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">클라이언트 주소</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="ipaddress">' + $(data).find('ipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">등록 일시</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

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
					displayAlertDialog("URL 차단 정보 조회", "URL 차단 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
