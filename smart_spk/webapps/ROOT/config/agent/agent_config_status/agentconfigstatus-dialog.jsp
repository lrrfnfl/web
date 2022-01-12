<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = ($(document).height()*3)/4;
	var g_lastDialogPosition;

	openAgentConfigStatusInfoDialog = function(companyId, userId) {

		var postData = getRequestAgentConfigStatusInfoParam(companyId, userId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("에이전트 설정 현황 정보 조회", "에이전트 설정 현황 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
					"minimizable" : false,
					"collapsable" : false,
					"dblclick" : "collapse",
					"maximize" : function(event, ui) {
					},
					"restore" : function(event, dialog){
					}
				};

				var dialogContents = "";
				dialogContents = '<div title="에이전트 설정 현황 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div class="category-sub-title">사업장 정보</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
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
				dialogContents += '</div>';
				dialogContents += '<div class="category-sub-title">기본 정책</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
				dialogContents += '<div id="row-jobprocessingtype" class="field-line">';
				dialogContents += '<div class="field-title">검출파일 처리유형</div>';
				dialogContents += '<div class="field-value"><span id="jobprocessingtype">' + g_htJobProcessingTypeList.get($(data).find('jobprocessingtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-forcedterminationflag" class="field-line">';
				dialogContents += '<div class="field-title">강제종료 차단</div>';
				dialogContents += '<div class="field-value"><span id="forcedterminationflag">' + g_htOptionTypeList.get($(data).find('forcedterminationflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decordingpermissionflag" class="field-line">';
				dialogContents += '<div class="field-title">복호화 허용</div>';
				dialogContents += '<div class="field-value"><span id="decordingpermissionflag">' + g_htOptionTypeList.get($(data).find('decordingpermissionflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-contentcopypreventionflag" class="field-line">';
				dialogContents += '<div class="field-title">복사 방지</div>';
				dialogContents += '<div class="field-value"><span id="contentcopypreventionflag">' + g_htOptionTypeList.get($(data).find('contentcopypreventionflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-realtimeobservationflag" class="field-line">';
				dialogContents += '<div class="field-title">실시간 감시</div>';
				dialogContents += '<div class="field-value"><span id="realtimeobservationflag">' + g_htOptionTypeList.get($(data).find('realtimeobservationflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-passwordexpirationflag" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 유효기간 설정</div>';
				dialogContents += '<div class="field-value"><span id="passwordexpirationflag">' + g_htOptionTypeList.get($(data).find('passwordexpirationflag').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('passwordexpirationflag').text() == '<%=OptionType.OPTION_TYPE_YES%>') {
					dialogContents += '<div id="row-passwordexpirationperiod" class="field-line">';
					dialogContents += '<div class="field-title">비밀번호 유효기간</div>';
					dialogContents += '<div class="field-value"><span id="passwordexpirationperiod">' + $(data).find('passwordexpirationperiod').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '일</span></div>';
					dialogContents += '</div>';
				}
				dialogContents += '</div>';
				dialogContents += '<div class="category-sub-title">워터마크</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
				dialogContents += '<div id="row-wmprintmode" class="field-line">';
				dialogContents += '<div class="field-title">출력 모드</div>';
				dialogContents += '<div class="field-value"><span id="wmprintmode">' + g_htPrintModeList.get($(data).find('wmprintmode').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div class="category-sub-title">매체 제어</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
				dialogContents += '<div id="row-usbcontrolflag" class="field-line">';
				dialogContents += '<div class="field-title">USB 제어</div>';
				dialogContents += '<div class="field-value"><span id="usbcontrolflag">' + g_htOptionTypeList.get($(data).find('usbcontrolflag').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('usbcontrolflag').text() == '<%=OptionType.OPTION_TYPE_YES%>') {
					dialogContents += '<div id="row-usbcontroltype" class="field-line">';
					dialogContents += '<div class="field-title">USB 제어 유형</div>';
					dialogContents += '<div class="field-value"><span id="usbcontroltype">' + g_htControlTypeList.get($(data).find('usbcontroltype').text()) + '</span></div>';
					dialogContents += '</div>';
				}
				dialogContents += '<div id="row-cdromcontrolflag" class="field-line">';
				dialogContents += '<div class="field-title">CD-ROM 제어</div>';
				dialogContents += '<div class="field-value"><span id="cdromcontrolflag">' + g_htOptionTypeList.get($(data).find('cdromcontrolflag').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('cdromcontrolflag').text() == '<%=OptionType.OPTION_TYPE_YES%>') {
					dialogContents += '<div id="row-cdromcontroltype" class="field-line">';
					dialogContents += '<div class="field-title">CD-ROM 제어 유형</div>';
					dialogContents += '<div class="field-value"><span id="cdromcontroltype">' + g_htControlTypeList.get($(data).find('cdromcontroltype').text()) + '</span></div>';
					dialogContents += '</div>';
				}
				dialogContents += '</div>';
				dialogContents += '<div class="category-sub-title">네트워크 서비스 제어</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
				dialogContents += '<div id="row-networkservicecontrolflag" class="field-line">';
				dialogContents += '<div class="field-title">네트워크 서비스 제어</div>';
				dialogContents += '<div class="field-value"><span id="networkservicecontrolflag">' + g_htOptionTypeList.get($(data).find('networkservicecontrolflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div class="category-sub-title">시스템 제어</div>';
				dialogContents += '<div class="category-contents border-none" style="padding: 5px 0;">';
				dialogContents += '<div id="row-systempasswordsetupflag" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 설정</div>';
				dialogContents += '<div class="field-value"><span id="systempasswordsetupflag">' + g_htOptionTypeList.get($(data).find('systempasswordsetupflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-systempasswordexpirationflag" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 유효기간 설정</div>';
				dialogContents += '<div class="field-value"><span id="systempasswordexpirationflag">' + g_htOptionTypeList.get($(data).find('systempasswordexpirationflag').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('systempasswordexpirationflag').text() == '<%=OptionType.OPTION_TYPE_YES%>') {
					dialogContents += '<div id="row-systempasswordexpirationperiod" class="field-line">';
					dialogContents += '<div class="field-title">비밀번호 유효기간</div>';
					dialogContents += '<div class="field-value"><span id="systempasswordexpirationperiod">' + $(data).find('systempasswordexpirationperiod').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '일</span></div>';
					dialogContents += '</div>';
				}
				dialogContents += '<div id="row-screensaveractivationflag" class="field-line">';
				dialogContents += '<div class="field-title">화면 보호기 설정</div>';
				dialogContents += '<div class="field-value"><span id="screensaveractivationflag">' + g_htOptionTypeList.get($(data).find('screensaveractivationflag').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('screensaveractivationflag').text() == '<%=OptionType.OPTION_TYPE_YES%>') {
					dialogContents += '<div id="row-screensaverwaitingminutes" class="field-line">';
					dialogContents += '<div class="field-title">활성화 대기 시간</div>';
					dialogContents += '<div class="field-value"><span id="screensaverwaitingminutes">' + $(data).find('screensaverwaitingminutes').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '분</span></div>';
					dialogContents += '</div>';
				}
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
					displayAlertDialog("에이전트 설정 현황 정보 조회", "에이전트 설정 현황 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
