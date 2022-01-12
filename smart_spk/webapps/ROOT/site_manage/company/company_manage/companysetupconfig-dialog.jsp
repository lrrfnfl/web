<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_objCompanySetupConfigDialog;

	$(document).ready(function() {
		g_objCompanySetupConfigDialog = $('#dialog-companysetupconfig');
	});

	openCompanySetupConfigDialog = function() {

		g_objCompanySetupConfigDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			width: 560,
			height: 'auto',
			minHeight: 300,
			maxHeight: $(document).height(),
			modal: true,
			open: function(event, ui) {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"확인": function() {
					if (validateCompanySetupConfigData()) {
						$(this).dialog('close');
					}
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
			}
		})

		g_objCompanySetupConfigDialog.dialog('open');
	};

	validateCompanySetupConfigData = function() {

		var objDbProtectionOption = g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]');
		var objPrintControlOption = g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]');
		var objWaterMarkOption = g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]');
		var objMediaControlOption = g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]');
		var objNetworkServiceControlOption = g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]');
		var objSoftwareManageOption = g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]');
		var objRansomwareDetectionOption = g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]');
		var objDefaultKeepFilePeriod = g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]');
		var objValidateTips = g_objCompanySetupConfigDialog.find('#validateTips');

		if (objDbProtectionOption.val().length == 0) {
			updateTips(objValidateTips, "DB 보안 지원 옵션을 선택해 주세요.");
			objDbProtectionOption.focus();
			return false;
		}

		if (objPrintControlOption.val().length == 0) {
			updateTips(objValidateTips, "출력 제어 지원 옵션을 선택해 주세요.");
			objPrintControlOption.focus();
			return false;
		}

		if (objWaterMarkOption.val().length == 0) {
			updateTips(objValidateTips, "워터마크 지원 옵션을 선택해 주세요.");
			objWaterMarkOption.focus();
			return false;
		}

		if (objMediaControlOption.val().length == 0) {
			updateTips(objValidateTips, "매체 제어 지원 옵션을 선택해 주세요.");
			objMediaControlOption.focus();
			return false;
		}

		if (objNetworkServiceControlOption.val().length == 0) {
			updateTips(objValidateTips, "네트워크 서비스 제어 지원 옵션을 선택해 주세요.");
			objNetworkServiceControlOption.focus();
			return false;
		}

		if (objSoftwareManageOption.val().length == 0) {
			updateTips(objValidateTips, "소프트웨어 관리 지원 옵션을 선택해 주세요.");
			objSoftwareManageOption.focus();
			return false;
		}

		if (objRansomwareDetectionOption.val().length == 0) {
			updateTips(objValidateTips, "랜섬웨어 감시 지원 옵션을 선택해 주세요.");
			objRansomwareDetectionOption.focus();
			return false;
		}

		if (objDefaultKeepFilePeriod.val().length == 0) {
			updateTips(objValidateTips, "개인정보 파일 보관일를 입력해 주세요.");
			return false;
		} else {
			if (!isValidParam(objDefaultKeepFilePeriod, PARAM_TYPE_NUMBER, "개인정보 파일 보관일", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div id="dialog-companysetupconfig" title="사업장 기능 옵션 설정" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
				<li>사업장의 기능 옵션을 설정해 주세요.</li>
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
			<div id="row-dbprotectionoption" class="field-line">
				<div class="field-title">DB 보안<span class="required_field">*</span></div>
				<div class="field-value"><select id="dbprotectionoption" name="dbprotectionoption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-printcontroloption" class="field-line hide-block">
				<div class="field-title">출력 제어<span class="required_field">*</span></div>
				<div class="field-value"><select id="printcontroloption" name="printcontroloption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-watermarkoption" class="field-line">
				<div class="field-title">워터마크<span class="required_field">*</span></div>
				<div class="field-value"><select id="watermarkoption" name="watermarkoption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-mediacontroloption" class="field-line">
				<div class="field-title">매체 제어<span class="required_field">*</span></div>
				<div class="field-value"><select id="mediacontroloption" name="mediacontroloption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-networkservicecontroloption" class="field-line">
				<div class="field-title">네트워크 서비스 제어<span class="required_field">*</span></div>
				<div class="field-value"><select id="networkservicecontroloption" name="networkservicecontroloption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-softwaremanageoption" class="field-line">
				<div class="field-title">소프트웨어 관리<span class="required_field">*</span></div>
				<div class="field-value"><select id="softwaremanageoption" name="softwaremanageoption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-ransomwaredetectionoption" class="field-line">
				<div class="field-title">랜섬웨어 감시<span class="required_field">*</span></div>
				<div class="field-value"><select id="ransomwaredetectionoption" name="ransomwaredetectionoption" class="ui-widget-content"></select></div>
			</div>
			<div id="row-defaultkeepfileperiod" class="field-line">
				<div class="field-title">개인정보 파일 보관일<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="defaultkeepfileperiod" name="defaultkeepfileperiod" class="text ui-widget-content" /></div>
			</div>
		</div>
	</div>
</div>
	