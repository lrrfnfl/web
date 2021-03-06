<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="licencerenewalhistory-dialog.jsp"%>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objLicenceRenewalHistoryList;

	var g_htLicenceTypeList = new Hashtable();
	var g_htPaymentTypeList = new Hashtable();

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objLicenceRenewalHistoryList = $('#licencerenewalhistory-list');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		g_objLicenceRenewalHistoryList.find('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objLicenceRenewalHistoryList.find('#searchdateto').datepicker('option', 'minDate', selectedDate);
				$('button[name="btnDownload"]').hide();
			}
		});

		g_objLicenceRenewalHistoryList.find('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				g_objLicenceRenewalHistoryList.find('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
				$('button[name="btnDownload"]').hide();
			}
		});
		g_objLicenceRenewalHistoryList.find('#searchdateto').datepicker('setDate', new Date());

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htLicenceTypeList = loadTypeList("LICENCE_TYPE");
		if (g_htLicenceTypeList.isEmpty()) {
			displayAlertDialog("???????????? ?????? ??????", "???????????? ?????? ?????? ??? ????????? ?????????????????????.", "????????? ????????? ????????? ??????????????? ????????? ????????????.");
		}

		g_htPaymentTypeList = loadTypeList("PAYMENT_TYPE");
		if (g_htPaymentTypeList.isEmpty()) {
			displayAlertDialog("?????? ?????? ??????", "?????? ?????? ?????? ??? ????????? ?????????????????????.", "????????? ????????? ????????? ??????????????? ????????? ????????????.");
		}

		innerDefaultLayout.show("west");
		loadCompanyTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadLicenceRenewalHistoryList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadLicenceRenewalHistoryList();
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("click", ".list-table th", function () { if (typeof $(this).attr('id') != typeof undefined) { g_searchListOrderByName = $(this).attr('id'); if (g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; $('button[name="btnSearch"]').click(); }; });	
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table tbody tr", function() { openLicenceRenewalHistoryInfoDialog($(this).attr('seqno')); });
	});

	loadCompanyTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[?????? ?????????]]></name></content>";
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
							displayAlertDialog("????????? ?????? ?????? ??????", "????????? ?????? ?????? ?????? ??? ????????? ?????????????????????.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("????????? ?????? ?????? ??????", "????????? ?????? ?????? ?????? ??? ????????? ?????????????????????.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
				$('button[name="btnDownload"]').hide();
				if (data.rslt.obj.attr('node_type') != "company_category") {
					g_searchListOrderByName = "";
					g_searchListOrderByDirection = "";
					g_searchListPageNo = 1;
					loadLicenceRenewalHistoryList();
				}
			}
		});
	};

	loadLicenceRenewalHistoryList = function() {

		var objSearchCondition = g_objLicenceRenewalHistoryList.find('#search-condition');
		var objSearchResult = g_objLicenceRenewalHistoryList.find('#search-result');

		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var objTreeReference = $.jstree._reference(g_objCompanyTree);

		var targetCompanyId = "";
		if (objTreeReference.get_selected().attr('node_type') == "company") {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var postData = getRequestLicenceRenewalHistoryListParam(
				targetCompanyId,
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
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
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">?????????...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("???????????? ?????? ?????? ??????", "???????????? ?????? ?????? ?????? ??? ????????? ?????????????????????.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';
				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">????????? ???</th>';
				htmlContents += '<th id="LICENCETYPE" class="ui-state-default">???????????? ??????</th>';
				htmlContents += '<th id="LICENCESTARTDATE" class="ui-state-default">???????????? ????????????</th>';
				htmlContents += '<th id="LICENCEENDDATE" class="ui-state-default">???????????? ????????????</th>';
				htmlContents += '<th id="LICENCECOUNT" class="ui-state-default">???????????? ???</th>';
				htmlContents += '<th id="DBPROTECTIONLICENCECOUNT" class="ui-state-default">DB ?????? ???????????? ???</th>';
				htmlContents += '<th id="PAYMENTAMOUNT" class="ui-state-default">?????? ??????</th>';
				htmlContents += '<th width="125" id="CREATEDATETIME" class="ui-state-default">????????????</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ ?????? ????????? ???: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " ??? ]");

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
						var paymentAmount = $(this).find('paymentamount').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr seqno=' + seqNo + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + companyName + '</td>';
						htmlContents += '<td style="text-align: center;">' + g_htLicenceTypeList.get(licenceType) + '</td>';
						htmlContents += '<td style="text-align: center;">' + licenceStartDate + '</td>';
						htmlContents += '<td style="text-align: center;">' + licenceEndDate + '</td>';
						if (licenceCount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + licenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
						}
						if (dbProtectionLicenceCount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + dbProtectionLicenceCount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
						}
						if (paymentAmount.length != 0) {
							htmlContents += '<td style="text-align: right;">' + paymentAmount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + '</td>';
						} else {
							htmlContents += '<td style="text-align: right;">0</td>';
						}
						htmlContents += '<td style="text-align: center;">' + createDatetime + '</td>';
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
								loadLicenceRenewalHistoryList();
							}
						});
					} else {
						objPagination.hide();
					}
					$('button[name="btnDownload"]').show();
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="8" align="center"><div style="padding: 10px 0; text-align: center;">????????? ???????????? ?????? ????????? ???????????? ????????????.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDownload"]').hide();
				}

				if (objTreeReference.get_selected().attr('node_type') == "company") {
					$('.inner-center .pane-header').text('???????????? ?????? ?????? - [' + objTreeReference.get_text(objTreeReference.get_selected()) + ']');
				} else {
					$('.inner-center .pane-header').text('?????? ???????????? ?????? ??????');
				}
				g_objLicenceRenewalHistoryList.show();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("???????????? ?????? ?????? ??????", "???????????? ?????? ?????? ?????? ??? ????????? ?????????????????????.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadLicenceRenewalHistoryList = function() {

		var objSearchCondition = g_objLicenceRenewalHistoryList.find('#search-condition');

		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objTreeReference = $.jstree._reference(g_objCompanyTree);

		var targetCompanyId = "";
		if (objTreeReference.get_selected().attr('node_type') == "company") {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var postData = getRequestCreateLicenceRenewalHistoryListFileParam(
				targetCompanyId,
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		var downloadFileName = "???????????? ?????? ??????";
		if ((objSearchDateFrom.val().length > 0) || (objSearchDateTo.val().length > 0)) {
			downloadFileName += " (" + objSearchDateFrom.val() + "~" + objSearchDateTo.val() + ")";
		}
		openDownloadDialog("???????????? ?????? ??????", downloadFileName, postData);
	};

//-->
</script>

<div class="inner-west">
	<div class="pane-header">????????? ??????</div>
	<div class="ui-layout-content zero-padding">
		<div id="company-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center"> 
	<div class="pane-header">?????? ???????????? ?????? ??????</div>
	<div class="ui-layout-content">
		<div id="licencerenewalhistory-list" style="display: none;">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>?????? ??????
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content input-date" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content input-date" readonly="readonly" />
				<span class="search-button">
					<button type="button" id="btnSearch" name="btnSearch" class="small-button">??? ???</button>
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
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button">?????? ????????????</button>
		</div>
	</div>
</div>
