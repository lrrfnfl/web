<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var g_objManageWaterMarkBackgroundImageDialog;
	var g_selectedImgPath = "";
	var g_selectedImgFileName = "";
	var g_selectedImgWidth = "";
	var g_selectedImgHeight = "";

	$(document).ready(function() {
		g_objManageWaterMarkBackgroundImageDialog = $('#dialog-managewatermarkbackgroundimage');

		$('#btnUploadFiles').button({ icons: {primary: "ui-icon-arrowthickstop-1-n"} });
		$('#btnSelectImage').button({ icons: {primary: "ui-icon-check"} });
		$('#btnDeselectImage').button({ icons: {primary: "ui-icon-cancel"} });
		$('#btnDeleteImage').button({ icons: {primary: "ui-icon-close"} });

	});

	openManageWaterMarkBackgroundImageDialog = function() {

		g_selectedImgPath = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]').val();
		g_selectedImgFileName = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagefilename"]').val();
		g_selectedImgWidth = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]').val();
		g_selectedImgHeight = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]').val();

		loadWaterMarkBackgroundImageListTable();

		if (g_selectedImgPath.length != 0) {
			displayThumbnail(g_selectedImgPath);
			$('#btnSelectImage').button("enable");
			$('#btnDeselectImage').button("enable");
			$('#btnDeleteImage').button("enable");
		} else {
			hideThumbnail();
			$('#btnSelectImage').button("disable");
			$('#btnDeselectImage').button("disable");
			$('#btnDeleteImage').button("disable");
		}

		g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table').scrolltable({
			stripe: true,
			oddClass: 'odd',
			maxHeight: 115
		});

		g_objManageWaterMarkBackgroundImageDialog.dialog({
			autoOpen: false,
			minWidth: 550,
			maxWidth: $(document).width(),
			width: $(document).width()/2,
			height: 'auto',
			minHeight: 480,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().focus();
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				g_selectedImgPath = "";
				g_selectedImgFileName = "";
				g_selectedImgWidth = "";
				g_selectedImgHeight = "";
				hideThumbnail();
			}
		})
		.dialogExtend({
			"closable" : false,
			"maximizable" : true,
			"minimizable" : true,
			"collapsable" : true,
			"dblclick" : "collapse"
		});

		$('button').click( function () {
			if ($(this).attr('id') == 'btnUploadFiles') {
				openUploadWaterMarkBackgroundImageDialog();
			} else if ($(this).attr('id') == 'btnSelectImage') {
				selectImage();
			} else if ($(this).attr('id') == 'btnDeselectImage') {
				deselectImage();
			} else if ($(this).attr('id') == 'btnDeleteImage') {
				deleteImage();
			}
		});

		g_objManageWaterMarkBackgroundImageDialog.dialog('open');
	};

	loadWaterMarkBackgroundImageListTable = function() {

		var objImageList = g_objManageWaterMarkBackgroundImageDialog.find('#image-list');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var targetCompanyId = ""; 
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var postData = getRequestWaterMarkBackgroundImageListParam(targetCompanyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("워터마크 이미지 리스트 조회", "워터마크 이미지 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table id="image-list-table" class="ui-widget-content scroll-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr style="border:none">';
				htmlContents += '<th width="40" style="text-align: center;">선택</th>';
				htmlContents += '<th>워터마크 이미지</th>';
				htmlContents += '<th style="width: 60px;">가로 크기</th>';
				htmlContents += '<th style="width: 60px;">세로 크기</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var resultRecordCount = $(data).find('file').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('file').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var fileName = $(this).find('filename').text();
						var filePath = $(this).find('filepath').text();
						var imageWidth = $(this).find('imagewidth').text();
						var imageHeigth = $(this).find('imageheight').text();

						htmlContents += '<tr class="' + lineStyle + '" filepath="' + filePath + '" filename="' + fileName + '" imagewidth="' + imageWidth + '" imageheigth="' + imageHeigth + '">';
						if ( (g_selectedImgPath.length != 0) && (g_selectedImgPath == filePath) ) {
							htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectfile" filename="' + fileName + '" style="border: 0;" onFocus="this.blur()" checked></td>';
						} else {
							htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectfile" filename="' + fileName + '" style="border: 0;" onFocus="this.blur()"></td>';
						}
						htmlContents += '<td style="text-align: left;" title="' + fileName + '">' + fileName + '</td>';
						htmlContents += '<td style="text-align: right;">' + imageWidth + '</td>';
						htmlContents += '<td style="text-align: right;">' + imageHeigth + '</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objImageList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table tbody tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table tbody tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
//					inlineScriptText += "g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table tbody tr').click(function() { var isChecked = $(this).find('input:checkbox[name=selectfile]').is(':checked'); $('input:checkbox[name=selectfile]').each( function () { $(this).prop('checked', false); }); if (isChecked == true) { $(this).find('input:checkbox[name=selectfile]').prop('checked', false); g_selectedImgPath = ''; g_selectedImgWidth = ''; g_selectedImgHeight = ''; hideThumbnail(); $('#btnSelectImage').button('disable'); $('#btnDeleteImage').button('disable'); } else { $(this).find('input:checkbox[name=selectfile]').prop('checked', true); g_selectedImgPath = $(this).attr('filepath'); g_selectedImgWidth = $(this).attr('imagewidth'); g_selectedImgHeight = $(this).attr('imageheigth'); displayThumbnail($(this).attr('filepath')); $('#btnSelectImage').button('enable'); $('#btnDeleteImage').button('enable'); } });";
					inlineScriptText += "g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table tbody tr').click(function (e) { selectImageRow($(this)); });";
					inlineScriptText += "g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table tbody tr td:first-child').click(function (e) { selectImageRow($(e.target).parent()); });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objImageList.append(inlineScript);
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="4" align="center"><div style="padding: 10px 0; text-align: center;">선택할 워터마크 이미지가 없습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objImageList.html(htmlContents);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("워터마크 이미지 리스트 조회", "워터마크 이미지 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	displayThumbnail = function(srcPath) {

		var imgContents = '<img src="' + srcPath + '" />';

		$('.nailthumb-container').html(imgContents);
		$('.nailthumb-container').nailthumb({width:200,height:200,method:'resize',fitDirection:'top left'});
	};

	hideThumbnail = function() {

		$('.nailthumb-container').html("");
	};

	deleteImage = function() {

		var arrTargetFileList = new Array();

		g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table input:checkbox[name="selectfile"]').filter(':checked').each( function () {
			arrTargetFileList.push($(this).attr('filename'));
		});

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var targetCompanyId = ""; 
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var postData = getRequestDeleteWaterMarkBackgroundImagesParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				targetCompanyId,
				arrTargetFileList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("워터마크 이미지 삭제", "워터마크 이미지 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("워터마크 이미지 삭제", "정상 처리되었습니다.", "정상적으로 워터마크 이미지가 삭제되었습니다.");

					loadWaterMarkBackgroundImageListTable();
					g_selectedImgPath = "";
					wmbackgroundimagefilename = '';
					g_selectedImgWidth = "";
					g_selectedImgHeight = "";
					hideThumbnail();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("워터마크 이미지 삭제", "워터마크 이미지 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
/*
	selectAllImages = function() {
		g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table input:checkbox[name=selectfile]').each( function () {
			$(this).prop('checked', true);
		});
	};

	deselectAllImages = function() {
		g_objManageWaterMarkBackgroundImageDialog.find('.scroll-table input:checkbox[name=selectfile]').each( function () {
			$(this).prop('checked', false);
		});
	};
*/

	selectImageRow = function(objectTarget) {
		var isChecked = objectTarget.find('input:checkbox[name=selectfile]').is(':checked');

		$('input:checkbox[name=selectfile]').each( function () {
			$(this).prop('checked', false);
		});
		if (isChecked == true) {
			objectTarget.find('input:checkbox[name=selectfile]').prop('checked', false);
			g_selectedImgPath = '';
			g_selectedImgFileName = '';
			g_selectedImgWidth = '';
			g_selectedImgHeight = '';
			hideThumbnail();
			$('#btnSelectImage').button('disable');
			$('#btnDeleteImage').button('disable');
		} else {
			objectTarget.find('input:checkbox[name=selectfile]').prop('checked', true);
			g_selectedImgPath = objectTarget.attr('filepath');
			g_selectedImgFileName = objectTarget.attr('filename');
			g_selectedImgWidth = objectTarget.attr('imagewidth');
			g_selectedImgHeight = objectTarget.attr('imageheigth');
			displayThumbnail(objectTarget.attr('filepath'));
			$('#btnSelectImage').button('enable');
			$('#btnDeleteImage').button('enable');
		}
	};

	selectImage = function() {
		if( g_selectedImgPath != '' ) {
			g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]').val(g_selectedImgPath);
			g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagefilename"]').val(g_selectedImgFileName);
			g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]').val(g_selectedImgWidth);
			g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]').val(g_selectedImgHeight);
			g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimagewidth"]').val(g_selectedImgWidth);
			g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimageheight"]').val(g_selectedImgHeight);
			g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('value', 100);
			g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('enable');

			g_objManageWaterMarkBackgroundImageDialog.dialog('close');
		}
	};

	deselectImage = function() {
		g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]').val('');
		g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagefilename"]').val('');
		g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]').val('');
		g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]').val('');
		g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimagewidth"]').val('');
		g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimageheight"]').val('');
		g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('value', 100);
		g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('disable');

		g_objManageWaterMarkBackgroundImageDialog.dialog('close');
	};
