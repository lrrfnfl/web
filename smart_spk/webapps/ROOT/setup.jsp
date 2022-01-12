<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title>서버 설정</title>

	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-layout/layout-default-latest.css" />
	<script type="text/javascript" src="/js/jquery-ui-layout/jquery.layout-latest.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
	<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

	<script type="text/javascript" src="/js/jstree-v.pre1.0/jquery.jstree.js"></script>

	<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all" />
	<script type="text/javascript" src="/js/layout.js"></script>
	<script type="text/javascript" src="/js/checkparam.js"></script>
	<script type="text/javascript" src="/js/commparam.js"></script>
	<script type="text/javascript" src="/js/types.js"></script>
	<script type="text/javascript" src="/js/uiutil.js"></script>

	<script type="text/javascript">
	<!--
		var g_arrTables = [
   			"server_config",
			"admin",
			"admin_accessable_address",
			"admin_log",
			"company",
			"company_setup_config",
			"licence",
			"licence_renewal_history",
			"payment",
			"dept",
			"member",
			"user_log",
			"pattern",
			"network_service_control_program",
			"ransomware_credential_exception_files",
			"ransomware_behavior_profile_exception_files",
			"api_callable_address",
			"agent_update",
			"company_default_pattern",
			"drm_permission_policy",
			"drm_permission_policy_member",
			"drm_permission_settings_log",
			"company_decoding_approbator",
			"dept_decoding_approbator",
			"member_decoding_approbator",
			"decoding_approval",
			"decoding_approval_files",
			"decoding_approval_history",
			"decoding_approval_status",
			"company_default_config",
			"dept_default_config",
			"member_default_config",
			"company_exclusion_search_folders",
			"dept_exclusion_search_folders",
			"member_exclusion_search_folders",
			"company_pattern_config",
			"dept_pattern_config",
			"member_pattern_config",
			"company_print_control_config",
			"dept_print_control_config",
			"member_print_control_config",
			"company_watermark_config",
			"dept_watermark_config",
			"member_watermark_config",
			"company_media_control_config",
			"dept_media_control_config",
			"member_media_control_config",
			"company_network_service_control_config",
			"dept_network_service_control_config",
			"member_network_service_control_config",
			"company_network_service_control_program",
			"dept_network_service_control_program",
			"member_network_service_control_program",
			"company_system_control_config",
			"dept_system_control_config",
			"member_system_control_config",
			"company_block_specific_urls",
			"dept_block_specific_urls",
			"member_block_specific_urls",
			"member_system_status",
			"member_synchronization_config",
			"db_protection",
			"db_protection_program",
			"db_protection_user",
			"db_protection_log",
			"user_notice",
			"user_notice_member",
			"install_state",
			"force_search",
			"force_search_detail",
			"force_search_pattern",
			"reserve_search",
			"reserve_search_member",
			"search_log",
			"search_result_summary",
			"search_result_summary_detail",
			"detect_log",
			"detect_log_detail",
			"detect_files",
			"detect_files_detail",
			"detect_files_expiration_extend_history",
			"detect_files_summary",
			"detect_pattern_summary",
			"detect_filetype_summary",
			"realtimeobservation_log",
			"print_log",
			"print_summary",
			"media_control_log",
			"url_block_log",
			"software_copyright",
			"software_licence",
			"software_allocation",
			"software_installation",
			"safe_export",
			"safe_export_files",
			"safe_export_summary_by_date",
			"ransomware_detect_log",
			"daily_ransomware_detect_summary",
			"monthly_report"
		];

		var g_arrViews = [
		];

		var g_arrInitTables = [
			"admin",
			"pattern",
			"network_service_control_program",
			"ransomware_credential_exception_files",
			"ransomware_behavior_profile_exception_files"
		];

		var g_htOptionTypeList = new Hashtable();
		var g_htServerTypeList = new Hashtable();

		var g_objSetupTree;
		var g_objResetDb;
		var g_objServerConfig;

		var g_totalCount = 0;
		var g_progressCount = 0;

		$(document).ready(function() {

			g_objSetupTree = $('#setup-tree');
			g_objResetDb = $('#reset-db');
			g_objServerConfig = $('#server-config');

			$( document ).tooltip();

			$('input:button, input:submit, button').button();
			$('button[name="btnResetDb"]').button({ icons: {primary: "ui-icon-refresh"} });
			$('button[name="btnSaveConfig"]').button({ icons: {primary: "ui-icon-disk"} });

			$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

			outerLayout = $("body").layout(outerMinLayoutOptions);
			showInnerLayout("innerDefault");
			innerDefaultLayout.show("west");

			g_htOptionTypeList = loadTypeList("OPTION_TYPE");
			if (g_htOptionTypeList.isEmpty()) {
				displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
			}

			g_htServerTypeList = loadTypeList("SERVER_TYPE");
			if (g_htServerTypeList.isEmpty()) {
				displayAlertDialog("서버 유형 조회", "서버 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
			}

			fillDropdownList(g_objServerConfig.find('select[name="servertype"]'), g_htServerTypeList, null, "선택");

			loadSetupTreeView();

			$('#tab-serverconfig').tabs({
				heightStyle: "content",
				active: 0
			});

			g_objResetDb.find('#tablescount').text(g_arrTables.length);
			g_objResetDb.find('#viewscount').text(g_arrViews.length);
			g_objResetDb.find('#inittablescount').text(g_arrInitTables.length);

			$('button').click( function () {
				if ($(this).attr('id') == 'btnResetDb') {
					displayConfirmDialog("DB 초기화", "DB를 초기화 하시겠습니까?", "", function() { resetDb(); });
				} else if ($(this).attr('id') == 'btnSaveConfig') {
					if (validateServerConfigData()) {
						displayConfirmDialog("설정 정보 저장", "설정 정보를 저장하시겠습니까?", "", function() { saveServerConfig(); });
					}
				}
			});

			g_objResetDb.find('input[type="radio"][name="insertinitdata"]').change( function(event) {
				if ($(this).filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
					g_objResetDb.find('#inittablescount').text(g_arrInitTables.length);
				} else {
					g_objResetDb.find('#inittablescount').text("0");
				}
			});

			g_objResetDb.find('#progressbar').progressbar({
				value: false,
				change: function() {
					g_objResetDb.find(".progress-label").text(g_objResetDb.find('#progressbar').progressbar( "value" ) + "%" );
				},
				complete: function() {
					g_objResetDb.find(".progress-label").text( "Complete!" );
				}
			});

			g_objServerConfig.find('select[name="servertype"]').change( function() {
				if ($(this).val() == '<%=ServerType.SERVER_TYPE_ASP%>') {
					$('#tab-serverconfig').disableTab(2);
				} else {
					$('#tab-serverconfig').enableTab(2);
				}
			});
		});

		reloadDefaultLayout = function() {
			var layoutHeight = $('.treeview-pannel').parent().height();
			var paddingTop = parseInt($('.treeview-pannel').css("padding-top"));
			var paddingBottom = parseInt($('.treeview-pannel').css("padding-bottom"));
			if ($('.treeview-pannel').length) {
				$('.treeview-pannel').height(layoutHeight - paddingTop - paddingBottom);
				$('.treeview-pannel').mCustomScrollbar('update');
			}
			$('.inner-center .ui-layout-content').mCustomScrollbar('update');
		};

		loadSetupTreeView = function() {

			var xmlTreeData = "";
			xmlTreeData += "<root>";
			xmlTreeData += "<item id='reset_db'>";
			xmlTreeData += "<content><name>DB 초기화</name></content>";
			xmlTreeData += "</item>";
			xmlTreeData += "<item id='server_config'>";
			xmlTreeData += "<content><name>서버 설정</name></content>";
			xmlTreeData += "</item>";
			xmlTreeData += "</root>";

			g_objSetupTree.jstree({
				"xml_data" : {
					"data" : xmlTreeData
				},
				"themes": {
					"theme": "classic",
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
				"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu" ]

			}).bind('loaded.jstree', function (event, data) {
				data.inst.open_all(-1); // -1 opens all nodes in the container
				data.inst.select_node('ul > li:first');
				$(this).mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
			}).bind('select_node.jstree', function (event, data) {
				$('.inner-center .pane-header').text(data.rslt.obj.children('a').text().trim());
				if (data.rslt.obj.attr('id') == "reset_db") {
					g_objResetDb.show();
					g_objServerConfig.hide();
					$('button[name="btnResetDb"]').show();
					$('button[name="btnSaveConfig"]').hide();
				} else if (data.rslt.obj.attr('id') == "server_config") {
					g_objResetDb.hide();
					g_objServerConfig.show();
					$('button[name="btnResetDb"]').hide();
					$('button[name="btnSaveConfig"]').show();
					loadServerConfig();
				}
			});
		};

		resetDb = function() {

			var objInsertInitData = g_objResetDb.find('input[type="radio"][name="insertinitdata"]');
			var objTotalTablesCount = g_objResetDb.find('#totaltablescount');
			var objTotalViewsCount = g_objResetDb.find('#totalviewscount');

			var objProgressBar = g_objResetDb.find('#progressbar');
			var objResultMessage = g_objResetDb.find('#resultmessage');

			$('button[name="btnResetDb"]').button("option", "disabled", true);
			objProgressBar.show();

			g_totalCount = (g_arrTables.length + g_arrViews.length)*2;
			if (objInsertInitData.filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
				g_totalCount += g_arrInitTables.length;
			}
			g_progressCount = 0;

			objTotalTablesCount.text(g_arrTables.length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
			objTotalViewsCount.text(g_arrViews.length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

			objProgressBar.progressbar({
				value: 0
			});

			dropView(g_arrViews.length-1);
		};

		dropView = function(index) {

			var objProgressMessage = g_objResetDb.find('#progressmessage');

			if (index >= 0) {
				var viewName = g_arrViews[index];
				var postData = getRequestDropViewParam(viewName);

				$.ajax({
					type: "POST",
					url: "/CommandService",
					data: $.param({sendmsg : postData}),
					dataType: "xml",
					cache: false,
					async: false,
					beforeSend: function(xhr) {
						objProgressMessage.text("뷰 삭제중 ...(" + (g_arrViews.length-index) + "/" + g_arrViews.length + ")");
					},
					success: function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayResultStatus("[오류] " + viewName + " 뷰 삭제에 실패하였습니다.- " + $(data).find('errormsg').text(), true);
						} else {
							g_progressCount++;
							displayResultStatus(viewName + " 뷰를 삭제하였습니다.", false);
							setTimeout(function() { dropView(index-1); }, 100);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayResultStatus("[오류] " + viewName + " 뷰 삭제에 실패하였습니다.- " + jqXHR.statusText + "(" + jqXHR.status + ")", true);
						}
					}
				});
			} else {
				setTimeout(function() { dropTable(g_arrTables.length-1); }, 100);
			}
		};

		dropTable = function(index) {

			var objProgressMessage = g_objResetDb.find('#progressmessage');

			if (index >= 0) {
				var tableName = g_arrTables[index];
				var postData = getRequestDropTableParam(tableName);

				$.ajax({
					type: "POST",
					url: "/CommandService",
					data: $.param({sendmsg : postData}),
					dataType: "xml",
					cache: false,
					async: false,
					beforeSend: function(xhr) {
						objProgressMessage.text("테이블 삭제중 ...(" + (g_arrTables.length-index) + "/" + g_arrTables.length + ")");
					},
					success: function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayResultStatus("[오류] " + tableName + " 테이블 삭제에 실패하였습니다.- " + $(data).find('errormsg').text(), true);
						} else {
							g_progressCount++;
							displayResultStatus(tableName + " 테이블를 삭제하였습니다.", false);
							setTimeout(function() { dropTable(index-1); }, 100);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayResultStatus("[오류] " + tableName + " 테이블 삭제에 실패하였습니다.- " + jqXHR.statusText + "(" + jqXHR.status + ")", true);
						}
					}
				});
			} else {
				setTimeout(function() { createTable(0); }, 100);
			}
		};

		createTable = function(index) {

			var objProgressMessage = g_objResetDb.find('#progressmessage');

			if (index < g_arrTables.length) {
				var tableName = g_arrTables[index];
				var postData = getRequestCreateTableParam(tableName);

				$.ajax({
					type: "POST",
					url: "/CommandService",
					data: $.param({sendmsg : postData}),
					dataType: "xml",
					cache: false,
					async: false,
					beforeSend: function(xhr) {
						objProgressMessage.text("테이블 생성중 ...(" + (index+1) + "/" + g_arrTables.length + ")");
					},
					success: function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayResultStatus("[오류] " + tableName + " 테이블 생성에 실패하였습니다.- " + $(data).find('errormsg').text(), true);
						} else {
							g_progressCount++;
							displayResultStatus(tableName + " 테이블을 생성하였습니다.", false);
							setTimeout(function() { createTable(index+1); }, 100);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayResultStatus("[오류] " + tableName + " 테이블 생성에 실패하였습니다.- " + jqXHR.statusText + "(" + jqXHR.status + ")", true);
						}
					}
				});
			} else {
				setTimeout(function() { createView(0); }, 100);
			}
		};

		createView = function(index) {

			var objProgressMessage = g_objResetDb.find('#progressmessage');

			if (index < g_arrViews.length) {
				var viewName = g_arrViews[index];
				var postData = getRequestCreateViewParam(viewName);

				$.ajax({
					type: "POST",
					url: "/CommandService",
					data: $.param({sendmsg : postData}),
					dataType: "xml",
					cache: false,
					async: false,
					beforeSend: function(xhr) {
						objProgressMessage.text("뷰 생성중 ...(" + (index+1) + "/" + g_arrViews.length + ")");
					},
					success: function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayResultStatus("[오류] " + viewName + " 뷰 생성에 실패하였습니다.- " + $(data).find('errormsg').text(), true);
						} else {
							g_progressCount++;
							displayResultStatus(viewName + " 뷰을 생성하였습니다.", false);
							setTimeout(function() { createView(index+1); }, 100);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayResultStatus("[오류] " + viewName + " 뷰 생성에 실패하였습니다.- " + jqXHR.statusText + "(" + jqXHR.status + ")", true);
						}
					}
				});
			} else {
				if (g_objResetDb.find('input[type="radio"][name="insertinitdata"]').filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
					setTimeout(function() { initTable(0); }, 100);
				}
			}
		};

		initTable = function(index) {

			var objProgressMessage = g_objResetDb.find('#progressmessage');

			if (index < g_arrInitTables.length) {
				var tableName = g_arrInitTables[index];
				var postData = getRequestInitTableParam(tableName);

				$.ajax({
					type: "POST",
					url: "/CommandService",
					data: $.param({sendmsg : postData}),
					dataType: "xml",
					cache: false,
					async: false,
					beforeSend: function(xhr) {
						objProgressMessage.text("테이블 초기화중 ...(" + (index+1) + "/" + g_arrInitTables.length + ")");
					},
					success: function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayResultStatus("[오류] " + tableName + " 테이블 초기화에 실패하였습니다.- " + $(data).find('errormsg').text(), true);
						} else {
							g_progressCount++;
							displayResultStatus(tableName + " 테이블이 초기화되었습니다.", false);
							setTimeout(function() { initTable(index+1); }, 100);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayResultStatus("[오류] " + tableName + " 테이블 초기화에 실패하였습니다.- " + jqXHR.statusText + "(" + jqXHR.status + ")", true);
						}
					}
				});
			}
		};

		displayResultStatus = function(resultMsg, isError) {

			var objResultMessage = g_objResetDb.find('#resultmessage');
			var objProgressMessage = g_objResetDb.find('#progressmessage');
			var objProgressBar = g_objResetDb.find('#progressbar');
			var objProgressLabel = g_objResetDb.find(".progress-label");

			objResultMessage.append(resultMsg + "\n");
			objResultMessage.scrollTop(objResultMessage[0].scrollHeight - objResultMessage.height());

			if (!isError) {
				var processrate = 0;
				if (g_progressCount == g_totalCount) {
					processrate = 100;
					$('button[name="btnResetDb"]').button("option", "disabled", false);
				} else {
					processrate = Math.floor((g_progressCount/g_totalCount)*100);
				}
				if (processrate == 100) {
					objProgressMessage.text("DB 초기화 완료!!!");
					objProgressBar.progressbar('value', processrate);
					setTimeout(function() { objProgressLabel.text("Complete!"); }, 500);
				} else {
					objProgressBar.progressbar('value', processrate);
				}
			}
		};

		loadServerConfig = function() {

			var objServerType = g_objServerConfig.find('select[name="servertype"]');
			var objVersion = g_objServerConfig.find('input[name="version"]');
			var objOem = g_objServerConfig.find('input[name="oem"]');
			var objForcedLoginFlag = g_objServerConfig.find('input[type="radio"][name="forcedloginflag"]');
			var objLogintTialLimitCount = g_objServerConfig.find('input[name="logintriallimitcount"]');
			var objReloginDelaySecondAfterLock = g_objServerConfig.find('input[name="relogindelaysecondafterlock"]');
			var objAdminAccessableAddressMaxCount = g_objServerConfig.find('input[name="adminaccessableaddressmaxcount"]');
			var objRepresentativeCompanyId = g_objServerConfig.find('input[name="representativecompanyid"]');

			var postData = getRequestServerConfigInfoParam();

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
						displayAlertDialog("서버 설정 정보 조회", "서버 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
						return false;
					}

					var serverType = $(data).find('servertype').text();
					var version = $(data).find('version').text();
					var oem = $(data).find('oem').text();
					var forcedLoginFlag = $(data).find('forcedloginflag').text();
					var loginTrialLimitCount = $(data).find('logintriallimitcount').text();
					var reloginDelaySecondAfterLock = $(data).find('relogindelaysecondafterlock').text();
					var adminAccessableAddressMaxCount = $(data).find('adminaccessableaddressmaxcount').text();
					var representativeCompanyId = $(data).find('representativecompanyid').text();

					if ((serverType != null) && (serverType.length > 0)) {
						objServerType.val(serverType);
						objVersion.val(version);
						objOem.val(oem);
						objForcedLoginFlag.prop('checked', false);
						objForcedLoginFlag.filter('[value=' + forcedLoginFlag + ']').prop('checked', true);
						objReloginDelaySecondAfterLock.val(reloginDelaySecondAfterLock);
						objLogintTialLimitCount.val(loginTrialLimitCount);
						objAdminAccessableAddressMaxCount.val(adminAccessableAddressMaxCount);
						objRepresentativeCompanyId.val(representativeCompanyId);
						if (serverType == '<%=ServerType.SERVER_TYPE_ASP%>') {
							$('#tab-serverconfig').disableTab(2);
						} else {
							$('#tab-serverconfig').enableTab(2);
						}
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("서버 설정 정보 조회", "서버 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		};

		saveServerConfig = function() {

			var objServerType = g_objServerConfig.find('select[name="servertype"]');
			var objVersion = g_objServerConfig.find('input[name="version"]');
			var objOem = g_objServerConfig.find('input[name="oem"]');
			var objForcedLoginFlag = g_objServerConfig.find('input[type="radio"][name="forcedloginflag"]');
			var objLogintTialLimitCount = g_objServerConfig.find('input[name="logintriallimitcount"]');
			var objReloginDelaySecondAfterLock = g_objServerConfig.find('input[name="relogindelaysecondafterlock"]');
			var objAdminAccessableAddressMaxCount = g_objServerConfig.find('input[name="adminaccessableaddressmaxcount"]');
			var objRepresentativeCompanyId = g_objServerConfig.find('input[name="representativecompanyid"]');

			var postData = getRequestSaveServerConfigParam(
					objServerType.val(),
					objVersion.val(),
					objOem.val(),
					objForcedLoginFlag.filter(':checked').val(),
					objLogintTialLimitCount.val(),
					objReloginDelaySecondAfterLock.val(),
					objAdminAccessableAddressMaxCount.val(),
					objRepresentativeCompanyId.val()
			);

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
						displayAlertDialog("서버 설정 정보 저장", "서버 설정 정보 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					} else {
						displayInfoDialog("서버 설정 정보 저장", "정상 처리되었습니다.", "정상적으로 서버 설정 정보가 저장되었습니다.");
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("서버 설정 정보 저장", "서버 설정 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		};

		validateServerConfigData = function() {

			var objServerType = g_objServerConfig.find('select[name="servertype"]');
			var objVersion = g_objServerConfig.find('input[name="version"]');
			var objForcedLoginFlag = g_objServerConfig.find('input[type="radio"][name="forcedloginflag"]');
			var objLogintTialLimitCount = g_objServerConfig.find('input[name="logintriallimitcount"]');
			var objReloginDelaySecondAfterLock = g_objServerConfig.find('input[name="relogindelaysecondafterlock"]');
			var objAdminAccessableAddressMaxCount = g_objServerConfig.find('input[name="adminaccessableaddressmaxcount"]');
			var objRepresentativeCompanyId = g_objServerConfig.find('input[name="representativecompanyid"]');

			if ((objServerType.val() == null) || (objServerType.val().length == 0)) {
				displayAlertDialog("입력 오류", "서버 유형을 선택해주세요.", "");
				return false;
			}

			if ((objVersion.val() == null) || (objVersion.val().length == 0)) {
				displayAlertDialog("입력 오류", "서버 버전을 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objVersion, PARAM_TYPE_SERVER_VERSION, "서버 버전", PARAM_SERVER_VERSION_MIN_LEN, PARAM_SERVER_VERSION_MAX_LEN, null)) {
					return false;
				}
			}

			if ((objForcedLoginFlag.filter(':checked').val() == null) || (objForcedLoginFlag.filter(':checked').val().length == 0)) {
				displayAlertDialog("입력 오류", "관리자 강제 로그인 유무를 선택해주세요.", "");
				return false;
			}

			if ((objLogintTialLimitCount.val() == null) || (objLogintTialLimitCount.val().length == 0)) {
				displayAlertDialog("입력 오류", "관리자 로그인시 계정 잠김까지 비밀번호 인증 실패 수를 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objLogintTialLimitCount, PARAM_TYPE_NUMBER, "로그인 시도 횟수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
					return false;
				} else {
					if (parseInt(objLogintTialLimitCount.val()) <= 0) {
						displayAlertDialog("입력 오류", "관리자 로그인시 계정 잠김까지 비밀번호 인증 실패 수를 입력해주세요.", "");
						return false;
					}
				}
			}

			if ((objReloginDelaySecondAfterLock.val() == null) || (objReloginDelaySecondAfterLock.val().length == 0)) {
				displayAlertDialog("입력 오류", "관리자 계정 잠김 후 재시도까지의 대기 시간을 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objReloginDelaySecondAfterLock, PARAM_TYPE_NUMBER, "재 로그인 대기 시간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
					return false;
				} else {
					if (parseInt(objReloginDelaySecondAfterLock.val()) <= 0) {
						displayAlertDialog("입력 오류", "관리자 계정 잠김 후 재시도까지의 대기 시간을 입력해주세요.", "");
						return false;
					}
				}
			}

			if ((objAdminAccessableAddressMaxCount.val() == null) || (objAdminAccessableAddressMaxCount.val().length == 0)) {
				displayAlertDialog("입력 오류", "관리자가 원격으로 서버에 접속 할 수 있는 접근 가능 주소 수를 입력해주세요.", "");
				return false;
			} else {
				if (!isValidParam(objAdminAccessableAddressMaxCount, PARAM_TYPE_NUMBER, "관리자 접속 가능 주소 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, null)) {
					return false;
				} else {
					if (parseInt(objAdminAccessableAddressMaxCount.val()) <= 0) {
						displayAlertDialog("입력 오류", "관리자가 원격으로 서버에 접속 할 수 있는 접근 가능 주소 수를 입력해주세요.", "");
						return false;
					}
				}
			}

			if (objServerType.val() == '<%=ServerType.SERVER_TYPE_ENTERPRISE%>') {
				if ((objRepresentativeCompanyId.val() == null) || (objRepresentativeCompanyId.val().length == 0)) {
					displayAlertDialog("입력 오류", "대표 사업장 ID를 입력해주세요.", "");
					return false;
				} else {
					if (!isValidParam(objRepresentativeCompanyId, PARAM_TYPE_COMPANYID, "대표 사업장 ID", PARAM_COMPANYID_MIN_LEN, PARAM_COMPANYID_MAX_LEN, null)) {
						return false;
					}
				}
			}

			return true;
		};
	//-->
	</script>
	<style>
		.styles-tab > .ui-widget-header { 
			border: none;
			background: #aaa url(/js/jquery-ui-1.10.3/css/custom-theme/images/ui-bg_highlight-soft_75_e0e0e0_1x100.png) 50% 50% repeat-x;
			border-top-left-radius: 0px;
			border-top-right-radius: 0px;
			border-bottom-left-radius: 0px;
			border-bottom-right-radius: 0px;
		}
	</style>
</head>
<body>
	<div class="ui-layout-north">
		<div class="ui-widget header-contents" style="height: 56px; line-height: 56px; background-color: #1e1f23;">
			<div style="float: left;">
				<span style="margin-left: 20px; font-size: 1.4em; font-weight: normal; color:#fff;"><%=CommonConstant.SERVER_TITLE%> Setup</span>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="ui-layout-center">
		<div id="innerDefault" class="inner-layout-container">
			<div class="inner-west">
				<div class="pane-header">설정 목록</div>
				<div class="ui-layout-content zero-padding">
					<div id="setup-tree" class="treeview-pannel"></div>
				</div>
			</div>
			<div class="inner-center">
				<div class="pane-header"></div>
				<div class="ui-layout-content">
					<div id="reset-db" class="info-form" style="padding: 10px;">
						<div class="info">
							<ul class="infolist">
								<li>서비스에 필요한 데이타베이스의 테이블/뷰를 삭제 후 재 생성합니다.</li>
								<li>기존 서비스 중인 데이타가 모두 삭제되므로 서비스 중인 경우에는 신중하게 선택하십시오.</li>
								<li>DB 초기화를 할 경우 아래의 "DB 초기화" 버튼을 선택하십시오.</li>
							</ul>
						</div>
						<div class="category-sub-title">초기화 옵션</div>
						<div class="category-sub-contents">
							<div id="row-tablescount" class="field-line">
								<div>테이블/뷰 생성 후 초기 데이타를 입력하시겠습니까?&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="insertinitdata" value="1" checked="checked" />예</label>&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="insertinitdata" value="0" />아니오</label>
								</div>
							</div>
						</div>
						<div class="category-sub-title" style="margin-top: 10px;">초기화 처리 상태</div>
						<div class="category-sub-contents">
							<div id="row-tablescount" class="field-line">
								<div class="field-title">테이블 수</div>
								<div class="field-value"><span id="tablescount"></span></div>
							</div>
							<div id="row-viewscount" class="field-line">
								<div class="field-title">뷰 수</div>
								<div class="field-value"><span id="viewscount"></span></div>
							</div>
							<div id="row-inittablescount" class="field-line">
								<div class="field-title">초기화 테이블 수</div>
								<div class="field-value"><span id="inittablescount"></span></div>
							</div>
							<div id="row-progressmessage" class="field-line">
								<div class="field-title">진행 상황</div>
								<div class="field-value"><span id="progressmessage"></span></div>
							</div>
							<div id="row-progressbar" class="field-line">
								<div class="field-title">진행률</div>
								<div class="field-value"><div id="progressbar" style="height: 24px; display: none;"><div class="progress-label"></div></div></div>
							</div>
							<div id="row-resultmessage" class="field-line">
								<div class="field-title">결과 메시지</div>
								<div class="field-contents"><textarea id="resultmessage" name="resultmessage" class="text ui-widget-content" style="height: 200px;"></textarea></div>
							</div>
						</div>
					</div>
					<div id="server-config" class="info-form" style="padding: 10px;">
						<div id="tab-serverconfig" class="styles-tab" style="border: none;">
							<ul>
								<li><a href="#tab-versionsetup">버전 설정</a></li>
								<li><a href="#tab-adminsetup">관리자 설정</a></li>
								<li><a href="#tab-certificatesetup">인증 설정</a></li>
							</ul>
							<div id="tab-versionsetup" style="padding: 10px 0;">
								<div class="category-sub-title">버전 정보</div>
								<div class="category-sub-contents">
									<div id="row-servertype" class="field-line">
										<div class="field-title">서버 유형</div>
										<div class="field-value"><select id="servertype" name="servertype" class="ui-widget-content" ></select></div>
									</div>
									<div id="row-version" class="field-line">
										<div class="field-title">서버 버전</div>
										<div class="field-value"><input type="text" id="version" name="version" value="1.0.0.0" class="text ui-widget-content" /></div>
									</div>
								</div>
								<div class="category-sub-title" style="margin-top: 10px;">OEM 설정</div>
								<div class="category-sub-contents">
									<div id="row-oem" class="field-line">
										<div class="field-title">OEM ID</div>
										<div class="field-value"><input type="text" id="oem" name="oem" class="text ui-widget-content" /></div>
									</div>
								</div>
							</div>
							<div id="tab-adminsetup" style="padding: 10px 0;">
								<div class="category-sub-title">강제 로그인 설정</div>
								<div class="category-sub-contents">
									<div>다른 관리자가 로그인 상태인 경우, 다른 관리자의 접속을 강제로 종료하고 접속하도록 설정하시겠습니까?&nbsp;&nbsp;
										<label class="radio"><input type="radio" name="forcedloginflag" value="1" checked="checked" />예</label>&nbsp;&nbsp;
										<label class="radio"><input type="radio" name="forcedloginflag" value="0" />아니오</label>
									</div>
								</div>
								<div class="category-sub-title" style="margin-top: 10px;">로그인 시도 횟수 설정</div>
								<div class="category-sub-contents">
									<div>관리자 로그인시 계정 잠김까지 비밀번호 인증 실패 수를 입력해주세요. &nbsp;&nbsp;
										최대 <input type="text" id="logintriallimitcount" name="logintriallimitcount" value="5" class="text ui-widget-content" style="text-align: right; width: 100px;" /> 회
									</div>
								</div>
								<div class="category-sub-title" style="margin-top: 10px;">재 로그인 대기 시간 설정</div>
								<div class="category-sub-contents">
									<div>관리자 계정 잠김 후 재시도까지의 대기 시간을 입력해주세요. &nbsp;&nbsp;
										<input type="text" id="relogindelaysecondafterlock" name="relogindelaysecondafterlock" value="600" class="text ui-widget-content" style="text-align: right; width: 100px;" /> 초
									</div>
								</div>
								<div class="category-sub-title" style="margin-top: 10px;">관리자 접속 가능 주소 수 설정</div>
								<div class="category-sub-contents">
									<div>관리자가 원격으로 서버에 접속 할 수 있는 접근 가능 주소 수를 입력해주세요. &nbsp;&nbsp;
										최대 <input type="text" id="adminaccessableaddressmaxcount" name="adminaccessableaddressmaxcount" value="2" class="text ui-widget-content" style="text-align: right; width: 100px;" /> 개
									</div>
								</div>
							</div>
							<div id="tab-certificatesetup" style="padding: 10px 0;">
								<div class="category-sub-title">인증 라이센스</div>
								<div class="category-sub-contents">
									<div id="row-representativecompanyid" class="field-line">
										<div class="field-title">대표 사업장 ID</div>
										<div class="field-value"><input type="text" id="representativecompanyid" name="representativecompanyid" class="text ui-widget-content" /></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="pane-footer">
					<div class="button-line">
						<button type="button" id="btnResetDb" name="btnResetDb" class="normal-button">DB 초기화</button>
						<button type="button" id="btnSaveConfig" name="btnSaveConfig" class="normal-button">설정 저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- 	<div class="ui-layout-south"> -->
<%-- 		<%@ include file ="/bottom.jsp"%> --%>
<!-- 	</div> -->
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
</body>
</html>