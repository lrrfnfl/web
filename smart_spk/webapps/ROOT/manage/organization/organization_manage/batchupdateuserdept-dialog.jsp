<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objBatchUpdateUserDeptDialog;
	var g_objBatchUpdateUserList;
	var g_objBatchUpdateDeptTree;

	$(document).ready(function() {

		g_objBatchUpdateUserDeptDialog = $('#dialog-batchupdateuserdept');
		g_objBatchUpdateUserList = $('#batch-update-user-list');
		g_objBatchUpdateDeptTree = $('#batch-update-dept-tree');

		g_objBatchUpdateUserDeptDialog.dialog({
			autoOpen: false,
			minWidth: 600,
			width: 800,
			maxWidth: $(document).width(),
			height: 'auto',
			minHeight: 600,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("부서 변경")').button({
 					icons: { primary: 'ui-icon-wrench' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
				$(this).parent().focus();
				resizeDialog($(this));
				loadBatchUpdateUserList();
				loadBatchUpdateDeptTreeView();
			},
			buttons: {
				"부서 변경": function() {
					if (validateBatchUpdateUserDeptData()) {
						displayConfirmDialog("부서 변경", "선택한 사용자들의 부서를 변경 하시겠습니까?", "", function() { batchUpdateUserDept(); });
					}
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				$(this).find('#validateTips').hide();
			},
			resizeStop: function(event, ui) {
				resizeDialog($(this));
			}
		})
		.dialogExtend({
			"closable" : false,
			"maximizable" : true,
			"minimizable" : true,
			"collapsable" : true,
			//"dblclick" : "collapse",
			"load" : function(event, dialog){},
			"beforeCollapse" : function(event, dialog){ },
			"beforeMaximize" : function(event, dialog){ },
			"beforeMinimize" : function(event, dialog){ },
			"beforeRestore" : function(event, dialog){ },
			"collapse" : function(event, dialog){ },
			"maximize" : function(event, dialog){
				resizeDialog($(this));
			},
			"minimize" : function(event, dialog){ },
			"restore" : function(event, dialog){
				resizeDialog($(this));
			}
		});
	});

	resizeDialog = function(objDialog) {
		var resizedHeight = objDialog.height() - objDialog.find(".dialog-contents").outerHeight(true);

		objDialog.find('#batch-update-user-list').height(objDialog.find('#batch-update-user-list').height() + resizedHeight - 1);
		objDialog.find('#batch-update-user-list').mCustomScrollbar('update');

		objDialog.find('#batch-update-target-dept').outerHeight(objDialog.find('#batch-update-user-list').outerHeight(true));
		objDialog.find('.treeview-pannel').outerHeight(objDialog.find('#batch-update-target-dept').height());
		objDialog.find('.treeview-pannel').mCustomScrollbar('update');
	};

	openBatchUpdateUserDeptDialog = function() {
		g_objBatchUpdateUserDeptDialog.dialog('open');
	};

	loadBatchUpdateUserList = function() {

		var htmlContents = '';

		htmlContents += '<table class="list-table">';
		htmlContents += '<thead>';
		htmlContents += '<tr>';
		htmlContents += '<th width="40" class="ui-state-default" style="text-align: center;">';
		htmlContents += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur()" checked>';
		htmlContents += '</th>';
		htmlContents += '<th class="ui-state-default">부서</th>';
		htmlContents += '<th class="ui-state-default">사용자 ID</th>';
		htmlContents += '<th class="ui-state-default">사용자 명</th>';
		htmlContents += '</tr>';
		htmlContents += '</thead>';
		htmlContents += '<tbody>';

		if (g_objUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').length == 0) {
			var objSearchCondition = g_objUserList.find('#search-condition');
			var objSearchResult = g_objUserList.find('#search-result');

			var objSearchUserName = objSearchCondition.find('input[name="searchusername"]');
			var objSearchServiceState = objSearchCondition.find('select[name="searchservicestate"]');

			var objOrganizationTreeReference = $.jstree._reference(g_objOrganizationTree);

			var targetCompanyId = ""; 
			if (typeof objOrganizationTreeReference.get_selected().attr('companyid') != typeof undefined) {
				targetCompanyId = objOrganizationTreeReference.get_selected().attr('companyid');
			}

			var arrTargetDeptList = new Array();
			if (objOrganizationTreeReference.get_selected().attr('node_type') == "dept") {
				arrTargetDeptList.push(objOrganizationTreeReference.get_selected().attr('deptcode'));
				if ($('input:checkbox[name="includechilddept"]').is(':checked') == true) {
					objOrganizationTreeReference.get_selected().find("li").each( function(idx, listItem) {
						if ($(this).attr('node_type') == 'dept') {
							arrTargetDeptList.push($(this).attr('deptcode'));
						}
					});
				}
			}

			var postData = getRequestUserListParam(targetCompanyId,
				arrTargetDeptList,
				objSearchUserName.val(),
				objSearchServiceState.val(),
				'',
				'',
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
						displayAlertDialog("사용자 목록 조회", "사용자 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
						return false;
					}

					$(data).find('record').each( function (index, value) {
						if (index%2 == 0)
							htmlContents += '<tr class="list_even">';
						else
							htmlContents += '<tr class="list_odd">';

						var companyId = $(this).find('companyid').text();
						var userId = $(this).find('userid').text();
						var userName = $(this).find('username').text();
						var deptName = $(this).find('deptname').text();

						htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" userid="' + userId + '" style="border: 0;" checked></td>';
						htmlContents += '<td>' + deptName + '</td>';
						htmlContents += '<td>' + userId + '</td>';
						htmlContents += '<td>' + userName + '</td>';
					});
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("사용자 목록 조회", "사용자 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		} else {
			g_objUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').each( function (index, value) {
				if (index%2 == 0)
					htmlContents += '<tr class="list_even">';
				else
					htmlContents += '<tr class="list_odd">';

				htmlContents += '<td style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + $(this).attr('companyid') + '" userid="' + $(this).attr('userid') + '" style="border: 0;" checked></td>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<td>' + $(this).closest('tr').find('td:eq(2)').text() + '</td>';
<% } else { %>
				htmlContents += '<td>' + $(this).closest('tr').find('td:eq(1)').text() + '</td>';
<% } %>
				htmlContents += '<td>' + $(this).attr('userid') + '</td>';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
				htmlContents += '<td>' + $(this).closest('tr').find('td:eq(4)').text() + '</td>';
<% } else { %>
				htmlContents += '<td>' + $(this).closest('tr').find('td:eq(3)').text() + '</td>';
<% } %>
			});
		}

		htmlContents += '</tbody>';
		htmlContents += '</table>';

		g_objBatchUpdateUserList.html(htmlContents);
		g_objBatchUpdateUserList.mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		var inlineScriptText = "";
		inlineScriptText += "g_objBatchUpdateUserList.find('.list-table thead tr th:first-child').click( function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody input:checkbox').each( function () { $(this).prop('checked', checkState); }); });";
		inlineScriptText += "g_objBatchUpdateUserList.find('.list-table tbody tr').click( function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead input:checkbox').prop('checked', false); }; });";

		var inlineScript   = document.createElement("script");
		inlineScript.type  = "text/javascript";
		inlineScript.text  = inlineScriptText;

		g_objBatchUpdateUserList.append(inlineScript);
	};

	loadBatchUpdateDeptTreeView = function() {

		var objOrganizationTreeReference = $.jstree._reference(g_objOrganizationTree);

		var xmlTreeData = '';
		xmlTreeData = loadCompanyNode(objOrganizationTreeReference.get_selected().attr('companyid'));

		g_objBatchUpdateDeptTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = "<%=OptionType.OPTION_TYPE_NO%>";
							var companyid = "";
							var deptCode = "";
							if (typeof node.attr('companyid') != typeof undefined) {
								companyid = node.attr('companyid');
							}
							if (typeof node.attr('deptcode') != typeof undefined) {
								deptCode = node.attr('deptcode');
							}
							var postData = getRequestDeptTreeNodesParam(companyid, deptCode, includeUserNodes);
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
							displayAlertDialog("대상 부서 구성도 조회", "대상 부서 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("대상 부서 구성도 조회", "대상 부서 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
						}
					}
				}
			},
			"themes": {
				"theme": "classic",
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
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
		}).bind('select_node.jstree', function (event, data) {
			if (data.rslt.obj.attr('node_type') != "company") {
				data.inst.toggle_node(data.rslt.obj);
			} else {
				data.inst.deselect_node(data.rslt.obj);
			}
		});
	};

	batchUpdateUserDept = function() {

		var objBatchUpdateDeptTreeReference = $.jstree._reference(g_objBatchUpdateDeptTree);

		var arrTargetUserList = new Array();
		g_objBatchUpdateUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').each( function () {
			arrTargetUserList.push($(this).attr('userid'));
		});

		var postData = getRequestBatchUpdateUserDeptParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				objBatchUpdateDeptTreeReference.get_selected().attr('companyid'),
				"<%=TargetUserType.TARGET_USER_TYPE_USER%>",
				"",
				arrTargetUserList,
				objBatchUpdateDeptTreeReference.get_selected().attr('deptcode'));

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 변경", "부서 변경 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("부서 변경", "정상 처리되었습니다.", "정상적으로 선택한 사용자들의 부서가 변경되었습니다.");
					var objTreeReference = $.jstree._reference(g_objOrganizationTree);
					var selectedNode = objTreeReference.get_selected();
					objTreeReference.deselect_node(selectedNode);
					objTreeReference.select_node(selectedNode);
					g_objBatchUpdateUserDeptDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 변경", "부서 변경 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateBatchUpdateUserDeptData = function() {

		var objBatchUpdateDeptTreeReference = $.jstree._reference(g_objBatchUpdateDeptTree);

		var objValidateTips = g_objBatchUpdateUserDeptDialog.find('#validateTips');

		if (g_objBatchUpdateUserList.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').length <= 0) {
			updateTips(objValidateTips, '변경할 대상 사용자를 선택해 주세요.');
			return false;
		}
		
		if (objBatchUpdateDeptTreeReference.get_selected().attr('node_type') != "dept") {
			updateTips(objValidateTips, '변경할 대상 부서를 선택해 주세요.');
			return false;
		}

		return true;
	};
//-->
</script>

<div id="dialog-batchupdateuserdept" title="부서 변경" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>변경할 사용자와 부서를 선택해 주세요.</li>
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
		<div>
			<div style="float: left; width: 60%">
				<div>
					<div class="category-title">대상 사용자 목록</div>
					<div id="batch-update-user-list" class="category-contents"></div>
				</div>
			</div>
			<div style="margin-left: 61%;">
				<div>
					<div class="category-title">대상 부서 선택</div>
					<div id="batch-update-target-dept" class="category-contents zero-padding">
						<div id="batch-update-dept-tree" class="treeview-pannel"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
