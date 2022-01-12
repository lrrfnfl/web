<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="saveconfigconfirm-dialog.jsp"%>
<%@ include file ="managewatermarkbackgroundimage-dialog.jsp"%>
<%@ include file ="uploadwatermarkbackgroundimage-dialog.jsp"%>
<%@ include file ="reservedwordinfo-dialog.jsp"%>
<style>
	#tab-networkservicecontrolprogram > .ui-widget-header { 
		border: none;
		background: #aaa url(/js/jquery-ui-1.10.3/css/custom-theme/images/ui-bg_highlight-soft_75_e0e0e0_1x100.png) 50% 50% repeat-x;
		border-top-left-radius: 0px;
		border-top-right-radius: 0px;
		border-bottom-left-radius: 0px;
		border-bottom-right-radius: 0px;
	}
</style>
<script type="text/javascript">
<!--
	var g_htOptionTypeList = new Hashtable();
	var g_htJobProcessingTypeList = new Hashtable();
	var g_htControlTypeList = new Hashtable();
	var g_htPrintModeList = new Hashtable();
	var g_htPrintLimitTypeList = new Hashtable();
	var g_htPrintMaskingTypeList = new Hashtable();
	var g_htFontStyleList = new Hashtable();
	var g_htFontNameList = new Hashtable();

	var g_objOrganizationTree;

	var g_objTabDefaultConfig;
	var g_objTabPatternConfig;
	var g_objTabPrintControlConfig;
	var g_objTabWaterMarkConfig;
	var g_objTabMediaControlConfig;
	var g_objTabNetworkServiceControlConfig;
	var g_objTabSystemControlConfig;
	var g_objTabWorkControlConfig;

	var g_objTabEmail;
	var g_objTabFtp;
	var g_objTabP2p;
	var g_objTabMessenger;
	var g_objTabCapture;
	var g_objTabEtc;

	var TAB_EMAIL = 0;
	var TAB_FTP = 1;
	var TAB_P2P = 2;
	var TAB_MESSENGER = 3;
	var TAB_CAPTURE = 4;
	var TAB_ETC = 5;

	var g_selectedConfigTabIndex = TAB_DEFAULT_CONFIG;
	var g_selectedProgramTypeTabIndex = TAB_EMAIL;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');

		g_objTabDefaultConfig = $('#tab-defaultconfig');
		g_objTabPatternConfig = $('#tab-patternconfig');
		g_objTabPrintControlConfig = $('#tab-printcontrolconfig');
		g_objTabWaterMarkConfig = $('#tab-watermarkconfig');
		g_objTabMediaControlConfig = $('#tab-mediacontrolconfig');
		g_objTabNetworkServiceControlConfig = $('#tab-networkservicecontrolconfig');
		g_objTabSystemControlConfig = $('#tab-systemcontrolconfig');
		g_objTabWorkControlConfig = $('#tab-workcontrolconfig');

		g_objTabEmail = g_objTabNetworkServiceControlConfig.find('#tab-email');
		g_objTabFtp = g_objTabNetworkServiceControlConfig.find('#tab-ftp');
		g_objTabP2p = g_objTabNetworkServiceControlConfig.find('#tab-p2p');
		g_objTabMessenger = g_objTabNetworkServiceControlConfig.find('#tab-messenger');
		g_objTabCapture = g_objTabNetworkServiceControlConfig.find('#tab-capture');
		g_objTabEtc = g_objTabNetworkServiceControlConfig.find('#tab-etc');

		$( document).tooltip({
			content: function() {
				return $(this).attr('title');
			}
		});

		$(".job-processing-active-count-spinner").spinner({
			min: 1,
			max: 50,
			step: 1,
			numberFormat: "n",
			change: function( event, ui) {
				var min = $(this).spinner('option', 'min');
				var max = $(this).spinner('option', 'max');

				if (isNaN($(this).val())) {
					$(this).spinner("value", min);
				} else if ($(this).val() > max) {
					$(this).spinner("value", max);
				} else if ($(this).val() < min) {
					$(this).spinner("value", min);
				} else {
					$(this).spinner("value", parseInt($(this).val()));
				}
			}
		});

		$("#sizepercentspinner").spinner({
			disabled: true,
			min: 50,
			max: 500,
			step: 5,
			numberFormat: "C",
			change: function( event, ui) {
				var spinnerValue = $(this).spinner('value');
				var orgWidth = g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimagewidth"]').val();
				var orgHeight = g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimageheight"]').val();

				if (spinnerValue == 100) {
					g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]').val(orgWidth);
					g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]').val(orgHeight);
				} else {
					g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]').val(Math.floor(orgWidth*spinnerValue/100));
					g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]').val(Math.floor(orgHeight*spinnerValue/100));
				}

			}
		});

		$(".password-spinner").spinner({
			min: 0,
			max: 50,
			step: 1,
			numberFormat: "n",
			change: function( event, ui) {
				var min = $(this).spinner('option', 'min');
				var max = $(this).spinner('option', 'max');

				if (isNaN($(this).val())) {
					$(this).spinner("value", min);
				} else if ($(this).val() > max) {
					$(this).spinner("value", max);
				} else if ($(this).val() < min) {
					$(this).spinner("value", min);
				} else {
					$(this).spinner("value", parseInt($(this).val()));
				}
			}
		});

		$('button').button();
		$('button[name="btnResetConfig"]').button({ icons: {primary: "ui-icon-arrowreturnthick-1-w"} });
		$('button[name="btnSaveConfig"]').button({ icons: {primary: "ui-icon-disk"} });
		$('button[name="btnDeleteExclusionSearchFolder"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnAddExclusionSearchFolder"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDeleteProgram"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnSelectProgram"]').button({ icons: {primary: "ui-icon-check"} });
		$('button[name="btnAddProgram"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDeleteBlockUrl"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnAddBlockUrl"]').button({ icons: {primary: "ui-icon-circle-plus"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htJobProcessingTypeList = loadTypeList("JOB_PROCESSING_TYPE");
		if (g_htJobProcessingTypeList.isEmpty()) {
			displayAlertDialog("검출파일 처리 유형 조회", "검출파일 처리 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htControlTypeList = loadTypeList("CONTROL_TYPE");
		if (g_htControlTypeList.isEmpty()) {
			displayAlertDialog("제어 유형 조회", "제어 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htPrintModeList = loadTypeList("PRINT_MODE");
		if (g_htPrintModeList.isEmpty()) {
			displayAlertDialog("출력 모드 유형 조회", "출력 모드 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htPrintLimitTypeList = loadTypeList("PRINT_LIMIT_TYPE");
		if (g_htPrintLimitTypeList.isEmpty()) {
			displayAlertDialog("출력 제한 유형 조회", "출력 제한 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htPrintMaskingTypeList = loadTypeList("PRINT_MASKING_TYPE");
		if (g_htPrintMaskingTypeList.isEmpty()) {
			displayAlertDialog("출력 마스킹 유형 조회", "출력 마스킹 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htFontStyleList = loadTypeList("FONT_STYLE");
		if (g_htFontStyleList.isEmpty()) {
			displayAlertDialog("출력 모드 유형 조회", "출력 모드 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htFontNameList = loadFontList();

		initControl();

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSaveConfig') {
				if (g_objOrganizationTree.find(".jstree-checked").length == 0) {
					displayAlertDialog("설정 저장 대상 오류", $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보를 저장할 대상을 선택해 주세요.", '');
					return false;
				}
				openSaveConfigConfirmDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "설정된 값으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보를 저장하시겠습니까?");
			} else if ($(this).attr('id') == 'btnReservedWordInfo') {
				openReservedWordInfoDialog();
			} else if ($(this).attr('id') == 'btnManageBackgroundImage') {
				openManageWaterMarkBackgroundImageDialog();
			} else if ($(this).attr('id') == 'btnAddExclusionSearchFolder') {
				addExclusionSearchFolderToList();
			} else if ($(this).attr('id') == 'btnDeleteExclusionSearchFolder') {
				deleteExclusionSearchFolderFromList();
			} else if ($(this).attr('id') == 'btnSelectProgram') {
				selectProgramToList();
			} else if ($(this).attr('id') == 'btnDeleteProgram') {
				deleteProgramFromList();
			} else if ($(this).attr('id') == 'btnAddProgram') {
				addProgramToList();
			} else if ($(this).attr('id') == 'btnAddBlockUrl') {
				addBlockUrlToList();
			} else if ($(this).attr('id') == 'btnDeleteBlockUrl') {
				deleteBlockUrlFromList();
			}
		});

		$('input[type="radio"]').change( function(event) {
			if ($(this).filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
				$(this).closest('.field-line').siblings().each( function() {
					$(this).show();
				});
			} else {
				$(this).closest('.field-line').siblings().each( function() {
					$(this).hide();
				});
			}
		});

		g_objTabDefaultConfig.find('select[name="jobprocessingtype"]').change( function() {
			if ($(this).val() == '<%=JobProcessingType.JOB_PROCESSING_TYPE_DELETE%>') {
				displayAlertDialog('검출파일 처리 유형 설정 확인', '검출파일 처리 유형을 "삭제"로 설정할 경우, 개인정보가 검출된 파일은 삭제되어 복구할 수 없습니다.', '');
			}
		});

		$('select[name="programlist"]').click( function() {
			if ($(this).children('option').filter(":selected").length == 1) {
				$(this).closest('.tab-contents').find('#newprogramname').val($(this).children('option').filter(":selected").text());
				$(this).closest('.tab-contents').find('#newfilename').val($(this).children('option').filter(":selected").val());
			}
		});

		$(document).on("keyup", "input.numeric", function() { $(this).val($(this).val().replace(/[^\d]/,'')); });
		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table thead tr th:first-child", function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });	
		$(document).on("click", ".list-table tbody tr", function(e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; });
		$(document).on("click", "#tab-networkservicecontrolconfig .list-table tbody tr td:nth-child(4)", function (e) { e.stopPropagation(); });	
	});

	loadFontList = function(companyId) {

		var g_htList = new Hashtable();
		var postData = getRequestFontListParam();

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("폰트 리스트 조회", "폰트 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					if (!g_htList.isEmpty()) g_htList.clear();
					$(data).find('font').each( function() {
						g_htList.put($(this).find('name').text(), $(this).find('name').text());
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("폰트 리스트 조회", "폰트 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
		return g_htList;
	};

	loadNetworkServiceControlProgram = function() {

		var postData = getRequestNetworkServiceControlProgramListParam('',
				'',
				'PROGRAMTYPE, PROGRAMNAME',
				'ASC',
				'',
				'');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("네트워크 서비스 제어 프로그램 리스트 조회", "네트워크 서비스 제어 프로그램 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				g_objTabEmail.find('#programlist').empty();
				g_objTabFtp.find('#programlist').empty();
				g_objTabP2p.find('#programlist').empty();
				g_objTabMessenger.find('#programlist').empty();
				g_objTabCapture.find('#programlist').empty();
				g_objTabEtc.find('#programlist').empty();

				$(data).find('record').each( function() {
					var programName = $(this).find('programname').text();
					var fileName = $(this).find('filename').text();
					var programType = $(this).find('programtype').text();

					var objOption = new Option(programName, fileName);
					$(objOption).html(programName);

					if (programType == "<%=ProgramType.PROGRAM_TYPE_EMAIL%>") {
						g_objTabEmail.find('#programlist').append(objOption);
					} else if (programType == "<%=ProgramType.PROGRAM_TYPE_FTP%>") {
						g_objTabFtp.find('#programlist').append(objOption);
					} else if (programType == "<%=ProgramType.PROGRAM_TYPE_P2P%>") {
						g_objTabP2p.find('#programlist').append(objOption);
					} else if (programType == "<%=ProgramType.PROGRAM_TYPE_MESSENGER%>") {
						g_objTabMessenger.find('#programlist').append(objOption);
					} else if (programType == "<%=ProgramType.PROGRAM_TYPE_CAPTURE%>") {
						g_objTabCapture.find('#programlist').append(objOption);
					} else if (programType == "<%=ProgramType.PROGRAM_TYPE_ETC%>") {
						g_objTabEtc.find('#programlist').append(objOption);
					}
				});

				$('#tab-networkservicecontrolprogram').tabs({
					hide: {
						duration: 200
					},
					activate: function(event, ui) {
						g_selectedProgramTypeTabIndex = ui.newTab.index();
					}
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 프로그램 리스트 조회", "네트워크 서비스 제어 프로그램 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadCompanyNode = function(companyId) {

		var nodeData = ""; 
		var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', companyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					var startTag = "<root>";
					var endTag = "</root>";
					nodeData = new XMLSerializer().serializeToString(data);
					nodeData = nodeData.substr(nodeData.indexOf(startTag), nodeData.lastIndexOf(endTag)-nodeData.indexOf(startTag)+endTag.length);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return nodeData;
	};

	loadOrganizationTreeView = function() {

		var xmlTreeData = '';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		xmlTreeData += '<root>';
		xmlTreeData += '<item id="root" node_type="root" state="closed">';
		xmlTreeData += '<content><name><![CDATA[전체 사업장]]></name></content>';
		xmlTreeData += '</item>';
		xmlTreeData += '</root>';
<% } else { %>
		xmlTreeData = loadCompanyNode('<%=(String)session.getAttribute("COMPANYID")%>');
<% } %>

		g_objOrganizationTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = '<%=OptionType.OPTION_TYPE_YES%>';
							if (node.attr("node_type") == 'company_category') {
								var categoryCode = node.children('a').text().trim();
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', categoryCode, '');
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'company') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), '', includeUserNodes);
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'dept') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), node.attr('deptcode'), includeUserNodes);
								return {
									sendmsg : postData
								};
							} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', '');
<% } else { %>
								var postData = getRequestDeptTreeNodesParam('<%=(String)session.getAttribute("COMPANYID")%>', '', includeUserNodes);
<% } %>
								return {
									sendmsg : postData
								};
							}
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
						}
					}
				}
			},
			"themes": {
				"theme": "<%=(String)session.getAttribute("THEMENAME")%>",
				"dots": true,
				"icons": false
			},
			"ui": {
				"select_limit": 1,
				"select_multiple_modifier": "none"
			},
			"types": {
				"AM": {
					"hover_node": false,
					"select_node": false
				},
				"AF": {
					"hover_node": false,
					"select_node": false
				},
				"Role": {
				// i dont know if possible to be done here? add class?
				// this.css("color", "red")
				//{ font-weight:bold}
				}
			},
			"contextmenu" : {
				"items" : null
			},
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu", "checkbox" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
			data.inst._get_node('ul > li:first').children('a').first().find('.jstree-checkbox').hide();
<% } %>
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('load_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if (($(this).attr('node_type') == "company") || ($(this).attr('node_type') == "user")) {
					if ($(this).attr('servicestate') == <%=ServiceState.SERVICE_STATE_STOP%>) {
						if (!$(this).find('a').first().hasClass('state-abnormal')) {
							$(this).find('a').first().addClass('state-abnormal');
						}
					} else {
						if (!$(this).find('a').first().hasClass('state-abnormal')) {
							$(this).find('a').first().removeClass('state-abnormal');
						}
					}
				}
			});
		}).bind('open_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if ($(this).attr('node_type') == "company_category") {
					$(this).children('a').first().find('.jstree-checkbox').hide();
				} else {
					if (data.inst.is_checked($(this))) {
						if (!data.inst.is_open($(this))) {
							data.inst.open_node($(this));
						}
					}
				}
			});
		}).bind('check_node.jstree', function (event, data) {
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			} else {
				data.rslt.obj.find("li > a").each( function() {
				//data.inst._get_children(data.rslt.obj).each( function() {
					if (!data.inst.is_open($(this))) {
						data.inst.open_node($(this));
					} else {
						expandChilds($(this));
					}
				});
			}
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
// 			if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
// 				if (!data.inst.is_checked(data.rslt.obj)) {
// 					data.inst.check_node(data.rslt.obj);
// 				}
// 			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') != "company_category") {
					if (data.rslt.obj.attr('node_type') == 'company') {
						$('.inner-center .pane-header').text('사업장 설정 정보 - [' + data.inst.get_text(data.rslt.obj) + ']');
					} else if (data.rslt.obj.attr('node_type') == 'dept') {
						$('.inner-center .pane-header').text('부서 설정 정보 - [' + data.inst.get_text(data.rslt.obj) + ']');
					} else if (data.rslt.obj.attr("node_type") == "user") {
						$('.inner-center .pane-header').text('사용자 설정 정보 - [' + data.inst.get_text(data.rslt.obj) + ']');
					} else {
						$('.inner-center .pane-header').text('기본 설정 정보');
					}
					loadConfig();
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
		});
	};

	function expandChilds(node) {
		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		objTreeReference._get_children(node).each( function() {
			if (objTreeReference.is_checked($(this))) {
				if (!objTreeReference.is_open($(this))) {
					objTreeReference.open_node($(this));
				}
			}
		});
	};

	function loadConfig() {
		if (g_selectedConfigTabIndex == TAB_DEFAULT_CONFIG) {
			loadDefaultConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_PATTERN_CONFIG) {
			loadPatternConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_PRINT_CONTROL_CONFIG) {
			loadPrintControlConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_WATERMARK_CONFIG) {
			loadWaterMarkConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_MEDIA_CONTROL_CONFIG) {
			loadMediaControlConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_NETWORKSERVICE_CONTROL_CONFIG) {
			loadNetworkServiceControlConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_SYSTEM_CONTROL_CONFIG) {
			loadSystemControlConfigInfo();
		} else if (g_selectedConfigTabIndex == TAB_WORK_CONTROL_CONFIG) {
			loadWorkControlConfigInfo();
		}
	};

	loadDefaultConfigInfo = function() {

		var objJobProcessingType = g_objTabDefaultConfig.find('select[name="jobprocessingtype"]');
		var objForcedTermination = g_objTabDefaultConfig.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objTabDefaultConfig.find('input[name="forcedterminationpwd"]');
		var objDecordingPermission = g_objTabDefaultConfig.find('input[type="radio"][name="decordingpermission"]');
		var objSafeExport = g_objTabDefaultConfig.find('input[type="radio"][name="safeexport"]');
		var objContentCopyPrevention = g_objTabDefaultConfig.find('input[type="radio"][name="contentcopyprevention"]');
		var objRealtimeObservation = g_objTabDefaultConfig.find('input[type="radio"][name="realtimeobservation"]');
		var objPasswordExpirationFlag = g_objTabDefaultConfig.find('input[type="radio"][name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objTabDefaultConfig.find('input[name="passwordexpirationperiod"]');
		var objExpiration = g_objTabDefaultConfig.find('input[type="radio"][name="expiration"]');
		var objExpirationPeriod = g_objTabDefaultConfig.find('input[name="expirationperiod"]');
		var objExpirationJobProcessingType = g_objTabDefaultConfig.find('select[name="expirationjobprocessingtype"]');
		var objUseServerOcrFlag = g_objTabDefaultConfig.find('input[type="radio"][name="useserverocrflag"]');
		var objOcrServerIpAddress = g_objTabDefaultConfig.find('input[name="ocrserveripaddress"]');
		var objOcrServerPort = g_objTabDefaultConfig.find('input[name="ocrserverport"]');
		var objExclusionSearchFolderList = g_objTabDefaultConfig.find('#exclusionsearchfolderlist');

		var objRowForcedTerminationPwd = g_objTabDefaultConfig.find('#row-forcedterminationpwd');
		var objRowPasswordExpirationPeriod = g_objTabDefaultConfig.find('#row-passwordexpirationperiod');
		var objRowExpirationPeriod = g_objTabDefaultConfig.find('#row-expirationperiod');
		var objRowExpirationJobProcessingType = g_objTabDefaultConfig.find('#row-expirationjobprocessingtype');
		var objRowOcrServerIpAddress = g_objTabDefaultConfig.find('#row-ocrserveripaddress');
		var objRowOcrServerPort = g_objTabDefaultConfig.find('#row-ocrserverport');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyDefaultConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptDefaultConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserDefaultConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyDefaultConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("기본 설정 정보 조회", "기본 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var jobProcessingType = $(data).find('jobprocessingtype').text();
				var forcedTerminationFlag = $(data).find('forcedterminationflag').text();
				var forcedTerminationPwd = $(data).find('forcedterminationpwd').text();
				var decordingPermissionFlag = $(data).find('decordingpermissionflag').text();
				var safeExportFlag = $(data).find('safeexportflag').text();
				var contentCopyPreventionFlag = $(data).find('contentcopypreventionflag').text();
				var realtimeObservationFlag = $(data).find('realtimeobservationflag').text();
				var passwordExpirationFlag = $(data).find('passwordexpirationflag').text();
				var passwordExpirationPeriod = $(data).find('passwordexpirationperiod').text();
				var expirationFlag = $(data).find('expirationflag').text();
				var expirationPeriod = $(data).find('expirationperiod').text();
				var expirationJobProcessingType = $(data).find('expirationjobprocessingtype').text();
				var useServerOcrFlag = $(data).find('useserverocrflag').text();
				var ocrServerIpAddress = $(data).find('ocrserveripaddress').text();
				var ocrServerPort = $(data).find('ocrserverport').text();

				objJobProcessingType.val(jobProcessingType);

				objForcedTermination.prop('checked', false);
				objForcedTermination.filter('[value=' + forcedTerminationFlag + ']').prop('checked', true);

				objForcedTerminationPwd.val(forcedTerminationPwd);
				if (forcedTerminationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowForcedTerminationPwd.show();
				} else {
					objRowForcedTerminationPwd.hide();
				}

				objDecordingPermission.prop('checked', false);
				objDecordingPermission.filter('[value=' + decordingPermissionFlag + ']').prop('checked', true);

				objSafeExport.prop('checked', false);
				objSafeExport.filter('[value=' + safeExportFlag + ']').prop('checked', true);

				objContentCopyPrevention.prop('checked', false);
				objContentCopyPrevention.filter('[value=' + contentCopyPreventionFlag + ']').prop('checked', true);

				objRealtimeObservation.prop('checked', false);
				objRealtimeObservation.filter('[value=' + realtimeObservationFlag + ']').prop('checked', true);

				if (passwordExpirationFlag.length > 0) {
					objPasswordExpirationFlag.prop('checked', false);
					objPasswordExpirationFlag.filter('[value=' + passwordExpirationFlag + ']').prop('checked', true);
					objPasswordExpirationPeriod.val(passwordExpirationPeriod);
					if (passwordExpirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
						objRowPasswordExpirationPeriod.show();
					} else {
						objRowPasswordExpirationPeriod.hide();
					}
				}

				if (expirationFlag.length > 0) {
					objExpiration.prop('checked', false);
					objExpiration.filter('[value=' + expirationFlag + ']').prop('checked', true);
					objExpirationPeriod.val(expirationPeriod);
					objExpirationJobProcessingType.val(expirationJobProcessingType);
					if (expirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
						objRowExpirationPeriod.show();
						objRowExpirationJobProcessingType.show();
					} else {
						objRowExpirationPeriod.hide();
						objRowExpirationJobProcessingType.hide();
					}
				}

				if (useServerOcrFlag.length > 0) {
					objUseServerOcrFlag.prop('checked', false);
					objUseServerOcrFlag.filter('[value=' + useServerOcrFlag + ']').prop('checked', true);
					objOcrServerIpAddress.val(ocrServerIpAddress);
					objOcrServerPort.val(ocrServerPort);
					if (useServerOcrFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
						objRowOcrServerIpAddress.show();
						objRowOcrServerPort.show();
					} else {
						objRowOcrServerIpAddress.hide();
						objRowOcrServerPort.hide();
					}
				}

				var tableHtml = '';
				tableHtml += '<table class="list-table">';
				tableHtml += '<thead>';
				tableHtml += '<tr>';
				tableHtml += '<th width="40" class="ui-state-default" style="text-align: center;">';
				tableHtml += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur();">';
				tableHtml += '</th>';
				tableHtml += '<th class="ui-state-default">폴더 경로</th>';
				tableHtml += '</tr>';
				tableHtml += '</thead>';

				tableHtml += '<tbody>';
				$(data).find('exclusionsearchfolderlist').find('folder').each( function(index) {
					var lineStyle = '';
					if (index%2 == 0)
						lineStyle = "list_odd";
					else
						lineStyle = "list_even";

					tableHtml += '<tr class="' + lineStyle + '">';
					tableHtml += '<td style="text-align: center;"><input type="checkbox" name="selectfolder" exclusionsearchfolderpath="' + $(this).find('path').text() + '" style="border: 0;"></td>';
					tableHtml += '<td>' + $(this).find('path').text() + '</td>';
					tableHtml += '</tr>';
				});
				tableHtml += '</tbody>';
				tableHtml += '</table>';

				objExclusionSearchFolderList.html(tableHtml);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("기본 설정 정보 조회", "기본 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadPatternConfigInfo = function() {

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyPatternConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptPatternConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserPatternConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyPatternConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("패턴 설정 정보 조회", "패턴 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				var beforePatternId = "";
				var recordCount = 1;
				var tableColumnCount = 0;

				if ($(data).find('pattern').length > 0) {

					$(data).find('pattern').each( function() {
						var patternId = $(this).find('patternid').text();
						var patternCategoryName = $(this).find('patterncategoryname').text();
						var patternSubId = $(this).find('patternsubid').text();
						var patternName = $(this).find('patternname').text();
						var defaultSearchFlag = $(this).find('defaultsearchflag').text();
						var jobProcessingActiveCount = $(this).find('jobprocessingactivecount').text();

						if (beforePatternId.length == 0) {
							if (recordCount == 1) {
								htmlContents += '<div class="category-pattern" style="margin-bottom: 5px;">';
								htmlContents += '<div class="category-sub-title">';
								htmlContents += '<div style="float: left; margin-top: 4px;">';
								htmlContents += '<label class="checkbox"><input type="checkbox" name="checkAll" patternid="' + patternId + '" onFocus="this.blur();" />' + patternCategoryName + '</label>';
								htmlContents += '</div>';
								htmlContents += '<div style="float: right;">';
								htmlContents += '처리 활성화 수: <input id="jobprocessingactivecount" name="jobprocessingactivecount" value="' + jobProcessingActiveCount + '" class="job-processing-active-count-spinner" style="width: 40px; font-size:0.9em; text-align: right;" /> 건';
								htmlContents += '</div>';
								htmlContents += '<div class="clear"></div>';
								htmlContents += '</div>';
								htmlContents += '<div class="category-sub-contents">';
								htmlContents += '<table class="list-table">';
								htmlContents += '<tbody>';
								htmlContents += '<tr>';
							} else if (tableColumnCount == 0) {
								htmlContents += '</tr>';
								htmlContents += '<tr>';
							}
						} else if (beforePatternId != patternId) {
							if (tableColumnCount != 0) {
								htmlContents += '<td colspan="' + (5 - tableColumnCount) + '">&nbsp;</td>';
							}
							htmlContents += '</tr>';
							htmlContents += '</tbody>';
							htmlContents += '</table>';
							htmlContents += '</div>';
							htmlContents += '</div>';
							htmlContents += '<div class="category-pattern" style="margin-bottom: 5px;">';
							htmlContents += '<div class="category-sub-title">';
							htmlContents += '<div style="float: left; margin-top: 4px;">';
							htmlContents += '<label class="checkbox"><input type="checkbox" name="checkAll" patternid="' + patternId + '" onFocus="this.blur();" />' + patternCategoryName + '</label>';
							htmlContents += '</div>';
							htmlContents += '<div style="float: right;">';
							htmlContents += '처리 활성화 수: <input id="jobprocessingactivecount" name="jobprocessingactivecount" value="' + jobProcessingActiveCount + '" class="job-processing-active-count-spinner" style="width: 40px; font-size:0.9em; text-align: right;" /> 건';
							htmlContents += '</div>';
							htmlContents += '<div class="clear"></div>';
							htmlContents += '</div>';
							htmlContents += '<div class="category-sub-contents">';
							htmlContents += '<table class="list-table">';
							htmlContents += '<tbody>';
							htmlContents += '<tr>';

							tableColumnCount = 0;
						} else {
							if (tableColumnCount == 0) {
								htmlContents += '</tr>';
								htmlContents += '<tr>';
							}
						}

						if (defaultSearchFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
							htmlContents += '<td width="20%" style="text-align: left;"><label class="checkbox"><input type="checkbox" name="checkboxpattern" patternid="' + patternId + '" patternsubid="' + patternSubId + '" onFocus="this.blur()" checked>' + patternName + '</label></td>';
						} else {
							htmlContents += '<td width="20%" style="text-align: left;"><label class="checkbox"><input type="checkbox" name="checkboxpattern" patternid="' + patternId + '" patternsubid="' + patternSubId + '" onFocus="this.blur()">' + patternName + '</label></td>';
						}

						beforePatternId = patternId;
						recordCount++;
						tableColumnCount = (tableColumnCount + 1) % 5;
					});

					if (tableColumnCount != 0) {
						htmlContents += '<td colspan="' + (5 - tableColumnCount) + '">&nbsp;</td>';
					}
					htmlContents += '</tr>';
					htmlContents += '</tbody>';
					htmlContents += '</table>';
					htmlContents += '</div>';
					htmlContents += '</div>';

					g_objTabPatternConfig.find('#patterninfo').html(htmlContents);

					$(".job-processing-active-count-spinner").spinner({
						min: 1,
						max: 50,
						step: 1,
						numberFormat: "n",
						change: function( event, ui) {
							var min = $(this).spinner('option', 'min');
							var max = $(this).spinner('option', 'max');

							if (isNaN($(this).val())) {
								$(this).spinner("value", min);
							} else if ($(this).val() > max) {
								$(this).spinner("value", max);
							} else if ($(this).val() < min) {
								$(this).spinner("value", min);
							} else {
								$(this).spinner("value", parseInt($(this).val()));
							}
						}
					});

					var inlineScriptText = "";
					inlineScriptText += "g_objTabPatternConfig.find('#patterninfo .category-sub-title input:checkbox').click( function () { var checkState = $(this).is(':checked'); $(this).closest('.category-pattern').find('.list-table input:checkbox').each( function () { $(this).prop('checked', checkState); }); });";
					inlineScriptText += "g_objTabPatternConfig.find('#patterninfo .category-sub-contents input:checkbox').click( function () { if ($(this).is(':checked')) { if ($(this).closest('table').find('input:checkbox').length == $(this).closest('table').find('input:checkbox').filter(':checked').length) { $(this).closest('.category-pattern').find('.category-sub-title input:checkbox').prop('checked', true); } } else { $(this).closest('.category-pattern').find('.category-sub-title input:checkbox').prop('checked', false); } });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					g_objTabPatternConfig.find('#patterninfo').append(inlineScript);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 설정 정보 조회", "패턴 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadPrintControlConfigInfo = function() {

		var objPrintControlFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printcontrolflag"]');
		var objPrintLimitFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printlimitflag"]');
		var objPrintLimitType = g_objTabPrintControlConfig.find('select[name="printlimittype"]');
		var objPrintLimitCount = g_objTabPrintControlConfig.find('input[name="printlimitcount"]');
		var objMaskingFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="maskingflag"]');
		var objMaskingType = g_objTabPrintControlConfig.find('select[name="maskingtype"]');
		var objJuminSexNotMaskingFlag = g_objTabPrintControlConfig.find('input[type="checkbox"][name="juminsexnotmaskingflag"]');
		var objLogCollectorIpAddress = g_objTabPrintControlConfig.find('input[name="logcollectoripaddress"]');
		var objLogCollectorPortNo = g_objTabPrintControlConfig.find('input[name="logcollectorportno"]');
		var objLogCollectorAccountId = g_objTabPrintControlConfig.find('input[name="logcollectoraccountid"]');
		var objLogCollectorAccountPwd = g_objTabPrintControlConfig.find('input[name="logcollectoraccountpwd"]');

		var objRowPrintLimitType = g_objTabPrintControlConfig.find('#row-printlimittype');
		var objRowMaskingType = g_objTabPrintControlConfig.find('#row-maskingtype');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyPrintControlConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptPrintControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserPrintControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyPrintControlConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("출력 제어 설정 정보 조회", "출력 제어 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var printControlFlag = $(data).find('printcontrolflag').text();
				var printLimitFlag = $(data).find('printlimitflag').text();
				var printLimitType = $(data).find('printlimittype').text();
				var printLimitCount = $(data).find('printlimitcount').text();
				var maskingFlag = $(data).find('maskingflag').text();
				var maskingType = $(data).find('maskingtype').text();
				var juminSexNotMaskingFlag = $(data).find('juminsexnotmaskingflag').text();
				var logCollectorIpAddress = $(data).find('logcollectoripaddress').text();
				var logCollectorPortNo = $(data).find('logcollectorportno').text();
				var logCollectorAccountId = $(data).find('logcollectoraccountid').text();
				var logCollectorAccountPwd = $(data).find('logcollectoraccountpwd').text();

				objPrintControlFlag.prop('checked', false);
				objPrintControlFlag.filter('[value=' + printControlFlag + ']').prop('checked', true);
				objPrintLimitFlag.prop('checked', false);
				objPrintLimitFlag.filter('[value=' + printLimitFlag + ']').prop('checked', true);
				objPrintLimitType.val(printLimitType);
				objPrintLimitCount.val(printLimitCount);
				if (printLimitFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowPrintLimitType.show();
				} else {
					objRowPrintLimitType.hide();
				}
				objMaskingFlag.prop('checked', false);
				objMaskingFlag.filter('[value=' + maskingFlag + ']').prop('checked', true);
				objMaskingType.val(maskingType);
				if (maskingFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowMaskingType.show();
				} else {
					objRowMaskingType.hide();
				}
				if (juminSexNotMaskingFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
					objJuminSexNotMaskingFlag.prop('checked', true);
				} else {
					objJuminSexNotMaskingFlag.prop('checked', false);
				}
				objLogCollectorIpAddress.val(logCollectorIpAddress);
				objLogCollectorPortNo.val(logCollectorPortNo);
				objLogCollectorAccountId.val(logCollectorAccountId);
				objLogCollectorAccountPwd.val(logCollectorAccountPwd);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("출력 제어 설정 정보 조회", "출력 제어 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadWaterMarkConfigInfo = function() {

		var objWmPrintMode = g_objTabWaterMarkConfig.find('select[name="wmprintmode"]');
		var objWm3StepWaterMark = g_objTabWaterMarkConfig.find('select[name="wm3stepwatermark"]');
		var objWmTextRepeatSize = g_objTabWaterMarkConfig.find('select[name="wmtextrepeatsize"]');
		var objWmOutlineMode = g_objTabWaterMarkConfig.find('select[name="wmoutlinemode"]');
		var objWmPrintTime = g_objTabWaterMarkConfig.find('select[name="wmprinttime"]');
		var objWmTextMain = g_objTabWaterMarkConfig.find('input[name="wmtextmain"]');
		var objWmTextSub = g_objTabWaterMarkConfig.find('input[name="wmtextsub"]');
		var objWmTextTopLeft = g_objTabWaterMarkConfig.find('input[name="wmtexttopleft"]');
		var objWmTextTopRight = g_objTabWaterMarkConfig.find('input[name="wmtexttopright"]');
		var objWmTextBottomLeft = g_objTabWaterMarkConfig.find('input[name="wmtextbottomleft"]');
		var objWmTextBottomRight = g_objTabWaterMarkConfig.find('input[name="wmtextbottomright"]');
		var objWmMainFontName = g_objTabWaterMarkConfig.find('select[name="wmmainfontname"]');
		var objWmMainFontSize = g_objTabWaterMarkConfig.find('select[name="wmmainfontsize"]');
		var objWmMainFontStyle = g_objTabWaterMarkConfig.find('select[name="wmmainfontstyle"]');
		var objWmSubFontName = g_objTabWaterMarkConfig.find('select[name="wmsubfontname"]');
		var objWmSubFontSize = g_objTabWaterMarkConfig.find('select[name="wmsubfontsize"]');
		var objWmSubFontStyle = g_objTabWaterMarkConfig.find('select[name="wmsubfontstyle"]');
		var objWmTextFontName = g_objTabWaterMarkConfig.find('select[name="wmtextfontname"]');
		var objWmTextFontSize = g_objTabWaterMarkConfig.find('select[name="wmtextfontsize"]');
		var objWmTextFontStyle = g_objTabWaterMarkConfig.find('select[name="wmtextfontstyle"]');
		var objWmFontMainAngle = g_objTabWaterMarkConfig.find('input[name="wmfontmainangle"]');
		var objWmFontDensityMain = g_objTabWaterMarkConfig.find('select[name="wmfontdensitymain"]');
		var objWmFontDensityText = g_objTabWaterMarkConfig.find('select[name="wmfontdensitytext"]');
		var objWmBackgroundMode = g_objTabWaterMarkConfig.find('select[name="wmbackgroundmode"]');
		var objWmBackgroundImage = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]');
		var objWmBackgroundImageFileName = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagefilename"]');
		var objWmBackgroundPositionX = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositionx"]');
		var objWmBackgroundPositionY = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositiony"]');
		var objWmBackgroundImageWidth = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]');
		var objWmBackgroundImageHeight = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]');
		var objOrgWmBackgroundImageWidth = g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimagewidth"]');
		var objOrgWmBackgroundImageHeight = g_objTabWaterMarkConfig.find('input[name="orgwmbackgroundimageheight"]');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyWaterMarkConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptWaterMarkConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserWaterMarkConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyWaterMarkConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("워터마크 설정 정보 조회", "워터마크 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var wmPrintMode = $(data).find('wmprintmode').text();
				var wm3StepWaterMark = $(data).find('wm3stepwatermark').text();
				var wmTextRepeatSize = $(data).find('wmtextrepeatsize').text();
				var wmOutlineMode = $(data).find('wmoutlinemode').text();
				var wmPrintTime = $(data).find('wmprinttime').text();
				var wmTextMain = $(data).find('wmtextmain').text();
				var wmTextSub = $(data).find('wmtextsub').text();
				var wmTextTopLeft = $(data).find('wmtexttopleft').text();
				var wmTextTopRight = $(data).find('wmtexttopright').text();
				var wmTextBottomLeft = $(data).find('wmtextbottomleft').text();
				var wmTextBottomRight = $(data).find('wmtextbottomright').text();
				var wmMainFontName = $(data).find('wmmainfontname').text();
				var wmMainFontSize = $(data).find('wmmainfontsize').text();
				var wmMainFontStyle = $(data).find('wmmainfontstyle').text();
				var wmSubFontName = $(data).find('wmsubfontname').text();
				var wmSubFontSize = $(data).find('wmsubfontsize').text();
				var wmSubFontStyle = $(data).find('wmsubfontstyle').text();
				var wmTextFontName = $(data).find('wmtextfontname').text();
				var wmTextFontSize = $(data).find('wmtextfontsize').text();
				var wmTextFontStyle = $(data).find('wmtextfontstyle').text();
				var wmFontMainAngle = $(data).find('wmfontmainangle').text();
				var wmFontDensityMain = $(data).find('wmfontdensitymain').text();
				var wmFontDensityText = $(data).find('wmfontdensitytext').text();
				var wmBackgroundMode = $(data).find('wmbackgroundmode').text();
				var wmBackgroundImage = $(data).find('wmbackgroundimage').text();
				var wmBackgroundPositionX = $(data).find('wmbackgroundpositionx').text();
				var wmBackgroundPositionY = $(data).find('wmbackgroundpositiony').text();
				var wmBackgroundImageWidth = $(data).find('wmbackgroundimagewidth').text();
				var wmBackgroundImageHeight = $(data).find('wmbackgroundimageheight').text();

				objWmPrintMode.val(wmPrintMode);
				objWm3StepWaterMark.val(wm3StepWaterMark);
				objWmTextRepeatSize.val(wmTextRepeatSize);
				objWmOutlineMode.val(wmOutlineMode);
				objWmPrintTime.val(wmPrintTime);
				objWmTextMain.val(wmTextMain);
				objWmTextSub.val(wmTextSub);
				objWmTextTopLeft.val(wmTextTopLeft);
				objWmTextTopRight.val(wmTextTopRight);
				objWmTextBottomLeft.val(wmTextBottomLeft);
				objWmTextBottomRight.val(wmTextBottomRight);
				objWmMainFontName.val(wmMainFontName);
				objWmMainFontSize.val(wmMainFontSize);
				objWmMainFontStyle.val(wmMainFontStyle);
				objWmSubFontName.val(wmSubFontName);
				objWmSubFontSize.val(wmSubFontSize);
				objWmSubFontStyle.val(wmSubFontStyle);
				objWmTextFontName.val(wmTextFontName);
				objWmTextFontSize.val(wmTextFontSize);
				objWmTextFontStyle.val(wmTextFontStyle);
				objWmFontMainAngle.val(wmFontMainAngle);
				objWmFontDensityMain.val(wmFontDensityMain);
				objWmFontDensityText.val(wmFontDensityText);
				objWmBackgroundMode.val(wmBackgroundMode);
				objWmBackgroundImage.val(wmBackgroundImage);
				var pathArray = wmBackgroundImage.split("/");
				var wmBackgroundImageFileName = pathArray[pathArray.length - 1];
				objWmBackgroundImageFileName.val(wmBackgroundImageFileName);
				objWmBackgroundPositionX.val(wmBackgroundPositionX);
				objWmBackgroundPositionY.val(wmBackgroundPositionY);
				objWmBackgroundImageWidth.val(wmBackgroundImageWidth);
				objWmBackgroundImageHeight.val(wmBackgroundImageHeight);
				objOrgWmBackgroundImageWidth.val(wmBackgroundImageWidth);
				objOrgWmBackgroundImageHeight.val(wmBackgroundImageHeight);

				if (wmBackgroundImage.length > 0) {
					g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('enable');
				} else {
					g_objTabWaterMarkConfig.find('#sizepercentspinner').spinner('disable');
				}
				if ((selectedNode.attr("node_type") == 'company') ||
					(selectedNode.attr("node_type") == 'dept') ||
					(selectedNode.attr("node_type") == "user")) {
					$('button[name="btnManageBackgroundImage"]').show();
				} else {
					$('button[name="btnManageBackgroundImage"]').hide();
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("워터마크 설정 정보 조회", "워터마크 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadMediaControlConfigInfo = function() {

		var objUsbControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="usbcontrolflag"]');
		var objUsbControlType = g_objTabMediaControlConfig.find('select[name="usbcontroltype"]');
		var objCdRomControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="cdromcontrolflag"]');
		var objCdRomControlType = g_objTabMediaControlConfig.find('select[name="cdromcontroltype"]');
		var objPublicFolderControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="publicfoldercontrolflag"]');
		var objPublicFolderControlType = g_objTabMediaControlConfig.find('select[name="publicfoldercontroltype"]');

		var objRowUsbControlType = g_objTabMediaControlConfig.find('#row-usbcontroltype');
		var objRowCdRomControlType = g_objTabMediaControlConfig.find('#row-cdromcontroltype');
		var objRowPublicFolderControlType = g_objTabMediaControlConfig.find('#row-publicfoldercontroltype');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyMediaControlConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptMediaControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserMediaControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyMediaControlConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("매체 제어 설정 정보 조회", "매체 제어 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var usbControlFlag = $(data).find('usbcontrolflag').text();
				var usbControlType = $(data).find('usbcontroltype').text();
				var cdRomControlFlag = $(data).find('cdromcontrolflag').text();
				var cdRomControlType = $(data).find('cdromcontroltype').text();
				var publicFolderControlFlag = $(data).find('publicfoldercontrolflag').text();
				var publicFolderControlType = $(data).find('publicfoldercontroltype').text();

				objUsbControlFlag.prop('checked', false);
				objUsbControlFlag.filter('[value=' + usbControlFlag + ']').prop('checked', true);

				objUsbControlType.val(usbControlType);
				if (usbControlFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowUsbControlType.show();
				} else {
					objRowUsbControlType.hide();
				}

				objCdRomControlFlag.prop('checked', false);
				objCdRomControlFlag.filter('[value=' + cdRomControlFlag + ']').prop('checked', true);

				objCdRomControlType.val(cdRomControlType);
				if (cdRomControlFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowCdRomControlType.show();
				} else {
					objRowCdRomControlType.hide();
				}

				objPublicFolderControlFlag.prop('checked', false);
				objPublicFolderControlFlag.filter('[value=' + publicFolderControlFlag + ']').prop('checked', true);

				objPublicFolderControlType.val(publicFolderControlType);
				if (publicFolderControlFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowPublicFolderControlType.show();
				} else {
					objRowPublicFolderControlType.hide();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("매체 제어 설정 정보 조회", "매체 제어 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadNetworkServiceControlConfigInfo = function() {

		var objNetworkServiceControlFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="networkservicecontrolflag"]');
		var objEmailSelectedProgramList = g_objTabEmail.find('#selectedprogramlist');
		var objFtpSelectedProgramList = g_objTabFtp.find('#selectedprogramlist');
		var objP2pSelectedProgramList = g_objTabP2p.find('#selectedprogramlist');
		var objMessengerSelectedProgramList = g_objTabMessenger.find('#selectedprogramlist');
		var objCaptureSelectedProgramList = g_objTabCapture.find('#selectedprogramlist');
		var objEtcSelectedProgramList = g_objTabEtc.find('#selectedprogramlist');
		var objBlockSpecificUrlsFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="blockspecificurlsflag"]');
		var objBlockSpecificUrlsList = g_objTabNetworkServiceControlConfig.find('#blockspecificurlslist');

		var objRowNetworkServiceControlProgram = g_objTabNetworkServiceControlConfig.find('#row-networkservicecontrolprogram');
		var objRowBlockSpecificUrls = g_objTabNetworkServiceControlConfig.find('#row-blockspecificurls');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyNetworkServiceControlConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptNetworkServiceControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserNetworkServiceControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyNetworkServiceControlConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("네트워크 서비스 제어 설정 정보 조회", "네트워크 서비스 제어 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var networkControlServiceFlag = $(data).find('networkservicecontrolflag').text();
				var blockSpecificUrlsFlag = $(data).find('blockspecificurlsflag').text();

				objNetworkServiceControlFlag.prop('checked', false);
				objNetworkServiceControlFlag.filter('[value=' + networkControlServiceFlag + ']').prop('checked', true);

				if (networkControlServiceFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowNetworkServiceControlProgram.show();
				} else {
					objRowNetworkServiceControlProgram.hide();
				}

				var tableHeader = '';
				tableHeader += '<table class="list-table">';
				tableHeader += '<thead>';
				tableHeader += '<tr>';
				tableHeader += '<th width="40" class="ui-state-default" style="text-align: center;">';
				tableHeader += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur()">';
				tableHeader += '</th>';
				tableHeader += '<th class="ui-state-default">프로그램 명</th>';
				tableHeader += '<th class="ui-state-default">파일 명</th>';
				tableHeader += '<th width="110" class="ui-state-default">제어 유형</th>';
				tableHeader += '</tr>';
				tableHeader += '</thead>';

				var tableTail = '</table>';

				var recordCount = 1;
				var lineStyle = '';

				var tableBody = '<tbody>';
				$(data).find('emailprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td title=' + $(this).find('programname').text() + '>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td title=' + $(this).find('filename').text() + '>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objEmailSelectedProgramList.html(tableHeader + tableBody + tableTail);

				recordCount = 1;
				lineStyle = '';
				tableBody = '<tbody>';
				$(data).find('ftpprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objFtpSelectedProgramList.html(tableHeader + tableBody + tableTail);

				recordCount = 1;
				lineStyle = '';
				tableBody = '<tbody>';
				$(data).find('p2pprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objP2pSelectedProgramList.html(tableHeader + tableBody + tableTail);

				recordCount = 1;
				lineStyle = '';
				tableBody = '<tbody>';
				$(data).find('messengerprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objMessengerSelectedProgramList.html(tableHeader + tableBody + tableTail);

				recordCount = 1;
				lineStyle = '';
				tableBody = '<tbody>';
				$(data).find('captureprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objCaptureSelectedProgramList.html(tableHeader + tableBody + tableTail);

				recordCount = 1;
				lineStyle = '';
				tableBody = '<tbody>';
				$(data).find('etcprogramlist').find('program').each( function() {
					if (recordCount%2 == 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";

					tableBody += '<tr class="' + lineStyle + '">';
					tableBody += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + $(this).find('programname').text() + '" filename="' + $(this).find('filename').text() + '" style="border: 0;"></td>';
					tableBody += '<td>' + $(this).find('programname').text() + '</td>';
					tableBody += '<td>' + $(this).find('filename').text() + '</td>';
					tableBody += '<td>';
					tableBody += '<select id="controltype" name="controltype">';
					var controlType = $(this).find('controltype').text();
					if (!g_htControlTypeList.isEmpty()) {
						g_htControlTypeList.each( function(value, name) {
							if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
									(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
								if (value == controlType) {
									tableBody += '<option value="' + value + '" selected>' + name + '</option>';
								} else {
									tableBody += '<option value="' + value + '">' + name + '</option>';
								}
							}
						});
					}
					tableBody += '</select>';
					tableBody += '</td>';
					tableBody += '</tr>';

					recordCount++;
				});
				tableBody += '</tbody>';

				objEtcSelectedProgramList.html(tableHeader + tableBody + tableTail);

				objBlockSpecificUrlsFlag.prop('checked', false);
				objBlockSpecificUrlsFlag.filter('[value=' + blockSpecificUrlsFlag + ']').prop('checked', true);

				var tableHtml = '';
				tableHtml += '<table class="list-table">';
				tableHtml += '<thead>';
				tableHtml += '<tr>';
				tableHtml += '<th width="40" class="ui-state-default" style="text-align: center;">';
				tableHtml += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur();">';
				tableHtml += '</th>';
				tableHtml += '<th class="ui-state-default">차단 URL</th>';
				tableHtml += '</tr>';
				tableHtml += '</thead>';

				tableHtml += '<tbody>';
				$(data).find('blockspecificurlslist').find('blockspecificurls').each( function(index) {
					var lineStyle = '';
					if (index%2 == 0)
						lineStyle = "list_odd";
					else
						lineStyle = "list_even";

					tableHtml += '<tr class="' + lineStyle + '">';
					tableHtml += '<td style="text-align: center;"><input type="checkbox" name="selecturl" blockurl="' + $(this).find('blockurl').text() + '" style="border: 0;"></td>';
					tableHtml += '<td>' + $(this).find('blockurl').text() + '</td>';
					tableHtml += '</tr>';
				});
				tableHtml += '</tbody>';
				tableHtml += '</table>';

				objBlockSpecificUrlsList.html(tableHtml);

				if (blockSpecificUrlsFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
					objRowBlockSpecificUrls.show();
				} else {
					objRowBlockSpecificUrls.hide();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("네트워크 서비스 제어 설정 정보 조회", "네트워크 서비스 제어 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadSystemControlConfigInfo = function() {

		var objSystemPasswordSetupFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordsetupflag"]');
		var objSystemPasswordMinLength = g_objTabSystemControlConfig.find('#systempasswordminlength');
		var objSystemPasswordMaxLength = g_objTabSystemControlConfig.find('#systempasswordmaxlength');
		var objSystemPasswordExpirationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordexpirationflag"]');
		var objSystemPasswordExpirationPeriod = g_objTabSystemControlConfig.find('select[name="systempasswordexpirationperiod"]');
		var objScreenSaverActivationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="screensaveractivationflag"]');
		var objScreenSaverWaitingMinutes = g_objTabSystemControlConfig.find('select[name="screensaverwaitingminutes"]');

		var objRowSystemPasswordMinLength = g_objTabSystemControlConfig.find('#row-systempasswordminlength');
		var objRowSystemPasswordMaxLength = g_objTabSystemControlConfig.find('#row-systempasswordmaxlength');
		var objRowSystemPasswordExpirationPeriod = g_objTabSystemControlConfig.find('#row-systempasswordexpirationperiod');
		var objRowScreenSaverWaitingMinutes = g_objTabSystemControlConfig.find('#row-screensaverwaitingminutes');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanySystemControlConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptSystemControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserSystemControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanySystemControlConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("시스템 제어 설정 정보 조회", "시스템 제어 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var systemPasswordSetupFlag = $(data).find('systempasswordsetupflag').text();
				var systemPasswordMinLength = $(data).find('systempasswordminlength').text();
				var systemPasswordMaxLength = $(data).find('systempasswordmaxlength').text();
				var systemPasswordExpirationFlag = $(data).find('systempasswordexpirationflag').text();
				var systemPasswordExpirationPeriod = $(data).find('systempasswordexpirationperiod').text();
				var screenSaverActivationFlag = $(data).find('screensaveractivationflag').text();
				var screenSaverWaitingMinutes = $(data).find('screensaverwaitingminutes').text();

				objSystemPasswordSetupFlag.prop('checked', false);
				objSystemPasswordSetupFlag.filter('[value=' + systemPasswordSetupFlag + ']').prop('checked', true);
				//objSystemPasswordMinLength.val(systemPasswordMinLength);
				objSystemPasswordMinLength.spinner("value", systemPasswordMinLength);
				//objSystemPasswordMaxLength.val(systemPasswordMaxLength);
				objSystemPasswordMaxLength.spinner("value", systemPasswordMaxLength);
				if (systemPasswordSetupFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowSystemPasswordMinLength.show();
					objRowSystemPasswordMaxLength.show();
				} else {
					objRowSystemPasswordMinLength.hide();
					objRowSystemPasswordMaxLength.hide();
				}
				objSystemPasswordExpirationFlag.prop('checked', false);
				objSystemPasswordExpirationFlag.filter('[value=' + systemPasswordExpirationFlag + ']').prop('checked', true);
				objSystemPasswordExpirationPeriod.val(systemPasswordExpirationPeriod);
				//objSystemPasswordExpirationPeriod.spinner("value", systemPasswordExpirationPeriod);
				if (systemPasswordExpirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowSystemPasswordExpirationPeriod.show();
				} else {
					objRowSystemPasswordExpirationPeriod.hide();
				}
				objScreenSaverActivationFlag.prop('checked', false);
				objScreenSaverActivationFlag.filter('[value=' + screenSaverActivationFlag + ']').prop('checked', true);
				objScreenSaverWaitingMinutes.val(screenSaverWaitingMinutes);
				//objScreenSaverWaitingMinutes.spinner("value", screenSaverWaitingMinutes);
				if (screenSaverActivationFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
					objRowScreenSaverWaitingMinutes.show();
				} else {
					objRowScreenSaverWaitingMinutes.hide();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("시스템 제어 설정 정보 조회", "시스템 제어 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadWorkControlConfigInfo = function() {

		var objSystemStartHours = g_objTabWorkControlConfig.find('select[name="systemstarthours"]');
		var objSystemStartMinutes = g_objTabWorkControlConfig.find('select[name="systemstartminutes"]');
		var objSystemEndHours = g_objTabWorkControlConfig.find('select[name="systemendhours"]');
		var objSystemEndMinutes = g_objTabWorkControlConfig.find('select[name="systemendminutes"]');
		var objWorkStartHours = g_objTabWorkControlConfig.find('select[name="workstarthours"]');
		var objWorkStartMinutes = g_objTabWorkControlConfig.find('select[name="workstartminutes"]');
		var objWorkEndHours = g_objTabWorkControlConfig.find('select[name="workendhours"]');
		var objWorkEndMinutes = g_objTabWorkControlConfig.find('select[name="workendminutes"]');
		var objAlertSystemEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertsystemendalarmflag"]');
		var objSystemEndAlarmStart = g_objTabWorkControlConfig.find('select[name="systemendalarmstart"]');
		var objSystemEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="systemendalarminterval"]');
		var objAlertWorkEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertworkendalarmflag"]');
		var objWorkEndAlarmStart = g_objTabWorkControlConfig.find('select[name="workendalarmstart"]');
		var objWorkEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="workendalarminterval"]');
		var objLockWhenIdleFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="lockwhenidleflag"]');
		var objIdleTimeForLock = g_objTabWorkControlConfig.find('select[name="idletimeforlock"]');
		var objPermitExtendedWorkFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="permitextendedworkflag"]');

		var objRowSystemEndAlarmStart = g_objTabWorkControlConfig.find('#row-systemendalarmstart');
		var objRowSystemEndAlarmInterval = g_objTabWorkControlConfig.find('#row-systemendalarminterval');
		var objRowWorkEndAlarmStart = g_objTabWorkControlConfig.find('#row-workendalarmstart');
		var objRowWorkEndAlarmInterval = g_objTabWorkControlConfig.find('#row-workendalarminterval');
		var objRowIdleTimeForLock = g_objTabWorkControlConfig.find('#row-idletimeforlock');

		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		var selectedNode = objTreeReference.get_selected();

		var postData =  "";
		if (selectedNode.attr("node_type") == 'company') {
			postData = getRequestCompanyWorkControlConfigInfoParam(selectedNode.attr('companyid'));
		} else if (selectedNode.attr("node_type") == 'dept') {
			postData = getRequestDeptWorkControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('deptcode'));
		} else if (selectedNode.attr("node_type") == "user") {
			postData = getRequestUserWorkControlConfigInfoParam(selectedNode.attr('companyid'), selectedNode.attr('userid'));
		} else {
			postData = getRequestCompanyWorkControlConfigInfoParam("");
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('#tab-agentconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-agentconfig .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("업무 설정 설정 정보 조회", "업무 설정 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var systemStartTime = $(data).find('systemstarttime').text();
				var systemEndTime = $(data).find('systemendtime').text();
				var workStartTime = $(data).find('workstarttime').text();
				var workEndTime = $(data).find('workendtime').text();
				var alertSystemEndAlarmFlag = $(data).find('alertsystemendalarmflag').text();
				var systemEndAlarmStart = $(data).find('systemendalarmstart').text();
				var systemEndAlarmInterval = $(data).find('systemendalarminterval').text();
				var alertWorkEndAlarmFlag = $(data).find('alertworkendalarmflag').text();
				var workEndAlarmStart = $(data).find('workendalarmstart').text();
				var workEndAlarmInterval = $(data).find('workendalarminterval').text();
				var lockWhenIdleFlag = $(data).find('lockwhenidleflag').text();
				var idleTimeForLock = $(data).find('idletimeforlock').text();
				var permitExtendedWorkFlag = $(data).find('permitextendedworkflag').text();

				var arrSystemStartTime = systemStartTime.split(':');
				var systemStartHours = arrSystemStartTime[0];
				var systemStartMinutes = arrSystemStartTime[1];
				var arrSystemEndTime = systemEndTime.split(':');
				var systemEndHours = arrSystemEndTime[0];
				var systemEndMinutes = arrSystemEndTime[1];
				var arrWorkStartTime = workStartTime.split(':');
				var workStartHours = arrWorkStartTime[0];
				var workStartMinutes = arrWorkStartTime[1];
				var arrWorkEndTime = workEndTime.split(':');
				var workEndHours = arrWorkEndTime[0];
				var workEndMinutes = arrWorkEndTime[1];

				objSystemStartHours.val(systemStartHours);
				objSystemStartMinutes.val(systemStartMinutes);
				objSystemEndHours.val(systemEndHours);
				objSystemEndMinutes.val(systemEndMinutes);
				objWorkStartHours.val(workStartHours);
				objWorkStartMinutes.val(workStartMinutes);
				objWorkEndHours.val(workEndHours);
				objWorkEndMinutes.val(workEndMinutes);

				objAlertSystemEndAlarmFlag.prop('checked', false);
				objAlertSystemEndAlarmFlag.filter('[value=' + alertSystemEndAlarmFlag + ']').prop('checked', true);
				objSystemEndAlarmStart.val(systemEndAlarmStart);
				objSystemEndAlarmInterval.val(systemEndAlarmInterval);
				if (alertSystemEndAlarmFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowSystemEndAlarmStart.show();
					objRowSystemEndAlarmInterval.show();
				} else {
					objRowSystemEndAlarmStart.hide();
					objRowSystemEndAlarmInterval.hide();
				}

				objAlertWorkEndAlarmFlag.prop('checked', false);
				objAlertWorkEndAlarmFlag.filter('[value=' + alertWorkEndAlarmFlag + ']').prop('checked', true);
				objWorkEndAlarmStart.val(workEndAlarmStart);
				objWorkEndAlarmInterval.val(workEndAlarmInterval);
				if (alertWorkEndAlarmFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowWorkEndAlarmStart.show();
					objRowWorkEndAlarmInterval.show();
				} else {
					objRowWorkEndAlarmStart.hide();
					objRowWorkEndAlarmInterval.hide();
				}

				objLockWhenIdleFlag.prop('checked', false);
				objLockWhenIdleFlag.filter('[value=' + lockWhenIdleFlag + ']').prop('checked', true);
				objIdleTimeForLock.val(idleTimeForLock);
				if (lockWhenIdleFlag == "<%=OptionType.OPTION_TYPE_YES%>") {
					objRowIdleTimeForLock.show();
				} else {
					objRowIdleTimeForLock.hide();
				}

				objPermitExtendedWorkFlag.prop('checked', false);
				objPermitExtendedWorkFlag.filter('[value=' + permitExtendedWorkFlag + ']').prop('checked', true);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("업무 설정 설정 정보 조회", "업무 설정 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		if (g_selectedConfigTabIndex == TAB_DEFAULT_CONFIG) {
			if (validateDefaultConfigData()) {
				saveDefaultConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_PATTERN_CONFIG) {
			savePatternConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
		} else if (g_selectedConfigTabIndex == TAB_PRINT_CONTROL_CONFIG) {
			if (validatePrintControlConfigData()) {
				savePrintControlConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_WATERMARK_CONFIG) {
			if (validateWaterMarkConfigData()) {
				saveWaterMarkConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_MEDIA_CONTROL_CONFIG) {
			if (validateMediaControlConfigData()) {
				saveMediaControlConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_NETWORKSERVICE_CONTROL_CONFIG) {
			if (validateNetworkServiceControlConfigData()) {
				saveNetworkServiceControlConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_SYSTEM_CONTROL_CONFIG) {
			if (validateSystemControlConfigData()) {
				saveSystemControlConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		} else if (g_selectedConfigTabIndex == TAB_WORK_CONTROL_CONFIG) {
			if (validateWorkControlConfigData()) {
				saveWorkControlConfig(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig);
			}
		}
	};

	saveDefaultConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objJobProcessingType = g_objTabDefaultConfig.find('select[name="jobprocessingtype"]');
		var objForcedTermination = g_objTabDefaultConfig.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objTabDefaultConfig.find('input[name="forcedterminationpwd"]');
		var objDecordingPermission = g_objTabDefaultConfig.find('input[type="radio"][name="decordingpermission"]');
		var objSafeExport = g_objTabDefaultConfig.find('input[type="radio"][name="safeexport"]');
		var objContentCopyPrevention = g_objTabDefaultConfig.find('input[type="radio"][name="contentcopyprevention"]');
		var objRealtimeObservation = g_objTabDefaultConfig.find('input[type="radio"][name="realtimeobservation"]');
		var objPasswordExpirationFlag = g_objTabDefaultConfig.find('input[type="radio"][name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objTabDefaultConfig.find('input[name="passwordexpirationperiod"]');
		var objExpiration = g_objTabDefaultConfig.find('input[type="radio"][name="expiration"]');
		var objExpirationPeriod = g_objTabDefaultConfig.find('input[name="expirationperiod"]');
		var objExpirationJobProcessingType = g_objTabDefaultConfig.find('select[name="expirationjobprocessingtype"]');
		var objUseServerOcrFlag = g_objTabDefaultConfig.find('input[type="radio"][name="useserverocrflag"]');
		var objOcrServerIpAddress = g_objTabDefaultConfig.find('input[name="ocrserveripaddress"]');
		var objOcrServerPort = g_objTabDefaultConfig.find('input[name="ocrserverport"]');
		var objExclusionSearchFolderList = g_objTabDefaultConfig.find('#exclusionsearchfolderlist');

		var htDefaultConfigData = new Hashtable();
		htDefaultConfigData.put("jobprocessingtype", objJobProcessingType.val());
		htDefaultConfigData.put("forcedterminationflag", objForcedTermination.filter(':checked').val());
		htDefaultConfigData.put("forcedterminationpwd", objForcedTerminationPwd.val());
		htDefaultConfigData.put("decordingpermissionflag", objDecordingPermission.filter(':checked').val());
		htDefaultConfigData.put("safeexportflag", objSafeExport.filter(':checked').val());
		htDefaultConfigData.put("contentcopypreventionflag", objContentCopyPrevention.filter(':checked').val());
		htDefaultConfigData.put("realtimeobservationflag", objRealtimeObservation.filter(':checked').val());
		htDefaultConfigData.put("passwordexpirationflag", objPasswordExpirationFlag.filter(':checked').val());
		htDefaultConfigData.put("passwordexpirationperiod", objPasswordExpirationPeriod.val());
		htDefaultConfigData.put("expirationflag", objExpiration.filter(':checked').val());
		htDefaultConfigData.put("expirationperiod", objExpirationPeriod.val());
		htDefaultConfigData.put("useserverocrflag", objUseServerOcrFlag.filter(':checked').val());
		htDefaultConfigData.put("ocrserveripaddress", objOcrServerIpAddress.val());
		htDefaultConfigData.put("ocrserverport", objOcrServerPort.val());
		htDefaultConfigData.put("expirationjobprocessingtype", objExpirationJobProcessingType.val());

		var arrExclusionSearchFolderList = new Array();
		objExclusionSearchFolderList.find('.list-table > tbody > tr').each( function () {
			arrExclusionSearchFolderList.push($(this).find('td:eq(1)').text());
		});

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyDefaultConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htDefaultConfigData,
					arrExclusionSearchFolderList);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptDefaultConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htDefaultConfigData,
					arrExclusionSearchFolderList);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserDefaultConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htDefaultConfigData,
					arrExclusionSearchFolderList);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	savePatternConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var arrPatternList = new Array();

		g_objTabPatternConfig.find('#patterninfo input:checkbox[name="checkboxpattern"]').each( function () {
			var arrPattern = new Array();
			arrPattern.push($(this).attr('patternid'));
			arrPattern.push($(this).attr('patternsubid'));
			if ($(this).is(":checked")){
				arrPattern.push("<%=OptionType.OPTION_TYPE_YES%>");
			} else {
				arrPattern.push("<%=OptionType.OPTION_TYPE_NO%>");
			}
			arrPattern.push($(this).closest(".category-pattern").find("#jobprocessingactivecount").spinner("value"));
			arrPatternList.push(arrPattern);
		});

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyPatternConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					arrPatternList);
			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptPatternConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					arrPatternList);
			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserPatternConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					arrPatternList);
			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	savePrintControlConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objPrintControlFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printcontrolflag"]');
		var objPrintLimitFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printlimitflag"]');
		var objPrintLimitType = g_objTabPrintControlConfig.find('select[name="printlimittype"]');
		var objPrintLimitCount = g_objTabPrintControlConfig.find('input[name="printlimitcount"]');
		var objMaskingFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="maskingflag"]');
		var objMaskingType = g_objTabPrintControlConfig.find('select[name="maskingtype"]');
		var objJuminSexNotMaskingFlag = g_objTabPrintControlConfig.find('input[type="checkbox"][name="juminsexnotmaskingflag"]');
		var objLogCollectorIpAddress = g_objTabPrintControlConfig.find('input[name="logcollectoripaddress"]');
		var objLogCollectorPortNo = g_objTabPrintControlConfig.find('input[name="logcollectorportno"]');
		var objLogCollectorAccountId = g_objTabPrintControlConfig.find('input[name="logcollectoraccountid"]');
		var objLogCollectorAccountPwd = g_objTabPrintControlConfig.find('input[name="logcollectoraccountpwd"]');

		var htPrintControlConfigData = new Hashtable();
		htPrintControlConfigData.put("printcontrolflag", objPrintControlFlag.filter(':checked').val());
		htPrintControlConfigData.put("printlimitflag", objPrintLimitFlag.filter(':checked').val());
		htPrintControlConfigData.put("printlimittype", objPrintLimitType.val());
		htPrintControlConfigData.put("printlimitcount", objPrintLimitCount.val());
		htPrintControlConfigData.put("maskingflag", objMaskingFlag.filter(':checked').val());
		htPrintControlConfigData.put("maskingtype", objMaskingType.val());
		var juminSexNotMaskingFlag;
		if(objJuminSexNotMaskingFlag.is(':checked')) {
			juminSexNotMaskingFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		} else {
			juminSexNotMaskingFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		}
		htPrintControlConfigData.put("juminsexnotmaskingflag", juminSexNotMaskingFlag);
		htPrintControlConfigData.put("logcollectoripaddress", objLogCollectorIpAddress.val());
		htPrintControlConfigData.put("logcollectorportno", objLogCollectorPortNo.val());
		htPrintControlConfigData.put("logcollectoraccountid", objLogCollectorAccountId.val());
		htPrintControlConfigData.put("logcollectoraccountpwd", objLogCollectorAccountPwd.val());

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyPrintControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htPrintControlConfigData);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptPrintControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htPrintControlConfigData);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserPrintControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htPrintControlConfigData);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveWaterMarkConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objWmPrintMode = g_objTabWaterMarkConfig.find('select[name="wmprintmode"]');
		var objWm3StepWaterMark = g_objTabWaterMarkConfig.find('select[name="wm3stepwatermark"]');
		var objWmTextRepeatSize = g_objTabWaterMarkConfig.find('select[name="wmtextrepeatsize"]');
		var objWmOutlineMode = g_objTabWaterMarkConfig.find('select[name="wmoutlinemode"]');
		var objWmPrintTime = g_objTabWaterMarkConfig.find('select[name="wmprinttime"]');
		var objWmTextMain = g_objTabWaterMarkConfig.find('input[name="wmtextmain"]');
		var objWmTextSub = g_objTabWaterMarkConfig.find('input[name="wmtextsub"]');
		var objWmTextTopLeft = g_objTabWaterMarkConfig.find('input[name="wmtexttopleft"]');
		var objWmTextTopRight = g_objTabWaterMarkConfig.find('input[name="wmtexttopright"]');
		var objWmTextBottomLeft = g_objTabWaterMarkConfig.find('input[name="wmtextbottomleft"]');
		var objWmTextBottomRight = g_objTabWaterMarkConfig.find('input[name="wmtextbottomright"]');
		var objWmMainFontName = g_objTabWaterMarkConfig.find('select[name="wmmainfontname"]');
		var objWmMainFontSize = g_objTabWaterMarkConfig.find('select[name="wmmainfontsize"]');
		var objWmMainFontStyle = g_objTabWaterMarkConfig.find('select[name="wmmainfontstyle"]');
		var objWmSubFontName = g_objTabWaterMarkConfig.find('select[name="wmsubfontname"]');
		var objWmSubFontSize = g_objTabWaterMarkConfig.find('select[name="wmsubfontsize"]');
		var objWmSubFontStyle = g_objTabWaterMarkConfig.find('select[name="wmsubfontstyle"]');
		var objWmTextFontName = g_objTabWaterMarkConfig.find('select[name="wmtextfontname"]');
		var objWmTextFontSize = g_objTabWaterMarkConfig.find('select[name="wmtextfontsize"]');
		var objWmTextFontStyle = g_objTabWaterMarkConfig.find('select[name="wmtextfontstyle"]');
		var objWmFontMainAngle = g_objTabWaterMarkConfig.find('input[name="wmfontmainangle"]');
		var objWmFontDensityMain = g_objTabWaterMarkConfig.find('select[name="wmfontdensitymain"]');
		var objWmFontDensityText = g_objTabWaterMarkConfig.find('select[name="wmfontdensitytext"]');
		var objWmBackgroundMode = g_objTabWaterMarkConfig.find('select[name="wmbackgroundmode"]');
		var objWmBackgroundImage = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]');
		var objWmBackgroundPositionX = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositionx"]');
		var objWmBackgroundPositionY = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositiony"]');
		var objWmBackgroundImageWidth = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]');
		var objWmBackgroundImageHeight = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]');

		var htWaterMarkConfigData = new Hashtable();
		htWaterMarkConfigData.put("wmprintmode", objWmPrintMode.val());
		htWaterMarkConfigData.put("wm3stepwatermark", objWm3StepWaterMark.val());
		htWaterMarkConfigData.put("wmtextrepeatsize", objWmTextRepeatSize.val());
		htWaterMarkConfigData.put("wmoutlinemode", objWmOutlineMode.val());
		htWaterMarkConfigData.put("wmprinttime", objWmPrintTime.val());
		htWaterMarkConfigData.put("wmtextmain", objWmTextMain.val());
		htWaterMarkConfigData.put("wmtextsub", objWmTextSub.val());
		htWaterMarkConfigData.put("wmtexttopleft", objWmTextTopLeft.val());
		htWaterMarkConfigData.put("wmtexttopright", objWmTextTopRight.val());
		htWaterMarkConfigData.put("wmtextbottomleft", objWmTextBottomLeft.val());
		htWaterMarkConfigData.put("wmtextbottomright", objWmTextBottomRight.val());
		htWaterMarkConfigData.put("wmmainfontname", objWmMainFontName.val());
		htWaterMarkConfigData.put("wmmainfontsize", objWmMainFontSize.val());
		htWaterMarkConfigData.put("wmmainfontstyle", objWmMainFontStyle.val());
		htWaterMarkConfigData.put("wmsubfontname", objWmSubFontName.val());
		htWaterMarkConfigData.put("wmsubfontsize", objWmSubFontSize.val());
		htWaterMarkConfigData.put("wmsubfontstyle", objWmSubFontStyle.val());
		htWaterMarkConfigData.put("wmtextfontname", objWmTextFontName.val());
		htWaterMarkConfigData.put("wmtextfontsize", objWmTextFontSize.val());
		htWaterMarkConfigData.put("wmtextfontstyle", objWmTextFontStyle.val());
		htWaterMarkConfigData.put("wmfontmainangle", objWmFontMainAngle.val());
		htWaterMarkConfigData.put("wmfontdensitymain", objWmFontDensityMain.val());
		htWaterMarkConfigData.put("wmfontdensitytext", objWmFontDensityText.val());
		htWaterMarkConfigData.put("wmbackgroundmode", objWmBackgroundMode.val());
		htWaterMarkConfigData.put("wmbackgroundimage", objWmBackgroundImage.val());
		htWaterMarkConfigData.put("wmbackgroundpositionx", objWmBackgroundPositionX.val());
		htWaterMarkConfigData.put("wmbackgroundpositiony", objWmBackgroundPositionY.val());
		htWaterMarkConfigData.put("wmbackgroundimagewidth", objWmBackgroundImageWidth.val());
		htWaterMarkConfigData.put("wmbackgroundimageheight", objWmBackgroundImageHeight.val());

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyWaterMarkConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htWaterMarkConfigData);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptWaterMarkConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htWaterMarkConfigData);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserWaterMarkConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htWaterMarkConfigData);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveMediaControlConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objUsbControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="usbcontrolflag"]');
		var objUsbControlType = g_objTabMediaControlConfig.find('select[name="usbcontroltype"]');
		var objCdRomControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="cdromcontrolflag"]');
		var objCdRomControlType = g_objTabMediaControlConfig.find('select[name="cdromcontroltype"]');
		var objPublicFolderControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="publicfoldercontrolflag"]');
		var objPublicFolderControlType = g_objTabMediaControlConfig.find('select[name="publicfoldercontroltype"]');

		var htMediaControlConfigData = new Hashtable();
		htMediaControlConfigData.put("usbcontrolflag", objUsbControlFlag.filter(':checked').val());
		htMediaControlConfigData.put("usbcontroltype", objUsbControlType.val());
		htMediaControlConfigData.put("cdromcontrolflag", objCdRomControlFlag.filter(':checked').val());
		htMediaControlConfigData.put("cdromcontroltype", objCdRomControlType.val());
		htMediaControlConfigData.put("publicfoldercontrolflag", objPublicFolderControlFlag.filter(':checked').val());
		htMediaControlConfigData.put("publicfoldercontroltype", objPublicFolderControlType.val());

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyMediaControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htMediaControlConfigData);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptMediaControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htMediaControlConfigData);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserMediaControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htMediaControlConfigData);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveNetworkServiceControlConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objNetworkServiceControlFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="networkservicecontrolflag"]');
		var objBlockSpecificUrlsFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="blockspecificurlsflag"]');
		var objBlockSpecificUrlsList = g_objTabNetworkServiceControlConfig.find('#blockspecificurlslist');

		var htNetworkServiceControlConfigData = new Hashtable();
		htNetworkServiceControlConfigData.put("networkservicecontrolflag", objNetworkServiceControlFlag.filter(':checked').val());
		htNetworkServiceControlConfigData.put("blockspecificurlsflag", objBlockSpecificUrlsFlag.filter(':checked').val());

		var arrEmailControlProgramList = new Array();
		g_objTabEmail.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrEmailControlProgramList.push(arrProgram);
		});

		var arrFtpControlProgramList = new Array();
		g_objTabFtp.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrFtpControlProgramList.push(arrProgram);
		});

		var arrP2pControlProgramList = new Array();
		g_objTabP2p.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrP2pControlProgramList.push(arrProgram);
		});

		var arrMessengerControlProgramList = new Array();
		g_objTabMessenger.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrMessengerControlProgramList.push(arrProgram);
		});

		var arrCaptureControlProgramList = new Array();
		g_objTabCapture.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrCaptureControlProgramList.push(arrProgram);
		});

		var arrEtcControlProgramList = new Array();
		g_objTabEtc.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			var arrProgram = new Array();
			arrProgram.push($(this).find('td:eq(1)').text());
			arrProgram.push($(this).find('td:eq(2)').text());
			arrProgram.push($(this).find('td:eq(3)').find('select[name="controltype"]').val());
			arrEtcControlProgramList.push(arrProgram);
		});

		var arrBlockSpecificUrlsList = new Array();
		objBlockSpecificUrlsList.find('.list-table > tbody > tr').each( function () {
			arrBlockSpecificUrlsList.push($(this).find('td:eq(1)').text());
		});

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyNetworkServiceControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htNetworkServiceControlConfigData,
					arrEmailControlProgramList,
					arrFtpControlProgramList,
					arrP2pControlProgramList,
					arrMessengerControlProgramList,
					arrCaptureControlProgramList,
					arrEtcControlProgramList,
					arrBlockSpecificUrlsList);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptNetworkServiceControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htNetworkServiceControlConfigData,
					arrEmailControlProgramList,
					arrFtpControlProgramList,
					arrP2pControlProgramList,
					arrMessengerControlProgramList,
					arrCaptureControlProgramList,
					arrEtcControlProgramList,
					arrBlockSpecificUrlsList);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserNetworkServiceControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htNetworkServiceControlConfigData,
					arrEmailControlProgramList,
					arrFtpControlProgramList,
					arrP2pControlProgramList,
					arrMessengerControlProgramList,
					arrCaptureControlProgramList,
					arrEtcControlProgramList,
					arrBlockSpecificUrlsList);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveSystemControlConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objSystemPasswordSetupFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordsetupflag"]');
		var objSystemPasswordMinLength = g_objTabSystemControlConfig.find('#systempasswordminlength');
		var objSystemPasswordMaxLength = g_objTabSystemControlConfig.find('#systempasswordmaxlength');
		var objSystemPasswordExpirationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordexpirationflag"]');
		var objSystemPasswordExpirationPeriod = g_objTabSystemControlConfig.find('select[name="systempasswordexpirationperiod"]');
		var objScreenSaverActivationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="screensaveractivationflag"]');
		var objScreenSaverWaitingMinutes = g_objTabSystemControlConfig.find('select[name="screensaverwaitingminutes"]');

		var htSystemControlConfigData = new Hashtable();
		htSystemControlConfigData.put("systempasswordsetupflag", objSystemPasswordSetupFlag.filter(':checked').val());
		htSystemControlConfigData.put("systempasswordminlength", objSystemPasswordMinLength.spinner("value"));
		htSystemControlConfigData.put("systempasswordmaxlength", objSystemPasswordMaxLength.spinner("value"));
		htSystemControlConfigData.put("systempasswordexpirationflag", objSystemPasswordExpirationFlag.filter(':checked').val());
		htSystemControlConfigData.put("systempasswordexpirationperiod", objSystemPasswordExpirationPeriod.val());
		htSystemControlConfigData.put("screensaveractivationflag", objScreenSaverActivationFlag.filter(':checked').val());
		htSystemControlConfigData.put("screensaverwaitingminutes", objScreenSaverWaitingMinutes.val());

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanySystemControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htSystemControlConfigData);

			if (!saveConfigProcess("사업장 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptSystemControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htSystemControlConfigData);

			if (!saveConfigProcess("부서 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserSystemControlConfigParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htSystemControlConfigData);

			if (!saveConfigProcess("사용자 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-clientconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveWorkControlConfig = function(bSaveCompanyConfig, bSaveDeptConfig, bSaveUserConfig) {

		var objSystemStartHours = g_objTabWorkControlConfig.find('select[name="systemstarthours"]');
		var objSystemStartMinutes = g_objTabWorkControlConfig.find('select[name="systemstartminutes"]');
		var objSystemEndHours = g_objTabWorkControlConfig.find('select[name="systemendhours"]');
		var objSystemEndMinutes = g_objTabWorkControlConfig.find('select[name="systemendminutes"]');
		var objWorkStartHours = g_objTabWorkControlConfig.find('select[name="workstarthours"]');
		var objWorkStartMinutes = g_objTabWorkControlConfig.find('select[name="workstartminutes"]');
		var objWorkEndHours = g_objTabWorkControlConfig.find('select[name="workendhours"]');
		var objWorkEndMinutes = g_objTabWorkControlConfig.find('select[name="workendminutes"]');
		var objAlertSystemEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertsystemendalarmflag"]');
		var objSystemEndAlarmStart = g_objTabWorkControlConfig.find('select[name="systemendalarmstart"]');
		var objSystemEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="systemendalarminterval"]');
		var objAlertWorkEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertworkendalarmflag"]');
		var objWorkEndAlarmStart = g_objTabWorkControlConfig.find('select[name="workendalarmstart"]');
		var objWorkEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="workendalarminterval"]');
		var objLockWhenIdleFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="lockwhenidleflag"]');
		var objIdleTimeForLock = g_objTabWorkControlConfig.find('select[name="idletimeforlock"]');
		var objPermitExtendedWorkFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="permitextendedworkflag"]');

		var htWorkControlConfigData = new Hashtable();
		htWorkControlConfigData.put("systemstarttime", objSystemStartHours.val() + ":" + objSystemStartMinutes.val() + ":00");
		htWorkControlConfigData.put("systemendtime", objSystemEndHours.val() + ":" + objSystemEndMinutes.val() + ":00");
		htWorkControlConfigData.put("workstarttime", objWorkStartHours.val() + ":" + objWorkStartMinutes.val() + ":00");
		htWorkControlConfigData.put("workendtime", objWorkEndHours.val() + ":" + objWorkEndMinutes.val() + ":00");
		htWorkControlConfigData.put("alertsystemendalarmflag", objAlertSystemEndAlarmFlag.filter(':checked').val());
		htWorkControlConfigData.put("systemendalarmstart", objSystemEndAlarmStart.val());
		htWorkControlConfigData.put("systemendalarminterval", objSystemEndAlarmInterval.val());
		htWorkControlConfigData.put("alertworkendalarmflag", objAlertWorkEndAlarmFlag.filter(':checked').val());
		htWorkControlConfigData.put("workendalarmstart", objWorkEndAlarmStart.val());
		htWorkControlConfigData.put("workendalarminterval", objWorkEndAlarmInterval.val());
		htWorkControlConfigData.put("lockwhenidleflag", objLockWhenIdleFlag.filter(':checked').val());
		htWorkControlConfigData.put("idletimeforlock", objIdleTimeForLock.val());
		htWorkControlConfigData.put("permitextendedworkflag", objPermitExtendedWorkFlag.filter(':checked').val());

		if (bSaveCompanyConfig) {
			var arrCompanyList = new Array();

			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
					arrCompanyList.push($(this).attr('companyid'));
	 			}
			});

			var postData = getRequestSaveCompanyWorkControlConfigParam(
					'<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					htWorkControlConfigData);

			if (!saveConfigProcess("사업장 " + $('#tab-agentconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveDeptConfig) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrDept = new Array();
				if ($(node).attr('node_type') == "dept") {
					arrDept.push($(this).attr('companyid'));
					arrDept.push($(this).attr('deptcode'));
					arrDeptList.push(arrDept);
	 			}
			});

			var postData = getRequestSaveDeptWorkControlConfigParam(
					'<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					htWorkControlConfigData);

			if (!saveConfigProcess("부서 " + $('#tab-agentconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		if (bSaveUserConfig) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				var arrUser = new Array();
				if ($(node).attr('node_type') == "user") {
					arrUser.push($(this).attr('companyid'));
					arrUser.push($(this).attr('userid'));
					arrUserList.push(arrUser);
	 			}
			});

			var postData = getRequestSaveUserWorkControlConfigParam(
					'<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					htWorkControlConfigData);

			if (!saveConfigProcess("사용자 " + $('#tab-agentconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text(), postData)) {
				return false;
			}
		}

		displayInfoDialog($('#tab-agentconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 저장", "정상 처리되었습니다.", "정상적으로 " + $('#tab-agentconfig li:eq(' + g_selectedConfigTabIndex + ')').find('a').text() + " 정보가 저장되었습니다.");
	};

	saveConfigProcess = function(saveTarget, postData) {
		var bResult = false;

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('#tab-clientconfig .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#tab-clientconfig .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog(saveTarget + " 저장", saveTarget + " 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					bResult = true;
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog(saveTarget + " 저장", saveTarget + " 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return bResult;
	};

	validateDefaultConfigData = function() {

		var objJobProcessingType = g_objTabDefaultConfig.find('select[name="jobprocessingtype"]');
		var objForcedTermination = g_objTabDefaultConfig.find('input[type="radio"][name="forcedtermination"]');
		var objForcedTerminationPwd = g_objTabDefaultConfig.find('input[name="forcedterminationpwd"]');
		var objDecordingPermission = g_objTabDefaultConfig.find('input[type="radio"][name="decordingpermission"]');
		var objSafeExport = g_objTabDefaultConfig.find('input[type="radio"][name="safeexport"]');
		var objContentCopyPrevention = g_objTabDefaultConfig.find('input[type="radio"][name="contentcopyprevention"]');
		var objRealtimeObservation = g_objTabDefaultConfig.find('input[type="radio"][name="realtimeobservation"]');
		var objExpiration = g_objTabDefaultConfig.find('input[type="radio"][name="expiration"]');
		var objExpirationPeriod = g_objTabDefaultConfig.find('input[name="expirationperiod"]');
		var objUseServerOcrFlag = g_objTabDefaultConfig.find('input[type="radio"][name="useserverocrflag"]');
		var objExpirationJobProcessingType = g_objTabDefaultConfig.find('select[name="expirationjobprocessingtype"]');

		if ((objJobProcessingType.val() == null) || (objJobProcessingType.val().length == 0)) {
			displayAlertDialog("입력 오류", "검출파일 처리 유형을 선택해주세요.", "");
			return false;
		}

		if ((objForcedTermination.filter(':checked').val() == null) || (objForcedTermination.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "강제종료 차단 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objForcedTermination.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objForcedTerminationPwd.val().length == 0) {
					displayAlertDialog("입력 오류", "클라이언트 종료 인증번호를 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objForcedTerminationPwd, PARAM_TYPE_ALPHANUMERIC, "클라이언트 종료 인증번호", PARAM_PLAIN_PWD_MIN_LEN, PARAM_PLAIN_PWD_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objDecordingPermission.filter(':checked').val() == null) || (objDecordingPermission.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "암호화된 파일에 대한 복호화 허용 유무를 선택해주세요.", "");
			return false;
		}

		if ((objSafeExport.filter(':checked').val() == null) || (objSafeExport.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "암호화된 파일에 대한 외부 반출 허용 유무를 선택해주세요.", "");
			return false;
		}

		if ((objContentCopyPrevention.filter(':checked').val() == null) || (objContentCopyPrevention.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "암호화된 파일 내용에 대한 복사 방지 유무를 선택해주세요.", "");
			return false;
		}

		if ((objRealtimeObservation.filter(':checked').val() == null) || (objRealtimeObservation.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "실시간 감시 기능의 강제 사용 유무를 선택해주세요.", "");
			return false;
		}

		if ((objExpiration.filter(':checked').val() == null) || (objExpiration.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "개인 정보 파일 보관 만료일 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objExpiration.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objExpirationPeriod.val().length == 0) {
					displayAlertDialog("입력 오류", "개인 정보 파일 보관 만료일을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objExpirationPeriod, PARAM_TYPE_NUMBER, "개인 정보 파일 보관 만료일", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
				if (objExpirationJobProcessingType.val() == null) {
					displayAlertDialog("입력 오류", "만료 파일 처리 유형을 선택해주세요.", "");
					return false;
				}
			}
		}

		if ((objUseServerOcrFlag.filter(':checked').val() == null) || (objUseServerOcrFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "서버 OCR 사용 유무를 선택해주세요.", "");
			return false;
		}

		return true;
	};

	validatePrintControlConfigData = function() {

		var objPrintControlFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printcontrolflag"]');
		var objPrintLimitFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="printlimitflag"]');
		var objPrintLimitType = g_objTabPrintControlConfig.find('select[name="printlimittype"]');
		var objPrintLimitCount = g_objTabPrintControlConfig.find('input[name="printlimitcount"]');
		var objMaskingFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="maskingflag"]');
		var objMaskingType = g_objTabPrintControlConfig.find('select[name="maskingtype"]');
		var objMaskingFlag = g_objTabPrintControlConfig.find('input[type="radio"][name="maskingflag"]');
		var objJuminSexNotMaskingFlag = g_objTabPrintControlConfig.find('input[type="checkbox"][name="juminsexnotmaskingflag"]');
		var objLogCollectorIpAddress = g_objTabPrintControlConfig.find('input[name="logcollectoripaddress"]');
		var objLogCollectorPortNo = g_objTabPrintControlConfig.find('input[name="logcollectorportno"]');
		var objLogCollectorAccountId = g_objTabPrintControlConfig.find('input[name="logcollectoraccountid"]');
		var objLogCollectorAccountPwd = g_objTabPrintControlConfig.find('input[name="logcollectoraccountpwd"]');

		if ((objPrintControlFlag.filter(':checked').val() == null) || (objPrintControlFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "출력 제어 기능 사용 유무를 선택해주세요.", "");
			return false;
		}

		if ((objPrintLimitFlag.filter(':checked').val() == null) || (objPrintLimitFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "출력 사용량 제한 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objPrintLimitFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objPrintLimitType.val().length == 0) {
					displayAlertDialog("입력 오류", "출력 사용량 제한 유형을 선택해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objPrintLimitCount, PARAM_TYPE_NUMBER, "출력 사용 페이지 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objMaskingFlag.filter(':checked').val() == null) || (objMaskingFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "개인정보 마스킹 사용 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objMaskingFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objMaskingType.val().length == 0) {
					displayAlertDialog("입력 오류", "개인정보 마스킹 유형을 선택해주세요.", "");
					return false;
				}
			}
		}

		if (objLogCollectorIpAddress.val().length != 0) {
			if (!isValidParam(objLogCollectorIpAddress, PARAM_TYPE_IPV4_ADDRESS, "로그 수집 서버 주소", PARAM_IPV4_ADDRESS_MIN_LEN, PARAM_IPV4_ADDRESS_MAX_LEN, null)) {
				return false;
			}
		}

		if (objLogCollectorPortNo.val().length != 0) {
			if (!isValidParam(objLogCollectorPortNo, PARAM_TYPE_NUMBER, "로그 수집 서버 포트 번호", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
				return false;
			}
		}

		if (objLogCollectorAccountId.val().length != 0) {
			if (!isValidParam(objLogCollectorAccountId, PARAM_TYPE_ID, "로그 수집 서버 계정 ID", PARAM_ID_MIN_LEN, PARAM_ID_MAX_LEN, null)) {
				return false;
			}
		}

		if (objLogCollectorAccountPwd.val().length != 0) {
			if (!isValidParam(objLogCollectorAccountPwd, PARAM_TYPE_PWD, "로그 수집 서버 계정 비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, null)) {
				return false;
			}
		}

		return true;
	};

	validateWaterMarkConfigData = function() {

		var objWmPrintMode = g_objTabWaterMarkConfig.find('select[name="wmprintmode"]');
		var objWm3StepWaterMark = g_objTabWaterMarkConfig.find('select[name="wm3stepwatermark"]');
		var objWmTextRepeatSize = g_objTabWaterMarkConfig.find('select[name="wmtextrepeatsize"]');
		var objWmOutlineMode = g_objTabWaterMarkConfig.find('select[name="wmoutlinemode"]');
		var objWmPrintTime = g_objTabWaterMarkConfig.find('select[name="wmprinttime"]');
		var objWmMainFontName = g_objTabWaterMarkConfig.find('select[name="wmmainfontname"]');
		var objWmMainFontSize = g_objTabWaterMarkConfig.find('select[name="wmmainfontsize"]');
		var objWmMainFontStyle = g_objTabWaterMarkConfig.find('select[name="wmmainfontstyle"]');
		var objWmSubFontName = g_objTabWaterMarkConfig.find('select[name="wmsubfontname"]');
		var objWmSubFontSize = g_objTabWaterMarkConfig.find('select[name="wmsubfontsize"]');
		var objWmSubFontStyle = g_objTabWaterMarkConfig.find('select[name="wmsubfontstyle"]');
		var objWmTextFontName = g_objTabWaterMarkConfig.find('select[name="wmtextfontname"]');
		var objWmTextFontSize = g_objTabWaterMarkConfig.find('select[name="wmtextfontsize"]');
		var objWmTextFontStyle = g_objTabWaterMarkConfig.find('select[name="wmtextfontstyle"]');
		var objWmFontMainAngle = g_objTabWaterMarkConfig.find('input[name="wmfontmainangle"]');
		var objWmFontDensityMain = g_objTabWaterMarkConfig.find('select[name="wmfontdensitymain"]');
		var objWmFontDensityText = g_objTabWaterMarkConfig.find('select[name="wmfontdensitytext"]');
		var objWmBackgroundMode = g_objTabWaterMarkConfig.find('select[name="wmbackgroundmode"]');
		var objWmBackgroundImage = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimage"]');
		var objWmBackgroundPositionX = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositionx"]');
		var objWmBackgroundPositionY = g_objTabWaterMarkConfig.find('input[name="wmbackgroundpositiony"]');
		var objWmBackgroundImageWidth = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimagewidth"]');
		var objWmBackgroundImageHeight = g_objTabWaterMarkConfig.find('input[name="wmbackgroundimageheight"]');

		if ((objWmPrintMode.val() == null) || (objWmPrintMode.val().length == 0)) {
			displayAlertDialog("입력 오류", "출력 모드를 선택해주세요.", "");
			return false;
		}

		if ((objWm3StepWaterMark.val() == null) || (objWm3StepWaterMark.val().length == 0)) {
			objWm3StepWaterMark.val('0');
		}

		if ((objWmTextRepeatSize.val() == null) || (objWmTextRepeatSize.val().length == 0)) {
			objWmTextRepeatSize.val('A4');
		}

		if ((objWmOutlineMode.val() == null) || (objWmOutlineMode.val().length == 0)) {
			objWmOutlineMode.val('0');
		}

		if ((objWmPrintTime.val() == null) || (objWmPrintTime.val().length == 0)) {
			displayAlertDialog("입력 오류", "워터마크 시간 출력 유무를 선택해주세요.", "");
			return false;
		}

		if ((objWmMainFontName.val() == null) || (objWmMainFontName.val().length == 0)) {
			displayAlertDialog("입력 오류", "Main 글꼴을 선택해주세요.", "");
			return false;
		}

		if ((objWmMainFontSize.val() == null) || (objWmMainFontSize.val().length == 0)) {
			displayAlertDialog("입력 오류", "Main 글꼴 크기를 선택해주세요.", "");
			return false;
		}

		if ((objWmMainFontStyle.val() == null) || (objWmMainFontStyle.val().length == 0)) {
			objWmMainFontStyle.val('0');
		}

		if ((objWmSubFontName.val() == null) || (objWmSubFontName.val().length == 0)) {
			objWmSubFontName.val('0');
		}

		if ((objWmSubFontSize.val() == null) || (objWmSubFontSize.val().length == 0)) {
			objWmSubFontSize.val('5');
		}

		if ((objWmSubFontStyle.val() == null) || (objWmSubFontStyle.val().length == 0)) {
			objWmSubFontStyle.val('0');
		}

		if ((objWmTextFontName.val() == null) || (objWmTextFontName.val().length == 0)) {
			objWmTextFontName.val('0');
		}

		if ((objWmTextFontSize.val() == null) || (objWmTextFontSize.val().length == 0)) {
			objWmTextFontSize.val('5');
		}

		if ((objWmTextFontStyle.val() == null) || (objWmTextFontStyle.val().length == 0)) {
			objWmTextFontStyle.val('0');
		}

		if ((objWmFontMainAngle.val() == null) || (objWmFontMainAngle.val().length == 0)) {
			displayAlertDialog("입력 오류", "Main 글꼴 기울기를 선택해주세요.", "");
			return false;
		}

		if ((objWmFontDensityMain.val() == null) || (objWmFontDensityMain.val().length == 0)) {
			displayAlertDialog("입력 오류", "Main 글꼴 농도를 선택해주세요.", "");
			return false;
		}

		if ((objWmFontDensityText.val() == null) || (objWmFontDensityText.val().length == 0)) {
			objWmFontDensityText.val('1');
		}

		if ((objWmBackgroundMode.val() == null) || (objWmBackgroundMode.val().length == 0)) {
			objWmBackgroundMode.val('0');
		}

		if (objWmBackgroundImage.val().length > 0) {
			if (objWmBackgroundImageWidth.val().length == 0) {
				displayAlertDialog("배경 이미지 가로 크기", "배경 이미지 가로 크기를 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objWmBackgroundImageWidth, PARAM_TYPE_NUMBER, "배경 이미지 가로 크기", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
					return false;
				}
			}

			if (objWmBackgroundImageHeight.val().length == 0) {
				displayAlertDialog("배경 이미지 세로 크기", "배경 이미지 세로 크기를 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objWmBackgroundImageHeight, PARAM_TYPE_NUMBER, "배경 이미지 세로 크기", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
					return false;
				}
			}
		}

		return true;
	};

	validateMediaControlConfigData = function() {

		var objUsbControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="usbcontrolflag"]');
		var objUsbControlType = g_objTabMediaControlConfig.find('select[name="usbcontroltype"]');
		var objCdRomControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="cdromcontrolflag"]');
		var objCdRomControlType = g_objTabMediaControlConfig.find('select[name="cdromcontroltype"]');
		var objPublicFolderControlFlag = g_objTabMediaControlConfig.find('input[type="radio"][name="publicfoldercontrolflag"]');
		var objPublicFolderControlType = g_objTabMediaControlConfig.find('select[name="publicfoldercontroltype"]');

		if ((objUsbControlFlag.filter(':checked').val() == null) || (objUsbControlFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "USB 제어 기능 사용 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objUsbControlFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objUsbControlType.val().length == 0) {
					displayAlertDialog("입력 오류", "USB 제어 유형을 선택해주세요.", "");
					return false;
				}
			}
		}

		if ((objCdRomControlFlag.filter(':checked').val() == null) || (objCdRomControlFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "CD-ROM 제어 기능 사용 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objCdRomControlFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objCdRomControlType.val().length == 0) {
					displayAlertDialog("입력 오류", "CD-ROM 제어 유형을 선택해주세요.", "");
					return false;
				}
			}
		}

		if ((objPublicFolderControlFlag.filter(':checked').val() == null) || (objPublicFolderControlFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "공유 폴더 제어 기능 사용 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objPublicFolderControlFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objPublicFolderControlType.val().length == 0) {
					displayAlertDialog("입력 오류", "공유 폴더 제어 유형을 선택해주세요.", "");
					return false;
				}
			}
		}

		return true;
	};

	validateNetworkServiceControlConfigData = function() {

		var objNetworkServiceControlFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="networkservicecontrolflag"]');
		var objBlockSpecificUrlsFlag = g_objTabNetworkServiceControlConfig.find('input[type="radio"][name="blockspecificurlsflag"]');

		if ((objNetworkServiceControlFlag.filter(':checked').val() == null) || (objNetworkServiceControlFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "네트워크 서비스 제어 기능 사용 유무를 선택해주세요.", "");
			return false;
		}

		if ((objBlockSpecificUrlsFlag.filter(':checked').val() == null) || (objBlockSpecificUrlsFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "브라우저에서 특정 URL에 대한 접속 차단 유무를 선택해주세요.", "");
			return false;
		}

		return true;
	};

	validateSystemControlConfigData = function() {

		var objSystemPasswordSetupFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordsetupflag"]');
		//var objSystemPasswordMinLength = g_objTabSystemControlConfig.find('#systempasswordminlength');
		var objSystemPasswordMaxLength = g_objTabSystemControlConfig.find('#systempasswordmaxlength');
		var objSystemPasswordExpirationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="systempasswordexpirationflag"]');
		var objSystemPasswordExpirationPeriod = g_objTabSystemControlConfig.find('select[name="systempasswordexpirationperiod"]');
		var objScreenSaverActivationFlag = g_objTabSystemControlConfig.find('input[type="radio"][name="screensaveractivationflag"]');
		var objScreenSaverWaitingMinutes = g_objTabSystemControlConfig.find('select[name="screensaverwaitingminutes"]');

		if ((objSystemPasswordSetupFlag.filter(':checked').val() == null) || (objSystemPasswordSetupFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 시스템의 비밀번호 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objSystemPasswordSetupFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
// 				if (objSystemPasswordMinLength.val().length == 0) {
// 					displayAlertDialog("입력 오류", "비밀번호 최소 길이를 입력해주세요.", "");
// 					return false;
// 				} else {
// 					if (!isValidParam(objSystemPasswordMinLength, PARAM_TYPE_NUMBER, "비밀번호 최소 길이", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
// 						return false;
// 					}
// 				}
// 				if (objSystemPasswordMaxLength.val().length == 0) {
// 					displayAlertDialog("입력 오류", "비밀번호 최대 길이를 입력해주세요.", "");
// 					return false;
// 				} else {
// 					if (!isValidParam(objSystemPasswordMaxLength, PARAM_TYPE_NUMBER, "비밀번호 최대 길이", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
// 						return false;
// 					}
// 				}
			}
		}

		if ((objSystemPasswordExpirationFlag.filter(':checked').val() == null) || (objSystemPasswordExpirationFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 시스템의 비밀번호 유효기간 설정 유무를 선택해주세요.", "");
			return false;
// 		} else {
<%-- 			if (objSystemPasswordExpirationFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") { --%>
// 				if (objSystemPasswordExpirationPeriod.val().length == 0) {
// 					displayAlertDialog("입력 오류", "비밀번호 유효기간을 입력해주세요.", "");
// 					return false;
// 				} else {
// 					if (!isValidParam(objSystemPasswordExpirationPeriod, PARAM_TYPE_NUMBER, "비밀번호 유효기간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
// 						return false;
// 					}
// 				}
// 			}
		}

		if ((objScreenSaverActivationFlag.filter(':checked').val() == null) || (objScreenSaverActivationFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 시스템의 화면 보호기 설정 유무를 선택해주세요.", "");
			return false;
// 		} else {
<%-- 			if (objScreenSaverActivationFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") { --%>
// 				if (objScreenSaverWaitingMinutes.val().length == 0) {
// 					displayAlertDialog("입력 오류", "활성화 대기 시간을 입력해주세요.", "");
// 					return false;
// 				} else {
// 					if (!isValidParam(objScreenSaverWaitingMinutes, PARAM_TYPE_NUMBER, "활성화 대기 시간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
// 						return false;
// 					}
// 				}
// 			}
		}

		return true;
	};

	validateWorkControlConfigData = function() {

		var objSystemStartHours = g_objTabWorkControlConfig.find('select[name="systemstarthours"]');
		var objSystemStartMinutes = g_objTabWorkControlConfig.find('select[name="systemstartminutes"]');
		var objSystemEndHours = g_objTabWorkControlConfig.find('select[name="systemendhours"]');
		var objSystemEndMinutes = g_objTabWorkControlConfig.find('select[name="systemendminutes"]');
		var objWorkStartHours = g_objTabWorkControlConfig.find('select[name="workstarthours"]');
		var objWorkStartMinutes = g_objTabWorkControlConfig.find('select[name="workstartminutes"]');
		var objWorkEndHours = g_objTabWorkControlConfig.find('select[name="workendhours"]');
		var objWorkEndMinutes = g_objTabWorkControlConfig.find('select[name="workendminutes"]');
		var objAlertSystemEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertsystemendalarmflag"]');
		var objSystemEndAlarmStart = g_objTabWorkControlConfig.find('select[name="systemendalarmstart"]');
		var objSystemEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="systemendalarminterval"]');
		var objAlertWorkEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertworkendalarmflag"]');
		var objWorkEndAlarmStart = g_objTabWorkControlConfig.find('select[name="workendalarmstart"]');
		var objWorkEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="workendalarminterval"]');
		var objLockWhenIdleFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="lockwhenidleflag"]');
		var objIdleTimeForLock = g_objTabWorkControlConfig.find('select[name="idletimeforlock"]');
		var objPermitExtendedWorkFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="permitextendedworkflag"]');

		if ((objAlertSystemEndAlarmFlag.filter(':checked').val() == null) || (objAlertSystemEndAlarmFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 시스템의 종료 알람 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objAlertSystemEndAlarmFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objSystemEndAlarmStart.val().length == 0) {
					displayAlertDialog("입력 오류", "알람 시작 시간을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objSystemEndAlarmStart, PARAM_TYPE_NUMBER, "알람 시작 시간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
				if (objSystemEndAlarmInterval.val().length == 0) {
					displayAlertDialog("입력 오류", "알람 간격을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objSystemEndAlarmInterval, PARAM_TYPE_NUMBER, "알람 간격", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objAlertWorkEndAlarmFlag.filter(':checked').val() == null) || (objAlertWorkEndAlarmFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 업무의 종료 알람 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objAlertWorkEndAlarmFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objWorkEndAlarmStart.val().length == 0) {
					displayAlertDialog("입력 오류", "알람 시작 시간을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objWorkEndAlarmStart, PARAM_TYPE_NUMBER, "알람 시작 시간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
				if (objWorkEndAlarmInterval.val().length == 0) {
					displayAlertDialog("입력 오류", "알람 간격을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objWorkEndAlarmInterval, PARAM_TYPE_NUMBER, "알람 간격", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objLockWhenIdleFlag.filter(':checked').val() == null) || (objLockWhenIdleFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자 시스템의 유휴시 잠금 기능 설정 유무를 선택해주세요.", "");
			return false;
		} else {
			if (objLockWhenIdleFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objIdleTimeForLock.val().length == 0) {
					displayAlertDialog("입력 오류", "잠금 대기 시간을 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objIdleTimeForLock, PARAM_TYPE_NUMBER, "잠금 대기 시간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
						return false;
					}
				}
			}
		}

		if ((objPermitExtendedWorkFlag.filter(':checked').val() == null) || (objPermitExtendedWorkFlag.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "사용자의 업무 연장 요청을 허용 유무를 선택해주세요.", "");
			return false;
		}

		return true;
	};

	initControl = function() {

		initDefaultConfigControl();
		initPrintControlConfigControl();
		initWaterMarkConfigControl();
		initMediaControlConfigControl();
		initNetworkServiceControlConfigControl();
		initSystemControlConfigControl();
		initWorkControlConfigControl();
	};

	initDefaultConfigControl = function() {

		var objJobProcessingType = g_objTabDefaultConfig.find('select[name="jobprocessingtype"]');
		var objExpirationJobProcessingType = g_objTabDefaultConfig.find('select[name="expirationjobprocessingtype"]');

		fillDropdownList(objJobProcessingType, g_htJobProcessingTypeList, null, null);
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_DECRYPT%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_INDIVIDUAL%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_SEND_SERVER%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_TO_VITUALDISK%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_FROM_VITUALDISK%>' + '"]').remove();

		fillDropdownList(objExpirationJobProcessingType, g_htJobProcessingTypeList, null, null);
		objExpirationJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_DECRYPT%>' + '"]').remove();
		objExpirationJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_INDIVIDUAL%>' + '"]').remove();
		objExpirationJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_SEND_SERVER%>' + '"]').remove();
		objExpirationJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_TO_VITUALDISK%>' + '"]').remove();
		objExpirationJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_FROM_VITUALDISK%>' + '"]').remove();
	};

	initPrintControlConfigControl = function() {

		var objPrintLimitType = g_objTabPrintControlConfig.find('select[name="printlimittype"]');
		var objMaskingType = g_objTabPrintControlConfig.find('select[name="maskingtype"]');

		fillDropdownList(objPrintLimitType, g_htPrintLimitTypeList, null, null);
		fillDropdownList(objMaskingType, g_htPrintMaskingTypeList, null, null);
	};

	initWaterMarkConfigControl = function() {

		var objWmPrintMode = g_objTabWaterMarkConfig.find('select[name="wmprintmode"]');
		var objWm3StepWaterMark = g_objTabWaterMarkConfig.find('select[name="wm3stepwatermark"]');
		var objWmTextRepeatSize = g_objTabWaterMarkConfig.find('select[name="wmtextrepeatsize"]');
		var objWmOutlineMode = g_objTabWaterMarkConfig.find('select[name="wmoutlinemode"]');
		var objWmPrintTime = g_objTabWaterMarkConfig.find('select[name="wmprinttime"]');
		var objWmMainFontName = g_objTabWaterMarkConfig.find('select[name="wmmainfontname"]');
		var objWmMainFontSize = g_objTabWaterMarkConfig.find('select[name="wmmainfontsize"]');
		var objWmMainFontStyle = g_objTabWaterMarkConfig.find('select[name="wmmainfontstyle"]');
		var objWmSubFontName = g_objTabWaterMarkConfig.find('select[name="wmsubfontname"]');
		var objWmSubFontSize = g_objTabWaterMarkConfig.find('select[name="wmsubfontsize"]');
		var objWmSubFontStyle = g_objTabWaterMarkConfig.find('select[name="wmsubfontstyle"]');
		var objWmTextFontName = g_objTabWaterMarkConfig.find('select[name="wmtextfontname"]');
		var objWmTextFontSize = g_objTabWaterMarkConfig.find('select[name="wmtextfontsize"]');
		var objWmTextFontStyle = g_objTabWaterMarkConfig.find('select[name="wmtextfontstyle"]');
		var objWmFontDensityMain = g_objTabWaterMarkConfig.find('select[name="wmfontdensitymain"]');
		var objWmFontDensityText = g_objTabWaterMarkConfig.find('select[name="wmfontdensitytext"]');
		var objWmBackgroundMode = g_objTabWaterMarkConfig.find('select[name="wmbackgroundmode"]');

		fillDropdownList(objWmPrintMode, g_htPrintModeList, null, null);

		fillDropdownList(objWm3StepWaterMark, g_htOptionTypeList, null, null);

		objWmTextRepeatSize.empty();
		objWmTextRepeatSize.append('<option value="A4">A4</option>');
		objWmTextRepeatSize.append('<option value="B5">B5</option>');

		fillDropdownList(objWmOutlineMode, g_htOptionTypeList, null, null);

		fillDropdownList(objWmPrintTime, g_htOptionTypeList, null, null);

		fillDropdownList(objWmMainFontName, g_htFontNameList, null, null);
		objWmMainFontSize.empty();
		for (var i=0; i<7; i++) {
			objWmMainFontSize.append('<option value="' + (i+1) + '">' + (i+1) + '</option>');
		}
		fillDropdownList(objWmMainFontStyle, g_htFontStyleList, null, null);

		fillDropdownList(objWmSubFontName, g_htFontNameList, null, null);
		objWmSubFontSize.empty();
		for (var i=0; i<7; i++) {
			objWmSubFontSize.append('<option value="' + (i+1) + '">' + (i+1) + '</option>');
		}
		fillDropdownList(objWmSubFontStyle, g_htFontStyleList, null, null);

		fillDropdownList(objWmTextFontName, g_htFontNameList, null, null);
		objWmTextFontSize.empty();
		for( var i=0; i<7; i++) {
			objWmTextFontSize.append('<option value="' + (i+1) + '">' + (i+1) + '</option>');
		}
		fillDropdownList(objWmTextFontStyle, g_htFontStyleList, null, null);

		objWmFontDensityMain.empty();
		for( var i=0; i<16; i++) {
			objWmFontDensityMain.append('<option value="' + (i+1) + '">' + (i+1) + '</option>');
		}

		objWmFontDensityText.empty();
		for( var i=0; i<16; i++) {
			objWmFontDensityText.append('<option value="' + (i+1) + '">' + (i+1) + '</option>');
		}

		objWmBackgroundMode.empty();
		objWmBackgroundMode.append('<option value="0">기본 이미지 크기</option>');
		objWmBackgroundMode.append('<option value="1">출력용지 크기</option>');
	};

	initMediaControlConfigControl = function() {

		var objUsbControlType = g_objTabMediaControlConfig.find('select[name="usbcontroltype"]');
		var objCdRomControlType = g_objTabMediaControlConfig.find('select[name="cdromcontroltype"]');
		var objPublicFolderControlType = g_objTabMediaControlConfig.find('select[name="publicfoldercontroltype"]');

		fillDropdownList(objUsbControlType, g_htControlTypeList, null, null);
		objUsbControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>' + '"]').remove();
		objUsbControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_BLOCK_EXECUTE%>' + '"]').remove();

		fillDropdownList(objCdRomControlType, g_htControlTypeList, null, null);
		objCdRomControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>' + '"]').remove();
		objCdRomControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_BLOCK_EXECUTE%>' + '"]').remove();

		fillDropdownList(objPublicFolderControlType, g_htControlTypeList, null, null);
		objPublicFolderControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>' + '"]').remove();
		objPublicFolderControlType.find('option[value="' + '<%=ControlType.CONTROL_TYPE_BLOCK_EXECUTE%>' + '"]').remove();
	};

	initNetworkServiceControlConfigControl = function() {
		loadNetworkServiceControlProgram();
	};

	initSystemControlConfigControl = function() {
		var objSystemPasswordExpirationPeriod = g_objTabSystemControlConfig.find('select[name="systempasswordexpirationperiod"]');
		var objScreenSaverWaitingMinutes = g_objTabSystemControlConfig.find('select[name="screensaverwaitingminutes"]');

		objSystemPasswordExpirationPeriod.empty();
		objSystemPasswordExpirationPeriod.append('<option value="0">0</option>');
		objSystemPasswordExpirationPeriod.append('<option value="30">30</option>');
		objSystemPasswordExpirationPeriod.append('<option value="60">60</option>');
		objSystemPasswordExpirationPeriod.append('<option value="90">90</option>');
		objSystemPasswordExpirationPeriod.append('<option value="120">120</option>');
		objSystemPasswordExpirationPeriod.append('<option value="180">180</option>');

		objScreenSaverWaitingMinutes.empty();
		objScreenSaverWaitingMinutes.append('<option value="0">0</option>');
		objScreenSaverWaitingMinutes.append('<option value="5">5</option>');
		objScreenSaverWaitingMinutes.append('<option value="10">10</option>');
		objScreenSaverWaitingMinutes.append('<option value="15">15</option>');
		objScreenSaverWaitingMinutes.append('<option value="30">30</option>');
		objScreenSaverWaitingMinutes.append('<option value="60">60</option>');
	};

	initWorkControlConfigControl = function() {

		var objSystemStartHours = g_objTabWorkControlConfig.find('select[name="systemstarthours"]');
		var objSystemStartMinutes = g_objTabWorkControlConfig.find('select[name="systemstartminutes"]');
		var objSystemEndHours = g_objTabWorkControlConfig.find('select[name="systemendhours"]');
		var objSystemEndMinutes = g_objTabWorkControlConfig.find('select[name="systemendminutes"]');
		var objWorkStartHours = g_objTabWorkControlConfig.find('select[name="workstarthours"]');
		var objWorkStartMinutes = g_objTabWorkControlConfig.find('select[name="workstartminutes"]');
		var objWorkEndHours = g_objTabWorkControlConfig.find('select[name="workendhours"]');
		var objWorkEndMinutes = g_objTabWorkControlConfig.find('select[name="workendminutes"]');
		var objAlertSystemEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertsystemendalarmflag"]');
		var objSystemEndAlarmStart = g_objTabWorkControlConfig.find('select[name="systemendalarmstart"]');
		var objSystemEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="systemendalarminterval"]');
		var objAlertWorkEndAlarmFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="alertworkendalarmflag"]');
		var objWorkEndAlarmStart = g_objTabWorkControlConfig.find('select[name="workendalarmstart"]');
		var objWorkEndAlarmInterval = g_objTabWorkControlConfig.find('select[name="workendalarminterval"]');
		var objLockWhenIdleFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="lockwhenidleflag"]');
		var objIdleTimeForLock = g_objTabWorkControlConfig.find('select[name="idletimeforlock"]');
		var objPermitExtendedWorkFlag = g_objTabWorkControlConfig.find('input[type="radio"][name="permitextendedworkflag"]');

		objSystemStartHours.empty();
		for (var i=0; i<24; i++) {
			if (i < 10)
				objSystemStartHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSystemStartHours.append('<option value="' + i + '">' + i + '</option>');
		}

		objSystemStartMinutes.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objSystemStartMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSystemStartMinutes.append('<option value="' + i + '">' + i + '</option>');
		}

		objSystemEndHours.empty();
		for (var i=0; i<24; i++) {
			if (i < 10)
				objSystemEndHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSystemEndHours.append('<option value="' + i + '">' + i + '</option>');
		}

		objSystemEndMinutes.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objSystemEndMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSystemEndMinutes.append('<option value="' + i + '">' + i + '</option>');
		}

		objWorkStartHours.empty();
		for (var i=0; i<24; i++) {
			if (i < 10)
				objWorkStartHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objWorkStartHours.append('<option value="' + i + '">' + i + '</option>');
		}

		objWorkStartMinutes.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objWorkStartMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objWorkStartMinutes.append('<option value="' + i + '">' + i + '</option>');
		}

		objWorkEndHours.empty();
		for (var i=0; i<24; i++) {
			if (i < 10)
				objWorkEndHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objWorkEndHours.append('<option value="' + i + '">' + i + '</option>');
		}

		objWorkEndMinutes.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objWorkEndMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objWorkEndMinutes.append('<option value="' + i + '">' + i + '</option>');
		}

		objSystemEndAlarmStart.empty();
		for (var i=1; i<=6; i++) {
				objSystemEndAlarmStart.append('<option value="' + (i*10) + '">' + (i*10) + '</option>');
		}

		objSystemEndAlarmInterval.empty();
		for (var i=1; i<=10; i++) {
				objSystemEndAlarmInterval.append('<option value="' + i + '">' + i + '</option>');
		}

		objWorkEndAlarmStart.empty();
		for (var i=1; i<=6; i++) {
				objWorkEndAlarmStart.append('<option value="' + (i*10) + '">' + (i*10) + '</option>');
		}

		objWorkEndAlarmInterval.empty();
		for (var i=1; i<=10; i++) {
				objWorkEndAlarmInterval.append('<option value="' + i + '">' + i + '</option>');
		}

		objIdleTimeForLock.empty();
		objIdleTimeForLock.append('<option value="5">5</option>');
		objIdleTimeForLock.append('<option value="10">10</option>');
		objIdleTimeForLock.append('<option value="15">15</option>');
		objIdleTimeForLock.append('<option value="30">30</option>');
		objIdleTimeForLock.append('<option value="60">60</option>');
	};

	addExclusionSearchFolderToList = function() {
		var objExclusionSearchFolderList = g_objTabDefaultConfig.find('#exclusionsearchfolderlist');
		var objNewExclusionSearchFolderPath = g_objTabDefaultConfig.find('#newexclusionsearchfolderpath');

		if (objNewExclusionSearchFolderPath.val().length == 0) {
			displayAlertDialog("검사 대상 제외 경로 설정", "추가할 경로를 입력해 주세요.", "");
			objNewExclusionSearchFolderPath.focus();
			return false;
		}

		var isAlready = false;
		objExclusionSearchFolderList.find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(1)').text() == objNewExclusionSearchFolderPath.val()) {
				displayAlertDialog("검사 대상 제외 경로 설정", "이미 추가한 경로입니다.", "");
				objNewExclusionSearchFolderPath.focus();
				isAlready = true;
				return false;
			}
		});

		if (!isAlready) {
			var newRow = '';
			newRow += '<tr>';
			newRow += '<td style="text-align: center;"><input type="checkbox" name="selectfolder" exclusionsearchfolderpath="' + objNewExclusionSearchFolderPath.val() + '" style="border: 0;"></td>';
			newRow += '<td title="' + objNewExclusionSearchFolderPath.val() + '">' + objNewExclusionSearchFolderPath.val() + '</td>';
			newRow += '</tr>';

			objExclusionSearchFolderList.find('tbody').append(newRow);
			refreshSelectedListTable(objExclusionSearchFolderList);
		}
	};

	deleteExclusionSearchFolderFromList = function() {
		var objExclusionSearchFolderList = g_objTabDefaultConfig.find('#exclusionsearchfolderlist');
		objExclusionSearchFolderList.find('.list-table tbody tr').find('input:checkbox[name="selectfolder"]').filter(':checked').each( function () {
			$(this).closest('tr').remove();
		});
		refreshSelectedListTable(objExclusionSearchFolderList);
	};

	selectProgramToList = function() {

		var objProgramList = null;
		var objSelectedProgramList = null;

		if (g_selectedProgramTypeTabIndex == TAB_EMAIL) {
			objProgramList = g_objTabEmail.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabEmail.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_FTP) {
			objProgramList = g_objTabFtp.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabFtp.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_P2P) {
			objProgramList = g_objTabP2p.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabP2p.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_MESSENGER) {
			objProgramList = g_objTabMessenger.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabMessenger.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_CAPTURE) {
			objProgramList = g_objTabCapture.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabCapture.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_ETC) {
			objProgramList = g_objTabEtc.find('select[name="programlist"]');
			objSelectedProgramList = g_objTabEtc.find('#selectedprogramlist');
		}

		objProgramList.children('option').filter(":selected").each( function() {
			var isAlreadyAdded = false;
			var selectedProgramName = $(this).text();
			var selectedFileName = $(this).val();

			g_objTabEmail.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 E-MAIL 항목에 이미 추가한 프로그램입니다.", "");
					isAlreadyAdded = true;
					return false;
				}
			});

			g_objTabFtp.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 FTP 항목에 이미 추가한 프로그램입니다.", "");
					isAlreadyAdded = true;
					return false;
				}
			});

			g_objTabP2p.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 P2P 항목에 이미 추가한 프로그램입니다.", "");
					isAlreadyAdded = true;
					return false;
				}
			});

			g_objTabMessenger.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 메신저 항목에 이미 추가한 프로그램입니다.", "");
					isAlreadyAdded = true;
					return false;
				}
			});

			g_objTabCapture.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 CAPTURE 항목에 이미 추가한 프로그램입니다.", "");
					isAlreadyAdded = true;
					return false;
				}
			});

			g_objTabEtc.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
				if ($(this).find('td:eq(2)').text().toLowerCase() == selectedFileName.toLowerCase()) {
					displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "[" + selectedFileName + "] 파일은 기타 항목에 이미 추가한 프로그램입니다.", "");
					return false;
				}
			});

			if (!isAlreadyAdded) {
				var newRow = '';
				newRow += '<tr>';
				newRow += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + selectedProgramName + '" filename="' + selectedFileName + '" style="border: 0;"></td>';
				newRow += '<td title="' + selectedProgramName + '">' + selectedProgramName + '</td>';
				newRow += '<td title="' + selectedFileName + '">' + selectedFileName + '</td>';
				newRow += '<td>';
				newRow += '<select id="controltype" name="controltype">';
				if (!g_htControlTypeList.isEmpty()) {
					g_htControlTypeList.each( function(value, name) {
						if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
								(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
							newRow += '<option value="' + value + '">' + name + '</option>';
						}
					});
				}
				newRow += '</select>';
				newRow += '</td>';
				newRow += '</tr>';

				objSelectedProgramList.find('tbody').append(newRow);
			}
		});

		refreshSelectedListTable(objSelectedProgramList);
	};

	addProgramToList = function() {

		var objSelectedProgramList = null;
		var newProgramName = null;
		var newFileName = null;

		if (g_selectedProgramTypeTabIndex == TAB_EMAIL) {
			objSelectedProgramList = g_objTabEmail.find('#selectedprogramlist');
			newProgramName = g_objTabEmail.find('#newprogramname').val().trim();
			newFileName = g_objTabEmail.find('#newfilename').val().trim();
		} else if (g_selectedProgramTypeTabIndex == TAB_FTP) {
			objSelectedProgramList = g_objTabFtp.find('#selectedprogramlist');
			newProgramName = g_objTabFtp.find('#newprogramname').val().trim();
			newFileName = g_objTabFtp.find('#newfilename').val().trim();
		} else if (g_selectedProgramTypeTabIndex == TAB_P2P) {
			objSelectedProgramList = g_objTabP2p.find('#selectedprogramlist');
			newProgramName = g_objTabP2p.find('#newprogramname').val().trim();
			newFileName = g_objTabP2p.find('#newfilename').val().trim();
		} else if (g_selectedProgramTypeTabIndex == TAB_MESSENGER) {
			objSelectedProgramList = g_objTabMessenger.find('#selectedprogramlist');
			newProgramName = g_objTabMessenger.find('#newprogramname').val().trim();
			newFileName = g_objTabMessenger.find('#newfilename').val().trim();
		} else if (g_selectedProgramTypeTabIndex == TAB_CAPTURE) {
			objSelectedProgramList = g_objTabCapture.find('#selectedprogramlist');
			newProgramName = g_objTabCapture.find('#newprogramname').val().trim();
			newFileName = g_objTabCapture.find('#newfilename').val().trim();
		} else if (g_selectedProgramTypeTabIndex == TAB_ETC) {
			objSelectedProgramList = g_objTabEtc.find('#selectedprogramlist');
			newProgramName = g_objTabEtc.find('#newprogramname').val().trim();
			newFileName = g_objTabEtc.find('#newfilename').val().trim();
		}

		if (newProgramName.length == 0) {
			displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "추가할 프로그램 명을 입력해 주세요.", "");
			return false;
		}

		if (newFileName.length == 0) {
			displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "추가할 프로그램 파일명을 입력해 주세요.", "");
			return false;
		}

		var isAlreadyAdded = false;
		g_objTabEmail.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "E-MAIL 항목에 이미 추가한 프로그램입니다.", "");
				isAlreadyAdded = true;
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		g_objTabFtp.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "FTP 항목에 이미 추가한 프로그램입니다.", "");
				isAlreadyAdded = true;
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		g_objTabP2p.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "P2P 항목에 이미 추가한 프로그램입니다.", "");
				isAlreadyAdded = true;
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		g_objTabMessenger.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "메신저 항목에 이미 추가한 프로그램입니다.", "");
				isAlreadyAdded = true;
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		g_objTabCapture.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "CAPTURE 항목에 이미 추가한 프로그램입니다.", "");
				isAlreadyAdded = true;
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		g_objTabEtc.find('#selectedprogramlist').find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(2)').text().toLowerCase() == newFileName.toLowerCase()) {
				displayAlertDialog("네트워크 서비스 제어 대상 프로그램 설정", "기타 항목에 이미 추가한 프로그램입니다.", "");
				return false;
			}
		});
		if (isAlreadyAdded) return false;

		var newRow = '';
		newRow += '<tr>';
		newRow += '<td style="text-align: center;"><input type="checkbox" name="selectprogram" programname="' + newProgramName + '" filename="' + newFileName + '" style="border: 0;"></td>';
		newRow += '<td title="' + newProgramName + '">' + newProgramName + '</td>';
		newRow += '<td title="' + newFileName + '">' + newFileName + '</td>';
		newRow += '<td>';
		newRow += '<select id="controltype" name="controltype">';
		if (!g_htControlTypeList.isEmpty()) {
			g_htControlTypeList.each( function(value, name) {
				if ((value != '<%=ControlType.CONTROL_TYPE_PERMIT_ENCRYPT_FILE%>') &&
						(value != '<%=ControlType.CONTROL_TYPE_PERMIT_READ%>')) {
					newRow += '<option value="' + value + '">' + name + '</option>';
				}
			});
		}
		newRow += '</select>';
		newRow += '</td>';
		newRow += '</tr>';

		objSelectedProgramList.find('tbody').append(newRow);

		refreshSelectedListTable(objSelectedProgramList);
	};

	deleteProgramFromList = function() {

		var objSelectedProgramList = null;

		if (g_selectedProgramTypeTabIndex == TAB_EMAIL) {
			objSelectedProgramList = g_objTabEmail.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_FTP) {
			objSelectedProgramList = g_objTabFtp.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_P2P) {
			objSelectedProgramList = g_objTabP2p.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_MESSENGER) {
			objSelectedProgramList = g_objTabMessenger.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_CAPTURE) {
			objSelectedProgramList = g_objTabCapture.find('#selectedprogramlist');
		} else if (g_selectedProgramTypeTabIndex == TAB_ETC) {
			objSelectedProgramList = g_objTabEtc.find('#selectedprogramlist');
		}

		objSelectedProgramList.find('.list-table tbody tr').find('input:checkbox[name="selectprogram"]').filter(':checked').each( function () {
			$(this).closest('tr').remove();
		});

		refreshSelectedListTable(objSelectedProgramList);
	};

	addBlockUrlToList = function() {
		var objBlockSpecificUrlsList = g_objTabNetworkServiceControlConfig.find('#blockspecificurlslist');
		var objNewBlockUrl = g_objTabNetworkServiceControlConfig.find('#newblockurl');

		if (objNewBlockUrl.val().length == 0) {
			displayAlertDialog("차단 URL 설정", "차단할 URL을 입력해 주세요.", "");
			objNewBlockUrl.focus();
			return false;
		} else {
			if (!isValidParam(objNewBlockUrl, PARAM_TYPE_DOMAIN, "차단 URL", PARAM_DOMAIN_MIN_LEN, PARAM_DOMAIN_MAX_LEN, null)) {
				return false;
			}
		}

		var isAlready = false;
		objBlockSpecificUrlsList.find('.list-table > tbody > tr').each( function () {
			if ($(this).find('td:eq(1)').text() == objNewBlockUrl.val()) {
				displayAlertDialog("차단 URL 설정", "이미 추가한 URL입니다.", "");
				objNewBlockUrl.focus();
				isAlready = true;
				return false;
			}
		});
		if (!isAlready) {
			var newRow = '';
			newRow += '<tr>';
			newRow += '<td style="text-align: center;"><input type="checkbox" name="selecturl" blockurl="' + objNewBlockUrl.val() + '" style="border: 0;"></td>';
			newRow += '<td title="' + objNewBlockUrl.val() + '">' + objNewBlockUrl.val() + '</td>';
			newRow += '</tr>';

			objBlockSpecificUrlsList.find('tbody').append(newRow);
			refreshSelectedListTable(objBlockSpecificUrlsList);
		}
	};

	deleteBlockUrlFromList = function() {
		var objBlockSpecificUrlsList = g_objTabNetworkServiceControlConfig.find('#blockspecificurlslist');
		objBlockSpecificUrlsList.find('.list-table tbody tr').find('input:checkbox[name="selecturl"]').filter(':checked').each( function () {
			$(this).closest('tr').remove();
		});
		refreshSelectedListTable(objBlockSpecificUrlsList);
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

<div class="inner-west">
	<div class="pane-header">조직 구성도</div>
	<div class="ui-layout-content zero-padding">
		<div id="organization-tree" class="treeview-pannel"></div>
	</div>
</div>
<div id="tab-clientconfig" class="inner-center styles-tab">
	<div class="pane-header">설정 정보</div>
	<ul>
		<li><a href="#tab-defaultconfig">기본 설정</a></li>
		<li><a href="#tab-patternconfig">패턴 설정</a></li>
		<li><a href="#tab-printcontrolconfig">출력 제어</a></li>
		<li><a href="#tab-watermarkconfig">워터마크 설정</a></li>
		<li><a href="#tab-mediacontrolconfig">매체 제어</a></li>
		<li><a href="#tab-networkservicecontrolconfig">네트워크 서비스 제어</a></li>
		<li><a href="#tab-systemcontrolconfig">시스템 제어</a></li>
		<li><a href="#tab-workcontrolconfig">업무 설정</a></li>
	</ul>
	<div class="ui-layout-content">
		<div id="tab-defaultconfig" style="padding: 10px;">
			<div class="category-sub-title">검출된 파일 처리 유형 설정 (강제검사에서 검출파일 처리 유형을 개별정책으로 설정시에도 적용)</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div class="field-title">검출파일 처리 유형</div>
					<div class="field-value">
						<select id="jobprocessingtype" name="jobprocessingtype" class="ui-widget-content"></select>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">삭제 방지 및 강제종료 차단 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자의 프로그램 삭제 방지 및  강제 종료를 차단하도록 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="forcedtermination" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="forcedtermination" value="0">아니오</label>
					</div>
				</div>
				<div id="row-forcedterminationpwd" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>인증 번호:&nbsp;
					<input type="text" id="forcedterminationpwd" name="forcedterminationpwd" class="text ui-widget-content" style="width: 120px;" />
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">암호화된 파일의 복호화 권한 설정</div>
			<div class="category-sub-contents">
				<div>사용자에게 암호화된 파일에 대한 복호화를 허용하도록 설정하시겠습니까?&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="decordingpermission" value="1">예</label>&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="decordingpermission" value="0">아니오</label>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px; display: none;">암호화된 파일의 외부 반출 권한 설정</div>
			<div class="category-sub-contents" style="display: none;">
				<div>사용자에게 암호화된 파일에 대한 외부 반출을 허용하도록 설정하시겠습니까?&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="safeexport" value="1">예</label>&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="safeexport" value="0">아니오</label>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">암호화된 파일의 내용 복사 방지 설정</div>
			<div class="category-sub-contents">
				<div>사용자에게 암호화된 파일 내용에 대한 복사를 방지하도록 설정하시겠습니까?&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="contentcopyprevention" value="1">예</label>&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="contentcopyprevention" value="0">아니오</label>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">실시간 감시기능 강제 사용 설정</div>
			<div class="category-sub-contents">
				<div>사용자 프로그램의 실시간 감시 기능을 강제 사용하도록 설정하시겠습니까?&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="realtimeobservation" value="1">예</label>&nbsp;&nbsp;
					<label class="radio"><input type="radio" name="realtimeobservation" value="0">아니오</label>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">비밀번호 유효기간 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자의 비밀번호 유효기간을 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="passwordexpirationflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="passwordexpirationflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-passwordexpirationperiod" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>유효기간:&nbsp;
					최종 비밀번호 변경일로부터 <input type="text" id="passwordexpirationperiod" name="passwordexpirationperiod" class="text ui-widget-content" style='width: 30px;text-align:right;' onkeyup="this.value=this.value.replace(/[^\d]/,'')" /> 일
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px; display: none;">개인 정보 파일 보관 만료일 설정</div>
			<div class="category-sub-contents" style="display: none;">
				<div class="field-line">
					<div>사용자 프로그램에서 개인정보가 검출된 파일에 대해 보관 만료기간을 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="expiration" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="expiration" value="0">아니오</label>
					</div>
				</div>
				<div id="row-expirationperiod" class="field-line">
					<div class="field-title">만료일</div>
					<div class="field-value">
						<input type="text" id="expirationperiod" name="expirationperiod" class="text ui-widget-content" style="width: 40px" /> 일 후
					</div>
				</div>
				<div id="row-expirationjobprocessingtype" class="field-line">
					<div class="field-title">만료 파일 처리 유형</div>
					<div class="field-value">
						<select id="expirationjobprocessingtype" name="expirationjobprocessingtype" class="ui-widget-content"></select>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">서버용 OCR 사용</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>이미지 검출을 위해 서버용 OCR을 사용하도록 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="useserverocrflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="useserverocrflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-ocrserveripaddress" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>OCR 서버 주소:&nbsp;
					<input type="text" id="ocrserveripaddress" name="ocrserveripaddress" class="text ui-widget-content" style="width: 120px;" />
				</div>
				<div id="row-ocrserverport" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>OCR 서버 포트:&nbsp;
					<input type="text" id="ocrserverport" name="ocrserverport" class="text ui-widget-content" style="width: 120px;" />
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">검사 대상 제외 경로 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div class="field-title">폴더 경로</div>
					<div class="field-contents">
						<input type="text" id="newexclusionsearchfolderpath" name="newexclusionsearchfolderpath" class="text ui-widget-content" style="width: calc(100% - 111px);" />
						<button type="button" id="btnAddExclusionSearchFolder" name="btnAddExclusionSearchFolder" class="normal-button" style="vertical-align: top;">경로 추가</button>
					</div>
				</div>
				<div class="field-line">
					<div style="border: 1px solid #d0d0d0; height: 120px; overflow: auto;">
						<div id="exclusionsearchfolderlist"></div>
					</div>
					<div class="button-line" style="margin-top: 5px;">
						<button type="button" id="btnDeleteExclusionSearchFolder" name="btnDeleteExclusionSearchFolder" class="normal-button">선택 경로 삭제</button>
					</div>
				</div>
			</div>
		</div>
		<div id="tab-patternconfig" style="padding: 10px;">
			<div class="info">
				<ul class="infolist">
					<li>기본 설정에서 "검출파일 처리 유형"을 암호화로 설정했을 경우, 검사 결과 해당 패턴 검출 수가 처리 활성화 수를 초과하면 파일이 암호화 됩니다.</li>
				</ul>
			</div>
			<div id="patterninfo"></div>
		</div>
		<div id="tab-printcontrolconfig" style="padding: 10px;">
			<div class="category-sub-title">출력 제어 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>출력 제어 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="printcontrolflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="printcontrolflag" value="0">아니오</label>
					</div>
				</div>
			</div>
			<div id="row-printlimit">
				<div class="category-sub-title" style="margin-top: 20px;">출력 사용량 설정</div>
				<div class="category-sub-contents">
					<div class="field-line">
						<div>출력 사용량을 제한 하시겠습니까?&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="printlimitflag" value="1">예</label>&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="printlimitflag" value="0">아니오</label>
						</div>
					</div>
					<div id="row-printlimittype" class="field-line">
						<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>제한 사용량:&nbsp;
						<select id="printlimittype" name="printlimittype" class="ui-widget-content" style="height: 26px; line-height: 26px;"></select>&nbsp;&nbsp;
						<input type="text" id="printlimitcount" name="printlimitcount" class="text ui-widget-content numeric" style="width: 60px;" /> 페이지
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">개인정보 마스킹 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>개인정보 마스킹 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="maskingflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="maskingflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-maskingtype" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>마스킹 유형:&nbsp;
					<select id="maskingtype" name="maskingtype" class="ui-widget-content"></select>&nbsp;&nbsp;
					<label for="juminsexnotmaskingflag"><input type="checkbox" id="juminsexnotmaskingflag" name="juminsexnotmaskingflag"/>주민등록번호 성별 자리(뒷자리 첫번째 숫자) 마스킹 제외</label>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px; display: none;">로그 수집 서버 설정 (출력파일 로그 수집 FTP 서버)</div>
			<div class="category-sub-contents" style="display: none;">
				<div class="field-line">
					<div class="field-title">IP 주소</div>
					<div class="field-value">
						<input type="text" id="logcollectoripaddress" name="logcollectoripaddress" class="text ui-widget-content" style="width: 130px;" />
					</div>
				</div>
				<div class="field-line">
					<div class="field-title">포트 번호</div>
					<div class="field-value">
						<input type="text" id="logcollectorportno" name="logcollectorportno" maxlength="8" class="text ui-widget-content numeric" style="width: 60px;" />
					</div>
				</div>
				<div class="field-line">
					<div class="field-title">계정 ID</div>
					<div class="field-value">
						<input type="text" id="logcollectoraccountid" name="logcollectoraccountid" class="text ui-widget-content" style="width: 130px;" />
					</div>
				</div>
				<div class="field-line">
					<div class="field-title">계정 비밀번호</div>
					<div class="field-value">
						<input type="text" id="logcollectoraccountpwd" name="logcollectoraccountpwd" class="text ui-widget-content" style="width: 130px;" />
					</div>
				</div>
			</div>
		</div>
		<div id="tab-watermarkconfig" style="padding: 10px;">
			<div class="category-sub-title">출력 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div class="field-title">모드</div>
					<div class="field-value">
						<select id="wmprintmode" name="wmprintmode" class="ui-widget-content"></select>
					</div>
				</div>
				<div class="field-line" style="display: none;">
					<div class="field-title">3단 워터마크</div>
					<div class="field-value">
						<select id="wm3stepwatermark" name="wm3stepwatermark" class="ui-widget-content"></select>
					</div>
				</div>
				<div class="field-line" style="display: none;">
					<div class="field-title">워터마크 반복</div>
					<div class="field-value">
						<select id="wmtextrepeatsize" name="wmtextrepeatsize" class="ui-widget-content"></select>
					</div>
				</div>
				<div class="field-line" style="display: none;">
					<div class="field-title">워터마크 외곽선 출력</div>
					<div class="field-value">
						<select id="wmoutlinemode" name="wmoutlinemode" class="ui-widget-content"></select>
					</div>
				</div>
				<div class="field-line">
					<div class="field-title">워터마크 시간 출력</div>
					<div class="field-value">
						<select id="wmprinttime" name="wmprinttime" class="ui-widget-content"></select>
					</div>
				</div>
			</div>
			<div style="margin-top: 20px;">
				<div class="left-frame" style="width: 49%; vertical-align: top;">
					<div class="category-sub-title">
						<div style="float: left;">출력 문자열 설정</div>
						<div style="float: right;">
							<button type="button" id="btnReservedWordInfo" name="btnReservedWordInfo" class="small-button">예약어 정보 보기</button>
						</div>
						<div class="clear"></div>
					</div>
					<div class="category-sub-contents">
						<div class="field-line">
							<div class="field-title">Main</div>
							<div class="field-value">
								<input type="text" id="wmtextmain" name="wmtextmain" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Sub</div>
							<div class="field-value">
								<input type="text" id="wmtextsub" name="wmtextsub" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Top Left</div>
							<div class="field-value">
								<input type="text" id="wmtexttopleft" name="wmtexttopleft" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Top Right</div>
							<div class="field-value">
								<input type="text" id="wmtexttopright" name="wmtexttopright" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Bottom Left</div>
							<div class="field-value">
								<input type="text" id="wmtextbottomleft" name="wmtextbottomleft" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Bottom Right</div>
							<div class="field-value">
								<input type="text" id="wmtextbottomright" name="wmtextbottomright" class="text ui-widget-content" style="width: 98%" />
							</div>
						</div>
					</div>
					<div class="category-sub-title" style="margin-top: 20px;">글꼴 설정</div>
					<div class="category-sub-contents">
						<div class="field-line">
							<div class="field-title">Main</div>
							<div class="field-contents">
								<table class="info-table">
								<tr>
									<td style="width: 30px;">글꼴: </td>
									<td colspan="4" style="text-align: left;">
										<select id="wmmainfontname" name="wmmainfontname" class="ui-widget-content" style="width: 100%;"></select>
									</td>
								</tr>
								<tr>
									<td style="width: 30px;">크기: </td>
									<td style="text-align: left;">
										<select id="wmmainfontsize" name="wmmainfontsize" class="ui-widget-content" style="width: 50px;"></select>
									</td>
									<td style="width: 5px; display: none;">&nbsp;</td>
									<td style="margin-left: 10px; width: 30px; display: none;">모양: </td>
									<td style="text-align: right; display: none;">
										<select id="wmmainfontstyle" name="wmmainfontstyle" class="ui-widget-content" style="width: 100%;"></select>
									</td>
								</tr>
								</table>
							</div>
							<div class="ui-state-highlight" style="margin-top: 10px;">
								<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-info"></span></li></ul>
								<span style="height: 18px; line-height: 18px;">Sub 및 상단, 하단 문구의 글꼴 크기는 Main 글꼴 크기에 따라 자동 조절됩니다.</span>
							</div>
						</div>
						<div class="field-line" style="display: none;">
							<div class="field-title">Sub</div>
							<div class="field-contents">
								<div>
									<table>
									<tr>
										<td width="10%">글꼴: </td>
										<td>
											<select id="wmsubfontname" name="wmsubfontname" class="ui-widget-content" style="width: 100%;"></select>
										</td>
									</table>
								</div>
								<div>
									<table>
									<tr>
										<td width="10%">크기: </td>
										<td>
											<select id="wmsubfontsize" name="wmsubfontsize" class="ui-widget-content" style="width: 100%;"></select>
										</td>
										<td width="5%">&nbsp;</td>
										<td width="10%" style="margin-left: 10px;">모양: </td>
										<td align="right">
											<select id="wmsubfontstyle" name="wmsubfontstyle" class="ui-widget-content" style="width: 100%;"></select>
										</td>
									</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="field-line" style="display: none;">
							<div class="field-title">Text</div>
							<div class="field-contents">
								<div>
									<table>
									<tr>
										<td width="10%">글꼴: </td>
										<td>
											<select id="wmtextfontname" name="wmtextfontname" class="ui-widget-content" style="width: 100%;"></select>
										</td>
									</table>
								</div>
								<div>
									<table>
									<tr>
										<td width="10%">크기: </td>
										<td>
											<select id="wmtextfontsize" name="wmtextfontsize" class="ui-widget-content" style="width: 100%;"></select>
										</td>
										<td width="5%">&nbsp;</td>
										<td width="10%" style="margin-left: 10px;">모양: </td>
										<td align="right">
											<select id="wmtextfontstyle" name="wmtextfontstyle" class="ui-widget-content" style="width: 100%;"></select>
										</td>
									</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="category-sub-title" style="margin-top: 20px;">글꼴 옵션 설정</div>
					<div class="category-sub-contents">
						<div class="field-line">
							<div class="field-title">Main 글꼴 기울기</div>
							<div class="field-value">
								<input type="text" id="wmfontmainangle" name="wmfontmainangle" class="text ui-widget-content numeric" style="width: 44px;" />
								<span>( 범위: 0~360, 시계방향 회전 )</span>
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">Main 글꼴 농도</div>
							<div class="field-value">
								<select id="wmfontdensitymain" name="wmfontdensitymain" class="ui-widget-content" style="width: 50px;"></select>
								<span>( 낮을수록 진함 )</span>
							</div>
						</div>
						<div class="field-line" style="display: none;">
							<div class="field-title">Text 글꼴 농도</div>
							<div class="field-value">
								<select id="wmfontdensitytext" name="wmfontdensitytext" class="ui-widget-content"></select>
							</div>
						</div>
					</div>
				</div>
				<div class="right-frame" style="margin-left: 51%; vertical-align: top;">
					<div class="category-sub-title">배경 이미지 설정</div>
					<div class="category-sub-contents">
						<div class="field-line" style="display: none;">
							<div class="field-title">배경 이미지 출력</div>
							<div class="field-value">
								<select id="wmbackgroundmode" name="wmbackgroundmode" class="ui-widget-content"></select>
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">배경 이미지</div>
							<div class="field-contents">
								<input type="text" id="wmbackgroundimagefilename" name="wmbackgroundimagefilename" class="text ui-widget-content" style="width: calc(100% - 118px);" disabled />
								<input type="hidden" id="wmbackgroundimage" name="wmbackgroundimage" class="text ui-widget-content" />
								<button type="button" id="btnManageBackgroundImage" name="btnManageBackgroundImage" class="small-button" style="vertical-align: top;">배경 이미지 관리</button>
							</div>
						</div>
						<div class="field-line" style="display: none;">
							<div class="field-title">배경 이미지 위치</div>
							<div class="field-value">
								<table>
								<tr>
									<td width="15%">X 좌표: </td>
									<td><input type="text" id="wmbackgroundpositionx" name="wmbackgroundpositionx" class="text ui-widget-content" style="width: 80px;" /></td>
									<td width="15%" style="margin-left: 10px;">y 좌표: </td>
									<td><input type="text" id="wmbackgroundpositiony" name="wmbackgroundpositiony" class="text ui-widget-content" style="width: 80px;" /></td>
								</tr>
								</table>
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">배경 이미지 크기</div>
							<div class="field-contents">
								<table>
								<tr>
									<td style="width: 50px; text-align: right;">가로(pixel): </td>
									<td style="text-align: left;">
										<input type="text" id="wmbackgroundimagewidth" name="wmbackgroundimagewidth" class="text ui-widget-content numeric" style="width: 50px;" />
										<input type="hidden" id="orgwmbackgroundimagewidth" name="orgwmbackgroundimagewidth" />
									</td>
									<td style="width: 50px; text-align: right;">세로(pixel): </td>
									<td style="text-align: left;">
										<input type="text" id="wmbackgroundimageheight" name="wmbackgroundimageheight" class="text ui-widget-content numeric" style="width: 50px;" />
										<input type="hidden" id="orgwmbackgroundimageheight" name="orgwmbackgroundimageheight" />
									</td>
								</tr>
								<tr>
									<td style="width: 50px; text-align: right;">비율(%): </td>
									<td colspan="3" style="text-align: left;"><input id="sizepercentspinner" name="sizepercentspinner" value="100" style="width: 27px;" /></td>
								</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="tab-mediacontrolconfig" style="padding: 10px;">
			<div class="category-sub-title">USB 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>USB 제어 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="usbcontrolflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="usbcontrolflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-usbcontroltype" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>USB 제어 유형:&nbsp;
					<select id="usbcontroltype" name="usbcontroltype" class="ui-widget-content"></select>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">CD-ROM 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>CD-ROM 제어 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="cdromcontrolflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="cdromcontrolflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-cdromcontroltype" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>CD-ROM 제어 유형:&nbsp;
					<select id="cdromcontroltype" name="cdromcontroltype" class="ui-widget-content"></select>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px; display: none;">공유 폴더 설정 <span style="color: #2E9AFE;">(기능 추가 예정)</span></div>
			<div class="category-sub-contents" style="display: none;">
				<div class="field-line">
					<div>공유 폴더 제어 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="publicfoldercontrolflag" value="1" disabled>예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="publicfoldercontrolflag" value="0" checked disabled>아니오</label>
					</div>
				</div>
				<div id="row-publicfoldercontroltype" class="field-line">
					<div class="field-title">공유 폴더 제어 유형</div>
					<div class="field-value">
						<select id="publicfoldercontroltype" name="publicfoldercontroltype" class="ui-widget-content"></select>
					</div>
				</div>
			</div>
		</div>
		<div id="tab-networkservicecontrolconfig" style="padding: 10px;">
			<div class="category-sub-title">E-MAIL/메신저/FTP/P2P 등의 네트워크 서비스에 대한 제어  설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>네트워크 서비스 제어 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="networkservicecontrolflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="networkservicecontrolflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-networkservicecontrolprogram" style="margin-top: 10px;">
					<div id="tab-networkservicecontrolprogram" class="styles-tab" style="border:none;">
						<ul>
							<li><a href="#tab-email">E-MAIL</a></li>
							<li><a href="#tab-ftp">FTP</a></li>
							<li><a href="#tab-p2p">P2P</a></li>
							<li><a href="#tab-messenger">메신저</a></li>
							<li><a href="#tab-capture">CAPTURE</a></li>
							<li><a href="#tab-etc">기타</a></li>
						</ul>
						<div id="tab-email" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<div id="tab-ftp" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<div id="tab-p2p" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<div id="tab-messenger" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<div id="tab-capture" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
						<div id="tab-etc" style="padding: 10px 0;">
							<div style="float: left; width: 50%">
								<div>
									<div class="category-title">제어 선택 프로그램</div>
									<div class="category-sub-contents">
										<div id="selectedprogramlist"></div>
									</div>
									<div class="button-line" style="margin-top: 4px;">
										<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="small-button">프로그램 삭제</button>
									</div>
								</div>
							</div>
							<div style="margin-left: 52%;">
								<div>
									<div class="category-title">제어 대상 프로그램</div>
									<div>
										<div><select id="programlist" name="programlist" multiple="multiple" size="15" style="padding: 5px; width: 100%; line-height:30px; height:230px;" class="ui-widget-content"></select></div>
										<div class="button-line" style="margin-top: 4px;">
											<button type="button" id="btnSelectProgram" name="btnSelectProgram" class="small-button">프로그램 선택</button>
										</div>
										<div style="margin-top: 30px;">
											<div class="field-line">
												<div class="field-title">프로그램 명</div>
												<div class="field-value">
													<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="field-line">
												<div class="field-title">프로그램 파일명</div>
												<div class="field-value">
													<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" style="width: 98%;" />
												</div>
											</div>
											<div class="button-line">
												<button type="button" id="btnAddProgram" name="btnAddProgram" class="small-button">프로그램 추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px; display: none;">특정 URL 차단 설정</div>
			<div class="category-sub-contents" style="margin-top: 20px; display: none;">
				<div class="field-line">
					<div>브라우저에서 특정 URL에 대한 접속을 차단하도록 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="blockspecificurlsflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="blockspecificurlsflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-blockspecificurls" class="field-line">
					<div class="field-title">차단 URL</div>
					<div class="field-contents">
						<input type="text" id="newblockurl" name="newblockurl" class="text ui-widget-content" style="width: 300px;"/>
						<button type="button" id="btnAddBlockUrl" name="btnAddBlockUrl" class="small-button" style="margin-bottom:4px;">URL 추가</button>
					</div>
					<div>
						<div class="category-title">차단 URL 목록</div>
						<div style="padding: 5px; border: 1px solid #aaa; height: 180px; overflow: auto;">
							<div id="blockspecificurlslist"></div>
						</div>
						<div class="button-line" style="margin-top: 4px;">
							<button type="button" id="btnDeleteBlockUrl" name="btnDeleteBlockUrl" class="small-button">URL 삭제</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="tab-systemcontrolconfig" style="padding: 10px;">
			<div class="category-sub-title">시스템 비밀번호 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자 시스템의 비밀번호를 설정하도록 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="systempasswordsetupflag" value="1" title="이 기능을 사용 시 시스템 비밀번호의 규칙을 설정하며,<br />설정된 초기 비밀번호가 없을 시,<br />시작화면에서 새 비밀번호를 설정합니다.">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="systempasswordsetupflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-systempasswordminlength" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>비밀번호 최소 길이:&nbsp;
					<input id="systempasswordminlength" name="systempasswordminlength" class="password-spinner" style="width: 40px; font-size: 1em; text-align: right; " /> 자리
				</div>
				<div id="row-systempasswordmaxlength" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>비밀번호 최대 길이:&nbsp;
					<input id="systempasswordmaxlength" name="systempasswordmaxlength" class="password-spinner" style="width: 40px; font-size: 1em; text-align: right;" /> 자리
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">시스템 비밀번호 유효기간 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자 시스템 비밀번호의 유효기간을 설정하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="systempasswordexpirationflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="systempasswordexpirationflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-systempasswordexpirationperiod" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>비밀번호 유효기간:&nbsp;
					<select id="systempasswordexpirationperiod" name="systempasswordexpirationperiod" class="ui-widget-content" style="width: 60px;"></select> 일
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">시스템 화면 보호기 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자 시스템의 화면 보호기를 활성화 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="screensaveractivationflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="screensaveractivationflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-screensaverwaitingminutes" class="field-line">
					<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>활성화 대기 시간:&nbsp;
					<select id="screensaverwaitingminutes" name="screensaverwaitingminutes" class="ui-widget-content" style="width: 60px;"></select> 분
				</div>
			</div>
		</div>
		<div id="tab-workcontrolconfig" style="padding: 10px;">
			<div class="category-sub-title">사용자 시스템 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자 시스템의 시작/종료 시간을 설정해 주세요.</div>
				</div>
				<div id="row-systemstarttime" class="field-line">
					<div class="field-title">시스템 시작 시간</div>
					<div class="field-value">
						<span style="margin-left: 10px;"><select id="systemstarthours" name="systemstarthours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시</span>
						<span style="margin-left: 10px;"><select id="systemstartminutes" name="systemstartminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분</span>
					</div>
				</div>
				<div id="row-systemendtime" class="field-line">
					<div class="field-title">시스템 종료 시간</div>
					<div class="field-value">
						<span style="margin-left: 10px;"><select id="systemendhours" name="systemendhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시</span>
						<span style="margin-left: 10px;"><select id="systemendminutes" name="systemendminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분</span>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">사용자 업무 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자의 업무 시작/종료 시간을 설정해 주세요.</div>
				</div>
				<div id="row-workstarttime" class="field-line">
					<div class="field-title">업무 시작 시간</div>
					<div class="field-value">
						<span style="margin-left: 10px;"><select id="workstarthours" name="workstarthours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시</span>
						<span style="margin-left: 10px;"><select id="workstartminutes" name="workstartminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분</span>
					</div>
				</div>
				<div id="row-workendtime" class="field-line">
					<div class="field-title">업무 종료 시간</div>
					<div class="field-value">
						<span style="margin-left: 10px;"><select id="workendhours" name="workendhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시</span>
						<span style="margin-left: 10px;"><select id="workendminutes" name="workendminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분</span>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">알람 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div class="field-line">
						<div>사용자 시스템 종료 알람을 설정하시겠습니까?&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="alertsystemendalarmflag" value="1">예</label>&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="alertsystemendalarmflag" value="0">아니오</label>
						</div>
					</div>
					<div id="row-systemendalarmstart" class="field-line">
						<div class="field-title">알람 시작 시간</div>
						<div class="field-value">
							종료 <select id="systemendalarmstart" name="systemendalarmstart" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분 전부터 알림 시작
						</div>
					</div>
					<div id="row-systemendalarminterval" class="field-line">
						<div class="field-title">알람 간격</div>
						<div class="field-value">
							매 <select id="systemendalarminterval" name="systemendalarminterval" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분 간격으로 알람
						</div>
					</div>
				</div>
				<div class="field-line" style="margin-top: 20px;">
					<div class="field-line">
						<div>사용자 업무 종료 알람을 설정하시겠습니까?&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="alertworkendalarmflag" value="1">예</label>&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="alertworkendalarmflag" value="0">아니오</label>
						</div>
					</div>
					<div id="row-workendalarmstart" class="field-line">
						<div class="field-title">알람 시작 시간</div>
						<div class="field-value">
							종료 <select id="workendalarmstart" name="workendalarmstart" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분 전부터 알림 시작
						</div>
					</div>
					<div id="row-workendalarminterval" class="field-line">
						<div class="field-title">알람 간격</div>
						<div class="field-value">
							매 <select id="workendalarminterval" name="workendalarminterval" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분 간격으로 알람
						</div>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">시스템 잠금 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자 시스템의 유휴시 잠금 기능을 설정 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="lockwhenidleflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="lockwhenidleflag" value="0">아니오</label>
					</div>
				</div>
				<div id="row-idletimeforlock" class="field-line">
					<div class="field-title">잠금 대기 시간</div>
					<div class="field-value">
						<select id="idletimeforlock" name="idletimeforlock" class="ui-widget-content" style="width: 60px;"></select> 분
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">연장 업무 설정</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>사용자의 업무 연장 요청을 허용하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="permitextendedworkflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="permitextendedworkflag" value="0">아니오</label>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnSaveConfig" name="btnSaveConfig" class="normal-button">설정 저장</button>
		</div>
	</div>
</div>
