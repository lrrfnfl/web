<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--
	var g_objPaymentDialog;

	$(document).ready(function() {
		g_objPaymentDialog = $('#dialog-payment');

		g_objPaymentDialog.dialog({
			autoOpen: false,
			minWidth: 650,
			width: 650,
			height: 'auto',
			autoResize: true,
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

	openPaymentInfoDialog = function(seqNo) {

		var objCompanyName = g_objPaymentDialog.find('#companyname');
		var objPaymentType = g_objPaymentDialog.find('#paymenttype');
		var objApprovalNo = g_objPaymentDialog.find('#approvalno');
		var objPaymentAmount = g_objPaymentDialog.find('#paymentamount');
		var objPaymentDate = g_objPaymentDialog.find('#paymentdate');
		var objCreateDatetime = g_objPaymentDialog.find('#createdatetime');

		var postData = getRequestPaymentInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결제 정보 조회", "결제 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyName = $(data).find('companyname').text();
				var paymentType = $(data).find('paymenttype').text();
				var approvalNo = $(data).find('approvalno').text();
				var paymentAmount = $(data).find('paymentamount').text();
				var paymentDate = $(data).find('paymentdate').text();
				var createDatetime = $(data).find('createdatetime').text();

				objCompanyName.text(companyName);
				objPaymentType.text(g_htPaymentTypeList.get(paymentType));
				objApprovalNo.text(approvalNo);
				objPaymentAmount.text(paymentAmount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 원');
				objPaymentDate.text(paymentDate);
				objCreateDatetime.text(createDatetime);

				g_objPaymentDialog.dialog('option', 'title', '결제 정보');
				g_objPaymentDialog.dialog({height:'auto'});

		  		g_objPaymentDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결제 정보 조회", "결제 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-payment" title="" class="dialog-form">
	<div class="form-contents">
		<div id="row-companyname" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">사업장</div>
			<div class="ui-corner-right field-value"><span id="companyname"></span></div>
		</div>
		<div id="row-approvalno" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">승인 번호</div>
			<div class="ui-corner-right field-value"><span id="approvalno"></span></div>
		</div>
		<div id="row-paymenttype" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">결제 유형</div>
			<div class="ui-corner-right field-value"><span id="paymenttype"></span></div>
		</div>
		<div id="row-paymentamount" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">결제 금액</div>
			<div class="ui-corner-right field-value"><span id="paymentamount"></span></div>
		</div>
		<div id="row-paymentdate" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">결제 일자</div>
			<div class="ui-corner-right field-value"><span id="paymentdate"></span></div>
		</div>
		<div id="row-createdatetime" class="field-line">
			<div class="ui-state-default ui-corner-left field-title">등록 일시</div>
			<div class="ui-corner-right field-value"><span id="createdatetime"></span></div>
		</div>
	</div>
</div>

