<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="changeadminpassword-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objAdminInfo;

	$(document).ready(function() {
		g_objAdminInfo = $('#admin-info');

		$( document).tooltip();

		$('button').button();
		$('#btnChangePassword').button({ icons: {primary: "ui-icon-key"} });
		$('#btnUpdate').button({ icons: {primary: "ui-icon-wrench"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		loadAdminInfo();

<% if (ChangeFirstPasswordState.CHANGE_FIRST_PASSWORD_STATE_NONE.equals((String)session.getAttribute("CHANGEFIRSTPASSWORDFLAG"))) { %>
		displayConfirmDialog("비밀번호 변경", "최초 로그인 또는 비밀번호 초기화 시에는 보안을 위하여 비밀번호를 변경해야 합니다.", "", function() { openChangeAdminPasswordDialog(); });
<% } else if (OptionType.OPTION_TYPE_YES.equals((String) session.getAttribute("NEEDCHANGEPASSWORDFLAG"))) { %>
		displayConfirmDialog("비밀번호 변경", "비밀번호 유효기간이 만료되었습니다.", "새로운 비밀번호로 변경해주세요.", function() { openChangeAdminPasswordDialog(); });
<% } %>

		$('button').click( function () {
			if ($(this).attr('id') == 'btnChangePassword') {
				openChangeAdminPasswordDialog();
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateAdminData()) {
					displayConfirmDialog("관리자 정보 변경", "관리자 정보를 변경하시겠습니까?", "", function() { updateAdmin(); });
				}
			}
		});
	});

	loadAdminInfo = function() {

		var objAdminName = g_objAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objAdminInfo.find('input[name="email"]');
		var objPhone = g_objAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objAdminInfo.find('input[name="mobilephone"]');
		var objAdminType = g_objAdminInfo.find('input[name="admintype"]');
		var objPasswordExpirationFlag = g_objAdminInfo.find('input[name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objAdminInfo.find('input[name="passwordexpirationperiod"]');

		var postData = getRequestAdminInfoByIdParam('<%=(String)session.getAttribute("ADMINID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 정보 조회", "관리자 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var adminName = $(data).find('adminname').text();
				var email = $(data).find('email').text();
				var phone = $(data).find('phone').text();
				var mobilePhone = $(data).find('mobilephone').text();
				var adminType = $(data).find('admintype').text();
				var passwordExpirationFlag = $(data).find('passwordexpirationflag').text();
				var passwordExpirationPeriod = $(data).find('passwordexpirationperiod').text();

				objAdminName.val(adminName);
				objEmail.val(email);
				objPhone.val(phone);
				objMobilePhone.val(mobilePhone);
				objAdminType.val(adminType);
				objPasswordExpirationFlag.val(passwordExpirationFlag);
				objPasswordExpirationPeriod.val(passwordExpirationPeriod);

				$('button[name="btnChangePassword"]').show();
				$('button[name="btnUpdate"]').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 정보 조회", "관리자 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateAdmin = function() {

		var objAdminName = g_objAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objAdminInfo.find('input[name="email"]');
		var objPhone = g_objAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objAdminInfo.find('input[name="mobilephone"]');
		var objAdminType = g_objAdminInfo.find('input[name="admintype"]');
		var objPasswordExpirationFlag = g_objAdminInfo.find('input[name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objAdminInfo.find('input[name="passwordexpirationperiod"]');

		var postData = getRequestUpdateAdminParam('<%=(String)session.getAttribute("ADMINID")%>',
			'<%=(String)session.getAttribute("ADMINID")%>',
			objAdminName.val(),
			objEmail.val(),
			objPhone.val(),
			objMobilePhone.val(),
			objAdminType.val(),
			'<%=(String)session.getAttribute("COMPANYID")%>',
			objPasswordExpirationFlag.val(),
			objPasswordExpirationPeriod.val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 정보 변경", "관리자 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("관리자 정보 변경", "정상 처리되었습니다.", "정상적으로 관리자 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 정보 변경", "관리자 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateAdminData = function(mode) {

		var objAdminName = g_objAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objAdminInfo.find('input[name="email"]');
		var objPhone = g_objAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objAdminInfo.find('input[name="mobilephone"]');
		var objValidateTips = g_objAdminInfo.find('#validateTips');

		if (!isValidParam(objAdminName, PARAM_TYPE_NAME, "관리자 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objEmail.val().length > 0) {
			if (!isValidParam(objEmail, PARAM_TYPE_EMAIL, "이메일", PARAM_EMAIL_MIN_LEN, PARAM_EMAIL_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objPhone.val().length > 0) {
			if (!isValidParam(objPhone, PARAM_TYPE_PHONE, "전화번호", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objMobilePhone.val().length > 0) {
			if (!isValidParam(objMobilePhone, PARAM_TYPE_MOBILE_PHONE, "휴대전화번호", PARAM_MOBILE_PHONE_MIN_LEN, PARAM_MOBILE_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div class="inner-center"> 
	<div class="pane-header">관리자 정보</div>
	<div class="ui-layout-content">
		<div id="admin-info" class="info-form show-block">
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
					<div class="field-title">관리자 ID<span class="required_field">*</span></div>
					<div class="field-value"><span id="adminid"><%=(String)session.getAttribute("ADMINID")%></span></div>
				</div>
				<div id="row-adminname" class="field-line">
					<div class="field-title">관리자 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="adminname" name="adminname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-email" class="field-line">
					<div class="field-title">이메일</div>
					<div class="field-value"><input type="text" id="email" name="email" class="text ui-widget-content" /></div>
				</div>
				<div id="row-phone" class="field-line">
					<div class="field-title">전화번호</div>
					<div class="field-value"><input type="text" id="phone" name="phone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-mobilephone" class="field-line">
					<div class="field-title">휴대전화번호</div>
					<div class="field-value"><input type="text" id="mobilephone" name="mobilephone" class="text ui-widget-content" /></div>
				</div>
				<input type="hidden" id="admintype" name="admintype" />
				<input type="hidden" id="passwordexpirationflag" name="passwordexpirationflag" />
				<input type="hidden" id="passwordexpirationperiod" name="passwordexpirationperiod" />
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnChangePassword" name="btnChangePassword" class="normal-button" style="display: none;">비밀번호 변경</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">관리자 정보 수정</button>
		</div>
	</div>
</div>
