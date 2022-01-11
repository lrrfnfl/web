<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objUploadWaterMarkBackgroundImageDialog;

	$(document).ready(function() {
		$('button[name="btnUpload"]').button({ icons: {primary: "ui-icon-arrowstop-1-n"} });

		g_objUploadWaterMarkBackgroundImageDialog = $('#dialog-uploadwatermarkbackgroundimage');

		g_objUploadWaterMarkBackgroundImageDialog.dialog({
			autoOpen: false,
			width: 400,
			height: 'auto',
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
			}
		});

	});

	openUploadWaterMarkBackgroundImageDialog = function() {

		g_objUploadWaterMarkBackgroundImageDialog.dialog('open');
		g_objUploadWaterMarkBackgroundImageDialog.parent().find('.ui-dialog-buttonpane button:contains(취소)').show();

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var targetCompanyId = ""; 
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		$('#file-upload').fileupload({
			dataType: "xml",
			acceptFileTypes: /^image\/(bmp)$/i,
			formData: {Type: 'watermark', CompanyId: targetCompanyId},
			url: '/UploadWatermarkImgFile',
			add: function(e, data) {
				var extension = data.originalFiles[0].name.substr((data.originalFiles[0].name.lastIndexOf('.') +1));
				if (extension != "bmp") {
					displayAlertDialog("워터마크 이미지 파일 업로드", "워터마크 이미지는 bmp 파일만 지원합니다.", "");
				} else {
					data.submit();
				}
			},
			start: function(e, data) {
				g_objUploadWaterMarkBackgroundImageDialog.parent().find('.ui-dialog-buttonpane button:contains(취소)').prop('disabled', true);
			},
			done: function(e, data) {
				g_objUploadWaterMarkBackgroundImageDialog.parent().find('.ui-dialog-buttonpane button:contains(취소)').prop('disabled', false);
				if ($(data.result).find('errorcode').text() != "0000") {
					displayAlertDialog("워터마크 이미지 파일 업로드", "워터마크 이미지 파일 업로드 중 오류가 발생하였습니다.", $(data.result).find('errormsg').text());
					return false;
				}
				loadWaterMarkBackgroundImageListTable();
				setTimeout(function() { g_objUploadWaterMarkBackgroundImageDialog.dialog('close'); }, 100);
			},
			fail: function(e, data) {
				if (data.jqXHR.status != 0 && data.jqXHR.readyState != 0) {
					displayAlertDialog("워터마크 이미지 파일 업로드", "워터마크 이미지 파일 업로드 중 오류가 발생하였습니다.", data.jqXHR.statusText + "(" + data.jqXHR.status + ")");
				}
			}
		});
	};
</script>

<div id="dialog-uploadwatermarkbackgroundimage" title="워터마크 배경 이미지 업로드" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>업로드할 워터마크 이미지를 선택해주세요.</li>
				<li>워터마크 bmp 파일만 지원합니다.</li>
			</ul>
		</div>
		<div style="margin-top: 10px;">
			<span class="btn btn-success fileinput-button">
				<span><button type="button" id="btnUpload" name="btnUpload" class="small-button">파일 업로드</button></span>
				<input type="file" id="file-upload" name="file-upload" />
			</span>
		</div>
	</div>
</div>
	