<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openLicenceRenewalHistoryInfoDialog = function(seqNo) {

		var postData = getRequestLicenceRenewalHistoryInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("라이센스 갱신 정보 조회", "라이센스 갱신 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var licenceCount = $(data).find('licencecount').text();
				if ((licenceCount == null) || (licenceCount.length <= 0)) {
					licenceCount = 0;
				}
				var dbProtectionLicenceCount = $(data).find('dbprotectionlicencecount').text();
				if ((dbProtectionLicenceCount == null) || (dbProtectionLicenceCount.length <= 0)) {
					dbProtectionLicenceCount = 0;
				}

				var comments = $(data).find('comments').text();
				comments = comments.replace(/\n/g, "<br />");
				comments = comments.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogOptions = {
					"minWidth" : 300,
					"maxWidth" : $(document).width(),
					"width" : g_dialogWidth,
					"height" : g_dialogHeight,
					"maxHeight" : $(document).height(),
					"resizable" : true,
					"draggable" : true,
					"open" : function() {
						$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
		 					icons: { primary: 'ui-icon-circle-check' }
						});
						$(this).parent().focus();
					},
					"resizeStop" : function() {
						g_dialogWidth = $(this).dialog("option", "width");
						g_dialogHeight = $(this).dialog("option", "height");
						resizeDialogElement($(this), $(this).find('#comments'));
					},
					"dragStop" : function( event, ui ) {
						g_lastDialogPosition = ui.position;
					},
					"buttons" : {
						"확인": function() {
							$(this).dialog('close');
						}
					},
					"close" : function() {
					}
				};

				var dialogExtendOptions = {
					"closable" : false,
					"maximizable" : true,
					"minimizable" : true,
					"collapsable" : true,
					"dblclick" : "collapse",
					"load" : function(event, dialog){ },
					"beforeCollapse" : function(event, dialog){ },
					"beforeMaximize" : function(event, dialog){ },
					"beforeMinimize" : function(event, dialog){ },
					"beforeRestore" : function(event, dialog){ },
					"collapse" : function(event, dialog){ },
					"maximize" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#comments'));
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#comments'));
					}
				};

				var dialogContents = "";
				dialogContents = '<div title="라이센스 갱신 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="row-companyname" class="field-line">';
				dialogContents += '<div class="field-title">사업장</div>';
				dialogContents += '<div class="field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-licencetype" class="field-line">';
				dialogContents += '<div class="field-title">라이센스 유형</div>';
				dialogContents += '<div class="field-value"><span id="licencetype">' + g_htLicenceTypeList.get($(data).find('licencetype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-licenceperiod" class="field-line">';
				dialogContents += '<div class="field-title">라이센스 유효기간</div>';
				dialogContents += '<div class="field-value"><span id="licencestartdate">' + $(data).find('licencestartdate').text() + '</span> ~ <span id="licenceenddate">' + $(data).find('licenceenddate').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-licencecount" class="field-line">';
				dialogContents += '<div class="field-title">라이센스 수</div>';
				dialogContents += '<div class="field-value"><span id="licencecount">' + licenceCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-dbprotectionlicencecount" class="field-line">';
				dialogContents += '<div class="field-title">DB 보안 라이센스 수</div>';
				dialogContents += '<div class="field-value"><span id="dbprotectionlicencecount">' + dbProtectionLicenceCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-paymenttype" class="field-line">';
				dialogContents += '<div class="field-title">결제 유형</div>';
				var paymentType = "";
				if ($(data).find('paymenttype').text().length > 0) {
					paymentType = g_htPaymentTypeList.get($(data).find('paymenttype').text());
				}
				dialogContents += '<div class="field-value"><span id="paymenttype">' + paymentType + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-paymentamount" class="field-line">';
				dialogContents += '<div class="field-title">결제 금액</div>';
				var paymentAmount = "";
				var paymentAmount = $(data).find('paymentamount').text();
				if ($(data).find('paymentamount').text().length > 0) {
					paymentAmount = paymentAmount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
				}
				dialogContents += '<div class="field-value"><span id="paymentamount">' + paymentAmount + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-paymentdate" class="field-line">';
				dialogContents += '<div class="field-title">결제 일자</div>';
				dialogContents += '<div class="field-value"><span id="paymentdate">' + $(data).find('paymentdate').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-comments" class="field-line">';
				dialogContents += '<div class="field-title">변경 사유</div>';
				dialogContents += '<div class="field-contents"><div id="comments" style="width: 98%; height: 120px; overflow: auto; white-space: normal;">' + comments + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-createdatetime" class="field-line">';
				dialogContents += '<div class="field-title">변경 일시</div>';
				dialogContents += '<div class="field-value"><span id="createdatetime">' + $(data).find('createdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				if (!$.isEmptyObject(g_lastDialogPosition)) {
					newDialog.closest('.ui-dialog').offset({ top: g_lastDialogPosition.top+15, left: g_lastDialogPosition.left+15});
				} else {
					newDialog.dialog("option", "position", { my: "center", at: "center" } );
				}

				if ((newDialog.closest('.ui-dialog').offset().top + newDialog.closest('.ui-dialog').outerHeight(true)) >= $(window).height()) {
					newDialog.closest('.ui-dialog').offset({ top: 0, left: newDialog.closest('.ui-dialog').offset.left});
				}

				g_lastDialogPosition = newDialog.closest('.ui-dialog').offset();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("라이센스 갱신 정보 조회", "라이센스 갱신 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>