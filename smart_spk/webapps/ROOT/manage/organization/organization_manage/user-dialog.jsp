<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objUserDialog;

	$(document).ready(function() {
		g_objUserDialog = $('#dialog-user');

		g_objUserDialog.dialog({
			autoOpen: false,
			width: 540,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("서비스 중지")').button({
 					icons: { primary: 'ui-icon-locked' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("서비스 중지 해제")').button({
 					icons: { primary: 'ui-icon-unlocked' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("비밀번호 초기화")').button({
 					icons: { primary: 'ui-icon-key' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("수정")').button({
 					icons: { primary: 'ui-icon-wrench' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("삭제")').button({
 					icons: { primary: 'ui-icon-trash' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"등록": function() {
					if (validateUserData(MODE_INSERT)) {
						insertUser();
					}
				},
				"서비스 중지": function() {
					displayConfirmDialog("사용자 서비스 중지", "사용자 서비스를 중지하시겠습니까?", "", function() { changeUserServiceState("<%=ServiceState.SERVICE_STATE_STOP%>"); } );
				},
				"서비스 중지 해제": function() {
					displayConfirmDialog("사용자 서비스 중지 해제", "사용자 서비스 중지를 해제하시겠습니까?", "", function() { changeUserServiceState("<%=ServiceState.SERVICE_STATE_NORMAL%>"); } );
				},
				"비밀번호 초기화": function() {
					openResetUserPasswordDialog();
				},
				"수정": function() {
					if (validateUserData(MODE_UPDATE)) {
						displayConfirmDialog("사용자 정보 수정", "사용자 정보를 수정하시겠습니까?", "", function() { updateUser(); });
					}
				},
				"삭제": function() {
					displayConfirmDialog("사용자 삭제", "사용자를 삭제하시겠습니까?", "", function() { deleteUser(); });
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:text, input:password').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
				$(this).find('select').each(function() {
					$(this).val('');
				});
			}
		});

		g_objUserDialog.find('input[name="companyid"]').change( function() {
			if ($(this).val() != null) {
				if ($(this).val().length == 0) {
					fillDropdownList(g_objUserDialog.find('select[name="dept"]'), null, null, "선택");
				} else {
					var htDeptList = new Hashtable();
					htDeptList = loadDeptList($(this).val());
					fillDropdownList(g_objUserDialog.find('select[name="dept"]'), htDeptList, null, "선택");
				}
			}
		});
	});

	openNewUserDialog = function() {

		var objCompanyId = g_objUserDialog.find('input[name="companyid"]');
		var objUserId = g_objUserDialog.find('input[name="userid"]');
		var objCompanyName = g_objUserDialog.find('#companyname');
		var objDept = g_objUserDialog.find('select[name="dept"]');
		var objUserType = g_objUserDialog.find('select[name="usertype"]');

		var objRowPwd = g_objUserDialog.find('#row-pwd');
		var objRowConfirmPwd = g_objUserDialog.find('#row-confirmpwd');
		var objRowInstallStatus = g_objUserDialog.find('#row-installstatus');
		var objRowInstallDatetime = g_objUserDialog.find('#row-installdatetime');
		var objRowUninstallDatetime = g_objUserDialog.find('#row-uninstalldatetime');
		var objRowLastChangedPasswordDatetime = g_objUserDialog.find('#row-lastchangedpassworddatetime');
		var objRowLastLoginDatetime = g_objUserDialog.find('#row-lastlogindatetime');
		var objRowLastSearchDatetime = g_objUserDialog.find('#row-lastsearchdatetime');
		var objRowLastAccessIpAddress = g_objUserDialog.find('#row-lastaccessipaddress');
		var objRowServiceState = g_objUserDialog.find('#row-servicestate');
		var objRowServiceStoppedDatetime = g_objUserDialog.find('#row-servicestoppeddatetime');
		var objRowLastModifiedDatetime = g_objUserDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objUserDialog.find('#row-createdatetime');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		var companyId;
		var companyName;
		var deptCode;
		if (objTreeReference.get_selected().attr('node_type') == "company") {
			companyId = objTreeReference.get_selected().attr('companyid');
			companyName = objTreeReference.get_text(objTreeReference.get_selected());
			deptCode = "";
		} else if (objTreeReference.get_selected().attr('node_type') == "dept") {
			companyId = objTreeReference.get_selected().attr('companyid');
			var parentCompanyNode = objTreeReference._get_node('#cid_' + companyId);
			companyName = objTreeReference.get_text(parentCompanyNode);
			deptCode = objTreeReference.get_selected().attr('deptcode');
		} else {
			displayAlertDialog("기능 오류", "기능 오류입니다.", "");
		}

		objCompanyId.val(companyId);
		objUserId.attr('readonly', false);
		objUserId.removeClass('ui-priority-secondary');
		objCompanyName.text(companyName);
		var htDeptList = new Hashtable();
		htDeptList = loadDeptList(companyId);
		fillDropdownList(objDept, htDeptList, deptCode, "선택");
		fillDropdownList(objUserType, g_htUserTypeList, g_htUserTypeList.get(0), null);

		objRowPwd.show();
		objRowConfirmPwd.show();
		objRowInstallStatus.hide();
		objRowInstallDatetime.hide();
		objRowUninstallDatetime.hide();
		objRowLastChangedPasswordDatetime.hide();
		objRowLastLoginDatetime.hide();
		objRowLastSearchDatetime.hide();
		objRowLastAccessIpAddress.hide();
		objRowServiceState.hide();
		objRowServiceStoppedDatetime.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		g_objUserDialog.dialog('option', 'title', '신규 사용자');
		g_objUserDialog.dialog({height:'auto'});

		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').show();
		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지)').hide();
		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지 해제)').hide();
		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(비밀번호 초기화)').hide();
		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
		g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').hide();

		g_objUserDialog.dialog('open');
	};

	openUserInfoDialog = function(seqNo) {

		var objCompanyId = g_objUserDialog.find('input[name="companyid"]');
		var objUserId = g_objUserDialog.find('input[name="userid"]');
		var objUserName = g_objUserDialog.find('input[name="username"]');
		var objEmail = g_objUserDialog.find('input[name="email"]');
		var objPhone = g_objUserDialog.find('input[name="phone"]');
		var objMobilePhone = g_objUserDialog.find('input[name="mobilephone"]');
		var objCompanyName = g_objUserDialog.find('#companyname');
		var objDept = g_objUserDialog.find('select[name="dept"]');
		var objUserType = g_objUserDialog.find('select[name="usertype"]');
		var objInstallStatus = g_objUserDialog.find('#installstatus');
		var objInstallDatetime = g_objUserDialog.find('#installdatetime');
		var objUninstallDatetime = g_objUserDialog.find('#uninstalldatetime');
		var objLastChangedPasswordDatetime = g_objUserDialog.find('#lastchangedpassworddatetime');
		var objLastLoginDatetime = g_objUserDialog.find('#lastlogindatetime');
		var objLastSearchDatetime = g_objUserDialog.find('#lastsearchdatetime');
		var objLastAccessIpAddress = g_objUserDialog.find('#lastaccessipaddress');
		var objServiceState = g_objUserDialog.find('#servicestate');
		var objServiceStoppedDatetime = g_objUserDialog.find('#servicestoppeddatetime');
		var objLastModifiedDatetime = g_objUserDialog.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objUserDialog.find('#createdatetime');

		var objRowPwd = g_objUserDialog.find('#row-pwd');
		var objRowConfirmPwd = g_objUserDialog.find('#row-confirmpwd');
		var objRowInstallStatus = g_objUserDialog.find('#row-installstatus');
		var objRowInstallDatetime = g_objUserDialog.find('#row-installdatetime');
		var objRowUninstallDatetime = g_objUserDialog.find('#row-uninstalldatetime');
		var objRowLastChangedPasswordDatetime = g_objUserDialog.find('#row-lastchangedpassworddatetime');
		var objRowLastLoginDatetime = g_objUserDialog.find('#row-lastlogindatetime');
		var objRowLastSearchDatetime = g_objUserDialog.find('#row-lastsearchdatetime');
		var objRowLastAccessIpAddress = g_objUserDialog.find('#row-lastaccessipaddress');
		var objRowServiceState = g_objUserDialog.find('#row-servicestate');
		var objRowServiceStoppedDatetime = g_objUserDialog.find('#row-servicestoppeddatetime');
		var objRowLastModifiedDatetime = g_objUserDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objUserDialog.find('#row-createdatetime');

		var postData = getRequestUserInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 정보 조회", "사용자 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var userId = $(data).find('userid').text();
				var userName = $(data).find('username').text();
				var email = $(data).find('email').text();
				var phone = $(data).find('phone').text();
				var mobilePhone = $(data).find('mobilephone').text();
				var deptCode = $(data).find('deptcode').text();
				var userType = $(data).find('usertype').text();
				var installFlag = $(data).find('installflag').text();
				var installDatetime = $(data).find('installdatetime').text();
				var uninstallDatetime = $(data).find('uninstalldatetime').text();
				var lastChangedPasswordDatetime = $(data).find('lastchangedpassworddatetime').text();
				var lastLoginDatetime = $(data).find('lastlogindatetime').text();
				var lastSearchDatetime = $(data).find('lastsearchdatetime').text();
				var lastAccessIpAddress = $(data).find('lastaccessipaddress').text();
				var serviceStateFlag = $(data).find('servicestateflag').text();
				var serviceStoppedDatetime = $(data).find('servicestoppeddatetime').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				objCompanyId.val(companyId);
				objUserId.val(userId);
				objUserName.val(userName);
				objEmail.val(email);
				objPhone.val(phone);
				objMobilePhone.val(mobilePhone);
				objCompanyName.text(companyName);
				var htDeptList = new Hashtable();
				htDeptList = loadDeptList(companyId);
				fillDropdownList(objDept, htDeptList, deptCode, null);
				fillDropdownList(objUserType, g_htUserTypeList, userType, null);
				objInstallStatus.text(g_htInstallStateList.get(installFlag));
				objInstallDatetime.text(installDatetime);
				objUninstallDatetime.text(uninstallDatetime);
				objLastChangedPasswordDatetime.text(lastChangedPasswordDatetime);
				objLastLoginDatetime.text(lastLoginDatetime);
				objLastSearchDatetime.text(lastSearchDatetime);
				objLastAccessIpAddress.text(lastAccessIpAddress);
				objServiceState.text(g_htServiceStateList.get(serviceStateFlag));
				if (serviceStateFlag == "<%=ServiceState.SERVICE_STATE_STOP%>") {
					objServiceState.addClass("state-abnormal");
				} else {
					objServiceState.removeClass("state-abnormal");
				}
				objServiceStoppedDatetime.text(serviceStoppedDatetime);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objUserId.attr('readonly', true);
				objUserId.blur();
				objUserId.addClass('ui-priority-secondary');
				objRowPwd.hide();
				objRowConfirmPwd.hide();
				objRowInstallStatus.show();
				objRowInstallDatetime.show();
				objRowUninstallDatetime.show();
				objRowLastLoginDatetime.show();
				objRowLastLoginDatetime.show();
				objRowLastSearchDatetime.show();
				objRowLastAccessIpAddress.show();
				objRowServiceState.show();
				objRowServiceStoppedDatetime.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				g_objUserDialog.dialog('option', 'title', '사용자 정보');
				g_objUserDialog.dialog({height:'auto'});
				g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').hide();
				if (serviceStateFlag == <%=ServiceState.SERVICE_STATE_NORMAL%>) {
					g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지)').show();
					g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지 해제)').hide();
				} else {
					g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지)').hide();
					g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(서비스 중지 해제)').show();
				}
				g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(비밀번호 초기화)').show();
				g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').show();
				g_objUserDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();

		  		g_objUserDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 정보 조회", "사용자 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	insertUser = function() {

		var postData = getRequestInsertUserParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objUserDialog.find('input[name="companyid"]').val(),
			g_objUserDialog.find('input[name="userid"]').val(),
			g_objUserDialog.find('input[name="pwd"]').val(),
			g_objUserDialog.find('input[name="username"]').val(),
			g_objUserDialog.find('input[name="email"]').val(),
			g_objUserDialog.find('input[name="phone"]').val(),
			g_objUserDialog.find('input[name="mobilephone"]').val(),
			g_objUserDialog.find('select[name="dept"]').val(),
			g_objUserDialog.find('select[name="usertype"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 등록", "사용자 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					var companyId = g_objUserDialog.find('input[name="companyid"]').val();
					var deptCode = g_objUserDialog.find('select[name="dept"]').val();
					var parentNodeId;
					if (deptCode.length > 0) {
						parentNodeId = 'dept_' + companyId + "_" + deptCode;
					} else {
						parentNodeId = 'cid_' + companyId;
					}
					if (selectedNode.attr('id') != parentNodeId) {
						objTreeReference.deselect_node(selectedNode);
						if (objTreeReference._get_node('#' + parentNodeId).length) {
							objTreeReference.select_node('#' + parentNodeId);
						} else {
							objTreeReference.select_node('#cid_' + companyId);
						}
					} else {
						objTreeReference.deselect_node(selectedNode);
						g_selectedTreeNode = null;
						objTreeReference.select_node(selectedNode);
					}
					displayInfoDialog("사용자 등록", "정상 처리되었습니다.", "정상적으로 사용자가 등록되었습니다.");
					g_objUserDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 등록", "사용자 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateUser = function() {

		var postData = getRequestUpdateUserParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objUserDialog.find('input[name="companyid"]').val(),
			g_objUserDialog.find('input[name="userid"]').val(),
			g_objUserDialog.find('input[name="username"]').val(),
			g_objUserDialog.find('input[name="email"]').val(),
			g_objUserDialog.find('input[name="phone"]').val(),
			g_objUserDialog.find('input[name="mobilephone"]').val(),
			g_objUserDialog.find('select[name="dept"]').val(),
			g_objUserDialog.find('select[name="usertype"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 정보 변경", "사용자 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					objTreeReference.deselect_node(selectedNode);
					g_selectedTreeNode = null;
					objTreeReference.select_node(selectedNode);
					displayInfoDialog("사용자 정보 변경", "정상 처리되었습니다.", "정상적으로 사용자 정보가 변경되었습니다.");
					g_objUserDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 정보 변경", "사용자 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	changeUserServiceState = function(serviceState) {

		var postData = getRequestChangeUserServiceStateParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objUserDialog.find('input[name="companyid"]').val(),
			g_objUserDialog.find('input[name="userid"]').val(),
			serviceState);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 서비스 상태 변경", "사용자 서비스 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					objTreeReference.deselect_node(selectedNode);
					g_selectedTreeNode = null;
					objTreeReference.select_node(selectedNode);
					displayInfoDialog("사용자 서비스 상태 변경", "정상 처리되었습니다.", "정상적으로 사용자 서비스 상태가 변경되었습니다.");
					g_objUserDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 서비스 상태 변경", "사용자 서비스 상태 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteUser = function() {

		var postData = getRequestDeleteUserParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objUserDialog.find('input[name="companyid"]').val(),
			g_objUserDialog.find('input[name="userid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 삭제", "사용자 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					objTreeReference.deselect_node(selectedNode);
					g_selectedTreeNode = null;
					objTreeReference.select_node(selectedNode);
					displayInfoDialog("사용자 삭제", "정상 처리되었습니다.", "정상적으로 사용자가 삭제되었습니다.");
					g_objUserDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 삭제", "사용자 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateUserData = function(mode) {

		var objUserId = g_objUserDialog.find('input[name="userid"]');
		var objPwd = g_objUserDialog.find('input[name="pwd"]');
		var objConfirmPwd = g_objUserDialog.find('input[name="confirmpwd"]');
		var objUserName = g_objUserDialog.find('input[name="username"]');
		var objEmail = g_objUserDialog.find('input[name="email"]');
		var objPhone = g_objUserDialog.find('input[name="phone"]');
		var objMobilePhone = g_objUserDialog.find('input[name="mobilephone"]');
		var objDept = g_objUserDialog.find('select[name="dept"]');
		var objUserType = g_objUserDialog.find('select[name="usertype"]');
		var objValidateTips = g_objUserDialog.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (!isValidParam(objUserId, PARAM_TYPE_ID, "사용자 ID", PARAM_ID_MIN_LEN, PARAM_ID_MAX_LEN, objValidateTips)) {
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
			} else {
				if (objPwd.hasClass('ui-state-error'))
					objPwd.removeClass('ui-state-error');
				if (objConfirmPwd.hasClass('ui-state-error'))
					objConfirmPwd.removeClass('ui-state-error');
			}
		}

		if (!isValidParam(objUserName, PARAM_TYPE_NAME, "사용자 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
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

		if (objDept.val().length == 0) {
			updateTips(objValidateTips, "소속 부서를 선택해 주세요.");
			objDept.focus();
			return false;
		}

		if (objUserType.val().length == 0) {
			updateTips(objValidateTips, "사용자 유형을 선택해 주세요.");
			objUserType.focus();
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-user" title="" class="dialog-form">
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
			<input type="hidden" id="companyid" name="companyid" />
			<div id="row-userid" class="field-line">
				<div class="field-title">사용자 ID<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="userid" name="userid" class="text ui-widget-content" /></div>
			</div>
			<div id="row-pwd" class="field-line">
				<div class="field-title">비밀번호<span class="required_field">*</span></div>
				<div class="field-value"><input type="password" id="pwd" name="pwd" value="" class="text ui-widget-content" /></div>
			</div>
			<div id="row-confirmpwd" class="field-line">
				<div class="field-title">비밀번호 확인<span class="required_field">*</span></div>
				<div class="field-value"><input type="password" id="confirmpwd" name="confirmpwd" value="" class="text ui-widget-content" /></div>
			</div>
			<div id="row-username" class="field-line">
				<div class="field-title">사용자 명<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="username" name="username" class="text ui-widget-content" /></div>
			</div>
			<div id="row-email" class="field-line" style="display: none;">
				<div class="field-title">이메일</div>
				<div class="field-value"><input type="text" id="email" name="email" class="text ui-widget-content" /></div>
			</div>
			<div id="row-phone" class="field-line" style="display: none;">
				<div class="field-title">전화번호</div>
				<div class="field-value"><input type="text" id="phone" name="phone" class="text ui-widget-content" /></div>
			</div>
			<div id="row-mobilephone" class="field-line" style="display: none;">
				<div class="field-title">휴대전화번호</div>
				<div class="field-value"><input type="text" id="mobilephone" name="mobilephone" class="text ui-widget-content" /></div>
			</div>
			<div id="row-companyname" class="field-line">
				<div class="field-title">사업장</div>
				<div class="field-value"><span id="companyname"></span></div>
			</div>
			<div id="row-dept" class="field-line">
				<div class="field-title">소속 부서<span class="required_field">*</span></div>
				<div class="field-value"><select id="dept" name="dept" class="ui-widget-content"></select></div>
			</div>
			<div id="row-usertype" class="field-line">
				<div class="field-title">사용자 유형<span class="required_field">*</span></div>
				<div class="field-value"><select id="usertype" name="usertype" class="ui-widget-content"></select></div>
			</div>
			<div id="row-installstatus" class="field-line">
				<div class="field-title">설치 상태</div>
				<div class="field-value"><span id="installstatus"></span></div>
			</div>
			<div id="row-installdatetime" class="field-line">
				<div class="field-title">최종 설치 일시</div>
				<div class="field-value"><span id="installdatetime"></span></div>
			</div>
			<div id="row-uninstalldatetime" class="field-line">
				<div class="field-title">최종 제거 일시</div>
				<div class="field-value"><span id="uninstalldatetime"></span></div>
			</div>
			<div id="row-lastchangedpassworddatetime" class="field-line">
				<div class="field-title">최종 비밀번호 변경 일시</div>
				<div class="field-value"><span id="lastchangedpassworddatetime"></span></div>
			</div>
			<div id="row-lastlogindatetime" class="field-line">
				<div class="field-title">최종 접속 일시</div>
				<div class="field-value"><span id="lastlogindatetime"></span></div>
			</div>
			<div id="row-lastsearchdatetime" class="field-line">
				<div class="field-title">최종 검사 일시</div>
				<div class="field-value"><span id="lastsearchdatetime"></span></div>
			</div>
			<div id="row-lastaccessipaddress" class="field-line">
				<div class="field-title">최종 접속 주소</div>
				<div class="field-value"><span id="lastaccessipaddress"></span></div>
			</div>
			<div id="row-servicestate" class="field-line">
				<div class="field-title">서비스 상태</div>
				<div class="field-value"><span id="servicestate"></span></div>
			</div>
			<div id="row-servicestoppeddatetime" class="field-line">
				<div class="field-title">서비스 중지 일시</div>
				<div class="field-value"><span id="servicestoppeddatetime"></span></div>
			</div>
			<div id="row-lastmodifieddatetime" class="field-line">
				<div class="field-title">최종 변경 일시</div>
				<div class="field-value"><span id="lastmodifieddatetime"></span></div>
			</div>
			<div id="row-createdatetime" class="field-line">
				<div class="field-title">등록 일시</div>
				<div class="field-value"><span id="createdatetime"></span></div>
			</div>
		</div>
	</div>
</div>
