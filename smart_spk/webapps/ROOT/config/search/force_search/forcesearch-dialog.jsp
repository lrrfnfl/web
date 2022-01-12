<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objForceSearchDialog;

	$(document).ready(function() {
		g_objForceSearchDialog = $('#dialog-forcesearch');

		$('#searchstartdate').datepicker({
			minDate: 0,
			showAnim: "slideDown",
			dateFormat: 'yy-mm-dd',
			inline: true
		});

		g_objForceSearchDialog.dialog({
			autoOpen: false,
			maxWidth: $(document).width(),
			width: 760,
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("검사 진행 상황")').button({
 					icons: { primary: 'ui-icon-contact' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("검사 중지")').button({
 					icons: { primary: 'ui-icon-cancel' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("검사 재개")').button({
 					icons: { primary: 'ui-icon-arrowrefresh-1-s' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("검사 대상 선택")').button({
 					icons: { primary: 'ui-icon-person' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("검사 패턴 설정")').button({
 					icons: { primary: 'ui-icon-note' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("등록")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("수정")').button({
 					icons: { primary: 'ui-icon-wrench' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("삭제")').button({
 					icons: { primary: 'ui-icon-trash' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().find(".ui-dialog-titlebar-close").hide();
				$(this).parent().focus();
				loadForceSearchMemberTreeView();
				loadForceSearchPattern();
			},
			buttons: {
				"검사 진행 상황": function() {
					openForceSearchStatusDialog();
				},
				"검사 중지": function() {
					displayConfirmDialog("강제검사 상태 변경", "강제검사를 중지하시겠습니까?", "", function() { changeForceSearchState("<%=SearchState.SEARCH_STATE_STOP%>"); } );
				},
				"검사 재개": function() {
					displayConfirmDialog("강제검사 정보 수정", "강제검사를 재개하시겠습니까?", "", function() { changeForceSearchState("<%=SearchState.SEARCH_STATE_SEARCHING%>"); } );
				},
				"검사 대상 선택": function() {
					openForceSearchMemberDialog();
				},
				"검사 패턴 설정": function() {
					openForceSearchPatternDialog();
				},
				"등록": function() {
					if (validateForceSearchData(MODE_INSERT)) {
						insertForceSearch();
					}
				},
				"수정": function() {
					if (validateForceSearchData(MODE_UPDATE)) {
						displayConfirmDialog("강제검사 정보 수정", "강제검사 정보를 수정하시겠습니까?", "", function() { updateForceSearch(); } );
					}
				},
				"삭제": function() {
					displayConfirmDialog("강제검사 삭제", "강제검사를 삭제하시겠습니까?", "", function() { deleteForceSearch(); } );
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:text').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error') )
						$(this).removeClass('ui-state-error');
				});
				$(this).find('input:checkbox').each(function() {
					$(this).prop('checked', false);
				});
				$(this).find('select').each(function() {
					$(this).val('');
				});
			}
		});

		g_objForceSearchDialog.find('select[name="searchmethod"]').change( function() {
			if ($('option:selected', this).val() == '<%=SearchMethodType.SEARCH_METHOD_TYPE_SIMPLE%>') {
				g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]').prop('checked', true);
				g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]').prop('checked', false);
				g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]').prop('checked', false);
				g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]').prop('disabled', true);
				g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]').prop('disabled', true);
				g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]').prop('disabled', true);
			} else {
				g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]').prop('disabled', false);
				g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]').prop('disabled', false);
				g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]').prop('disabled', false);
			}
		});
	});

	openNewForceSearchDialog = function() {

		var objCompanyId = g_objForceSearchDialog.find('input[name="companyid"]');
		var objSearchId = g_objForceSearchDialog.find('#searchid');
		var objCompanyName = g_objForceSearchDialog.find('#companyname');
		var objRegisterName = g_objForceSearchDialog.find('#registername');
		var objThreadPriority = g_objForceSearchDialog.find('select[name="threadpriority"]');
		var objSearchAfterNextBooting = g_objForceSearchDialog.find('select[name="searchafternextbooting"]');
		var objJobProcessingType = g_objForceSearchDialog.find('select[name="jobprocessingtype"]');
		var objSearchMethod = g_objForceSearchDialog.find('select[name="searchmethod"]');
		var objSearchStartHours = g_objForceSearchDialog.find('select[name="searchstarthours"]');
		var objSearchStartMinutes = g_objForceSearchDialog.find('select[name="searchstartminutes"]');
		var objSearchStartSeconds = g_objForceSearchDialog.find('select[name="searchstartseconds"]');
		var objTargetUserCount = g_objForceSearchDialog.find('#targetusercount');
		var objTargetPatternCount = g_objForceSearchDialog.find('#targetpatterncount');

		var objRowSearchId = g_objForceSearchDialog.find('#row-searchid');
		var objRowLastModifierName = g_objForceSearchDialog.find('#row-lastmodifiername');
		var objRowLastModifiedDatetime = g_objForceSearchDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objForceSearchDialog.find('#row-createdatetime');

		var targetCompanyId = "";
		var targetCompanyName = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
			targetCompanyName = objTreeReference.get_text(objTreeReference.get_selected());
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
		targetCompanyName = "<%=(String)session.getAttribute("COMPANYNAME")%>";
<% } %>

		objCompanyId.val(targetCompanyId);
		objSearchId.text("");
		objCompanyName.text(targetCompanyName);
		objRegisterName.text('<%=(String)session.getAttribute("ADMINNAME")%>');

		fillDropdownList(objThreadPriority, g_htThreadPriorityTypeList, null, "선택");
		fillDropdownList(objSearchAfterNextBooting, g_htOptionTypeList, "<%=OptionType.OPTION_TYPE_NO%>", "선택");
		fillDropdownList(objJobProcessingType, g_htJobProcessingTypeList, null, "선택");
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_DECRYPT%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_SEND_SERVER%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_TO_VITUALDISK%>' + '"]').remove();
		objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_FROM_VITUALDISK%>' + '"]').remove();
		fillDropdownList(objSearchMethod, g_htSearchMethodTypeList, null, "선택");

		objSearchStartHours.empty();
		for (var i=0; i<24; i++) {
			if (i < 10)
				objSearchStartHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSearchStartHours.append('<option value="' + i + '">' + i + '</option>');
		}

		objSearchStartMinutes.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objSearchStartMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSearchStartMinutes.append('<option value="' + i + '">' + i + '</option>');
		}

		objSearchStartSeconds.empty();
		for (var i=0; i<60; i++) {
			if (i < 10)
				objSearchStartSeconds.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
			else
				objSearchStartSeconds.append('<option value="' + i + '">' + i + '</option>');
		}

		objTargetUserCount.text("0");
		objTargetPatternCount.text("0");

		objRowSearchId.hide();
		objRowLastModifierName.hide();
		objRowLastModifiedDatetime.hide();
		objRowCreateDatetime.hide();

		g_objForceSearchDialog.dialog('option', 'title', '신규 강제검사');
		g_objForceSearchDialog.dialog({height:'auto'});

		changeAllElementDisableState(g_objForceSearchDialog, false);

		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 진행 상황)').hide();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 중지)').hide();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 재개)').hide();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').show();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').button("enable");
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').show();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').button("enable");
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').show();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
		g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').hide();

		g_objForceSearchDialog.dialog('open');
	};

	openForceSearchInfoDialog = function(seqNo) {

		var objCompanyId = g_objForceSearchDialog.find('input[name="companyid"]');
		var objSearchId = g_objForceSearchDialog.find('#searchid');
		var objCompanyName = g_objForceSearchDialog.find('#companyname');
		var objRegisterName = g_objForceSearchDialog.find('#registername');
		var objThreadPriority = g_objForceSearchDialog.find('select[name="threadpriority"]');
		var objSearchAfterNextBooting = g_objForceSearchDialog.find('select[name="searchafternextbooting"]');
		var objJobProcessingType = g_objForceSearchDialog.find('select[name="jobprocessingtype"]');
		var objSearchMethod = g_objForceSearchDialog.find('select[name="searchmethod"]');
		var objIncludeDocsFlag = g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]');
		var objIncludeImgsFlag = g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]');
		var objIncludeZipsFlag = g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]');
		var objSearchStartDate = g_objForceSearchDialog.find('input:text[name="searchstartdate"]');
		var objSearchStartHours = g_objForceSearchDialog.find('select[name="searchstarthours"]');
		var objSearchStartMinutes = g_objForceSearchDialog.find('select[name="searchstartminutes"]');
		var objSearchStartSeconds = g_objForceSearchDialog.find('select[name="searchstartseconds"]');
		var objTargetUserCount = g_objForceSearchDialog.find('#targetusercount');
		var objTargetPatternCount = g_objForceSearchDialog.find('#targetpatterncount');
		var objLastModifierName = g_objForceSearchDialog.find('#lastmodifiername');
		var objLastModifiedDatetime = g_objForceSearchDialog.find('#lastmodifieddatetime');
		var objCreateDatetime = g_objForceSearchDialog.find('#createdatetime');

		var objRowSearchId = g_objForceSearchDialog.find('#row-searchid');
		var objRowLastModifierName = g_objForceSearchDialog.find('#row-lastmodifiername');
		var objRowLastModifiedDatetime = g_objForceSearchDialog.find('#row-lastmodifieddatetime');
		var objRowCreateDatetime = g_objForceSearchDialog.find('#row-createdatetime');

		var postData = getRequestForceSearchInfoParam(seqNo);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 정보 조회", "강제검사 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var companyId = $(data).find('companyid').text();
				var companyName = $(data).find('companyname').text();
				var searchId = $(data).find('searchid').text();
				var registerName = $(data).find('registername').text();
				var threadPriorityType = $(data).find('threadprioritytype').text();
				var searchAfterNextBootingFlag = $(data).find('searchafternextbootingflag').text();
				var jobProcessingType = $(data).find('jobprocessingtype').text();
				var searchMethod = $(data).find('searchmethod').text();
				var includeDocsFlag = $(data).find('includedocsflag').text();
				var includeImgsFlag = $(data).find('includeimgsflag').text();
				var includeZipsFlag = $(data).find('includezipsflag').text();
				var searchStartDatetime = $(data).find('searchstartdatetime').text();
				var searchStateFlag = $(data).find('searchstateflag').text();
				var lastModifierName = $(data).find('lastmodifiername').text();
				var lastModifiedDatetime = $(data).find('lastmodifieddatetime').text();
				var createDatetime = $(data).find('createdatetime').text();
				var updateLocked = $(data).find('updatelocked').text();
				var targetUserCount = $(data).find('targetusercount').text();
				var targetPatternCount = $(data).find('targetpatterncount').text();

				objCompanyId.val(companyId);
				objSearchId.text(searchId);
				objCompanyName.text(companyName);
				objRegisterName.text(registerName);
				fillDropdownList(objThreadPriority, g_htThreadPriorityTypeList, threadPriorityType, null);
				fillDropdownList(objSearchAfterNextBooting, g_htOptionTypeList, searchAfterNextBootingFlag, null);
				fillDropdownList(objJobProcessingType, g_htJobProcessingTypeList, jobProcessingType, null);
				objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_DECRYPT%>' + '"]').remove();
				objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_SEND_SERVER%>' + '"]').remove();
				objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_TO_VITUALDISK%>' + '"]').remove();
				objJobProcessingType.find('option[value="' + '<%=JobProcessingType.JOB_PROCESSING_TYPE_MOVE_FROM_VITUALDISK%>' + '"]').remove();
				fillDropdownList(objSearchMethod, g_htSearchMethodTypeList, searchMethod, null);

				if (includeDocsFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objIncludeDocsFlag.prop('checked', true);
				}
				if (includeImgsFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objIncludeImgsFlag.prop('checked', true);
				}
				if (includeZipsFlag == '<%=OptionType.OPTION_TYPE_YES%>') {
					objIncludeZipsFlag.prop('checked', true);
				}

				if (searchMethod == '<%=SearchMethodType.SEARCH_METHOD_TYPE_SIMPLE%>') {
					objIncludeDocsFlag.prop('disabled', true);
					objIncludeImgsFlag.prop('disabled', true);
					objIncludeZipsFlag.prop('disabled', true);
				} else {
					objIncludeDocsFlag.prop('disabled', false);
					objIncludeImgsFlag.prop('disabled', false);
					objIncludeZipsFlag.prop('disabled', false);
				}

				var reggie = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
				var dateArray = reggie.exec(searchStartDatetime); 

				var searchStartDate = dateArray[1] + "-" + dateArray[2] + "-" + dateArray[3];
				var searchStartHours = dateArray[4];
				var searchStartMinutes = dateArray[5];
				var searchStartSeconds = dateArray[6];

				objSearchStartDate.val(searchStartDate);

				objSearchStartHours.empty();
				for (var i=0; i<24; i++) {
					if (i < 10)
						objSearchStartHours.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
					else
						objSearchStartHours.append('<option value="' + i + '">' + i + '</option>');
				}
				objSearchStartHours.find('option[value="' + searchStartHours + '"]').attr('selected', 'selected');

				objSearchStartMinutes.empty();
				for (var i=0; i<60; i++) {
					if (i < 10)
						objSearchStartMinutes.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
					else
						objSearchStartMinutes.append('<option value="' + i + '">' + i + '</option>');
				}
				objSearchStartMinutes.find('option[value="' + searchStartMinutes + '"]').attr('selected', 'selected');

				objSearchStartSeconds.empty();
				for (var i=0; i<60; i++) {
					if (i < 10)
						objSearchStartSeconds.append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
					else
						objSearchStartSeconds.append('<option value="' + i + '">' + i + '</option>');
				}
				objSearchStartSeconds.find('option[value="' + searchStartSeconds + '"]').attr('selected', 'selected');

				if ((targetUserCount != null) && (targetUserCount.length > 0)) {
					objTargetUserCount.text(targetUserCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				} else {
					objTargetUserCount.text("0");
				}
				if ((targetPatternCount != null) && (targetPatternCount.length > 0)) {
					objTargetPatternCount.text(targetPatternCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
				} else {
					objTargetPatternCount.text("0");
				}
				objLastModifierName.text(lastModifierName);
				objLastModifiedDatetime.text(lastModifiedDatetime);
				objCreateDatetime.text(createDatetime);

				objRowSearchId.show();
				objRowLastModifierName.show();
				objRowLastModifiedDatetime.show();
				objRowCreateDatetime.show();

				var htDeptList = new Hashtable();
				htDeptList = loadDeptList(companyId);
				fillDropdownList(g_objForceSearchStatusDialog.find('select[name="searchdept"]'), htDeptList, null, "전체");
				fillDropdownList(g_objForceSearchStatusDialog.find('select[name="searchcompletestate"]'), g_htCompleteStateList, null, "전체");

				g_objForceSearchDialog.dialog('option', 'title', '강제검사 정보');

				g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 진행 상황)').show();
				g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(등록)').hide();
				if (searchStateFlag == '<%=SearchState.SEARCH_STATE_SEARCHING%>') {
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 중지)').show();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 재개)').hide();
					if (updateLocked == '<%=OptionType.OPTION_TYPE_YES%>') {
						changeAllElementDisableState(g_objForceSearchDialog, true);
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').button("disable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').button("disable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').button("disable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').button("disable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();
					} else {
						changeAllElementDisableState(g_objForceSearchDialog, false);
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').button("enable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').button("enable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').button("enable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').show();
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').button("enable");
						g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();
					}
				} else if (searchStateFlag == '<%=SearchState.SEARCH_STATE_STOP%>') {
					changeAllElementDisableState(g_objForceSearchDialog, true);
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 중지)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 재개)').show();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').button("enable");
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();
				} else if (searchStateFlag == '<%=SearchState.SEARCH_STATE_COMPLETE%>') {
					changeAllElementDisableState(g_objForceSearchDialog, true);
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 중지)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 재개)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 대상 선택)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(검사 패턴 설정)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
					g_objForceSearchDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').hide();
				}

				g_objForceSearchDialog.dialog('open');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 정보 조회", "강제검사 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	insertForceSearch = function() {

		var searchStartDatetime = g_objForceSearchDialog.find('input[name="searchstartdate"]').datepicker('getDate').formatString("yyyyMMdd") + g_objForceSearchDialog.find('select[name="searchstarthours"]').val() + g_objForceSearchDialog.find('select[name="searchstartminutes"]').val() + g_objForceSearchDialog.find('select[name="searchstartseconds"]').val();
		var includeDocsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		var includeImgsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		var includeZipsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		
		if (g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]').is(':checked')) {
			includeDocsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		if (g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]').is(':checked')) {
			includeImgsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		if (g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]').is(':checked')) {
			includeZipsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		var arrTargetCompanyList = new Array();
		var arrTargetUserList = new Array();

		g_objForceSearchMemberTree.jstree("get_checked", null, true).each( function() {
			if ($(this).attr('node_type') == "user") {
				if(arrTargetCompanyList.indexOf($(this).attr('companyid')) < 0) {
					arrTargetCompanyList.push($(this).attr('companyid'));
				}

				var arrTargetUser = new Array();
				arrTargetUser.push($(this).attr('companyid'));
				arrTargetUser.push($(this).attr('deptcode'));
				arrTargetUser.push($(this).attr('userid'));
				arrTargetUserList.push(arrTargetUser);
			}
		});

		var arrTargetPattrnList = new Array();
		g_objForceSearchPatternDialog.find('input:checkbox[name=checkboxpattern]').filter(':checked').each( function () {
			var patternId = $(this).attr('patternid');
			var patternSubId = $(this).attr('patternsubid');

			var arrPattern = new Array();
			arrPattern.push(patternId);
			arrPattern.push(patternSubId);

			arrTargetPattrnList.push(arrPattern);
		});

		var postData = getRequestInsertForceSearchParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objForceSearchDialog.find('select[name="threadpriority"]').val(),
			g_objForceSearchDialog.find('select[name="searchafternextbooting"]').val(),
			g_objForceSearchDialog.find('select[name="jobprocessingtype"]').val(),
			g_objForceSearchDialog.find('select[name="searchmethod"]').val(),
			includeDocsFlag,
			includeImgsFlag,
			includeZipsFlag,
			searchStartDatetime,
			arrTargetCompanyList,
			arrTargetUserList,
			arrTargetPattrnList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 등록", "강제검사 등록 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadForceSearchList();
					displayInfoDialog("강제검사 등록", "정상 처리되었습니다.", "정상적으로 강제검사가 등록되었습니다.");
					g_objForceSearchDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 등록", "강제검사 등록 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	updateForceSearch = function() {

		var searchStartDatetime = g_objForceSearchDialog.find('input[name="searchstartdate"]').datepicker('getDate').formatString("yyyyMMdd") + g_objForceSearchDialog.find('select[name="searchstarthours"]').val() + g_objForceSearchDialog.find('select[name="searchstartminutes"]').val() + g_objForceSearchDialog.find('select[name="searchstartseconds"]').val();

		var includeDocsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		var includeImgsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		var includeZipsFlag = "<%=OptionType.OPTION_TYPE_NO%>";
		
		if (g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]').is(':checked')) {
			includeDocsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		if (g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]').is(':checked')) {
			includeImgsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		if (g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]').is(':checked')) {
			includeZipsFlag = "<%=OptionType.OPTION_TYPE_YES%>";
		}

		var arrTargetDeptList = new Array();
		var arrTargetUserList = new Array();

		g_objForceSearchMemberTree.jstree("get_checked", null, true).each( function() {
			if ($(this).attr('node_type') == "user") {
				var arrTargetUser = new Array();
				arrTargetUser.push($(this).attr('companyid'));
				arrTargetUser.push($(this).attr('deptcode'));
				arrTargetUser.push($(this).attr('userid'));
				arrTargetUserList.push(arrTargetUser);
			}
		});

		var arrTargetPattrnList = new Array();
		g_objForceSearchPatternDialog.find('input:checkbox[name=checkboxpattern]').filter(':checked').each( function () {
			var patternId = $(this).attr('patternid');
			var patternSubId = $(this).attr('patternsubid');

			var arrPattern = new Array();
			arrPattern.push(patternId);
			arrPattern.push(patternSubId);

			arrTargetPattrnList.push(arrPattern);
		});

		var postData = getRequestUpdateForceSearchParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objForceSearchDialog.find('#searchid').text(),
			g_objForceSearchDialog.find('select[name="threadpriority"]').val(),
			g_objForceSearchDialog.find('select[name="searchafternextbooting"]').val(),
			g_objForceSearchDialog.find('select[name="jobprocessingtype"]').val(),
			g_objForceSearchDialog.find('select[name="searchmethod"]').val(),
			includeDocsFlag,
			includeImgsFlag,
			includeZipsFlag,
			searchStartDatetime,
			g_objForceSearchDialog.find('input[name="companyid"]').val(),
			arrTargetDeptList,
			arrTargetUserList,
			arrTargetPattrnList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 정보 변경", "강제검사 정보 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadForceSearchList();
					displayInfoDialog("강제검사 정보 변경", "정상 처리되었습니다.", "정상적으로 강제검사 정보가 변경되었습니다.");
					g_objForceSearchDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 정보 변경", "강제검사 정보 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	changeForceSearchState = function(searchState) {
		var postData = getRequestChangeForceSearchStateParam('<%=(String)session.getAttribute("ADMINID")%>',
			g_objForceSearchDialog.find('#searchid').text(),
			g_objForceSearchDialog.find('input[name="companyid"]').val(),
			searchState);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 상태 변경", "강제검사 상태 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					g_searchListPageNo = 1;
					loadForceSearchList();
					displayInfoDialog("강제검사 상태 변경", "정상 처리되었습니다.", "정상적으로 강제검사 상태가 변경되었습니다.");
					g_objForceSearchDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 상태 변경", "강제검사 상태 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteForceSearch = function() {

		var postData = getRequestDeleteForceSearchParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objForceSearchDialog.find('#searchid').text(),
				g_objForceSearchDialog.find('input[name="companyid"]').val());

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("강제검사 삭제", "강제검사 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("강제검사 삭제", "정상 처리되었습니다.", "정상적으로 강제검사가 삭제되었습니다.");
					g_searchListPageNo = 1;
					loadForceSearchList();
					g_objForceSearchDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("강제검사 삭제", "강제검사 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateForceSearchData = function(mode) {

		var objThreadPriority = g_objForceSearchDialog.find('select[name="threadpriority"]');
		var objSearchAfterNextBooting = g_objForceSearchDialog.find('select[name="searchafternextbooting"]');
		var objJobProcessingType = g_objForceSearchDialog.find('select[name="jobprocessingtype"]');
		var objSearchMethode = g_objForceSearchDialog.find('select[name="searchmethod"]');
		var objIncludeDocsFlag = g_objForceSearchDialog.find('input:checkbox[name="includedocsflag"]');
		var objIncludeImgsFlag = g_objForceSearchDialog.find('input:checkbox[name="includeimgsflag"]');
		var objIncludeZipsFlag = g_objForceSearchDialog.find('input:checkbox[name="includezipsflag"]');
		var objSearchStartDate = g_objForceSearchDialog.find('input[name="searchstartdate"]');
		var objTargetUserCount = g_objForceSearchDialog.find('#targetusercount');
		var objTargetPatternCount = g_objForceSearchDialog.find('#targetpatterncount');
		var objValidateTips = g_objForceSearchDialog.find('#validateTips');

		if (objThreadPriority.val().length == 0) {
			updateTips(objValidateTips, "검사 쓰레드 우선 순위 옵션을 선택해 주세요.");
			objThreadPriority.focus();
			return false;
		}

		if (objSearchAfterNextBooting.val().length == 0) {
			updateTips(objValidateTips, "부팅 후 검사 옵션을 선택해 주세요.");
			objSearchAfterNextBooting.focus();
			return false;
		}

		if (objJobProcessingType.val().length == 0) {
			updateTips(objValidateTips, "검출파일 처리유형 옵션을 선택해 주세요.");
			objJobProcessingType.focus();
			return false;
		}

		if (objSearchMethode.val().length == 0) {
			updateTips(objValidateTips, "검사 정밀도 옵션을 선택해 주세요.");
			objSearchMethode.focus();
			return false;
		}

		if (!objIncludeDocsFlag.is(':checked') && !objIncludeImgsFlag.is(':checked') && !objIncludeZipsFlag.is(':checked')) {
			updateTips(objValidateTips, "검사 대상 파일을 선택해 주세요.");
			return false;
		}

		if (objSearchStartDate.val().length <= 0) {
			updateTips(objValidateTips, "검사 실행일자를 선택해 주세요.");
			objSearchStartDate.focus();
			return false;
		} else if (!isValidParam(objSearchStartDate, PARAM_TYPE_DATE, "검사 실행일자", PARAM_DATE_MIN_LEN, PARAM_DATE_MAX_LEN, objValidateTips)) {
			return false;
		}

		if (objTargetUserCount.text() == '0') {
			updateTips(objValidateTips, "강제검사 대상을 선택해 주세요.");
			return false;
		}

		if (objTargetPatternCount.text() == '0') {
			updateTips(objValidateTips, "검사 패턴을 선택해 주세요.");
			return false;
		}

		return true;
	};

	changeAllElementDisableState = function(objTarget, isDisabled) {
		objTarget.find('input, select').prop('disabled', isDisabled);
	};
//-->
</script>

<div id="dialog-forcesearch" title="" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li><span class="required_field">(*)</span> 필드는 필수 입력 필드입니다.</li>
				<li>검사 정밀도를 "빠른검사"로 설정할 경우, 문서 파일만 확장자를 기준으로 검사합니다.</li>
				<li>검사 정밀도를 "정밀검사"로 설정할 경우, 선택한 "검사 대상 파일"을 확장자와 관계없이 검사합니다.</li>
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
				<div class="field-title">대상 사업장</div>
				<div class="field-value"><span id="companyname"></span></div>
			</div>
			<div id="row-searchid" class="field-line">
				<div class="field-title">검사 ID<span class="required_field">*</span></div>
				<div class="field-value"><span id="searchid"></span></div>
			</div>
			<div id="row-registername" class="field-line">
				<div class="field-title">등록 관리자</div>
				<div class="field-value"><span id="registername"></span></div>
			</div>
			<div id="row-threadpriority" class="field-line">
				<div class="field-title">검사 쓰레드 우선 순위<span class="required_field">*</span></div>
				<div class="field-contents"><select id="threadpriority" name="threadpriority" class="ui-widget-content"></select></div>
			</div>
			<div id="row-searchafternextbooting" class="field-line" style="display: none;">
				<div class="field-title">부팅 후 검사<span class="required_field">*</span></div>
				<div class="field-value"><select id="searchafternextbooting" name="searchafternextbooting" class="ui-widget-content"></select></div>
			</div>
			<div id="row-jobprocessingtype" class="field-line">
				<div class="field-title">검출파일 처리유형<span class="required_field">*</span></div>
				<div class="field-value"><select id="jobprocessingtype" name="jobprocessingtype" class="ui-widget-content"></select></div>
			</div>
			<div id="row-searchmethod" class="field-line">
				<div class="field-title">검사 정밀도<span class="required_field">*</span></div>
				<div class="field-value"><select id="searchmethod" name="searchmethod" class="ui-widget-content"></select></div>
			</div>
			<div id="row-targetfiles" class="field-line">
				<div class="field-title">검사 대상 파일<span class="required_field">*</span></div>
				<div class="field-value">
					<label class="checkbox"><input type="checkbox" name="includedocsflag">문서 파일</label>
					<label class="checkbox" style="margin-left: 10px;"><input type="checkbox" name="includeimgsflag">이미지 파일</label>
					<label class="checkbox" style="margin-left: 10px;"><input type="checkbox" name="includezipsflag">압축 파일</label>
				</div>
			</div>
			<div id="row-searchstartdatetime" class="field-line">
				<div class="field-title">검사 실행 일시<span class="required_field">*</span></div>
				<div class="field-value">
					<span><input type="text" id="searchstartdate" name="searchstartdate" class="text ui-widget-content input-date" readonly /> 일</span>
					<span style="margin-left: 10px;"><select id="searchstarthours" name="searchstarthours" style="width: 50px;" class="ui-widget-content"></select> 시</span>
					<span style="margin-left: 10px;"><select id="searchstartminutes" name="searchstartminutes" style="width: 50px;" class="ui-widget-content"></select> 분</span>
					<span style="margin-left: 10px;"><select id="searchstartseconds" name="searchstartseconds" style="width: 50px;" class="ui-widget-content"></select> 초</span>
				</div>
			</div>
			<div id="row-targetusercount" class="field-line">
				<div class="field-title">검사 대상 사용자 수</div>
				<div class="field-value"><span id="targetusercount"></span> 명</div>
			</div>
			<div id="row-targetpatterncount" class="field-line">
				<div class="field-title">검사 패턴 수</div>
				<div class="field-value"><span id="targetpatterncount"></span> 패턴</div>
			</div>
			<div id="row-lastmodifiername" class="field-line">
				<div class="field-title">최종 변경자</div>
				<div class="field-value"><span id="lastmodifiername"></span></div>
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
