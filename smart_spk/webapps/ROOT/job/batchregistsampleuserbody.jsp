<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
	var g_objOrganizationTree;
	var g_objBatchRegistSampleUserManage;
	var g_objBatchRegistSampleUserStatus;

	var g_htCompanyList = new Hashtable();

	var g_selectedCompanyId = "";
	var g_selectedDeptCode = "";

	var g_bStopBatch = false;

	var g_registUserTotalCount = 0;
	var g_registUserProgressCount = 0;
	var g_registUserCountPerDept = 0;
	var g_registUserProgressCountPerDept = 0;
	var g_registUserSuccessCount = 0;
	var g_registUserFailCount = 0;

	var g_deptCountForRegistUser = 0;
	var g_deptIndexForRegistUser = 0;
	var g_arrDeptListForRegistUser = null;

	$(document).ready(function() {
		g_objOrganizationTree = $('#organization-tree');
		g_objBatchRegistSampleUserManage = $('#batchregistsampleuser-manage');
		g_objBatchRegistSampleUserStatus = $('#batchregistsampleuser-status');

		$( document ).tooltip();

		$('input:button, input:submit, button').button();
		$('#btnStart').button({ icons: {primary: "ui-icon-play"} });
		$('#btnCancel').button({ icons: {primary: "ui-icon-stop"} });

		$('#dialog:ui-dialog').dialog('destroy');

		loadCompanyList();
		innerDefaultLayout.show("west");
		loadOrganizationTreeView();

		g_objBatchRegistSampleUserManage.find('#registusercountperdept').change(function() {
			calculateForRegistUser();
		});

		g_objBatchRegistSampleUserStatus.find('#deptregistuserprogressbar').progressbar({
			value: 0
		});

		g_objBatchRegistSampleUserStatus.find('#totalregistuserprogressbar').progressbar({
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

	loadCompanyList = function() {

		var postData;

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		postData = getRequestCompanyListParam('', '', '', 'COMPANYNAME', 'ASC', '', '');
<% } else { %>
		postData = getRequestCompanyListParam('<%=(String)session.getAttribute("COMPANYID")%>', '', '', 'COMPANYNAME', 'ASC', '', '');
<% } %>

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

				if (!g_htCompanyList.isEmpty())
					g_htCompanyList.clear();

				$(data).find('record').each(function() {
					g_htCompanyList.put($(this).find('companyid').text(), $(this).find('companyname').text());
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 리스트 조회", "사업장 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadOrganizationTreeView = function() {

		var postData = "";

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		postData = getRequestOrganizationInfoParam('', "<%=OptionType.OPTION_TYPE_NO%>");
<% } else { %>
		postData = getRequestOrganizationInfoParam('<%=(String)session.getAttribute("COMPANYID")%>', "<%=OptionType.OPTION_TYPE_NO%>");
<% } %>

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				g_objOrganizationTree.block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				g_objOrganizationTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("조직 구성 정보 조회", "조직 구성 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var xmlTreeData = "";
				var companyNodeXml = "";
				var totalMemberCount = 0;

				$(data).find('company').each(function() {
					var itemId = $(this).find('companyid').text();

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					companyNodeXml += "<item id='" + itemId + "' parent_id='ALL' autocreatedeptcodeflag='" + $(this).find('autocreatedeptcodeflag').text() + "' node_type='company'>";
<% } else { %>
					companyNodeXml += "<item id='" + itemId + "' autocreatedeptcodeflag='" + $(this).find('autocreatedeptcodeflag').text() + "' node_type='company'>";
<% } %>
					if (($(this).find('membercount').text().length == 0) || ($(this).find('membercount').text() == "0")) {
						companyNodeXml += "<content><name>" + $(this).find('companyname').text() + "</name></content>";
					} else {
						totalMemberCount += parseInt($(this).find('membercount').text());
						companyNodeXml += "<content><name>" + $(this).find('companyname').text() + " [" + $(this).find('membercount').text() + "]</name></content>";
					}
					companyNodeXml += "</item>";
				});

				var deptNodeXml = "";

				$(data).find('dept').each(function() {
					var itemId = $(this).find('companyid').text() + "_" + $(this).find('deptcode').text();
					var itemParentId = "";
					if ($(this).find('parentdeptcode').text().length == 0) {
						itemParentId = $(this).find('companyid').text();
					} else {
						itemParentId = $(this).find('companyid').text() + "_" + $(this).find('parentdeptcode').text();
					}

					deptNodeXml += "<item id='" + itemId + "' parent_id='" + itemParentId + "' companyid='" + $(this).find('companyid').text() + "' deptcode='" + $(this).find('deptcode').text() + "' deptname='" + $(this).find('deptname').text() + "' parentdeptcode='" + $(this).find('parentdeptcode').text() + "' node_type='dept'>";
					if (($(this).find('membercount').text().length == 0) || ($(this).find('membercount').text() == "0")) {
						deptNodeXml += "<content><name>" + $(this).find('deptname').text() + "</name></content>";
					} else {
						deptNodeXml += "<content><name>" + $(this).find('deptname').text() + " [" + $(this).find('membercount').text() + "]</name></content>";
					}
					deptNodeXml += "</item>";
				});

				xmlTreeData += "<root>";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				xmlTreeData += "<item id='ALL' node_type='ROOT'>";
				if (totalMemberCount == 0) {
					xmlTreeData += "<content><name>전체 사업장</name></content>";
				} else {
					xmlTreeData += "<content><name>전체 사업장 [" + totalMemberCount + "]</name></content>";
				}
				xmlTreeData += "</item>";
<% } %>
				xmlTreeData += companyNodeXml + deptNodeXml;
				xmlTreeData += "</root>";

				g_objOrganizationTree.jstree({
					"xml_data" : {
						"data" : xmlTreeData
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
						//   this.css("color", "red")
						    //{ font-weight:bold}
						}
					},
					"contextmenu" : {
						"items" : null
					},
					"plugins" : [ "themes", "xml_data", "ui", "checkbox", "Select", "types", "crrm", "contextmenu" ]

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

					if (g_selectedDeptCode.length > 0) {
						g_objOrganizationTree.jstree('select_node', $('#' + g_selectedCompanyId + "_" + g_selectedDeptCode));
					} else if (g_selectedCompanyId.length > 0) {
						g_objOrganizationTree.jstree('select_node', $('#' + g_selectedCompanyId));
					}

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
					$('.treeview-pannel').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
					$('.treeview-pannel').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
				}).bind('select_node.jstree', function (event, data) {
					if (data.rslt.obj.attr('node_type') == "company") {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedDeptCode = "";
					} else if (data.rslt.obj.attr('node_type') == "dept") {
						g_selectedCompanyId = data.rslt.obj.attr('companyid');
						g_selectedDeptCode = data.rslt.obj.attr('deptcode');
					} else {
						g_selectedCompanyId = "";
						g_selectedDeptCode = "";
					}

					if ($.jstree._reference($(this)).is_checked('#' + data.rslt.obj.attr('id'))) {
						$.jstree._reference($(this)).uncheck_node('#' + data.rslt.obj.attr('id'));
					} else {
						$.jstree._reference($(this)).check_node('#' + data.rslt.obj.attr('id'));
					}
				}).bind('check_node.jstree', function (event, data) {
					calculateForRegistUser();
				}).bind('uncheck_node.jstree', function (event, data) {
					calculateForRegistUser();
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

	calculateForRegistUser = function() {

		g_arrDeptListForRegistUser = new Array();
		g_objOrganizationTree.find(".jstree-leaf").each(function(i, element) {
			if ($.jstree._reference($(this)).is_checked('#' + $(element).attr('id'))) {
				var arrDept = new Array();
				arrDept.push($(this).attr('companyid'));
				arrDept.push($(this).attr('deptcode'));
				arrDept.push($(this).attr('deptname'));
				g_arrDeptListForRegistUser.push(arrDept);
			}
		});

		g_deptCountForRegistUser = g_arrDeptListForRegistUser.length;

		g_registUserCountPerDept = parseInt(g_objBatchRegistSampleUserManage.find('#registusercountperdept').val());
		g_registUserTotalCount = g_deptCountForRegistUser * g_registUserCountPerDept;

		g_objBatchRegistSampleUserManage.find('#deptcountforregistuser').text(g_deptCountForRegistUser);
		g_objBatchRegistSampleUserManage.find('#registusertotalcount').text(g_registUserTotalCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		g_objBatchRegistSampleUserStatus.find('#registusertotalcount').text(g_registUserTotalCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		if (g_registUserTotalCount > 0) {
			$('#btnStart').button("enable");
		} else {
			$('#btnStart').button("disable");
		}
	};

	startProcess = function() {

		//clearTimeout(timeoutHandle);

		$('#btnStart').hide();
		$('#btnCancel').show();

		g_objOrganizationTree.find('*').prop('disabled',true);
		g_objBatchRegistSampleUserManage.find('#registusercountperdept').prop('disabled',true);

		g_objBatchRegistSampleUserStatus.show();

		var objTotalRegistUserCount = g_objBatchRegistSampleUserStatus.find('#registusertotalcount');
		var objRegistUserProgressCount = g_objBatchRegistSampleUserStatus.find('#registuserprocesscount');
		var objRegistUserSuccessCount = g_objBatchRegistSampleUserStatus.find('#registusersuccesscount');
		var objRegistUserFailCount = g_objBatchRegistSampleUserStatus.find('#registuserfailcount');

		var objDeptRegistUserProgressBar = g_objBatchRegistSampleUserStatus.find('#deptregistuserprogressbar');
		var objTotalRegistUserProgressBar = g_objBatchRegistSampleUserStatus.find('#totalregistuserprogressbar');

		g_bStopBatch = false;

		g_registUserProgressCount = 0;
		g_registUserProgressCountPerDept = 0;
		g_registUserSuccessCount = 0;
		g_registUserFailCount = 0;
		g_deptIndexForRegistUser = 0;

		objTotalRegistUserCount.text(g_registUserTotalCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objRegistUserProgressCount.text(g_registUserProgressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objRegistUserSuccessCount.text(g_registUserSuccessCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objRegistUserFailCount.text(g_registUserFailCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		objDeptRegistUserProgressBar.progressbar('value', g_registUserProgressCountPerDept.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objTotalRegistUserProgressBar.progressbar('value', g_registUserProgressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		setTimeout(function() { executeProcess(); }, 10);
	}

	executeProcess = function() {

		var objProcessDeptName = g_objBatchRegistSampleUserStatus.find('#processdeptname');
		var objResultMsg = g_objBatchRegistSampleUserStatus.find('#resultmessage');

		if (g_bStopBatch)
			return false;

		g_registUserProgressCount++;
		g_registUserProgressCountPerDept++;

		if (g_registUserProgressCount <= g_registUserTotalCount) {
			if (g_registUserProgressCountPerDept > g_registUserCountPerDept) {
				if (g_registUserCountPerDept == 1) {
					g_registUserProgressCountPerDept = 1;
				} else {
					g_registUserProgressCountPerDept = g_registUserProgressCountPerDept % g_registUserCountPerDept;
				}
				g_deptIndexForRegistUser++;
			}

			var companyId = g_arrDeptListForRegistUser[g_deptIndexForRegistUser][0];
			var deptCode = g_arrDeptListForRegistUser[g_deptIndexForRegistUser][1];
			var deptName = g_arrDeptListForRegistUser[g_deptIndexForRegistUser][2];
			var userId = companyId + "_" + deptCode + "_U" + g_registUserProgressCountPerDept;
			var userName = g_htCompanyList.get(companyId) + " " + deptName + " 사용자" + g_registUserProgressCountPerDept;
			var password = "qwe123!@#";
			var email = "";
			var phone = "";
			var mobilePhone = "";

			objProcessDeptName.text(g_htCompanyList.get(companyId) + " ==> " + deptName);
			objResultMsg.val(objResultMsg.val() + userName + " ==> ");

			var postData = getRequestInsertUserParam('<%=(String)session.getAttribute("ADMINID")%>',
					companyId,
					userId,
					password,
					userName,
					email,
					phone,
					mobilePhone,
					deptCode,
					<%=UserType.USER_TYPE_NORMAL%>,
					<%=JobProcessingType.JOB_PROCESSING_TYPE_NONE%>,
					<%=OptionType.OPTION_TYPE_YES%>,
					<%=OptionType.OPTION_TYPE_NO%>,
					<%=OptionType.OPTION_TYPE_YES%>);

			insertUser(postData);
		} else {
			g_registUserTotalCount = 0;
			g_registUserProgressCount = 0;
			g_registUserCountPerDept = 0;
			g_registUserProgressCountPerDept = 0;
			g_registUserSuccessCount = 0;
			g_registUserFailCount = 0;

			g_deptCountForRegistUser = 0;
			g_deptIndexForRegistUser = 0;
		}
	};

	function insertUser(postData) {

		var resultMsg = "";

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					g_registUserFailCount++;
					resultMsg = "[등록 실패] " + $(data).find('errormsg').text();
//					objResultMsg.val( objResultMsg.val() + "[등록 실패] " + $(data).find('errormsg').text() + "\n");
				} else {
					g_registUserSuccessCount++;
					resultMsg = "[정상 등록]";
//					objResultMsg.val( objResultMsg.val() + "[정상 등록]\n");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					g_registUserFailCount++;
					resultMsg = "[등록 실패] " + jqXHR.statusText + "(" + jqXHR.status + ")";
//					objResultMsg.val( objResultMsg.val() + "[등록 실패] " + jqXHR.statusText + "(" + jqXHR.status + ")\n");
/*
					objResult.text(jqXHR.statusText + "(" + jqXHR.status + ")");
					objResult.attr("title", jqXHR.statusText + "(" + jqXHR.status + ")");
					objResult.css('color', '#f58400');
*/
				}
			},
			complete: function(){
				displayResultStatus(resultMsg);
				setTimeout(function() { executeProcess(); }, 10);
			}
		});
	};

	displayResultStatus = function(resultMsg) {

		var objRegistUserProgressCount = g_objBatchRegistSampleUserStatus.find('#registuserprocesscount');
		var objRegistUserSuccessCount = g_objBatchRegistSampleUserStatus.find('#registusersuccesscount');
		var objRegistUserFailCount = g_objBatchRegistSampleUserStatus.find('#registuserfailcount');

		var objDeptRegistUserProgressBar = g_objBatchRegistSampleUserStatus.find('#deptregistuserprogressbar');
		var objTotalRegistUserProgressBar = g_objBatchRegistSampleUserStatus.find('#totalregistuserprogressbar');

		var objResultMsg = g_objBatchRegistSampleUserStatus.find('#resultmessage');

		objRegistUserProgressCount.text(g_registUserProgressCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objRegistUserSuccessCount.text(g_registUserSuccessCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
		objRegistUserFailCount.text(g_registUserFailCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

		var deptRegistUserProgressRate = 0;
		if (g_registUserProgressCountPerDept == g_registUserCountPerDept) {
			deptRegistUserProgressRate = 100;
		} else {
			deptRegistUserProgressRate = (g_registUserProgressCountPerDept/g_registUserCountPerDept)*100;
		}
		objDeptRegistUserProgressBar.progressbar('value', deptRegistUserProgressRate);

		var totalRegistUserProgressRate = 0;
		if (g_registUserProgressCount == g_registUserTotalCount) {
			totalRegistUserProgressRate = 100;
		} else {
			totalRegistUserProgressRate = (g_registUserProgressCount/g_registUserTotalCount)*100;
		}
		objTotalRegistUserProgressBar.progressbar('value', totalRegistUserProgressRate);

		objResultMsg.val(objResultMsg.val() + resultMsg + "\n");
	};
</script>

<div class="inner-west">
	<div class="pane-header ui-widget-header ui-corner-top">
		<div style="float: left; font-weight: bold;">조직 구성도</div>
		<div style="float: right; font-weight: normal;"><input type="checkbox" id="includechilddept" name="includechilddept" style="vertical-align: top; width: 12px; height: 12px;"/><label for="includechilddept"> 하위부서 포함</label></div>
		<div class="clear"></div>
	</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom" style="padding: 0;">
		<div id="organization-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center"> 
	<div class="pane-header ui-widget-header ui-corner-top">사용자 배치 등록</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom">
		<div id="batchregistsampleuser-manage">
			<div class="frame-body" style="padding: 10px;">
				<div class="category-sub-title">부서별 등록 사용자 설정</div>
				<div class="category-sub-contents">
					<div class="field-line">
						<div class="field-title">부서별 등록 사용자 수</div>
						<div class="field-value">
							<input type="text" id="registusercountperdept" name="registusercountperdept" class="text ui-widget-content" value="0" style="width: 50px;" /> 명
						</div>
					</div>
					<div class="field-line" style="margin-top: 30px;">
						<div class="field-title">총 등록 대상 부서 수</div>
						<div class="field-value">
							<span id="deptcountforregistuser">0</span> 부서
						</div>
					</div>
					<div class="field-line">
						<div class="field-title">총 등록 사용자 수</div>
						<div class="field-value">
							<span id="registusertotalcount">0</span> 명
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="batchregistsampleuser-status" style="margin-top: 60px; display: none;">
			<div class="frame-body" style="padding: 10px;">
				<div class="category-sub-title">배치 사용자 등록 현황</div>
				<div class="category-sub-contents">
					<div class="field-line">
						<div class="field-title">총 등록 사용자 수</div>
						<div class="field-value">
							<span id="registusertotalcount">0</span> 명
						</div>
					</div>
					<div class="field-line">
						<div class="field-title">등록 진행 사용자</div>
						<div class="field-value">
							<span id="registuserprocesscount">0</span> 번째 사용자
						</div>
					</div>
					<div class="field-line">
						<div class="field-title">등록 성공 사용자 수</div>
						<div class="field-value">
							<span id="registusersuccesscount">0</span> 명
						</div>
					</div>
					<div class="field-line">
						<div class="field-title">등록 실패 사용자 수</div>
						<div class="field-value">
							<span id="registuserfailcount">0</span> 명
						</div>
					</div>
					<div class="field-line" style="margin-top: 20px;">
						<div class="field-title">부서 사용자 등록</div>
						<div class="field-contents">
							<div id="deptregistuserprogressstatus">[ <span id="processdeptname"></span> ] 사용자 등록 중...</div>
							<div id="deptregistuserprogressbar" style="height: 8px;"></div>
						</div>
					</div>
					<div class="field-line" style="margin-top: 5px;">
						<div class="field-title">전체 사용자 등록</div>
						<div class="field-value" style="padding-top: 4px;">
							<div id="totalregistuserprogressbar" style="height: 8px;"></div>
						</div>
					</div>
					<div style="margin-top: 10px;">
						<textarea id="resultmessage" name="resultmessage" style="padding: 8px; width: 98%; height: 123px;"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="ui-state-default pane-footer">
		<div class="button-line">
			<button type="button" id="btnStart" name="btnStart" class="normal-button" disabled>등록 실행</button>
			<button type="button" id="btnCancel" name="btnCancel" class="normal-button" style="display: none;">실행 중지</button>
		</div>
	</div>
</div>
