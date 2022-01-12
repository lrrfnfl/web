<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objLicenceList;
	var g_objLicenceInfo;

	var g_htLicenceTypeList = new Hashtable();
	var g_htPaymentTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objLicenceList = $('#licence-list');
		g_objLicenceInfo = $('#licence-info');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnEdit"]').button({ icons: {primary: "ui-icon-wrench"} });
		$('button[name="btnUpdate"]').button({ icons: {primary: "ui-icon-disk"} });

		$('#dialog:ui-dialog').dialog('destroy');

		$('#searchlicenceenddate').datepicker({
			showAnim: "slideDown"
		});

		g_objLicenceInfo.find('input[name="licencestartdate"]').datepicker({
			showAnim: "slideDown"
		});

		g_objLicenceInfo.find('input[name="licenceenddate"]').datepicker({
			showAnim: "slideDown"
		});

		g_objLicenceInfo.find('input[name="paymentdate"]').datepicker({
			maxDate: 0,
			showAnim: "slideDown"
		});

		g_objLicenceInfo.find('input[name="licencecount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'0', vMax: "999999"});
		g_objLicenceInfo.find('input[name="dbprotectionlicencecount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'0', vMax: "999999"});
		g_objLicenceInfo.find('input[name="paymentamount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'-99999999', vMax: "99999999"});

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htLicenceTypeList = loadTypeList("LICENCE_TYPE");
		if (g_htLicenceTypeList.isEmpty()) {
			displayAlertDialog("라이센스 유형 조회", "라이센스 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objLicenceList.find('#search-condition').find('select[name="searchlicencetype"]'), g_htLicenceTypeList, null, "전체");

		g_htPaymentTypeList = loadTypeList("PAYMENT_TYPE");
		if (g_htPaymentTypeList.isEmpty()) {
			displayAlertDialog("결제 유형 조회", "결제 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		innerDefaultLayout.show("west");
		loadCompanyTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadLicenceList();
			} else if ($(this).attr('id') == 'btnEdit') {
				editLicence();
			} else if ($(this).attr('id') == 'btnUpdate') {
				if (validateLicenceData()) {
					displayConfirmDialog("라이센스 정보 변경", "라이센스 정보를 변경하시겠습니까?", "", function() { updateLicence(); } );
				}
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
					loadLicenceInfo(data.rslt.obj.attr('companyid'));
				} else {
					if (data.rslt.obj.attr('node_type') != "company_category") {
						g_searchListOrderByName = "";
						g_searchListOrderByDirection = "";
						g_searchListPageNo = 1;
						loadLicenceList();
					}
				}
			}
		});
	};

	loadLicenceList = function() {

		var objSearchCondition = g_objLicenceList.find('#search-condition');
		var objSearchResult = g_objLicenceList.find('#search-result');

		var objSearchLicenceType = objSearchCondition.find('select[name="searchlicencetype"]');
		var objSearchLicenceEndDate = objSearchCondition.find('input[name="searchlicenceenddate"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var postData = getRequestLicenceListParam(objSearchLicenceType.val(),
				objSearchLicenceEndDate.val(),
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
					displayAlertDialog("라이센스 목록 조회", "라이센스 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">사업장 명</th>';
				htmlContents += '<th id="LICENCETYPE" class="ui-state-default">라이센스 유형</th>';
				htmlContents += '<th id="LICENCESTARTDATE" class="ui-state-default">라이센스 시작일자</th>';
				htmlContents += '<th id="LICENCEENDDATE" class="ui-state-default">라이센스 종료일자</th>';
				htmlContents += '<th id="LICENCECOUNT" class="ui-state-default">라이센스 수</th>';
				htmlContents += '<th id="USECOUNT" class="ui-state-default">라이센스 사용 수</th>';
				htmlContents += '<th id="DBPROTECTIONLICENCECOUNT" class="ui-state-default">DB 보안 라이센스 수</th>';
				htmlContents += '<th width="125" id="CREATEDATETIME" class="ui-state-default">등록일시</th>';
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

						var seqNo = $(this).find('seqno').text();
						var companyId = $(this).find('companyid').text();
						var companyName = $(this).find('companyname').text();
						var licenceType = $(this).find('licencetype').text();
						var licenceStartDate = $(this).find('licencestartdate').text();
						var licenceEndDate = $(this).find('licenceenddate').text();
						var licenceCount = $(this).find('licencecount').text();
						var dbProtectionLicenceCount = $(this).find('dbprotectionlicencecount').text();
						var useCount = $(this).find('usecount').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr companyid=' + companyId + ' companyname=' + companyName + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + companyName + '</td>';
						htmlContents += '<td style="text-align:center;">' + g_htLicenceTypeList.get(licenceType) + '</td>';
						htmlContents += '<td style="text-align:center;">' + licenceStartDate + '</td>';
						htmlContents += '<td style="text-align:center;">' + licenceEndDate + '</td>';
						if (licenceCount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + licenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
						}
						if (useCount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + useCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
						}
						if (dbProtectionLicenceCount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + dbProtectionLicenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
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
								loadLicenceList();
							}
						});
					} else {
						objPagination.hide();
					}
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="8" align="center"><div style="padding: 10px 0; text-align: center;">등록된 라이센스가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();
				}

				$('button[name="btnEdit"]').hide();
				$('button[name="btnUpdate"]').hide();

				$('.inner-center .pane-header').text('전체 라이센스 목록');
				g_objLicenceList.show();
				g_objLicenceInfo.hide();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("라이센스 목록 조회", "라이센스 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadLicenceInfo = function(targetCompanyId) {

		var objValidateTips = g_objLicenceInfo.find('#validateTips');
		var objCompanyId = g_objLicenceInfo.find('input[name="companyid"]');
		var objCompanyName = g_objLicenceInfo.find('#companyname');
		var objLicenceType = g_objLicenceInfo.find('select[name="licencetype"]');
		var objLicenceStartDate = g_objLicenceInfo.find('input[name="licencestartdate"]');
		var objLicenceEndDate = g_objLicenceInfo.find('input[name="licenceenddate"]');
		var objLicenceCount = g_objLicenceInfo.find('input[name="licencecount"]');
		var objUseCount = g_objLicenceInfo.find('#usecount');
		var objDbProtectionLicenceCount = g_objLicenceInfo.find('input[name="dbprotectionlicencecount"]');
		var objLastModifiedDatetime = g_objLicenceInfo.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objLicenceInfo.find('#createdatetime');

		var objRowUseCount = g_objLicenceInfo.find('#row-usecount');
		var objRowPaymentType = g_objLicenceInfo.find('#row-paymenttype');
		var objRowPaymentAmount = g_objLicenceInfo.find('#row-paymentamount');
		var objRowPaymentDate = g_objLicenceInfo.find('#row-paymentdate');
		var objRowComments = g_objLicenceInfo.find('#row-comments');
		var objRowLastModifiedDatetime = g_objLicenceInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objLicenceInfo.find('#row-createdatetime');

		objValidateTips.hide();
		g_objLicenceInfo.find('input:text').each(function() {
			if ($(this).hasClass('ui-state-error'))
				$(this).removeClass('ui-state-error');
		});

		var postData = getRequestLicenceInfoByIdParam(targetCompanyId);

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
					displayAlertDialog("라이센스 정보 조회", "라이센스 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var licenceType = $(data).find('licencetype').text();
				var licenceStartDate = $(data).find('licencestartdate').text();
				var licenceEndDate = $(data).find('licenceenddate').text();
				var licenceCount = $(data).find('licencecount').text();
				var dbProtectionLicenceCount = $(data).find('dbprotectionlicencecount').text();
				var useCount = $(data).find('usecount').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();

				if ((licenceCount == null) || (licenceCount.length <= 0)) {
					licenceCount = 0;
				}
				if ((dbProtectionLicenceCount == null) || (dbProtectionLicenceCount.length <= 0)) {
					dbProtectionLicenceCount = 0;
				}

				objCompanyId.val(companyId);
				objCompanyName.text(companyName);
				fillDropdownList(objLicenceType, g_htLicenceTypeList, licenceType, null);
				objLicenceType.prop("disabled", true);
				objLicenceStartDate.val(licenceStartDate);
				objLicenceStartDate.datepicker("option", { disabled: true });
				objLicenceEndDate.val(licenceEndDate);
				objLicenceEndDate.datepicker("option", { disabled: true });
				objLicenceCount.val(licenceCount);
				objLicenceCount.prop("disabled", true);
				objUseCount.text(useCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				objDbProtectionLicenceCount.val(dbProtectionLicenceCount);
				objDbProtectionLicenceCount.prop("disabled", true);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objRowUseCount.show();
				objRowPaymentType.hide();
				objRowPaymentAmount.hide();
				objRowPaymentDate.hide();
				objRowComments.hide();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				$('button[name="btnEdit"]').show();
				$('button[name="btnUpdate"]').hide();

				$('.inner-center .pane-header').text('라이센스 정보 - [' + companyName + ']');
				g_objLicenceList.hide();
				g_objLicenceInfo.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("라이센스 정보 조회", "라이센스 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	editLicence = function() {

		var objCompanyName = g_objLicenceInfo.find('#companyname');
		var objLicenceType = g_objLicenceInfo.find('select[name="licencetype"]');
		var objLicenceStartDate = g_objLicenceInfo.find('input[name="licencestartdate"]');
		var objLicenceEndDate = g_objLicenceInfo.find('input[name="licenceenddate"]');
		var objLicenceCount = g_objLicenceInfo.find('input[name="licencecount"]');
		var objDbProtectionLicenceCount = g_objLicenceInfo.find('input[name="dbprotectionlicencecount"]');
		var objPaymentType = g_objLicenceInfo.find('select[name="paymenttype"]');
		var objPaymentAmount = g_objLicenceInfo.find('input[name="paymentamount"]');
		var objPaymentDate = g_objLicenceInfo.find('input[name="paymentdate"]');
		var objComments = g_objLicenceInfo.find('textarea[name="comments"]');

		var objRowUseCount = g_objLicenceInfo.find('#row-usecount');
		var objRowPaymentType = g_objLicenceInfo.find('#row-paymenttype');
		var objRowPaymentAmount = g_objLicenceInfo.find('#row-paymentamount');
		var objRowPaymentDate = g_objLicenceInfo.find('#row-paymentdate');
		var objRowComments = g_objLicenceInfo.find('#row-comments');
		var objRowLastModifiedDatetime = g_objLicenceInfo.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objLicenceInfo.find('#row-createdatetime');

		objLicenceType.prop("disabled", false);
		objLicenceStartDate.datepicker("option", { disabled: false });
		objLicenceEndDate.datepicker("option", { disabled: false });
		objLicenceCount.prop("disabled", false);
		objDbProtectionLicenceCount.prop("disabled", false);

		objRowUseCount.hide();
		fillDropdownList(objPaymentType, g_htPaymentTypeList, null, "선택");
		objRowPaymentType.show();
		objPaymentAmount.val('');
		objRowPaymentAmount.show();
		objPaymentDate.val('');
		objComments.val('');
		objRowPaymentDate.show();
		objRowComments.show();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		$('button[name="btnEdit"]').hide();
		$('button[name="btnUpdate"]').show();

		$('.inner-center .pane-header').text('라이센스 정보 수정- [' + objCompanyName.text() + ']');

		g_objLicenceList.hide();
		g_objLicenceInfo.show();
	};

	updateLicence = function() {

		var postData = getRequestUpdateLicenceParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objLicenceInfo.find('input[name="companyid"]').val(),
				g_objLicenceInfo.find('select[name="licencetype"]').val(),
				g_objLicenceInfo.find('input[name="licencestartdate"]').val(),
				g_objLicenceInfo.find('input[name="licenceenddate"]').val(),
				g_objLicenceInfo.find('input[name="licencecount"]').val().replace(/,/g, ''),
				g_objLicenceInfo.find('input[name="dbprotectionlicencecount"]').val().replace(/,/g, ''),
				g_objLicenceInfo.find('select[name="paymenttype"]').val(),
				new Date().formatString("yyyyMMddhhmmss"),
				g_objLicenceInfo.find('input[name="paymentamount"]').val().replace(/,/g, ''),
				g_objLicenceInfo.find('input[name="paymentdate"]').val(),
				g_objLicenceInfo.find('textarea[name="comments"]').val());

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
					displayAlertDialog("라이센스 정보 변경", "라이센스 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadLicenceInfo(g_objLicenceInfo.find('input[name="companyid"]').val());
					displayInfoDialog("라이센스 정보 변경", "정상 처리되었습니다.", "정상적으로 라이센스 정보가 변경되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("라이센스 정보 변경", "라이센스 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateLicenceData = function() {

		var objLicenceType = g_objLicenceInfo.find('select[name="licencetype"]');
		var objLicenceStartDate = g_objLicenceInfo.find('input[name="licencestartdate"]');
		var objLicenceEndDate = g_objLicenceInfo.find('input[name="licenceenddate"]');
		var objLicenceCount = g_objLicenceInfo.find('input[name="licencecount"]');
		var objDbProtectionLicenceCount = g_objLicenceInfo.find('input[name="dbprotectionlicencecount"]');
		var objPaymentType = g_objLicenceInfo.find('select[name="paymenttype"]');
		var objPaymentAmount = g_objLicenceInfo.find('input[name="paymentamount"]');
		var objPaymentDate = g_objLicenceInfo.find('input[name="paymentdate"]');
		var objValidateTips = g_objLicenceInfo.find('#validateTips');

		if (objLicenceType.val().length == 0) {
			updateTips(objValidateTips, "라이센스 유형을 선택해 주세요.");
			objLicenceType.focus();
			return false;
		} else {
			if (objLicenceStartDate.val().length == 0) {
				updateTips(objValidateTips, "라이센스 시작일자를 선택해 주세요.");
				objLicenceStartDate.focus();
				return false;
			}
			if (objLicenceEndDate.val().length == 0) {
				updateTips(objValidateTips, "라이센스 종료일자를 선택해 주세요.");
				objLicenceEndDate.focus();
				return false;
			}
			var licenceStartDate = new Date(objLicenceStartDate.val());
			var licenceEndDate = new Date(objLicenceEndDate.val());
			if (licenceStartDate.getTime() >= licenceEndDate.getTime()) {
				updateTips(objValidateTips, "라이센스 유효기간을 정확히 입력해 주세요.");
				return false;
			}
		}

		if (objLicenceCount.val().length == 0) {
			updateTips(objValidateTips, "라이센스 수를 압력해 주세요.");
			objLicenceCount.focus();
			return false;
		} else {
			if (!isValidParam(objLicenceCount, PARAM_TYPE_NUMBER, "라이센스 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			} else {
				if (parseInt(objLicenceCount.val()) <= 0) {
					updateTips(objValidateTips, "라이센스 수를 압력해 주세요.");
					objLicenceCount.focus();
					return false;
				}
			}
		}

		if (objDbProtectionLicenceCount.val().length == 0) {
			updateTips(objValidateTips, "DB 보안 라이센스 수를 압력해 주세요.");
			objDbProtectionLicenceCount.focus();
			return false;
		} else {
			if (!isValidParam(objDbProtectionLicenceCount, PARAM_TYPE_NUMBER, "DB 보안 라이센스 수", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			} else {
				if (parseInt(objDbProtectionLicenceCount.val()) < 0) {
					updateTips(objValidateTips, "DB 보안 라이센스 수를 압력해 주세요.");
					objDbProtectionLicenceCount.focus();
					return false;
				}
			}
		}

// 		if (objPaymentType.val().length == 0) {
// 			updateTips(objValidateTips, "결제 유형을 선택해 주세요.");
// 			objPaymentType.focus();
// 			return false;
// 		}

		if (objPaymentAmount.val().length > 0) {
			if (!isValidParam(objPaymentAmount, PARAM_TYPE_SIGNED_INTEGER, "결제 금액", PARAM_NUMBER_MIN_LEN, PARAM_NUMBER_MAX_LEN, objValidateTips)) {
				return false;
			}
		}

// 		if (objPaymentDate.val().length == 0) {
// 			updateTips(objValidateTips, "결제 일자를 선택해 주세요.");
// 			objPaymentDate.focus();
// 			return false;
// 		}

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
	<div class="pane-header">전체 라이센스 목록</div>
	<div class="ui-layout-content">
		<div id="licence-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>라이센스 유형
				<select id="searchlicencetype" name="searchlicencetype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>라이센스 만료일
				~<input type="text" id="searchlicenceenddate" name="searchlicenceenddate" class="text ui-widget-content input-date" readonly="readonly" />
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
		<div id="licence-info" class="info-form">
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
				<div id="row-companyname" class="field-line">
					<div class="field-title">사업장</div>
					<div class="field-value"><span id="companyname"></span></div>
				</div>
				<div id="row-licencetype" class="field-line">
					<div class="field-title">라이센스 유형<span class="required_field">*</span></div>
					<div class="field-value"><select id="licencetype" name="licencetype" class="ui-widget-content"></select></div>
				</div>
				<div id="row-licenceperiod" class="field-line">
					<div class="field-title">라이센스 유효기간<span class="required_field">*</span></div>
					<div class="field-value">
						<input type="text" id="licencestartdate" name="licencestartdate" class="text ui-widget-content input-date" readonly="readonly" />
						~ <input type="text" id="licenceenddate" name="licenceenddate" class="text ui-widget-content input-date" readonly="readonly" />
					</div>
				</div>
				<div id="row-licencecount" class="field-line">
					<div class="field-title">라이센스 수<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="licencecount" name="licencecount" value="" class="text ui-widget-content input-count" /></div>
				</div>
				<div id="row-usecount" class="field-line">
					<div class="field-title">라이센스 사용 수</div>
					<div class="field-value"><span id="usecount"></span></div>
				</div>
				<div id="row-dbprotectionlicencecount" class="field-line">
					<div class="field-title">DB 보안 라이센스 수<span class="required_field">*</span></div>
					<div class="field-value"><input type="text" id="dbprotectionlicencecount" name="dbprotectionlicencecount" value="" class="text ui-widget-content input-count" /></div>
				</div>
				<div id="row-paymenttype" class="field-line">
					<div class="field-title">결제 유형</div>
					<div class="field-value"><select id="paymenttype" name="paymenttype" class="ui-widget-content"></select></div>
				</div>
				<div id="row-paymentamount" class="field-line">
					<div class="field-title">결제 금액</div>
					<div class="field-value"><input type="text" id="paymentamount" name="paymentamount" value="" class="text ui-widget-content input-amount" /> 원</div>
				</div>
				<div id="row-paymentdate" class="field-line">
					<div class="field-title">결제 일자</div>
					<div class="field-value">
						<input type="text" id="paymentdate" name="paymentdate" class="text ui-widget-content input-date" readonly="readonly" />
					</div>
				</div>
				<div id="row-comments" class="field-line">
					<div class="field-title">변경 사유</div>
					<div class="field-contents"><textarea id="comments" name="comments" class="text ui-widget-content" style="height: 100px;"></textarea></div>
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
			<button type="button" id="btnEdit" name="btnEdit" class="normal-button" style="display: none;">라이센스 수정</button>
			<button type="button" id="btnUpdate" name="btnUpdate" class="normal-button" style="display: none;">라이센스 변경</button>
		</div>
	</div>
</div>
