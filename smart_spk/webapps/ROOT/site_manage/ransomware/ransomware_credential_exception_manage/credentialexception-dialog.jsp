<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objCredentialExceptionDialog;

	$(document).ready(function() {
		g_objCredentialExceptionDialog = $('#dialog-credentialexception');

		g_objCredentialExceptionDialog.dialog({
			autoOpen: false,
			width: $(document).width()/2,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: true,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"등록": function() {
					if (validateRansomwareCredentialExceptionFileData()) {
						insertRansomwareCredentialExceptionFile();
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
			}
		});
	});

	openNewCredentialExceptionDialog = function() {

		g_objCredentialExceptionDialog.find('input[name="filename"]').val('');

		g_objCredentialExceptionDialog.dialog('option', 'title', '랜섬웨어 신뢰정보 예외');
		g_objCredentialExceptionDialog.dialog({height:'auto'});

		g_objCredentialExceptionDialog.dialog('open');
	};

	insertRansomwareCredentialExceptionFile = function() {

		var postData = getRequestInsertRansomwareCredentialExceptionFileParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objCredentialExceptionDialog.find('input[name="filename"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("랜섬웨어 신뢰정보 예외 파일 등록", "랜섬웨어 신뢰정보 예외 파일 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadFileTreeView();
					displayInfoDialog("랜섬웨어 신뢰정보 예외 파일 등록", "정상적으로 랜섬웨어 신뢰정보 예외 파일이 등록되었습니다.", "");
					g_objCredentialExceptionDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("랜섬웨어 신뢰정보 예외 파일 등록", "랜섬웨어 신뢰정보 예외 파일 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateRansomwareCredentialExceptionFileData = function() {

		var objFileName = g_objCredentialExceptionDialog.find('input[name="filename"]');
		var objValidateTips = g_objCredentialExceptionDialog.find('#validateTips');

		if (objFileName.val().length == 0) {
			updateTips(objValidateTips, "파일 명을 입력해주세요.");
			objFileName.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-credentialexception" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
			</ul>
		</div>
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
			<div id="row-filename" class="field-line">
				<div class="field-title">파일명<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="filename" name="filename" class="text ui-widget-content" /></div>
			</div>
		</div>
	</div>
</div>
