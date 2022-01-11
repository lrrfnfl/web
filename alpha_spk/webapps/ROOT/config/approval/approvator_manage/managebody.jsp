<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<%@ include file ="saveconfirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objOrganizationTree;
	var g_objMainContent;
	var g_objTargetUsersTree;
	var g_objDecodingApprobatorTree;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objOrganizationTree = $('#organization-tree');
		g_objMainContent = $('#main-content');
		g_objTargetUsersTree = $('#target-users-tree');
		g_objDecodingApprobatorTree = $('#decoding-approbator-tree');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnAddPriority"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDeleteApprobator"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnSave"]').button({ icons: {primary: "ui-icon-disk"} });

		$('#dialog:ui-dialog').dialog('destroy');

		innerDefaultLayout.show("west");
		loadOrganizationTreeView();
		loadDecodingApprobatorTreeView();

		$('button').click( function () {
			if ($(this).attr('id') == 'btnAddPriority') {
				addPriorityNode();
			} else if ($(this).attr('id') == 'btnDeleteApprobator') {
				var objTreeReference = $.jstree._reference(g_objDecodingApprobatorTree);
				var selectedNode = objTreeReference.get_selected();
				if (selectedNode.attr('node_type') == "user") {
					deleteApprobatorNode(selectedNode);
				}
			} else if ($(this).attr('id') == 'btnSave') {
				if (g_objOrganizationTree.find(".jstree-checked").length == 0) {
					displayAlertDialog("설정 저장 대상 오류", "조직 구성도에서 정보를 저장할 대상을 선택해 주세요.", '');
					return false;
				}
				openSaveConfirmDialog("설정 저장", "설정된 값으로 정보를 저장하시겠습니까?");
			}
		});
	});

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

	loadOrganizationTreeView = function() {

		var xmlTreeData = '';
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		xmlTreeData += '<root>';
		xmlTreeData += '<item id="root" node_type="root" state="closed">';
		xmlTreeData += '<content><name><![CDATA[전체 사업장]]></name></content>';
		xmlTreeData += '</item>';
		xmlTreeData += '</root>';
<% } else { %>
		xmlTreeData = loadCompanyNode('<%=(String)session.getAttribute("COMPANYID")%>');
<% } %>

		g_objOrganizationTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							var includeUserNodes = '<%=OptionType.OPTION_TYPE_YES%>';
							if (node.attr("node_type") == 'company_category') {
								var categoryCode = node.children('a').text().trim();
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', categoryCode, '');
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'company') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), '', includeUserNodes);
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'dept') {
								var postData = getRequestDeptTreeNodesParam(node.attr('companyid'), node.attr('deptcode'), includeUserNodes);
								return {
									sendmsg : postData
								};
							} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_ORGANIZATION%>', '', '');
