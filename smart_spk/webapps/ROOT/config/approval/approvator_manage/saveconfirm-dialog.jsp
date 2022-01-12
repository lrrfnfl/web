<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
	var g_objSaveConfirmDialog;

	$(document).ready(function() {
		g_objSaveConfirmDialog = $('#dialog-saveconfirm');
	});

	openSaveConfirmDialog = function(dialogTitle, confirmMessage) {
		g_objSaveConfirmDialog.dialog({
			autoOpen: false,
			resizable: false,
			width: 500,
			height: 'auto',
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();

				$('#div-savecompany').hide();
				$('#div-savealldepts').hide();
				$('#div-saveallusers').hide();

				g_objOrganizationTree.find(".jstree-checked").each(function(i, element) {
					if ($(element).attr('node_type') == "company") {
		 				$('input:checkbox[name="checksavecompany"]').prop('checked', true);
						$('#div-savecompany').show();
					} else if ($(element).attr('node_type') == "dept") {
		 				$('input:checkbox[name="checksavealldepts"]').prop('checked', true);
						$('#div-savealldepts').show();
					} else if ($(element).attr('node_type') == "user") {
		 				$('input:checkbox[name="checksaveallusers"]').prop('checked', true);
						$('#div-saveallusers').show();
					}
				});
			},
			buttons: {
				"확인": function() {
					if (typeof saveDecodingApprobator === "function") {
						saveDecodingApprobator($('input:checkbox[name="checksavecompany"]').is(':checked'),
								$('input:checkbox[name="checksavealldepts"]').is(':checked'),
								$('input:checkbox[name="checksaveallusers"]').is(':checked'));
					}
					$(this).dialog('close');
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('input:checkbox').each(function() {
					$(this).prop('checked', false);
				});
			}
		});

		g_objSaveConfirmDialog.find('#saveconfirm-message').html(confirmMessage);
		g_objSaveConfirmDialog.dialog('option', 'title', dialogTitle);
		g_objSaveConfirmDialog.dialog('open');
	}
</script>

<div id="dialog-saveconfirm" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="icon-message-holder">
			<div class="icon-holder"><span class="ui-icon ui-icon-circle-check"></span></div>
			<div class="message-holder">
				<div class="icon-message"><strong><span id="saveconfirm-message"></span></strong></div>
			</div>
		</div>
		<div class="clear"></div>
		<div style="margin: 10px 0 0 20px;">
			<div style="margin: 8px 0;">설정 정보 저장 대상 선택:</div>
			<div id="div-savecompany" class="field-line"><label class="checkbox"><input type="checkbox" name="checksavecompany" onFocus="this.blur()">선택한 사업장</label></div>
			<div id="div-savealldepts" class="field-line"><label class="checkbox"><input type="checkbox" name="checksavealldepts" onFocus="this.blur()">선택한 모든 부서</label></div>
			<div id="div-saveallusers" class="field-line"><label class="checkbox"><input type="checkbox" name="checksaveallusers" onFocus="this.blur()">선택한 모든 사용자</label></div>
		</div>
	</div>
</div>
