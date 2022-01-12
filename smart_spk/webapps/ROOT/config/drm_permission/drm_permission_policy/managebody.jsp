<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objMainContent;
	var g_objDrmPermissionPolicyTree;
	var g_objTargetUsersTree;
	var g_objDrmPermissionPolicy;

	var g_htDeptList = new Hashtable();

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objMainContent = $('#main-content');
		g_objDrmPermissionPolicyTree = $('#drm-permission-policy-tree');
		g_objTargetUsersTree = $('#target-users-tree');
		g_objDrmPermissionPolicy = $('#drm-permission-policy');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnNew"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnSave"]').button({ icons: {primary: "ui-icon-disk"} });
		$('button[name="btnDelete"]').button({ icons: {primary: "ui-icon-trash"} });
		$('button[name="btnAddUserToList"]').button({ icons: {primary: "ui-icon-arrowthickstop-1-w"} });
		$('button[name="btnRemoveUserFromList"]').button({ icons: {primary: "ui-icon-arrowthickstop-1-e"} });

		$('#dialog:ui-dialog').dialog('destroy');

		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
		g_objDrmPermissionPolicy.mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

		g_objDrmPermissionPolicy.find('input[name="expirationdate"]').datepicker({
			showAnim: "slideDown"
		}).datepicker("setDate", new Date());

		g_objDrmPermissionPolicy.find('input[name="readlimitcount"]').autoNumeric('init', {aSep: ',', mDec: "0", vMin:'0', vMax: "999999"});

		innerDefaultLayout.show("west");
		loadDrmPermissionPolicyTreeView('');
