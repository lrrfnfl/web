<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	#tab-searchloginfo > .ui-widget-header { 
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

	openSearchLogInfoDialog = function(seqNo) {

		var postData = getRequestSearchLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("검사 정보 조회", "검사 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
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
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement($(this), $(this).find('#searchinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
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
							resizeDialogElement($(this), $(this).find('#searchinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement($(this), $(this).find('#searchinfo'));
						} else {
							resizeDialogElement($(this), $(this).find('.scroll-table'));
						}
					}
				};

				var detectFileCount = $(data).find('detectfilecount').text();
				var detectPatternCount = $(data).find('detectpatterncount').text();
				var totalDetectKeywordCount = $(data).find('totaldetectkeywordcount').text();
				if (detectFileCount.length == 0)
					detectFileCount = 0;
				if (detectPatternCount.length == 0)
					detectPatternCount = 0;
				if (totalDetectKeywordCount.length == 0)
					totalDetectKeywordCount = 0;

				var dialogContents = "";
				dialogContents = '<div title="검사 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="tab-searchloginfo" class="styles-tab border-none">';
				dialogContents += '<ul>';
				dialogContents += '<li><a href="#tab-searchinfo">검사 정보</a></li>';
				dialogContents += '<li><a href="#tab-detectinfo">검출 상세 정보</a></li>';
				dialogContents += '</ul>';
				dialogContents += '<div id="tab-searchinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<div id="searchinfo">';
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
				dialogContents += '<div id="row-searchid" class="field-line">';
				dialogContents += '<div class="field-title">검사 ID</div>';
				dialogContents += '<div class="field-value"><span id="searchid">' + $(data).find('searchid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-searchtype" class="field-line">';
				dialogContents += '<div class="field-title">검사 유형</div>';
				dialogContents += '<div class="field-value"><span id="searchtype">' + g_htSearchTypeList.get($(data).find('searchtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-startdatetime" class="field-line">';
				dialogContents += '<div class="field-title">검사 시작일시</div>';
				dialogContents += '<div class="field-value"><span id="startdatetime">' + $(data).find('startdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-enddatetime" class="field-line">';
				dialogContents += '<div class="field-title">검사 종료일시</div>';
				dialogContents += '<div class="field-value"><span id="enddatetime">' + $(data).find('enddatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-detectfilecount" class="field-line">';
				dialogContents += '<div class="field-title">검출 파일 수</div>';
				dialogContents += '<div class="field-value"><span id="detectfilecount">' + detectFileCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 파일</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-detectpatterncount" class="field-line">';
				dialogContents += '<div class="field-title">검출 패턴 유형</div>';
				dialogContents += '<div class="field-value"><span id="detectpatterncount">' + detectPatternCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 패턴</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-totaldetectkeywordcount" class="field-line">';
				dialogContents += '<div class="field-title">검출 패턴 수</div>';
				dialogContents += '<div class="field-value"><span id="totaldetectkeywordcount">' + totalDetectKeywordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span> 건</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-ipaddress" class="field-line">';
				dialogContents += '<div class="field-title">클라이언트 주소</div>';
				dialogContents += '<div class="field-value"><span id="ipaddress">' + $(data).find('ipaddress').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="field-title">등록 일시</div>';
				dialogContents += '<div class="field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '<div id="tab-detectinfo" style="padding: 8px 2px 0 2px;">';
				dialogContents += '<table class="scroll-table" style="margin: 0; border: none;">';
				dialogContents += '<thead>';
				dialogContents += '<tr>';
				dialogContents += '<th width="40%">패턴 대분류 명</th>';
				dialogContents += '<th width="40%">패턴 소분류 명</th>';
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

						var patternCategoryName = $(this).find('patterncategoryname').text();
						var patternName = $(this).find('patternname').text();
						var detectKeywordCount = $(this).find('detectkeywordcount').text();

						dialogContents += '<tr class="' + lineStyle + '">';
						dialogContents += '<td>' + patternCategoryName + '</td>';
						dialogContents += '<td>' + patternName + '</td>';
						dialogContents += '<td style="text-align: right;">' + detectKeywordCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 건</td>';
						dialogContents += '</tr>';

						recordCount++;
			  		});

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				} else {
					dialogContents += '<tr>';
					dialogContents += '<td colspan="3" align="center"><div style="padding: 10px 0; text-align: center;">검출된 패턴 내용이 존재하지 않습니다.</div></td>';
					dialogContents += '</tr>';

					dialogContents += '</tbody>';
					dialogContents += '</table>';
				}
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				newDialog.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: newDialog.find('#searchinfo').height() - 26
				});

				newDialog.find('#tab-searchloginfo').tabs({
					heightStyle: "content",
					active: 0,
					activate: function(event, ui) {
						g_selectedDialogTabIndex = ui.newTab.index();
						if (g_selectedDialogTabIndex == 0) {
							resizeDialogElement(newDialog, newDialog.find('#searchinfo'));
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
					displayAlertDialog("검사 정보 조회", "검사 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>
