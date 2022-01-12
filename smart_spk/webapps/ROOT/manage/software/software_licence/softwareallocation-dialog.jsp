<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objSoftwareAllocationDialog;

	$(document).ready(function() {
		g_objSoftwareAllocationDialog = $('#dialog-softwareallocation');
		g_objOrganizationTree = $('#organization-tree');

		g_objSoftwareAllocationDialog.find('input[name="includechilddept"]:checkbox').click(function() {
			loadSoftwareAllocationTargetUserList();
		});
	});

	openSoftwareAllocationDialog = function() {

		loadOrganizationTreeView();

		g_objSoftwareAllocationDialog.dialog({
			autoOpen: false,
			minWidth: 740,
			maxWidth: $(document).width(),
			height: 'auto',
			minHeight: 360,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("저장")').button({
 					icons: { primary: 'ui-icon-circle-plus' }
				});
				$(this).parent().find('.ui-dialog-buttonpane button:contains("취소")').button({
 					icons: { primary: 'ui-icon-circle-close' }
				});
			},
			buttons: {
				"저장":  function() {
					displayConfirmDialog("소프트웨어 배정", "선택하신 사용자에게 소프트웨어를 배정하시겠습니까?", "", function() { allocateSoftware(); });
				},
				"취소": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
			},
			resizeStop: function(event, ui) {
				resizeDialog($(this));
			}
		})
		.dialogExtend({
			"closable" : true,
			"maximizable" : true,
			"minimizable" : true,
			"collapsable" : false,
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

		g_objSoftwareAllocationDialog.dialog('option', 'title', '소프트웨어 배정 - [' + g_objSoftwareLicenceInfo.find('input[name="softwarename"]').val() + ']');
		g_objSoftwareAllocationDialog.dialog('open');
	};

	resizeDialog = function(objDialog) {

		var resizedHeight = objDialog.height() - objDialog.find(".dialog-contents").outerHeight(true);

		var scrollTableBodyHeight = objDialog.find('.st-body').height();

		objDialog.find('.scroll-table').scrolltable('destroy');
		objDialog.find('.scroll-table').scrolltable({
			stripe: true,
			oddClass: 'odd',
			height: scrollTableBodyHeight + resizedHeight
		});
		objDialog.find('.treeview-pannel').innerHeight(objDialog.find('.scroll-table').height()+1);
	};

	loadOrganizationTreeView = function() {

		var postData = "";

		postData = getRequestOrganizationInfoParam(g_objSoftwareLicenceInfo.find('input[name="companyid"]').val(), "<%=OptionType.OPTION_TYPE_NO%>");

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

				$(data).find('company').each(function() {
					var itemId = $(this).find('companyid').text();

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
					companyNodeXml += "<item id='" + itemId + "' parent_id='ALL' service_state='" + $(this).find('servicestateflag').text() + "' node_type='company'>";
<% } else { %>
					companyNodeXml += "<item id='" + itemId + "' service_state='" + $(this).find('servicestateflag').text() + "' node_type='company'>";
<% } %>
					companyNodeXml += "<content><name>" + $(this).find('companyname').text() + "</name></content>";
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

					deptNodeXml += "<item id='" + itemId + "' parent_id='" + itemParentId + "' companyid='" + $(this).find('companyid').text() + "' deptcode='" + $(this).find('deptcode').text() + "' node_type='dept'>";
					deptNodeXml += "<content><name>" + $(this).find('deptname').text() + "</name></content>";
					deptNodeXml += "</item>";
				});

				xmlTreeData += "<root>";
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
						"types": {
							"disabled" : {
								"check_node" : false,
								"uncheck_node" : false
							}
						},
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
					"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu" ]

				}).bind('loaded.jstree', function (event, data) {
					data.inst.open_all(-1); // -1 opens all nodes in the container

					// ROOT 노드 Select
					data.inst.select_node('ul > li:first');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
					data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
					data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
				}).bind('select_node.jstree', function (event, data) {
					loadSoftwareAllocationTargetUserList();
				});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("조직 구성 정보 조회", "조직 구성 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	loadSoftwareAllocationTargetUserList = function() {

		var companyId = "";
		var deptCode = "";

		var selectedNode = g_objOrganizationTree.jstree("get_selected");
		if (!$.isEmptyObject(selectedNode)) {
			if (selectedNode.attr('node_type') == "company") {
				companyId = selectedNode.attr('id');
				deptCode = "";
			} else if (selectedNode.attr('node_type') == "dept") {
				companyId = selectedNode.attr('companyid');
				deptCode = selectedNode.attr('deptcode');
			}
		}

		var arrTargetDeptList = new Array();
		if ((deptCode != null) && (deptCode.length != 0 )) {
			arrTargetDeptList.push(deptCode);
			if ($('input:checkbox[name="includechilddept"]').is(':checked') == true) {
				g_objOrganizationTree.find('#' + companyId + '_' + deptCode).find("li").each( function( idx, listItem) {
					if ($(this).attr('node_type') == 'dept') {
						arrTargetDeptList.push($(this).attr('deptcode'));
					}
				});
			}
		}

		var postData = getRequestSoftwareAllocationTargetUserListParam(companyId,
			arrTargetDeptList,
			g_objSoftwareLicenceInfo.find('input[name="softwarename"]').val(),
			"DEPTNAME, USERNAME",
			"ASC",
			"",
			"");

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('#user-list').block({ message: '<img src="/images/processing.gif" align="bottom" alt="" width="16" height="16" /> 처리중...', css: { padding: '5px 0', width: '140px', background: 'transparent', border: '1px dotted #ddd', color: '#fff' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('#user-list').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 배정 대상 목록 조회", "소프트웨어 배정 대상 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var objUserList = g_objSoftwareAllocationDialog.find('#user-list');

				var oldScrollTableHeight = null;
				if (objUserList.find('.st-body').length > 0) {
					oldScrollTableHeight = objUserList.find('.st-body').height();
					objUserList.find('.scroll-table').scrolltable('destroy');
				}

				var resultRecordCount = $(data).find('record').length;

				var htmlContents = '';
				htmlContents += '<table class="ui-widget-content scroll-table">';
				htmlContents += '<thead>';
				htmlContents += '<tr style="border:none">';
				htmlContents += '<th width="40" style="text-align: center;">';
				if (resultRecordCount > 0) {
					htmlContents += '<input type="checkbox" name="All" style="border: 0;" onFocus="this.blur()">';
				} else {
					htmlContents += '&nbsp;';
				}
				htmlContents += '</th>';
				htmlContents += '<th>부서 명</th>';
				htmlContents += '<th>사용자 명</th>';
				htmlContents += '<th width="60">설치 상태</th>';
				htmlContents += '</tr>';
				htmlContents += '</thead>';
				htmlContents += '<tbody>';

				if (resultRecordCount > 0) {
					var recordCount = 1;
					var lineStyle = '';
					$(data).find('record').each(function() {
						if (recordCount%2 == 0)
							lineStyle = "list_even";
						else
							lineStyle = "list_odd";

						htmlContents += '<tr companyid="' + companyId + '" deptcode="' + $(this).find('deptcode').text() + '" class="' + lineStyle + '">';
						if ($(this).find('allocatestate').text() == "0") {
							htmlContents += '<td width="40" style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" deptcode="' + $(this).find('deptcode').text() + '" userid="' + $(this).find('userid').text() + '" style="border: 0;"></td>';
						} else {
							htmlContents += '<td width="40" style="text-align: center;"><input type="checkbox" name="selectuser" companyid="' + companyId + '" deptcode="' + $(this).find('deptcode').text() + '" userid="' + $(this).find('userid').text() + '" style="border: 0;" checked></td>';
						}
						htmlContents += '<td>' + $(this).find('deptname').text() + '</td>';
						htmlContents += '<td>' + $(this).find('username').text() + '</td>';
						htmlContents += '<td>' + g_htOptionTypeList.get($(this).find('installstate').text()) + '</td>';
						htmlContents += '</tr>';

						recordCount++;
					});

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objUserList.html(htmlContents);

					var inlineScriptText = "";
					inlineScriptText += "g_objSoftwareAllocationDialog.find('.scroll-table tr.list_odd').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_odd')});";
					inlineScriptText += "g_objSoftwareAllocationDialog.find('.scroll-table tr.list_even').hover(function() {$(this).toggleClass('list_text_over');$(this).toggleClass('list_even')});";
					inlineScriptText += "g_objSoftwareAllocationDialog.find('.scroll-table input:checkbox[name=All]').click( function () { if ($(this).is(':checked') == true) { $('input:checkbox[name=selectuser]').each( function () { $(this).prop('checked', true); }); } else { $('input:checkbox[name=selectuser]').each( function () { $(this).prop('checked', false); }); } });";
					inlineScriptText += "g_objSoftwareAllocationDialog.find('.scroll-table tbody tr td:first-child').click( function (e) { e.stopPropagation(); });";

					var inlineScript   = document.createElement("script");
					inlineScript.type  = "text/javascript";
					inlineScript.text  = inlineScriptText;

					objUserList.append(inlineScript);
				} else {
					htmlContents += '<tr>';
					htmlContents += '<td colspan="4" align="center"><div style="padding: 10px 0; text-align: center;">등록된 소프트웨어 배정 대상 목록이 존재하지 않습니다.</div></td>';
					htmlContents += '</tr>';

					htmlContents += '</tbody>';
					htmlContents += '</table>';

					objUserList.html(htmlContents);
				}

				if (oldScrollTableHeight != null) {
					objUserList.find('.scroll-table').scrolltable({
						stripe: true,
						oddClass: 'odd',
						setWidths: true,
						height: oldScrollTableHeight
					});
				} else {
					objUserList.find('.scroll-table').scrolltable({
						stripe: true,
						oddClass: 'odd',
						setWidths: true
					});
					resizeDialog(g_objSoftwareAllocationDialog);
					g_objSoftwareAllocationDialog.dialog("option", "position", { my: "center", at: "center" } );
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 배정 대상 목록 조회", "소프트웨어 배정 대상 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	allocateSoftware = function() {

		var arrTargetDeptList = new Array();

		var selectedNode = g_objOrganizationTree.jstree("get_selected");
		if (!$.isEmptyObject(selectedNode)) {
			if (selectedNode.attr('node_type') == "dept") {
				var companyId = selectedNode.attr('companyid');
				var deptCode = selectedNode.attr('deptcode');

				if ((deptCode != null) && (deptCode.length != 0 )) {
					arrTargetDeptList.push(deptCode);
					if ($('input:checkbox[name="includechilddept"]').is(':checked') == true) {
						g_objOrganizationTree.find('#' + companyId + '_' + deptCode).find("li").each( function( idx, listItem) {
							if ($(this).attr('node_type') == 'dept') {
								arrTargetDeptList.push($(this).attr('deptcode'));
							}
						});
					}
				}
			}
		}

		var arrTargetUserList = new Array();
		g_objSoftwareAllocationDialog.find('input:checkbox[name=selectuser]').filter(':checked').each( function () {
			var arrTargetUser = new Array();
			arrTargetUser.push($(this).attr('companyid'));
			arrTargetUser.push($(this).attr('deptcode'));
			arrTargetUser.push($(this).attr('userid'));
			arrTargetUserList.push(arrTargetUser);
		});

		var postData = getRequestAllocateSoftwareParam('<%=(String)session.getAttribute("ADMINID")%>',
				g_objSoftwareLicenceInfo.find('input[name="companyid"]').val(),
				g_objSoftwareLicenceInfo.find('input[name="softwarename"]').val(),
				arrTargetDeptList,
				arrTargetUserList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				g_objSoftwareAllocationDialog.parent().find('.ui-dialog-buttonpane button:contains("저장")').attr("disabled", true);
				g_objSoftwareAllocationDialog.parent().find('.ui-dialog-buttonpane button:contains("취소")').attr("disabled", true);
			},
			complete: function(jqXHR, textStatus) {
				g_objSoftwareAllocationDialog.parent().find('.ui-dialog-buttonpane button:contains("저장")').attr("disabled", false);
				g_objSoftwareAllocationDialog.parent().find('.ui-dialog-buttonpane button:contains("취소")').attr("disabled", false);
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("소프트웨어 배정", "소프트웨어 배정 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("소프트웨어 배정", "정상 처리되었습니다.", "정상적으로 소프트웨어가 배정되었습니다.");
					loadSoftwareLicenceInfo();
					g_objSoftwareAllocationDialog.dialog('close');
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("소프트웨어 배정", "소프트웨어 배정 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-softwareallocation" title="소프트웨어 배정" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul>
				<li>소프트웨어를 배정할 사용자를 선택해 주세요.</li>
			</ul>
		</div>
		<div style="float: left; width: 35%">
			<div class="ui-state-default ui-corner-top category-title" style="border: 1px solid #aaa;">
				<div style="float: left;">조직도</div>
				<div style="float: right; font-weight: normal;"><input type="checkbox" id="includechilddept" name="includechilddept" style="vertical-align: top; width: 12px; height: 12px;"/><label for="includechilddept"> 하위부서 포함</label></div>
				<div class="clear"></div>
			</div>
			<div id="organization-tree" class="treeview-pannel" style="border: 1px solid #aaa;"></div>
		</div>
		<div style="margin-left: 36%;">
			<div class="ui-state-default ui-corner-top category-title" style="border: 1px solid #aaa;">소프트웨어 배정 대상 목록</div>
			<div id="user-list"></div>
		</div>
		<div class="clear"></div>
	</div>
</div>