<% } else { %>
								var postData = getRequestDeptTreeNodesParam('<%=(String)session.getAttribute("COMPANYID")%>', '', includeUserNodes);
<% } %>
								return {
									sendmsg : postData
								};
							}
						}
					},
					"dataType": "xml",
					"cache": false,
					"async": false,
					"success": function(data, textStatus, jqXHR) {
						if ($(data).find('errorcode').text() != "0000") {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("조직 구성도 조회", "조직 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
			data.inst._get_node('ul > li:first').children('a').first().find('.jstree-checkbox').hide();
<% } %>
			setTimeout(function() { data.inst.select_node('ul > li:first'); }, 500);
		}).bind('load_node.jstree', function (event, data) {
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
		}).bind('open_node.jstree', function (event, data) {
			data.inst._get_children(data.rslt.obj).each( function() {
				if ($(this).attr('node_type') == "company_category") {
					$(this).children('a').first().find('.jstree-checkbox').hide();
				} else {
					if (data.inst.is_checked($(this))) {
						if (!data.inst.is_open($(this))) {
							data.inst.open_node($(this));
						}
					}
				}
			});
		}).bind('check_node.jstree', function (event, data) {
			if ((typeof g_selectedTreeNode.attr('companyid') != typeof undefined) &&
					(g_selectedTreeNode.attr('companyid') != data.rslt.obj.attr('companyid'))) {
				data.inst.uncheck_node(data.rslt.obj);
				return false;
			}
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			} else {
				data.rslt.obj.find("li > a").each( function() {
					if (!data.inst.is_open($(this))) {
						data.inst.open_node($(this));
					} else {
						expandChilds($(this));
					}
				});
			}
		}).bind('select_node.jstree', function (event, data) {
			g_oldSelectedTreeNode = g_selectedTreeNode;
			g_selectedTreeNode = data.rslt.obj;
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
// 			if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
// 				if (!data.inst.is_checked(data.rslt.obj)) {
// 					data.inst.check_node(data.rslt.obj);
// 				}
// 			}
			data.inst.get_container().find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('companyid') != data.rslt.obj.attr('companyid')) {
					data.inst.uncheck_node($(node));
				}
			});
			if (!data.rslt.obj.is(g_oldSelectedTreeNode)) {
				if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
					if (data.rslt.obj.attr('node_type') == 'company') {
						$('.inner-center .pane-header').text('사업장 결재자 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
						loadDecodingApprobatorInfo(data.rslt.obj.attr('companyid'), '', '');
					} else if (data.rslt.obj.attr('node_type') == 'dept') {
						$('.inner-center .pane-header').text('부서 결재자 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
						loadDecodingApprobatorInfo(data.rslt.obj.attr('companyid'), data.rslt.obj.attr('deptcode'), '');
					} else if (data.rslt.obj.attr("node_type") == "user") {
						$('.inner-center .pane-header').text('사용자 결재자 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
						loadDecodingApprobatorInfo(data.rslt.obj.attr('companyid'), data.rslt.obj.attr('deptcode'), data.rslt.obj.attr('userid'));
					}
					if (g_oldSelectedTreeNode == null) {
						loadTargetUsersTreeView(data.rslt.obj.attr('companyid'));
					} else {
						if (g_oldSelectedTreeNode.attr('companyid') != data.rslt.obj.attr('companyid') ) {
							loadTargetUsersTreeView(data.rslt.obj.attr('companyid'));
						}
					}
					data.inst.set_text(g_objDecodingApprobatorTree.find('ul > li:first') , "[" + data.inst.get_text(data.rslt.obj) + "]");
					$('button[name="btnSave"]').show();
					g_objMainContent.show();
					$('.inner-center .ui-layout-content').unblock();
				} else {
					$('.inner-center .pane-header').text('결재자 설정');
					$('button[name="btnSave"]').hide();
					g_objMainContent.hide();
					$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><span style="position:relative; bottom: -1px;line-height: 20px;">결재자 설정을 위한 대상을 선택해 주세요.</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '360px', 'width': '50%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
		});
	};

	function expandChilds(node) {
		var objTreeReference = $.jstree._reference(g_objOrganizationTree);
		objTreeReference._get_children(node).each( function() {
			if (objTreeReference.is_checked($(this))) {
				if (!objTreeReference.is_open($(this))) {
					objTreeReference.open_node($(this));
				}
			}
		});
	};

	loadTargetUsersTreeView = function(companyId) {

		var xmlTreeData = loadCompanyNode(companyId);

		g_objTargetUsersTree.jstree({
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
							displayAlertDialog("결재자 대상 구성도 조회", "결재자 대상 구성도 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("결재자 대상 구성도 조회", "결재자 대상 구성도 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			"crrm" : {
				"move" : {
					"check_move" : function (data) {
						return false;
					}
				}
			},
			"dnd" : {
				"is_draggable" : function(data) {
				},
				"drag_check" : function(data) {
				},
				"drop_check" : function (data) {
				},
				"drop_finish" : function (data) {
				}
			},
			"contextmenu" : {
				"items" : null
			},
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "dnd", "crrm", "contextmenu" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
		}).bind('hover_node.jstree', function (event, data) {
			if (data.rslt.obj.attr('node_type') != "user") {
				data.inst.dehover_node(data.rslt.obj)
			}
		}).bind('select_node.jstree', function (event, data) {
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
		});
	};

	loadDecodingApprobatorTreeView = function() {

		var approbatorNodeXml = "";
		approbatorNodeXml += "<item id='priority_1' parent_id='root' priority='1' node_type='priority'>";
		approbatorNodeXml += "<content><name>1 순위 결재자</name></content>";
		approbatorNodeXml += "</item>";
		approbatorNodeXml += "<item id='main_1' parent_id='priority_1' priority='1' node_type='main-approbator'>";
		approbatorNodeXml += "<content><name>주 결재자</name></content>";
		approbatorNodeXml += "</item>";
		approbatorNodeXml += "<item id='substitute_1' parent_id='priority_1' priority='1' node_type='substitute-approbator'>";
		approbatorNodeXml += "<content><name>대체 결재자</name></content>";
		approbatorNodeXml += "</item>";

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root'>";
		xmlTreeData += "<content><name>순위별 결재자</name></content>";
		xmlTreeData += "</item>";
		xmlTreeData += approbatorNodeXml;
		xmlTreeData += "</root>";

		g_objDecodingApprobatorTree.jstree({
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
				}
			},
			"crrm" : {
				"move" : {
					"always_copy": "multitree",
					"default_position": "inside",
					"check_move" : function (data) {
						/*
						requires crrm plugin

						.o - the node being moved
						.r - the reference node in the move
						.ot - the origin tree instance
						.rt - the reference tree instance
						.p - the position to move to (may be a string - "last", "first", etc)
						.cp - the calculated position to move to (always a number)
						.np - the new parent
						.oc - the original node (if there was a copy)
						.cy - boolen indicating if the move was a copy
						.cr - same as np, but if a root node is created this is -1
						.op - the former parent
						.or - the node that was previously in the position of the moved node */

						// 결재자는 서브노드로만 이동 가능
						if (data.p != "inside") {
							return false;
						}

						// 결재자는 "주 결재자" 노드와 "대체 결재자" 노드로만 이동 가능
						if ((data.r.attr('node_type') != "main-approbator") && (data.r.attr('node_type') != "substitute-approbator")) {
							return false;
						}

						// 사용자 노드만 이동 가능
						if (data.o.attr("node_type") != "user") {
							return false
						}

						// "주 결재자" 노드에는 1명만 등록 가능
						if ((data.r.attr('node_type') == "main-approbator") && data.rt._get_children(data.np).length > 0) {
							return false;
						}

						// 결재자 tree 내에서 이동 불가
						if (data.rt == data.ot) {
							return false;
						}

						var is_valid = true;

						// 다른 tree 에서 drag&drop 할 경우 중복 검사
						if (data.rt != data.ot) {
							var treeContainer = data.rt.get_container();
							treeContainer.find("li").each( function() {
								if ($(this).attr('node_type') == "user") {
									if (($(this).attr('companyid') == data.o.attr("companyid")) &&
										($(this).attr('deptcode') == data.o.attr("deptcode")) &&
										($(this).attr('userid') == data.o.attr("userid"))) {
										is_valid = false;
										return false;
									}
								}
							});
						}
						if (!is_valid) return false;

						// "주 결재자" 가 등록 되어야만 "대체 결재자" 등록 가능
						if (data.r.attr('node_type') == "substitute-approbator") {
							var priorityNode = data.rt._get_parent(data.r);
							data.rt._get_children(priorityNode).each( function() {
								if ($(this).attr("node_type") == "main-approbator") {
									if (data.rt._get_children($(this)).length == 0) {
										is_valid = false;
										return false;
									}
								}
							});
						}
						if (!is_valid) return false;

						// 상위의 "주 결재자" 가 모두 등록되어있어야만 등록 가능
						var currentPriority = data.rt._get_parent(data.r).attr("priority");
						data.rt.get_container().find('li').each( function() {
							if (parseInt($(this).attr("priority")) < parseInt(currentPriority)) {
								data.rt._get_children($(this)).each( function() {
									if ($(this).attr("node_type") == "main-approbator") {
										if (data.rt._get_children($(this)).length == 0) {
											is_valid = false;
											return false;
										}
									}
								});
							}
						});
						if (!is_valid) return false;

						return true;
					}
				}
			},
			"dnd" : {
				"drag_check" : function (data) {
				},
				"drag_finish" : function (data) {
				}
			},
			"contextmenu" : {
				"items" : decodingApprobatorTreeContextMenu
			},
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "dnd", "crrm", "contextmenu" ]
		}).bind('loaded.jstree', function (event, data) {
<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
			data.inst.get_container().mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
		}).bind('hover_node.jstree', function (event, data) {
			if (data.rslt.obj.attr('node_type') != "user") {
				data.inst.dehover_node(data.rslt.obj)
			}
		}).bind('select_node.jstree', function (event, data) {
			if (!data.inst.is_open(data.rslt.obj)) {
				data.inst.open_node(data.rslt.obj);
			}
			if (data.rslt.obj.attr('node_type') == "user") {
				if ((data.inst._get_parent(data.rslt.obj).attr("node_type") == "main-approbator") &&
						(data.inst._get_children(data.inst._get_parent(data.rslt.obj).siblings()).length > 0)) { // 주 결재자 삭제시 대체 결제자가 있는 경우
					$('button[name="btnDeleteApprobator"]').hide();
				} else {
					$('button[name="btnDeleteApprobator"]').show();
				}
			} else {
				$('button[name="btnDeleteApprobator"]').hide();
			}
		});
	};

	function decodingApprobatorTreeContextMenu(node) {

		var items = {
			"deleteItem": {
				"label" : "결재자 삭제",
				"action" : function () {
					displayConfirmDialog("결재자 삭제", "결재자를 삭제하시겠습니까?", "", function() { deleteApprobatorNode($(node)); } );
				}
			}
		};

		if (($(node).attr('node_type') == "priority") || ($(node).attr('node_type') == "main-approbator") || ($(node).attr('node_type') == "substitute-approbator")) {
			delete items.deleteItem;
		}

		return items;
	};

	loadDecodingApprobatorInfo = function(companyId, deptCode, userId) {

		var postData = "";

		if (userId.length > 0) {
			postData = getRequestUserDecodingApprobatorInfoParam(companyId, deptCode, userId);
		} else if (deptCode.length > 0) {
			postData = getRequestDeptDecodingApprobatorInfoParam(companyId, deptCode);
		} else if (companyId.length > 0) {
			postData = getRequestCompanyDecodingApprobatorInfoParam(companyId);
		}

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			//async: false,
			beforeSend: function() {
				g_objDecodingApprobatorTree.block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				g_objDecodingApprobatorTree.unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("결재자 설정 정보 조회", "결재자 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					var treeReference = $.jstree._reference(g_objDecodingApprobatorTree);
					treeReference.get_container().find('li').each( function(index, node) {
						if ($(this).attr("node_type") == "priority") {
							treeReference.remove($(this));
						}
					});
					var maxPriority = 1;
					$(data).find('record').each( function() {
						if (maxPriority < parseInt($(this).find('approbatorpriority').text())) {
							maxPriority = parseInt($(this).find('approbatorpriority').text());
						}
					});
					for (var i=0; i<maxPriority; i++) {
						addPriorityNode();
					}
					$(data).find('record').each( function() {
						addApprobatorNode($(this).find('approbatorcompanyid').text(),
								$(this).find('approbatordeptcode').text(),
								$(this).find('approbatoruserid').text(),
								$(this).find('approbatorusername').text(),
								$(this).find('approbatorpriority').text(),
								$(this).find('approbatortype').text());
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("결재자 설정 정보 조회", "결재자 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveDecodingApprobator = function(bSaveCompanySetup, bSaveDeptSetup, bSaveUserSetup) {

		var arrApprobatorList = new Array();

		var priority = "";
		var treeReference = $.jstree._reference(g_objDecodingApprobatorTree);
		treeReference.get_container().find('li').each( function(index, node) {
			if ($(this).attr("node_type") == "priority") {
				priority = $(this).attr("priority");
				treeReference._get_children($(this)).each( function() {
					if ($(this).attr("node_type") == "main-approbator") {
						treeReference._get_children($(this)).each( function() {
							if ($(this).attr("node_type") == "user") {
								var arrApprobator = new Array();
								arrApprobator.push($(this).attr('companyid'));
								arrApprobator.push($(this).attr('deptcode'));
								arrApprobator.push($(this).attr('userid'));
								arrApprobator.push(priority);
								arrApprobator.push("<%=DecodingApprobatorType.DECODING_APPROBATOR_TYPE_MAIN%>");
								arrApprobatorList.push(arrApprobator);
							}
						});
					} else if ($(this).attr("node_type") == "substitute-approbator") {
						treeReference._get_children($(this)).each( function() {
							if ($(this).attr("node_type") == "user") {
								var arrApprobator = new Array();
								arrApprobator.push($(this).attr('companyid'));
								arrApprobator.push($(this).attr('deptcode'));
								arrApprobator.push($(this).attr('userid'));
								arrApprobator.push(priority);
								arrApprobator.push("<%=DecodingApprobatorType.DECODING_APPROBATOR_TYPE_SUBSTITUTE%>");
								arrApprobatorList.push(arrApprobator);
							}
						});
					}
				});
			}
		});

// 		var targetCompanyId = $.jstree._reference(g_objTargetUsersTree)._get_node('ul > li:first').attr('id');

		if (bSaveCompanySetup) {
			var arrCompanyList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
				if ($(node).attr('node_type') == "company") {
// 					if ($(node).attr('companyid') == targetCompanyId) {
						arrCompanyList.push($(this).attr('companyid'));
// 					} else {
// 						$.jstree._reference(g_objOrganizationTree).uncheck_node($(this));
// 					}
	 			}
			});

			var postData = getRequestSaveCompanyDecodingApprobatorParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrCompanyList,
					arrApprobatorList);

			if (!saveProcess("사업장 결재자 설정 정보 저장", postData)) {
				return false;
			}
		}

		if (bSaveDeptSetup) {
			var arrDeptList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
// 				if ($(node).attr('companyid') == targetCompanyId) {
					var arrDept = new Array();
					if ($(node).attr('node_type') == "dept") {
						arrDept.push($(this).attr('companyid'));
						arrDept.push($(this).attr('deptcode'));
						arrDeptList.push(arrDept);
		 			}
// 				} else {
// 					$.jstree._reference(g_objOrganizationTree).uncheck_node($(this));
// 				}
			});

			var postData = getRequestSaveDeptDecodingApprobatorParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrDeptList,
					arrApprobatorList);

			if (!saveProcess("부서 결재자 설정 정보 저장", postData)) {
				return false;
			}
		}

		if (bSaveUserSetup) {
			var arrUserList = new Array();
			g_objOrganizationTree.find(".jstree-checked").each( function(i, node) {
// 				if ($(node).attr('companyid') == targetCompanyId) {
					var arrUser = new Array();
					if ($(node).attr('node_type') == "user") {
						arrUser.push($(this).attr('companyid'));
						arrUser.push($(this).attr('deptcode'));
						arrUser.push($(this).attr('userid'));
						arrUserList.push(arrUser);
		 			}
// 				} else {
// 					$.jstree._reference(g_objOrganizationTree).uncheck_node($(this));
// 				}
			});

			var postData = getRequestSaveUserDecodingApprobatorParam('<%=(String)session.getAttribute("ADMINID")%>',
					arrUserList,
					arrApprobatorList);

			if (!saveProcess("사용자 결재자 설정 정보 저장", postData)) {
				return false;
			}
		}

		displayInfoDialog("결재자 설정 정보 저장", "정상 처리되었습니다.", "정상적으로 결재자 설정 정보가 저장되었습니다.");
	};

	saveProcess = function(saveTarget, postData) {

		var bResult = false;

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			beforeSend: function() {
				$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><img src="/images/processing.gif" width="16" height="16" style="vertical-align: middle;" /> <span style="position:relative; bottom: -1px;line-height: 20px;">처리중...</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '180px', 'width': '25%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
			},
			complete: function(jqXHR, textStatus) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog(saveTarget + " 저장", saveTarget + " 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					bResult = true;
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog(saveTarget + " 저장", saveTarget + " 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return bResult;
	};

	addPriorityNode = function() {

		var treeReference = $.jstree._reference(g_objDecodingApprobatorTree);
		var maxPriority = 0;

		treeReference.get_container().find('li').each( function(index, node) {
			if ($(this).attr("node_type") == "priority") {
				if (parseInt($(this).attr("priority")) > maxPriority) {
					maxPriority = parseInt($(this).attr("priority"));
				}
			}
		});

		var newPriorityNode = { attr: { id: "priority_" + (maxPriority+1), priority: (maxPriority+1), node_type: "priority" }, state: "open", data: (maxPriority+1) + " 순위 결재자" };
		if (maxPriority == 0) {
			treeReference.create('#root', "inside", newPriorityNode, false, true);
		} else {
			treeReference.create("#priority_" + maxPriority, "after", newPriorityNode, false, true);
		}

		var newMainApprobatorNode = { attr: { id: "main_" + (maxPriority+1), priority: (maxPriority+1), node_type: "main-approbator" }, data: "주 결재자" };
		treeReference.create("#priority_" + (maxPriority+1), "first", newMainApprobatorNode, false, true);

		var newSubstituteApprobatorNode = { attr: { id: "substitute_" + (maxPriority+1), priority: (maxPriority+1), node_type: "substitute-approbator" }, data: "대체 결재자" };
		treeReference.create("#priority_" + (maxPriority+1), "last", newSubstituteApprobatorNode, false, true);
	};

	addApprobatorNode = function(approbatorCompanyId, approbatorDeptCode, approbatorUserId, approbatorUserName, approbatorPriority, approbatortype) {

		var treeReference = $.jstree._reference(g_objDecodingApprobatorTree);

		var newNode = { attr: { id: approbatorCompanyId + "_" + approbatorDeptCode + "_" + approbatorUserId, companyid: approbatorCompanyId, deptcode: approbatorDeptCode, userid: approbatorUserId, node_type: "user" }, data: approbatorUserName };
		if (approbatortype == "<%=DecodingApprobatorType.DECODING_APPROBATOR_TYPE_MAIN%>") {
			treeReference.create("#main_" + approbatorPriority, "last", newNode, false, true);
		} else {
			treeReference.create("#substitute_" + approbatorPriority, "last", newNode, false, true);
		}
	};

	deleteApprobatorNode = function(node) {

		var treeReference = $.jstree._reference(g_objDecodingApprobatorTree);

		if (treeReference._get_parent(node).attr("node_type") == "main-approbator") { // 주 결재자 삭제시
			var nodePriority = treeReference._get_parent(node).attr("priority");

			var is_valid = true;
			// 하위 순위에 주 결재자가 있는 경우 삭제 불가
			treeReference.get_container().find('li').each( function(index, node) {
				if (parseInt($(this).attr("priority")) > parseInt(nodePriority)) {
					if (treeReference._get_children("#main_" + $(this).attr("priority")).length > 0) {
						displayAlertDialog("결재자 삭제 ", "결재자를 삭제할 수 없습니다.",
								"하위 순위 결재자가 있는 경우, \"주 결재자\"를 삭제할 수 없습니다.<br />하위 순위 결재자들을 삭제한 후 \"주 결재자\"를 삭제해 주십시오.");
						is_valid = false;
						return false;
					}
				}
			});
			if (!is_valid) return false;

			// 돋일 순위 대체 결재자가 있는 경우 삭제 불가
			if (treeReference._get_children("#substitute_" + nodePriority).length > 0) {
				displayAlertDialog("결재자 삭제 ", "결재자를 삭제할 수 없습니다.",
						"돋일 순위에 \"대체 결재자\"가 있는 경우, \"주 결재자\"를 삭제할 수 없습니다.<br />동일 순위 \"대체 결재자\"를 삭제한 후 \"주 결재자\"를 삭제해 주십시오.");
				return false;
			}
		}

		$.jstree._reference(g_objDecodingApprobatorTree).remove(node);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">조직 구성도</div>
	<div class="ui-layout-content zero-padding">
		<div id="organization-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">결재자 설정</div>
	<div class="ui-layout-content" style="padding: 20px;">
		<div id="main-content">
			<div style="float: left; width: 55%">
				<div>
					<div class="category-title">결재자 설정 목록</div>
					<div id="decoding-approbator" class="droppable category-contents zero-padding">
						<div id="decoding-approbator-tree" class="treeview-pannel"></div>
					</div>
					<div class="button-line" style="margin-top: 4px;">
						<button type="button" id="btnAddPriority" name="btnAddPriority" class="normal-button">결재 순위 추가</button>
						<button type="button" id="btnDeleteApprobator" name="btnDeleteApprobator" class="normal-button">선택 결재자 삭제</button>
					</div>
				</div>
			</div>
			<div style="margin-left: 56%;">
				<div>
					<div class="category-title">결재자 대상 목록</div>
					<div id="target-users" class="draggable category-contents zero-padding">
						<div id="target-users-tree" class="treeview-pannel"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnSave" name="btnSave" class="normal-button" style="display: none;">설정 저장</button>
		</div>
	</div>
</div>
