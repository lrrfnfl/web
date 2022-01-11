<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="companydefaultpattern-dialog.jsp"%>
<%@ include file ="companysetupconfig-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objCompanyList;
	var g_objCompanyInfo;

	var g_htServiceStateList = new Hashtable();
	var g_htOptionTypeList = new Hashtable();
	var g_arrPatternList = new Array();
	var g_htSupportFunctionTypeList = new Hashtable();
	
	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objCompanyList = $('#company-list');
		g_objCompanyInfo = $('#company-info');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
<% } %>
		$('button[name="btnStopService"]').button({ icons: {primary: "ui-icon-locked"} });
		$('button[name="btnResumeService"]').button({ icons: {primary: "ui-icon-unlocked"} });
<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnSetupConfig"]').button({ icons: {primary: "ui-icon-gear"} });
<% } %>
		$('button[name="btnSetupPattern"]').button({ icons: {primary: "ui-icon-note"} });
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnInsert"]').button({ icons: {primary: "ui-icon-circle-plus"} });
<% } %>
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htServiceStateList = loadTypeList("SERVICE_STATE");
		if (g_htServiceStateList.isEmpty()) {
			displayAlertDialog("서비스 상태 유형 조회", "서비스 상태 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htSupportFunctionTypeList = loadTypeList("SUPPORT_FUNCTION_TYPE");
		if (g_htSupportFunctionTypeList.isEmpty()) {
			displayAlertDialog("지원기능 옵션 유형 조회", "지원기능 옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList($('#search-condition').find('select[name="searchservicestate"]'), g_htServiceStateList, null, "전체");
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]').val("180");

		g_arrPatternList = loadPatternList();

		innerDefaultLayout.show("west");
		loadCompanyTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadCompanyList();
			} else if ($(this).attr('id') == 'btnNew') {
				newCompany();
			} else if ($(this).attr('id') == 'btnStopService') {
				displayConfirmDialog("사업장 서비스 중지", "사업장 서비스를 중지하시겠습니까?", "", function() { changeCompanyServiceState("<%=ServiceState.SERVICE_STATE_STOP%>"); } );
			} else if ($(this).attr('id') == 'btnResumeService') {
				displayConfirmDialog("사업장 서비스 중지 해제", "사업장 서비스 중지를 해제하시겠습니까?", "", function() { changeCompanyServiceState("<%=ServiceState.SERVICE_STATE_NORMAL%>"); } );
			} else if ($(this).attr('id') == 'btnSetupConfig') {
				openCompanySetupConfigDialog();
			} else if ($(this).attr('id') == 'btnSetupPattern') {
				openCompanyDefaultPatternDialog();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateCompanyData(MODE_INSERT)) {
					insertCompany();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateCompanyData(MODE_UPDATE)) {
					displayConfirmDialog("사업장 정보 수정", "사업장 정보를 수정하시겠습니까?", "", function() { updateCompany(); } );
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("사업장 삭제", "사업장을 삭제하시겠습니까?<br /><br /><font color='#C24125'>사업장을 삭제할 경우 사업장과 관련된 모든 데이타가 삭제되어 복구가 불가능합니다.</font>", "", function() { deleteCompany(); } );
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { onClickTr($(this)); });
	});

	onClickTr = function(objTr) {
		var objTree = $.jstree._reference(g_objCompanyTree); 
		var companyId = objTr.attr('companyid');
		var companyName = objTr.attr('companyname').charAt(0);
		objTree.deselect_node(objTree.get_selected());
		if (objTree._get_node('#cid_' + companyId).length) {
			objTree.select_node('#cid_' + companyId);
		} else {
			var companyName = objTr.attr('companyname').charAt(0);
			var categoryId;
			if (companyName.charAt(0).match('[가-힣]')) {
				var categoryCode = "기타";
				var nTmp=companyName.charCodeAt(0) - 0xAC00;
				if (nTmp>-1 && nTmp<11172) {
					var cho, jung, jong;
					jong=nTmp % 28; // 종성
					jung=( (nTmp-jong)/28 ) % 21; // 중성
					cho=( ( (nTmp-jong)/28 ) - jung ) / 21; // 종성
					categoryCode = String.fromCharCode((cho * 21) * 28 + 0xAC00);
				}
				switch(categoryCode) {
					case "까":
						categoryCode = "가";
						break;
					case "따":
						categoryCode = "다";
						break;
					case "빠":
						categoryCode = "바";
						break;
					case "싸":
						categoryCode = "사";
						break;
					case "짜":
						categoryCode = "자";
						break;
					default:
						break;
				}
				categoryId = 'category_' + categoryCode;
			} else {
				categoryId = 'category_기타';
			}
			if (objTree._get_node('#' + categoryId).length) {
				objTree.open_node('#' + categoryId);
			}
			if (objTree._get_node('#cid_' + companyId).length) {
				objTree.select_node('#cid_' + companyId);
			}
		}
	};

	loadPatternList = function() {

		var arrList = new Array();

		var postData = getRequestPatternListParam('',
				'',
				'',
				'PATTERNID, PATTERNSUBID',
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
					displayAlertDialog("패턴 목록 조회", "패턴 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}
				$(data).find('record').each( function() {
					var arrPattern = new Array();
					arrPattern.push($(this).find('patternid').text());
					arrPattern.push($(this).find('patterncategoryname').text());
					arrPattern.push($(this).find('patternsubid').text());
					arrPattern.push($(this).find('patternname').text());
					arrList.push(arrPattern);
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("패턴 목록 조회", "패턴 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return arrList;
	};

	loadCompanyTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[전체 사업장]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "</root>";

		g_objCompanyTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var categoryCode;
							if (node.attr("node_type") == 'company_category') {
								categoryCode = node.children('a').text().trim();
							} else {
								categoryCode = "";
							}
							var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_COMPANY%>', categoryCode, '');
							return {
								sendmsg : postData
							};
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('load_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if ($(this).attr('node_type') == "company") {
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
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (data.rslt.obj.attr('node_type') == "company") {
					loadCompanyInfo(data.rslt.obj.attr('companyid'));
				} else {
					if (data.rslt.obj.attr('node_type') != "company_category") {
						g_searchListOrderByName = "";
						g_searchListOrderByDirection = "";
						g_searchListPageNo = 1;
						loadCompanyList();
					}
				}
			}
		});
	};

	loadCompanyList = function() {

		var objSearchCondition = g_objCompanyList.find('#search-condition');
		var objSearchResult = g_objCompanyList.find('#search-result');

		var objSearchCompanyName = objSearchCondition.find('input[name="searchcompanyname"]');
		var objSearchServiceState = objSearchCondition.find('select[name="searchservicestate"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		if (objSearchCompanyName.val().length >0) {
			if (!isValidParam(objSearchCompanyName, PARAM_TYPE_SEARCH_KEYWORD, "사업장 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchCompanyName.hasClass('ui-state-error') )
			objSearchCompanyName.removeClass('ui-state-error');
		}

		var postData = getRequestCompanyListParam('',
				objSearchCompanyName.val(),
				objSearchServiceState.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection,
				<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>,
				g_searchListPageNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="COMPANYID" class="ui-state-default">사업장 ID</th>';
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">사업장 명</th>';
				htmlContents += '<th id="SERVICESTATEFLAG" width="20%" class="ui-state-default">서비스 상태</th>';
				htmlContents += '<th id="CREATEDATETIME" width="20%" class="ui-state-default">등록일시</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				if (resultRecordCount > 0) {
					$(data).find('record').each( function(index) {
						var lineStyle = '';
						if (index%2 == 0)
							lineStyle = "list_odd";
						else
							lineStyle = "list_even";

						var companyId = $(this).find('companyid').text();
						var companyName = $(this).find('companyname').text();
						var serviceStateFlag = $(this).find('servicestateflag').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr companyid=' + companyId + ' companyname=' + companyName + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + companyId + '</td>';
						htmlContents += '<td>' + companyName + '</td>';
						if (serviceStateFlag == "<%=ServiceState.SERVICE_STATE_STOP%>") {
							htmlContents += '<td class="state-abnormal" style="text-align:center;">' + g_htServiceStateList.get(serviceStateFlag) + '</td>';
						} else {
							htmlContents += '<td style="text-align:center;">' + g_htServiceStateList.get(serviceStateFlag) + '</td>';
						}
						htmlContents += '<td style="text-align:center;">' + createDatetime + '</td>';
						htmlContents += '</tr>';
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var totalPageCount;
					if (totalRecordCount%<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>== 0) {
						totalPageCount = totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>;
					} else {
						totalPageCount = Math.floor(totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>) + 1;
					}

					if (totalPageCount >1) {
						objPagination.show();
						objPagination.paging({
							current: g_searchListPageNo,
							max: totalPageCount,
							onclick: function(e, page){
								g_searchListPageNo = page;
								loadCompanyList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="4" align="center"><div style="padding: 10px 0; text-align: center;">등록된 사업장이 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnNew"]').show();
<% } %>
				$('#btnStopService').hide();
				$('#btnResumeService').hide();
<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnSetupConfig"]').hide();
<% } %>
				$('button[name="btnSetupPattern"]').hide();
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnInsert"]').hide();
<% } %>
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();

				$('.inner-center .pane-header').text('전체 사업장 목록');
				g_objCompanyInfo.hide();
				g_objCompanyList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadCompanyInfo = function(targetCompanyId) {

		var objCompanyId = g_objCompanyInfo.find('input[name="companyid"]');
		var objCompanyName = g_objCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objCompanyInfo.find('input[name="managermobilephone"]');
		var objAutoCreateDeptCode = g_objCompanyInfo.find('select[name="autocreatedeptcode"]');
		var objServiceState = g_objCompanyInfo.find('#servicestate');
		var objServiceStoppedDatetime = g_objCompanyInfo.find('#servicestoppeddatetime');
		var objTargetPatternCount = g_objCompanyInfo.find('#targetpatterncount');
		var objLastModifiedDatetime = g_objCompanyInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objCompanyInfo.find('#createdatetime');

		var objRowServiceState = g_objCompanyInfo.find('#row-servicestate');
		var objRowServiceStoppedDatetime = g_objCompanyInfo.find('#row-servicestoppeddatetime');
		var objRowLastModifiedDatetime = g_objCompanyInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objCompanyInfo.find('#row-createdatetime');

		g_objCompanyInfo.find('#validateTips').hide();
		g_objCompanyInfo.find('input:text').each( function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		var postData = getRequestCompanyInfoByIdParam(targetCompanyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 정보 조회", "사업장 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var companyPostalCode = $(data).find('companypostalcode').text();
				var companyAddress = $(data).find('companyaddress').text();
				var companyDetailAddress = $(data).find('companydetailaddress').text();
				var managerName = $(data).find('managername').text();
				var managerEmail = $(data).find('manageremail').text();
				var managerPhone = $(data).find('managerphone').text();
				var managerMobilePhone = $(data).find('managermobilephone').text();
				var autoCreateDeptCodeFlag = $(data).find('autocreatedeptcodeflag').text();
				var serviceStateFlag = $(data).find('servicestateflag').text();
				var serviceStoppedDatetime = $(data).find('servicestoppeddatetime').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				objCompanyId.val(companyId);
				objCompanyName.val(companyName);
				objCompanyPostalCode.val(companyPostalCode);
				objCompanyAddress.val(companyAddress);
				objCompanyDetailAddress.val(companyDetailAddress);
				objManagerName.val(managerName);
				objManagerEmail.val(managerEmail);
				objManagerPhone.val(managerPhone);
				objManagerMobilePhone.val(managerMobilePhone);
				fillDropdownList(objAutoCreateDeptCode, g_htOptionTypeList, autoCreateDeptCodeFlag, null);
				objServiceState.text(g_htServiceStateList.get(serviceStateFlag));
				if (serviceStateFlag == "<%=ServiceState.SERVICE_STATE_STOP%>") {
					objServiceState.addClass("state-abnormal");
				} else {
					objServiceState.removeClass("state-abnormal");
				}
				objServiceStoppedDatetime.text(serviceStoppedDatetime);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objCompanyId.attr('readonly', true);
				objCompanyId.blur();
				objCompanyId.addClass('ui-priority-secondary');
				objCompanyId.tooltip({ disabled: true });
				objAutoCreateDeptCode.attr('disabled', true);
				objRowServiceState.show();
				objRowServiceStoppedDatetime.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				var dbProtectionOption = $(data).find('dbprotectionoption').text();
				var printControlOption = $(data).find('printcontroloption').text();
				var waterMarkOption = $(data).find('watermarkoption').text();
				var mediaControlOption = $(data).find('mediacontroloption').text();
				var networkServiceControlOption = $(data).find('networkservicecontroloption').text();
				var softwareManageOption = $(data).find('softwaremanageoption').text();
				var ransomwareDetectionOption = $(data).find('ransomwaredetectionoption').text();
				var defaultKeepFilePeriod = $(data).find('defaultkeepfileperiod').text();

				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]'), g_htSupportFunctionTypeList, dbProtectionOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]'), g_htSupportFunctionTypeList, printControlOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]'), g_htSupportFunctionTypeList, waterMarkOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]'), g_htSupportFunctionTypeList, mediaControlOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]'), g_htSupportFunctionTypeList, networkServiceControlOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]'), g_htSupportFunctionTypeList, softwareManageOption, null);
				fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]'), g_htSupportFunctionTypeList, ransomwareDetectionOption, null);
				g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]').val(defaultKeepFilePeriod);

				fillCompanyDefaultPatternList(g_arrPatternList);
				$(data).find('pattern').each( function() {
					var patternId = $(this).find('patternid').text();
					var patternSubId = $(this).find('patternsubid').text();
					g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').each( function () {
						if (($(this).attr('patternid') == patternId) && ($(this).attr('patternsubid') == patternSubId)) {
							$(this).prop('checked', true);
						}
					});
				});
				objTargetPatternCount.text(g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').filter(':checked').length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 패턴");

<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnNew"]').show();
<% } %>
				if (serviceStateFlag == <%=ServiceState.SERVICE_STATE_NORMAL%>) {
					$('#btnStopService').show();
					$('#btnResumeService').hide();
				} else {
					$('#btnStopService').hide();
					$('#btnResumeService').show();
				}
<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnSetupConfig"]').show();
<% } %>
				$('button[name="btnSetupPattern"]').show();
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
				$('button[name="btnInsert"]').hide();
