<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objLicenceInfoDialog;

	$(document).ready(function() {
		g_objLicenceInfoDialog = $('#dialog-licenceinfo');

		g_objLicenceInfoDialog.dialog({
			autoOpen: false,
			width: $(document).width()*(1/3),
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
			}
		});
	});

	openLicenceInfoDialog = function(targetCompanyId) {

		var objLicenceStartDate = g_objLicenceInfoDialog.find('#licencestartdate');
		var objLicenceEndDate = g_objLicenceInfoDialog.find('#licenceenddate');
		var objLicenceCount = g_objLicenceInfoDialog.find('#licencecount');
		var objUseCount = g_objLicenceInfoDialog.find('#usecount');

		var postData = getRequestLicenceInfoByIdParam(targetCompanyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("라이센스 정보 조회", "라이센스 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var licenceType = $(data).find('licencetype').text();
				var licenceStartDate = $(data).find('licencestartdate').text();
				var licenceEndDate = $(data).find('licenceenddate').text();
				var licenceCount = $(data).find('licencecount').text();
				var dbProtectionLicenceCount = $(data).find('dbprotectionlicencecount').text();
				var useCount = $(data).find('usecount').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				if ((licenceCount == null) || (licenceCount.length <= 0)) {
					licenceCount = 0;
				}
				if ((dbProtectionLicenceCount == null) || (dbProtectionLicenceCount.length <= 0)) {
					dbProtectionLicenceCount = 0;
				}

				objLicenceStartDate.text(licenceStartDate);
				objLicenceEndDate.text(licenceEndDate);
				objLicenceCount.text(licenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				objUseCount.text(useCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

				g_objLicenceInfoDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 정보 조회", "사용자 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-licenceinfo" title="라이센스 정보" class="dialog-form">
	<div class="dialog-contents">
		<div id="row-licenceperiod" class="field-line">
			<div class="field-title-140">라이센스 유효기간</div>
			<div class="field-value-140">
				<span id="licencestartdate"></span> ~ <span id="licenceenddate"></span>
			</div>
		</div>
		<div id="" class="field-line">
			<div class="field-title-140">라이센스 수</div>
			<div class="field-value-140"><span id="licencecount"></span></div>
		</div>
		<div id="row-usecount" class="field-line">
			<div class="field-title-140">라이센스 사용 수</div>
			<div class="field-value-140"><span id="usecount"></span></div>
		</div>
	</div>
</div>
