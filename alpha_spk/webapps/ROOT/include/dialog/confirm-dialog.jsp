<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objConfirmDialog;

	$(document).ready(function() {
		g_objConfirmDialog = $('#dialog-confirm');
	});

	displayConfirmDialog = function(dialogTitle, confirmTitle, confirmMessage, funcToExec) {
		g_objConfirmDialog.dialog({
			autoOpen: false,
			resizable: false,
			width: 500,
			height: 'auto',
			closeOnEscape: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
			},
			buttons: {
				"확인": function() {
					funcToExec();
					$(this).dialog('close');
				},
				"취소": function() {
					$(this).dialog('close');
				}
			}
		});

		g_objConfirmDialog.find('#confirm-title').html(confirmTitle);
		g_objConfirmDialog.find('#confirm-message').html(confirmMessage);
		g_objConfirmDialog.dialog('option', 'title', dialogTitle);

		g_objConfirmDialog.dialog('open');
	}
</script>

<div id="dialog-confirm" title="" class="dialog-form">
	<div style="padding: 10px 10px 5px 10px;">
		<div class="icon-message-holder">
			<div class="icon-holder"><span id="alert-icon" class="ui-icon ui-icon-circle-check"></span></div>
			<div class="message-holder">
				<div class="icon-message"><strong><span id="confirm-title"></span></strong></div>
				<div class="detail-message"><span id="confirm-message"></span></div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
</div>
