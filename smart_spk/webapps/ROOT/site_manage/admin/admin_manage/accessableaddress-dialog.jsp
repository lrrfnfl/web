<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objAccessableAddressDialog;

	$(document).ready(function() {
		g_objAccessableAddressDialog = $('#dialog-accessableaddress');

		$('button[name="btnAddAddress"]').button({ icons: {primary: "ui-icon-plus"} });
		$('button[name="btnDeleteAddress"]').button({ icons: {primary: "ui-icon-close"} });

		$('button').click( function () {
			if ($(this).attr('id') == 'btnAddAddress') {
				addAccessableAddressToList(g_objAccessableAddressDialog.find('input[name="newaccessableaddress"]').val());
			} else if ($(this).attr('id') == 'btnDeleteAddress') {
				deleteAccessableAddressFromList();
			}
		});

		g_objAccessableAddressDialog.find('select[name="accessableaddresstype"]').change( function() {
			if ($('option:selected', this).val() == '<%=AccessableAddressType.ACCESSABLE_ADDRESS_TYPE_ALL%>') {
				g_objAccessableAddressDialog.find('#row-accessableaddress').hide();
			} else {
				g_objAccessableAddressDialog.find('#row-accessableaddress').show();
			}
		});

		$(document).on("click", ".list-table thead tr th:first-child", function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });	
		$(document).on("click", ".list-table tbody tr", function(e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; });
	});

	openAccessableAddressDialog = function() {

		var postData = getRequestAdminAccessableAddressInfoParam(g_objAdminInfo.find('input[name="adminid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 접속주소 제한 정보", "관리자 접속주소 제한 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var accessableAddressType = $(data).find('accessableaddresstype').text();

				g_objAccessableAddressDialog.find('#adminid').text(g_objAdminInfo.find('input[name="adminid"]').val());
				g_objAccessableAddressDialog.find('#adminname').text(g_objAdminInfo.find('input[name="adminname"]').val());
				fillDropdownList(g_objAccessableAddressDialog.find('select[name="accessableaddresstype"]'), g_htAccessableAddressTypeList, accessableAddressType, null);

				g_objAccessableAddressDialog.find('#accessableaddresslist').html('');
				$(data).find('accessableaddress').each( function(index, item) {
					addAccessableAddressToList($(item).text())
				});

				if (accessableAddressType == '<%=AccessableAddressType.ACCESSABLE_ADDRESS_TYPE_LIMITED%>') {
					g_objAccessableAddressDialog.find('#row-accessableaddress').show();
				} else {
					g_objAccessableAddressDialog.find('#row-accessableaddress').hide();
				}

				g_objAccessableAddressDialog.dialog({
					autoOpen: false,
					width: 540,
					maxWidth: $(document).width(),
					height: 'auto',
					maxHeight: $(document).height(),
					resizable: false,
					modal: true,
					open: function() {
						$(this).parent().find('.ui-dialog-buttonpane button:contains("적용")').button({
							icons: { primary: 'ui-icon-disk' }
						});
						$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
							icons: { primary: 'ui-icon-circle-close' }
						});
						$(this).parent().find(".ui-dialog-titlebar-close").hide();
						$(this).parent().focus();
					},
					buttons: {
						"적용": function() {
							if (validateAccessableAddressData()) {
								displayConfirmDialog("관리자 접속주소 관리", "설정내용을 적용하시겠습니까?", "", function() { applyAccessableAddress(); });
							}
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
					}
				});

		  		g_objAccessableAddressDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 접속주소 제한 정보", "관리자 접속주소 제한 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	applyAccessableAddress = function() {

		var objAccessableAddressList = g_objAccessableAddressDialog.find('#accessableaddresslist');

		var arrayAccessableAddressList = new Array();
		g_objAccessableAddressDialog.find('#accessableaddresslist').find('.list-table > tbody > tr').find('input:checkbox:first').each( function (index, item) {
			arrayAccessableAddressList.push($(item).attr('accessableaddress'));
		});

		var postData = getRequestApplyAdminAccessableAddressParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objAccessableAddressDialog.find('#adminid').text(),
				g_objAccessableAddressDialog.find('select[name="accessableaddresstype"]').val(),
				arrayAccessableAddressList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 접속주소 제한 설정 적용", "관리자 접속주소 제한 설정 적용 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("관리자 접속주소 제한 설정 적용", "정상 처리되었습니다.", "정상적으로 관리자의 접속주소 제한 설정이 적용되었습니다.");
					g_objAdminInfo.find('#accessableaddresstype').text(g_htAccessableAddressTypeList.get(g_objAccessableAddressDialog.find('select[name="accessableaddresstype"]').val()));
					g_objAccessableAddressDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 접속주소 제한 설정 적용", "관리자 접속주소 제한 설정 적용 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateAccessableAddressData = function() {
		var objAccessableAddressList = g_objAccessableAddressDialog.find('#accessableaddresslist');
		var objValidateTips = g_objAccessableAddressDialog.find('#validateTips');

		if (g_objAccessableAddressDialog.find('select[name="accessableaddresstype"]').val() == <%=AccessableAddressType.ACCESSABLE_ADDRESS_TYPE_LIMITED%>) {
			if (objAccessableAddressList.find('.list-table > tbody > tr').length == 0) {
 				updateTips(objValidateTips, "접속 가능 주소를 추가해 주세요.");
				return false;
			}
		}
		return true;
	};

	addAccessableAddressToList = function(newAddress) {

		var objAccessableAddressList = g_objAccessableAddressDialog.find('#accessableaddresslist');

		if (newAddress.length == 0) {
			return false;
		}

		if (newAddress == '') {
			displayAlertDialog("관리자 접속주소 관리", "추가할 주소를 입력해 주세요.");
			return false;
		} else {
			var objResultMessage = new resultMessage();
			if (!checkParam(PARAM_TYPE_IPV4_ADDRESS, "추가할 주소", newAddress, objResultMessage)) {
				displayAlertDialog("관리자 접속주소 관리", objResultMessage.message, "");
				return false;
			}
		}

		if (objAccessableAddressList.find('.list-table > tbody > tr').length >= <%=(String) session.getAttribute("ADMINACCESSABLEADDRESSMAXCOUNT")%>) {
			displayAlertDialog("관리자 접속주소 관리", "관리자가 관리자 페이지에 접근할 수 있는 주소는 최대 <%=(String) session.getAttribute("ADMINACCESSABLEADDRESSMAXCOUNT")%>개 까지 등록할 수 있습니다.");
			return false;
		}

		var isAlready = false;
		if (objAccessableAddressList.find('.list-table > tbody > tr').length != 0) {
			objAccessableAddressList.find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(1)').text().trim() == newAddress.trim()) {
					displayAlertDialog("관리자 접속주소 관리", "이미 추가한 주소입니다.", "");
					isAlready = true;
					return false;
				}
			});
		} else {
			var tableHtml = '';
			tableHtml += '<table class="list-table">';
			tableHtml += '<thead>';
			tableHtml += '<tr>';
			tableHtml += '<th width="40" class="ui-state-default" style="text-align: center;">';
			tableHtml += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur();">';
			tableHtml += '</th>';
			tableHtml += '<th class="ui-state-default">접속 가능 주소</th>';
			tableHtml += '</tr>';
			tableHtml += '</thead>';
			tableHtml += '<tbody>';
			tableHtml += '</tbody>';
			tableHtml += '</table>';
			objAccessableAddressList.html(tableHtml);
		}

		if (!isAlready) {
			var newRow = '';
			newRow += '<tr>';
			newRow += '<td style="text-align: center;"><input type="checkbox" name="selectaddress" accessableaddress="' + newAddress.trim() + '" style="border: 0;"></td>';
			newRow += '<td style="text-align: left;">' + newAddress.trim() + '</td>';
			newRow += '</tr>';

			objAccessableAddressList.find('tbody').append(newRow);
			refreshSelectedListTable(objAccessableAddressList);
		}
	};

	deleteAccessableAddressFromList = function() {

		var objAccessableAddressList = g_objAccessableAddressDialog.find('#accessableaddresslist');
		objAccessableAddressList.find('.list-table tbody tr').find('input:checkbox[name="selectaddress"]').filter(':checked').each( function () {
			$(this).closest('tr').remove();
		});
		refreshSelectedListTable(objAccessableAddressList);
	};

	refreshSelectedListTable = function(objTable) {

		var recordCount = 1;
		var lineStyle = '';

		objTable.find('.list-table tbody tr').each( function() {
			if (recordCount%2 == 0)
				lineStyle = "list_even";
			else
				lineStyle = "list_odd";

			$(this).removeClass("list_even");
			$(this).removeClass("list_odd");
			$(this).addClass(lineStyle);

			recordCount++;
		});
	};
