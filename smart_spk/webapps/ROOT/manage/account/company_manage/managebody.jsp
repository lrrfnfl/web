<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="licenceinfo-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyInfo;

	$(document).ready(function() {
		g_objCompanyInfo = $('#company-info');

		$( document).tooltip();

		$('button').button();
		$('button[name="btnLicenceInfo"]').button({ icons: {primary: "ui-icon-info"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		loadCompanyInfo();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnLicenceInfo') {
				openLicenceInfoDialog('<%=(String)session.getAttribute("COMPANYID")%>');
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateCompanyData()) {
					displayConfirmDialog("사업장 정보 변경", "사업장 정보를 변경하시겠습니까?", "", function() { updateCompany(); });
				}
			}
		});
	});

	loadCompanyInfo = function() {

		var objCompanyName = g_objCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objCompanyInfo.find('input[name="managermobilephone"]');
		var objAutoCreateDeptCode = g_objCompanyInfo.find('input[name="autocreatedeptcode"]');

		var postData = getRequestCompanyInfoByIdParam('<%=(String)session.getAttribute("COMPANYID")%>');

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
					displayAlertDialog("사업장 정보 조회", "사업장 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyName = $(data).find('companyname').text();
				var companyPostalCode = $(data).find('companypostalcode').text();
				var companyAddress = $(data).find('companyaddress').text();
				var companyDetailAddress = $(data).find('companydetailaddress').text();
				var managerName = $(data).find('managername').text();
				var managerEmail = $(data).find('manageremail').text();
				var managerPhone = $(data).find('managerphone').text();
				var managerMobilePhone = $(data).find('managermobilephone').text();
				var autoCreateDeptCodeFlag = $(data).find('autocreatedeptcodeflag').text();

				objCompanyName.val(companyName);
				objCompanyPostalCode.val(companyPostalCode);
				objCompanyAddress.val(companyAddress);
				objCompanyDetailAddress.val(companyDetailAddress);
				objManagerName.val(managerName);
				objManagerEmail.val(managerEmail);
				objManagerPhone.val(managerPhone);
				objManagerMobilePhone.val(managerMobilePhone);
				objAutoCreateDeptCode.val(autoCreateDeptCodeFlag);

<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnLicenceInfo"]').show();
<% } %>
				$('button[name="btnUpdate"]').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 정보 조회", "사업장 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateCompany = function() {

		var objCompanyName = g_objCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objCompanyInfo.find('input[name="managermobilephone"]');
		var objAutoCreateDeptCode = g_objCompanyInfo.find('input[name="autocreatedeptcode"]');

		var htCompanySetupConfigData = new Hashtable();

		var postData = getRequestUpdateCompanyParam('<%=(String)session.getAttribute("ADMINID")%>',
			'<%=(String)session.getAttribute("COMPANYID")%>',
			objCompanyName.val(),
			objCompanyPostalCode.val(),
			objCompanyAddress.val(),
			objCompanyDetailAddress.val(),
			objManagerName.val(),
			objManagerEmail.val(),
			objManagerPhone.val(),
			objManagerMobilePhone.val(),
			objAutoCreateDeptCode.val(),
			htCompanySetupConfigData,
			null);

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
					displayAlertDialog("사업장 정보 변경", "사업장 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("사업장 정보 변경", "정상 처리되었습니다.", "정상적으로 사업장 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 정보 변경", "사업장 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateCompanyData = function() {

		var objCompanyName = g_objCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objCompanyInfo.find('input[name="managermobilephone"]');
		var objValidateTips = g_objCompanyInfo.find('#validateTips');

		if (!isValidParam(objCompanyName, PARAM_TYPE_NAME, "사업장 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objCompanyPostalCode.val().length >0) {
			if (!isValidParam(objCompanyPostalCode, PARAM_TYPE_POSTAL_CODE, "우편번호", PARAM_POSTAL_CODE_MIN_LEN, PARAM_POSTAL_CODE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyAddress.val().length >0) {
			if (!isValidParam(objCompanyAddress, PARAM_TYPE_ADDRESS, "주소", PARAM_ADDRESS_MIN_LEN, PARAM_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyDetailAddress.val().length >0) {
			if (!isValidParam(objCompanyDetailAddress, PARAM_TYPE_ADDRESS, "상세주소", PARAM_DETAIL_ADDRESS_MIN_LEN, PARAM_DETAIL_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (!isValidParam(objManagerName, PARAM_TYPE_NAME, "담당자 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objManagerEmail.val().length > 0) {
			if (!isValidParam(objManagerEmail, PARAM_TYPE_EMAIL, "담당자 이메일", PARAM_EMAIL_MIN_LEN, PARAM_EMAIL_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objManagerPhone.val().length > 0) {
			if (!isValidParam(objManagerPhone, PARAM_TYPE_PHONE, "담당자 전화번호", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objManagerMobilePhone.val().length >0) {
			if (!isValidParam(objManagerMobilePhone, PARAM_TYPE_MOBILE_PHONE, "담당자 휴대전화번호", PARAM_MOBILE_PHONE_MIN_LEN, PARAM_MOBILE_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div class="inner-center">
	<div class="pane-header">사업장 정보</div>
	<div class="ui-layout-content">
		<div id="company-info" class="info-form show-block">
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
				<div id="row-companyid" class="field-line">
					<div class="field-title">사업장 ID<span class="required_field">*</span></div>
					<div class="field-value"><span id="companyid"><%=(String)session.getAttribute("COMPANYID")%></span></div>
				</div>
				<div id="row-companyname" class="field-line">
					<div class="field-title">사업장 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="companyname" name="companyname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companypostalcode" class="field-line">
					<div class="field-title">우편번호</div>
					<div class="field-value"><input type="text" id="companypostalcode" name="companypostalcode" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companyaddress" class="field-line">
					<div class="field-title">주소</div>
					<div class="field-value"><input type="text" id="companyaddress" name="companyaddress" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companydetailaddress" class="field-line">
					<div class="field-title">상세주소</div>
					<div class="field-value"><input type="text" id="companydetailaddress" name="companydetailaddress" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managername" class="field-line">
					<div class="field-title">담당자 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="managername" name="managername" class="text ui-widget-content" /></div>
				</div>
				<div id="row-manageremail" class="field-line">
					<div class="field-title">담당자 이메일</div>
					<div class="field-value"><input type="text" id="manageremail" name="manageremail" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managerphone" class="field-line">
					<div class="field-title">담당자 전화번호</div>
					<div class="field-value"><input type="text" id="managerphone" name="managerphone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managermobilephone" class="field-line">
					<div class="field-title">담당자 휴대전화번호</div>
					<div class="field-value"><input type="text" id="managermobilephone" name="managermobilephone" class="text ui-widget-content" /></div>
				</div>
				<input type="hidden" id="autocreatedeptcode" name="autocreatedeptcode" />
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnLicenceInfo" name="btnLicenceInfo" class="normal-button" style="display: none;">라이센스 정보</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">사업장 정보 수정</button>
		</div>
	</div>
</div>
