<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objSetupConfigDialog;

	$(document).ready(function() {
		g_objSetupConfigDialog = $('#dialog-setupconfig');
	});

	openSetupConfigDialog = function() {

		g_objSetupConfigDialog.dialog({
			autoOpen: false,
			width: 600,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("저장")').button({
 					icons: { primary: 'ui-icon-disk' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"저장": function() {
					if (validateUserSynchronizationConfigData(false)) {
						saveUserSynchronizationConfig();
					}
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
			}
		});

  		g_objSetupConfigDialog.dialog('open');
	};

	loadUserSynchronizationConfigInfo = function() {

		var objDbType = g_objSetupConfigDialog.find('select[name="dbtype"]');
		var objDbIp = g_objSetupConfigDialog.find('input[name="dbip"]');
		var objDbPort = g_objSetupConfigDialog.find('input[name="dbport"]');
		var objDbSid = g_objSetupConfigDialog.find('input[name="dbsid"]');
		var objDbAccountId = g_objSetupConfigDialog.find('input[name="dbaccountid"]');
		var objDbAccountPassword = g_objSetupConfigDialog.find('input[name="dbaccountpassword"]');
		var objSqlQuery = g_objSetupConfigDialog.find('textarea[name="sqlquery"]');
		var objExceptionUserList = g_objSetupConfigDialog.find('textarea[name="exceptionuserlist"]');

		var postData = getRequestUserSynchronizationConfigInfoParam('<%=(String)session.getAttribute("COMPANYID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 동기화 설정 정보", "사용자 동기화 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var dbType = $(data).find('dbtype').text();
				var dbIp = $(data).find('dbip').text();
				var dbPort = $(data).find('dbport').text();
				var dbSid = $(data).find('dbsid').text();
				var dbAccountId = $(data).find('dbaccountid').text();
				var dbAccountPassword = $(data).find('dbaccountpassword').text();
				var sqlQuery = $(data).find('sqlquery').text();
				var exceptionUserList = $(data).find('exceptionuserlist').text();

				if ((dbType != null) && (dbType.length > 0)) {
					objDbType.val(dbType);
					objDbIp.val(dbIp);
					objDbPort.val(dbPort);
					objDbSid.val(dbSid);
					objDbAccountId.val(dbAccountId);
					objDbAccountPassword.val(dbAccountPassword);
					objSqlQuery.val(sqlQuery);
					objExceptionUserList.val(exceptionUserList);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 동기화 설정 정보", "사용자 동기화 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveUserSynchronizationConfig = function() {

		var objDbType = g_objSetupConfigDialog.find('select[name="dbtype"]');
		var objDbIp = g_objSetupConfigDialog.find('input[name="dbip"]');
		var objDbPort = g_objSetupConfigDialog.find('input[name="dbport"]');
		var objDbSid = g_objSetupConfigDialog.find('input[name="dbsid"]');
		var objDbAccountId = g_objSetupConfigDialog.find('input[name="dbaccountid"]');
		var objDbAccountPassword = g_objSetupConfigDialog.find('input[name="dbaccountpassword"]');
		var objSqlQuery = g_objSetupConfigDialog.find('textarea[name="sqlquery"]');
		var objExceptionUserList = g_objSetupConfigDialog.find('textarea[name="exceptionuserlist"]');

		var postData = getRequestSaveUserSynchronizationConfigParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				'<%=(String)session.getAttribute("COMPANYID")%>',
				objDbType.val(),
				objDbIp.val(),
				objDbPort.val(),
				objDbSid.val(),
				objDbAccountId.val(),
				objDbAccountPassword.val(),
				objSqlQuery.val(),
				objExceptionUserList.val()
				);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 동기화 설정 정보", "사용자 동기화 설정 정보 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}
				displayInfoDialog("사용자 동기화 설정 정보", "정상 처리되었습니다.", "정상적으로 사용자 동기화 설정 정보가 저장되었습니다.");
				g_objSetupConfigDialog.dialog('close');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 동기화 설정 정보", "사용자 동기화 설정 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateUserSynchronizationConfigData = function() {

		var objDbType = g_objSetupConfigDialog.find('select[name="dbtype"]');
		var objDbIp = g_objSetupConfigDialog.find('input[name="dbip"]');
		var objDbPort = g_objSetupConfigDialog.find('input[name="dbport"]');
		var objDbSid = g_objSetupConfigDialog.find('input[name="dbsid"]');
		var objDbAccountId = g_objSetupConfigDialog.find('input[name="dbaccountid"]');
		var objDbAccountPassword = g_objSetupConfigDialog.find('input[name="dbaccountpassword"]');
		var objSqlQuery = g_objSetupConfigDialog.find('textarea[name="sqlquery"]');
		var objValidateTips = g_objSetupConfigDialog.find('#validateTips');

		if (objDbType.val().length == 0) {
			updateTips(objValidateTips, "DB 유형을 선택해 주세요.");
			objDbType.focus();
			return false;
		}

		if (!isValidParam(objDbIp, PARAM_TYPE_IPV4_ADDRESS, "DB 주소", PARAM_IPV4_ADDRESS_MIN_LEN, PARAM_IPV4_ADDRESS_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (!isValidParam(objDbPort, PARAM_TYPE_NUMBER, "DB 포트", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objDbSid.val().length == 0) {
			updateTips(objValidateTips, "DB SID를 입력해 주세요.");
			objDbSid.focus();
			return false;
		}

		if (objDbAccountId.val().length == 0) {
			updateTips(objValidateTips, "DB 계정 아이디를 입력해 주세요.");
			objDbAccountId.focus();
			return false;
		}

		if (objDbAccountPassword.val().length == 0) {
			updateTips(objValidateTips, "DB 계정 비밀번호를 입력해 주세요.");
			objDbAccountPassword.focus();
			return false;
		}

		if (objSqlQuery.val().length == 0) {
			updateTips(objValidateTips, " 사용자 조회 Sql을 입력해 주세요.");
			objSqlQuery.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-setupconfig" title="사용자 동기화 설정" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>동기화 하고자하는 사용자 데이타 베이스 관련 정보를 설정해 주세요.</li>
				<li>"사용자 조회 Sql" 항목에는 부서코드, 부서명, 사용자ID, 사용자명, 비밀번호 항목이 반드시 필요하며(소속된 사원이 없는 부서일 경우 사용자ID, 사용자명, 비밀번호 값은 없음), 다음 예)와 같이 모든 부서 및 사용자 정보를 포함하고 있어야 한다. 각 필드는 정해진 필드명으로 Aliasing 되어있어야한다.
					<div style="margin-top:5px; margin-left:18px;font-size:11px; color:#088A85;">예) SELECT</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">부서테이블.부서코드 AS deptcode,</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">부서테이블.부서명 AS deptname,</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">사원테이블.사원ID AS userid,</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">사원테이블.사원명 AS username,</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">사원테이블.비밀번호 AS userpwd</div>
					<div style="margin-top:5px; margin-left:36px;font-size:11px; color:#088A85;">FROM</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">부서테이블</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">LEFT JOIN</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">사원테이블</div>
					<div style="margin-top:5px; margin-left:44px;font-size:11px; color:#088A85;">ON 사원테이블.부서코드 = 부서테이블.부서코드</div>
				</li>
				<li>"동기화 제외 사용자"는 동기화시 제외하고자하는 사용자 ID 값을 ';' 로 구분하여 나열해주세요.
					<div style="margin-top:5px; margin-left:18px;font-size:11px; color:#088A85;">예) user1;user2;user3;</div>
				</li>
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
			<div id="row-dbtype" class="field-line">
				<div class="field-title">DB 유형<span class="required_field">*</span></div>
				<div class="field-value"><select id="dbtype" name="dbtype" class="ui-widget-content"></select></div>
			</div>
			<div id="row-dbip" class="field-line">
				<div class="field-title">DB 주소<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="dbip" name="dbip" class="text ui-widget-content" /></div>
			</div>
			<div id="row-dbport" class="field-line">
				<div class="field-title">DB 포트<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="dbport" name="dbport" class="text ui-widget-content" /></div>
			</div>
			<div id="row-dbsid" class="field-line">
				<div class="field-title">DB SID<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="dbsid" name="dbsid" class="text ui-widget-content" /></div>
			</div>
			<div id="row-dbaccountid" class="field-line">
				<div class="field-title">DB 계정 아이디<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="dbaccountid" name="dbaccountid" class="text ui-widget-content" /></div>
			</div>
			<div id="row-dbaccountpassword" class="field-line">
				<div class="field-title">DB 계정 비밀번호<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="dbaccountpassword" name="dbaccountpassword" class="text ui-widget-content" /></div>
			</div>
			<div id="row-sqlquery" class="field-line">
				<div class="field-title">사용자 조회 Sql<span class="required_field">*</span></div>
				<div class="field-contents"><textarea id="sqlquery" name="sqlquery" class="text ui-widget-content" style='height: 160px;'></textarea></div>
			</div>
			<div id="row-exceptionuserlist" class="field-line">
				<div class="field-title">동기화 제외 사용자</div>
				<div class="field-contents"><textarea id="exceptionuserlist" name="exceptionuserlist" class="text ui-widget-content" style='height: 52px;'></textarea></div>
			</div>
		</div>
	</div>
</div>