//-->
</script>

<div id="dialog-accessableaddress" title="관리자 접속주소 관리" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>[특정 IP 에서 접속 가능]으로 설정할 경우,<BR />&nbsp;&nbsp;&nbsp;관리자가 관리자 페이지에 접근할 수 있는 주소는 최대 <%=(String) session.getAttribute("ADMINACCESSABLEADDRESSMAXCOUNT")%>개 까지 등록할 수 있습니다.</li>
				<li>[특정 IP 에서 접속 가능]으로 설정할 경우,<BR />&nbsp;&nbsp;&nbsp;설정된 이외에 주소에서 관리자 페이지로의 접근은 제한됩니다.</li>
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
			<div id="row-adminid" class="field-line">
				<div class="field-title">관리자 ID</div>
				<div class="field-value"><span id="adminid"></span></div>
			</div>
			<div id="row-adminname" class="field-line">
				<div class="field-title">관리자 명</div>
				<div class="field-value"><span id="adminname"></span></div>
			</div>
			<div id="row-accessableaddresstype" class="field-line">
				<div class="field-title">접속제한 유형</div>
				<div class="field-value"><select id="accessableaddresstype" name="accessableaddresstype" class="ui-widget-content"></select></div>
			</div>
			<div id="row-accessableaddress" class="field-line">
				<div class="field-title">접속제한 주소</div>
				<div class="field-contents" style="background: none;">
					<div class="field-line">
						<input type="text" id="newaccessableaddress" name="newaccessableaddress" class="text ui-widget-content" style="width: calc(100% - 111px);" />
						<button type="button" id="btnAddAddress" name="btnAddAddress" class="normal-button" style="vertical-align: top;">주소 추가</button>
					</div>
					<div class="field-line">
						<div style="border: 1px solid #d0d0d0; height: 120px; overflow: auto;">
							<div id="accessableaddresslist"></div>
						</div>
					</div>
					<div class="field-line button-line">
						<button type="button" id="btnDeleteAddress" name="btnDeleteAddress" class="normal-button">선택 주소 삭제</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
