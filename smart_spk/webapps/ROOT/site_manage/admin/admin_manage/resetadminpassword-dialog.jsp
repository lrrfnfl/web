<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objResetAdminPasswordDialog;

	$(document).ready(function() {
		g_objResetAdminPasswordDialog = $('#dialog-resetadminpassword');
	});

	openResetAdminPasswordDialog = function() {

		g_objResetAdminPasswordDialog.find('#adminid').text(g_objAdminInfo.find('input[name="adminid"]').val());
		g_objResetAdminPasswordDialog.find('#adminname').text(g_objAdminInfo.find('input[name="adminname"]').val());

		g_objResetAdminPasswordDialog.dialog({
			autoOpen: false,
			width: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("비밀번호 초기화")').button({
 					icons: { primary: 'ui-icon-key' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"비밀번호 초기화": function() {
					if (validateResetAdminPasswordData()) {
						displayConfirmDialog("관리자 비밀번호 초기화", "관리자 비밀번호를 초기화하시겠습니까?", "", function() { resetPassword(); });
					}
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:password').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
			}
		});

		g_objResetAdminPasswordDialog.dialog('open');
	};

	resetPassword = function() {

		var postData = getRequestResetAdminPasswordParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objResetAdminPasswordDialog.find('#adminid').text(),
				g_objResetAdminPasswordDialog.find('input[name="pwd"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 비밀번호 초기화", "관리자 비밀번호 초기화 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("관리자 비밀번호 초기화", "정상 처리되었습니다.", "정상적으로 관리자 비밀번호가 초기화되었습니다.");
					g_objResetAdminPasswordDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 비밀번호 초기화", "관리자 비밀번호 초기화 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateResetAdminPasswordData = function() {

		var objPwd = g_objResetAdminPasswordDialog.find('input[name="pwd"]');
		var objConfirmPwd = g_objResetAdminPasswordDialog.find('input[name="confirmpwd"]');
		var objValidateTips = g_objResetAdminPasswordDialog.find('#validateTips');

		if (!isValidParam(objPwd, PARAM_TYPE_PWD, "비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objPwd.val() != objConfirmPwd.val()) {
			updateTips(objValidateTips, "입력한 두 비밀번호가 일치하지 않습니다.");
			objPwd.addClass('ui-state-error');
			objPwd.val('');
			objConfirmPwd.addClass('ui-state-error');
			objConfirmPwd.val('');
			objPwd.focus();
			return false;
		} else {
			if (objPwd.hasClass('ui-state-error'))
				objPwd.removeClass('ui-state-error');
			if (objConfirmPwd.hasClass('ui-state-error'))
				objConfirmPwd.removeClass('ui-state-error');
		}

		return true;
	};
</script>

<div id="dialog-resetadminpassword" title="비밀번호 초기화" class="dialog-form">
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
			<div id="row-adminid" class="field-line">
				<div class="field-title-140">관리자 ID</div>
				<div class="field-value-140"><span id="adminid"></span></div>
			</div>
			<div id="row-adminname" class="field-line">
				<div class="field-title-140">관리자 명</div>
				<div class="field-value-140"><span id="adminname"></span></div>
			</div>
			<div id="row-pwd" class="field-line">
				<div class="field-title-140">초기화할 비밀번호<span class="required_field">*</span></div>
				<div class="field-value-140"><input type="password" id="pwd" name="pwd" value="" class="text ui-widget-content" /></div>
			</div>
			<div id="row-confirmpwd" class="field-line">
				<div class="field-title-140">비밀번호 확인<span class="required_field">*</span></div>
				<div class="field-value-140"><input type="password" id="confirmpwd" name="confirmpwd" value="" class="text ui-widget-content" /></div>
			</div>
		</div>
	</div>
</div>
	