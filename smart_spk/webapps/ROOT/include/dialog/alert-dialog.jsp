<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objAlertDialog;

	$(document).ready(function() {
		g_objAlertDialog = $('#dialog-alert');

		g_objAlertDialog.dialog({
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
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			}
		});
	});

	displayInfoDialog = function(dialogTitle, infoTitle, infoMessage) {

		if (g_objAlertDialog.find('#alert-div').hasClass('ui-state-error')) {
			g_objAlertDialog.find('#alert-div').removeClass('ui-state-error').addClass('ui-state-highlight');
		}

		if (g_objAlertDialog.find('#alert-icon').hasClass('ui-icon-alert')) {
			g_objAlertDialog.find('#alert-icon').removeClass('ui-icon-alert').addClass('ui-icon-info');
		}

		g_objAlertDialog.find('#alert-title').html(infoTitle);
		g_objAlertDialog.find('#alert-message').html(infoMessage);

		g_objAlertDialog.dialog('option', 'title', dialogTitle);
		g_objAlertDialog.dialog('open');
	}

	displayAlertDialog = function(dialogTitle, alertTitle, alertMessage) {

		if (g_objAlertDialog.find('#alert-div').hasClass('ui-state-highlight')) {
			g_objAlertDialog.find('#alert-div').removeClass('ui-state-highlight').addClass('ui-state-error');
		}

		if (g_objAlertDialog.find('#alert-icon').hasClass('ui-icon-info')) {
			g_objAlertDialog.find('#alert-icon').removeClass('ui-icon-info').addClass('ui-icon-alert');
		}

		g_objAlertDialog.find('#alert-title').html(alertTitle);
		g_objAlertDialog.find('#alert-message').html(alertMessage);

		g_objAlertDialog.dialog('option', 'title', dialogTitle);
		g_objAlertDialog.dialog('open');
	}
</script>

<div id="dialog-alert" title="" class="dialog-form">
	<div id="alert-div" class="ui-state-highlight" style="padding: 10px 10px 5px 10px;">
		<div class="icon-message-holder">
			<div class="icon-holder"><span id="alert-icon" class="ui-icon ui-icon-info"></span></div>
			<div class="message-holder">
				<div class="icon-message"><strong><span id="alert-title"></span></strong></div>
				<div class="detail-message"><span id="alert-message"></span></div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
</div>

