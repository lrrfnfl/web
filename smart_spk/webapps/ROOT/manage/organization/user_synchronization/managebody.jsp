<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<%@ page import="com.spk.error.CommonError" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="setupconfig-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objMainContent;

	var g_htDatabaseTypeList = new Hashtable();

	$(document).ready(function() {

		g_objMainContent = $('#main-content');

		$( document).tooltip();

		$('button').button();
		$('#btnSetupConfig').button({ icons: {primary: "ui-icon-gear"} });
		$('#btnPreparation').button({ icons: {primary: "ui-icon-lightbulb"} });
		$('#btnExecution').button({ icons: {primary: "ui-icon-play"}, disabled: true });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htDatabaseTypeList = loadTypeList("DATABASE_TYPE");
		if (g_htDatabaseTypeList.isEmpty()) {
			displayAlertDialog("DB 유형 조회", "DB 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}
		fillDropdownList(g_objSetupConfigDialog.find('select[name="dbtype"]'), g_htDatabaseTypeList, null, "선택");

		loadUserSynchronizationConfigInfo();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSetupConfig') {
				openSetupConfigDialog();
			} else if ($(this).attr('id') == 'btnPreparation') {
				prepareUserSynchronization();
			} else if ($(this).attr('id') == 'btnExecution') {
				executeUserSynchronization();
			}
		});
	});

	prepareUserSynchronization = function() {

		var postData = getRequestUserSynchronizationPreparationParam('<%=(String)session.getAttribute("COMPANYID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사용자 동기화 준비", "사용자 동기화 준비 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var totalUserCount = $(data).find('totalusercount').text();
				var newUserCount = $(data).find('newusercount').text();
				var updateUserCount = $(data).find('updateusercount').text();
				var serviceStopUserCount = $(data).find('servicestopusercount').text();
				var serviceResumeUserCount = $(data).find('serviceresumeusercount').text();
				var licenceCount = $(data).find('licencecount').text();
				var usedLicenceCount = $(data).find('usedlicencecount').text();
				var needlicenceCount = $(data).find('needlicencecount').text();

				g_objMainContent.find('#totalusercount').text(totalUserCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#newusercount').text(newUserCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#updateusercount').text(updateUserCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#servicestopusercount').text(serviceStopUserCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#serviceresumeusercount').text(serviceResumeUserCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#licencecount').text(licenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				g_objMainContent.find('#usedlicencecount').text(usedLicenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				if (parseInt(licenceCount) >= ((parseInt(usedLicenceCount) + parseInt(needlicenceCount)))) {
					g_objMainContent.find('#needlicencecount').text(needlicenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
					$('#btnExecution').button("option", "disabled", false);
				} else {
					g_objMainContent.find('#needlicencecount').html('<html><body>' + needlicenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' - <span class="ui-state-error">라이센스 초과!!!</span></body></html>');
					$('#btnExecution').button("option", "disabled", true);
				}

				g_objMainContent.find('#synchronization-info').show();
				g_objMainContent.find('#added-dept-list').hide();

				$('#btnPreparation').button("option", "disabled", true);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 동기화 준비", "사용자 동기화 준비 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	executeUserSynchronization = function() {

		var postData = getRequestUserSynchronizationExecutionParam('<%=(String)session.getAttribute("COMPANYID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					if ($(data).find('errorcode').text() == '<%=CommonError.COMM_ERROR_USER_SYNCHRONIZATION_DEPTCODE_MISMATCH%>') {
						setTimeout(function() { getAddedDeptList(); }, 500);
					} else {
						displayAlertDialog("사용자 동기화 실행", "사용자 동기화 실행 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					}
					return false;
				}

				displayInfoDialog("사용자 동기화", "정상 처리되었습니다.", "정상적으로 사용자 동기화 작업이 완료 되었습니다.");
				$('#btnPreparation').button("option", "disabled", false);
				$('#btnExecution').button("option", "disabled", true);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사용자 동기화 실행", "사용자 동기화 실행 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	getAddedDeptList = function() {

		var postData = getRequestUserSynchronizationAddedDeptListParam('<%=(String)session.getAttribute("COMPANYID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("추가되야할 부서 코드 목록 조회", "추가되야할 부서 코드 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}
				g_objMainContent.find('select[name="addeddeptlist"]').empty();
				$(data).find('record').each( function(index) {
					var deptCode = $(this).find('deptcode').text();
					var deptName = $(this).find('deptname').text();

					g_objMainContent.find('select[name="addeddeptlist"]').append('<option value="' + deptCode + '">' + deptName + '</option>');
				});

// 				$(data).find('deptcode').each(function() {
// 					g_objMainContent.find('select[name="addeddeptlist"]').append('<option value="' + $(this).text() + '">' + $(this).text() + '</option>');
// 				});
				g_objMainContent.find('#synchronization-info').hide();
				g_objMainContent.find('#added-dept-list').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("추가되야할 부서 코드 목록 조회", "추가되야할 부서 코드 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div class="inner-center"> 
	<div class="pane-header">사용자 동기화</div>
	<div class="ui-layout-content">
		<div id="main-content" class="info-form show-block">
			<div class="info">
				<ul class="infolist">
					<li>사용자 동기화 작업은 기존 사용중인 인사 DB의 사용자를 기반으로 사용자를 동기화 해주는 역할을 합니다.</li>
					<li>인사 DB에 있고 SPK에 서비스 중지중인 사용자는 서비스 정상 상태로 변경됩니다.</li>
					<li>인사 DB에 없고 SPK에 있는 사용자는 서비스 중지 상태로 변경됩니다.</li>
				</ul>
			</div>
			<div id="synchronization-info" style="display: none;">
				<div class="category-title">사용자 동기화 정보</div>
				<div class="category-contents border-none" style="padding: 5px 0;">
					<div id="row-totalusercount" class="field-line">
						<div class="field-title">전체 동기화 사용자 수</div>
						<div class="field-value"><span id="totalusercount"></span></div>
					</div>
					<div id="row-newusercount" class="field-line">
						<div class="field-title">신규 등록 사용자 수</div>
						<div class="field-value"><span id="newusercount"></span></div>
					</div>
					<div id="row-updateusercount" class="field-line">
						<div class="field-title">정보 변경 사용자 수</div>
						<div class="field-value"><span id="updateusercount"></span></div>
					</div>
					<div id="row-servicestopusercount" class="field-line">
						<div class="field-title">서비스 중지 사용자 수</div>
						<div class="field-value"><span id="servicestopusercount"></span></div>
					</div>
					<div id="row-serviceresumeusercount" class="field-line">
						<div class="field-title">서비스 재개 사용자 수</div>
						<div class="field-value"><span id="serviceresumeusercount"></span></div>
					</div>
					<div id="row-licencecount" class="field-line">
						<div class="field-title">전체 라이센스 수</div>
						<div class="field-value"><span id="licencecount"></span></div>
					</div>
					<div id="row-usedlicencecount" class="field-line">
						<div class="field-title">사용중인 라이센스 수</div>
						<div class="field-value"><span id="usedlicencecount"></span></div>
					</div>
					<div id="row-needlicencecount" class="field-line">
						<div class="field-title">추가될 라이센스 수</div>
						<div class="field-value"><span id="needlicencecount"></span></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnSetupConfig" name="btnSetupConfig" class="normal-button">사용자 동기화 설정</button>
			<button type="button" id="btnPreparation" name="btnPreparation" class="normal-button">사용자 동기화 준비</button>
			<button type="button" id="btnExecution" name="btnExecution" class="normal-button">사용자 동기화 실행</button>
		</div>
	</div>
</div>
