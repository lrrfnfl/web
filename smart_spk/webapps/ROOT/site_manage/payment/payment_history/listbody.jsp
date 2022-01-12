<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="payment-dialog.jsp"%>
<%@ include file ="/include/dialog/download-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objPaymentList;

	var g_htPaymentTypeList = new Hashtable();
	var g_htCompanyList = new Hashtable();

	var g_selectedCompanyId = "";

	var g_searchListOrderByName = "";
	var g_searchListOrderByDirection = "";
	var g_searchListPageNo = 1;

	$(document).ready(function() {
		g_objCompanyTree = $('#company-tree');
		g_objPaymentList = $('#payment-list');

		$( document ).tooltip();

		$('input:button, input:submit, button').button();
		$('button[name="btnSearch"]').button({ icons: {primary: "ui-icon-search"} });
		$('button[name="btnDownload"]').button({ icons: {primary: "ui-icon-arrowstop-1-s"} });

		$('#searchdatefrom').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdateto').datepicker('option', 'minDate', selectedDate);
			}
		});

		$('#searchdateto').datepicker({
			maxDate: 0,
			showAnim: "slideDown",
			onSelect: function(selectedDate) {
				$('#searchdatefrom').datepicker('option', 'maxDate', selectedDate);
			}
		});

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htPaymentTypeList = loadTypeList("PAYMENT_TYPE");
		if (g_htPaymentTypeList.isEmpty()) {
			displayAlertDialog("결제 유형 조회", "결제 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

		fillDropdownList(g_objPaymentList.find('#search-condition').find('select[name="searchpaymenttype"]'), g_htPaymentTypeList, null, "전체");

		innerDefaultLayout.show("west");
		loadCompanyTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSearch') {
				g_searchListPageNo = 1;
				loadPaymentList();
			} else if ($(this).attr('id') == 'btnDownload') {
				downloadPaymentList();
			}
		});
	});

	loadCompanyTreeView = function() {

		var postData = getRequestCompanyListParam('', '', '', 'COMPANYNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				g_objCompanyTree.block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" />처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				g_objCompanyTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var xmlTreeData = "";
				var companyNodeXml = "";

				if (!g_htCompanyList.isEmpty())
					g_htCompanyList.clear();

				$(data).find('record').each(function() {
					g_htCompanyList.put($(this).find('companyid').text(), $(this).find('companyname').text());

					companyNodeXml += "<item id='" + $(this).find('companyid').text() + "' parent_id='ALL' service_state='" + $(this).find('servicestateflag').text() + "' node_type='company'>";
					companyNodeXml += "<content><name>" + $(this).find('companyname').text() + "</name></content>";
					companyNodeXml += "</item>";
				});

				xmlTreeData += "<root>";
				xmlTreeData += "<item id='ALL' node_type='ROOT'>";
				xmlTreeData += "<content><name>전체 사업장</name></content>";
				xmlTreeData += "</item>";
				xmlTreeData += companyNodeXml;
				xmlTreeData += "</root>";

				g_objCompanyTree.jstree({
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

					// ROOT 자식 노드(사업장) 의 서비스 상태에 따라 사업장 명 색상 변경 
					data.inst._get_children(data.inst._get_node('ul >li:first')).each(function() {
						if ($(this).attr('service_state') == <%=ServiceState.SERVICE_STATE_STOP%>) {
							data.inst.get_container().find('li[id=' + $(this).attr('id') + '] a').first().addClass('state-abnormal');
						} else {
							data.inst.get_container().find('li[id=' + $(this).attr('id') + '] a').first().removeClass('state-abnormal');
						}
					});

					if (g_selectedCompanyId.length > 0) {
						data.inst.select_node('#' + g_selectedCompanyId);
					} else {
						data.inst.select_node('ul > li:first');
					}

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
					data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
					data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
				}).bind('select_node.jstree', function (event, data) {
					if (data.rslt.obj.attr('node_type') == "company") {
						g_selectedCompanyId = data.rslt.obj.attr('id');
						$('.inner-center .pane-header').text('결제 내역 목록 - [' + data.rslt.obj.children('a').text().trim() + ']');
					} else {
						g_selectedCompanyId = "";
						$('.inner-center .pane-header').text('전체 결제 내역 목록');
					}

					g_searchListPageNo = 1;
					loadPaymentList();
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 목록 조회", "사업장 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadPaymentList = function() {

		var objSearchCondition = g_objPaymentList.find('#search-condition');
		var objSearchResult = g_objPaymentList.find('#search-result');

		var objSearchApprovalNo = objSearchCondition.find('input[name="searchapprovalno"]');
		var objSearchPaymentType = objSearchCondition.find('select[name="searchpaymenttype"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var objResultList = objSearchResult.find('#result-list');
		var objPagination = objSearchResult.find('#pagination');
		var objTotalRecordCount = objSearchResult.find('#totalrecordcount');

		var postData = getRequestPaymentListParam(g_selectedCompanyId,
				objSearchApprovalNo.val(),
				objSearchPaymentType.val(),
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
					displayAlertDialog("결제 내역 목록 조회", "결제 내역 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				$('.inline-search-condition').show();

				var htmlContents = '';

				htmlContents += '<table class="list-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<th id="COMPANYNAME" class="ui-state-default">사업장</th>';
<% } %>
				htmlContents += '<th id="APPROVALNO" class="ui-state-default">승인 번호</th>';
				htmlContents += '<th id="PAYMENTTYPE" class="ui-state-default">결제 유형</th>';
				htmlContents += '<th id="PAYMENTAMOUNT" class="ui-state-default">결제 금액</th>';
				htmlContents += '<th id="PAYMENTAMOUNT" class="ui-state-default">결제 일자</th>';
				htmlContents += '<th id="CREATEDATETIME" class="ui-state-default">등록 일시</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				objTotalRecordCount.text("[ 대상 레코드 수: " + totalRecordCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " 건 ]");

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var seqNo = $(this).find('seqno').text();
						var companyName = $(this).find('companyname').text();
						var approvalNo = $(this).find('approvalno').text();
						var paymentType = $(this).find('paymenttype').text();
						var paymentAmount = $(this).find('paymentamount').text();
						var paymentDate = $(this).find('paymentdate').text();
						var createDatetime = $(this).find('createdatetime').text();

						htmlContents += '<tr seqno="' + seqNo + '" class="' + lineStyle + '">';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
						htmlContents += '<td>' + companyName + '</td>';
<% } %>
						htmlContents += '<td>' + approvalNo + '</td>';
						htmlContents += '<td>' + g_htPaymentTypeList.get(paymentType) + '</td>';
						htmlContents += '<td style="text-align: right;">' + paymentAmount.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' 원</td>';
						htmlContents += '<td style="text-align: center;">' + paymentDate + '</td>';
						htmlContents += '<td style="text-align: center;">' + createDatetime + '</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objPaymentList.find('.list-table th').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objPaymentList.find('.list-table th').click(function() { if( $(this).attr('id') != null) { g_searchListOrderByName = $(this).attr('id'); if( g_searchListOrderByDirection == 'ASC') { g_searchListOrderByDirection = 'DESC'; } else { g_searchListOrderByDirection = 'ASC'; }; g_searchListPageNo = 1; loadPaymentList(); } });";
					inlineScriptText += "g_objPaymentList.find('.list-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objPaymentList.find('.list-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
					inlineScriptText += "g_objPaymentList.find('.list-table tbody tr').click( function () { openPaymentInfoDialog($(this).attr('seqno')); });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objResultList.append(inlineScript);

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
								loadPaymentList();
							}
						});
					} else {
						objPagination.hide();
					}
					$('button[name="btnDownload"]').show();
				} else {
					htmlContents += '<tr>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					htmlContents += '<td colspan="6" align="center"><div style="padding: 10px 0; text-align: center;">등록된 결제 내역가 존재하지 않습니다.</div></td>';
<% } else { %>
					htmlContents += '<td colspan="5" align="center"><div style="padding: 10px 0; text-align: center;">등록된 결제 내역가 존재하지 않습니다.</div></td>';
<% } %>
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objPagination.hide();

					$('button[name="btnDownload"]').hide();
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결제 내역 목록 조회", "결제 내역 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	downloadPaymentList = function() {

		var objSearchCondition = g_objPaymentList.find('#search-condition');

		var objSearchApprovalNo = objSearchCondition.find('input[name="searchapprovalno"]');
		var objSearchPaymentType = objSearchCondition.find('select[name="searchpaymenttype"]');
		var objSearchDateFrom = objSearchCondition.find('input[name="searchdatefrom"]');
		var objSearchDateTo = objSearchCondition.find('input[name="searchdateto"]');

		var postData = getRequestCreatePaymentListFileParam(g_selectedCompanyId,
				objSearchApprovalNo.val(),
				objSearchPaymentType.val(),
				objSearchDateFrom.val(),
				objSearchDateTo.val(),
				g_searchListOrderByName,
				g_searchListOrderByDirection);

		openDownloadDialog("결제 내역 목록", postData);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header ui-widget-header ui-corner-top">사업장 목록</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom" style="padding: 0;">
		<div id="company-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header ui-widget-header ui-corner-top">전체 결제 내역 목록</div>
	<div class="ui-layout-content ui-widget-content ui-corner-bottom">
		<div id="payment-list">
			<div id="search-condition" class="inline-search-condition">
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>승인 번호
				<input type="text" id="searchapprovalno" name="searchapprovalno" class="text ui-widget-content ui-corner-all" />
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>결제 유형
				<select id="searchpaymenttype" name="searchpaymenttype" class="ui-widget-content"></select>
				<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>조회 기간
				<input type="text" id="searchdatefrom" name="searchdatefrom" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
				~<input type="text" id="searchdateto" name="searchdateto" class="text ui-widget-content ui-corner-all" style="width: 80px; text-align: center;" readonly="readonly" />
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
	</div>
	<div class="ui-state-default pane-footer">
		<div class="button-line">
			<button type="button" id="btnDownload" name="btnDownload" class="normal-button">목록 다운로드</button>
		</div>
	</div>
</div>
