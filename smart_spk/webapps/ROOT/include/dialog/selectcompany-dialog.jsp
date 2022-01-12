<%@ page contentType = "text/html; charset=UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
<script type="text/javascript">
	var g_objSelectCompanyDialog;

	var g_companyListOrderByName = "COMPANYNAME";
	var g_companyListOrderByDirection = "ASC";
	var g_companyListPageNo = 1;

	$(document).ready(function() {
		g_objSelectCompanyDialog = $('#dialog-selectcompany');

		$('#btnSelectCompany').button({ icons: {primary: "ui-icon-search"} });
		$('#btnSearchCompany').button({ icons: {primary: "ui-icon-search"} });

		$('#dialog:ui-dialog').dialog('destroy');
		g_objSelectCompanyDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			minHeight: 200,
			width: 400,
			height: 'auto',
			autoResize: true,
			modal: false,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
			},
			buttons: {
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('input:text').each(function() {
					$(this).val('');
					if ( $(this).hasClass('ui-state-error') )
						$(this).removeClass('ui-state-error');
				});
				$(this).find('#validateTips').text('');
				$(this).find('#search-result').hide();
			}
		});

		$('button').click( function () {
			if ($(this).attr('id') == 'btnSelectCompany') {
				openSelectCompanyDialog();
			} else if ($(this).attr('id') == 'btnSearchCompany') {
				g_companyListPageNo = 1;
				loadCompanyList();
			}
		});
	});

	openSelectCompanyDialog = function() {

		g_objSelectCompanyDialog.dialog({height:'auto'});
		g_objSelectCompanyDialog.dialog('open');
	};

	loadCompanyList = function() {

		var objValidateTips = g_objSelectCompanyDialog.find('#validateTips');
		var objSearchCondition = g_objSelectCompanyDialog.find('#search-condition');
		var objSearchResult = g_objSelectCompanyDialog.find('#search-result');

		var objSearchCompanyName = objSearchCondition.find('input[name="searchcompanyname"]');

		var objResultList = objSearchResult.find('#result-list');
		var objResultPagination = objSearchResult.find('#result-pagination');
		var objPagination = objResultPagination.find('#pagination');

		if (objSearchCompanyName.val().length > 0) {
			if ( !isValidParam(objSearchCompanyName, PARAM_TYPE_SEARCH_KEYWORD, "사업자 명", PARAM_SEARCH_KEYWORD_MIN_LEN, PARAM_SEARCH_KEYWORD_MAX_LEN, objValidateTips) ) {
				return false;
			}
		} else {
			if ( objSearchCompanyName.hasClass('ui-state-error') )
				objSearchCompanyName.removeClass('ui-state-error');
		}

		var postData = getRequestCompanyListParam(objSearchCompanyName.val(),
			'',
			g_companyListOrderByName,
			g_companyListOrderByDirection,
			<%=CommonConstant.DISPLAY_TEN_LINE_LIST%>,
			g_companyListPageNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
  			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업자 리스트 조회", "사업자 리스트 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var htmlContents = '';

				htmlContents += '<table class="ui-widget-content">';
				htmlContents += '<thead>';
				htmlContents += '<tr class="ui-widget-header">';
				htmlContents += '<th>';
				htmlContents += '<ul>사업자 ID';
				htmlContents += '<li class="ui-state-default ui-corner-all" orderbyname="COMPANYID" orderbydirection="ASC"><span class="ui-icon ui-icon-arrowstop-1-s"></span></li>';
				htmlContents += '<li class="ui-state-default ui-corner-all" orderbyname="COMPANYID" orderbydirection="DESC"><span class="ui-icon ui-icon-arrowstop-1-n"></span></li>';
				htmlContents += '</ul>';
				htmlContents += '</th>';
				htmlContents += '<th>';
				htmlContents += '<ul>사업자 명';
				htmlContents += '<li class="ui-state-default ui-corner-all" orderbyname="COMPANYNAME" orderbydirection="ASC"><span class="ui-icon ui-icon-arrowstop-1-s"></span></li>';
				htmlContents += '<li class="ui-state-default ui-corner-all" orderbyname="COMPANYNAME" orderbydirection="DESC"><span class="ui-icon ui-icon-arrowstop-1-n"></span></li>';
				htmlContents += '</ul>';
				htmlContents += '</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				var totalRecordCount = parseInt($(data).find('totalrecordcount').text());
				var resultRecordCount = $(data).find('record').length;

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = "";
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						var companyId = $(this).find('companyid').text();
						var companyName = $(this).find('companyname').text();

						htmlContents += '<tr companyid=' + companyId + ' class="' + lineStyle + '">';
						htmlContents += '<td>' + companyId + '</td>';
						htmlContents += '<td>' + companyName + '</td>';
						htmlContents += '</tr>';

						recordCount++;
			  		});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);
					objSearchResult.show();

					var inlineScriptText = "";
					inlineScriptText += "g_objSelectCompanyDialog.find('.list-table li').hover(function() { $(this).addClass('ui-state-hover'); }, function() { $(this).removeClass('ui-state-hover'); });";
					inlineScriptText += "g_objSelectCompanyDialog.find('.list-table li').click(function() { g_companyListOrderByName = $(this).attr('orderbyname'); g_companyListOrderByDirection = $(this).attr('orderbydirection'); g_companyListPageNo = 1; loadCompanyList(); });";
					inlineScriptText += "g_objSelectCompanyDialog.find('.list-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objSelectCompanyDialog.find('.list-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
					inlineScriptText += "g_objSelectCompanyDialog.find('.list-table tbody tr').click( function () { selectedCompany($(this).attr('companyid')); });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objResultList.append(inlineScript);

					var totalPageCount;
					if (totalRecordCount%<%=CommonConstant.DISPLAY_TEN_LINE_LIST%> == 0)
						totalPageCount = totalRecordCount/<%=CommonConstant.DISPLAY_TEN_LINE_LIST%>;
					else
						totalPageCount = Math.floor(totalRecordCount/<%=CommonConstant.DISPLAY_TEN_LINE_LIST%>) + 1;

					objResultPagination.show();
					objPagination.paginate({
						count: totalPageCount,
						start: g_companyListPageNo,
						display: <%=CommonConstant.DEFAULT_DISPLAY_PAGE_COUNT%>,
						border: false,
						text_color: '#898989',
						background_color: 'none',
						text_hover_color: '#000',
						background_hover_color: 'none',
						images: false,
						mouse: 'press',
						onChange: function(selectPageNo){
							g_companyListPageNo = selectPageNo;
							loadCompanyList();
						}
					});
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="2" align="center"><div style="padding: 10px 0; text-align: center;">등록된 사업자가 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objResultList.html(htmlContents);

					objResultPagination.hide();
					objPagination.paginate = null;
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업자 리스트 조회", "사업자 리스트 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
  		});
	};

	selectedCompany = function(selectedCompanyId) {
		g_objSelectCompanyDialog.find('#selectedcompanyid').val(selectedCompanyId);
		g_objSelectCompanyDialog.find('#frm-selectcompany').submit();
	};
</script>

<div id="dialog-selectcompany" title="사업자 선택" class="dialog-form">
	<div class="ui-corner-all info">
		<p>
			- 관리하고자하는 사업자를 선택해 주세요.
		</p>
	</div>

	<p id="validateTips" class="validateTips"></p>

	<div id="search-condition" class="inline-search-condition">
		<form id="frm-selectcompany" method="post">
			<input type="hidden" id="selectedcompanyid" name="selectedcompanyid" />
			<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-triangle-1-e"></span></li></ul>사업자명
			<input type="text" id="searchcompanyname" name="searchcompanyname" class="text ui-widget-content ui-corner-all" style="width: 110px; margin-left: 2px;" />
			<span class="search-button">
				<button type="button" id="btnSearchCompany" name="btnSearchCompany" class="small-button">조 회</button>
			</span>
		</form>
	</div>
	<div id="search-result" class="search-result" style="display:none">
		<div id="result-list" class="list-table"></div>
		<div id="result-pagination" class="pagination">
			<div id="pagination"></div>
		</div>
	</div>
</div>
<% } %>