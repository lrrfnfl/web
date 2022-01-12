<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<script type="text/javascript">
<!--
	var g_objUserNoticeMemberDialog;
	var g_objUserNoticeMemberTree;

	$(document).ready(function() {
		g_objUserNoticeMemberDialog = $('#dialog-usernoticemember');
		g_objUserNoticeMemberTree = $('#usernoticemember-tree');

		g_objUserNoticeMemberDialog.dialog({
			autoOpen: false,
			minWidth: 400,
			maxWidth: $(document).width(),
			height: 'auto',
			minHeight: 400,
			maxHeight: $(document).height(),
			modal: true,
			open: function() {
				$(this).parent().find('.ui-dialog-buttonpane button:contains("확인")').button({
 					icons: { primary: 'ui-icon-circle-check' }
				});
				$(this).parent().focus();
			},
			buttons: {
				"확인": function() {
					$(this).dialog('close');
				}
			},
			close: function() {
				var targetUserCount = 0;
				g_objUserNoticeMemberTree.jstree("get_checked", null, true).each( function() {
					if ($(this).attr('node_type') == "user") {
						targetUserCount++;
					}
				});
				g_objUserNoticeDialog.find('#targetusercount').text(targetUserCount.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
			},
			resizeStop: function(event, ui) {
				resizeDialog($(this));
			}
		})
		.dialogExtend({
			"closable" : false,
			"maximizable" : true,
			"minimizable" : false,
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
	});

	openUserNoticeMemberDialog = function() {
		g_objUserNoticeMemberDialog.dialog('open');
	};

	resizeDialog = function(objDialog) {
		var resizedHeight = objDialog.height() - objDialog.find(".dialog-contents").outerHeight(true);

		objDialog.find('.treeview-pannel').innerHeight(objDialog.find('.treeview-pannel').innerHeight() + resizedHeight - 1);
		objDialog.find('.treeview-pannel').mCustomScrollbar('update');
	};

	loadCompanyNode = function(companyId) {

		var nodeData = ""; 
		var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', companyId);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					var startTag = "<root>";
					var endTag = "</root>";
					nodeData = new XMLSerializer().serializeToString(data);
					nodeData = nodeData.substr(nodeData.indexOf(startTag), nodeData.lastIndexOf(endTag)-nodeData.indexOf(startTag)+endTag.length);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("사업장 노드 조회", "사업장 노드 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return nodeData;
	};

	loadUserNoticeMemberTreeView = function() {

		var xmlTreeData = loadCompanyNode(g_objUserNoticeDialog.find('input[name="companyid"]').val());

		g_objUserNoticeMemberTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = "<%=OptionType.OPTION_TYPE_YES%>";
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
							displayAlertDialog("공지 대상 구성도 조회", "공지 대상 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("공지 대상 구성도 조회", "공지 대상 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu", "checkbox" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
			loadUserNoticeMemberList();
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
			data.inst._get_children(data.rslt.obj).each( function() {
				if (($(this).attr('node_type') == "company") || ($(this).attr('node_type') == "user")) {
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
			if (!data.inst.is_checked(data.rslt.obj)) {
				data.inst.check_node(data.rslt.obj);
			} else {
				data.inst.uncheck_node(data.rslt.obj);
			}
		});
	};

	loadUserNoticeMemberList = function() {

		if (g_objUserNoticeDialog.find('input[name="noticeid"]').val().length == 0)
			return false;

		var postData = getRequestUserNoticeMemberListParam(
				g_objUserNoticeDialog.find('input[name="noticeid"]').val(),
				g_objUserNoticeDialog.find('input[name="companyid"]').val(),
				null,
				"",
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
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("공지 대상 목록 조회", "공지 대상 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					$(data).find('record').each(function() {
						var targetNodeId = "uid_" + $(this).find('companyid').text() + "_" + $(this).find('userid').text();
						$.jstree._reference(g_objUserNoticeMemberTree).check_node('#' + targetNodeId);
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("공지 대상 목록 조회", "공지 대상 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};
//-->
</script>

<div id="dialog-usernoticemember" title="공지 대상 선택" class="dialog-form">
	<div class="dialog-contents">
		<div class="info">
			<ul class="infolist">
				<li>공지 대상 사용자를 선택해 주세요.</li>
			</ul>
		</div>
		<div class="category-title">공지 대상 사용자</div>
		<div class="category-contents zero-padding">
			<div id="usernoticemember-tree" class="treeview-pannel" style="height: 300px;"></div>
		</div>
	</div>
</div>
