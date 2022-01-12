<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = 480;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openSoftwareCopyrightInfoDialog = function(seqNo) {

		var postData = getRequestSoftwareCopyrightInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 저작권 정보 조회", "소프트웨어 저작권 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
					"closable" : true,
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
				dialogContents = '<div title="소프트웨어 저작권 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="row-softwarename" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">소프트웨어 명</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="softwarename">' + $(data).find('softwarename').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-softwaretype" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">소프트웨어 유형</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="softwaretype">' + g_htSoftwareTypeList.get($(data).find('softwaretype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-description" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">설명</div>';
				dialogContents += '<div class="ui-corner-right field-contents"><div id="description" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + $(data).find('description').text() + '</span></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-price" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">가격</div>';
				if (($(data).find('price').text() != null) && $(data).find('price').text().length > 0) {
					dialogContents += '<div class="ui-corner-right field-value"><span id="price">' + $(data).find('price').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
				} else {
					dialogContents += '<div class="ui-corner-right field-value"><span id="price">&nbsp;</span></div>';
				}
				dialogContents += '</div>';
				dialogContents += '<div id="row-filename" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">파일 명</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="filename">' + $(data).find('filename').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filesize" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">파일 크기</div>';
				if (($(data).find('filesize').text() != null) && $(data).find('filesize').text().length > 0) {
					dialogContents += '<div class="ui-corner-right field-value"><span id="filesize">' + $(data).find('filesize').text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
				} else {
					dialogContents += '<div class="ui-corner-right field-value"><span id="filesize">&nbsp;</span></div>';
				}
				dialogContents += '</div>';
				dialogContents += '<div id="row-manufacturer" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">제조사</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="manufacturer">' + $(data).find('manufacturer').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-vendor" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">공급사</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="vendor">' + $(data).find('vendor').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-vendoremail" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">공급사 E-Mail</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="vendoremail">' + $(data).find('vendoremail').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-vendorphone" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">공급사 전화번호</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="vendorphone">' + $(data).find('vendorphone').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-vendorfax" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">공급사 Fax</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="vendorfax">' + $(data).find('vendorfax').text() + '</span></div>';
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
					displayAlertDialog("소프트웨어 저작권 정보 조회", "소프트웨어 저작권 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
