<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objDeptDialog;

	$(document).ready(function() {
		g_objDeptDialog = $('#dialog-dept');

		g_objDeptDialog.dialog({
			autoOpen: false,
			width: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
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
					if (validateDeptData(MODE_INSERT)) {
						insertDept();
					}
				},
				"수정": function() {
					if (validateDeptData(MODE_UPDATE)) {
						displayConfirmDialog("부서 정보 수정", "부서 정보를 수정하시겠습니까?", "", function() { updateDept(); });
					}
				},
				"삭제": function() {
					displayConfirmDialog("부서 삭제", "부서를 삭제하시겠습니까?", "", function() { deleteDept(); });
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:text').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
				$(this).find('select').each(function() {
					$(this).val('');
				});
			}
		});
	});

	openNewDeptDialog = function() {

		var objCompanyId = g_objDeptDialog.find('input[name="companyid"]');
		var objCompanyName = g_objDeptDialog.find('#companyname');
		var objDeptCode = g_objDeptDialog.find('input[name="deptcode"]');
		var objDeptName = g_objDeptDialog.find('input[name="deptname"]');
		var objParentDept = g_objDeptDialog.find('select[name="parentdept"]');
		var objDeptCodeAutoCreateMessage = g_objDeptDialog.find('#deptcodeautocreatemessage');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		var companyId;
		var companyName;
		var parentDeptCode;
		var autoCreateDeptCode;
		if (objTreeReference.get_selected().attr('node_type') == "company") {
			companyId = objTreeReference.get_selected().attr('companyid');
			companyName = objTreeReference.get_text(objTreeReference.get_selected());
			parentDeptCode = "";
			autoCreateDeptCode = objTreeReference.get_selected().attr('autocreatedeptcode');
		} else if (objTreeReference.get_selected().attr('node_type') == "dept") {
			companyId = objTreeReference.get_selected().attr('companyid');
			var parentCompanyNode = $.jstree._reference(g_objOrganizationTree)._get_node('#cid_' + companyId);
			companyName = objTreeReference.get_text(parentCompanyNode);
			parentDeptCode = objTreeReference.get_selected().attr('deptcode');
			autoCreateDeptCode = parentCompanyNode.attr('autocreatedeptcode');
		} else {
			displayAlertDialog("기능 오류", "기능 오류입니다.", "");
		}

		objCompanyId.val(companyId);
		objCompanyName.text(companyName);
		objDeptCode.val('');
		if (autoCreateDeptCode == '<%=OptionType.OPTION_TYPE_YES%>') {
			objDeptCode.attr('disabled', true);
			objDeptCodeAutoCreateMessage.text('부서코드는 자동으로 생성됩니다.');
			objDeptCodeAutoCreateMessage.closest('li').show()
		} else {
			objDeptCode.attr('disabled', false);
			objDeptCodeAutoCreateMessage.closest('li').hide()
		}
		objDeptName.val('');
		var htDeptList = new Hashtable();
		htDeptList = loadDeptList(companyId);
		fillDropdownList(objParentDept, htDeptList, parentDeptCode, "없음");

		g_objDeptDialog.dialog('option', 'title', '신규 부서');
		g_objDeptDialog.dialog({height:'auto'});

		g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').show();
		g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
		g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').hide();

  		g_objDeptDialog.dialog('open');
	};

	openDeptInfoDialog = function() {

		var objCompanyId = g_objDeptDialog.find('input[name="companyid"]');
		var objCompanyName = g_objDeptDialog.find('#companyname');
		var objDeptCode = g_objDeptDialog.find('input[name="deptcode"]');
		var objDeptName = g_objDeptDialog.find('input[name="deptname"]');
		var objParentDept = g_objDeptDialog.find('select[name="parentdept"]');
		var objDeptCodeAutoCreateMessage = g_objDeptDialog.find('#deptcodeautocreatemessage');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);

		var companyId;
		var companyName;
		var deptCode;
		if (objTreeReference.get_selected().attr('node_type') == "dept") {
			companyId = objTreeReference.get_selected().attr('companyid');
			var parentCompanyNode = objTreeReference._get_node('#cid_' + companyId);
			companyName = objTreeReference.get_text(parentCompanyNode);
			deptCode = objTreeReference.get_selected().attr('deptcode');
		} else {
			displayAlertDialog("기능 오류", "기능 오류입니다.", "");
		}

		var postData = getRequestDeptInfoParam(companyId, deptCode);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 정보 조회", "부서 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var deptName = $(data).find('deptname').text();
				var parentDeptCode = $(data).find('parentdeptcode').text();

				objCompanyId.val(companyId);
				objCompanyName.text(companyName);
				objDeptCode.val(deptCode);
				objDeptCode.attr('disabled', true);
				objDeptCode.addClass('ui-priority-secondary');
				objDeptCode.blur();
				objDeptCodeAutoCreateMessage.closest('li').hide()
				objDeptName.val(deptName);
				var htDeptList = new Hashtable();
				htDeptList = loadDeptList(companyId);
				fillDropdownList(objParentDept, htDeptList, parentDeptCode, "없음");
				objParentDept.find('[value="' + deptCode + '"]').remove();

				g_objDeptDialog.dialog('option', 'title', '부서 정보');
				g_objDeptDialog.dialog({height:'auto'});

				g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').hide();
				g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').show();
				g_objDeptDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();

				g_objDeptDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 정보 조회", "부서 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	insertDept = function() {

		var postData = getRequestInsertDeptParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objDeptDialog.find('input[name="companyid"]').val(),
				g_objDeptDialog.find('input[name="deptcode"]').val(),
				g_objDeptDialog.find('input[name="deptname"]').val(),
				g_objDeptDialog.find('select[name=parentdept]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 등록", "부서 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var companyId = g_objDeptDialog.find('input[name="companyid"]').val();
					var parentDeptCode = g_objDeptDialog.find('select[name=parentdept]').val();
					var parentNodeId;
					if (parentDeptCode.length > 0) {
						parentNodeId = 'dept_' + companyId + "_" + parentDeptCode;
					} else {
						parentNodeId = 'cid_' + companyId;
					}
					if (objTreeReference._get_node('#' + parentNodeId).length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh('#' + parentNodeId);
						objTreeReference.select_node('#' + parentNodeId);
						if (objTreeReference._get_node('#' + parentNodeId).hasClass('jstree-leaf')) {
							objTreeReference._get_node('#' + parentNodeId).removeClass('jstree-leaf')
							objTreeReference._get_node('#' + parentNodeId).addClass('jstree-open');
						}
					}
					displayInfoDialog("부서 등록", "정상적으로 부서가 등록되었습니다.", "");
					g_objDeptDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 등록", "부서 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateDept = function() {

		var postData = getRequestUpdateDeptParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objDeptDialog.find('input[name="companyid"]').val(),
				g_objDeptDialog.find('input[name="deptcode"]').val(),
				g_objDeptDialog.find('input[name="deptname"]').val(),
				g_objDeptDialog.find('select[name=parentdept]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 정보 수정", "부서 정보 수정 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var companyId = g_objDeptDialog.find('input[name="companyid"]').val();
					var parentDeptCode = g_objDeptDialog.find('select[name=parentdept]').val();
					var parentNodeId;
					if (parentDeptCode.length > 0) {
						parentNodeId = 'dept_' + companyId + "_" + parentDeptCode;
					} else {
						parentNodeId = 'cid_' + companyId;
					}
					objTreeReference.refresh(objTreeReference._get_parent(objTreeReference.get_selected()));
					if (objTreeReference._get_node('#' + parentNodeId).length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh('#' + parentNodeId);
						objTreeReference.select_node('#' + parentNodeId);
						if (objTreeReference._get_node('#' + parentNodeId).hasClass('jstree-leaf')) {
							objTreeReference._get_node('#' + parentNodeId).removeClass('jstree-leaf')
							objTreeReference._get_node('#' + parentNodeId).addClass('jstree-open');
						}
					}
					displayInfoDialog("부서 정보 수정", "정상적으로 부서 정보가 수정되었습니다.", "");
					g_objDeptDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 정보 수정", "부서 정보 수정 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteDept = function() {

		var postData = getRequestDeleteDeptParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objDeptDialog.find('input[name="companyid"]').val(),
				g_objDeptDialog.find('input[name="deptcode"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 삭제", "부서 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var companyId = g_objDeptDialog.find('input[name="companyid"]').val();
					var parentDeptCode = g_objDeptDialog.find('select[name=parentdept]').val();
					var parentNodeId;
					if (parentDeptCode.length > 0) {
						parentNodeId = 'dept_' + companyId + "_" + parentDeptCode;
					} else {
						parentNodeId = 'cid_' + companyId;
					}
					if (objTreeReference._get_node('#' + parentNodeId).length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh('#' + parentNodeId);
						objTreeReference.select_node('#' + parentNodeId);
					}
					displayInfoDialog("부서 삭제", "정상적으로 부서가 삭제되었습니다.", "");
					g_objDeptDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 삭제", "부서 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateDeptData = function(mode) {

		var objDeptCode = g_objDeptDialog.find('input[name="deptcode"]');
		var objDeptName = g_objDeptDialog.find('input[name="deptname"]');
		var objValidateTips = g_objDeptDialog.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (objDeptCode.val().length > 0) {
				if (!isValidParam(objDeptCode, PARAM_TYPE_DEPT_CODE, "부서 코드", PARAM_DEPT_CODE_MIN_LEN, PARAM_DEPT_CODE_MAX_LEN, objValidateTips)) {
					return false;
				}
			}
		}

		if (!isValidParam(objDeptName, PARAM_TYPE_NAME, "부서 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-dept" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
				<li>부서명은 구분 가능하도록 중복되지 않게 입력해 주세요.</li>
				<li><span id="deptcodeautocreatemessage"></span></li>
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
			<div id="row-companyname" class="field-line">
				<div class="field-title">사업장</div>
				<div class="field-value"><span id="companyname"></span></div>
			</div>
			<div id="row-deptcode" class="field-line">
				<div class="field-title">부서 코드</div>
				<div class="field-value"><input type="text" id="deptcode" name="deptcode" class="text ui-widget-content" /></div>
			</div>
			<div id="row-deptname" class="field-line">
				<div class="field-title">부서 명<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="deptname" name="deptname" class="text ui-widget-content" /></div>
			</div>
			<div id="row-parentdept" class="field-line">
				<div class="field-title">상위 부서<span class="required_field">*</span></div>
				<div class="field-value"><select id="parentdept" name="parentdept" class="ui-widget-content"></select></div>
			</div>
		</div>
	</div>
</div>
