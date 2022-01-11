<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openDbProtectionLogInfoDialog = function(seqNo) {

		var postData = getRequestDbProtectionLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("DB 보안 로그 정보 조회", "DB 보안 로그 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var logContents = $(data).find('logcontents').text();
				logContents = logContents.replace(/\n/g, "<br />");
				logContents = logContents.replace(/\t/g, "&nbsp;&nbsp;");
				if (logContents.length == 0)
					logContents = "&nbsp;";

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
						resizeDialogElement($(this), $(this).find('#logcontents'));
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#logcontents'));
					}
				};

				var dialogContents = "";
				dialogContents = '<div title="DB 보안 로그 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="row-companyname" class="field-line">';
				dialogContents += '<div class="field-title">사업장</div>';
				dialogContents += '<div class="field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-ipaddress" class="field-line">';
				dialogContents += '<div class="field-title">IP 주소</div>';
				dialogContents += '<div class="field-value"><span id="ipaddress">' + $(data).find('ipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-clientid" class="field-line">';
				dialogContents += '<div class="field-title">MAC 주소</div>';
				dialogContents += '<div class="field-value"><span id="clientid">' + $(data).find('clientid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-logtype" class="field-line">';
				dialogContents += '<div class="field-title">로그 유형</div>';
				dialogContents += '<div class="field-value"><span id="logtype">' + g_htDbProtectionLogTypeList.get($(data).find('logtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-logContents" class="field-line">';
				dialogContents += '<div class="field-title">로그 내용</div>';
				dialogContents += '<div class="field-contents"><div id="logcontents" style="width: 98%; height: 120px; overflow: auto;">' + logContents + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-logdatetime" class="field-line">';
				dialogContents += '<div class="field-title">처리 일시</div>';
				dialogContents += '<div class="field-value"><span id="logdatetime">' + $(data).find('logdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="field-title">등록 일시</div>';
				dialogContents += '<div class="field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
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
					displayAlertDialog("DB 보안 로그 정보 조회", "DB 보안 로그 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>