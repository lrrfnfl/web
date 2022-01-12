<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_dialogWidth = 500;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openSafeExportInfoDialog = function(seqNo) {

		var postData = getRequestSafeExportInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("안전반출 정보 조회", "안전반출 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var dialogOptions = {
					"minWidth" : 400,
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
					"focus" : function(event, ui) {
						var inlineScriptText = "";
						inlineScriptText += "$('.scroll-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
						inlineScriptText += "$('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
						inlineScriptText += "$('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";

						var inlineScript   = document.createElement("script");
						inlineScript.type  = "text/javascript";
						inlineScript.text  = inlineScriptText;

						$(this).append(inlineScript);
					},
					"resizeStop" : function(event, ui) {
						g_dialogWidth = $(this).dialog("option", "width");
						g_dialogHeight = $(this).dialog("option", "height");
						resizeDialogElement($(this), $(this).find('#exportinfo'));
						$(this).find('#exportinfo').mCustomScrollbar('update');
						resizeDialogElement($(this), $(this).find('.scroll-table'));
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
					"closable" : true,
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
						resizeDialogElement($(this), $(this).find('#exportinfo'));
						$(this).find('#exportinfo').mCustomScrollbar('update');
						resizeDialogElement($(this), $(this).find('.scroll-table'));
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#exportinfo'));
						$(this).find('#exportinfo').mCustomScrollbar('update');
						resizeDialogElement($(this), $(this).find('.scroll-table'));
					}
				};

				var exportFilesCount = $(data).find('exportfilescount').text();
				if (exportFilesCount.length == 0)
					exportFilesCount = 0;

				var description = $(data).find('description').text();
				description = description.replace(/\n/g, "<br />");
				description = description.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogContents = "";
				dialogContents = '<div title="안전반출 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="tab-safeexportinfo" class="styles-tab" style="border: none;">';
				dialogContents += '<ul>';
				dialogContents += '<li><a href="#tab-exportinfo">안전반출 정보</a></li>';
				dialogContents += '<li><a href="#tab-filesinfo">파일 정보</a></li>';
				dialogContents += '</ul>';
				dialogContents += '<div id="tab-exportinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<div id="exportinfo">';
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
				dialogContents += '<div id="row-receiver" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">수취인</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="receiver">' + $(data).find('receiver').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-receiveremail" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">수취인 Email</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="receiveremail">' + $(data).find('receiveremail').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-description" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">요청 내용</div>';
				dialogContents += '<div class="ui-corner-right field-contents"><div id="description" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + description + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decoder" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">복호화 요청인</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="decoder">' + $(data).find('decoder').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decodedipaddress" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">복호화 요청인 IP 주소</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="decodedipaddress">' + $(data).find('decodedipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decodedclientid" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">복호화 요청인 MAC 주소</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="decodedclientid">' + $(data).find('decodedclientid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decodeddatetime" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">복호화 요청일시</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="decodeddatetime">' + $(data).find('decodeddatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-exportfilescount" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">반출 파일 수</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="exportfilescount">' + exportFilesCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 파일</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-decodestatus" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">복호화 상태</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="decodestatus">' + g_htOptionTypeList.get($(data).find('decodestatus').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="ui-state-default ui-corner-left field-title">반출 요청일시</div>';
				dialogContents += '<div class="ui-corner-right field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-filesinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<table class="ui-widget-content scroll-table" style="margin:0; border:none;">';
				dialogContents += '<thead>';
				dialogContents += '<tr>';
				dialogContents += '<th width="10%">순번</th>';
				dialogContents += '<th>파일명</th>';
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

						var patternCategoryName = "";
						var fileName = $(this).find('filename').text();
						var detectKeywordCount = "0";

						dialogContents += '<tr class="' + lineStyle + '">';
						dialogContents += '<td>' + recordCount + '</td>';
						dialogContents += '<td>' + $(this).find('filename').text() + '</td>';
						dialogContents += '</tr>';

						recordCount++;
 					});

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				} else {
					dialogContents += '<tr>';
					dialogContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">반출 파일 정보가 존재하지 않습니다.</div></td>';
					dialogContents += '</tr>';

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				}
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				newDialog.find('#exportinfo').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

				newDialog.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: newDialog.find('#exportinfo').height() - 28
				});

				newDialog.find('#tab-safeexportinfo').tabs({
					heightStyle: "content",
					active: 0,
					activate: function(event, ui) {
						if (ui.newTab.index() == 0) {
							resizeDialogElement(newDialog, newDialog.find('#exportinfo'));
						} else {
							resizeDialogElement(newDialog, newDialog.find('.scroll-table'));
						}
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
					displayAlertDialog("안전반출 정보 조회", "안전반출 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