<% } %>
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();

				$('.inner-center .pane-header').text('사업장 정보 - [' + companyName + ']');
				g_objCompanyList.hide();
				g_objCompanyInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 정보 조회", "사업장 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newCompany = function() {

		var objCompanyId = g_objCompanyInfo.find('input[name="companyid"]');
		var objAutoCreateDeptCode = g_objCompanyInfo.find('select[name="autocreatedeptcode"]');
		var objTargetPatternCount = g_objCompanyInfo.find('#targetpatterncount');

		var objRowServiceState = g_objCompanyInfo.find('#row-servicestate');
		var objRowServiceStoppedDatetime = g_objCompanyInfo.find('#row-servicestoppeddatetime');
		var objRowLastModifiedDatetime = g_objCompanyInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objCompanyInfo.find('#row-createdatetime');

		g_objCompanyInfo.find('#validateTips').hide();
		g_objCompanyInfo.find('input:text').each( function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		objCompanyId.attr('readonly', false);
		objCompanyId.removeClass('ui-priority-secondary');
		objCompanyId.tooltip({ disabled: false });
		fillDropdownList(objAutoCreateDeptCode, g_htOptionTypeList, '<%=OptionType.OPTION_TYPE_YES%>', null);
		objAutoCreateDeptCode.attr('disabled', false);
		objRowServiceState.hide();
		objRowServiceStoppedDatetime.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		fillDropdownList(g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]'), g_htSupportFunctionTypeList, <%=SupportFunctionType.SUPPORT_FUNCTION_TYPE_ACTIVATE%>, null);
		g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]').val("180");

		fillCompanyDefaultPatternList(g_arrPatternList);
		g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').each( function () {
			$(this).prop('checked', true);
		});

		objTargetPatternCount.text(g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').filter(':checked').length.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 패턴");

<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnNew"]').hide();
<% } %>
		$('#btnStopService').hide();
		$('#btnResumeService').hide();
