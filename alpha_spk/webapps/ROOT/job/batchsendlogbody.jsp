<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
	var g_objOrganizationTree;
	var g_objBatchSendLogManage;
	var g_objBatchSendLogStatus;

	var g_htCompanyList = new Hashtable();

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
	var g_selectedCompanyId = "";
<% } else { %>
	var g_selectedCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>
	var g_selectedDeptCode = "";
	var g_selectedUserId = "";

	var g_bStopBatch = false;

	var g_totalSendLogCount = 0;
	var g_sendLogProgressCount = 0;
	var g_sendLogSuccessCount = 0;
	var g_sendLogFailCount = 0;
	var g_sendLogCountPerUser = 0;
	var g_sendLogProgressCountPerUser = 0;
	var g_detectDocFileCountPerUser = 0;
	var g_sendLogProgressCountPerDocFile = 0;
	var g_detectImgFileCountPerUser = 0;
	var g_sendLogProgressCountPerImgFile = 0;
	var g_detectZipFileCountPerUser = 0;
	var g_sendLogProgressCountPerZipFile = 0;

	var g_userCountForSendLog = 0;
	var g_userIndexForSendLog = 0;
	var g_arrUserListForSendLog = null;

	var g_sendLogCompanyId = "";
	var g_sendLogUserId = "";
	var g_sendLogUserName = "";
	var g_sendSearchId = "";
	var g_sendSearchDateString = "";

	$(document).ready(function() {
		g_objOrganizationTree = $('#organization-tree');
		g_objBatchSendLogManage = $('#batchsendsearchlog-manage');
		g_objBatchSendLogStatus = $('#batchsendsearchlog-status');

		$( document ).tooltip();

		$('input:button, input:submit, button').button();
		$('#btnStart').button({ icons: {primary: "ui-icon-play"} });
		$('#btnCancel').button({ icons: {primary: "ui-icon-stop"} });

		$('#dialog:ui-dialog').dialog('destroy');

		g_htCompanyList = loadCompanyList(g_selectedCompanyId);

		loadOrganizationTreeView();

		g_objBatchSendLogManage.find('#detectdocfilecountperuser').change(function() {
			calculateForSendLog();
		});

		g_objBatchSendLogManage.find('#detectimgfilecountperuser').change(function() {
			calculateForSendLog();
		});

		g_objBatchSendLogManage.find('#detectzipfilecountperuser').change(function() {
			calculateForSendLog();
		});

		g_objBatchSendLogStatus.find('#sendlogperuserprogressbar').progressbar({
			value: 0
		});

		g_objBatchSendLogStatus.find('#totalsendlogprogressbar').progressbar({
			value: 0
		});

		$('button').click( function () {
			if ($(this).attr('id') == 'btnStart') {
				startProcess();
			} else if ($(this).attr('id') == 'btnCancel') {
				g_bStopBatch = true;
			}
		});
	});

	loadCompanyList = function(companyId) {

		var g_htList = new Hashtable();
		var postData = getRequestCompanyListParam(companyId, '', '', 'COMPANYNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 리스트 조회", "사업장 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				if (!g_htList.isEmpty())
					g_htList.clear();

				$(data).find('record').each(function() {
					var companyId = $(this).find('companyid').text();
					var companyName = $(this).find('companyname').text();

					g_htList.put(companyId, companyName);
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 리스트 조회", "사업장 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
		return g_htList;
	};

	loadOrganizationTreeView = function() {

		var xmlTreeData = "";

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		postData = getRequestOrganizationInfoParam('', "<%=OptionType.OPTION_TYPE_YES%>");
<% } else { %>
		postData = getRequestOrganizationInfoParam(g_selectedCompanyId, "<%=OptionType.OPTION_TYPE_YES%>");
<% } %>

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			beforeSend: function() {
				g_objOrganizationTree.block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus ) {
				g_objOrganizationTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("조직 구성 정보 조회", "조직 구성 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyNodeXml = "";
				var totalMemberCount = 0;

				$(data).find('company').each(function() {
					var companyId = $(this).find('companyid').text();
					var companyName = $(this).find('companyname').text();
					var memberCount = $(this).find('membercount').text();

					var itemId = companyId;

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					companyNodeXml += "<item id='" + itemId + "' parent_id='ALL' node_type='company' companyid='" + companyId + "' companyname='" + companyName + "'>";
					if (memberCount == "0") {
						companyNodeXml += "<content><name>" + companyName + "</name></content>";
					} else {
						totalMemberCount += parseInt(memberCount);
						companyNodeXml += "<content><name>" + companyName + " [" + memberCount + "]</name></content>";
					}
					companyNodeXml += "</item>";
<% } else { %>
					companyNodeXml += "<item id='" + itemId + "' node_type='company' companyid='" + companyId + "' companyname='" + companyName + "'>";
					if (memberCount == "0") {
						companyNodeXml += "<content><name>" + companyName + "</name></content>";
					} else {
						companyNodeXml += "<content><name>" + companyName + " [" + memberCount + "]</name></content>";
					}
					companyNodeXml += "</item>";
<% } %>
				});

				var deptNodeXml = "";

				$(data).find('dept').each(function() {
					var companyId = $(this).find('companyid').text();
					var deptCode = $(this).find('deptcode').text();
					var deptName = $(this).find('deptname').text();
					var parentDeptCode = $(this).find('parentdeptcode').text();
					var memberCount = $(this).find('membercount').text();

					var itemId = "";
					var itemParentId = "";

					itemId = companyId + "_" + deptCode;

					if (parentDeptCode == "") {
						itemParentId = companyId;
					} else {
						itemParentId = companyId + "_" + parentDeptCode;
					}

					deptNodeXml += "<item id='" + itemId + "' parent_id='"  + itemParentId  + "' node_type='dept' companyid='" + companyId + "' deptcode='" + deptCode + "' deptname='" + deptName + "'>";
					if (memberCount == "0") {
						deptNodeXml += "<content><name>" + deptName + "</name></content>";
					} else {
						deptNodeXml += "<content><name>" + deptName + " [" + memberCount + "]</name></content>";
					}
					deptNodeXml += "</item>";
				});

				var userNodeXml = "";

				$(data).find('user').each(function() {
					var companyId = $(this).find('companyid').text();
					var deptCode = $(this).find('deptcode').text();
					var userId = $(this).find('userid').text();
					var userName = $(this).find('username').text();

					var itemId = "";
					var itemParentId = "";

					itemId = companyId + "_" + deptCode + "_" + userId;

					itemParentId = companyId + "_" + deptCode;

					userNodeXml += "<item id='" + itemId + "' parent_id='"  + itemParentId  + "' node_type='user' companyid='" + companyId + "' deptcode='" + deptCode + "' userid='" + userId + "' username='" + userName + "'>";
					userNodeXml += "<content><name>" + userName + "</name></content>";
					userNodeXml += "</item>";
				});

				xmlTreeData += "<root>";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				xmlTreeData += "<item id='ALL' state='open' node_type='root'>";
				if (totalMemberCount == 0) {
					xmlTreeData += "<content><name>전체 사업장</name></content>";
				} else {
					xmlTreeData += "<content><name>전체 사업장 [" + totalMemberCount + "]</name></content>";
				}
				xmlTreeData += "</item>";
<% } %>
				xmlTreeData += companyNodeXml + deptNodeXml + userNodeXml;
				xmlTreeData += "</root>";

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
				var themeName = "darkness";
<% } else { %>
				var themeName = "classic";
<% } %>

				g_objOrganizationTree.jstree({
					"xml_data" : {
						"data" : xmlTreeData
					},
					"themes": {
						"theme": themeName,
						"dots": true,
						"icons": false
					},
					"ui": {
						"select_limit": 1,
						"select_multiple_modifier": "none"
					},
					"checkbox": {
						"two_state": false,
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
					"plugins" : [ "themes", "xml_data", "ui", "checkbox", "Select", "types", "crrm" ]
				}).bind('loaded.jstree', function (event, data) {
					g_objOrganizationTree.jstree('open_all');

					$('.jstree-open').each(function() {
						if ($(this).attr('node_type') == "dept") {
							var hasChildDept = false;
							$(this).find("li").each(function(idx, childNode) {
								if ($(this).attr('node_type') == "dept") {
									hasChildDept = true;
									return false;
								}
							});
							if (!hasChildDept) {
								$.jstree._reference($(this)).close_node($(this), true);
							}
						}
					});

					if (g_selectedUserId.length > 0) {
						g_objOrganizationTree.jstree('select_node', $('#' + g_selectedCompanyId + "_" + g_selectedDeptCode + "_" + g_selectedUserId));
					} else if (g_selectedDeptCode.length > 0) {
						g_objOrganizationTree.jstree('select_node', $('#' + g_selectedCompanyId + "_" + g_selectedDeptCode));
					} else if (g_selectedCompanyId.length > 0) {
						g_objOrganizationTree.jstree('select_node', $('#' + g_selectedCompanyId));
					}

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
					g_objOrganizationTree.mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
					g_objOrganizationTree.mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
				}).bind('select_node.jstree', function (event, data) {
					if ( data.rslt.obj.attr('node_type') == "company" ) {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedDeptCode = "";
						g_selectedUserId = "";
					} else if ( data.rslt.obj.attr('node_type') == "dept" ) {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedDeptCode = data.rslt.obj.attr('deptcode');
						g_selectedUserId = "";
					} else if ( data.rslt.obj.attr('node_type') == "user" ) {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedDeptCode = data.rslt.obj.attr('deptcode');
						g_selectedUserId = data.rslt.obj.attr('userid');
					} else {
						g_selectedCompanyId = "";
						g_selectedDeptCode = "";
						g_selectedUserId = "";
					}

					if ($.jstree._reference($(this)).is_checked('#' + data.rslt.obj.attr('id'))) {
						$.jstree._reference($(this)).uncheck_node('#' + data.rslt.obj.attr('id'));
					} else {
						$.jstree._reference($(this)).check_node('#' + data.rslt.obj.attr('id'));
					}
				}).bind('check_node.jstree', function (event, data) {
					calculateForSendLog();
				}).bind('uncheck_node.jstree', function (event, data) {
					calculateForSendLog();
				});

				$('.button-line').show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("조직 구성 정보 조회", "조직 구성 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	calculateForSendLog = function() {

		g_arrUserListForSendLog = new Array();
		g_objOrganizationTree.find(".jstree-leaf").each(function(i, element) {
			if ($.jstree._reference($(this)).is_checked('#' + $(element).attr('id'))) {
				var arrUser = new Array();
				arrUser.push($(this).attr('companyid'));
				arrUser.push($(this).attr('userid'));
				arrUser.push($(this).attr('username'));
				g_arrUserListForSendLog.push(arrUser);
			}
		});

		g_userCountForSendLog = g_arrUserListForSendLog.length;

		g_detectDocFileCountPerUser = parseInt(g_objBatchSendLogManage.find('#detectdocfilecountperuser').val());
		g_detectImgFileCountPerUser = parseInt(g_objBatchSendLogManage.find('#detectimgfilecountperuser').val());
		g_detectZipFileCountPerUser = parseInt(g_objBatchSendLogManage.find('#detectzipfilecountperuser').val());

		var detectFileCountPerUser = g_detectDocFileCountPerUser + g_detectImgFileCountPerUser + g_detectZipFileCountPerUser;
		g_sendLogCountPerUser = detectFileCountPerUser;

		var totalDetectFileCount = g_userCountForSendLog * detectFileCountPerUser;

		g_totalSendLogCount = g_userCountForSendLog * g_sendLogCountPerUser;

		g_objBatchSendLogManage.find('#usercountforsendlog').text(g_userCountForSendLog.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogManage.find('#detectfilecountperuser').text(detectFileCountPerUser.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogManage.find('#sendlogcountperuser').text(g_sendLogCountPerUser.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogManage.find('#totaldetectfilecount').text(totalDetectFileCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogManage.find('#totalsendlogcount').text(g_totalSendLogCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		if (g_totalSendLogCount > 0) {
			$('#btnStart').button("enable");
		} else {
			$('#btnStart').button("disable");
		}
	};

	startProcess = function() {

		//clearTimeout(g_timeoutHandle);

		$('#btnStart').hide();
		$('#btnCancel').show();

		g_objOrganizationTree.find('*').prop('disabled',true);
		g_objBatchSendLogManage.find('#detectdocfilecountperuser').prop('disabled',true);
		g_objBatchSendLogManage.find('#detectimgfilecountperuser').prop('disabled',true);
		g_objBatchSendLogManage.find('#detectzipfilecountperuser').prop('disabled',true);

		g_bStopBatch = false;

		g_sendLogProgressCount = 0;
		g_sendLogSuccessCount = 0;
		g_sendLogFailCount = 0;
		g_userIndexForSendLog = 0;

		g_objBatchSendLogStatus.find('#usercountforsendlog').text(g_userCountForSendLog.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogStatus.find('#sendlogcountperuser').text(g_sendLogCountPerUser.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogStatus.find('#totalsendlogcount').text(g_totalSendLogCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogStatus.find('#sendlogsuccesscount').text(g_sendLogSuccessCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchSendLogStatus.find('#sendlogfailcount').text(g_sendLogFailCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		g_objBatchSendLogStatus.find('#sendlogperuserprogressbar').progressbar('value', 0);
		g_objBatchSendLogStatus.find('#totalsendlogprogressbar').progressbar('value', 0);

		g_objBatchSendLogStatus.show();

		setTimeout(function() { executeProcess(); }, 10);
	};

	executeProcess = function() {

		var objProcessUser = g_objBatchSendLogStatus.find('#processinguser');

		if (g_bStopBatch)
			return false;

		if (g_userIndexForSendLog < g_userCountForSendLog) {
			g_sendLogCompanyId = g_arrUserListForSendLog[g_userIndexForSendLog][0];
			g_sendLogUserId = g_arrUserListForSendLog[g_userIndexForSendLog][1];
			g_sendLogUserName = g_arrUserListForSendLog[g_userIndexForSendLog][2];

			g_userIndexForSendLog++;
			g_sendLogProgressCountPerUser = 0;
			g_sendLogProgressCountPerDocFile = 0;
			g_sendLogProgressCountPerImgFile = 0;
			g_sendLogProgressCountPerZipFile = 0;

			objProcessUser.text("[" + g_htCompanyList.get(g_sendLogCompanyId) + " ==> " + g_sendLogUserName + "] 사용자 로그 전송 중...(" + g_userIndexForSendLog + "/" + g_userCountForSendLog + ")");
			g_objBatchSendLogStatus.find('#sendlogperuserprogressbar').progressbar('value', 0);

			setTimeout(function() { sendSearchLog(); }, 10);
		}
	};

	function sendSearchLog() {

		if (g_bStopBatch)
			return false;

		var currentDatetime = new Date();
		var startDatetime = new Date();
		startDatetime.addTime('mm', -30);

		g_sendSearchId = "N" + currentDatetime.formatString("yyyyMMddhhmmss");
		g_sendSearchDateString = currentDatetime.formatString("yyyyMMdd");
		var startDatetimeString = startDatetime.formatString("yyyyMMddhhmmss");
		var endDatetimeString = currentDatetime.formatString("yyyyMMddhhmmss");

		var postData = "";
		postData += '<?xml version="1.0" encoding="utf-8" ?>';
		postData += '<ZAVAWARE>';
		postData += '<COMMAND>SEND_SEARCH_DATE</COMMAND>';
		postData += '<REQUEST>';
		postData += '<COMPANYID>' + g_sendLogCompanyId + '</COMPANYID>';
		postData += '<USERID>' + g_sendLogUserId + '</USERID>';
		postData += '<SEARCHID>' + g_sendSearchId + '</SEARCHID>';
		postData += '<SEARCHTYPE>' + "2" + '</SEARCHTYPE>';
		postData += '<STARTDATETIME>' + startDatetimeString + '</STARTDATETIME>';
		postData += '<ENDDATETIME>' + endDatetimeString + '</ENDDATETIME>';
		postData += '<IPADDRESS>' + "127.0.0.1" + '</IPADDRESS>';
		postData += '<CLIENTID>' + "FF:FF:FF:FF:FF:FF" + '</CLIENTID>';
		postData += '</REQUEST>';
		postData += '</ZAVAWARE>';

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					setTimeout(function() { quitProcess($(data).find('errormsg').text()); }, 1);
				} else {
					setTimeout(function() { sendDetectLog(); }, 10);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					setTimeout(function() { quitProcess(jqXHR.statusText + "(" + jqXHR.status + ")"); }, 1);
				}
			}
		});
	};

	function sendDetectLog() {

		if (g_bStopBatch)
			return false;

		var fileType = "";
		var patternId = "";
		var patternSubId = "";
		var patternDetectCount = 0;
		var searchPath = ""
		var result = "0";

		var postData = "";

		if (g_sendLogProgressCountPerUser < g_sendLogCountPerUser) {
			if (g_sendLogProgressCountPerDocFile < g_detectDocFileCountPerUser) {
				g_sendLogProgressCountPerDocFile++;
				fileType = "<%=FileType.FILE_TYPE_DOCUMENT%>";
				searchPath = "C:\\DocSample\\Doc" + g_sendLogProgressCountPerDocFile + ".doc";
				patternId = "1";
				patternSubId = "1011";
				patternDetectCount = "200"
			} else if (g_sendLogProgressCountPerImgFile < g_detectImgFileCountPerUser) {
				g_sendLogProgressCountPerImgFile++;
				fileType = "<%=FileType.FILE_TYPE_IMAGE%>";
				searchPath = "C:\\ImgSample\\Img" + g_sendLogProgressCountPerImgFile + ".jpg";
				patternId = "1";
				patternSubId = "1013";
				patternDetectCount = "100"
			} else if (g_sendLogProgressCountPerZipFile < g_detectZipFileCountPerUser) {
				g_sendLogProgressCountPerZipFile++;
				fileType = "<%=FileType.FILE_TYPE_MIXED%>";
				searchPath = "C:\\ZipSample\\Zip" + g_sendLogProgressCountPerZipFile + ".zip";
				patternId = "5";
				patternSubId = "5011";
				patternDetectCount = "50"
			}

			postData += '<?xml version="1.0" encoding="utf-8" ?>';
			postData += '<ZAVAWARE>';
			postData += '<COMMAND>SEND_SEARCH_LOG</COMMAND>';
			postData += '<REQUEST>';
			postData += '<COMPANYID>' + g_sendLogCompanyId + '</COMPANYID>';
			postData += '<USERID>' + g_sendLogUserId + '</USERID>';
			postData += '<SEARCHID>' + g_sendSearchId + '</SEARCHID>';
			postData += '<SEARCHTYPE>' + "2" + '</SEARCHTYPE>';
			postData += '<SEARCHSEQNO>' + g_sendLogProgressCountPerUser + '</SEARCHSEQNO>';
			postData += '<SEARCHDATE>' + g_sendSearchDateString + '</SEARCHDATE>';
			postData += '<PATTERNID>' + patternId + '</PATTERNID>';
			postData += '<PATTERNSUBID>' + patternSubId + '</PATTERNSUBID>';
			postData += '<PATTERNDETECTCNT>' + patternDetectCount + '</PATTERNDETECTCNT>';
			postData += '<SEARCHWORD></SEARCHWORD>';
			postData += '<SEARCHPATH><![CDATA[' + searchPath + ']]></SEARCHPATH>';
			postData += '<FILETYPE>' + fileType + '</FILETYPE>';
			postData += '<FILEID></FILEID>';
			postData += '<RESULT>' + result + '</RESULT>';
			postData += '<IPADDRESS>' + "127.0.0.1" + '</IPADDRESS>';
			postData += '<CLIENTID>' + "FF:FF:FF:FF:FF:FF" + '</CLIENTID>';
			postData += '</REQUEST>';
			postData += '</ZAVAWARE>';

			$.ajax({
				type: "POST",
				url: "/CommandService",
				data: $.param({sendmsg : postData}),
				dataType: "xml",
				cache: false,
				async: false,
				success: function(data, textStatus, jqXHR) {
					if ($(data).find('errorcode').text() != "0000") {
						g_sendLogFailCount++;
					} else {
						g_sendLogSuccessCount++;
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						g_sendLogFailCount++;
					}
				},
				complete: function(){
					g_sendLogProgressCount++;
					g_sendLogProgressCountPerUser++;
					displayResultStatus();
					setTimeout(function() { sendDetectLog(); }, 10);
				}
			});
		} else {
			setTimeout(function() { executeProcess(); }, 10);
		}
	};

	quitProcess = function(errorMsg) {
		displayAlertDialog("프로세스 비정상 종료", "처리 중 오류가 발생하여 비정상 종료합니다.", errorMsg);
	};

	displayResultStatus = function() {

		var objSendLogProgressCount = g_objBatchSendLogStatus.find('#sendlogprogresscount');
		var objSendLogSuccessCount = g_objBatchSendLogStatus.find('#sendlogsuccesscount');
		var objSendLogFailCount = g_objBatchSendLogStatus.find('#sendlogfailcount');

		var objSendLogPerUserProgressBar = g_objBatchSendLogStatus.find('#sendlogperuserprogressbar');
		var objTotalSendLogProgressBar = g_objBatchSendLogStatus.find('#totalsendlogprogressbar');

		objSendLogProgressCount.text(g_sendLogProgressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objSendLogSuccessCount.text(g_sendLogSuccessCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objSendLogFailCount.text(g_sendLogFailCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		var sendLogPerUserProgressRate = 0;
		if (g_sendLogProgressCountPerUser == g_sendLogCountPerUser) {
			sendLogPerUserProgressRate = 100;
		} else {
			sendLogPerUserProgressRate = (g_sendLogProgressCountPerUser/g_sendLogCountPerUser)*100;
		}
		objSendLogPerUserProgressBar.progressbar('value', sendLogPerUserProgressRate);

		var totalSendLogProgressRate = 0;
		if (g_sendLogProgressCount == g_totalSendLogCount) {
			totalSendLogProgressRate = 100;
		} else {
			totalSendLogProgressRate = (g_sendLogProgressCount/g_totalSendLogCount)*100;
		}
		objTotalSendLogProgressBar.progressbar('value', totalSendLogProgressRate);
	};
</script>

<div class="ui-widget site-map-path">
	<span class="parent-path">샘플 검사(검출) 내역 전송</span>
</div>

<div class="main-frame">
	<div class="main-left-frame" style="width: 25%;">
		<div class="frame-contents ui-widget-content ui-corner-all">
			<div class="ui-widget-header ui-corner-top frame-header">
				<span style="float: left; font-weight: bold;">조직 구성도</span>
				<div class="clear"></div>
			</div>
			<div id="organization-tree" class="treeview-pannel"></div>
		</div>
	</div>
	<div class="main-right-frame-wrapper" style="width: 74.5%;">
		<div class="main-right-frame">
			<div id="batchsendsearchlog-manage" class="frame-contents ui-widget-content ui-corner-left">
				<div class="ui-widget-header ui-corner-top frame-header">
					<span style="float: left; font-weight: bold;">전송 설정</span>
					<div class="clear"></div>
				</div>
				<div class="frame-body" style="padding: 10px;">
					<div class="category-sub-title">사용자별 검출 설정</div>
					<div class="category-sub-contents">
						<div class="field-line">
							<div class="field-title">문서 파일 검출 수</div>
							<div class="field-value">
								<input type="text" id="detectdocfilecountperuser" name="detectdocfilecountperuser" class="text ui-widget-content" value="0" style="width: 50px;" /> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">이미지 파일 검출 수</div>
							<div class="field-value">
								<input type="text" id="detectimgfilecountperuser" name="detectimgfilecountperuser" class="text ui-widget-content" value="0" style="width: 50px;" /> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">압축 파일 검출 수</div>
							<div class="field-value">
								<input type="text" id="detectzipfilecountperuser" name="detectzipfilecountperuser" class="text ui-widget-content" value="0" style="width: 50px;" /> 건
							</div>
						</div>
						<div class="field-line" style="margin-top: 25px;">
							<div class="field-title">로그 전송 사용자 수</div>
							<div class="field-value">
								<span id="usercountforsendlog">0</span> 명
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">사용자별 검출 파일 수</div>
							<div class="field-value">
								<span id="detectfilecountperuser">0</span> 파일
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">사용자별 전송 로그 수</div>
							<div class="field-value">
								<span id="sendlogcountperuser">0</span> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">총 검출 파일 수</div>
							<div class="field-value">
								<span id="totaldetectfilecount">0</span> 파일
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">총 전송 로그 수</div>
							<div class="field-value">
								<span id="totalsendlogcount">0</span> 건
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="button-line">
				<button type="button" id="btnStart" name="btnStart" class="normal-button" disabled>전송 실행</button>
				<button type="button" id="btnCancel" name="btnCancel" class="normal-button" style="display: none;">전송 중지</button>
			</div>
			<div id="batchsendsearchlog-status" class="frame-contents ui-widget-content ui-corner-left" style="margin-top: 60px; display: none;">
				<div class="ui-widget-header ui-corner-top frame-header">
					<span style="float: left; font-weight: bold;">전송 현황</span>
					<div class="clear"></div>
				</div>
				<div class="frame-body" style="padding: 10px;">
					<div class="category-sub-title">로그 전송 현황</div>
					<div class="category-sub-contents">
						<div class="field-line">
							<div class="field-title">로그 전송 사용자 수</div>
							<div class="field-value">
								<span id="usercountforsendlog"></span> 명
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">사용자별 전송 로그 수</div>
							<div class="field-value">
								<span id="sendlogcountperuser"></span> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">총 전송 로그 수</div>
							<div class="field-value">
								<span id="totalsendlogcount"></span> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">전송 로그 진행 수</div>
							<div class="field-value">
								<span id="sendlogprogresscount"></span> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">전송 성공 로그 수</div>
							<div class="field-value">
								<span id="sendlogsuccesscount"></span> 건
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">전송 실패 로그 수</div>
							<div class="field-value">
								<span id="sendlogfailcount"></span> 건
							</div>
						</div>
						<div class="field-line" style="margin-top: 20px;">
							<div class="field-title">전송 진행 사용자</div>
							<div class="field-value" style="padding-top: 2px;">
								<span id="processinguser"></span>
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">사용자 로그 전송</div>
							<div class="field-value" style="padding-top: 2px;">
								<div id="sendlogperuserprogressbar" style="height: 10px; width: 80%;"></div>
							</div>
						</div>
						<div class="field-line">
							<div class="field-title">총 로그 전송</div>
							<div class="field-value" style="padding-top: 2px;">
								<div id="totalsendlogprogressbar" style="height: 10px; width: 80%;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
