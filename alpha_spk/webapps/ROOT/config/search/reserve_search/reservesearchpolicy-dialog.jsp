<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objReserveSearchPolicyDialog;

	$(document).ready(function() {
		g_objReserveSearchPolicyDialog = $('#dialog-reservesearchpolicy');

		g_objReserveSearchPolicyDialog.dialog({
			autoOpen: false,
			width: 700,
			maxWidth: $(document).width(),
			height: 'auto',
			maxHeight: $(document).height(),
			resizable: false,
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("추가")').button({
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

				$(this).find('input[type="radio"][name="searchscheduletype"]').each( function() {
					$(this).siblings('span').text(g_htSearchScheduleTypeList.get($(this).val()));
				});
			},
			buttons: {
				"추가": function() {
					if (validateReserveSearchPolicyData()) {
						insertReserveSearchPolicy();
					}
				},
				"수정": function() {
					if (validateReserveSearchPolicyData()) {
						displayConfirmDialog("정책 정보 수정", "정책 정보를 수정하시겠습니까?", "", function() { updateReserveSearchPolicy(); });
					}
				},
				"삭제": function() {
					displayConfirmDialog("정책 삭제", "정책를 삭제하시겠습니까?", "정책을 삭제할 경우 할당된 사용자 정보도 삭제됩니다.", function() { removePolicy(); });
					$(this).dialog('close');
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
				$(this).find('input:text').each(function() {
					$(this).val('');
					if ($(this).hasClass('ui-state-error'))
						$(this).removeClass('ui-state-error');
				});
			}
		});

		$('#searchspecifieddate').datepicker({
			minDate: 0,
			showAnim: "slideDown"
		});

		g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]').change(function () {
			$(".schedule").each( function() {
				$(this).hide();
			});
			$(this).closest('div').siblings('div .schedule').show();
		});
	});

	openNewReserveSearchPolicyDialog = function() {

		g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]').each( function() {
			$(this).prop('checked', false);
		});

		g_objReserveSearchPolicyDialog.find(".schedule").each( function() {
			$(this).hide();
		});

		g_objReserveSearchPolicyDialog.find('select[name="nthweek"]').each( function() {
			fillDropdownList($(this), g_htNthWeekTypeList, '<%=NthWeekType.NTHWEEK_TYPE_FIRST%>', null);
		});

		g_objReserveSearchPolicyDialog.find('select[name="dayofweek"]').each( function() {
			fillDropdownList($(this), g_htDayOfWeekTypeList, '<%=DayOfWeekType.DAYOFWEEK_TYPE_MONDAY%>', null);
		});

		g_objReserveSearchPolicyDialog.find('select[name="searchhours"]').each( function() {
			$(this).empty();
			for (var i=0; i<24; i++) {
				if (i < 10)
					$(this).append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
				else
					$(this).append('<option value="' + i + '">' + i + '</option>');
			}
		});

		g_objReserveSearchPolicyDialog.find('select[name="searchminutes"]').each( function() {
			$(this).empty();
			for (var i=0; i<60; i++) {
				if (i < 10)
					$(this).append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
				else
					$(this).append('<option value="' + i + '">' + i + '</option>');
			}
		});

		g_objReserveSearchPolicyDialog.dialog('option', 'title', '신규 예약검사 정책');
		g_objReserveSearchPolicyDialog.dialog({height:'auto'});

		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(추가)').show();
		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').hide();
		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').hide();

  		g_objReserveSearchPolicyDialog.dialog('open');
	};

	openReserveSearchPolicyInfoDialog = function(htPolicyInfo) {

		var objSearchScheduleType = g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]');
		var objNthWeekForMonth = g_objReserveSearchPolicyDialog.find('#nthweekformonth');
		var objDayOfWeekForMonth = g_objReserveSearchPolicyDialog.find('#dayofweekformonth');
		var objSearchHoursForMonth = g_objReserveSearchPolicyDialog.find('#searchhoursformonth');
		var objSearchMinutesForMonth = g_objReserveSearchPolicyDialog.find('#searchminutesformonth');
		var objDayOfWeekForWeek = g_objReserveSearchPolicyDialog.find('#dayofweekforweek');
		var objSearchHoursForWeek = g_objReserveSearchPolicyDialog.find('#searchhoursforweek');
		var objSearchMinutesForWeek = g_objReserveSearchPolicyDialog.find('#searchminutesforweek');
		var objSearchHoursForDay = g_objReserveSearchPolicyDialog.find('#searchhoursforday');
		var objSearchMinutesForDay = g_objReserveSearchPolicyDialog.find('#searchminutesforday');
		var objSearchSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchspecifieddate');
		var objSearchHoursForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchhoursforspecifieddate');
		var objSearchMinutesForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchminutesforspecifieddate');

		var searchScheduleType = htPolicyInfo.get("searchscheduletype");
		var nthWeekForMonth = htPolicyInfo.get("nthweekformonth");
		var dayOfWeekForMonth = htPolicyInfo.get("dayofweekformonth");
		var searchHoursForMonth = htPolicyInfo.get("searchhoursformonth");
		var searchMinutesForMonth = htPolicyInfo.get("searchminutesformonth");
		var dayOfWeekForWeek = htPolicyInfo.get("dayofweekforweek");
		var searchHoursForWeek = htPolicyInfo.get("searchhoursforweek");
		var searchMinutesForWeek = htPolicyInfo.get("searchminutesforweek");
		var searchHoursForDay = htPolicyInfo.get("searchhoursforday");
		var searchMinutesForDay = htPolicyInfo.get("searchminutesforday");
		var searchSpecifiedDate = htPolicyInfo.get("searchspecifieddate");
		var searchHoursForSpecifiedDate = htPolicyInfo.get("searchhoursforspecifieddate");
		var searchMinutesForSpecifiedDate = htPolicyInfo.get("searchminutesforspecifieddate");

		objSearchScheduleType.each( function() {
			$(this).prop('checked', false);
		});
		objSearchScheduleType.filter('[value=' + searchScheduleType + ']').prop('checked', true);

		g_objReserveSearchPolicyDialog.find(".schedule").each( function() {
			$(this).hide();
		});
		objSearchScheduleType.filter('[value=' + searchScheduleType + ']').closest('div').siblings('div .schedule').show();

		g_objReserveSearchPolicyDialog.find('select[name="nthweek"]').each( function() {
			fillDropdownList($(this), g_htNthWeekTypeList, '<%=NthWeekType.NTHWEEK_TYPE_FIRST%>', null);
		});
		if (typeof nthWeekForMonth !== typeof undefined && nthWeekForMonth !== false) {
			objNthWeekForMonth.val(nthWeekForMonth);
		}

		g_objReserveSearchPolicyDialog.find('select[name="dayofweek"]').each( function() {
			fillDropdownList($(this), g_htDayOfWeekTypeList, '<%=DayOfWeekType.DAYOFWEEK_TYPE_MONDAY%>', null);
		});
		if (typeof dayOfWeekForMonth !== typeof undefined && dayOfWeekForMonth !== false) {
			objDayOfWeekForMonth.val(dayOfWeekForMonth);
		}
		if (typeof dayOfWeekForWeek !== typeof undefined && dayOfWeekForWeek !== false) {
			objDayOfWeekForWeek.val(dayOfWeekForWeek);
		}

		g_objReserveSearchPolicyDialog.find('select[name="searchhours"]').each( function() {
			$(this).empty();
			for (var i=0; i<24; i++) {
				if (i < 10)
					$(this).append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
				else
					$(this).append('<option value="' + i + '">' + i + '</option>');
			}
		});
		if (typeof searchHoursForMonth !== typeof undefined && searchHoursForMonth !== false) {
			objSearchHoursForMonth.val(searchHoursForMonth);
		}
		if (typeof searchHoursForWeek !== typeof undefined && searchHoursForWeek !== false) {
			objSearchHoursForWeek.val(searchHoursForWeek);
		}
		if (typeof searchHoursForDay !== typeof undefined && searchHoursForDay !== false) {
			objSearchHoursForDay.val(searchHoursForDay);
		}
		if (typeof searchHoursForSpecifiedDate !== typeof undefined && searchHoursForSpecifiedDate !== false) {
			objSearchHoursForSpecifiedDate.val(searchHoursForSpecifiedDate);
		}

		g_objReserveSearchPolicyDialog.find('select[name="searchminutes"]').each( function() {
			$(this).empty();
			for (var i=0; i<60; i++) {
				if (i < 10)
					$(this).append('<option value="' + ('0' + i) + '">' + ('0' + i) + '</option>');
				else
					$(this).append('<option value="' + i + '">' + i + '</option>');
			}
		});
		if (typeof searchMinutesForMonth !== typeof undefined && searchMinutesForMonth !== false) {
			objSearchMinutesForMonth.val(searchMinutesForMonth);
		}
		if (typeof searchMinutesForWeek !== typeof undefined && searchMinutesForWeek !== false) {
			objSearchMinutesForWeek.val(searchMinutesForWeek);
		}
		if (typeof searchMinutesForDay !== typeof undefined && searchMinutesForDay !== false) {
			objSearchMinutesForDay.val(searchMinutesForDay);
		}
		if (typeof searchMinutesForSpecifiedDate !== typeof undefined && searchMinutesForSpecifiedDate !== false) {
			objSearchMinutesForSpecifiedDate.val(searchMinutesForSpecifiedDate);
		}

		if (typeof searchSpecifiedDate !== typeof undefined && searchSpecifiedDate !== false) {
			objSearchSpecifiedDate.val(searchSpecifiedDate);
		}

		g_objReserveSearchPolicyDialog.dialog('option', 'title', '예약검사 정책 정보');
		g_objReserveSearchPolicyDialog.dialog({height:'auto'});

		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(추가)').hide();
		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(수정)').show();
		g_objReserveSearchPolicyDialog.parent().find('.ui-dialog-buttonpane button:contains(삭제)').show();

  		g_objReserveSearchPolicyDialog.dialog('open');
	};

	insertReserveSearchPolicy = function() {

		var objSearchScheduleType = g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]');
		var objNthWeekForMonth = g_objReserveSearchPolicyDialog.find('#nthweekformonth');
		var objDayOfWeekForMonth = g_objReserveSearchPolicyDialog.find('#dayofweekformonth');
		var objSearchHoursForMonth = g_objReserveSearchPolicyDialog.find('#searchhoursformonth');
		var objSearchMinutesForMonth = g_objReserveSearchPolicyDialog.find('#searchminutesformonth');
		var objDayOfWeekForWeek = g_objReserveSearchPolicyDialog.find('#dayofweekforweek');
		var objSearchHoursForWeek = g_objReserveSearchPolicyDialog.find('#searchhoursforweek');
		var objSearchMinutesForWeek = g_objReserveSearchPolicyDialog.find('#searchminutesforweek');
		var objSearchHoursForDay = g_objReserveSearchPolicyDialog.find('#searchhoursforday');
		var objSearchMinutesForDay = g_objReserveSearchPolicyDialog.find('#searchminutesforday');
		var objSearchSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchspecifieddate');
		var objSearchHoursForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchhoursforspecifieddate');
		var objSearchMinutesForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchminutesforspecifieddate');

		var htPolicyInfo = new Hashtable();
		htPolicyInfo.put('searchscheduletype', objSearchScheduleType.filter(':checked').val());
		htPolicyInfo.put('nthweekformonth', objNthWeekForMonth.val());
		htPolicyInfo.put('dayofweekformonth', objDayOfWeekForMonth.val());
		htPolicyInfo.put('searchhoursformonth', objSearchHoursForMonth.val());
		htPolicyInfo.put('searchminutesformonth', objSearchMinutesForMonth.val());
		htPolicyInfo.put('dayofweekforweek', objDayOfWeekForWeek.val());
		htPolicyInfo.put('searchhoursforweek', objSearchHoursForWeek.val());
		htPolicyInfo.put('searchminutesforweek', objSearchMinutesForWeek.val());
		htPolicyInfo.put('searchhoursforday', objSearchHoursForDay.val());
		htPolicyInfo.put('searchminutesforday', objSearchMinutesForDay.val());
		htPolicyInfo.put('searchspecifieddate', objSearchSpecifiedDate.val());
		htPolicyInfo.put('searchhoursforspecifieddate', objSearchHoursForSpecifiedDate.val());
		htPolicyInfo.put('searchminutesforspecifieddate', objSearchMinutesForSpecifiedDate.val());

		addPolicy(htPolicyInfo, null);

		g_objReserveSearchPolicyDialog.dialog('close');
	};

	updateReserveSearchPolicy = function() {

		var objSearchScheduleType = g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]');
		var objNthWeekForMonth = g_objReserveSearchPolicyDialog.find('#nthweekformonth');
		var objDayOfWeekForMonth = g_objReserveSearchPolicyDialog.find('#dayofweekformonth');
		var objSearchHoursForMonth = g_objReserveSearchPolicyDialog.find('#searchhoursformonth');
		var objSearchMinutesForMonth = g_objReserveSearchPolicyDialog.find('#searchminutesformonth');
		var objDayOfWeekForWeek = g_objReserveSearchPolicyDialog.find('#dayofweekforweek');
		var objSearchHoursForWeek = g_objReserveSearchPolicyDialog.find('#searchhoursforweek');
		var objSearchMinutesForWeek = g_objReserveSearchPolicyDialog.find('#searchminutesforweek');
		var objSearchHoursForDay = g_objReserveSearchPolicyDialog.find('#searchhoursforday');
		var objSearchMinutesForDay = g_objReserveSearchPolicyDialog.find('#searchminutesforday');
		var objSearchSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchspecifieddate');
		var objSearchHoursForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchhoursforspecifieddate');
		var objSearchMinutesForSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchminutesforspecifieddate');

		var htPolicyInfo = new Hashtable();
		htPolicyInfo.put('searchscheduletype', objSearchScheduleType.filter(':checked').val());
		htPolicyInfo.put('nthweekformonth', objNthWeekForMonth.val());
		htPolicyInfo.put('dayofweekformonth', objDayOfWeekForMonth.val());
		htPolicyInfo.put('searchhoursformonth', objSearchHoursForMonth.val());
		htPolicyInfo.put('searchminutesformonth', objSearchMinutesForMonth.val());
		htPolicyInfo.put('dayofweekforweek', objDayOfWeekForWeek.val());
		htPolicyInfo.put('searchhoursforweek', objSearchHoursForWeek.val());
		htPolicyInfo.put('searchminutesforweek', objSearchMinutesForWeek.val());
		htPolicyInfo.put('searchhoursforday', objSearchHoursForDay.val());
		htPolicyInfo.put('searchminutesforday', objSearchMinutesForDay.val());
		htPolicyInfo.put('searchspecifieddate', objSearchSpecifiedDate.val());
		htPolicyInfo.put('searchhoursforspecifieddate', objSearchHoursForSpecifiedDate.val());
		htPolicyInfo.put('searchminutesforspecifieddate', objSearchMinutesForSpecifiedDate.val());

		updatePolicy(htPolicyInfo);

		g_objReserveSearchPolicyDialog.dialog('close');
	};

	validateReserveSearchPolicyData = function() {

		var objSearchScheduleType = g_objReserveSearchPolicyDialog.find('input[type="radio"][name="searchscheduletype"]');
		var objSearchSpecifiedDate = g_objReserveSearchPolicyDialog.find('#searchspecifieddate');
		var objValidateTips = g_objReserveSearchPolicyDialog.find('#validateTips');

		if ((objSearchScheduleType.filter(':checked').val() == null) || (objSearchScheduleType.filter(':checked').val().length == 0)) {
			updateTips(objValidateTips, "검사 일정을 선택해주세요.");
			return false;
		}

		if (objSearchScheduleType.filter(':checked').val() == "<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_SPECIFIED_DATE%>") {
			if (objSearchSpecifiedDate.val().length == 0) {
				updateTips(objValidateTips, "검사 지정일을 선택해주세요.");
				objSearchSpecifiedDate.focus();
				return false;
			}
		}

		return true;
	};
