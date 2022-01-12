<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objDetectFileExtendExpirationDialog;

	$(document).ready(function() {
		g_objDetectFileExtendExpirationDialog = $('#dialog-detectfileextendexpiration');
	});

	openDetectFileExtendExpirationDialog = function(objDetectFileInfoDialog) {

		g_objDetectFileExtendExpirationDialog.dialog({
			autoOpen: false,
			width: 600,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("수정")').button({
 					icons: { primary: 'ui-icon-wrench' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();

				$(this).find('input[name="extenddate"]').val(objDetectFileInfoDialog.find('#fileexpirationdate').text());
				$(this).find('input[name="extenddate"]').datepicker({
					minDate: 0,
					showAnim: "slideDown",
					onClose: function() {
						g_objDetectFileExtendExpirationDialog.find('textarea[name="reason"]').focus(); 
					}
				});
			},
			buttons: {
				"수정": function() {
					if (validateDetectFileExtendExpirationData()) {
						displayConfirmDialog("파일 보관 만료일 변경", "파일의 보관 만료일을 변경하시겠습니까?", "", function() { updateDetectFileExtendExpiration(objDetectFileInfoDialog); });
					}
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:text').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
				$(this).find('textarea').each(function() {
					$(this).val('');
				});
			}
		});

		g_objDetectFileExtendExpirationDialog.dialog('open');
	};

	updateDetectFileExtendExpiration = function(objDetectFileInfoDialog) {

		var postData = getRequestDetectFileExtendExpirationParam(
				objDetectFileInfoDialog.find('input[name="companyid"]').val(),
				objDetectFileInfoDialog.find('#userid').text(),
				objDetectFileInfoDialog.find('#lastsearchid').text(),
				objDetectFileInfoDialog.find('input[name="lastsearchseqno"]').val(),
				'<%=RequesterType.REQUESTER_TYPE_ADMIN%>',
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objDetectFileExtendExpirationDialog.find('textarea[name="reason"]').val(),
				g_objDetectFileExtendExpirationDialog.find('input[name="extenddate"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("파일 보관 만료일 변경", "파일 보관 만료일 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("파일 보관 만료일 변경", "정상 처리되었습니다.", "정상적으로 파일 보관 만료일이 변경되었습니다.");
					g_objDetectFileExtendExpirationDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("파일 보관 만료일 변경", "파일 보관 만료일 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateDetectFileExtendExpirationData = function() {

		var objExtendDate = g_objDetectFileExtendExpirationDialog.find('input[name="extenddate"]');
		var objReason = g_objDetectFileExtendExpirationDialog.find('textarea[name="reason"]');
		var objValidateTips = g_objDetectFileExtendExpirationDialog.find('#validateTips');

		if (objExtendDate.val().length == 0) {
			updateTips(objValidateTips, "파일 보관 만료 일자를 입력해 주세요.");
			objExtendDate.focus();
			return false;
		}

		if (objReason.val().length == 0) {
			updateTips(objValidateTips, "파일 보관 만료 변경 사유를 입력해 주세요.");
			objReason.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-detectfileextendexpiration" title="파일 보관 만료일 변경" class="dialog-form">
		<div id="validateTips" class="validateTips">
			<div class="icon-message-holder">
				<div class="icon-holder"><span id="alert-icon" class="ui-icon ui-icon-alert"></span></div>
				<div class="message-holder">
					<div class="icon-message"><strong>입력오류:</strong>&nbsp;<span id="validateMsg"></span></div>
				</div>
			</div>
			<div class="clear"></div>
		</div>
	<div class="form-contents">
		<div id="row-extenddate" class="field-line">
			<div class="field-title">보관 만료 일자</div>
			<div class="field-value"><input type="text" id="extenddate" name="extenddate" class="text ui-widget-content input-date" readonly="readonly" /></div>
		</div>
		<div id="row-reason" class="field-line">
			<div class="field-title">연장 사유</div>
			<div class="field-contents"><textarea id="reason" name="reason" class="text ui-widget-content" style="height: 200px;"></textarea></div>
		</div>
	</div>
</div>
