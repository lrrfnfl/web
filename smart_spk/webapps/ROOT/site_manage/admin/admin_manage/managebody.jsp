<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="accessableaddress-dialog.jsp"%>
<%@ include file ="resetadminpassword-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objAdminTree;
	var g_objAdminList;
	var g_objAdminInfo;

	var g_htOptionTypeList = new Hashtable();
	var g_htAdminTypeList = new Hashtable();
	var g_htAccessableAddressTypeList = new Hashtable();
	var g_htLoginStateList = new Hashtable();
	var g_htLockStateList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objAdminTree = $('#admin-tree');
		g_objAdminList = $('#admin-list');
		g_objAdminInfo = $('#admin-info');

		$( document).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnManageAccessableAddress"]').button({ icons: {primary: "ui-icon-arrowthickstop-1-e"} });
		$('button[name="btnResetPassword"]').button({ icons: {primary: "ui-icon-key"} });
		$('button[name="btnUnlock"]').button({ icons: {primary: "ui-icon-unlocked"} });
		$('button[name="btnInsert"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });

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

		g_htAdminTypeList = loadTypeList("ADMIN_TYPE");
		if (g_htAdminTypeList.isEmpty()) {
			displayAlertDialog("관리자 유형 조회", "관리자 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htAccessableAddressTypeList = loadTypeList("ACCESSABLE_ADDRESS_TYPE");
		if (g_htAccessableAddressTypeList.isEmpty()) {
			displayAlertDialog("접근 제한 주소 유형 조회", "접근 제한 주소 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htLoginStateList = loadTypeList("LOGIN_STATE");
		if (g_htLoginStateList.isEmpty()) {
			displayAlertDialog("로그인 유형 조회", "로그인 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		g_htLockStateList = loadTypeList("LOCK_STATE");
		if (g_htLockStateList.isEmpty()) {
			displayAlertDialog("잠김 유형 조회", "잠김 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadAdminTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadAdminList();
			} else if ($(this).attr('id') == 'btnNew') {
				newAdmin();
			} else if ($(this).attr('id') == 'btnManageAccessableAddress') {
				openAccessableAddressDialog();
			} else if ($(this).attr('id') == 'btnResetPassword') {
				openResetAdminPasswordDialog();
			} else if ($(this).attr('id') == 'btnUnlock') {
				unlockAdmin();
			} else if ($(this).attr('id') == 'btnInsert') {
				if (validateAdminData(MODE_INSERT)) {
					insertAdmin();
				}
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateAdminData(MODE_UPDATE)) {
					displayConfirmDialog("관리자 정보 수정", "관리자 정보를 수정하시겠습니까?", "", function() { updateAdmin(); });
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("관리자 삭제", "관리자를 삭제하시겠습니까?", "", function() { deleteAdmin(); });
			}
		});

		$('input[type="radio"]').change( function(event) {
			if ($(this).filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
				$(this).closest('div').siblings().each( function() {
					$(this).show();
				});
			} else {
				$(this).closest('div').siblings().each( function() {
					$(this).hide();
				});
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
		var objTree = $.jstree._reference(g_objAdminTree); 
		var companyId = objTr.attr('companyid');
		var adminId = objTr.attr('adminid');
		objTree.deselect_node(objTree.get_selected());
		if (objTree._get_node('#aid_' + adminId).length) {
			objTree.select_node('#aid_' + adminId);
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
				objTree.open_node('#cid_' + companyId);
			}
			if (objTree._get_node('#aid_' + adminId).length) {
				objTree.select_node('#aid_' + adminId);
			}
		}
	};

	loadAdminTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root'>";
		xmlTreeData += "<content><name><![CDATA[전체 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "<item id='root_siteadmin' parent_id='root' admintype='<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>' node_type='siteadmin_category' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[사이트 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "<item id='root_companyadmin' parent_id='root' admintype='<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>' node_type='companyadmin_category' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[사업장 관리자]]></name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += "</root>";

		g_objAdminTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var postData;
							if (node.attr("node_type") == 'siteadmin_category') {
	 							postData = getRequestAdminTreeNodesParam('<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>', '');
							} else if (node.attr("node_type") == 'companyadmin_category') {
								postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ADMIN%>', '', '');
							} else if (node.attr("node_type") == 'company_category') {
								postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ADMIN%>', node.children('a').text().trim(), '');
							} else if (node.attr("node_type") == 'company') {
	 							postData = getRequestAdminTreeNodesParam('<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>', node.attr('companyid'));
							}
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
							displayAlertDialog("관리자 트리 목록 조회", "관리자 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
		 			},
		 			error: function(jqXHR, textStatus, errorThrown) {
		 				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
		 					displayAlertDialog("관리자 트리 목록 조회", "관리자 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			data.inst.open_node('#root_siteadmin');
			data.inst.open_node('#root_companyadmin');
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('load_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each(function() {
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
				} else if ($(this).attr('node_type') == "admin") {
					if ($(this).attr('lockflag') == "<%=LockState.LOCK_STATE_LOCK%>") {
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
				if (data.rslt.obj.attr('node_type') == "admin") {
					loadAdminInfo(data.rslt.obj.attr('adminid'));
				} else {
					if (data.rslt.obj.attr('node_type') != "company_category") {
						g_searchListOrderByName = "";
						g_searchListOrderByDirection = "";
						g_searchListPageNo = 1;
						loadAdminList();
					}
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = null;
			g_selectedTreeNode = null;
		});
	};

	loadAdminList = function() {

		var objSearchCondition = g_objAdminList.find('#search-condition');
		var objSearchResult = g_objAdminList.find('#search-result');

		var objSearchAdminName = objSearchCondition.find('input[name="searchadminname"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objAdminTree);

		if (objSearchAdminName.val().length > 0) {
			if (!isValidParam(objSearchAdminName, PARAM_TYPE_SEARCH_KEYWORD, "관리자 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, null)) {
				return false;
			}
		} else {
			if (objSearchAdminName.hasClass('ui-state-error'))
			objSearchAdminName.removeClass('ui-state-error');
		}

		var targetAdminType;
		var targetCompanyId;
		if (objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') {
			targetAdminType = "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>";
			targetCompanyId = "";
		} else if (objTreeReference.get_selected().attr("node_type") == 'companyadmin_category') {
			targetAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
			targetCompanyId = "";
		} else if (objTreeReference.get_selected().attr("node_type") == "company") {
			targetAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		} else {
			targetAdminType = "";
			targetCompanyId = "";
		}

		var postData = getRequestAdminListParam(objSearchAdminName.val(),
				targetAdminType,
				targetCompanyId,
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
					displayAlertDialog("관리자 목록 조회", "관리자 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="ADMINID" class="ui-state-default">관리자 ID</th>';
				htmlContents += '<th id="ADMINNAME" class="ui-state-default">관리자 명</th>';
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">소속 사업장</th>';
				htmlContents += '<th width="14%" id="ADMINTYPE" class="ui-state-default">관리자 유형</th>';
				htmlContents += '<th width="15%" id="CREATEDATETIME" class="ui-state-default">등록일시</th>';
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

						var adminId = $(this).find('adminid').text();
						var adminName = $(this).find('adminname').text();
						var companyId = $(this).find('companyid').text();
						var companyName = $(this).find('companyname').text();
						var adminType = $(this).find('admintype').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr adminid=' + adminId + ' companyid=' + companyId + ' companyname=' + companyName + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + adminId + '</td>';
						htmlContents += '<td>' + adminName + '</td>';
						htmlContents += '<td>' + companyName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htAdminTypeList.get(adminType) + '</td>';
						htmlContents += '<td style="text-align:center;">' + createDatetime + '</td>';
						htmlContents += '</tr>';
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var totalPageCount;
					if (totalRecordCount%<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%> == 0) {
						totalPageCount = totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>;
					} else {
						totalPageCount = Math.floor(totalRecordCount/<%=CommonConstant.DEFAULT_DISPLAY_LIST_COUNT%>) + 1;
					}

					if (totalPageCount > 1) {
						objPagination.show();
						objPagination.paging({
							current: g_searchListPageNo,
							max: totalPageCount,
							onclick: function(e, page){
								g_searchListPageNo = page;
								loadAdminList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">등록된 관리자가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				if ((objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') ||
						(objTreeReference.get_selected().attr("node_type") == "company")) {
					$('button[name="btnNew"]').show();
				} else {
					$('button[name="btnNew"]').hide();
				}
				$('button[name="btnManageAccessableAddress"]').hide();
				$('button[name="btnResetPassword"]').hide();
				$('button[name="btnUnlock"]').hide();
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').hide();
				$('button[name="btnDelete"]').hide();

				if (objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') {
					$('.inner-center .pane-header').text(objTreeReference.get_text(objTreeReference.get_selected()) + ' 목록');
				} else if (objTreeReference.get_selected().attr("node_type") == 'companyadmin_category') {
					$('.inner-center .pane-header').text(objTreeReference.get_text(objTreeReference.get_selected()) + ' 목록');
				} else if (objTreeReference.get_selected().attr("node_type") == "company") {
					$('.inner-center .pane-header').text('관리자 목록 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('전체 관리자 목록');
				}
				g_objAdminInfo.hide();
				g_objAdminList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 목록 조회", "관리자 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadAdminInfo = function(targetAdminId) {

		var objAdminId = g_objAdminInfo.find('input[name="adminid"]');
		var objAdminName = g_objAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objAdminInfo.find('input[name="email"]');
		var objPhone = g_objAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objAdminInfo.find('input[name="mobilephone"]');
		var objAdminType = g_objAdminInfo.find('input[name="admintype"]');
		var objAdminTypeString = g_objAdminInfo.find('#admintypestring');
		var objCompanyId = g_objAdminInfo.find('input[name="companyid"]');
		var objCompanyName = g_objAdminInfo.find('#companyname');
		var objAccessableAddressType = g_objAdminInfo.find('#accessableaddresstype');
		var objPasswordExpirationFlag = g_objAdminInfo.find('input[type="radio"][name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objAdminInfo.find('input[name="passwordexpirationperiod"]');
		var objLastChangedPasswordDatetime = g_objAdminInfo.find('#lastchangedpassworddatetime');
		var objLoginStatus = g_objAdminInfo.find('#loginstatus');
		var objLastLoginDatetime = g_objAdminInfo.find('#lastlogindatetime');
		var objLockStatus = g_objAdminInfo.find('#lockstatus');
		var objLockDatetime = g_objAdminInfo.find('#lockdatetime');
		var objLastModifiedDatetime = g_objAdminInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objAdminInfo.find('#createdatetime');

		var objRowPwd = g_objAdminInfo.find('#row-pwd');
		var objRowConfirmPwd = g_objAdminInfo.find('#row-confirmpwd');
		var objRowCompanyName = g_objAdminInfo.find('#row-companyname');
		var objRowAccessableAddressType = g_objAdminInfo.find('#row-accessableaddresstype');
		var objRowPasswordExpirationPeriod = g_objAdminInfo.find('#row-passwordexpirationperiod');
		var objRowLastChangedPasswordDatetime = g_objAdminInfo.find('#row-lastchangedpassworddatetime');
		var objRowLoginStatus = g_objAdminInfo.find('#row-loginstatus');
		var objRowLastLoginDatetime = g_objAdminInfo.find('#row-lastlogindatetime');
		var objRowLockStatus = g_objAdminInfo.find('#row-lockstatus');
		var objRowLockDatetime = g_objAdminInfo.find('#row-lockdatetime');
		var objRowLastModifiedDatetime = g_objAdminInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objAdminInfo.find('#row-createdatetime');

		g_objAdminInfo.find('#validateTips').hide();
		g_objAdminInfo.find('input:text, input:password').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objAdminInfo.find('select').each(function() {
			$(this).val('');
		});

		var postData = getRequestAdminInfoByIdParam(targetAdminId);

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
					displayAlertDialog("관리자 정보 조회", "관리자 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var adminId = $(data).find('adminid').text();
				var adminName = $(data).find('adminname').text();
				var email = $(data).find('email').text();
				var phone = $(data).find('phone').text();
				var mobilePhone = $(data).find('mobilephone').text();
				var adminType = $(data).find('admintype').text();
				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var accessableAddressType = $(data).find('accessableaddresstype').text();
				var passwordExpirationFlag = $(data).find('passwordexpirationflag').text();
				var passwordExpirationPeriod = $(data).find('passwordexpirationperiod').text();
				var lastChangedPasswordDatetime = $(data).find('lastchangedpassworddatetime').text();
				var loginFlag = $(data).find('loginflag').text();
				var lastLoginDatetime = $(data).find('lastlogindatetime').text();
				var lockFlag = $(data).find('lockflag').text();
				var lockDatetime = $(data).find('lockdatetime').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				objAdminId.val(adminId);
				objAdminName.val(adminName);
				objEmail.val(email);
				objPhone.val(phone);
				objMobilePhone.val(mobilePhone);
				objAdminType.val(adminType);
				objAdminTypeString.text(g_htAdminTypeList.get(adminType));
				objCompanyId.val(companyId);
				objCompanyName.text(companyName);
				if (adminType == "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>") {
					objRowCompanyName.hide()
				} else {
					objRowCompanyName.show()
				}
				objAccessableAddressType.text(g_htAccessableAddressTypeList.get(accessableAddressType));
				objPasswordExpirationFlag.prop('checked', false);
				objPasswordExpirationFlag.filter('[value=' + passwordExpirationFlag + ']').prop('checked', true);
				objPasswordExpirationPeriod.val(passwordExpirationPeriod);
				objLastChangedPasswordDatetime.text(lastChangedPasswordDatetime);
				objLoginStatus.text(g_htLoginStateList.get(loginFlag));
				objLastLoginDatetime.text(lastLoginDatetime);
				objLockStatus.text(g_htLockStateList.get(lockFlag));
				if (lockFlag == "<%=LockState.LOCK_STATE_LOCK%>") {
					objLockStatus.addClass("state-abnormal");
				} else {
					objLockStatus.removeClass("state-abnormal");
				}
				objLockDatetime.text(lockDatetime);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objAdminId.attr('readonly', true);
				objAdminId.blur();
				objAdminId.addClass('ui-priority-secondary');
				objAdminId.tooltip({ disabled: true });
				objRowPwd.hide();
				objRowConfirmPwd.hide();
				objRowAccessableAddressType.show();
				if (passwordExpirationFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objRowPasswordExpirationPeriod.show();
				} else {
					objRowPasswordExpirationPeriod.hide();
				}
				objRowLastChangedPasswordDatetime.show();
				objRowLoginStatus.show();
				objRowLastLoginDatetime.show();
				objRowLockStatus.show();
				objRowLockDatetime.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				$('button[name="btnNew"]').hide();
				$('button[name="btnManageAccessableAddress"]').show();
				$('button[name="btnResetPassword"]').show();
				if (lockFlag == "<%=LockState.LOCK_STATE_LOCK%>") {
					$('button[name="btnUnlock"]').show();
				} else {
					$('button[name="btnUnlock"]').hide();
				}
				$('button[name="btnInsert"]').hide();
				$('button[name="btnUpdate"]').show();
				$('button[name="btnDelete"]').show();

				$('.inner-center .pane-header').text('관리자 정보 - [' + adminName + ']');
				g_objAdminList.hide();
				g_objAdminInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 정보 조회", "관리자 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	newAdmin = function() {

		var objAdminId = g_objAdminInfo.find('input[name="adminid"]');
		var objAdminType = g_objAdminInfo.find('input[name="admintype"]');
		var objAdminTypeString = g_objAdminInfo.find('#admintypestring');
		var objCompanyId = g_objAdminInfo.find('input[name="companyid"]');
		var objCompanyName = g_objAdminInfo.find('#companyname');
		var objPasswordExpirationFlag = g_objAdminInfo.find('input[type="radio"][name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objAdminInfo.find('input[name="passwordexpirationperiod"]');

		var objRowPwd = g_objAdminInfo.find('#row-pwd');
		var objRowConfirmPwd = g_objAdminInfo.find('#row-confirmpwd');
		var objRowCompanyName = g_objAdminInfo.find('#row-companyname');
		var objRowAccessableAddressType = g_objAdminInfo.find('#row-accessableaddresstype');
		var objRowPasswordExpirationPeriod = g_objAdminInfo.find('#row-passwordexpirationperiod');
		var objRowLastChangedPasswordDatetime = g_objAdminInfo.find('#row-lastchangedpassworddatetime');
		var objRowLoginStatus = g_objAdminInfo.find('#row-loginstatus');
		var objRowLastLoginDatetime = g_objAdminInfo.find('#row-lastlogindatetime');
		var objRowLockStatus = g_objAdminInfo.find('#row-lockstatus');
		var objRowLockDatetime = g_objAdminInfo.find('#row-lockdatetime');
		var objRowLastModifiedDatetime = g_objAdminInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objAdminInfo.find('#row-createdatetime');

		var objTreeReference = $.jstree._reference(g_objAdminTree);

		g_objAdminInfo.find('#validateTips').hide();
		g_objAdminInfo.find('input:text, input:password').each(function() {
			$(this).val('');
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});
		g_objAdminInfo.find('select').each(function() {
			$(this).val('');
		});

		objAdminId.attr('readonly', false);
		objAdminId.removeClass('ui-priority-secondary');
		objRowPwd.show();
		objRowConfirmPwd.show();
		objAdminId.tooltip({ disabled: false });
		var selectedAdminType;
		if (objTreeReference.get_selected().attr("node_type") == 'siteadmin_category') {
			selectedAdminType = "<%=AdminType.ADMIN_TYPE_SITE_ADMIN%>";
		} else if (objTreeReference.get_selected().attr("node_type") == 'companyadmin_category') {
			selectedAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
		} else if (objTreeReference.get_selected().attr("node_type") == "company_category") {
			selectedAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
		} else if (objTreeReference.get_selected().attr("node_type") == "company") {
			selectedAdminType = "<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>";
		} else {
			selectedAdminType = "";
		}
		objAdminType.val(selectedAdminType);
		objAdminTypeString.text(g_htAdminTypeList.get(selectedAdminType));
		if (selectedAdminType == '<%=AdminType.ADMIN_TYPE_COMPANY_ADMIN%>') {
			objCompanyId.val(objTreeReference.get_selected().attr("companyid"));
			objCompanyName.text(objTreeReference.get_selected().children('a').text().trim());
			objRowCompanyName.show();
		} else {
			objCompanyId.val('');
			objRowCompanyName.hide();
		}
		objPasswordExpirationFlag.prop('checked', false);
		objPasswordExpirationFlag.filter('[value=' + <%=OptionType.OPTION_TYPE_NO%> + ']').prop('checked', true);
		objPasswordExpirationPeriod.val('<%=CommonConstant.DEFAULT_PASSWORD_EXPIRATION_PERIOD%>');

		objRowAccessableAddressType.hide();
		objRowPasswordExpirationPeriod.hide();
		objRowLastChangedPasswordDatetime.hide();
		objRowLoginStatus.hide();
		objRowLastLoginDatetime.hide();
		objRowLockStatus.hide();
		objRowLockDatetime.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		$('button[name="btnNew"]').hide();
		$('button[name="btnManageAccessableAddress"]').hide();
		$('button[name="btnResetPassword"]').hide();
		$('button[name="btnUnlock"]').hide();
		$('button[name="btnInsert"]').show();
		$('button[name="btnUpdate"]').hide();
		$('button[name="btnDelete"]').hide();

		$('.inner-center .pane-header').text('신규 관리자 - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
		g_objAdminList.hide();
		g_objAdminInfo.show();
	};

	insertAdmin = function() {

		var postData = getRequestInsertAdminParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objAdminInfo.find('input[name="adminid"]').val(),
			g_objAdminInfo.find('input[name="pwd"]').val(),
			g_objAdminInfo.find('input[name="adminname"]').val(),
			g_objAdminInfo.find('input[name="email"]').val(),
			g_objAdminInfo.find('input[name="phone"]').val(),
			g_objAdminInfo.find('input[name="mobilephone"]').val(),
			g_objAdminInfo.find('input[name="admintype"]').val(),
			g_objAdminInfo.find('input[name="companyid"]').val(),
			g_objAdminInfo.find('input[type="radio"][name="passwordexpirationflag"]').filter(':checked').val(),
			g_objAdminInfo.find('input[name="passwordexpirationperiod"]').val());

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
					displayAlertDialog("관리자 등록", "관리자 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objAdminTree);
					var objTargetNode = null;
					if (objTreeReference.get_selected().attr("node_type") == "admin") {
						objTargetNode = objTreeReference._get_parent(objTreeReference.get_selected());
					} else {
						objTargetNode = objTreeReference.get_selected();
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
						if (objTargetNode.hasClass('jstree-leaf')) {
							objTargetNode.removeClass('jstree-leaf')
							objTargetNode.addClass('jstree-open');
						}
					}
					displayInfoDialog("관리자 등록", "정상 처리되었습니다.", "정상적으로 관리자가 등록되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 등록", "관리자 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateAdmin = function() {

		var postData = getRequestUpdateAdminParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAdminInfo.find('input[name="adminid"]').val(),
				g_objAdminInfo.find('input[name="adminname"]').val(),
				g_objAdminInfo.find('input[name="email"]').val(),
				g_objAdminInfo.find('input[name="phone"]').val(),
				g_objAdminInfo.find('input[name="mobilephone"]').val(),
				g_objAdminInfo.find('input[name="admintype"]').val(),
				g_objAdminInfo.find('input[name="companyid"]').val(),
				g_objAdminInfo.find('input[type="radio"][name="passwordexpirationflag"]').filter(':checked').val(),
				g_objAdminInfo.find('input[name="passwordexpirationperiod"]').val());

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
					displayAlertDialog("관리자 정보 변경", "관리자 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objAdminTree);
					var objTargetNode = null;
					if (objTreeReference.get_selected().attr("node_type") == "admin") {
						objTargetNode = objTreeReference._get_parent(objTreeReference.get_selected());
					} else {
						objTargetNode = objTreeReference.get_selected();
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
					}
					displayInfoDialog("관리자 정보 변경", "정상 처리되었습니다.", "정상적으로 관리자 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 정보 변경", "관리자 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	unlockAdmin = function() {

		var postData = getRequestUnlockAdminParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAdminInfo.find('input[name="adminid"]').val());

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
					displayAlertDialog("관리자 잠김 해제", "관리자 잠김 해제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var adminId = g_objAdminInfo.find('input[name="adminid"]').val();
					var adminNode = $.jstree._reference(g_objAdminTree)._get_node('#aid_' + adminId);
					if (adminNode.length) {
						if (adminNode.find('a').first().hasClass('state-abnormal')) {
							adminNode.find('a').first().removeClass('state-abnormal')
						}
					}
					loadAdminInfo(adminId);
					displayInfoDialog("관리자 잠김 해제", "정상 처리되었습니다.", "정상적으로 관리자의 잠김 상태를 해제하였습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 잠김 해제", "관리자 잠김 해제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};


	deleteAdmin = function() {

		var postData = getRequestDeleteAdminParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objAdminInfo.find('input[name="adminid"]').val());

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
					displayAlertDialog("관리자 삭제", "관리자 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var objTreeReference = $.jstree._reference(g_objAdminTree);
					var objTargetNode = null;
					if (objTreeReference.get_selected().attr("node_type") == "admin") {
						objTargetNode = objTreeReference._get_parent(objTreeReference.get_selected());
					} else {
						objTargetNode = objTreeReference.get_selected();
					}
					if (objTargetNode.length) {
						objTreeReference.deselect_node(objTreeReference.get_selected());
						objTreeReference.refresh(objTargetNode);
						objTreeReference.select_node(objTargetNode);
					}
					displayInfoDialog("관리자 삭제", "정상 처리되었습니다.", "정상적으로 관리자가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("관리자 삭제", "관리자 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateAdminData = function(mode) {

		var objCompanyId = g_objAdminInfo.find('input[name="companyid"]');
		var objAdminId = g_objAdminInfo.find('input[name="adminid"]');
		var objPwd = g_objAdminInfo.find('input[name="pwd"]');
		var objConfirmPwd = g_objAdminInfo.find('input[name="confirmpwd"]');
		var objAdminName = g_objAdminInfo.find('input[name="adminname"]');
		var objEmail = g_objAdminInfo.find('input[name="email"]');
		var objPhone = g_objAdminInfo.find('input[name="phone"]');
		var objMobilePhone = g_objAdminInfo.find('input[name="mobilephone"]');
		var objPasswordExpirationFlag = g_objAdminInfo.find('input[type="radio"][name="passwordexpirationflag"]');
		var objPasswordExpirationPeriod = g_objAdminInfo.find('input[name="passwordexpirationperiod"]');
		var objValidateTips = g_objAdminInfo.find('#validateTips');

		if (mode == MODE_INSERT) {
			if (!isValidParam(objAdminId, PARAM_TYPE_ID, "관리자 ID", PARAM_ID_MIN_LEN, PARAM_ID_MAX_LEN, objValidateTips)) {
				return false;
			}

			if (objAdminId.val() == objCompanyId.val()) {
				updateTips(objValidateTips, "관리자 ID 는 사업장 ID 와 동일하게 생성할 수 없습니다.");
				objAdminId.focus();
				return false;
			}

			if (!isValidParam(objPwd, PARAM_TYPE_PWD, "비밀번호", PARAM_PWD_MIN_LEN, PARAM_PWD_MAX_LEN, objValidateTips)) {
				return false;
			}

			if (objPwd.val() != objConfirmPwd.val()) {
				updateTips(objValidateTips, "입력한 두 비밀번호가 일치하지 않습니다.");
				objPwd.val('');
				objConfirmPwd.val('');
				objPwd.focus();
				return false;
			}
		}

		if (!isValidParam(objAdminName, PARAM_TYPE_NAME, "관리자 명", PARAM_NAME_MIN_LEN, PARAM_NAME_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objEmail.val().length > 0) {
			if (!isValidParam(objEmail, PARAM_TYPE_EMAIL, "이메일", PARAM_EMAIL_MIN_LEN, PARAM_EMAIL_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objPhone.val().length > 0) {
			if (!isValidParam(objPhone, PARAM_TYPE_PHONE, "전화번호", PARAM_PHONE_MIN_LEN, PARAM_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if (objMobilePhone.val().length > 0) {
			if (!isValidParam(objMobilePhone, PARAM_TYPE_MOBILE_PHONE, "휴대전화번호", PARAM_MOBILE_PHONE_MIN_LEN, PARAM_MOBILE_PHONE_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

		if ((objPasswordExpirationFlag.filter(':checked').val() == null) || (objPasswordExpirationFlag.filter(':checked').val().length == 0)) {
			updateTips(objValidateTips, "비밀번호 유효기간 사용 여부를 선택해주세요.");
			return false;
		} else {
			if (objPasswordExpirationFlag.filter(':checked').val() == "<%=OptionType.OPTION_TYPE_YES%>") {
				if (objPasswordExpirationPeriod.val().length == 0) {
					updateTips(objValidateTips, "비밀번호 유효기간을 입력해주세요.");
					return false;
				} else {
					if (!isValidParam(objPasswordExpirationPeriod, PARAM_TYPE_NUMBER, "비밀번호 유효기간", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
						return false;
					}
				}
			}
		}

		return true;
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">관리자 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="admin-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center"> 
	<div class="pane-header">전체 관리자 목록</div>
	<div class="ui-layout-content">
		<div id="admin-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>관리자 명
				<input type="text" id="searchadminname" name="searchadminname" class="text ui-widget-content" />
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
		<div id="admin-info" class="info-form">
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
				<input type="hidden" id="admintype" name="admintype" />
				<div id="row-adminid" class="field-line">
					<div class="field-title">관리자 ID<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="adminid" name="adminid" class="text ui-widget-content" /></div>
				</div>
				<div id="row-pwd" class="field-line">
					<div class="field-title">비밀번호<span class="required_field">*</span></div>
					<div class="field-value"><input type="password" id="pwd" name="pwd" value="" class="text ui-widget-content" /></div>
				</div>
				<div id="row-confirmpwd" class="field-line">
					<div class="field-title">비밀번호 확인<span class="required_field">*</span></div>
					<div class="field-value"><input type="password" id="confirmpwd" name="confirmpwd" value="" class="text ui-widget-content" /></div>
				</div>
				<div id="row-adminname" class="field-line">
					<div class="field-title">관리자 명<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="adminname" name="adminname" class="text ui-widget-content" /></div>
				</div>
				<div id="row-email" class="field-line">
					<div class="field-title">이메일</div>
					<div class="field-value"><input type="text" id="email" name="email" class="text ui-widget-content" /></div>
				</div>
				<div id="row-phone" class="field-line">
					<div class="field-title">전화번호</div>
					<div class="field-value"><input type="text" id="phone" name="phone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-mobilephone" class="field-line">
					<div class="field-title">휴대전화번호</div>
					<div class="field-value"><input type="text" id="mobilephone" name="mobilephone" class="text ui-widget-content" /></div>
				</div>
				<div id="row-admintypestring" class="field-line">
					<div class="field-title">관리자 유형</div>
					<div class="field-value"><span id="admintypestring"></span></div>
				</div>
				<div id="row-companyname" class="field-line">
					<div class="field-title">소속 사업장</div>
					<div class="field-value"><span id="companyname"></span></div>
				</div>
				<div id="row-accessableaddresstype" class="field-line">
					<div class="field-title">접근주소 제한</div>
					<div class="field-value"><span id="accessableaddresstype"></span></div>
				</div>
				<div id="row-passwordexpiration" class="field-line">
					<div class="field-title">비밀번호 유효기간<span class="required_field">*</span></div>
					<div class="field-contents">
						<div>
							<label class="radio"><input type="radio" name="passwordexpirationflag" value="1">사용</label>&nbsp;&nbsp;
							<label class="radio"><input type="radio" name="passwordexpirationflag" value="0">미사용</label>
						</div>
						<div id="row-passwordexpirationperiod">
							최종 비밀번호 변경일로부터 <input type="text" id="passwordexpirationperiod" name="passwordexpirationperiod" class="text ui-widget-content" style='width: 30px;text-align:right;' onkeyup="this.value=this.value.replace(/[^\d]/,'')" /> 일
						</div>
					</div>
				</div>
				<div id="row-lastchangedpassworddatetime" class="field-line">
					<div class="field-title">최종 비밀번호 변경 일시</div>
					<div class="field-value"><span id="lastchangedpassworddatetime"></span></div>
				</div>
				<div id="row-lastlogindatetime" class="field-line">
					<div class="field-title">최종 접속 일시</div>
					<div class="field-value"><span id="lastlogindatetime"></span></div>
				</div>
				<div id="row-lockstatus" class="field-line">
					<div class="field-title">계정 상태</div>
					<div class="field-value"><span id="lockstatus"></span></div>
				</div>
				<div id="row-lockdatetime" class="field-line">
					<div class="field-title">계정 잠김 일시</div>
					<div class="field-value"><span id="lockdatetime"></span></div>
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
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 관리자</button>
			<button type="button" id="btnManageAccessableAddress" name="btnManageAccessableAddress" class="normal-button" style="display: none;">접속주소 관리</button>
			<button type="button" id="btnResetPassword" name="btnResetPassword" class="normal-button" style="display: none;">비밀번호 초기화</button>
			<button type="button" id="btnUnlock" name="btnUnlock" class="normal-button" style="display: none;">잠김 해제</button>
			<button type="button" id="btnInsert" name="btnInsert" class="normal-button" style="display: none;">관리자 등록</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">관리자 정보 수정</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">관리자 삭제</button>
		</div>
	</div>
</div>
