<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var TAB_COMPANY_INFO = 0;
	var TAB_ADMIN_INFO = 1;
	var TAB_LICENCE_INFO = 2;
	var TAB_REQUEST_CONFIRM = 3;

	var g_objTabCompanyInfo;
	var g_objTabAdminInfo;
	var g_objTabLicenceInfo;
	var g_objTabRequestConfirm;

	var g_htOptionTypeList = new Hashtable();
	var g_htLicenceTypeList = new Hashtable();
	var g_htPaymentTypeList = new Hashtable();

	$(document).ready(function() {
		g_objTabCompanyInfo = $('#tab-company-info');
		g_objTabAdminInfo = $('#tab-admin-info');
		g_objTabLicenceInfo = $('#tab-licence-info');
		g_objTabRequestConfirm = $('#tab-request-confirm');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnPrev"]').button({ icons: {primary: "ui-icon-arrow-1-w"} });
		$('button[name="btnNext"]').button({ icons: {primary: "ui-icon-arrow-1-e"} });
		$('button[name="btnRequest"]').button({ icons: {primary: "ui-icon-play"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('#tab-main .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('#tab-main .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillOptionList(g_objTabCompanyInfo.find('#radioautocreatedeptcode'), 'autocreatedeptcode', g_htOptionTypeList, '<%=OptionType.OPTION_TYPE_YES%>');

		g_htLicenceTypeList = loadTypeList("LICENCE_TYPE");
		if (g_htLicenceTypeList.isEmpty()) {
			displayAlertDialog("라이센스 유형 조회", "라이센스 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillOptionList(g_objTabLicenceInfo.find('#radiolicencetype'), 'licencetype', g_htLicenceTypeList, '<%=LicenceType.LICENCE_TYPE_STANDARD%>');

		g_htPaymentTypeList = loadTypeList("PAYMENT_TYPE");
		if (g_htPaymentTypeList.isEmpty()) {
			displayAlertDialog("결제 유형 조회", "결제 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillOptionList(g_objTabLicenceInfo.find('#radiopaymenttype'), 'paymenttype', g_htPaymentTypeList, null);

		g_objTabLicenceInfo.find('input[name="licencestartdate"]').datepicker({
			maxDate: null,
			showAnim: "slideDown",
		}).datepicker("setDate", new Date());

		g_objTabLicenceInfo.find('input[name="licenceenddate"]').datepicker({
			maxDate: null,
			showAnim: "slideDown",
		});

		g_objTabLicenceInfo.find('input[name="paymentdate"]').datepicker({
			maxDate: null,
			showAnim: "slideDown",
		});

		g_objTabLicenceInfo.find('input[name="licencecount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'0', vMax: "999999"});
		g_objTabLicenceInfo.find('input[name="paymentamount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'-99999999', vMax: "99999999"});

		$('#tab-main').tabs({
			hide: {
				duration: 200
			},
			active: 0,
			beforeActivate: function( event, ui ) {
				if (ui.oldTab.index() == TAB_COMPANY_INFO) {
					if (!validateCompanyData()) event.preventDefault();
				} else if (ui.oldTab.index() == TAB_ADMIN_INFO) {
					if (!validateAdminData()) event.preventDefault();
				} else if (ui.oldTab.index() == TAB_LICENCE_INFO) {
					if (!validateLicenceData()) event.preventDefault();
				}
			},
			activate: function(event, ui) {
				$('button[name="btnPrev"]').hide();
				$('button[name="btnNext"]').hide();
				$('button[name="btnRequest"]').hide();
				if (ui.newTab.index() == TAB_COMPANY_INFO) {
					$('button[name="btnNext"]').show();
				} else if (ui.newTab.index() == TAB_REQUEST_CONFIRM) {
					displayRequestConfirmData();
					$('button[name="btnPrev"]').show();
					$('button[name="btnRequest"]').show();
				} else {
					$('button[name="btnPrev"]').show();
					$('button[name="btnNext"]').show();
				}
			}
		});

		$('button').click( function () {
			if ($(this).attr('id') == 'btnPrev') {
				var active = $('#tab-main').tabs("option", "active");
				$('#tab-main').tabs("option", "active", active - 1);
			} else if ($(this).attr('id') == 'btnNext') {
				var active = $('#tab-main').tabs("option", "active");
				$('#tab-main').tabs("option", "active", active + 1);
			} else if ($(this).attr('id') == 'btnRequest') {
				requestApplication();
			}
		});

/*
		g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]').change( function() {
			g_objTabLicenceInfo.find('#row-cardtype').hide();
			g_objTabLicenceInfo.find('#row-cardissuer').hide();
			g_objTabLicenceInfo.find('#row-bank').hide();
			if ($(this).filter(':checked').val() == '<%=PaymentType.PAYMENT_TYPE_CREDIT_CARD%>') {
				g_objTabLicenceInfo.find('#row-cardtype').show();
				g_objTabLicenceInfo.find('#row-cardissuer').show();
			} else if ($(this).filter(':checked').val() == '<%=PaymentType.PAYMENT_TYPE_ACCOUNT_TRANSFER%>') {
				g_objTabLicenceInfo.find('#row-bank').show();
			}
		});
*/

	});

	displayRequestConfirmData = function() {

		var objCompanyId = g_objTabRequestConfirm.find('#companyid');
		var objCompanyName = g_objTabRequestConfirm.find('#companyname');
		var objCompanyPostalCode = g_objTabRequestConfirm.find('#companypostalcode');
		var objCompanyAddress = g_objTabRequestConfirm.find('#companyaddress');
		var objCompanyDetailAddress = g_objTabRequestConfirm.find('#companydetailaddress');
		var objManagerName = g_objTabRequestConfirm.find('#managername');
		var objManagerEmail = g_objTabRequestConfirm.find('#manageremail');
		var objManagerPhone = g_objTabRequestConfirm.find('#managerphone');
		var objManagerMobilePhone = g_objTabRequestConfirm.find('#managermobilephone');
		var objAutoCreateDeptCode = g_objTabRequestConfirm.find('#autocreatedeptcode');
		var objAdminId = g_objTabRequestConfirm.find('#adminid');
		var objPwd = g_objTabRequestConfirm.find('#pwd');
		var objAdminName = g_objTabRequestConfirm.find('#adminname');
		var objEmail = g_objTabRequestConfirm.find('#email');
		var objPhone = g_objTabRequestConfirm.find('#phone');
		var objMobilePhone = g_objTabRequestConfirm.find('#mobilephone');
		var objLicenceType = g_objTabRequestConfirm.find('#licencetype');
		var objLicenceStartDate = g_objTabRequestConfirm.find('#licencestartdate');
		var objLicenceEndDate = g_objTabRequestConfirm.find('#licenceenddate');
		var objLicenceCount = g_objTabRequestConfirm.find('#licencecount');
		var objPaymentAmount = g_objTabRequestConfirm.find('#paymentamount');
		var objPaymentDate = g_objTabRequestConfirm.find('#paymentdate');
		var objPaymentType = g_objTabRequestConfirm.find('#paymenttype');

		objCompanyId.text(g_objTabCompanyInfo.find('input[name="companyid"]').val());
		objCompanyName.text(g_objTabCompanyInfo.find('input[name="companyname"]').val());
		objCompanyPostalCode.text(g_objTabCompanyInfo.find('input[name="companypostalcode"]').val());
		objCompanyAddress.text(g_objTabCompanyInfo.find('input[name="companyaddress"]').val());
		objCompanyDetailAddress.text(g_objTabCompanyInfo.find('input[name="companydetailaddress"]').val());
		objManagerName.text(g_objTabCompanyInfo.find('input[name="managername"]').val());
		objManagerEmail.text(g_objTabCompanyInfo.find('input[name="manageremail"]').val());
		objManagerPhone.text(g_objTabCompanyInfo.find('input[name="managerphone"]').val());
		objManagerMobilePhone.text(g_objTabCompanyInfo.find('input[name="managermobilephone"]').val());
		objAutoCreateDeptCode.text(g_htOptionTypeList.get(g_objTabCompanyInfo.find('input[type="radio"][name="autocreatedeptcode"]').filter(':checked').val()));
		objAdminId.text(g_objTabAdminInfo.find('input[name="adminid"]').val());
		objPwd.text(g_objTabAdminInfo.find('input[name="pwd"]').val());
		objAdminName.text(g_objTabAdminInfo.find('input[name="adminname"]').val());
		objEmail.text(g_objTabAdminInfo.find('input[name="email"]').val());
		objPhone.text(g_objTabAdminInfo.find('input[name="phone"]').val());
		objMobilePhone.text(g_objTabAdminInfo.find('input[name="mobilephone"]').val());
		objLicenceType.text(g_htLicenceTypeList.get(g_objTabLicenceInfo.find('input[type="radio"][name="licencetype"]').filter(':checked').val()));
		objLicenceStartDate.text(g_objTabLicenceInfo.find('input[name="licencestartdate"]').val());
		objLicenceEndDate.text(g_objTabLicenceInfo.find('input[name="licenceenddate"]').val());
		objLicenceCount.text(g_objTabLicenceInfo.find('input[name="licencecount"]').val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		if (g_objTabLicenceInfo.find('input[name="paymentamount"]').val().length > 0) {
			objPaymentAmount.text(g_objTabLicenceInfo.find('input[name="paymentamount"]').val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 원");
		} else {
			objPaymentAmount.text('');
		}
		objPaymentDate.text(g_objTabLicenceInfo.find('input[name="paymentdate"]').val());
		if (g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]').is(":checked")) {
			objPaymentType.text(g_htPaymentTypeList.get(g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]').filter(':checked').val()));
		}
	};

	requestApplication = function() {

		var currentDate = new Date();
		var approvalNo = currentDate.formatString("yyyyMMddhhmmss");

		var paymentType = "";
		if (g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]').is(":checked")) {
			paymentType = g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]').filter(':checked').val();
		}

		var postData = getRequestApplicationServiceParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objTabCompanyInfo.find('input[name="companyid"]').val(),
			g_objTabCompanyInfo.find('input[name="companyname"]').val(),
			g_objTabCompanyInfo.find('input[name="companypostalcode"]').val(),
			g_objTabCompanyInfo.find('input[name="companyaddress"]').val(),
			g_objTabCompanyInfo.find('input[name="companydetailaddress"]').val(),
			g_objTabCompanyInfo.find('input[name="managername"]').val(),
			g_objTabCompanyInfo.find('input[name="manageremail"]').val(),
			g_objTabCompanyInfo.find('input[name="managerphone"]').val(),
			g_objTabCompanyInfo.find('input[name="managermobilephone"]').val(),
			g_objTabCompanyInfo.find('input[type="radio"][name="autocreatedeptcode"]').filter(':checked').val(),
			g_objTabAdminInfo.find('input[name="adminid"]').val(),
			g_objTabAdminInfo.find('input[name="pwd"]').val(),
			g_objTabAdminInfo.find('input[name="adminname"]').val(),
			g_objTabAdminInfo.find('input[name="email"]').val(),
			g_objTabAdminInfo.find('input[name="phone"]').val(),
			g_objTabAdminInfo.find('input[name="mobilephone"]').val(),
			g_objTabLicenceInfo.find('input[type="radio"][name="licencetype"]').filter(':checked').val(),
			g_objTabLicenceInfo.find('input[name="licencestartdate"]').val().split('-').join(''),
			g_objTabLicenceInfo.find('input[name="licenceenddate"]').val().split('-').join(''),
			g_objTabLicenceInfo.find('input[name="licencecount"]').val().replace(/,/g, ''),
			paymentType,
			approvalNo,
			g_objTabLicenceInfo.find('input[name="paymentamount"]').val().replace(/,/g, ''),
			g_objTabLicenceInfo.find('input[name="paymentdate"]').val().split('-').join(''));

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('button[name="btnPrev"]').hide();
				$('button[name="btnRequest"]').hide();
				$('#tab-main .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-main .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("서비스 신청", "서비스 신청 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("서비스 신청", "정상 처리되었습니다.", "정상적으로 서비스가 신청되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("서비스 신청", "서비스 신청 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateCompanyData = function() {

		var objCompanyId = g_objTabCompanyInfo.find('input[name="companyid"]');
		var objCompanyName = g_objTabCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objTabCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objTabCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objTabCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objTabCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objTabCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objTabCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objTabCompanyInfo.find('input[name="managermobilephone"]');
		var objAutoCreateDeptCode = g_objTabCompanyInfo.find('input[type="radio"][name="autocreatedeptcode"]');
		var objValidateTips = g_objTabCompanyInfo.find('#validateTips');

		if (!isValidParam(objCompanyId, PARAM_TYPE_COMPANYID, "사업장 ID", PARAM_COMPANYID_MIN_LEN, PARAM_COMPANYID_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (!isValidParam(objCompanyName, PARAM_TYPE_NAME, "사업장 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objCompanyPostalCode.val().length > 0) {
			if (!isValidParam(objCompanyPostalCode, PARAM_TYPE_POSTAL_CODE, "우편번호", PARAM_POSTAL_CODE_MIN_LEN, PARAM_POSTAL_CODE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyAddress.val().length > 0) {
			if (!isValidParam(objCompanyAddress, PARAM_TYPE_ADDRESS, "주소", PARAM_ADDRESS_MIN_LEN, PARAM_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyDetailAddress.val().length > 0) {
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

		if (objManagerMobilePhone.val().length > 0) {
			if (!isValidParam(objManagerMobilePhone, PARAM_TYPE_MOBILE_PHONE, "담당자 휴대전화번호", PARAM_MOBILE_PHONE_MIN_LEN, PARAM_MOBILE_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if ((objAutoCreateDeptCode.filter(':checked').val() == null) || (objAutoCreateDeptCode.filter(':checked').val().length == 0)) {
			updateTips(objValidateTips, "부서코드 자동 생성 유형을 선택해 주세요.");
			return false;
		}

		return true;
	};

	validateAdminData = function() {

		var objAdminId = g_objTabAdminInfo.find('input[name="adminid"]');
		var objPwd = g_objTabAdminInfo.find('input[name="pwd"]');
		var objConfirmPwd = g_objTabAdminInfo.find('input[name="confirmpwd"]');
		var objAdminName = g_objTabAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objTabAdminInfo.find('input[name="email"]');
		var objPhone = g_objTabAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objTabAdminInfo.find('input[name="mobilephone"]');
		var objValidateTips = g_objTabAdminInfo.find('#validateTips');

		if (!isValidParam(objAdminId, PARAM_TYPE_ID, "관리자 ID", PARAM_ID_MIN_LEN, PARAM_ID_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (!isValidParam(objPwd, PARAM_TYPE_PWD, "비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objPwd.val() != objConfirmPwd.val()) {
			updateTips(objValidateTips, "입력한 두 비밀번호가 일치하지 않습니다.");
			objPwd.val('');
			objConfirmPwd.val('');
			objPwd.focus();
			return false;
		}

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

	validateLicenceData = function() {

		var objLicenceType = g_objTabLicenceInfo.find('input[type="radio"][name="licencetype"]');
		var objLicenceStartDate = g_objTabLicenceInfo.find('input[name="licencestartdate"]');
		var objLicenceEndDate = g_objTabLicenceInfo.find('input[name="licenceenddate"]');
		var objLicenceCount = g_objTabLicenceInfo.find('input[name="licencecount"]');
		var objPaymentAmount = g_objTabLicenceInfo.find('input[name="paymentamount"]');
		var objPaymentDate = g_objTabLicenceInfo.find('input[name="paymentdate"]');
		var objPaymentType = g_objTabLicenceInfo.find('input[type="radio"][name="paymenttype"]');
		var objValidateTips = g_objTabLicenceInfo.find('#validateTips');

		if ((objLicenceType.filter(':checked').val() == null) || (objLicenceType.filter(':checked').val().length == 0)) {
			updateTips(objValidateTips, "라이센스 유형을 선택해 주세요.");
			return false;
		} else {
			if (objLicenceStartDate.val().length == 0) {
				updateTips(objValidateTips, "라이센스 시작일자를 선택해 주세요.");
				objLicenceStartDate.focus();
				return false;
			}
			if (objLicenceEndDate.val().length == 0) {
				updateTips(objValidateTips, "라이센스 종료일자를 선택해 주세요.");
				objLicenceEndDate.focus();
				return false;
			}
		}

		if (objLicenceCount.val().length == 0) {
			updateTips(objValidateTips, "라이센스 수를 압력해 주세요.");
			objLicenceCount.focus();
			return false;
		} else {
			if (!isValidParam(objLicenceCount, PARAM_TYPE_NUMBER, "라이센스 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			} else {
				if (parseInt(objLicenceCount.val()) <= 0) {
					updateTips(objValidateTips, "라이센스 수를 압력해 주세요.");
					objLicenceCount.focus();
					return false;
				}
			}
		}

		if (objPaymentAmount.val().length > 0) {
			if (!isValidParam(objPaymentAmount, PARAM_TYPE_NUMBER, "결제 금액", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			} else {
				if (parseInt(objPaymentAmount.val()) < 0) {
					updateTips(objValidateTips, "결제 금액을 압력해 주세요.");
					objPaymentAmount.focus();
					return false;
				}
			}
		}

// 		if (objPaymentDate.val().length == 0) {
// 			updateTips(objValidateTips, "결제 일자를 선택해 주세요.");
// 			objPaymentDate.focus();
// 			return false;
// 		}

// 		if ((objPaymentType.filter(':checked').val() == null) || (objPaymentType.filter(':checked').val().length == 0)) {
// 			updateTips(objValidateTips, "결제 유형을 선택해 주세요.");
// 			return false;
// 		}

		return true;
	};
//-->
</script>

<div id="tab-main" class="inner-center under-tab border-none">
	<div class="pane-header" style="margin-bottom: 20px;">서비스 신청</div>
	<ul>
		<li><a href="#tab-company-info">1. 사업장 정보 입력</a></li>
		<li><a href="#tab-admin-info">2. 관리자 정보 입력</a></li>
		<li><a href="#tab-licence-info">3. 라이센스 정보 입력</a></li>
		<li><a href="#tab-request-confirm">4. 신청 정보 확인</a></li>
	</ul>
	<div class="ui-layout-content border-none">
		<div id="tab-company-info" class="info-form">
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
					<div class="field-value"><input type="text" id="companyid" name="companyid" class="text ui-widget-content" /></div>
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
				<div id="row-autocreatedeptcode" class="field-line">
					<div class="field-title">부서코드 자동 생성<span class="required_field">*</span></div>
					<div class="field-value">
						<div id="radioautocreatedeptcode"></div>
					</div>
				</div>
			</div>
		</div>
		<div id="tab-admin-info" class="info-form">
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
					<div class="field-value"><input type="text" id="adminid" name="adminid" class="text ui-widget-content" /></div>
				</div>
				<div id="row-pwd" class="field-line">
					<div class="field-title">비밀번호<span class="required_field">*</span></div>
					<div class="field-value"><input type="password" id="pwd" name="pwd" value="" class="text ui-widget-content" /></div>
				</div>
				<div id="row-confirmpwd" class="field-line">
					<div class="field-title">비밀번호 확인<span class="required_field">*</span></div>
					<div class="field-value"><input type="password" id="confirmpwd" name="confirmpwd" value="" class="text ui-widget-content" /></div>
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
			</div>
		</div>
		<div id="tab-licence-info" class="info-form">
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
				<div id="row-licencetype" class="field-line">
					<div class="field-title">라이센스 유형<span class="required_field">*</span></div>
					<div class="field-value">
						<div id="radiolicencetype"></div>
					</div>
				</div>
				<div id="row-licenceperiod" class="field-line">
					<div class="field-title">라이센스 유효기간<span class="required_field">*</span></div>
					<div class="field-value">
						<input type="text" id="licencestartdate" name="licencestartdate" class="text ui-widget-content input-date" readonly="readonly" />
						~ <input type="text" id="licenceenddate" name="licenceenddate" class="text ui-widget-content input-date" readonly="readonly" />
					</div>
				</div>
				<div id="row-licencecount" class="field-line">
					<div class="field-title">라이센스 수<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="licencecount" name="licencecount" value="" class="text ui-widget-content" style="text-align: right; width: 80px;" /> 명</div>
				</div>
				<div id="row-paymentamount" class="field-line">
					<div class="field-title">결제 금액</div>
					<div class="field-value"><input type="text" id="paymentamount" name="paymentamount" value="" class="text ui-widget-content" style="text-align: right; width: 80px;" /> 원</div>
				</div>
				<div id="row-paymentdate" class="field-line">
					<div class="field-title">결제일자</div>
					<div class="field-value">
						<input type="text" id="paymentdate" name="paymentdate" class="text ui-widget-content input-date" />
					</div>
				</div>
				<div id="row-paymenttype" class="field-line">
					<div class="field-title">결제 유형<span class="required_field">*</span></div>
					<div class="field-value">
						<div id="radiopaymenttype"></div>
					</div>
				</div>
<!--
				<div id="row-cardtype" class="field-line" style="display: none;">
					<div class="field-title">카드 구분</div>
					<div class="field-value">
						<label class="radio"><input type="radio" name="cardtype" value="0">일반 카드</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="cardtype" value="1">법인 카드</label>
					</div>
				</div>
				<div id="row-cardissuer" class="field-line" style="display: none;">
					<div class="field-title">카드 종류</div>
					<div class="field-value">
						<select id="cardissuer" name="cardissuer" class="ui-widget-content">
							<option value="">카드선택</option>
							<option value='KB'>KB국민카드</option>
							<option value='SH'>신한카드</option>
							<option value='SS'>삼성카드</option>
							<option value='HD'>현대카드</option>
							<option value='LO'>롯데카드</option>
							<option value='KE'>외환카드</option>
							<option value='BC'>비씨카드</option>
							<option value='HN-SK'>하나SK카드</option>
							<option value='HN-BC'>하나(BC)카드</option>
							<option value='WR'>우리카드</option>
							<option value='NH'>NH농협카드</option>
							<option value='NH-BC'>NH비씨카드</option>
							<option value='CT'>씨티카드</option>
							<option value='KG'>광주카드</option>
							<option value='JB'>전북은행카드</option>
							<option value='SH'>수협카드</option>
							<option value='JJ'>제주은행카드</option>
						</select>
					</div>
				</div>
				<div id="row-bank" class="field-line" style="display: none;">
					<div class="field-title">입금 은행</div>
					<div class="field-value">
						<select id="bank" name="bank" class="ui-widget-content">
							<option value="">은행선택</option>
							<option value="NH">농협</option>
							<option value="KB">국민은행</option>
							<option value="WR">우리은행</option>
							<option value="HN">하나은행</option>
							<option value="SH">신한은행</option>
							<option value="KE">외환은행</option>
							<option value="CT">씨티은행</option>
							<option value="IBK">기업은행</option>
							<option value="EPOST">우체국</option>
							<option value="PS">부산은행</option>
							<option value="SC">SC은행</option>
						</select>
					</div>
				</div>
-->
			</div>
		</div>
		<div id="tab-request-confirm" class="info-form">
			<div class="category-sub-title">사업장 정보</div>
			<div class="category-contents border-none" style="padding: 5px 0;">
				<div id="row-companyid" class="field-line">
					<div class="field-title">사업장 ID</div>
					<div class="field-value"><span id="companyid"></span></div>
				</div>
				<div id="row-companyname" class="field-line">
					<div class="field-title">사업장 명</div>
					<div class="field-value"><span id="companyname"></span></div>
				</div>
				<div id="row-companypostalcode" class="field-line">
					<div class="field-title">우편번호</div>
					<div class="field-value"><span id="companypostalcode"></span></div>
				</div>
				<div id="row-companyaddress" class="field-line">
					<div class="field-title">주소</div>
					<div class="field-value"><span id="companyaddress"></span></div>
				</div>
				<div id="row-companydetailaddress" class="field-line">
					<div class="field-title">상세주소</div>
					<div class="field-value"><span id="companydetailaddress"></span></div>
				</div>
				<div id="row-managername" class="field-line">
					<div class="field-title">담당자 명</div>
					<div class="field-value"><span id="managername"></span></div>
				</div>
				<div id="row-manageremail" class="field-line">
					<div class="field-title">담당자 이메일</div>
					<div class="field-value"><span id="manageremail"></span></div>
				</div>
				<div id="row-managerphone" class="field-line">
					<div class="field-title">담당자 전화번호</div>
					<div class="field-value"><span id="managerphone"></span></div>
				</div>
				<div id="row-managermobilephone" class="field-line">
					<div class="field-title">담당자 휴대전화번호</div>
					<div class="field-value"><span id="managermobilephone"></span></div>
				</div>
				<div id="row-autocreatedeptcode" class="field-line">
					<div class="field-title">부서코드 자동 생성</div>
					<div class="field-value"><span id="autocreatedeptcode"></span></div>
				</div>
			</div>
			<div class="category-sub-title">관리자 정보</div>
			<div class="category-contents border-none" style="padding: 5px 0;">
				<div id="row-adminid" class="field-line">
					<div class="field-title">관리자 ID</div>
					<div class="field-value"><span id="adminid"></span></div>
				</div>
				<div id="row-pwd" class="field-line">
					<div class="field-title">비밀번호</div>
					<div class="field-value"><span id="pwd"></span></div>
				</div>
				<div id="row-adminname" class="field-line">
					<div class="field-title">관리자 명</div>
					<div class="field-value"><span id="adminname"></span></div>
				</div>
				<div id="row-email" class="field-line">
					<div class="field-title">이메일</div>
					<div class="field-value"><span id="email"></span></div>
				</div>
				<div id="row-phone" class="field-line">
					<div class="field-title">전화번호</div>
					<div class="field-value"><span id="phone"></span></div>
				</div>
				<div id="row-mobilephone" class="field-line">
					<div class="field-title">휴대전화번호</div>
					<div class="field-value"><span id="mobilephone"></span></div>
				</div>
			</div>
			<div class="category-sub-title">라이센스 정보</div>
			<div class="category-contents border-none" style="padding: 5px 0;">
				<div id="row-licencetype" class="field-line">
					<div class="field-title">라이센스 유형</div>
					<div class="field-value"><span id="licencetype"></span></div>
				</div>
				<div id="row-licenceperiod" class="field-line">
					<div class="field-title">라이센스 유효기간</div>
					<div class="field-value"><span id="licencestartdate"></span> ~ <span id="licenceenddate"></span></div>
				</div>
				<div id="row-licencecount" class="field-line">
					<div class="field-title">라이센스 수</div>
					<div class="field-value"><span id="licencecount">0</span> 명</div>
				</div>
				<div id="row-paymentamount" class="field-line">
					<div class="field-title">결제 금액</div>
					<div class="field-value"><span id="paymentamount">0</span></div>
				</div>
				<div id="row-paymentdate" class="field-line">
					<div class="field-title">결제 일자</div>
					<div class="field-value"><span id="paymentdate"></span></div>
				</div>
				<div id="row-paymenttype" class="field-line">
					<div class="field-title">결제 유형</div>
					<div class="field-value"><span id="paymenttype"></span></div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnPrev" name="btnPrev" class="normal-button" style="display: none;">이전</button>
			<button type="button" id="btnNext" name="btnNext" class="normal-button">다음</button>
			<button type="button" id="btnRequest" name="btnRequest" class="normal-button" style="display: none;">신청하기</button>
		</div>
	</div>
</div>