</script>

<div id="dialog-managewatermarkbackgroundimage" title="워터마크 이미지 관리" class="dialog-form">
	<div class="dialog-contents">
		<div class="category-sub-title">워터마크 이미지 목록</div>
		<div class="category-sub-contents">
			<div style="float: left; width: 60%;">
				<div id="image-list"></div>
			</div>
			<div style="margin-left: 65%;">
				<div style="text-align: right;">
					<button type="button" id="btnUploadFiles" name="btnUploadFiles" class="normal-button" style="width: 100%;">이미지 업로드</button>
				</div>
			</div>
		</div>
		<div class="clear"></div>
		<div class="category-sub-title" style="margin-top: 20px;">워터마크 이미지 상세</div>
		<div class="category-sub-contents">
			<div style="float: left; width: 60%;">
				<div class="nailthumb-container"></div>
				<div id="image-metrix" style="margin-top: 10px;"></div>
			</div>
			<div style="margin-left: 65%;">
				<div style="text-align: right;">
					<button type="button" id="btnSelectImage" name="btnSelectImage" class="normal-button" style="width: 100%;">이미지 선택</button>
				</div>
				<div style="text-align: right; margin-top: 8px;">
					<button type="button" id="btnDeselectImage" name="btnDeselectImage" class="normal-button" style="width: 100%;">이미지 선택 취소</button>
				</div>
				<div style="text-align: right; margin-top: 8px;">
					<button type="button" id="btnDeleteImage" name="btnDeleteImage" class="normal-button" style="width: 100%;">이미지 삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
	