<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnSetupConfig"]').show();
<% } %>
		$('button[name="btnSetupPattern"]').show();
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
		$('button[name="btnInsert"]').show();
<% } %>
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 사업장');
		g_objCompanyList.hide();
		g_objCompanyInfo.show();
	};

	insertCompany = function() {

		var htCompanySetupConfigData = new Hashtable();
		htCompanySetupConfigData.put("dbprotectionoption", g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]').val());
		htCompanySetupConfigData.put("printcontroloption", g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]').val());
		htCompanySetupConfigData.put("watermarkoption", g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]').val());
		htCompanySetupConfigData.put("mediacontroloption", g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]').val());
		htCompanySetupConfigData.put("networkservicecontroloption", g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]').val());
		htCompanySetupConfigData.put("softwaremanageoption", g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]').val());
		htCompanySetupConfigData.put("ransomwaredetectionoption", g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]').val());
		htCompanySetupConfigData.put("defaultkeepfileperiod", g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]').val());

		var postData = getRequestInsertCompanyParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objCompanyInfo.find('input[name="companyid"]').val(),
				g_objCompanyInfo.find('input[name="companyname"]').val(),
				g_objCompanyInfo.find('input[name="companypostalcode"]').val(),
				g_objCompanyInfo.find('input[name="companyaddress"]').val(),
				g_objCompanyInfo.find('input[name="companydetailaddress"]').val(),
				g_objCompanyInfo.find('input[name="managername"]').val(),
				g_objCompanyInfo.find('input[name="manageremail"]').val(),
				g_objCompanyInfo.find('input[name="managerphone"]').val(),
				g_objCompanyInfo.find('input[name="managermobilephone"]').val(),
				g_objCompanyInfo.find('select[name="autocreatedeptcode"]').val(),
				htCompanySetupConfigData,
				getSelectedPatternList());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 등록", "사업장 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadCompanyTreeView();
					displayInfoDialog("사업장 등록", "정상 처리되었습니다.", "정상적으로 사업장이 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 등록", "사업장 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateCompany = function() {

		var htCompanySetupConfigData = new Hashtable();
		htCompanySetupConfigData.put("dbprotectionoption", g_objCompanySetupConfigDialog.find('select[name="dbprotectionoption"]').val());
		htCompanySetupConfigData.put("printcontroloption", g_objCompanySetupConfigDialog.find('select[name="printcontroloption"]').val());
		htCompanySetupConfigData.put("watermarkoption", g_objCompanySetupConfigDialog.find('select[name="watermarkoption"]').val());
		htCompanySetupConfigData.put("mediacontroloption", g_objCompanySetupConfigDialog.find('select[name="mediacontroloption"]').val());
		htCompanySetupConfigData.put("networkservicecontroloption", g_objCompanySetupConfigDialog.find('select[name="networkservicecontroloption"]').val());
		htCompanySetupConfigData.put("softwaremanageoption", g_objCompanySetupConfigDialog.find('select[name="softwaremanageoption"]').val());
		htCompanySetupConfigData.put("ransomwaredetectionoption", g_objCompanySetupConfigDialog.find('select[name="ransomwaredetectionoption"]').val());
		htCompanySetupConfigData.put("defaultkeepfileperiod", g_objCompanySetupConfigDialog.find('input[name="defaultkeepfileperiod"]').val());

		var postData = getRequestUpdateCompanyParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objCompanyInfo.find('input[name="companyid"]').val(),
				g_objCompanyInfo.find('input[name="companyname"]').val(),
				g_objCompanyInfo.find('input[name="companypostalcode"]').val(),
				g_objCompanyInfo.find('input[name="companyaddress"]').val(),
				g_objCompanyInfo.find('input[name="companydetailaddress"]').val(),
				g_objCompanyInfo.find('input[name="managername"]').val(),
				g_objCompanyInfo.find('input[name="manageremail"]').val(),
				g_objCompanyInfo.find('input[name="managerphone"]').val(),
				g_objCompanyInfo.find('input[name="managermobilephone"]').val(),
				g_objCompanyInfo.find('select[name="autocreatedeptcode"]').val(),
				htCompanySetupConfigData,
				getSelectedPatternList());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 정보 변경", "사업장 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objCompanyTree);
					var companyId = g_objCompanyInfo.find('input[name="companyid"]').val();
					var beforeCompanyName = objTreeReference.get_text(objTreeReference.get_selected());
					var afterCompanyName = g_objCompanyInfo.find('input[name="companyname"]').val();
					if (beforeCompanyName.charAt(0) != afterCompanyName.charAt(0)) {
						var objParentNode = objTreeReference._get_parent(objTreeReference.get_selected());
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objParentNode);
						if (objParentNode.attr("node_type") == "company_category") {
							var categoryId;
							if (afterCompanyName.charAt(0).match('[가-힣]')) {
								categoryId = 'category_' + afterCompanyName.charAt(0);
							} else {
								categoryId = 'category_기타';
							}
							if (objTreeReference._get_node('#' + categoryId).length) {
								objTreeReference.refresh('#' + categoryId);
								if (objTreeReference._get_node('#cid_' + companyId).length) {
									objTreeReference.select_node('#cid_' + companyId);
								}
								if (objTreeReference._get_node('#' + categoryId).hasClass('jstree-leaf')) {
									objTreeReference._get_node('#' + categoryId).removeClass('jstree-leaf')
									objTreeReference._get_node('#' + categoryId).addClass('jstree-open');
								}
							}
						} else {
							objTreeReference.select_node('#cid_' + companyId);
						}
					} else {
						loadCompanyInfo(companyId);
					}
					displayInfoDialog("사업장 정보 변경", "정상 처리되었습니다.", "정상적으로 사업장 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 정보 변경", "사업장 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	changeCompanyServiceState = function(serviceState) {

		var postData = getRequestChangeCompanyServiceStateParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objCompanyInfo.find('input[name="companyid"]').val(),
				serviceState);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 서비스 상태 변경", "사업장 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var companyId = g_objCompanyInfo.find('input[name="companyid"]').val();
					var companyNode = $.jstree._reference(g_objCompanyTree)._get_node('#cid_' + companyId);
					if (companyNode.length) {
						if (serviceState == <%=ServiceState.SERVICE_STATE_STOP%>) {
							if (!companyNode.find('a').first().hasClass('state-abnormal')) {
								companyNode.find('a').first().addClass('state-abnormal')
							}
						} else {
							if (companyNode.find('a').first().hasClass('state-abnormal')) {
								companyNode.find('a').first().removeClass('state-abnormal')
							}
						}
					}
					loadCompanyInfo(companyId);
					displayInfoDialog("사업장 서비스 상태 변경", "정상 처리되었습니다.", "정상적으로 사업장 서비스 상태가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 서비스 상태 변경", "사업장 서비스 상태 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteCompany = function() {

		var postData = getRequestDeleteCompanyParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				g_objCompanyInfo.find('input[name="companyid"]').val());

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
					displayAlertDialog("사업장 삭제", "사업장 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadCompanyTreeView();
					displayInfoDialog("사업장 삭제", "정상 처리되었습니다.", "정상적으로 사업장이 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 삭제", "사업장 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	getSelectedPatternList = function() {

		var arrCompanyDefaultPattrnList = new Array();
		g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').filter(':checked').each( function () {
			var arrPattern = new Array();
			arrPattern.push($(this).attr('patternid'));
			arrPattern.push($(this).attr('patternsubid'));
			arrCompanyDefaultPattrnList.push(arrPattern);
		});
		return arrCompanyDefaultPattrnList;
	};

	validateCompanyData = function(mode) {

		var objCompanyId = g_objCompanyInfo.find('input[name="companyid"]');
		var objCompanyName = g_objCompanyInfo.find('input[name="companyname"]');
		var objCompanyPostalCode = g_objCompanyInfo.find('input[name="companypostalcode"]');
		var objCompanyAddress = g_objCompanyInfo.find('input[name="companyaddress"]');
		var objCompanyDetailAddress = g_objCompanyInfo.find('input[name="companydetailaddress"]');
		var objManagerName = g_objCompanyInfo.find('input[name="managername"]');
		var objManagerEmail = g_objCompanyInfo.find('input[name="manageremail"]');
		var objManagerPhone = g_objCompanyInfo.find('input[name="managerphone"]');
		var objManagerMobilePhone = g_objCompanyInfo.find('input[name="managermobilephone"]');
		var objAutoCreateDeptCode = g_objCompanyInfo.find('select[name="autocreatedeptcode"]');
		var objValidateTips = g_objCompanyInfo.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (!isValidParam(objCompanyId, PARAM_TYPE_COMPANYID, "사업장 ID", PARAM_COMPANYID_MIN_LEN, PARAM_COMPANYID_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (!isValidParam(objCompanyName, PARAM_TYPE_NAME, "사업장 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objCompanyPostalCode.val().length >0) {
			if (!isValidParam(objCompanyPostalCode, PARAM_TYPE_POSTAL_CODE, "우편번호", PARAM_POSTAL_CODE_MIN_LEN, PARAM_POSTAL_CODE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyAddress.val().length >0) {
			if (!isValidParam(objCompanyAddress, PARAM_TYPE_ADDRESS, "주소", PARAM_ADDRESS_MIN_LEN, PARAM_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objCompanyDetailAddress.val().length >0) {
			if (!isValidParam(objCompanyDetailAddress, PARAM_TYPE_ADDRESS, "상세주소", PARAM_DETAIL_ADDRESS_MIN_LEN, PARAM_DETAIL_ADDRESS_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (!isValidParam(objManagerName, PARAM_TYPE_NAME, "담당자 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objManagerEmail.val().length > 0) {
			if (!isValidParam(objManagerEmail, PARAM_TYPE_EMAIL, "담당자 이메일", PARAM_EMAIL_MIN_LEN, PARAM_EMAIL_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objManagerPhone.val().length > 0) {
			if (!isValidParam(objManagerPhone, PARAM_TYPE_PHONE, "담당자 전화번호", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objManagerMobilePhone.val().length >0) {
			if (!isValidParam(objManagerMobilePhone, PARAM_TYPE_MOBILE_PHONE, "담당자 휴대전화번호", PARAM_MOBILE_PHONE_MIN_LEN, PARAM_MOBILE_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objAutoCreateDeptCode.val().length == 0) {
			updateTips(objValidateTips, "부서코드 자동 생성 유형을 선택해 주세요.");
			objAutoCreateDeptCode.focus();
			return false;
		}

		if (g_objCompanyDefaultPatternDialog.find('input:checkbox[name=selectpattern]').filter(':checked').length == 0) {
			updateTips(objValidateTips, "사업장 사용 패턴을 설정해 주세요.");
			return false;
		}

		return true;
	};

//-->
</script>

<div class="inner-west">
	<div class="pane-header">사업장 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="company-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">전체 사업장 목록</div>
	<div class="ui-layout-content">
		<div id="company-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사업장 명
				<input type="text" id="searchcompanyname" name="searchcompanyname" class="text ui-widget-content" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>서비스 상태
				<select id="searchservicestate" name="searchservicestate" class="ui-widget-content"></select>
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">조 회</button>
				</span>
			</div>
			<div id="search-result">
				<div id="result-list"></div>
				<div id="list-pagination" class="div-pagination">
					<div id="pagination" class="pagination"></div>
					<div id="totalrecordcount" class="total-record-count"></div>
				</div>
			</div>
		</div>
		<div id="company-info" class="info-form">
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
				<div id="row-companyid" class="field-line">
					<div class="field-title">사업장 ID<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="companyid" name="companyid" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companyname" class="field-line">
					<div class="field-title">사업장 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="companyname" name="companyname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companypostalcode" class="field-line">
					<div class="field-title">우편번호</div>
					<div class="field-value"><input type="text" id="companypostalcode" name="companypostalcode" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companyaddress" class="field-line">
					<div class="field-title">주소</div>
					<div class="field-value"><input type="text" id="companyaddress" name="companyaddress" class="text ui-widget-content" /></div>
				</div>
				<div id="row-companydetailaddress" class="field-line">
					<div class="field-title">상세주소</div>
					<div class="field-value"><input type="text" id="companydetailaddress" name="companydetailaddress" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managername" class="field-line">
					<div class="field-title">담당자 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="managername" name="managername" class="text ui-widget-content" /></div>
				</div>
				<div id="row-manageremail" class="field-line">
					<div class="field-title">담당자 이메일</div>
					<div class="field-value"><input type="text" id="manageremail" name="manageremail" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managerphone" class="field-line">
					<div class="field-title">담당자 전화번호</div>
					<div class="field-value"><input type="text" id="managerphone" name="managerphone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-managermobilephone" class="field-line">
					<div class="field-title">담당자 휴대전화번호</div>
					<div class="field-value"><input type="text" id="managermobilephone" name="managermobilephone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-autocreatedeptcode" class="field-line">
					<div class="field-title">부서코드 자동 생성<span class="required_field">*</span></div>
					<div class="field-value"><select id="autocreatedeptcode" name="autocreatedeptcode" class="ui-widget-content"></select></div>
				</div>
				<div id="row-servicestate" class="field-line">
					<div class="field-title">서비스 상태</div>
					<div class="field-value"><span id="servicestate"></span></div>
				</div>
				<div id="row-servicestoppeddatetime" class="field-line">
					<div class="field-title">서비스 중지 일시</div>
					<div class="field-value"><span id="servicestoppeddatetime"></span></div>
				</div>
				<div id="row-targetpatterncount" class="field-line">
					<div class="field-title">설정 패턴 수</div>
					<div class="field-value"><span id="targetpatterncount"></span></div>
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
	<div class="pane-footer">
		<div class="button-line">
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 사업장</button>
<% } %>
			<button type="button" id="btnStopService" name="btnStopService" class="normal-button" style="display: none;">서비스 중지</button>
			<button type="button" id="btnResumeService" name="btnResumeService" class="normal-button" style="display: none;">서비스 중지 해제</button>
<% if (ServerType.SERVER_TYPE_ASP.equals((String) session.getAttribute("SERVERTYPE"))) { %>
			<button type="button" id="btnSetupConfig" name="btnSetupConfig" class="normal-button" style="display: none;">사업장 기능 옵션 설정</button>
<% } %>
			<button type="button" id="btnSetupPattern" name="btnSetupPattern" class="normal-button" style="display: none;">사업장 사용 패턴 설정</button>
<% if (ServerType.SERVER_TYPE_ENTERPRISE.equals((String) session.getAttribute("SERVERTYPE"))) { %>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">사업장 등록</button>
<% } %>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">사업장 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">사업장 삭제</button>
		</div>
	</div>
</div>
