<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openRealtimeObservationLogInfoDialog = function(seqNo) {

		var postData = getRequestRealtimeObservationLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("파일 감시 정보 조회", "파일 감시 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
						resizeDialogElement($(this), $(this).find('#observationcontents'));
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
					"maximize" : function(event, ui) {
						resizeDialogElement($(this), $(this).find('#observationcontents'));
					},
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#observationcontents'));
					}
				};

				var observationContents = $(data).find('observationcontents').text();
				observationContents = observationContents.replace(/\n/g, "<br />");
				observationContents = observationContents.replace(/\t/g, "&nbsp;&nbsp;");

				var detectPatternCount = $(data).find('detectpatterncount').text();
				var detectKeywordCount = $(data).find('detectkeywordcount').text();
				if (detectPatternCount.length == 0)
					detectPatternCount = 0;
				if (detectKeywordCount.length == 0)
					detectKeywordCount = 0;

				var dialogContents = "";
				dialogContents = '<div title="파일 감시 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
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
				dialogContents += '<div id="row-usertype" class="field-line">';
				dialogContents += '<div class="field-title">사용자 유형</div>';
				dialogContents += '<div class="field-value"><span id="usertype">' + g_htUserTypeList.get($(data).find('usertype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filepath" class="field-line">';
				dialogContents += '<div class="field-title">감시 파일명</div>';
				dialogContents += '<div class="field-contents"><span id="filepath">' + $(data).find('filepath').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-observationtype" class="field-line">';
				dialogContents += '<div class="field-title">감시 유형</div>';
				dialogContents += '<div class="field-value"><span id="observationtype">' + g_htRealtimeObservationTypeList.get($(data).find('observationtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-observationcontents" class="field-line">';
				dialogContents += '<div class="field-title">감시 코멘트</div>';
				dialogContents += '<div class="field-contents"><div id="observationcontents" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + observationContents + '</div></div>';
				dialogContents += '</div>';
				//dialogContents += '<div id="row-detectpatterncount" class="field-line">';
				//dialogContents += '<div class="field-title">검출 패턴 유형</div>';
				//dialogContents += '<div class="field-value"><span id="detectpatterncount">' + detectPatternCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 패턴</div>';
				//dialogContents += '</div>';
				//dialogContents += '<div id="row-detectkeywordcount" class="field-line">';
				//dialogContents += '<div class="field-title">검출 패턴 수</div>';
				//dialogContents += '<div class="field-value"><span id="detectkeywordcount">' + detectKeywordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 건</div>';
				//dialogContents += '</div>';
				dialogContents += '<div id="row-ipaddress" class="field-line">';
				dialogContents += '<div class="field-title">클라이언트 주소</div>';
				dialogContents += '<div class="field-value"><span id="ipaddress">' + $(data).find('ipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="field-title">감시 일시</div>';
				dialogContents += '<div class="field-value"><span id="observationdatetime">' + $(data).find('observationdatetime').text() + '</span></div>';
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
					displayAlertDialog("파일 감시 정보 조회", "파일 감시 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