//-->
</script>

<div id="dialog-reservesearchpolicy" title="" class="dialog-form">
	<div class="dialog-contents">
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
			<div id="row-schedule" class="field-line">
				<div class="field-title">검사 일정</div>
				<div class="field-contents">
					<div style="padding: 5px;">
						<div><label class="radio"><input type="radio" name="searchscheduletype" value="<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_MONTH%>" /><span></span></label></div>
						<div class="schedule" style="margin: 2px 0 0 18px; display: none;">
							<select id="nthweekformonth" name="nthweek" class="ui-widget-content"></select>&nbsp;&nbsp;
							<select id="dayofweekformonth" name="dayofweek" class="ui-widget-content"></select>&nbsp;&nbsp;
							<select id="searchhoursformonth" name="searchhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시
							<select id="searchminutesformonth" name="searchminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분에 검사합니다.
						</div>
					</div>
					<div style="padding: 5px;">
						<div><label class="radio"><input type="radio" name="searchscheduletype" value="<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_WEEK%>" /><span></span></label></div>
						<div class="schedule" style="margin: 2px 0 0 18px; display: none;">
							<select id="dayofweekforweek" name="dayofweek" class="ui-widget-content"></select>&nbsp;&nbsp;
							<select id="searchhoursforweek" name="searchhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시
							<select id="searchminutesforweek" name="searchminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분에 검사합니다.
						</div>
					</div>
					<div style="padding: 5px;">
						<div><label class="radio"><input type="radio" name="searchscheduletype" value="<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_EACH_DAY%>" /><span></span></label></div>
						<div class="schedule" style="margin: 2px 0 0 18px; display: none;">
							<select id="searchhoursforday" name="searchhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시
							<select id="searchminutesforday" name="searchminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분에 검사합니다.
						</div>
					</div>
					<div style="padding: 5px;">
						<div><label class="radio"><input type="radio" name="searchscheduletype" value="<%=SearchScheduleType.SEARCH_SCHEDULE_TYPE_SPECIFIED_DATE%>" /><span></span></label></div>
						<div class="schedule" style="margin: 2px 0 0 18px; display: none;">
							<input type="text" id="searchspecifieddate" name="searchspecifieddate" class="text ui-widget-content" style="width: 80px; text-align: center;" readonly="readonly" /> 일
							<select id="searchhoursforspecifieddate" name="searchhours" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 시
							<select id="searchminutesforspecifieddate" name="searchminutes" style="min-width: 55px; width: 55px;" class="ui-widget-content"></select> 분에 검사합니다.
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
