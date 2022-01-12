<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<script type="text/javascript">
<!--
	var g_objForceSearchStatusDialog;

	var g_searchForceSearchStatusListOrderByName = "";
	var g_searchForceSearchStatusListOrderByDirection = "";

	var g_objForceSearchStatusScrollTableHeight = 200;

	$(document).ready(function() {
		g_objForceSearchStatusDialog = $('#dialog-forcesearchstatus');

		$('input:button, input:submit, button').button();
		$('#btnSearchStatus').button({ icons: {primary: "ui-icon-search"} });

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearchStatus') {
				loadForceSearchStatusList();
			}
		});
	});

	openForceSearchStatusDialog = function() {

		loadForceSearchStatusList();

		g_objForceSearchStatusDialog.dialog({
			autoOpen: false,
			maxWidth: $(document).width(),
			width: $(document).width()/2,
			height: 'auto',
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().focus();
				$(this).dialog("option", "position", { my: "center", at: "center" } );
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				g_searchForceSearchStatusListOrderByName = "";
				g_searchForceSearchStatusListOrderByDirection = "";

				$(this).find('input:text').each(function() {
					$(this).val('');
					if ( $(this).hasClass('ui-state-error') )
						$(this).removeClass('ui-state-error');
				});
				$(this).find('select').each(function() {
					$(this).val('');
				});
			},
			resizeStop: function(event, ui) {
				resizeDialogElement($(this), $(this).find('.scroll-table'));
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
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				resizeDialogElement($(this), $(this).find('.scroll-table'));
			}
		});

		g_objForceSearchStatusDialog.dialog('open');
	};

	loadForceSearchStatusList = function() {

		var objTargetUserCount = g_objForceSearchStatusDialog.find('#targetusercount');
		var objCompleteUserCount = g_objForceSearchStatusDialog.find('#completeusercount');
		var objCompletePercentage = g_objForceSearchStatusDialog.find('#completepercentage');

		var objSearchCondition = g_objForceSearchStatusDialog.find('#search-condition');
		var objSearchResult = g_objForceSearchStatusDialog.find('#search-result');

		var objSearchDept = objSearchCondition.find('select[name="searchdept"]');
		var objSearchCompleteState = objSearchCondition.find('select[name="searchcompletestate"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');

		var postData = getRequestForceSearchStatusListParam(g_objForceSearchDialog.find('#searchid').text(),
			g_objForceSearchDialog.find('input[name="companyid"]').val(),
			objSearchDept.val(),
			objSearchCompleteState.val(),
			g_searchForceSearchStatusListOrderByName,
			g_searchForceSearchStatusListOrderByDirection,
			"",
			"");

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 진행 상황 조회", "강제검사 진행 상황 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var targetUserCount = $(data).find('targetusercount').text();
				var completeUserCount = $(data).find('completeusercount').text();

				objTargetUserCount.text(targetUserCount);
				objCompleteUserCount.text(completeUserCount);
				objCompletePercentage.text((parseFloat(completeUserCount)/parseFloat(targetUserCount)*100).toFixed(2) + ' %');

				var dialogContents = '';

				dialogContents += '<table class="ui-widget-content scroll-table" style="border: 0;">';
				dialogContents += '<thead>';
				dialogContents += '<tr>';
				dialogContents += '<th width="20%" id="DEPTNAME">부서 명</th>';
				dialogContents += '<th width="15%" id="USERID">사용자 ID</th>';
				dialogContents += '<th width="15%" id="USERNAME">사용자 명</th>';
				dialogContents += '<th width="10%" id="COMPLETEFLAG">검사 상태</th>';
				dialogContents += '<th width="20%" id="STARTDATETIME">검사 시작 일시</th>';
				dialogContents += '<th width="20%" id="ENDDATETIME">검사 종료 일시</th>';
				dialogContents += '</tr>';
				dialogContents += '</thead>';
				dialogContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var deptName = $(this).find('deptname').text();
						var userId = $(this).find('userid').text();
						var userName = $(this).find('username').text();
						var completeFlag = $(this).find('completeflag').text();
						var startDatetime = $(this).find('startdatetime').text();
						var endDatetime = $(this).find('enddatetime').text();

						dialogContents += '<tr class="' + lineStyle + '">';
						dialogContents += '<td>' + deptName + '</td>';
						dialogContents += '<td>' + userId + '</td>';
						dialogContents += '<td>' + userName + '</td>';
						dialogContents += '<td style="text-align: center;">' + g_htCompleteStateList.get(completeFlag) + '</td>';
						dialogContents += '<td style="text-align: center;"><span style="white-space: normal">' + startDatetime + '</td>';
						dialogContents += '<td style="text-align: center;"><span style="white-space: normal">' + endDatetime + '</td>';
						dialogContents += '</tr>';

						recordCount++;
					});

					dialogContents += '</tbody>';
					dialogContents += '</table>';

					objResultList.html(dialogContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objForceSearchStatusDialog.find('.scroll-table th').hover(function() { $(this).addClass('ui-state-hover'); $(this).css('border', 'none'); $(this).css({'cursor': 'pointer'}); }, function() { $(this).removeClass('ui-state-hover'); $(this).css({'cursor': 'default'}); });";
					inlineScriptText += "g_objForceSearchStatusDialog.find('.scroll-table th').click(function() { if( $(this).attr('id') != null ) { g_searchForceSearchStatusListOrderByName = $(this).attr('id'); if( g_searchForceSearchStatusListOrderByDirection == 'ASC') { g_searchForceSearchStatusListOrderByDirection = 'DESC'; } else { g_searchForceSearchStatusListOrderByDirection = 'ASC'; }; g_objForceSearchStatusScrollTableHeight=g_objForceSearchStatusDialog.find('.scroll-table').find('.st-body').height(); loadForceSearchStatusList(); } });";
					inlineScriptText += "g_objForceSearchStatusDialog.find('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objForceSearchStatusDialog.find('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objResultList.append(inlineScript);
				} else {
					dialogContents += '<tr>';
					dialogContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 강제검사 대상 사용자가 존재하지 않습니다.</div></td>';
					dialogContents += '</tr>';

					dialogContents += '</tbody>';
					dialogContents += '</table>';

					objResultList.html(dialogContents);
				}

				g_objForceSearchStatusDialog.find('.scroll-table').scrolltable({
					stripe: true,
					oddClass: 'odd',
					height: g_objForceSearchStatusScrollTableHeight
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 진행 상황 조회", "강제검사 진행 상황 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-forcesearchstatus" title="검사 진행 상황" class="dialog-form">
	<div class="dialog-contents">
		<div class="category-sub-title">검사 진행 요약</div>
		<div class="category-sub-contents">
			<div class="field-line">
				<div class="field-title">검사 대상 사용자</div>
				<div class="field-value"><span id="targetusercount"></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">검사 완료 사용자</div>
				<div class="field-value"><span id="completeusercount"></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">검사 진행율</div>
				<div class="field-value"><span id="completepercentage"></span></div>
			</div>
		</div>
		<div id="search-condition" class="inline-search-condition" style="margin-top: 20px;">
			<form name="frm-search" method="post">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>부서
				<select id="searchdept" name="searchdept" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>검사 상태
				<select id="searchcompletestate" name="searchcompletestate" class="ui-widget-content"></select>
				<span class="search-button">
					<button type="button" id="btnSearchStatus" name="btnSearchStatus" class="small-button">조 회</button>
				</span>
			</form>
		</div>
		<div id="search-result" class="search-result">
			<div id="result-list"></div>
		</div>
	</div>
</div>
