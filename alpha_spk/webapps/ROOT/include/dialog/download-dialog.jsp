<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objDownloadDialog;

	$(document).ready(function() {
		g_objDownloadDialog = $('#dialog-download');

		g_objDownloadDialog.dialog({
			autoOpen: false,
			width: 500,
			autoResize: true,
			resizable: false,
			modal: true,
			closeOnEscape: false,
			open: function() {
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			}
		});
	});

	openDownloadDialog = function(downloadSubject, downloadFileName, postData) {
		g_objDownloadDialog.dialog('option', 'title', downloadSubject + " 다운로드");

		g_objDownloadDialog.find('#processingmsg').html('<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" />   다운로드 파일을 생성중입니다.<div style="margin:8px 0 0 20px;">생성되는 파일의 크기에 따라 수 분 이상 소요될 수 있습니다.</div>');
		g_objDownloadDialog.parent().find('.ui-dialog-buttonpane button:contains(파일 다운로드)').hide();
		g_objDownloadDialog.parent().find('.ui-dialog-buttonpane button:contains(취소)').show();

 		g_objDownloadDialog.dialog('open');

		setTimeout(function() { createDownloadFile(downloadSubject, downloadFileName, postData); }, 500);
	};

	createDownloadFile = function(downloadSubject, downloadFileName, postData) {

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend:function(){
				clearBrowserTimeout();
				g_isWorking = true;
			},
			complete: function(jqXHR, textStatus ) {
				g_isWorking = false;
				setTimeout(function() { g_objDownloadDialog.dialog('close') }, 500);
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("다운로드 파일 생성", "다운로드 파일 생성 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var downloadPath = encodeURIComponent($(data).find('filepath').text());
				var saveFileName = downloadFileName;
				var saveFileExtension = downloadPath.replace(/^.*\./, '');
				if (saveFileExtension.length > 0) {
					saveFileName += "." + saveFileExtension;
				}

				window.location.href = "/include/download.jsp?savefilename=" + saveFileName + "&filepath=" + downloadPath;
				//window.location.href = "/include/download.jsp?savefilename=" + downloadFileName + "&filepath=" + encodeURIComponent($(data).find('filepath').text());
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("다운로드 파일 생성", "다운로드 파일 생성 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
</script>

<div id="dialog-download" title="" class="dialog-form">
	<div style="padding: 10px; background:transparent; border: none;">
		<span id="processingmsg"></span>
	</div>
</div>
