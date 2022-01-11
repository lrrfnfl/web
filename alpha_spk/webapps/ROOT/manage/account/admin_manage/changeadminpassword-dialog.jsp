<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_objChangeAdminPasswordDialog;

	$(document).ready(function() {
		g_objChangeAdminPasswordDialog = $('#dialog-changeadminpassword');
	});

	openChangeAdminPasswordDialog = function() {

		g_objChangeAdminPasswordDialog.find('#adminid').text(g_objAdminInfo.find('#adminid').text());
		g_objChangeAdminPasswordDialog.find('#adminname').text(g_objAdminInfo.find('input[name="adminname"]').val());

		g_objChangeAdminPasswordDialog.dialog({
			autoOpen: false,
			width: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("비밀번호 변경")').button({
 					icons: { primary: 'ui-icon-key' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"비밀번호 변경": function() {
					if (validateChangeAdminPasswordData()) {
						displayConfirmDialog("계정 비밀번호 변경", "계정 비밀번호를 변경하시겠습니까?", "", function() { changePassword(); });
					}
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').text('');
				$(this).find('input:password').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
			}
		});

  		g_objChangeAdminPasswordDialog.dialog('open');
	};

	changePassword = function() {

		var postData = getRequestChangeAdminPasswordParam('<%=(String)session.getAttribute("ADMINID")%>',
			'<%=(String)session.getAttribute("ADMINID")%>',
			g_objChangeAdminPasswordDialog.find('input[name="oldpwd"]').val(),
			g_objChangeAdminPasswordDialog.find('input[name="pwd"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("계정 비밀번호 변경", "계정 비밀번호 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("계정 비밀번호 변경", "정상 처리되었습니다.", "정상적으로 계정 비밀번호가 변경되었습니다.");
					location.reload();
					g_objChangeAdminPasswordDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("계정 비밀번호 변경", "계정 비밀번호 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateChangeAdminPasswordData = function() {

		var objOldPwd = g_objChangeAdminPasswordDialog.find('input[name="oldpwd"]');
		var objPwd = g_objChangeAdminPasswordDialog.find('input[name="pwd"]');
		var objConfirmPwd = g_objChangeAdminPasswordDialog.find('input[name="confirmpwd"]');
		var objValidateTips = g_objChangeAdminPasswordDialog.find('#validateTips');

		if (!isValidParam(objOldPwd, PARAM_TYPE_PWD, "기존 비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (!isValidParam(objPwd, PARAM_TYPE_PWD, "변경할 비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objPwd.val() != objConfirmPwd.val()) {
			updateTips(objValidateTips, "입력한 두 비밀번호가 일치하지 않습니다.");
			objPwd.val('');
			objConfirmPwd.val('');
			objPwd.focus();
			return false;
		} else if (objPwd.val() == objOldPwd.val()) {
			updateTips(objValidateTips, "이전 비밀번호와 다른 비밀번호를 입력해 주세요.");
			objPwd.val('');
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
//-->
</script>

<div id="dialog-changeadminpassword" title="비밀번호 변경" class="dialog-form">
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
				<div class="field-title">관리자 ID</div>
				<div class="field-value"><span id="adminid"></span></div>
			</div>
			<div id="row-adminname" class="field-line">
				<div class="field-title">관리자 명</div>
				<div class="field-value"><span id="adminname"></span></div>
			</div>
			<div id="row-oldpwd" class="field-line">
				<div class="field-title">기존 비밀번호<span class="required_field">*</span></div>
				<div class="field-value"><input type="password" id="oldpwd" name="oldpwd" value="" class="text ui-widget-content" /></div>
			</div>
			<div id="row-pwd" class="field-line">
				<div class="field-title">변경할 비밀번호<span class="required_field">*</span></div>
				<div class="field-value"><input type="password" id="pwd" name="pwd" value="" class="text ui-widget-content" /></div>
			</div>
			<div id="row-confirmpwd" class="field-line">
				<div class="field-title">비밀번호 확인<span class="required_field">*</span></div>
				<div class="field-value"><input type="password" id="confirmpwd" name="confirmpwd" value="" class="text ui-widget-content" /></div>
			</div>
		</div>
	</div>
</div>
