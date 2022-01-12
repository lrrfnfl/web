<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="batchuserregistprogress-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objManageBatch;

	$(document).ready(function() {
		g_objManageBatch = $('#manage-batch');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });
		$('button[name="btnUpload"]').button({ icons: {primary: "ui-icon-arrowstop-1-n"} });
		$('button[name="btnExecuteBatch"]').button({ icons: {primary: "ui-icon-disk"} });
		$('button[name="btnStopBatch"]').button({ icons: {primary: "ui-icon-circle-close"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		$('#file-upload').fileupload({
			dataType: "xml",
			formData: {Type: 'batchregist'},
			url: '/UploadUserListFile',
			add: function(e, data) {
				var extension = data.originalFiles[0].name.substr((data.originalFiles[0].name.lastIndexOf('.') +1));
				if (extension != "csv") {
					displayAlertDialog("사용자 배치등록 파일 업로드", "사용자 배치등록 파일은 csv 파일만 지원합니다.", "");
				} else {
					data.submit();
				}
			},
			start: function(e, data) {
				$('#file-upload').prop('disabled', true);
			},
			done: function(e, data) {
				$('#file-upload').prop('disabled', false);
				if ($(data.result).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 배치등록 파일 업로드", "사용자 배치등록 파일 업로드 중 오류가 발생하였습니다.", $(data.result).find('errormsg').text());
					return false;
				}
				setTimeout(function() { getBatchUserRegistData($(data.result).find('filename').text()); }, 100);
			},
			fail: function(e, data) {
				if (data.jqXHR.status != 0 && data.jqXHR.readyState != 0) {
					displayAlertDialog("사용자 배치등록 파일 업로드", "사용자 배치등록 파일 업로드 중 오류가 발생하였습니다.", data.jqXHR.statusText + "(" + data.jqXHR.status + ")");
				}
			}
		});

		$('button').click( function () {
			if ($(this).attr('id') == 'btnDownload') {
				downloadBatchUserRegistFormat();
			} else if ($(this).attr('id') == 'btnExecuteBatch') {
				openBatchUserRegistProgressDialog();
			}
		});
	});

	downloadBatchUserRegistFormat = function() {

<% if (AdminType.ADMIN_TYPE_COMPANY_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var postData = getRequestCreateBatchUserRegistFormatFileParam('<%=(String)session.getAttribute("COMPANYID")%>',
				'DEPTCODE',
				'ASC');

		openDownloadDialog("사용자 배치 등록 형식 파일 다운로드", "사용자 배치 등록 형식 파일 다운로드", postData);
<% } else { %>
		location.href = "/downfiles/formatfiles/BatchUserRegist_Format.zip";
<% } %>
	};

	getBatchUserRegistData = function(fileName) {

		var postData = getRequestUserListForBatchRegistParam(fileName);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" />처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 배치 등록 목록 조회", "사용자 배치 등록 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th width="5%" class="ui-state-default">번호</th>';
				htmlContents += '<th width="8%" class="ui-state-default">사업장 ID</th>';
				htmlContents += '<th width="8%" class="ui-state-default">사업장 명</th>';
				htmlContents += '<th width="5%" class="ui-state-default">부서 코드</th>';
				htmlContents += '<th width="8%" class="ui-state-default">부서 명</th>';
				htmlContents += '<th width="8%" class="ui-state-default">사용자 ID</th>';
				htmlContents += '<th width="8%" class="ui-state-default">비밀번호</th>';
				htmlContents += '<th width="8%" class="ui-state-default">사용자 명</th>';
				htmlContents += '<th width="12%" class="ui-state-default">이메일</th>';
				htmlContents += '<th width="7%" class="ui-state-default">전화번호</th>';
				htmlContents += '<th width="7%" class="ui-state-default">휴대전화번호</th>';
				htmlContents += '<th class="ui-state-default">처리결과</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var companyId = $(this).find('field_0').text();
						var companyName = $(this).find('field_1').text();
						var deptCode = $(this).find('field_2').text();
						var deptName = $(this).find('field_3').text();
						var userId = $(this).find('field_4').text();
						var password = $(this).find('field_5').text();
						var userName = $(this).find('field_6').text();
						var email = $(this).find('field_7').text();
						var phone = $(this).find('field_8').text();
						var mobilePhone = $(this).find('field_9').text();

						htmlContents += '<tr class="' + lineStyle + '">';
						htmlContents += '<td>' + recordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						htmlContents += '<td title="' + companyId + '">' + companyId + '</td>';
						htmlContents += '<td title="' + companyName + '">' + companyName + '</td>';
						htmlContents += '<td title="' + deptCode + '">' + deptCode + '</td>';
						htmlContents += '<td title="' + deptName + '">' + deptName + '</td>';
						htmlContents += '<td title="' + userId + '">' + userId + '</td>';
						htmlContents += '<td title="' + password + '">' + password + '</td>';
						htmlContents += '<td title="' + userName + '">' + userName + '</td>';
						htmlContents += '<td title="' + email + '">' + email + '</td>';
						htmlContents += '<td title="' + phone + '">' + phone + '</td>';
						htmlContents += '<td title="' + mobilePhone + '">' + mobilePhone + '</td>';
						htmlContents += '<td>&nbsp;</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					$('#userdata-list').html(htmlContents);

					$('#select-batch-file').hide();
					$('#userdata-list').show();
					$('button[name="btnExecuteBatch"]').show();

					var inlineScriptText = "";
					inlineScriptText += "g_objManageBatch.find('.list-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objManageBatch.find('.list-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objManageBatch.find('.list-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					$('#userdata-list').append(inlineScript);
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="10" align="center"><div style="padding: 10px 0; text-align: center;">등록할 사용자 데이타가 없습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					$('#userdata-list').html(htmlContents);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 배치 등록 목록 조회", "사용자 배치 등록 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
 		});
	};
//-->
</script>

<div class="inner-center">
	<div class="pane-header">사용자 배치 등록</div>
	<div class="ui-layout-content">
		<div id="manage-batch">
			<div id="select-batch-file">
				<div class="info">
					<ul class="infolist">
						<li>사용자 배치 등록 형식 파일을 다운받으려면 <button type="button" id="btnDownload" name="btnDownload" class="small-button">다운로드</button> 를 클릭하세요.</li>
						<li>배치 등록할 파일을 선택해 주세요.</li>
					</ul>
				</div>
				<div style="margin-top: 10px; margin-left: 20px;">
					<span class="btn btn-success fileinput-button">
						<span><button type="button" id="btnUpload" name="btnUpload" class="small-button">파일 업로드</button></span>
						<input type="file" id="file-upload" name="file-upload" />
					</span>
				</div>
			</div>
			<div id="userdata-list"></div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnExecuteBatch" name="btnExecuteBatch" class="normal-button" style="display: none;">등록 실행</button>
		</div>
	</div>
</div>

