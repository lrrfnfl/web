<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
	var g_objBatchUserRegistProgressDialog;

	var g_bStopBatch = false;
	var g_totalCount = 0;
	var g_progressCount = 0;
	var g_successCount = 0;
	var g_failCount = 0;

	$(document).ready(function() {
		g_objBatchUserRegistProgressDialog = $('#dialog-batchuserregistprogress');

		g_objBatchUserRegistProgressDialog.dialog({
			autoOpen: false,
			width: 400,
			height: 'auto',
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().find('.ui-dialog-buttonpane button:contains(확인)').hide();
				$(this).parent().find('.ui-dialog-buttonpane button:contains(취소)').show();
				$(this).parent().focus();

				setTimeout(function() { executeBatch(); }, 100);
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				},
				"취소": function() {
					g_bStopBatch = true;
					$(this).parent().find('.ui-dialog-buttonpane button:contains(확인)').show();
					$(this).parent().find('.ui-dialog-buttonpane button:contains(취소)').hide();
				}
			},
			close: function() {
			}
		});

		g_objBatchUserRegistProgressDialog.find('#progressbar').progressbar({
			value: 0
		});

	});

	openBatchUserRegistProgressDialog = function() {

		var objTotalCount = g_objBatchUserRegistProgressDialog.find('#totalcount');
		var objProgressCount = g_objBatchUserRegistProgressDialog.find('#progresscount');
		var objSuccessCount = g_objBatchUserRegistProgressDialog.find('#successcount');
		var objFailCount = g_objBatchUserRegistProgressDialog.find('#failcount');
		var objProgressBar = g_objBatchUserRegistProgressDialog.find('#progressbar');

		g_bStopBatch = false;

		g_totalCount = g_objManageBatch.find('.list-table > tbody > tr').length;
		g_progressCount = 0;
		g_successCount = 0;
		g_failCount = 0;

		objTotalCount.text(g_totalCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objProgressCount.text(g_progressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objSuccessCount.text(g_successCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objFailCount.text(g_failCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objProgressBar.progressbar('value', g_progressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		g_objBatchUserRegistProgressDialog.dialog('open');
	};

	executeBatch = function() {

		var delayMiliseconds = 0;

		g_objManageBatch.find('.list-table > tbody > tr').each( function () {
			delayMiliseconds += 200;
			var objTr = $(this);
			if (validateUserData(objTr)) {
				setTimeout(function() { insertUser(objTr); }, delayMiliseconds);
			}
		});
	};

	insertUser = function(objTr) {

		var companyId = objTr.find('td:eq(1)').text();
		var deptCode = objTr.find('td:eq(3)').text();
		var userId = objTr.find('td:eq(5)').text();
		var password = objTr.find('td:eq(6)').text();
		var userName = objTr.find('td:eq(7)').text();
		var email = objTr.find('td:eq(8)').text();
		var phone = objTr.find('td:eq(9)').text();
		var mobilePhone = objTr.find('td:eq(10)').text();
		var objResult = objTr.find('td:eq(11)');

		if (g_bStopBatch)
			return false;

		var postData = getRequestInsertUserParam('<%=(String)session.getAttribute("ADMINID")%>',
				companyId,
				userId,
				password,
				userName,
				email,
				phone,
				mobilePhone,
				deptCode,
				<%=UserType.USER_TYPE_NORMAL%>);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayResultStatus(objResult, $(data).find('errormsg').text(), true);
				} else {
					displayResultStatus(objResult, '정상처리', false);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					objResult.text(jqXHR.statusText + "(" + jqXHR.status + ")");
					objResult.attr("title", jqXHR.statusText + "(" + jqXHR.status + ")");
					objResult.css('color', '#f58400');
				}
			}
		});
	};

	displayResultStatus = function(objResult, resultMsg, isError) {

		var objProgressCount = g_objBatchUserRegistProgressDialog.find('#progresscount');
		var objSuccessCount = g_objBatchUserRegistProgressDialog.find('#successcount');
		var objFailCount = g_objBatchUserRegistProgressDialog.find('#failcount');
		var objProgressBar = g_objBatchUserRegistProgressDialog.find('#progressbar');

		objProgressCount.text((++g_progressCount).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		var processrate = 0;
		if (g_progressCount == g_totalCount) {
			processrate = 100;
			g_objBatchUserRegistProgressDialog.parent().find('.ui-dialog-buttonpane button:contains(확인)').show();
			g_objBatchUserRegistProgressDialog.parent().find('.ui-dialog-buttonpane button:contains(취소)').hide();
		} else {
			processrate = (g_progressCount/g_totalCount)*100;
		}
		objProgressBar.progressbar('value', processrate);

		if( isError) {
			g_failCount += 1;
			objResult.text(resultMsg);
			objResult.css('color', '#f58400');
			objFailCount.text((g_failCount).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		} else {
			g_successCount += 1;
			objResult.text(resultMsg);
			objResult.css('color', '#67b021');
			objSuccessCount.text((g_successCount).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		}
	};

	validateUserData = function(objTr) {

		var companyId = objTr.find('td:eq(1)').text();
		var deptCode = objTr.find('td:eq(3)').text();
		var userId = objTr.find('td:eq(5)').text();
		var password = objTr.find('td:eq(6)').text();
		var userName = objTr.find('td:eq(7)').text();
		var email = objTr.find('td:eq(8)').text();
		var phone = objTr.find('td:eq(9)').text();
		var mobilePhone = objTr.find('td:eq(10)').text();
		var objResult = objTr.find('td:eq(11)');

		var objResultMessage = new resultMessage();

		if ((companyId.length < PARAM_COMPANYID_MIN_LEN) || (companyId.length > PARAM_COMPANYID_MAX_LEN)) {
			displayResultStatus(objResult, "[사업장 ID] 의 길이는 " + PARAM_COMPANYID_MIN_LEN + "~" + PARAM_COMPANYID_MAX_LEN + " 자리여야 합니다.", true);
			return false;
		} else if (!checkParam(PARAM_TYPE_COMPANYID, "사업장 ID", companyId, objResultMessage)) {
			displayResultStatus(objResult, objResultMessage.message, true);
			return false;
		}

		if ((deptCode.length < PARAM_DEPT_CODE_MIN_LEN) || (deptCode.length > PARAM_DEPT_CODE_MAX_LEN)) {
			displayResultStatus(objResult, "[부서 코드] 의 길이는 " + PARAM_DEPT_CODE_MIN_LEN + "~" + PARAM_DEPT_CODE_MAX_LEN + " 자리여야 합니다.", true);
			return false;
		} else if (!checkParam(PARAM_TYPE_DEPT_CODE, "부서 코드", deptCode, objResultMessage)) {
			displayResultStatus(objResult, objResultMessage.message, true);
			return false;
		}

		if ((userId.length < PARAM_ID_MIN_LEN) || (userId.length > PARAM_ID_MAX_LEN)) {
			displayResultStatus(objResult, "[사용자 ID] 의 길이는 " + PARAM_ID_MIN_LEN + "~" + PARAM_ID_MAX_LEN + " 자리여야 합니다.", true);
			return false;
		} else if (!checkParam(PARAM_TYPE_ID, "사용자 ID", userId, objResultMessage)) {
			displayResultStatus(objResult, objResultMessage.message, true);
			return false;
		}

		if ((password.length < PARAM_PWD_MIN_LEN) || (password.length > PARAM_PWD_MAX_LEN)) {
			displayResultStatus(objResult, "[비밀번호] 의 길이는 " + PARAM_PWD_MIN_LEN + "~" + PARAM_PWD_MAX_LEN + " 자리여야 합니다.", true);
			return false;
		} else if (!checkParam(PARAM_TYPE_PWD, "비밀번호", password, objResultMessage)) {
			displayResultStatus(objResult, objResultMessage.message, true);
			return false;
		}

		if ((userName.length < PARAM_NAME_MIN_LEN) || (userName.length > PARAM_NAME_MAX_LEN)) {
			displayResultStatus(objResult, "[사용자 명] 의 길이는 " + PARAM_NAME_MIN_LEN + "~" + PARAM_NAME_MAX_LEN + " 자리여야 합니다.", true);
			return false;
		} else if (!checkParam(PARAM_TYPE_NAME, "사용자 명", userName, objResultMessage)) {
			displayResultStatus(objResult, objResultMessage.message, true);
			return false;
		}

		if (email.length != 0) {
			if ((email.length < PARAM_EMAIL_MIN_LEN) || (email.length > PARAM_EMAIL_MAX_LEN)) {
				displayResultStatus(objResult, "[이메일] 의 길이는 " + PARAM_EMAIL_MIN_LEN + "~" + PARAM_EMAIL_MAX_LEN + " 자리여야 합니다.", true);
				return false;
			} else if (!checkParam(PARAM_TYPE_EMAIL, "이메일", email, objResultMessage)) {
				displayResultStatus(objResult, objResultMessage.message, true);
				return false;
			}
		}

		if (phone.length != 0) {
			if ((phone.length < PARAM_PHONE_MIN_LEN) || (phone.length > PARAM_PHONE_MAX_LEN)) {
				displayResultStatus(objResult, "[전화번호] 의 길이는 " + PARAM_PHONE_MIN_LEN + "~" + PARAM_PHONE_MAX_LEN + " 자리여야 합니다.", true);
				return false;
			} else if (!checkParam(PARAM_TYPE_PHONE, "전화번호", phone, objResultMessage)) {
				displayResultStatus(objResult, objResultMessage.message, true);
				return false;
			}
		}

		if (mobilePhone.length != 0) {
			if ((mobilePhone.length < PARAM_MOBILE_PHONE_MIN_LEN) || (mobilePhone.length > PARAM_MOBILE_PHONE_MAX_LEN)) {
				displayResultStatus(objResult, "[휴대전화번호] 의 길이는 " + PARAM_MOBILE_PHONE_MIN_LEN + "~" + PARAM_MOBILE_PHONE_MAX_LEN + " 자리여야 합니다.", true);
				return false;
			} else if (!checkParam(PARAM_TYPE_MOBILE_PHONE, "휴대전화번호", mobilePhone, objResultMessage)) {
				displayResultStatus(objResult, objResultMessage.message, true);
				return false;
			}
		}

		return true;
	};
</script>

<div class="ui-dialog">
	<div id="dialog-batchuserregistprogress" title="사용자 배치 등록 처리 상태" class="ui-dialog-content dialog-form">
		<div class="form-contents">
			<div id="row-totalcount" class="field-line">
				<div class="field-title">총 등록 사용자 수</div>
				<div class="field-value"><span id="totalcount"></span></div>
			</div>
			<div id="row-progresscount" class="field-line">
				<div class="field-title">등록 진행 수 </div>
				<div class="field-value"><span id="progresscount"></span></div>
			</div>
			<div id="row-successcount" class="field-line">
				<div class="field-title">등록 성공 수</div>
				<div class="field-value"><span id="successcount"></span></div>
			</div>
			<div id="row-failcount" class="field-line">
				<div class="field-title">등록 실패 수</div>
				<div class="field-value"><span id="failcount"></span></div>
			</div>
		</div>
		<div id="batchprogress" style="margin: 20px 0;">
			<div>진행률:</div>
			<div id="progressbar" style="height: 20px; border: 1px solid #efefef;"></div>
		</div>
	</div>
</div>
	