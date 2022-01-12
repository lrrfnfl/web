<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
	var g_objSaveConfigConfirmDialog;

	$(document).ready(function() {
		g_objSaveConfigConfirmDialog = $('#dialog-saveconfigconfirm');
	});

	openSaveConfigConfirmDialog = function(dialogTitle, confirmMessage) {

		g_objSaveConfigConfirmDialog.dialog({
			autoOpen: false,
			width: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
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
				$(this).parent().focus();

				$('#div-saveallcompanys').hide();
				$('#div-savealldepts').hide();
				$('#div-saveallusers').hide();

				g_objOrganizationTree.find(".jstree-checked").each(function(i, node) {
					if ($(node).attr('node_type') == "company") {
		 				$('input:checkbox[name="checksaveallcompanys"]').prop('checked', true);
						$('#div-saveallcompanys').show();
					} else if ($(node).attr('node_type') == "dept") {
		 				$('input:checkbox[name="checksavealldepts"]').prop('checked', true);
						$('#div-savealldepts').show();
					} else if ($(node).attr('node_type') == "user") {
		 				$('input:checkbox[name="checksaveallusers"]').prop('checked', true);
						$('#div-saveallusers').show();
					}
				});
			},
			buttons: {
				"확인": function() {
					if (typeof saveConfig === "function") {
						saveConfig($('input:checkbox[name="checksaveallcompanys"]').is(':checked'),
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

		g_objSaveConfigConfirmDialog.find('#saveconfigconfirm-message').html(confirmMessage);
		g_objSaveConfigConfirmDialog.dialog('option', 'title', dialogTitle);
		g_objSaveConfigConfirmDialog.dialog('open');
	}
</script>

<div id="dialog-saveconfigconfirm" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="icon-message-holder">
			<div class="icon-holder"><span class="ui-icon ui-icon-circle-check"></span></div>
			<div class="message-holder">
				<div class="icon-message"><strong><span id="saveconfigconfirm-message"></span></strong></div>
			</div>
		</div>
		<div class="clear"></div>
		<div style="margin: 10px 0 0 20px;">
			<div style="margin: 8px 0;">설정 정보 저장 대상 선택:</div>
			<div id="div-saveallcompanys" class="field-line"><label class="checkbox"><input type="checkbox" name="checksaveallcompanys" onFocus="this.blur()">선택한 <% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>모든 <% } %>사업장</label></div>
			<div id="div-savealldepts" class="field-line"><label class="checkbox"><input type="checkbox" name="checksavealldepts" onFocus="this.blur()">선택한 모든 부서</label></div>
			<div id="div-saveallusers" class="field-line"><label class="checkbox"><input type="checkbox" name="checksaveallusers" onFocus="this.blur()">선택한 모든 사용자</label></div>
		</div>
	</div>
</div>
