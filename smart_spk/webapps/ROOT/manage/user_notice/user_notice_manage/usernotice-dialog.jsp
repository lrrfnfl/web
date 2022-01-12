<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objUserNoticeDialog;

	$(document).ready(function() {
		g_objUserNoticeDialog = $('#dialog-usernotice');

		g_objUserNoticeDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			width: $(document).width()/2,
			height: 'auto',
			minHeight: 300,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("공지 대상 선택")').button({
 					icons: { primary: 'ui-icon-person' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("전체 공지 등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("수정")').button({
 					icons: { primary: 'ui-icon-wrench' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("삭제")').button({
 					icons: { primary: 'ui-icon-trash' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().focus();
			},
			buttons: {
				"공지 대상 선택": function() {
					openUserNoticeMemberDialog();
				},
				"등록": function() {
					if (validateUserNoticeData(false)) {
						insertUserNotice();
					}
				},
				"전체 공지 등록": function() {
					if (validateUserNoticeData(true)) {
						insertUserNoticeAll();
					}
				},
				"수정": function() {
					if (validateUserNoticeData(false)) {
						displayConfirmDialog("사용자 공지 정보 수정", "사용자 공지 정보를 수정하시겠습니까?", "", function() { updateUserNotice(); });
					}
				},
				"삭제": function() {
					displayConfirmDialog("사용자 공지 정보 삭제", "사용자 공지 정보를 삭제하시겠습니까?", "", function() { deleteUserNotice(); });
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
				$(this).find('textarea').each(function() {
					$(this).val('');
				});
				$(this).find('select').each(function() {
					$(this).val('');
				});
			},
			resizeStop: function(event, ui) {
				resizeDialogElement($(this), $(this).find('#contents'));
			}
		})
		.dialogExtend({
			"closable" : false,
			"maximizable" : true,
			"minimizable" : false,
			"collapsable" : false,
			//"dblclick" : "collapse",
			"load" : function(event, dialog){ },
			"beforeCollapse" : function(event, dialog){ },
			"beforeMaximize" : function(event, dialog){ },
			"beforeMinimize" : function(event, dialog){ },
			"beforeRestore" : function(event, dialog){ },
			"collapse" : function(event, dialog){ },
			"maximize" : function(event, dialog){
				resizeDialogElement($(this), $(this).find('#contents'));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				resizeDialogElement($(this), $(this).find('#contents'));
			}
		});
	});

	openNewUserNoticeAllDialog = function() {

		var objCompanyId = g_objUserNoticeDialog.find('input[name="companyid"]');
		var objNoticeId = g_objUserNoticeDialog.find('input[name="noticeid"]');
		var objCompanyName = g_objUserNoticeDialog.find('#companyname');
		var objRegisterName = g_objUserNoticeDialog.find('#registername');
		var objTargetUserCount = g_objUserNoticeDialog.find('#targetusercount');

		var objRowCompanyName = g_objUserNoticeDialog.find('#row-companyname');
		var objRowTargetUserCount = g_objUserNoticeDialog.find('#row-targetusercount');
		var objRowLastModifierName = g_objUserNoticeDialog.find('#row-lastmodifiername');
		var objRowLastModifiedDatetime = g_objUserNoticeDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objUserNoticeDialog.find('#row-createdatetime');

		objCompanyId.val("");
		objNoticeId.val("");
		objCompanyName.text("전체");
		objRegisterName.text('<%=(String)session.getAttribute("ADMINNAME")%>');
		objTargetUserCount.text("0");

		//objRowCompanyName.hide();
		objRowTargetUserCount.hide();
		objRowLastModifierName.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		g_objUserNoticeDialog.dialog('option', 'title', '전체 사용자 공지');

		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("공지 대상 선택")').hide();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("등록")').hide();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("전체 공지 등록")').show();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("수정")').hide();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("삭제")').hide();

		g_objUserNoticeDialog.dialog('open');
	};

	openNewUserNoticeDialog = function() {

		var objCompanyId = g_objUserNoticeDialog.find('input[name="companyid"]');
		var objNoticeId = g_objUserNoticeDialog.find('input[name="noticeid"]');
		var objCompanyName = g_objUserNoticeDialog.find('#companyname');
		var objRegisterName = g_objUserNoticeDialog.find('#registername');
		var objTargetUserCount = g_objUserNoticeDialog.find('#targetusercount');

		var objRowCompanyName = g_objUserNoticeDialog.find('#row-companyname');
		var objRowTargetUserCount = g_objUserNoticeDialog.find('#row-targetusercount');
		var objRowLastModifierName = g_objUserNoticeDialog.find('#row-lastmodifiername');
		var objRowLastModifiedDatetime = g_objUserNoticeDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objUserNoticeDialog.find('#row-createdatetime');

		var targetCompanyId = "";
		var targetCompanyName = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
			targetCompanyName = objTreeReference.get_text(objTreeReference.get_selected());
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
		targetCompanyName = "<%=(String)session.getAttribute("COMPANYNAME")%>";
<% } %>

		objCompanyId.val(targetCompanyId);
		objNoticeId.val("");
		objCompanyName.text(targetCompanyName);
		objRegisterName.text('<%=(String)session.getAttribute("ADMINNAME")%>');
		objTargetUserCount.text("0");

		//objRowCompanyName.show();
		objRowTargetUserCount.show();
		objRowLastModifierName.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		loadUserNoticeMemberTreeView();

		g_objUserNoticeDialog.dialog('option', 'title', '신규 사용자 공지');

		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("공지 대상 선택")').show();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("등록")').show();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("전체 공지 등록")').hide();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("수정")').hide();
		g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("삭제")').hide();

		g_objUserNoticeDialog.dialog('open');
	};

	openUserNoticeInfoDialog = function(seqNo) {

		var objCompanyId = g_objUserNoticeDialog.find('input[name="companyid"]');
		var objNoticeId = g_objUserNoticeDialog.find('input[name="noticeid"]');
		var objCompanyName = g_objUserNoticeDialog.find('#companyname');
		var objRegisterName = g_objUserNoticeDialog.find('#registername');
		var objTitle = g_objUserNoticeDialog.find('input[name="title"]');
		var objContents = g_objUserNoticeDialog.find('textarea[name="contents"]');
		var objTargetUserCount = g_objUserNoticeDialog.find('#targetusercount');
		var objLastModifierName = g_objUserNoticeDialog.find('#lastmodifiername');
		var objLastModifiedDatetime = g_objUserNoticeDialog.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objUserNoticeDialog.find('#createdatetime');

		var objRowCompanyName = g_objUserNoticeDialog.find('#row-companyname');
		var objRowTargetUserCount = g_objUserNoticeDialog.find('#row-targetusercount');
		var objRowLastModifierName = g_objUserNoticeDialog.find('#row-lastmodifiername');
		var objRowLastModifiedDatetime = g_objUserNoticeDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objUserNoticeDialog.find('#row-createdatetime');

		var postData = getRequestUserNoticeInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 공지 정보 조회", "사용자 공지 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var noticeId = $(data).find('noticeid').text();
				var registerName = $(data).find('registername').text();
				var title = $(data).find('title').text();
				var contents = $(data).find('contents').text();
				var lastModifierName = $(data).find('lastmodifiername').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();
				var targetUserCount = $(data).find('targetusercount').text();

				objCompanyId.val(companyId);
				objNoticeId.val(noticeId);
				objCompanyName.text(companyName);
				objRegisterName.text(registerName);
				objTitle.val(title);
				objContents.val(contents);
				if ((targetUserCount != null) && (targetUserCount.length > 0)) {
					objTargetUserCount.text(targetUserCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				} else {
					objTargetUserCount.text("0");
				}
				objLastModifierName.text(lastModifierName);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objRowCompanyName.show();
				objRowTargetUserCount.show();
				objRowLastModifierName.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				loadUserNoticeMemberTreeView();

				g_objUserNoticeDialog.dialog('option', 'title', '사용자 공지 정보');

				g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("공지 대상 선택")').show();
				g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("등록")').hide();
				g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("전체 공지 등록")').hide();
				g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("수정")').show();
				g_objUserNoticeDialog.parent().find('.ui-dialog-buttonpane button:contains("삭제")').show();

				g_objUserNoticeDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 공지 정보 조회", "사용자 공지 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	insertUserNoticeAll = function() {

		var postData = getRequestInsertUserNoticeAllParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objUserNoticeDialog.find('input[name="title"]').val(),
				g_objUserNoticeDialog.find('textarea[name="contents"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" />처리중...<br>전체 공지 등록은 다소 시간이 지연될 수 있습니다.', css: { padding: '12px', width: '50%', background: 'transparent', border: '1px solid #ddd', color: '#fff', '-webkit-border-radius': '4px', '-moz-border-radius': '4px' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("전체 사용자 공지 등록", "전체 사용자 공지 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadUserNoticeList();
					displayInfoDialog("전체 사용자 공지 등록", "정상 처리되었습니다.", "정상적으로 전체 사용자 공지가 등록되었습니다.");
					g_objUserNoticeDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("전체 사용자 공지 등록", "전체 사용자 공지 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	insertUserNotice = function() {

		var arrTargetCompanyList = new Array();
		var arrTargetUserList = new Array();

		g_objUserNoticeMemberTree.jstree("get_checked", null, true).each( function() {
			if ($(this).attr('node_type') == "user") {
				if(arrTargetCompanyList.indexOf($(this).attr('companyid')) < 0) {
					arrTargetCompanyList.push($(this).attr('companyid'));
				}

				var arrTargetUser = new Array();
				arrTargetUser.push($(this).attr('companyid'));
				arrTargetUser.push($(this).attr('deptcode'));
				arrTargetUser.push($(this).attr('userid'));
				arrTargetUserList.push(arrTargetUser);
			}
		});

		var postData = getRequestInsertUserNoticeParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objUserNoticeDialog.find('input[name="title"]').val(),
				g_objUserNoticeDialog.find('textarea[name="contents"]').val(),
				arrTargetCompanyList,
				arrTargetUserList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 공지 등록", "사용자 공지 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadUserNoticeList();
					displayInfoDialog("사용자 공지 등록", "정상 처리되었습니다.", "정상적으로 사용자 공지가 등록되었습니다.");
					g_objUserNoticeDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 공지 등록", "사용자 공지 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateUserNotice = function() {

		var arrTargetUserList = new Array();

		g_objUserNoticeMemberTree.jstree("get_checked", null, true).each( function() {
			if ($(this).attr('node_type') == "user") {
				var arrTargetUser = new Array();
				arrTargetUser.push($(this).attr('companyid'));
				arrTargetUser.push($(this).attr('deptcode'));
				arrTargetUser.push($(this).attr('userid'));
				arrTargetUserList.push(arrTargetUser);
			}
		});

		var postData = getRequestUpdateUserNoticeParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objUserNoticeDialog.find('input[name="noticeid"]').val(),
				g_objUserNoticeDialog.find('input[name="title"]').val(),
				g_objUserNoticeDialog.find('textarea[name="contents"]').val(),
				g_objUserNoticeDialog.find('input[name="companyid"]').val(),
				arrTargetUserList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 공지 정보 변경", "사용자 공지 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadUserNoticeList();
					displayInfoDialog("사용자 공지 정보 변경", "정상 처리되었습니다.", "정상적으로 사용자 공지 정보가 변경되었습니다.");
					g_objUserNoticeDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 공지 정보 변경", "사용자 공지 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteUserNotice = function() {

		var postData = getRequestDeleteUserNoticeParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objUserNoticeDialog.find('input[name="noticeid"]').val(),
				g_objUserNoticeDialog.find('input[name="companyid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 공지 삭제", "사용자 공지 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadUserNoticeList();
					displayInfoDialog("사용자 공지 삭제", "정상 처리되었습니다.", "정상적으로 사용자 공지가 삭제되었습니다.");
					g_objUserNoticeDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 공지 삭제", "사용자 공지 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateUserNoticeData = function(noticeAll) {

		var objTitle = g_objUserNoticeDialog.find('input[name="title"]');
		var objContents = g_objUserNoticeDialog.find('textarea[name="contents"]');
		var objTargetUserCount = g_objUserNoticeDialog.find('#targetusercount');
		var objValidateTips = g_objUserNoticeDialog.find('#validateTips');

		if (objTitle.val().length == 0) {
			updateTips(objValidateTips, "공지 제목을 입력해 주세요.");
			resizeDialogElement(g_objUserNoticeDialog, g_objUserNoticeDialog.find('#contents'));
			objTitle.focus();
			return false;
		}

		if (objContents.val().length == 0) {
			updateTips(objValidateTips, "공지 내용을 입력해 주세요.");
			resizeDialogElement(g_objUserNoticeDialog, g_objUserNoticeDialog.find('#contents'));
			objContents.focus();
			return false;
		}

		if (!noticeAll) {
			if (objTargetUserCount.text() == '0') {
				updateTips(objValidateTips, "공지 대상을 선택해 주세요.");
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div id="dialog-usernotice" title="" class="dialog-form">
	<div class="dialog-contents">
			<div class="info">
				<ul class="infolist">
					<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
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
			<input type="hidden" id="companyid" name="companyid" />
			<input type="hidden" id="noticeid" name="noticeid" />
			<div id="row-companyname" class="field-line">
				<div class="field-title">대상 사업장</div>
				<div class="field-value"><span id="companyname"></span></div>
			</div>
			<div id="row-registername" class="field-line">
				<div class="field-title">작성자</div>
				<div class="field-value"><span id="registername"></span></div>
			</div>
			<div id="row-title" class="field-line">
				<div class="field-title">공지 제목<span class="required_field">*</span></div>
				<div class="field-value"><input type="text" id="title" name="title" class="text ui-widget-content" /></div>
			</div>
			<div id="row-contents" class="field-line">
				<div class="field-title">공지 내용<span class="required_field">*</span></div>
				<div class="field-contents"><textarea id="contents" name="contents" class="text ui-widget-content" style="height: 200px;"></textarea></div>
			</div>
			<div id="row-targetusercount" class="field-line">
				<div class="field-title">공지 대상 사용자 수</div>
				<div class="field-value"><span id="targetusercount"></span> 명</div>
			</div>
			<div id="row-lastmodifiername" class="field-line">
				<div class="field-title">최종 변경자</div>
				<div class="field-value"><span id="lastmodifiername"></span></div>
			</div>
			<div id="row-lastmodifieddatetime" class="field-line">
				<div class="field-title">최종 변경 일시</div>
				<div class="field-value"><span id="lastmodifieddatetime"></span></div>
			</div>
			<div id="row-createdatetime" class="field-line">
				<div class="field-title">등록 일시</div>
				<div class="field-value"><span id="createdatetime"></span></div>
			</div>
		</div>
	</div>
</div>
