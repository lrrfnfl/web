<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	#tab-detectfileinfo > .ui-widget-header { 
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
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;
	var g_selectedDialogTabIndex = 0;

	openDetectFileInfoDialog = function(seqNo) {

		var postData = getRequestDetectFileInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("검출 파일 정보 조회", "검출 파일 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
/*
						$(this).parent().find('.ui-dialog-buttonpane button:contains("수정")').button({
		 					icons: { primary: 'ui-icon-wrench' }
						});
						$(this).parent().find('.ui-dialog-buttonpane button:contains("보관 만료일 연장")').button({
		 					icons: { primary: 'ui-icon-clock' }
						});
						$(this).parent().find('.ui-dialog-buttonpane button:contains("보관 만료일 연장 내역")').button({
		 					icons: { primary: 'ui-icon-note' }
						});
*/
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
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement($(this), $(this).find('#fileinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
					},
					"dragStop" : function(event, ui) {
						g_lastDialogPosition = ui.position;
					},
					"buttons" : {
/*
						"수정": function() {
							if (validateDetectFileData($(this))) {
								updateDetectFile($(this));
								//displayConfirmDialog("검출 파일 정보 수정", "검출 파일 정보를 수정하시겠습니까?", "", function() { updateDetectFile($(this)); });
							}
						},
						"보관 만료일 연장": function() {
							openDetectFileExtendExpirationDialog($(this));
						},
						"보관 만료일 연장 내역": function() {
							openDetectFileExpirationExtendHistoryDialog($(this));
						},
*/
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
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement($(this), $(this).find('#fileinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement($(this), $(this).find('#fileinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
					}
				};

				var comment = $(data).find('comment').text();
				comment = comment.replace(/\n/g, "<br />");
				comment = comment.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogContents = "";
				dialogContents = '<div title="검출 파일 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="tab-detectfileinfo" class="styles-tab border-none">';
				dialogContents += '<ul>';
				dialogContents += '<li><a href="#tab-fileinfo">검출 파일 정보</a></li>';
				dialogContents += '<li><a href="#tab-detectinfo">검출 상세 정보</a></li>';
				dialogContents += '</ul>';
				dialogContents += '<div id="tab-fileinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<div id="validateTips" class="validateTips">';
				dialogContents += '<div class="icon-message-holder">';
				dialogContents += '<div class="icon-holder"><span id="alert-icon" class="ui-icon ui-icon-alert"></span></div>';
				dialogContents += '<div class="message-holder">';
				dialogContents += '<div class="icon-message"><strong>입력오류:</strong>&nbsp;<span id="validateMsg"></span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="fileinfo">';
				dialogContents += '<input type="hidden" id="companyid" value="' + $(data).find('companyid').text() + '" name="companyid" />';
				dialogContents += '<input type="hidden" id="deptcode" value="' + $(data).find('deptcode').text() + '" name="deptcode" />';
				dialogContents += '<input type="hidden" id="lastsearchseqno" value="' + $(data).find('lastsearchseqno').text() + '" name="lastsearchseqno" />';
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
				dialogContents += '<div id="row-lastsearchid" class="field-line">';
				dialogContents += '<div class="field-title">최종 검사 ID</div>';
				dialogContents += '<div class="field-value"><span id="lastsearchid">' + $(data).find('lastsearchid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastsearchtype" class="field-line">';
				dialogContents += '<div class="field-title">최종 검사 유형</div>';
				dialogContents += '<div class="field-value"><span id="lastsearchtype">' + g_htSearchTypeList.get($(data).find('lastsearchtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastsearchdate" class="field-line">';
				dialogContents += '<div class="field-title">최종 검사 일자</div>';
				dialogContents += '<div class="field-value"><span id="lastsearchdate">' + $(data).find('lastsearchdate').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-searchpath" class="field-line">';
				dialogContents += '<div class="field-title">검출 파일</div>';
				dialogContents += '<div class="field-contents"><span id="searchpath">' + $(data).find('searchpath').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filetype" class="field-line">';
				dialogContents += '<div class="field-title">파일 유형</div>';
				dialogContents += '<div class="field-value"><span id="filetype">' + g_htFileTypeList.get($(data).find('filetype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filecategory" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">파일 분류</div>';
				dialogContents += '<div class="field-value"><select id="filecategory" name="filecategory" class="ui-widget-content"></select></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-comment" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">사용자 코멘트</div>';
				dialogContents += '<div class="field-contents"><div id="comment" style="width: 98%; height: 80px; overflow: auto; white-space: normal;">' + comment + '</div></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastresult" class="field-line">';
				dialogContents += '<div class="field-title">최종 처리 상태</div>';
				dialogContents += '<div class="field-value"><span id="lastresult">' + g_htResultStateList.get($(data).find('lastresult').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-filecreationdate" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">파일 생성 일자</div>';
				dialogContents += '<div class="field-value"><input type="text" id="filecreationdate" name="filecreationdate" value="' + $(data).find('filecreationdate').text() + '" class="text ui-widget-content" style="width: 80px;" readonly="readonly" /></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-fileexpirationdate" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">보관 만료 일자</div>';
				dialogContents += '<div class="field-value"><span id="fileexpirationdate">' + $(data).find('fileexpirationdate').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastmodifiername" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">최종 변경자</div>';
				dialogContents += '<div class="field-value"><span id="lastmodifiername">' + $(data).find('lastmodifiername').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastmodifieddatetime" class="field-line" style="display: none;">';
				dialogContents += '<div class="field-title">최종 변경 일시</div>';
				dialogContents += '<div class="field-value"><span id="lastmodifieddatetime">' + $(data).find('lastmodifieddatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-detectinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<table class="scroll-table" style="margin: 0; border: none;">';
				dialogContents += '<thead>';
				dialogContents += '<tr>';
				dialogContents += '<th width="50%">패턴명</th>';
				dialogContents += '<th>검출 패턴 수</th>';
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

						var patternId = $(this).find('patternid').text();
						var detectKeywordCount = $(this).find('detectkeywordcount').text();

						dialogContents += '<tr class="' + lineStyle + '">';
						dialogContents += '<td>' + g_htPatternList.get(patternId) + '</td>';
						dialogContents += '<td style="text-align: right;">' + detectKeywordCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
						dialogContents += '</tr>';

						recordCount++;
					});

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				} else {
					dialogContents += '<tr>';
					dialogContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">검출된 패턴 내용이 존재하지 않습니다.</div></td>';
					dialogContents += '</tr>';

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				}
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				fillDropdownList(newDialog.find('select[name="filecategory"]'), g_htFileCategoryList, $(data).find('filecategory').text(), null);

				newDialog.find('input[name="filecreationdate"]').datepicker({
					maxDate: 0,
					showAnim: "slideDown"
				});

				newDialog.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: newDialog.find('#fileinfo').height() - 26
				});

				newDialog.find('#tab-detectfileinfo').tabs({
					heightStyle: "content",
					active: 0,
					activate: function(event, ui) {
						g_selectedDialogTabIndex = ui.newTab.index();
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement(newDialog, newDialog.find('#fileinfo'));
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
					displayAlertDialog("검출 파일 정보 조회", "검출 파일 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateDetectFile = function(objDialog) {

		var postData = getRequestUpdateDetectFileParam('<%=(String)session.getAttribute("ADMINID")%>',
				objDialog.find('input[name="companyid"]').val(),
				objDialog.find('input[name="deptcode"]').val(),
				objDialog.find('#userid').text(),
				objDialog.find('#lastsearchid').text(),
				objDialog.find('input[name="lastsearchseqno"]').val(),
				objDialog.find('select[name="filecategory"]').val(),
				objDialog.find('input[name="filecreationdate"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("검출 파일 정보 변경", "검출 파일 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("검출 파일 정보 변경", "정상 처리되었습니다.", "정상적으로 검출 파일 정보가 변경되었습니다.");
					loadDetectFileList();
					g_objDetectFileInfoDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("검출 파일 정보 변경", "검출 파일 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateDetectFileData = function(objDialog) {

		var objFileCreationDate = objDialog.find('input[name="filecreationdate"]');
		var objValidateTips = objDialog.find('#validateTips');

		if (objFileCreationDate.val().length == 0) {
			updateTips(objValidateTips, "파일 생성 일자를 입력해 주세요.");
			objFileCreationDate.focus();
			return false;
		}

		return true;
	};
//-->
</script>
