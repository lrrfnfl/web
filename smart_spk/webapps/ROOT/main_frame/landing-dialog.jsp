<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript" src="/js/jquery-dialogextend-master/build/jquery.dialogextend.js"></script>
<script type="text/javascript">
<!--
	var g_htOptionTypeList = new Hashtable();

	var g_objLandingDialog;

	$(document).ready(function() {

		$('#dialog-landing').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_objLandingDialog = $('#dialog-landing');

		g_objLandingDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			width: $(document).width()-$(document).width()/10,
			height: $(document).height()-$(document).height()/10,
			minHeight: 300,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("설정 저장")').button({
 					icons: { primary: 'ui-icon-disk' }
				});
				$('#dialog-landing').mCustomScrollbar('update');
			},
			buttons: {
				"설정 저장": function() {
					if (validateLandingSetupData()) {
						saveLandingSetupConfig();
					}
				}
			},
			close: function() {
			},
			resizeStop: function(event, ui) {
				$('#dialog-landing').mCustomScrollbar('update');

				//resizeDialogElement($(this), $(this).find('#contents'));
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
				$('#dialog-landing').mCustomScrollbar('update');

				//resizeDialogElement($(this), $(this).find('#contents'));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				$('#dialog-landing').mCustomScrollbar('update');

				//resizeDialogElement($(this), $(this).find('#contents'));
			}
		});

		g_objLandingDialog.find('input[type="radio"]').change( function(event) {
			if ($(this).filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
				$(this).closest('.field-line').siblings().each( function() {
					if ($(this).hasClass("sub-option")) {
						$(this).show();
					}
				});
			} else {
				$(this).closest('.field-line').siblings().each( function() {
					if ($(this).hasClass("sub-option")) {
						$(this).hide();
					}
				});
			}
		});

		openLandingDialog();
	});

	openLandingDialog = function() {

		var objForcedTermination = g_objLandingDialog.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objLandingDialog.find('input[name="forcedterminationpwd"]');
		var objReEncoding = g_objLandingDialog.find('input[type="radio"][name="reencoding"]');
		var objDecordingPermission = g_objLandingDialog.find('input[type="radio"][name="decordingpermission"]');

		var objRowForcedTerminationPwd = g_objLandingDialog.find('#row-forcedterminationpwd');

		var postData = getRequestLandingSetupConfigInfoParam('<%=(String)session.getAttribute("COMPANYID")%>');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("주요 정책 설정 정보 조회", "주요 정책 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var forcedTerminationFlag = $(data).find('forcedterminationflag').text();
				var forcedTerminationPwd = $(data).find('forcedterminationpwd').text();
				var reEncodingFlag = $(data).find('reencodingflag').text();
				var decordingPermissionFlag = $(data).find('decordingpermissionflag').text();

				objForcedTermination.prop('checked', false);
				objForcedTermination.filter('[value=' + forcedTerminationFlag + ']').prop('checked', true);

				objForcedTerminationPwd.val(forcedTerminationPwd);
				if (forcedTerminationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowForcedTerminationPwd.show();
				} else {
					objRowForcedTerminationPwd.hide();
				}

				objReEncoding.prop('checked', false);
				objReEncoding.filter('[value=' + reEncodingFlag + ']').prop('checked', true);

				objDecordingPermission.prop('checked', false);
				objDecordingPermission.filter('[value=' + decordingPermissionFlag + ']').prop('checked', true);

				g_objLandingDialog.dialog('option', 'title', '관리자 정책 시작하기');
				g_objLandingDialog.parent().find('.ui-dialog-buttonpane button:contains("설정 저장")').show();
				g_objLandingDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("주요 정책 설정 정보 조회", "주요 정책 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveLandingSetupConfig = function() {

		var objForcedTermination = g_objLandingDialog.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objLandingDialog.find('input[name="forcedterminationpwd"]');
		var objReEncoding = g_objLandingDialog.find('input[type="radio"][name="reencoding"]');
		var objDecordingPermission = g_objLandingDialog.find('input[type="radio"][name="decordingpermission"]');

		var htConfigData = new Hashtable();
		htConfigData.put("forcedterminationflag", objForcedTermination.filter(':checked').val());
		htConfigData.put("forcedterminationpwd", objForcedTerminationPwd.val());
		htConfigData.put("reencodingflag", objReEncoding.filter(':checked').val());
		htConfigData.put("decordingpermissionflag", objDecordingPermission.filter(':checked').val());

		var postData = getRequestSaveLandingSetupConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
				'<%=(String)session.getAttribute("COMPANYID")%>',
				htConfigData);

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
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("주요 정책 설정 정보 저장", "주요 정책 설정 정보 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
// 					displayInfoDialog("주요 정책 설정 정보 저장", "정상 처리되었습니다.", "정상적으로 주요 정책 설정 정보가 저장되었습니다.");
					g_objLandingDialog.dialog('close');
<%	if (ChangeFirstPasswordState.CHANGE_FIRST_PASSWORD_STATE_NONE.equals((String) session.getAttribute("CHANGEFIRSTPASSWORDFLAG"))) { %>
					location.href = "/manage/account/admin_manage/manage.jsp";
<% } %>
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("주요 정책 설정 정보 저장", "주요 정책 설정 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateLandingSetupData = function() {

		var objForcedTermination = g_objLandingDialog.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objLandingDialog.find('input[name="forcedterminationpwd"]');
		var objReEncoding = g_objLandingDialog.find('input[type="radio"][name="reencoding"]');
		var objDecordingPermission = g_objLandingDialog.find('input[type="radio"][name="decordingpermission"]');

		if ((objForcedTermination.filter(':checked').val() == null) || (objForcedTermination.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "강제종료 차단 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objForcedTermination.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objForcedTerminationPwd.val().length == 0) {
					displayAlertDialog("입력 오류", "에이전트 종료 인증번호를 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objForcedTerminationPwd, PARAM_TYPE_ALPHANUMERIC, "에이전트 종료 인증번호", PARAM_PLAIN_PWD_MIN_LEN, PARAM_PLAIN_PWD_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objReEncoding.filter(':checked').val() == null) || (objReEncoding.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "복호화된 파일에 대한 재암호화 여부를 선택해주세요.", "");
			return false;
		}

		if ((objDecordingPermission.filter(':checked').val() == null) || (objDecordingPermission.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "암호화된 파일에 대한 복호화 허용 유무를 선택해주세요.", "");
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-landing" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="form-contents">
			<div class="category-title">일반 정책</div>
			<div class="category-contents" style="padding: 20px;">
				<div class="category-sub-title">강제종료 차단 설정</div>
				<div class="category-sub-contents">
					<div class="info">
						<ul class="infolist">
							<li>사용자가 비즈세이퍼 에이전트를 로그오프하거나 삭제할 수 있도록 허용할지 결정합니다.</li>
							<li>업무상 불가피한 경우를 제외하고 ‘예’ 를 통해 보안을 강화하는게 좋습니다.</li>
						</ul>
					</div>
					<div class="field-line">
						<div>사용자의 프로그램 강제 종료를 차단하도록 설정하시겠습니까?&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="forcedtermination" value="1">예</label>&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="forcedtermination" value="0" checked>아니오</label>
						</div>
					</div>
					<div id="row-forcedterminationpwd" class="field-line sub-option" style="display: none;">
						<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>인증 번호:&nbsp;
						<input type="text" id="forcedterminationpwd" name="forcedterminationpwd" class="text ui-widget-content" style="width: 120px;" />
					</div>
				</div>
				<div class="category-sub-title" style="margin-top: 20px;">복호화 파일의 재암호화 설정</div>
				<div class="category-sub-contents">
					<div class="info">
						<ul class="infolist">
							<li>이 기능은 관리자 페이지에서 설정할 수 없으며 향후 변경시 지원팀을 통해 처리가능합니다.</li>
							<li>사용자가 복호화한 파일을 그대로 방치할 경우 유출의 우려가 있어 10분 후 재 암호화하는 기능입니다.</li>
							<li>업무 구조상 복호화 상태를 유지하시려면 ‘아니오’를 선택해 주십시요.</li>
						</ul>
					</div>
					<div>복호화된 파일에 대해 재암호화하도록 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="reencoding" value="1" checked>예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="reencoding" value="0">아니오</label>
					</div>
				</div>
				<div class="category-sub-title" style="margin-top: 20px;">암호화된 파일의 복호화 권한 설정</div>
				<div class="category-sub-contents">
					<div class="info">
						<ul class="infolist">
							<li>사용자가 필요시 “복호화 사유”를 남기고 스스로 파일을 복호화 할 수 있습니다.</li>
							<li>보안상 사용자에게 결재를 통해 파일을 복호화하도록 통제하기 원하시면 ‘아니오’를 선택하십시요.</li>
						</ul>
					</div>
					<div>사용자에게 암호화된 파일에 대한 복호화를 허용하도록 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="decordingpermission" value="1" checked>예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="decordingpermission" value="0">아니오</label>
					</div>
				</div>
			</div>
			<div class="category-title" style="margin-top:20px;">매체/ 네트워크</div>
			<div class="category-contents" style="padding: 20px;">
				<div class="field-line">
					매체 (USB/ CDROM) 사용통제 및 로그, 네트워크(브라우저, 메신저) 파일첨부 차단 또는 로그 수집 등의 정책을 [ 관리 &gt; 에이전트 관리 &gt; 에이전트 설정 ] 에서 설정할 수 있습니다.
				</div>
				<div class="field-line">
					기본적 정책은 ‘아니오’ 입니다.
				</div>
			</div>
			<div class="category-title" style="margin-top:20px;">워터마크</div>
			<div class="category-contents" style="padding: 20px;">
				<div class="field-line">
					프린터 출력시 워터마크를 지정할 수 있습니다. 해당 정책은 관리자 페이지 [ 관리 &gt; 에이전트 관리&gt; 에이전트 설정 ] 기능에서 설정할 수 있습니다.
				</div>
				<div class="field-line">
					기본 정책은 ‘아니오’ 입니다.
				</div>
			</div>
			<div class="category-title" style="margin-top:20px;">문서보안</div>
			<div class="category-contents" style="padding: 20px;">
				<div class="field-line">
					이 기능은 한번 설정하면 향후 기능을 사용하지 않거나 변경하기에 사용중인 파일 복호화 등 신중한 검토가 필요하므로 아래 내용에 따라 검토가 필요합니다. ( 필요시 지원팀 문의 )
				</div>
				<div class="field-line">
					기본모드(AD): 모든 문서가 암호화되어 승인이나 공식적인 반출외에 기업의 정보가 유출되는 것을 원천적으로 차단하는 기능입니다. (DRM)
				</div>
				<div class="field-line">
					간편모드(SEA): 개인정보가 포함된 파일만 암호화되며 문서 작업시 자동 암/복호화 처리됩니다.
				</div>
				<div style="margin-top: 15px;">
					<div class="category-sub-title">문서보안 (기본모드)</div>
					<div class="category-sub-contents">
						<table class="info-table" style="table-layout: auto;">
						<thead>
						<tr>
							<th class="ui-state-default">문서종류 (버전)</th>
							<th class="ui-state-default">암복호화</th>
							<th class="ui-state-default">외부반출 (메일 등)</th>
							<th class="ui-state-default">제약사항</th>
						</tr>
						</thead>
						<tbody>
						<tr class="list_odd">
							<td style="text-align: left;">MS 오피스 (전체)</td>
							<td>문서 생성 및 저장시 자동으로 암호화 문서 열기 자동복호화</td>
							<td>복호화 필요 (정책에 따라 결재처리)</td>
							<td style="text-align: left;">MS 오피스 프로그램이 아닌 다른 프로그램에서 파일 읽을 수 없음 (예, 메일, 웹 그룹웨어 내용보기, 내용검색)</td>
						</tr>
						<tr class="list_even">
							<td style="text-align: left;">아래한글</td>
							<td>상동</td>
							<td>상동</td>
							<td style="text-align: left;">한글 프로그램이 아닌 다른 프로그램에서 파일 읽을 수 없음</td>
						</tr>
						<tr class="list_odd">
							<td style="text-align: left;">PDF</td>
							<td>상동</td>
							<td>상동</td>
							<td style="text-align: left;">Adobe PDF 외에 암호화 파일 읽을 수 없음 (다른 PDF 리더 사용시 사용 문의)</td>
						</tr>
						<tr class="list_even">
							<td style="text-align: left;">포토샵/일러스트</td>
							<td>상동</td>
							<td>상동</td>
							<td style="text-align: left;">이미지 파일로 (내보내기)저장시 해당 이미지 파일 (png, bmp, gif, jpg) 암호화는 옵션으로 처리<br />* 이미지가 암호화되면 – 웹이나 기타 이클립스 등 다지안/웹 개발 툴에서 직접 사용이 불가하며 복호화해서 사용해야 함</td>
						</tr>
						<tr class="list_odd">
							<td style="text-align: left;">CAD (AutoCAD 외)</td>
							<td>상동</td>
							<td>상동</td>
							<td style="text-align: left;">CAD 종류 및 응용 Tool (2D, 3D) 적용에 대해 사전 문의 및 적용검토 필요<br />* CAD 도면을 이미지로 내보낼 경우 암호화 여부는 정책 (암호화 되면 사전 지정 검토된 프로그램 이외에 이미지 볼 수 없음)</td>
						</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="field-line" style="margin-top: 15px;">
					간편모드는 MS 오피스, 한글, PDF 에서 개인정보가 포함될 경우만 암호화되며 해당 프로그램으로 오픈시 자동 복호화되지만 다른 프로그램에서 해당 파일 사용시 복호화를 원칙으로 합니다.
				</div>
				<div class="field-line">
					네트워크 공유 폴더에서 직접 사용을 권장하지 않음 (느리거나 무결성 보장 어려움)
				</div>
				<div class="field-line">
					파일 용량이 커질경우 파일 열기/ 저장시 10% 내외의 속도저하 발생할 수 있음
				</div>
			</div>
		</div>
	</div>
</div>
