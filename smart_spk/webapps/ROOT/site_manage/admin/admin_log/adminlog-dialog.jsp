<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openAdminLogInfoDialog = function(seqNo) {

		var postData = getRequestAdminLogInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("관리자 로그 정보 조회", "관리자 로그 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var jobContent = $(data).find('jobcontent').text();
				jobContent = jobContent.replace(/\n/g, "<br />");
				jobContent = jobContent.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogOptions = {
					"minWidth" : 300,
					"maxWidth" : $(document).width(),
					"width" : g_dialogWidth,
					"height" : g_dialogHeight,
					"maxHeight" : $(document).height(),
					"resizable" : true,
					"draggable" : true,
					"open" : function() {
						$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
		 					icons: { primary: 'ui-icon-circle-check' }
						});
						$(this).parent().focus();
					},
					"resizeStop" : function() {
						g_dialogWidth = $(this).dialog("option", "width");
						g_dialogHeight = $(this).dialog("option", "height");
						resizeDialogElement($(this), $(this).find('#jobcontent'));
					},
					"dragStop" : function( event, ui ) {
						g_lastDialogPosition = ui.position;
					},
					"buttons" : {
						"확인": function() {
							$(this).dialog('close');
						}
					},
					"close" : function() {
					}
				};

				var dialogExtendOptions = {
					"closable" : false,
					"maximizable" : true,
					"minimizable" : true,
					"collapsable" : true,
					"dblclick" : "collapse",
					"load" : function(event, dialog){ },
					"beforeCollapse" : function(event, dialog){ },
					"beforeMaximize" : function(event, dialog){ },
					"beforeMinimize" : function(event, dialog){ },
					"beforeRestore" : function(event, dialog){ },
					"collapse" : function(event, dialog){ },
					"maximize" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#jobcontent'));
					},
					"minimize" : function(event, dialog){ },
					"restore" : function(event, dialog){
						resizeDialogElement($(this), $(this).find('#jobcontent'));
					}
				};

				var dialogContents = "";
				dialogContents = '<div title="관리자 로그 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
				dialogContents += '<div id="row-adminid" class="field-line">';
				dialogContents += '<div class="field-title">관리자 ID</div>';
				dialogContents += '<div class="field-value"><span id="adminid">' + $(data).find('adminid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-adminname" class="field-line">';
				dialogContents += '<div class="field-title">관리자 명</div>';
				dialogContents += '<div class="field-value"><span id="adminname">' + $(data).find('adminname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-admintype" class="field-line">';
				dialogContents += '<div class="field-title">관리자 유형</div>';
				dialogContents += '<div class="field-value"><span id="admintype">' + g_htAdminTypeList.get($(data).find('admintype').text()) + '</span></div>';
				dialogContents += '</div>';
				if ($(data).find('admintype').text() == "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>") {
					dialogContents += '<div id="row-companyid" class="field-line">';
					dialogContents += '<div class="field-title">사업장 ID</div>';
					dialogContents += '<div class="field-value"><span id="companyid">' + $(data).find('companyid').text() + '</span></div>';
					dialogContents += '</div>';
					dialogContents += '<div id="row-companyname" class="field-line">';
					dialogContents += '<div class="field-title">사업장 명</div>';
					dialogContents += '<div class="field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
					dialogContents += '</div>';
				}
				dialogContents += '<div id="row-jobtype" class="field-line">';
				dialogContents += '<div class="field-title">작업 유형</div>';
				dialogContents += '<div class="field-value"><span id="jobtype">' + g_htJobTypeList.get($(data).find('jobtype').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-jobcategory" class="field-line">';
				dialogContents += '<div class="field-title">작업 대상</div>';
				dialogContents += '<div class="field-value"><span id="jobcategory">' + g_htJobCategoryList.get($(data).find('jobcategory').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-jobsubject" class="field-line">';
				dialogContents += '<div class="field-title">작업 제목</div>';
				dialogContents += '<div class="field-value"><span id="jobsubject">' + $(data).find('jobsubject').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-jobcontent" class="field-line">';
				dialogContents += '<div class="field-title">작업 내용</div>';
				dialogContents += '<div class="field-contents"><div id="jobcontent" style="width: 98%; height: 200px; overflow: auto; white-space: normal;">' + jobContent + '</div></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-jobdatetime" class="field-line">';
				dialogContents += '<div class="field-title">작업 일시</div>';
				dialogContents += '<div class="field-value"><span id="jobdatetime">' + $(data).find('jobdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '</div>';
				dialogContents += '</div>';

				// open dialog
				var newDialog = $(dialogContents).dialog(dialogOptions).dialogExtend(dialogExtendOptions);

				if (!$.isEmptyObject(g_lastDialogPosition)) {
					newDialog.closest('.ui-dialog').offset({ top: g_lastDialogPosition.top+15, left: g_lastDialogPosition.left+15});
				} else {
					newDialog.dialog("option", "position", { my: "center", at: "center" } );
				}

				if ((newDialog.closest('.ui-dialog').offset().top + newDialog.closest('.ui-dialog').outerHeight(true)) >= $(window).height()) {
					newDialog.closest('.ui-dialog').offset({ top: 0, left: newDialog.closest('.ui-dialog').offset.left});
				}

				g_lastDialogPosition = newDialog.closest('.ui-dialog').offset();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 로그 정보 조회", "관리자 로그 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>