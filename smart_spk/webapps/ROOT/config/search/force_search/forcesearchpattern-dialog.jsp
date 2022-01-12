<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objForceSearchPatternDialog;
	var g_openedForceSearchPatternDialog;
	var g_bReloadForceSearchPattern = false;

	$(document).ready(function() {
		g_objForceSearchPatternDialog = $('#dialog-forcesearchpattern');
	});

	openForceSearchPatternDialog = function() {

		g_objForceSearchPatternDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			width: 800,
			height: 600,
			minHeight: 300,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("전체 패턴 선택")').button({
 					icons: { primary: 'ui-icon-squaresmall-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("전체 패턴 해제")').button({
 					icons: { primary: 'ui-icon-circlesmall-minus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().focus();
				$(this).dialog("option", "position", { my: "center", at: "center" } );
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
				$(this).mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
				$(this).mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
			},
			buttons: {
				"전체 패턴 선택":  function() {
					selectAllPatterns();
				},
				"전체 패턴 해제":  function() {
					deselectAllPatterns();
				},
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				g_objForceSearchDialog.find('#targetpatterncount').text($(this).find('input:checkbox[name=checkboxpattern]').filter(':checked').length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
			},
			resizeStop: function(event, ui) {
				$(this).mCustomScrollbar('update');
			}
		})
		.dialogExtend({
			"closable" : false,
			"maximizable" : true,
			"minimizable" : false,
			"collapsable" : false,
			"dblclick" : "collapse",
			"load" : function(event, dialog){ },
			"beforeCollapse" : function(event, dialog){ },
			"beforeMaximize" : function(event, dialog){ },
			"beforeMinimize" : function(event, dialog){ },
			"beforeRestore" : function(event, dialog){ },
			"collapse" : function(event, dialog){ },
			"maximize" : function(event, dialog){
				$(this).mCustomScrollbar('update');
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				$(this).mCustomScrollbar('update');
			}
		});

		g_objForceSearchPatternDialog.dialog('open');
	};

	loadForceSearchPattern = function() {

		var postData = getRequestForceSearchPatternParam(
				g_objForceSearchDialog.find('#searchid').text(),
				g_objForceSearchDialog.find('input[name="companyid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("검사 패턴 조회", "검사 패턴 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				var beforePatternId = "";
				var recordCount = 1;
				var tableColumnCount = 0;

				$(data).find('record').each(function() {
					var patternId = $(this).find('patternid').text();
					var patternCategoryName = $(this).find('patterncategoryname').text();
					var patternSubId = $(this).find('patternsubid').text();
					var patternName = $(this).find('patternname').text();
					var useFlag = $(this).find('useflag').text();

					if (beforePatternId.length == 0) {
						if (recordCount == 1) {
							htmlContents += '<div class="category-pattern" style="margin-bottom: 5px;">';
							htmlContents += '<div class="category-sub-title"><label class="checkbox"><input type="checkbox" name="checkAll" patternid="' + patternId + '" onFocus="this.blur()">' + patternCategoryName + '</label></div>';
							htmlContents += '<div class="category-sub-contents">';
							htmlContents += '<table class="list-table">';
							htmlContents += '<tbody>';
							htmlContents += '<tr>';
						} else if (tableColumnCount == 0) {
							htmlContents += '</tr>';
							htmlContents += '<tr>';
						}
					} else if (beforePatternId != patternId) {
						if (tableColumnCount != 0) {
							htmlContents += '<td colspan="' + (5 - tableColumnCount) + '">&nbsp;</td>';
						}
						htmlContents += '</tr>';
						htmlContents += '</tbody>';
						htmlContents += '</table>';
						htmlContents += '</div>';
						htmlContents += '</div>';
						htmlContents += '<div class="category-pattern" style="margin-bottom: 5px;">';
						htmlContents += '<div class="category-sub-title"><label class="checkbox"><input type="checkbox" name="checkAll" patternid="' + patternId + '" onFocus="this.blur()">' + patternCategoryName + '</label></div>';
						htmlContents += '<div class="category-sub-contents">';
						htmlContents += '<table class="list-table">';
						htmlContents += '<tbody>';
						htmlContents += '<tr>';

						tableColumnCount = 0;
					} else {
						if (tableColumnCount == 0) {
							htmlContents += '</tr>';
							htmlContents += '<tr>';
						}
					}

					if (useFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
						htmlContents += '<td width="20%" style="text-align: left;"><label class="checkbox"><input type="checkbox" name="checkboxpattern" patternid="' + patternId + '" patternsubid="' + patternSubId + '" onFocus="this.blur()" checked>' + patternName + '</label></td>';
					} else {
						htmlContents += '<td width="20%" style="text-align: left;"><label class="checkbox"><input type="checkbox" name="checkboxpattern" patternid="' + patternId + '" patternsubid="' + patternSubId + '" onFocus="this.blur()">' + patternName + '</label></td>';
					}

					beforePatternId = patternId;
					recordCount++;
					tableColumnCount = (tableColumnCount + 1) % 5;
				});

				if (tableColumnCount != 0) {
					htmlContents += '<td colspan="' + (5 - tableColumnCount) + '">&nbsp;</td>';
				}
				htmlContents += '</tr>';
				htmlContents += '</tbody>';
				htmlContents += '</table>';
				htmlContents += '</div>';
				htmlContents += '</div>';

				g_objForceSearchPatternDialog.find('#pattern-list').html(htmlContents);

				var inlineScriptText = "";
				inlineScriptText += "g_objForceSearchPatternDialog.find('.category-sub-title input:checkbox').click( function () { var checkState = $(this).is(':checked'); $(this).closest('.category-pattern').find('.list-table input:checkbox').each( function () { $(this).prop('checked', checkState); }); });";
				inlineScriptText += "g_objForceSearchPatternDialog.find('.category-sub-contents input:checkbox').click( function () { if ($(this).is(':checked')) { if ($(this).closest('table').find('input:checkbox').length == $(this).closest('table').find('input:checkbox').filter(':checked').length) { $(this).closest('.category-pattern').find('.category-sub-title input:checkbox').prop('checked', true); } } else { $(this).closest('.category-pattern').find('.category-sub-title input:checkbox').prop('checked', false); } });";
				
// 				inlineScriptText += "g_objForceSearchPatternDialog.find('input:checkbox[name=checkAll]').click( function () { if ($(this).is(':checked') == true) { var checkboxPatternId = $(this).attr('patternid'); $('input:checkbox[name=checkboxpattern]').each( function () { if ($(this).attr('patternid') == checkboxPatternId) { $(this).prop('checked', true); } }); } else { var checkboxPatternId = $(this).attr('patternid'); $('input:checkbox[name=checkboxpattern]').each( function () { if ($(this).attr('patternid') == checkboxPatternId) { $(this).prop('checked', false); } }); } });";
// 				inlineScriptText += "g_objForceSearchPatternDialog.find('input:checkbox[name=checkboxpattern]').click( function() { $(this).find('input:checkbox[name=checkboxpattern]').prop('checked', !$(this).find('input:checkbox[name=checkboxpattern]').is(':checked')); if ($(this).closest('table').find('input:checkbox[name=checkboxpattern]').length == $(this).closest('table').find('input:checkbox[name=checkboxpattern]').filter(':checked').length) { $(this).closest('.category-pattern').find('input:checkbox[name=checkAll]').prop('checked', true); } else { $(this).closest('.category-pattern').find('input:checkbox[name=checkAll]').prop('checked', false); } });";

				var inlineScript   = document.createElement("script");
				inlineScript.type  = "text/javascript";
				inlineScript.text  = inlineScriptText;

				g_objForceSearchPatternDialog.find('#pattern-list').append(inlineScript);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("검사 패턴 조회", "검사 패턴 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	selectAllPatterns = function() {
		g_objForceSearchPatternDialog.find('#pattern-list input:checkbox').each( function () {
			$(this).prop('checked', true);
		});
	};

	deselectAllPatterns = function() {
		g_objForceSearchPatternDialog.find('#pattern-list input:checkbox').each( function () {
			$(this).prop('checked', false);
		});
	};
//-->
</script>

<div id="dialog-forcesearchpattern" title="검사 패턴 설정" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>강제검사 대상 패턴을 선택해 주세요.</li>
			</ul>
		</div>
		<div id="pattern-list"style="margin-top: 20px;"></div>
	</div>
</div>
