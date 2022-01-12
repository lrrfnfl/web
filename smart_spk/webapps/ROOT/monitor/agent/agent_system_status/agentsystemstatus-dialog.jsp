<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_dialogWidth = $(document).width()/2;
	var g_dialogHeight = "auto";
	var g_lastDialogPosition;

	openAgentSystemStatusInfoDialog = function(seqNo) {

		var postData = getRequestAgentSystemStatusInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 시스템 현황 정보 조회", "사용자 시스템 현황 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var cpuInfo = $(data).find('cpuinfo').text();
				cpuInfo = cpuInfo.replace(/\n/g, "&nbsp;");
				cpuInfo = cpuInfo.replace(/\t/g, "&nbsp;&nbsp;");

				var memoryInfo = $(data).find('memoryinfo').text();
				memoryInfo = memoryInfo.replace(/\n/g, "&nbsp;");
				memoryInfo = memoryInfo.replace(/\t/g, "&nbsp;&nbsp;");

				var osInfo = $(data).find('osinfo').text();
				osInfo = osInfo.replace(/\n/g, "&nbsp;");
				osInfo = osInfo.replace(/\t/g, "&nbsp;&nbsp;");

				var antivirusSoftwareInfo = $(data).find('antivirussoftwareinfo').text();
				antivirusSoftwareInfo = antivirusSoftwareInfo.replace(/\n/g, "&nbsp;");
				antivirusSoftwareInfo = antivirusSoftwareInfo.replace(/\t/g, "&nbsp;&nbsp;");

				var dialogOptions = {
					"minWidth" : 400,
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
				dialogContents = '<div title="사용자 시스템 현황 정보" class="dialog-form">';
				dialogContents += '<div class="dialog-contents">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				dialogContents += '<div id="row-companyname" class="field-line">';
				dialogContents += '<div class="field-title">사업장</div>';
				dialogContents += '<div class="field-value"><span id="companyname">' + $(data).find('companyname').text() + '</span></div>';
				dialogContents += '</div>';
<% } %>
				dialogContents += '<div id="row-deptname" class="field-line">';
				dialogContents += '<div class="field-title">부서</div>';
				dialogContents += '<div class="field-value"><span id="deptname">' + $(data).find('deptname').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-userid" class="field-line">';
				dialogContents += '<div class="field-title">사용자 ID</div>';
				dialogContents += '<div class="field-value"><span id="userid">' + $(data).find('userid').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-username" class="field-line">';
				dialogContents += '<div class="field-title">사용자 명</div>';
				dialogContents += '<div class="field-value"><span id="username">' + $(data).find('username').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-installflag" class="field-line">';
				dialogContents += '<div class="field-title">에이젼트 설치</div>';
				dialogContents += '<div class="field-value"><span id="installflag">' + g_htInstallStateList.get($(data).find('installflag').text()) + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-servicestateflag" class="field-line">';
				dialogContents += '<div class="field-title">서비스 상태</div>';
				if ($(data).find('servicestateflag').text() == "<%=ServiceState.SERVICE_STATE_STOP%>") {
					dialogContents += '<div class="field-value"><span id="servicestateflag" class="state-abnormal">' + g_htServiceStateList.get($(data).find('servicestateflag').text()) + '</span></div>';
				} else {
					dialogContents += '<div class="field-value"><span id="servicestateflag">' + g_htServiceStateList.get($(data).find('servicestateflag').text()) + '</span></div>';
				}
				dialogContents += '</div>';
				dialogContents += '<div id="row-cpuinfo" class="field-line">';
				dialogContents += '<div class="field-title">CPU 정보</div>';
				dialogContents += '<div class="field-value"><span id="cpuinfo">' + cpuInfo + '</span></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-memoryinfo" class="field-line">';
				dialogContents += '<div class="field-title">메모리 정보</div>';
				dialogContents += '<div class="field-value"><span id="memoryinfo">' + memoryInfo + '</span></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-osinfo" class="field-line">';
				dialogContents += '<div class="field-title">OS 정보</div>';
				dialogContents += '<div class="field-value"><span id="osinfo">' + osInfo + '</span></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastosupdatedatetime" class="field-line">';
				dialogContents += '<div class="field-title">OS 업데이트 일시</div>';
				dialogContents += '<div class="field-value"><span id="lastosupdatedatetime">' + $(data).find('lastosupdatedatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-antivirussoftwareinfo" class="field-line">';
				dialogContents += '<div class="field-title">백신 정보</div>';
				dialogContents += '<div class="field-value"><span id="antivirussoftwareinfo">' + antivirusSoftwareInfo + '</span></div>';
				dialogContents += '<div class="clear"></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-antivirussoftwarelatestupdateflag" class="field-line">';
				dialogContents += '<div class="field-title">백신 최신 업데이트</div>';
				dialogContents += '<div class="field-value"><span id="antivirussoftwarelatestupdateflag">';
				if ($(data).find('antivirussoftwarelatestupdateflag').text().length > 0) { 
					dialogContents += g_htOptionTypeList.get($(data).find('antivirussoftwarelatestupdateflag').text());
				}
				dialogContents += '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-systempasswordsetupflag" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 설정</div>';
				dialogContents += '<div class="field-value"><span id="systempasswordsetupflag">';
				if ($(data).find('systempasswordsetupflag').text().length > 0) { 
					dialogContents += g_htOptionTypeList.get($(data).find('systempasswordsetupflag').text());
				}
				dialogContents += '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-lastchangedsystempassworddatetime" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 변경 일시</div>';
				dialogContents += '<div class="field-value"><span id="lastchangedsystempassworddatetime">' + $(data).find('lastchangedsystempassworddatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-systempasswordexpirationdatetime" class="field-line">';
				dialogContents += '<div class="field-title">비밀번호 만료 일시</div>';
				dialogContents += '<div class="field-value"><span id="systempasswordexpirationdatetime">' + $(data).find('systempasswordexpirationdatetime').text() + '</span></div>';
				dialogContents += '</div>';
				dialogContents += '<div id="row-screensaveractivationflag" class="field-line">';
				dialogContents += '<div class="field-title">화면 보호기 설정</div>';
				dialogContents += '<div class="field-value"><span id="screensaveractivationflag">';
				if ($(data).find('screensaveractivationflag').text().length > 0) { 
					dialogContents += g_htOptionTypeList.get($(data).find('screensaveractivationflag').text());
				}
				dialogContents += '</span></div>';
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
					displayAlertDialog("사용자 시스템 현황 정보 조회", "사용자 시스템 현황 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>