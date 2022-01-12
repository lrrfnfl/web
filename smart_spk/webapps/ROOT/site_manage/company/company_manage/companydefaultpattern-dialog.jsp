<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_objCompanyDefaultPatternDialog;

	$(document).ready(function() {
		g_objCompanyDefaultPatternDialog = $('#dialog-companydefaultpattern');
	});

	openCompanyDefaultPatternDialog = function() {

		g_objCompanyDefaultPatternDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			width: $(document).width()/2,
			height: 'auto',
			minHeight: 300,
			maxHeight: $(document).height(),
			modal: true,
			open: function(event, ui) {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("전체 패턴 선택")').button({
 					icons: { primary: 'ui-icon-squaresmall-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("전체 패턴 해제")').button({
 					icons: { primary: 'ui-icon-circlesmall-minus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();

				$(this).find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: 244
				});
				$(this).dialog("option", "position", { my: "center", at: "center" } );
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
				g_objCompanyInfo.find('#targetpatterncount').text($(this).find('input:checkbox[name=selectpattern]').filter(':checked').length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 패턴");
			},
			resizeStop: function(event, ui) {
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			}
		})
		.dialogExtend({
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
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			}
		});

		g_objCompanyDefaultPatternDialog.dialog('open');
	};

	fillCompanyDefaultPatternList = function(arrList) {

		var objPatternList = g_objCompanyDefaultPatternDialog.find('#pattern-list');

		var htmlContents = '';

		htmlContents += '<table class="scroll-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr style="border:none">';
		htmlContents += '<th>선택</th>';
		htmlContents += '<th width="45%">패턴 대분류 명</th>';
		htmlContents += '<th width="45%">패턴 소분류 명</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		$.each(arrList, function(rowIdx, arrPattern) {
			var lineStyle = '';
			if (rowIdx%2 == 0)
				lineStyle = "list_odd";
			else
				lineStyle = "list_even";

			htmlContents += '<tr class="' + lineStyle + '">';
			htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectpattern" patternid="' + arrPattern[0] + '"  patternsubid="' + arrPattern[2] + '" style="border: 0;"></td>';
			htmlContents += '<td>' + arrPattern[1] + '</td>';
			htmlContents += '<td>' + arrPattern[3] + '</td>';
			htmlContents += '</tr>';
		});

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		objPatternList.html(htmlContents);

		var inlineScriptText = "";
		inlineScriptText += "g_objCompanyDefaultPatternDialog.find('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
		inlineScriptText += "g_objCompanyDefaultPatternDialog.find('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
		inlineScriptText += "g_objCompanyDefaultPatternDialog.find('.scroll-table tbody tr td:first-child').click( function (e) { e.stopPropagation(); });";

		var inlineScript   = document.createElement("script");
		inlineScript.type  = "text/javascript";
		inlineScript.text  = inlineScriptText;

		objPatternList.append(inlineScript);
	};

	selectAllPatterns = function() {
		g_objCompanyDefaultPatternDialog.find('.scroll-table tbody tr').each( function () {
			$(this).find('input:checkbox[name=selectpattern]').prop('checked', true);
		});
	};

	deselectAllPatterns = function() {
		g_objCompanyDefaultPatternDialog.find('.scroll-table tbody tr').each( function () {
			$(this).find('input:checkbox[name=selectpattern]').prop('checked', false);
		});
	};
//-->
</script>

<div id="dialog-companydefaultpattern" title="사업장 사용 패턴 설정" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>검사에 사용할 사업장의 기본 패턴을 선택해 주세요.</li>
			</ul>
		</div>
		<div id="pattern-list"></div>
	</div>
</div>
	