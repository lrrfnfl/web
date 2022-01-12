<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openDrmPermissionSettingsLogInfoDialog = function(seqNo) {

		var postData = getRequestDrmPermissionSettingsLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("문서보안 권한 설정 정보 조회", "문서보안 권한 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
					"minimizable" : true,
					"collapsable" : true,
					"dblclick" : "collapse",
					"maximize" : function(event, ui) {},
					"restore" : function(event, dialog){}
				};

				var dialogContents = "";
				dialogContents = '<div title="문서보안 권한 설정 정보" class="dialog-form">';
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
				dialogContents += '<div class="field-title">파일명</div>';
				dialogContents += '<div class="field-value"><span id="filename">' + $(data).find('filename').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filepath" class="field-line">';
				dialogContents += '<div class="field-title">파일경로</div>';
				dialogContents += '<div class="field-contents"><div id="filenpath" style="width: 98%; height: 40px; line-height: 20px; overflow:hidden; word-break:break-all;">' + $(data).find('filepath').text() + '</div></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-policyid" class="field-line">';
				dialogContents += '<div class="field-title">정책 ID</div>';
				dialogContents += '<div class="field-value"><span id="policyid">' + $(data).find('policyid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-policyname" class="field-line">';
				dialogContents += '<div class="field-title">정책명</div>';
				dialogContents += '<div class="field-value"><span id="policyname">' + $(data).find('policyname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-readpermission" class="field-line">';
				dialogContents += '<div class="field-title">읽기 권한</div>';
				dialogContents += '<div class="field-value"><span id="readpermission">' + g_htOptionTypeList.get($(data).find('readpermission').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-writepermission" class="field-line">';
				dialogContents += '<div class="field-title">쓰기 권한</div>';
				dialogContents += '<div class="field-value"><span id="writepermission">' + g_htOptionTypeList.get($(data).find('writepermission').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-printpermission" class="field-line">';
				dialogContents += '<div class="field-title">출력 권한</div>';
				dialogContents += '<div class="field-value"><span id="printpermission">' + g_htOptionTypeList.get($(data).find('printpermission').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-expirationdate" class="field-line">';
				dialogContents += '<div class="field-title">접근 만료 일자</div>';
				dialogContents += '<div class="field-value"><span id="expirationdate">' + $(data).find('expirationdate').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-readlimitcount" class="field-line">';
				dialogContents += '<div class="field-title">접근 제한 횟수</div>';
				dialogContents += '<div class="field-value"><span id="readlimitcount">' + $(data).find('readlimitcount').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
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
					displayAlertDialog("문서보안 권한 설정 정보 조회", "문서보안 권한 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