<% if (!AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		g_htDeptList = loadDeptList('<%=(String)session.getAttribute("COMPANYID")%>');
		loadTargetUsersTreeView('<%=(String)session.getAttribute("COMPANYID")%>');
<% } %>

		$('button').click( function () {
			if ($(this).attr('id') == 'btnNew') {
				newDrmPermissionPolicy();
			} else if ($(this).attr('id') == 'btnSave') {
				if (validateDrmPermissionPolicyData()) {
					displayConfirmDialog("설정 저장", "설정 정보를 저장 하시겠습니까?", "", function() { saveDrmPermissionPolicy(); });
				}
			} else if ($(this).attr('id') == 'btnDelete') {
				displayConfirmDialog("정책 삭제", "정책을 삭제하시겠습니까?", "", function() { deleteDrmPermissionPolicy(); });
			} else if ($(this).attr('id') == 'btnAddUserToList') {
				addUserToList();
			} else if ($(this).attr('id') == 'btnRemoveUserFromList') {
				removeUserFromList();
			}
		});

		$('input[type="radio"]').change( function(event) {
			if ($(this).filter(':checked').val() == '<%=OptionType.OPTION_TYPE_YES%>') {
				$(this).closest('.radio-branch').siblings().each( function() {
					$(this).show();
				});
			} else {
				$(this).closest('.radio-branch').siblings().each( function() {
					$(this).hide();
				});
			}
		});

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
		$(document).on("click", ".list-table thead tr th", function (e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } var checkState = $(this).find('input:checkbox').is(':checked'); $(this).closest('table').find('tbody td:nth-child(' + ($(this).index() + 1) + ') input:checkbox').each( function () { $(this).prop('checked', checkState); }); });	
		$(document).on("click", ".list-table tbody tr td", function(e) { if (!$(e.target).is(':checkbox')) { $(this).find('input:checkbox').prop('checked', !$(this).find('input:checkbox').is(':checked')); } if ($(this).find('input:checkbox').is(':checked')) { if ($(this).closest('tbody').find('tr').length == $(this).closest('tbody').find('td:nth-child(' + ($(this).index() + 1) + ') input:checkbox').filter(':checked').length) { $(this).closest('table').find('thead th:nth-child(' + ($(this).index() + 1) + ') input:checkbox').prop('checked', true); } } else { $(this).closest('table').find('thead th:nth-child(' + ($(this).index() + 1) + ') input:checkbox').prop('checked', false); }; });
	});

	loadDeptList = function(companyId) {

		var g_htList = new Hashtable();
		var postData = getRequestDeptListParam(companyId, '', 'DEPTNAME', 'ASC', '', '');

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("부서 목록 조회", "부서 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				} else {
					if (!g_htList.isEmpty()) g_htList.clear();
					$(data).find('record').each( function() {
						g_htList.put($(this).find('deptcode').text(), $(this).find('deptname').text());
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("부서 목록 조회", "부서 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});

		return g_htList;
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

	loadDrmPermissionPolicyTreeView = function(selectedCompanyId) {

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

		g_objDrmPermissionPolicyTree.jstree({
			"xml_data" : {
				"data" : xmlTreeData,
				"ajax": {
					"type": 'POST',
					"url": "/CommandService",
					"data": function (node) {
						if (!$.isEmptyObject(node)) {
							if (node.attr("node_type") == 'company_category') {
								var categoryCode = node.children('a').text().trim();
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_DRM_PERMISSION_POLICY%>', categoryCode, '');
								return {
									sendmsg : postData
								};
							} else if (node.attr("node_type") == 'company') {
								var postData = getRequestDrmPermissionPolicyTreeNodesParam(node.attr('companyid'));
								return {
									sendmsg : postData
								};
							} else {
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
								var postData = getRequestCompanyTreeNodesParam('<%=TreeViewType.TREE_VIEW_TYPE_DRM_PERMISSION_POLICY%>', '', '');
<% } else { %>
								var postData = getRequestDrmPermissionPolicyTreeNodesParam('<%=(String)session.getAttribute("COMPANYID")%>');
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
							displayAlertDialog("문서보안 권한 정책 트리 목록 조회", "문서보안 권한 정책 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("문서보안 권한 정책 트리 목록 조회", "문서보안 권한 정책 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			if (selectedCompanyId.length == 0) {
				setTimeout(function() { data.inst.select_node('ul > li:first'); }, 100);
			} else {
				data.inst.select_node('ul > li:first');
				data.inst.deselect_node(data.inst.get_selected());
				if (data.inst._get_node('#cid_' + selectedCompanyId).length) {
					setTimeout(function() { data.inst.select_node('#cid_' + selectedCompanyId); }, 100);
				}
			}
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
				if ((g_oldSelectedTreeNode != null) && (data.rslt.obj.attr('companyid') != g_oldSelectedTreeNode.attr('companyid'))) {
					if (typeof data.rslt.obj.attr('companyid') != typeof undefined) {
						g_htDeptList = loadDeptList(data.rslt.obj.attr('companyid'));
						loadTargetUsersTreeView(data.rslt.obj.attr('companyid'));
					}
				}
				if (data.rslt.obj.attr('node_type') == "company") {
					$('.inner-center .pane-header').text('문서보안 권한 정책 설정');
					g_objMainContent.hide();
					$('button[name="btnSave"]').hide();
					$('button[name="btnNew"]').show();
					$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><span style="position:relative; bottom: -1px;line-height: 20px;">설정을 위한 문서보안 권한 정책을 선택해 주세요.</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '360px', 'width': '50%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
				} else if (data.rslt.obj.attr('node_type') == "policy") {
					$('.inner-center .pane-header').text('문서보안 권한 정책 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
					g_objMainContent.show();
					$('button[name="btnSave"]').show();
					$('button[name="btnNew"]').show();
					$('.inner-center .ui-layout-content').unblock();
					loadDrmPermissionPolicyInfo();
				} else {
					$('.inner-center .pane-header').text('문서보안 권한 정책 설정');
					g_objMainContent.hide();
					$('button[name="btnSave"]').hide();
					$('button[name="btnNew"]').hide();
					$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><span style="position:relative; bottom: -1px;line-height: 20px;">설정을 위한 문서보안 권한 정책을 선택해 주세요.</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '360px', 'width': '50%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
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
							displayAlertDialog("소속 사용자 트리 목록 조회", "소속 사용자 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("소속 사용자 트리 목록 조회", "소속 사용자 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
			"plugins" : [ "themes", "xml_data", "ui", "Select", "types", "crrm", "contextmenu", "checkbox" ]
		}).bind('loaded.jstree', function (event, data) {
			data.inst.get_container().mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
			$('button[name="btnAddUserToList"]').button("option", "disabled", true);
		}).bind('load_node.jstree', function (event, data) {
			data.inst.open_all(-1); // -1 opens all nodes in the container
		}).bind('check_node.jstree', function (event, data) {
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToList"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToList"]').button("option", "disabled", false);
			}
		}).bind('uncheck_node.jstree', function (event, data) {
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToList"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToList"]').button("option", "disabled", false);
			}
		}).bind('select_node.jstree', function (event, data) {
			if (!data.inst.is_checked(data.rslt.obj)) {
				data.inst.check_node(data.rslt.obj);
			} else {
				data.inst.uncheck_node(data.rslt.obj);
			}
			if (data.inst.get_container().find(".jstree-checked").length == 0) {
				$('button[name="btnAddUserToList"]').button("option", "disabled", true);
			} else {
				$('button[name="btnAddUserToList"]').button("option", "disabled", false);
			}
		});
	};

	newDrmPermissionPolicy = function() {

		var objPolicyId = g_objDrmPermissionPolicy.find('input[name="policyid"]');
		var objPolicyName = g_objDrmPermissionPolicy.find('input[name="policyname"]');
		var objReadPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="readpermission"]');
		var objWritePermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="writepermission"]');
		var objPrintPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="printpermission"]');
		var objExpirationDateSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="expirationdatesetupflag"]');
		var objExpirationDate = g_objDrmPermissionPolicy.find('input[name="expirationdate"]');
		var objReadLimitCountSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="readlimitcountsetupflag"]');
		var objReadLimitCount = g_objDrmPermissionPolicy.find('input[name="readlimitcount"]');

		var objRowPolicyId = g_objDrmPermissionPolicy.find('#row-policyid');
		var objRowExpirationDate = g_objDrmPermissionPolicy.find('#row-expirationdate');
		var objRowReadLimitCount = g_objDrmPermissionPolicy.find('#row-readlimitcount');

		objPolicyId.val('');
		objRowPolicyId.hide();
		objPolicyName.val('');
		objPolicyName.attr('readonly', false);
		objPolicyName.removeClass('ui-priority-secondary');
		objPolicyName.tooltip({ disabled: false });
		objReadPermission.prop('checked', false);
		objReadPermission.filter('[value=<%=OptionType.OPTION_TYPE_YES%>]').prop('checked', true);
		objWritePermission.prop('checked', false);
		objWritePermission.filter('[value=<%=OptionType.OPTION_TYPE_YES%>]').prop('checked', true);
		objPrintPermission.prop('checked', false);
		objPrintPermission.filter('[value=<%=OptionType.OPTION_TYPE_YES%>]').prop('checked', true);
		objExpirationDateSetupFlag.prop('checked', false);
		objExpirationDateSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_NO%>]').prop('checked', true);
		objExpirationDate.val('');
		objRowExpirationDate.hide();
		objReadLimitCountSetupFlag.prop('checked', false);
		objReadLimitCountSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_NO%>]').prop('checked', true);
		objReadLimitCount.val('');
		objRowReadLimitCount.hide();

		g_objDrmPermissionPolicy.find('.list-table thead').find('input:checkbox').filter(':checked').each( function (index, item) {
			 $(item).prop('checked', false);
		});
		g_objDrmPermissionPolicy.find('.list-table tbody').html('');

		g_objMainContent.show();
		$('button[name="btnSave"]').show();
		$('button[name="btnNew"]').hide();
		$('button[name="btnDelete"]').hide();
		$('.inner-center .ui-layout-content').unblock();
		reloadDefaultLayout();
	};

	loadDrmPermissionPolicyInfo = function() {

		var objPolicyId = g_objDrmPermissionPolicy.find('input[name="policyid"]');
		var objPolicyName = g_objDrmPermissionPolicy.find('input[name="policyname"]');
		var objReadPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="readpermission"]');
		var objWritePermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="writepermission"]');
		var objPrintPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="printpermission"]');
		var objExpirationDateSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="expirationdatesetupflag"]');
		var objExpirationDate = g_objDrmPermissionPolicy.find('input[name="expirationdate"]');
		var objReadLimitCountSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="readlimitcountsetupflag"]');
		var objReadLimitCount = g_objDrmPermissionPolicy.find('input[name="readlimitcount"]');

		var objRowPolicyId = g_objDrmPermissionPolicy.find('#row-policyid');
		var objRowExpirationDate = g_objDrmPermissionPolicy.find('#row-expirationdate');
		var objRowReadLimitCount = g_objDrmPermissionPolicy.find('#row-readlimitcount');

		var objTreeReference = $.jstree._reference(g_objDrmPermissionPolicyTree);
		var selectedCompanyId = "";
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			selectedCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var selectedPolicyId = "";
		if (typeof objTreeReference.get_selected().attr('policyid') != typeof undefined) {
			selectedPolicyId = objTreeReference.get_selected().attr('policyid');
		}

		var postData = getRequestDrmPermissionPolicyInfoParam(selectedCompanyId, selectedPolicyId);

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
			complete: function(jqXHR, textStatus ) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("문서보안 권한 정책 설정 정보 조회", "문서보안 권한 정책 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				g_objDrmPermissionPolicy.find('.list-table thead').find('input:checkbox').filter(':checked').each( function (index, item) {
					 $(item).prop('checked', false);
				});
				g_objDrmPermissionPolicy.find('.list-table tbody').html('');

				var policyName = $(data).find('policyname').text();
				var readPermission = $(data).find('readpermission').text();
				var writePermission = $(data).find('writepermission').text();
				var printPermission = $(data).find('printpermission').text();
				var expirationDate = $(data).find('expirationdate').text();
				var readLimitCount = $(data).find('readlimitcount').text();
				var appliedCount = $(data).find('appliedcount').text();

				objPolicyId.val(selectedPolicyId);
				objRowPolicyId.show();
				objPolicyName.val(policyName);
				if (parseInt(appliedCount) > 0) {
					objPolicyName.attr('readonly', true);
					objPolicyName.blur();
					objPolicyName.addClass('ui-priority-secondary');
					objPolicyName.tooltip({ disabled: true });
					$('button[name="btnDelete"]').hide();
				} else {
					objPolicyName.attr('readonly', false);
					objPolicyName.removeClass('ui-priority-secondary');
					objPolicyName.tooltip({ disabled: false });
					$('button[name="btnDelete"]').show();
				}
				objReadPermission.prop('checked', false);
				objReadPermission.filter('[value=' + readPermission + ']').prop('checked', true);
				objWritePermission.prop('checked', false);
				objWritePermission.filter('[value=' + writePermission + ']').prop('checked', true);
				objPrintPermission.prop('checked', false);
				objPrintPermission.filter('[value=' + printPermission + ']').prop('checked', true);
				objExpirationDateSetupFlag.prop('checked', false);
				if (expirationDate == '2999-12-31') {
					objExpirationDateSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_NO%>]').prop('checked', true);
					objExpirationDate.val('');
					objRowExpirationDate.hide();
				} else {
					objExpirationDateSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_YES%>]').prop('checked', true);
					objExpirationDate.val(expirationDate);
					objRowExpirationDate.show();
				}
				objReadLimitCountSetupFlag.prop('checked', false);
				if (readLimitCount == '0') {
					objReadLimitCountSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_NO%>]').prop('checked', true);
					objReadLimitCount.val('');
					objRowReadLimitCount.hide();
				} else {
					objReadLimitCountSetupFlag.filter('[value=<%=OptionType.OPTION_TYPE_YES%>]').prop('checked', true);
					objReadLimitCount.val(readLimitCount);
					objRowReadLimitCount.show();
				}

				var newRow = '';
				if ($(data).find('user').length > 0) {
					$(data).find('user').each(function(index, item) {
						var deptCode = $(item).find("deptcode").text();
						var deptName = $(item).find("deptname").text();
						var userId = $(item).find("userid").text();
						var userName = $(item).find("username").text();

						newRow += '<tr>';
						newRow += '<td><input type="checkbox" name="selectuser" companyid="' + selectedCompanyId + '" deptcode="' + deptCode + '" userid="' + userId + '" style="border: 0;"></td>';
						newRow += '<td>' + deptName + '</td>';
						newRow += '<td>' + userId + '</td>';
						newRow += '<td>' + userName + '</td>';
						newRow += '</tr>';
					});
				} else {
					newRow = '<td colspan="3" align="center"><div style="padding: 10px 0; text-align: center;">등록된 정책 소속 사용자 정보가 존재하지 않습니다.</div></td>';
				}
				g_objDrmPermissionPolicy.find('.list-table tbody').append(newRow);
				reloadDefaultLayout();
				g_objDrmPermissionPolicy.mCustomScrollbar('update');
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("문서보안 권한 정책 설정 정보 조회", "문서보안 권한 정책 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveDrmPermissionPolicy = function() {

		var objPolicyId = g_objDrmPermissionPolicy.find('input[name="policyid"]');
		var objPolicyName = g_objDrmPermissionPolicy.find('input[name="policyname"]');
		var objReadPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="readpermission"]');
		var objWritePermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="writepermission"]');
		var objPrintPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="printpermission"]');
		var objExpirationDateSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="expirationdatesetupflag"]');
		var objExpirationDate = g_objDrmPermissionPolicy.find('input[name="expirationdate"]');
		var objReadLimitCountSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="readlimitcountsetupflag"]');
		var objReadLimitCount = g_objDrmPermissionPolicy.find('input[name="readlimitcount"]');

		var objTreeReference = $.jstree._reference(g_objDrmPermissionPolicyTree);
		var selectedCompanyId = "";
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			selectedCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var expirationDate = "";
		if (objExpirationDateSetupFlag.filter(':checked').val() == '0') {
			expirationDate = '2999-12-31';
		} else {
			expirationDate = objExpirationDate.val();
		}

		var readLimitCount = "";
		if (objReadLimitCountSetupFlag.filter(':checked').val() == '0') {
			readLimitCount = '0';
		} else {
			readLimitCount = objReadLimitCount.val().replace(/,/g, '');
		}

		var arrUserList = new Array();
		g_objDrmPermissionPolicy.find('.list-table tbody tr').each(function (index, item) {
			var htUserInfo = new Hashtable();
			htUserInfo.put('deptcode', $(item).find('td:first-child input:checkbox').attr('deptcode'));
			htUserInfo.put('userid', $(item).find('td:first-child input:checkbox').attr('userid'));
			arrUserList.push(htUserInfo);
		});

		var postData = getRequestSaveDrmPermissionPolicyParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				selectedCompanyId,
				objPolicyId.val(),
				objPolicyName.val(),
				objReadPermission.filter(':checked').val(),
				objWritePermission.filter(':checked').val(),
				objPrintPermission.filter(':checked').val(),
				expirationDate,
				readLimitCount,
				arrUserList);

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
			complete: function(jqXHR, textStatus ) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("문서보안 권한 정책 설정 정보 저장", "문서보안 권한 정책 설정 정보 저장 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadDrmPermissionPolicyTreeView(selectedCompanyId);
					displayInfoDialog("문서보안 권한 정책 설정 정보 저장", "정상 처리되었습니다.", "문서보안 권한 정책 설정 정보가 저장되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("문서보안 권한 정책 설정 정보 저장", "문서보안 권한 정책 설정 정보 저장 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	deleteDrmPermissionPolicy = function() {

		var objTreeReference = $.jstree._reference(g_objDrmPermissionPolicyTree);
		var selectedCompanyId = "";
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			selectedCompanyId = objTreeReference.get_selected().attr('companyid');
		}

		var postData = getRequestDeleteDrmPermissionPolicyParam(
				'<%=(String)session.getAttribute("ADMINID")%>',
				selectedCompanyId,
				g_objDrmPermissionPolicy.find('input[name="policyid"]').val());

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
			complete: function(jqXHR, textStatus ) {
				$('.inner-center .ui-layout-content').unblock();
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("문서보안 권한 정책 설정 정보 삭제", "문서보안 권한 정책 설정 정보 삭제 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					loadDrmPermissionPolicyTreeView(selectedCompanyId);
					displayInfoDialog("문서보안 권한 정책 설정 정보 삭제", "정상 처리되었습니다.", "문서보안 권한 정책 설정 정보가 삭제되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("문서보안 권한 정책 설정 정보 삭제", "문서보안 권한 정책 설정 정보 삭제 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	validateDrmPermissionPolicyData = function() {

		var objPolicyName = g_objDrmPermissionPolicy.find('input[name="policyname"]');
		var objReadPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="readpermission"]');
		var objWritePermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="writepermission"]');
		var objPrintPermission = g_objDrmPermissionPolicy.find('input[type="radio"][name="printpermission"]');
		var objExpirationDateSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="expirationdatesetupflag"]');
		var objExpirationDate = g_objDrmPermissionPolicy.find('input[name="expirationdate"]');
		var objReadLimitCountSetupFlag = g_objDrmPermissionPolicy.find('input[type="radio"][name="readlimitcountsetupflag"]');
		var objReadLimitCount = g_objDrmPermissionPolicy.find('input[name="readlimitcount"]');

		if (!isValidParam(objPolicyName, PARAM_TYPE_NAME, "정책명", PARAM_LEN_1, PARAM_LEN_64, null)) {
			return false;
		}

		if ((objReadPermission.filter(':checked').val() == null) || (objReadPermission.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "파일 읽기 권한을 설정해주세요.", "");
			return false;
		}

		if ((objWritePermission.filter(':checked').val() == null) || (objWritePermission.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "파일 쓰기 권한을 설정해주세요.", "");
			return false;
		}

		if ((objPrintPermission.filter(':checked').val() == null) || (objPrintPermission.filter(':checked').val().length == 0)) {
			displayAlertDialog("입력 오류", "파일 출력 권한을 설정해주세요.", "");
			return false;
		}

		if (g_objDrmPermissionPolicy.find('.list-table tbody tr').find('input:checkbox').length ==0) {
			displayAlertDialog("입력 오류", "정책 소속 사용자를 선택해주세요.", "");
			return false;
		}

		return true;
	};

	addUserToList = function() {

		var objTargetUsersTreeReference = $.jstree._reference(g_objTargetUsersTree);

		g_objDrmPermissionPolicy.find('.list-table thead').find('input:checkbox').filter(':checked').each( function (index, item) {
			 $(item).prop('checked', false);
		});
		if (g_objDrmPermissionPolicy.find('.list-table tbody tr').find('input:checkbox').length ==0) {
			g_objDrmPermissionPolicy.find('.list-table tbody').html('');
		}

		g_objTargetUsersTree.find(".jstree-checked").each( function(i, node) {
			if ($(node).attr('node_type') == "user") {
				var companyId = $(node).attr('companyid');
				var deptCode = $(node).attr('deptcode');
				var userId = $(node).attr('userid');
				var userName = objTargetUsersTreeReference.get_text($(node));

				var isAlready = false;
				g_objDrmPermissionPolicy.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').each( function () {
					if (($(this).attr("companyid") == companyId) && ($(this).attr("deptcode") == deptCode) && ($(this).attr("userid") == userId)) {
						isAlready = true;
						return false;
					}
				});

				if (!isAlready) {
					var newRow = '';
					newRow += '<tr>';
					newRow += '<td><input type="checkbox" name="selectuser" companyid="' + companyId + '" deptcode="' + deptCode + '" userid="' + userId + '" style="border: 0;"></td>';
					newRow += '<td>' + g_htDeptList.get(deptCode) + '</td>';
					newRow += '<td>' + userId + '</td>';
					newRow += '<td>' + userName.split('-')[0].trim() + '</td>';
					newRow += '</tr>';

					g_objDrmPermissionPolicy.find('.list-table tbody').append(newRow);
				}
				g_objTargetUsersTree.jstree('uncheck_node', $(node));
			}
		});

		g_objDrmPermissionPolicy.mCustomScrollbar('update');

		$('button[name="btnAddUserToList"]').button("option", "disabled", true);

		refreshListTable(g_objDrmPermissionPolicy);
	};

	removeUserFromList = function() {

		g_objDrmPermissionPolicy.find('.list-table tbody tr').find('input:checkbox[name="selectuser"]').filter(':checked').each( function (index, item) {
			var companyId = $(item).attr('companyid');
			var deptCode = $(item).attr('deptcode');
			var userId = $(item).attr('userid');
			$(this).closest('tr').remove();
		});

		g_objDrmPermissionPolicy.find('.list-table thead tr th:first-child').find('input:checkbox').prop('checked', false);

		refreshListTable(g_objDrmPermissionPolicy);
	};

	refreshListTable = function(objTarget) {

		objTarget.find('.list-table').each( function() {
			$(this).find('tbody > tr').each( function(index) {
				var lineStyle = '';
				if (index%2 == 0)
					lineStyle = "list_odd";
				else
					lineStyle = "list_even";

				$(this).removeClass("list_even");
				$(this).removeClass("list_odd");
				$(this).addClass(lineStyle);
			});
		});
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">정책 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="drm-permission-policy-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">정책 설정</div>
	<div class="ui-layout-content">
		<div id="main-content" style="padding: 10px;">
			<div style="float: left; width: 60%">
				<div class="category-sub-title">설정 정보</div>
				<div id="drm-permission-policy" class="droppable category-sub-contents" style="border: 1px solid #aaa; padding: 10px; overflow:auto;">
					<div class="category-sub-title-2">정책 정보</div>
					<div class="category-sub-contents-2">
						<div id="row-policyid" class="field-line">
							<div class="field-title-140">정책 ID</div>
							<div class="field-value-140" style="background: none;"><input type="text" id="policyid" name="policyid" class="text ui-widget-content" style="border: none; width: calc(100% - 6px);" readonly /></div>
						</div>
						<div class="field-line">
							<div class="field-title-140">정책명<span class="required_field">*</span></div>
							<div class="field-value-140"><input type="text" id="policyname" name="policyname" class="text ui-widget-content" style="width: calc(100% - 6px);"/></div>
						</div>
					</div>
					<div class="category-sub-title-2">정책 옵션</div>
					<div class="category-sub-contents-2">
						<div class="info">
							<ul class="infolist">
								<li>정책에 포함된 모든 사용자들의 문서보안 권한 관련 옵션을 설정합니다.</li>
							</ul>
						</div>
						<div>
							<div>파일 읽기 권한을 부여하시겠습니까?&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="readpermission" value="1"  checked="checked" />예</label>&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="readpermission" value="0" />아니오</label>
							</div>
						</div>
						<div>
							<div>파일 쓰기 권한을 부여하시겠습니까?&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="writepermission" value="1"  checked="checked" />예</label>&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="writepermission" value="0" />아니오</label>
							</div>
						</div>
						<div>
							<div>파일 출력 권한을 부여하시겠습니까?&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="printpermission" value="1"  checked="checked" />예</label>&nbsp;&nbsp;
								<label class="radio"><input type="radio" name="printpermission" value="0" />아니오</label>
							</div>
						</div>
						<div>
							<div class="radio-branch">
								<div>파일 접근 만료 일자를 설정하시겠습니까?&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="expirationdatesetupflag" value="1"  checked="checked" />예</label>&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="expirationdatesetupflag" value="0" />아니오</label>
								</div>
							</div>
							<div id="row-expirationdate" class="radio-branch">
								<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>만료 일자:&nbsp;
								<input type="text" id="expirationdate" name="expirationdate" class="text ui-widget-content input-date" readonly="readonly" />
							</div>
						</div>
						<div>
							<div class="radio-branch">
								<div>파일 접근 횟수 제한을 설정하시겠습니까?&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="readlimitcountsetupflag" value="1"  checked="checked" />예</label>&nbsp;&nbsp;
									<label class="radio"><input type="radio" name="readlimitcountsetupflag" value="0" />아니오</label>
								</div>
							</div>
							<div id="row-readlimitcount" class="radio-branch">
								<ul class="ui-helper-clearfix icons"><li><span class="ui-icon ui-icon-stop" style="padding-bottom: 5px;"></span></li></ul>접근 횟수:&nbsp;
								<input type="text" id="readlimitcount" name="readlimitcount" class="text ui-widget-content input-date" />
							</div>
						</div>
					</div>
					<div class="category-sub-title-2">소속 사용자</div>
					<div class="category-sub-contents-2">
						<table class="list-table">
						<thead>
						<tr>
							<th width="40" class="ui-state-default" style="text-align: center;">
								<input type="checkbox" style="border: 0;" onFocus="this.blur();">
							</th>
							<th class="ui-state-default">부서명</th>
							<th class="ui-state-default">사용자ID</th>
							<th class="ui-state-default">사용자명</th>
						</tr>
						</thead>
						<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="button-line" style="margin-top: 2px;">
					<button type="button" id="btnRemoveUserFromList" name="btnRemoveUserFromList" class="normal-button">선택 사용자 제외</button>
				</div>
			</div>
			<div style="margin-left: 61%;">
				<div class="category-sub-title">선택 대상</div>
				<div id="target-users" class="draggable category-sub-contents">
					<div id="target-users-tree" class="treeview-pannel"></div>
				</div>
				<div class="button-line" style="margin-top: 2px;">
					<button type="button" id="btnAddUserToList" name="btnAddUserToList" class="normal-button">선택 사용자 추가</button>
				</div>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnNew" name="btnNew" class="normal-button" style="display: none;">신규 정책</button>
			<button type="button" id="btnSave" name="btnSave" class="normal-button" style="display: none;">설정 저장</button>
			<button type="button" id="btnDelete" name="btnDelete" class="normal-button" style="display: none;">정책 삭제</button>
		</div>
	</div>
</div>
