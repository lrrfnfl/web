<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objReservedWordInfoDialog;

	$(document).ready(function() {
		g_objReservedWordInfoDialog = $('#dialog-reservedwordinfo');
	});

	openReservedWordInfoDialog = function() {
		g_objReservedWordInfoDialog.dialog({
			autoOpen: false,
			width: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			//modal: true,
			open: function() {
				//$(".ui-dialog-titlebar-close").hide();
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
			}
		});

		g_objReservedWordInfoDialog.dialog('open');
	};
</script>

<div id="dialog-reservedwordinfo" title="예약어 정보" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<div style="margin-bottom: 20px;">아래의 예약어를 사용할 경우, 해당 예약어는 자동으로 해당 값으로 변환되며, 그 외의 문자열은 그대로 출력됩니다.</div>
			<ul class="infolist">
				<li>[DEPTNAME]: 부서 이름</li>
				<li>[USERSERIAL]: 사용자 ID</li>
				<li>[USERNAME]: 사용자 이름</li>
				<li>[COMNAME]: 컴퓨터 이름</li>
				<li>[IP]: 출력하는 컴퓨터의 IP주소</li>
				<li>[PRINTTIME]: 출력 시간</li>
			</ul>
		</div>
	</div>
</div>

