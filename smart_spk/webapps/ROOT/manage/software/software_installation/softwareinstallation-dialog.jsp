<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openSoftwareInstallationInfoDialog = function(seqNo) {

		var postData = getRequestSoftwareInstallationInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 설치 정보 조회", "소프트웨어 설치 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
						resizeDialogElement($(this), $(this).find('#description'));
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
						resizeDialogElement($(this), $(this).find('#description'));
					},
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#description'));
					}
				};

				var dialogContents = "";
				dialogContents = '<div title="소프트웨어 설치 정보" class="dialog-form">';
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
				dialogContents += '<div id="row-softwarename" class="field-line">';
				dialogContents += '<div class="field-title">소프트웨어 명</div>';
				dialogContents += '<div class="field-value"><span id="softwarename">' + $(data).find('softwarename').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-version" class="field-line">';
				dialogContents += '<div class="field-title">버전</div>';
				dialogContents += '<div class="field-value"><span id="version">' + $(data).find('version').text() + '</span></div>';
				dialogContents += '</div>';
// 				dialogContents += '<div id="row-filename" class="field-line">';
// 				dialogContents += '<div class="field-title">파일 명</div>';
// 				dialogContents += '<div class="field-value"><span id="filename">' + $(data).find('filename').text() + '</span></div>';
// 				dialogContents += '</div>';
// 				dialogContents += '<div id="row-filesize" class="field-line">';
// 				dialogContents += '<div class="field-title">파일 크기</div>';
// 				if (($(data).find('filesize').text() != null) && $(data).find('filesize').text().length > 0) {
// 					dialogContents += '<div class="field-value"><span id="filesize">' + $(data).find('filesize').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
// 				} else {
// 					dialogContents += '<div class="field-value"><span id="filesize">&nbsp;</span></div>';
// 				}
// 				dialogContents += '</div>';
				dialogContents += '<div id="row-description" class="field-line">';
				dialogContents += '<div class="field-title">설명</div>';
				dialogContents += '<div class="field-contents"><div id="description" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + $(data).find('description').text() + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-vendor" class="field-line">';
				dialogContents += '<div class="field-title">공급사</div>';
				dialogContents += '<div class="field-value"><span id="vendor">' + $(data).find('vendor').text() + '</span></div>';
				dialogContents += '</div>';
// 				dialogContents += '<div id="row-installedpath" class="field-line">';
// 				dialogContents += '<div class="field-title">설치 경로</div>';
// 				dialogContents += '<div class="field-value" title="' + $(data).find('installedpath').text() + '"><span id="installedpath">' + $(data).find('installedpath').text() + '</span></div>';
// 				dialogContents += '</div>';
				dialogContents += '<div id="row-installeddate" class="field-line">';
				dialogContents += '<div class="field-title">설치 일자</div>';
				dialogContents += '<div class="field-value"><span id="installeddate">' + $(data).find('installeddate').text() + '</span></div>';
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
					displayAlertDialog("소프트웨어 설치 정보 조회", "소프트웨어 설치 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
