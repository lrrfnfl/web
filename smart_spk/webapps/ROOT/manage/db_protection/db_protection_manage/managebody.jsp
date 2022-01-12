<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ include file ="/include/dialog/alert-dialog.jsp"%>
<%@ include file ="/include/dialog/confirm-dialog.jsp"%>
<script type="text/javascript">
<!--
	var g_objCompanyTree;
	var g_objDbProtectionManage;

	var g_htOptionTypeList = new Hashtable();

	var g_addAddressCount = 0;

	var g_oldSelectedTreeNode = null;
	var g_selectedTreeNode = null;

	$(document).ready(function() {

		g_objCompanyTree = $('#company-tree');
		g_objDbProtectionManage = $('#dbprotection-manage');

		$( document ).tooltip();

		$('button').button();
		$('button[name="btnDeleteProgram"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnAddProgram"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnDeleteAddress"]').button({ icons: {primary: "ui-icon-circle-minus"} });
		$('button[name="btnAddAddress"]').button({ icons: {primary: "ui-icon-circle-plus"} });
		$('button[name="btnSave"]').button({ icons: {primary: "ui-icon-disk"} });

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		g_htOptionTypeList = loadTypeList("OPTION_TYPE");
		if (g_htOptionTypeList.isEmpty()) {
			displayAlertDialog("옵션 유형 조회", "옵션 유형 조회 중 오류가 발생하였습니다.", "자세한 사항은 시스템 관리자에게 문의해 주십시오.");
		}

<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		innerDefaultLayout.show("west");
		loadCompanyTreeView();
<% } else { %>
		loadDbProtectionInfo();
		$('button[name="btnSave"]').show();
		g_objDbProtectionManage.show();
<% } %>

		$('button').click( function () {
			if ($(this).attr('id') == 'btnDeleteProgram') {
				deleteProgramFromList();
			} else if ($(this).attr('id') == 'btnAddProgram') {
				addProgramToList();
			} else if ($(this).attr('id') == 'btnDeleteAddress') {
				deleteAddressFromList();
			} else if ($(this).attr('id') == 'btnAddAddress') {
				addAddressToList();
			} else if ($(this).attr('id') == 'btnSave') {
				displayConfirmDialog("설정 저장", "설정 정보를 저장 하시겠습니까?", "", function() { saveDbProtectionInfo(); });
			}
		});

		g_objDbProtectionManage.find('select[name="programlist"]').change( function() {
			g_objDbProtectionManage.find('#newprogramname').val($(this).children("option:selected").text());
			g_objDbProtectionManage.find('#newfilename').val($(this).val());
		});
	});

	loadCompanyTreeView = function() {

		var xmlTreeData = "";
		xmlTreeData += "<root>";
		xmlTreeData += "<item id='root' node_type='root' state='closed'>";
		xmlTreeData += "<content><name><![CDATA[전체 사업장]]></name></content>";
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
							var categoryCode = "";
							if (node.attr("node_type") == 'company_category') {
								categoryCode = node.children('a').text().trim();
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
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
							return false;
						} else {
							var startTag = "<root>";
							var endTag = "</root>";
							return data.substr(data.indexOf(startTag), data.lastIndexOf(endTag)-data.indexOf(startTag)+endTag.length);
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						if (jqXHR.status != 0 && jqXHR.readyState != 0) {
							displayAlertDialog("사업장 트리 목록 조회", "사업장 트리 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
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
				if (data.rslt.obj.attr('node_type') == "company") {
					$('.inner-center .pane-header').text('사업장 DB 보안 설정 - [' + data.inst.get_text(data.rslt.obj) + ']');
					$('button[name="btnSave"]').show();
					g_objDbProtectionManage.show();
					$('.inner-center .ui-layout-content').unblock();

					loadDbProtectionInfo();
				} else {
					$('.inner-center .pane-header').text('DB 보안 설정');
					$('button[name="btnSave"]').hide();
					g_objDbProtectionManage.hide();
					$('.inner-center .ui-layout-content').block({ message: '<div style="height:20px;"><span style="position:relative; bottom: -1px;line-height: 20px;">DB 보안 설정을 위한 사업장을 선택해 주세요.</span></div>', themedCSS: { margin: '0', padding: '0', 'min-width': '360px', 'width': '50%', height: '42px', backgroundColor: '#fff', border: '1px solid #aaa', color: '#fff', '-webkit-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', '-moz-box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)', 'box-shadow': '4px 4px 4px 0px rgba(0,0,0,0.55)' }, overlayCSS: { backgroundColor:'#000', opacity: .3, cursor: 'wait' }, fadeIn: 0, fadeOut: 0 });
				}
			}
		}).bind('deselect_node.jstree', function (event, data) {
			g_selectedTreeNode = null;
		});
	};

	loadDbProtectionInfo = function() {

		var objUseFlag = g_objDbProtectionManage.find('input[type="radio"][name="useflag"]');
		var objDbProtectionLicenceCount = g_objDbProtectionManage.find('#dbprotectionlicencecount');
		var objCurrentRegisteredCount = g_objDbProtectionManage.find('#currentregisteredcount');
		var objProgramList = g_objDbProtectionManage.find('select[name="programlist"]');
		var objAddressList = g_objDbProtectionManage.find('select[name="addresslist"]');

		var targetCompanyId = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestDbProtectionInfoParam(targetCompanyId);

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
				$('.inner-center .ui-layout-content').mCustomScrollbar('update');
			},
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("DB 보안 설정 정보 조회", "DB 보안 설정 정보 조회 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
					return false;
				}

				var useFlag = $(data).find('useflag').text();
				var dbProtectionLicenceCount = $(data).find('dbprotectionlicencecount').text();
				var currentRegisteredCount = $(data).find('currentregisteredcount').text();

				objUseFlag.prop('checked', false);
				objUseFlag.filter('[value=' + useFlag + ']').prop('checked', true);

				objDbProtectionLicenceCount.text(dbProtectionLicenceCount);
				objCurrentRegisteredCount.text(currentRegisteredCount);

				objProgramList.empty();
				$(data).find('program').each(function() {
					objProgramList.append('<option value="' + $(this).find('filename').text() + '">' + $(this).find('programname').text() + '</option>');
				});

				objAddressList.empty();
				$(data).find('address').each(function() {
					objAddressList.append('<option value="' + $(this).text() + '">' + $(this).text() + '</option>');
				});

				g_addAddressCount = 0;
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("DB 보안 설정 정보 조회", "DB 보안 설정 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	saveDbProtectionInfo = function() {

		var objUseFlag = g_objDbProtectionManage.find('input[type="radio"][name="useflag"]:checked');
		var objDbProtectionLicenceCount = g_objDbProtectionManage.find('#dbprotectionlicencecount');
		var objProgramList = g_objDbProtectionManage.find('select[name="programlist"]');
		var objAddressList = g_objDbProtectionManage.find('select[name="addresslist"]');

		if (parseInt(objDbProtectionLicenceCount.text()) <= 0) {
			displayAlertDialog("DB 보안 설정 적용", "DB 보안 설정 가능한 라이센스가 없습니다.", "");
			return false;
		}

		var arrProgramList = new Array();
		objProgramList.children('option').each( function() {
			var arrProgram = new Array();
			if ($(this).val().length > 0) {
				arrProgram.push($(this).text());
				arrProgram.push($(this).val());
				arrProgramList.push(arrProgram);
			}
		});

		if ((objUseFlag.val() == "<%=OptionType.OPTION_TYPE_YES%>") && (arrProgramList.length <= 0)) {
			displayAlertDialog("DB 보안 설정 적용", "DB 보안을 적용할 프로그램을 입력해 주세요.", "");
			return false;
		}

		var arrAddressList = new Array();
		objAddressList.children('option').each( function() {
			if ($(this).val().length > 0) {
				arrAddressList.push($(this).val());
			}
		});

		if ((objUseFlag.val() == "<%=OptionType.OPTION_TYPE_YES%>") && (arrAddressList.length <= 0)) {
			displayAlertDialog("DB 보안 설정 적용", "DB 보안을 적용할 대상 시스템의 주소를 입력해 주세요.", "");
			return false;
		}

		var targetCompanyId = "";
<% if (AdminType.ADMIN_TYPE_SITE_ADMIN.equals((String)session.getAttribute("ADMINTYPE"))) { %>
		var objTreeReference = $.jstree._reference(g_objCompanyTree);
		if (typeof objTreeReference.get_selected().attr('companyid') != typeof undefined) {
			targetCompanyId = objTreeReference.get_selected().attr('companyid');
		}
<% } else { %>
		targetCompanyId = "<%=(String)session.getAttribute("COMPANYID")%>";
<% } %>

		var postData = getRequestUpdateDbProtectionParam('<%=(String)session.getAttribute("ADMINID")%>',
				targetCompanyId,
				objUseFlag.val(),
				arrProgramList,
				arrAddressList);

		$.ajax({
			type: "POST",
			url: "/CommandService",
			data: $.param({sendmsg : postData}),
			dataType: "xml",
			cache: false,
			async: false,
			success: function(data, textStatus, jqXHR) {
				if ($(data).find('errorcode').text() != "0000") {
					displayAlertDialog("DB 보안 설정 적용", "DB 보안 설정 적용 중 오류가 발생하였습니다.", $(data).find('errormsg').text());
				} else {
					displayInfoDialog("DB 보안 설정 적용", "정상 처리되었습니다.", "정상적으로 DB 보안 설정이 적용되었습니다.");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				if (jqXHR.status != 0 && jqXHR.readyState != 0) {
					displayAlertDialog("DB 보안 설정 적용", "DB 보안 설정 적용 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
				}
			}
		});
	};

	addProgramToList = function() {

		var objProgramList = g_objDbProtectionManage.find('#programlist');
		var objNewProgramName = g_objDbProtectionManage.find('#newprogramname');
		var objNewFileName = g_objDbProtectionManage.find('#newfilename');

		if (objNewProgramName.val().length == 0) {
			displayAlertDialog("DB 보안 프로그램 설정", "추가할 프로그램 명을 입력해 주세요.", "");
			objNewProgramName.addClass('ui-state-error');
			objNewProgramName.focus();
			return false;
		}

		if (objNewFileName.val().length == 0) {
			displayAlertDialog("DB 보안 프로그램 설정", "추가할 프로그램 파일명을 입력해 주세요.", "");
			objNewFileName.addClass('ui-state-error');
			objNewFileName.focus();
			return false;
		}

		var isAlready = false;

		objProgramList.children('option').each( function() {
			if ( $(this).val() == objNewFileName.val() ) {
				displayAlertDialog("DB 보안 프로그램 설정", "이미 추가한 프로그램입니다.", "");
				objNewFileName.focus();
				isAlready = true;
				return false;
			}
		});

		if (!isAlready) {
			var objOption = new Option(objNewProgramName.val(), objNewFileName.val(), true, true);
			$(objOption).html(objNewProgramName.val());
			objProgramList.append(objOption);

			objNewProgramName.val('');
			objNewFileName.val('');
		}
	};

	deleteProgramFromList = function() {

		var objProgramList = g_objDbProtectionManage.find('#programlist');

		objProgramList.children('option').filter(":selected").remove();
	};

	addAddressToList = function() {

		var objAddressList = g_objDbProtectionManage.find('#addresslist');
		var objNewAddress = g_objDbProtectionManage.find('#newaddress');
		var objDbProtectionLicenceCount = g_objDbProtectionManage.find('#dbprotectionlicencecount');
		var objCurrentRegisteredCount = g_objDbProtectionManage.find('#currentregisteredcount');

		if ((g_addAddressCount + parseInt(objCurrentRegisteredCount.text())) >= parseInt(objDbProtectionLicenceCount.text())) {
			displayAlertDialog("DB 보안 IP 주소 설정", "DB 보안 설정 가능한 라이센스 수를 초과하였습니다.", "");
			return false;
		}

		if (objNewAddress.val() == '') {
			displayAlertDialog("DB 보안 IP 주소 설정", "추가할 주소를 입력해 주세요.", "");
			objNewAddress.addClass('ui-state-error');
			objNewAddress.focus();
			return false;
		} else {
			if (!isValidParam(objNewAddress, PARAM_TYPE_IPV4_ADDRESS, "보안할 PC IP 주소", PARAM_DETAIL_ADDRESS_MIN_LEN, PARAM_DETAIL_ADDRESS_MAX_LEN, null)) {
				return false;
			}
		}

		var isAlready = false;

		objAddressList.children('option').each( function() {
			if ( $(this).val() == objNewAddress.val() ) {
				displayAlertDialog("DB 보안 IP 주소 설정", "이미 추가한 주소입니다.", "");
				objNewAddress.focus();
				isAlready = true;
				return false;
			}
		});

		if (!isAlready) {
			var objOption = new Option(objNewAddress.val(), objNewAddress.val(), true, true);
			$(objOption).html(objNewAddress.val());
			objAddressList.append(objOption);

			objNewAddress.val('');
		}

		g_addAddressCount++;
		objCurrentRegisteredCount.text(parseInt(objCurrentRegisteredCount.text())+1);
	};

	deleteAddressFromList = function() {

		var objAddressList = g_objDbProtectionManage.find('#addresslist');
		var objCurrentRegisteredCount = g_objDbProtectionManage.find('#currentregisteredcount');

		objAddressList.children('option').filter(":selected").remove();

		g_addAddressCount--;
		objCurrentRegisteredCount.text(parseInt(objCurrentRegisteredCount.text())-1);
	};
//-->
</script>

<div class="inner-west">
	<div class="pane-header">사업장 목록</div>
	<div class="ui-layout-content zero-padding">
		<div id="company-tree" class="treeview-pannel"></div>
	</div>
</div>
<div class="inner-center">
	<div class="pane-header">DB 보안 설정</div>
	<div class="ui-layout-content">
		<div id="dbprotection-manage" class="info-form" style="padding: 10px;">
			<div class="category-sub-title">기본 DB 보안 설정 정보</div>
			<div class="category-sub-contents">
				<div class="field-line">
					<div>DB 보안 기능을 사용 하시겠습니까?&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="useflag" value="1">예</label>&nbsp;&nbsp;
						<label class="radio"><input type="radio" name="useflag" value="0">아니오</label>
					</div>
				</div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">DB 보안 대상 프로그램 등록</div>
			<div class="category-sub-contents">
				<div style="float: left; width: 50%;">
					<div><select id="programlist" name="programlist" style="padding: 5px; width: 100%; height: 140px; line-height:30px;" class="ui-widget-content"></select></div>
					<div style="float: right; margin-top: 4px;">
						<button type="button" id="btnDeleteProgram" name="btnDeleteProgram" class="normal-button">선택 프로그램 삭제</button>
					</div>
				</div>
				<div style="margin-left: 51%;">
					<div class="field-line">
						<div class="field-title-200">프로그램 명</div>
						<div class="field-value-200">
							<input type="text" id="newprogramname" name="newprogramname" class="text ui-widget-content" />
						</div>
					</div>
					<div class="field-line">
						<div class="field-title-200">프로그램 파일명</div>
						<div class="field-value-200">
							<input type="text" id="newfilename" name="newfilename" class="text ui-widget-content" />
						</div>
					</div>
					<div class="button-line">
						<button type="button" id="btnAddProgram" name="btnAddProgram" class="normal-button">프로그램 추가</button>
					</div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="category-sub-title" style="margin-top: 20px;">DB 보안 적용 시스템 등록  ( 현재 등록 상태: <span id="currentregisteredcount"></span>/<span id="dbprotectionlicencecount"></span> )</div>
			<div class="category-sub-contents">
				<div style="float: left; width: 50%;">
					<div><select id="addresslist" name="addresslist" style="padding: 5px; width: 100%; height: 140px; line-height:30px;" class="ui-widget-content"></select></div>
					<div style="float: right; margin-top: 4px;">
						<button type="button" id="btnDeleteAddress" name="btnDeleteAddress" class="normal-button">선택주소 삭제</button>
					</div>
				</div>
				<div style="margin-left: 51%;">
					<div class="field-line">
						<div class="field-title-200">보안 적용 시스템 IP 주소</div>
						<div class="field-value-200">
							<input type="text" id="newaddress" name="newaddress" class="text ui-widget-content" />
						</div>
					</div>
					<div class="button-line">
						<button type="button" id="btnAddAddress" name="btnAddAddress" class="normal-button">주소 추가</button>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>
	<div class="pane-footer">
		<div class="button-line">
			<button type="button" id="btnSave" name="btnSave" class="normal-button" style="display: none;">설정 저장</button>
		</div>
	</div>
</div>
