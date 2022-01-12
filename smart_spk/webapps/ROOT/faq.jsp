<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.spk.common.constant.CommonConstant" %>
<%@ page import="com.spk.type.*" %>
<%@ page import="com.spk.util.Util" %>
<%@ page import="com.spk.util.DbUtil" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

	String webTitle = CommonConstant.SERVER_TITLE;
	/*************************************************************************
	 * 서버 설정 정보 조회
	 ************************************************************************/
	 HashMap<String, String> mapServerConfig = DbUtil.getServerConfig(session);
	if (!mapServerConfig.isEmpty()) {
		if ("MEDISAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			webTitle = CommonConstant.MEDISAFER_SERVER_TITLE;
		} else if ("BIZSAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			webTitle = CommonConstant.BIZSAFER_SERVER_TITLE;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title><%=webTitle%></title>

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/css/darkness.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />
<% } %>

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/themes/darkness/jquery.ui.all.css" media="all" />
<% } else { %>
	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
<% } %>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/development-bundle/ui/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/development-bundle/ui/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/development-bundle/ui/jquery.ui.accordion.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-layout/layout-default-latest.css" />
	<script type="text/javascript" src="/js/jquery-ui-layout/jquery.layout-latest.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
	<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

	<script type="text/javascript" src="/js/blockui.js"></script>

	<script type="text/javascript" src="/js/jshashtable-2.1/jshashtable.js"></script>

	<script type="text/javascript" src="/js/jstree-v.pre1.0/jquery.jstree.js"></script>

	<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all" />
	<script type="text/javascript" src="/js/layout.js"></script>

	<script type="text/javascript">
	<!--
		var g_objFaqTree;
		var g_objFaqList;
		var g_objFaqContents;

		var g_selectedFaqId = "";

		$(document).ready(function() {
		
			g_objFaqTree = $('#faq-tree');
			g_objFaqContents = $('#faq-contents');

			$( document ).tooltip();

			$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

			outerLayout = $("body").layout(outerMinLayoutOptions);
			showInnerLayout("innerDefault");
			innerDefaultLayout.show("west");

			var faqTreeData = makeFaqTreeData();
			loadFaqTreeView(faqTreeData);

			$("#accordion").accordion({
				collapsible: true,
				heightStyle: "content",
				header: "h3"
			});
		});

		reloadDefaultLayout = function() {
			var layoutHeight = $('.treeview-pannel').parent().height();
			var paddingTop = parseInt($('.treeview-pannel').css("padding-top"));
			var paddingBottom = parseInt($('.treeview-pannel').css("padding-bottom"));
			if ($('.treeview-pannel').length) {
				$('.treeview-pannel').height(layoutHeight - paddingTop - paddingBottom);
				$('.treeview-pannel').mCustomScrollbar('update');
			}
			$('.inner-center .ui-layout-content').mCustomScrollbar('update');
		};

		makeFaqTreeData = function() {

			var faqTreeData = "";

			faqTreeData += "<item id='item_0' parent_id='ALL' faq_id='0'>";
			faqTreeData += "<content><name>로그인 오류</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_01' parent_id='item_0' faq_id='0'>";
			faqTreeData += "<content><name>PC 부팅 시 SPK 자동로그인 기능이 설정되어 있는 환경에서 부팅 시 자동으로 로그인 되지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_02' parent_id='item_0' faq_id='0'>";
			faqTreeData += "<content><name>프로그램을 정상 설치하였으나 이후 기능작동이 되지 않습니다.</name></content>";
			faqTreeData += "</item>";
		
			faqTreeData += "<item id='item_03' parent_id='item_0' faq_id='0'>";
			faqTreeData += "<content><name>사용자 비밀번호를 분실했는데 어떻게 해야 하나요?</name></content>";
			faqTreeData += "</item>";
		
			faqTreeData += "<item id='item_1' parent_id='ALL' faq_id='1'>";
			faqTreeData += "<content><name>암/복호화 오류</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_11' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>텍스트파일(.txt)이나 이미지파일( .png, .jpg 등)이 깨져서 보입니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_12' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>암호화된 문서파일을 열 때 문서가 정상적으로 보이지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_13' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>암호화된 이미지 파일을 열람 시 이미지가 정상적으로 보이지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_14' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>암호화된 문서를 외부로 보내려면 어떻게 해야 하나요?</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_15' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>마우스 우클릭 복호화 메뉴를 선택했는데도 파일이 복호화되지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_16' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>개인정보가 없는 파일인데도 파일생성 및 편집 시 자동으로 암호화가 됩니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_17' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>기존 문서를 마우스 우클릭하여 수동으로 암호화 처리하면 사내에서도 파일이 열리지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_18' parent_id='item_1' faq_id='1'>";
			faqTreeData += "<content><name>암호화된 한글파일에서 마우스 우클릭 으로 ”한글문서(Hwp) 인쇄(P)”를 선택하여 출력 시 인쇄문서에 글자 깨짐 현상이 발생 됩니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_2' parent_id='ALL' faq_id='2'>";
			faqTreeData += "<content><name>오류 메세지</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_21' parent_id='item_2' faq_id='2'>";
			faqTreeData += "<content><name>SPK 실행 시, “업데이트 오류” 메시지가 나타납니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_22' parent_id='item_2' faq_id='2'>";
			faqTreeData += "<content><name>PDF 문서를 여는 과정에서 “지원되지 않는 파일 형식이거나 파일이 손상되었으므로 ‘파일이름.pdf’를 열 수 없었습니다.” 라는 메시지가 표시되며 열리지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_23' parent_id='item_2' faq_id='2'>";
			faqTreeData += "<content><name>클라이언트 PC 화면에 ”강제 검사 확인에 문제가 생겼습니다.” 라는 문구가 나타나는 오류</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_24' parent_id='item_2' faq_id='2'>";
			faqTreeData += "<content><name>제품설치 시 “ADLP모듈이 존재하지 않습니다” 라는 메시지가 나타나는 오류</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_25' parent_id='item_2' faq_id='2'>";
			faqTreeData += "<content><name>신규로 추가된 인력이 있어 사용자 등록 후 클라이언트 설치 시 “등록되지 않는 사업자”라는 메시지가 나타나는 오류</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_3' parent_id='ALL' faq_id='3'>";
			faqTreeData += "<content><name>기타 질문</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_31' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>개인정보를 검출 할 수 있는 파일형식은 어떤게 있나요?</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_32' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>개인정보 검사화면의 빠른검사와 일반검사의 차이는 뭔가요?</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_33' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>관리자 페이지에서 사용자 정책 변경 후 변경된 정책이 반영되지 않습니다.</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_34' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>관리자 페이지의 글자 깨짐 오류 문의</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_35' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>제어판에서 사용자가 임의로 프로그램 삭제가 가능한가요?</name></content>";
			faqTreeData += "</item>";

			faqTreeData += "<item id='item_36' parent_id='item_3' faq_id='3'>";
			faqTreeData += "<content><name>Safe.PrivacyKeeper 제품삭제는 어떻게 하나요?</name></content>";
			faqTreeData += "</item>";

			return faqTreeData;
		};
	
		loadFaqTreeView = function(faqTreeData) {

			var xmlTreeData = "";

			xmlTreeData += "<root>";
			xmlTreeData += "<item id='ALL' node_type='ROOT'>";
			xmlTreeData += "<content><name>전체 목록</name></content>";
			xmlTreeData += "</item>";
			xmlTreeData += faqTreeData;
			xmlTreeData += "</root>";

			g_objFaqTree.jstree({
				"xml_data" : {
					"data" : xmlTreeData
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
				g_objFaqTree.jstree('open_all');

				if (g_selectedFaqId.length >0)
					g_objFaqTree.jstree('select_node', $('#' + g_selectedFaqId));
				else
					data.inst.select_node('ul >li:first');

				$('.treeview-pannel').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });

			}).bind('select_node.jstree', function (event, data) {
				$("#accordion").accordion("option", "active", Number(data.rslt.obj.attr('faq_id')));
			});
		};
	//-->
	</script>
</head>
<body>
	<div class="ui-layout-north">
		<div class="ui-widget header-contents" style="background-color: #fff;">
<% if ("MEDISAFER".equals(mapServerConfig.get("oem"))) { %>
			<div class="logo-display">
				<span><img src="/images/skb_top_title_server.png" border="0" alt="MediSager Server" width="280" height="54" style="vertical-align: bottom;" /></span>
			</div>
<% } else { %>
			<div class="logo-display">
				<span><img src="/images/top_title_server.jpg" border="0" alt="safe.PrivacyKeeper Server" width="284" height="43" style="vertical-align: bottom;" /></span>
			</div>
<% } %>
			<div class="clear"></div>
		</div>
	</div>
	<div class="ui-layout-center">
		<div id="innerDefault" class="inner-layout-container">
			<div class="inner-west">
				<div class="pane-header ui-widget-header ui-corner-top">FAQ 목록</div>
				<div class="ui-layout-content ui-widget-content ui-corner-bottom" style="padding: 0;">
					<div id="faq-tree" class="treeview-pannel"></div>
				</div>
			</div>
			<div class="inner-center">
				<div class="pane-header ui-widget-header ui-corner-top">FAQ 내용</div>
				<div class="ui-layout-content ui-widget-content ui-corner-bottom">
					<div id="faq-contents" class="faq-form">
						<div id="accordion">
							<h3>로그인 오류</h3>
							<div>
								<div class="category">
									<div class="title">Q1. PC 부팅 시 SPK 자동로그인 기능이 설정되어 있는 환경에서 부팅 시 자동으로 로그인 되지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>SPK는 인터넷이 느린 네트워크 환경에서도 접속 시간 지연을 감안하여 자동 로그인 시 일정 시간 대기 후 로그인을 시도합니다. 그럼에도 불구하고 인터넷 접속 시간이 많이 지연되어 로그인 실패가 발생할 수 있습니다.</li>
											<li>PC 부팅 시 설정되어 있는 시작프로그램이 많아 자동실행에서 SPK의 우선 실행순위가 뒤로 밀려 발생할 수 있는 문제 입니다.</li>
											<li>접속지연에 대한 SPK 최신 패치 버전에 대해 관리자 및 기술지원팀에 문의 바랍니다.</li>
											<li>부팅이 완료된 후, 바탕화면에 있는 SPK 아이콘을 클릭해도 자동 로그인 됩니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q2. 프로그램을 정상 설치하였으나 이후 기능작동이 되지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>최초 프로그램 설치 이후 비밀번호 변경 창이 나타나는데, 그때 사용자 비밀번호를 변경하지 않으면 프로그램 기능을 사용 할 수 없습니다.</li>
											<li>비밀번호는 영문 대문자, 영문 소문자, 숫자, 특수문자(!@#$^*)를 사용하여 2종 10자, 3종 8자 이상 18자리 이하 조합으로 변경하셔야 합니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q3. 사용자 비밀번호를 분실했는데 어떻게 해야 하나요?</div>
									<div class="contents">
										<ul>
											<li>회사 내 개인정보 관리자에게 ‘비밀번호 초기화’를 요청하고 ‘새로운 비밀번호’를 받습니다.</li>
											<li>관리자는 SPK 관리자페이지에서 “관리 &gt; 조직 관리 &gt; 부서/사용자 관리“ 목록에서 해당 사용자를 클릭하여 “사용자 정보” 하단의 “비밀번호 초기화” 버튼을 클릭하여 비밀번호를 초기화 할 수 있습니다.</li>
											<li>관리자에게 받은 ‘새로운 비밀번호’는 임시 비밀번호이므로, 프로그램을 실행 후 다시 한번 비밀번호를 변경해야 프로그램을 정상적으로 사용하실 수 있습니다.</li>
										</ul>
									</div>
								</div>
							</div>
							<h3>암/복호화 오류</h3>
							<div>
								<div class="category">
									<div class="title">Q1. 텍스트파일(.txt)이나 이미지파일( .png, .jpg 등)이 깨져서 보입니다.</div>
									<div class="contents">
										<ul>
											<li>텍스트 파일의 대표적인 문서편집기인 "메모장" 은 SPK의 자동 암복호화 문서보안 지원 대상이 아닙니다. ( 자동 암/복호화 지원대상 프로그램은 Q2 를 참고해 주십시요 )
												<ul class="sub-contents">
													<li>- 텍스트파일이 암호화되는 경우는, 개인정보 검출을 통해 암호화되는 경우가 대표적입니다.</li>
													<li>- 자동으로 암/복호화를 지원하지 않으므로, 사용하시려면 탐색기에서 해당파일을 마우스 오른쪽 메뉴로 클릭한 후, 복호화 기능을 이용해 주시기 바랍니다.</li>
												</ul>
											</li>
											<li>이미지 파일 역시, 자동 암/복호화를 지원하는 프로그램을 사용하지 않으시면, 깨져보입니다. 자세한 내용은 Q3 을 참고해 주십시요.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q2. 암호화된 문서파일을 열 때 문서가 정상적으로 보이지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>SPK 의 암호화된 문서를 작업할 수 있는 문서보안 편집 프로그램은 다음과 같습니다.
												<ul class="sub-contents">
													<li>- 텍스트 문서 편집 프로그램 : 한글 2007, 2010, 2013, MS Office 2003, 2007, 2010, 2013, Acrobat  6.x/ 7.x/ 8.x/ 9.x/ X[10.x]/ XI[11.x]</li>
													<li>- 이미지 문서 뷰어 프로그램 : Windows 기본 이미지 뷰어, Windows 그림판, 알씨</li>
												</ul>
											</li>
											<li>이 외 다른 프로그램에서는 암호화된 파일을 열 수 없습니다. (메모장 등으로 암호화된 .txt 파일을 여는 경우 등)</li>
											<li>현재 SPK 가 지원하는 OS는 Windows XP, VISTA, 7[36bit, 64bit] 입니다 ( Windows 8[36bit, 64bit]은 2014년 6월 지원 예정 )</li>
											<li>SPK AD(중요 정보 유출방지 기능) 이외의 타 문서보안솔루션(FASOO/마크애니/소프트캠프사 등)이 설치 되어있는 경우 솔루션 간 간섭문제로 인하여 암호화된 파일이 정상적으로 작업이 되지 않을 수 있습니다. 해당 경우는 해당 타 문서보안솔루션 정보와 함께 SPK 기술지원 팀에 연락 바랍니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q3. 암호화된 이미지 파일을 열람 시 이미지가 정상적으로 보이지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>이미지 파일은 모든 뷰어에서는 보이지 않으며, 이미지 뷰어의 연결 프로그램을 변경해야 합니다.
												<ul class="sub-contents">
													<li>- 조치 방법 : 암호화된 이미지 파일 선택 후 오른쪽 마우스 클릭 &gt; 연결 프로그램 &gt; 프로그램 선택 &gt; “Windows 사진뷰어 / 알씨” 선택 &gt; 이 종류의 파일을 열 때 항상 선택된 프로그램 사용 부분 체크 &gt; 확인</li>
												</ul>
											</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q4. 암호화된 문서를 외부로 보내려면 어떻게 해야 하나요?</div>
									<div class="contents">
										<ul>
											<li>SPK AD(중요 정보 유출방지 기술) 로 암호화된 문서 및 이미지는 현재 Client가 설치되어 있는 조직에서만 공유가 가능합니다. 따라서  외부로 문서공유 시 복호화 작업을 통하여 일반 파일로 변환 후 공유하여야 합니다.</li>
											<li>복호화 시 작성하는 복호화 사유는 관리자 페이지에 기록되므로 자세한 목적을 기록해야합니다.</li>
											<li>관리자에 의해 복호화 권한이 주어지지 않은 사용자는 “You don’t have a permission to decrypt”라는 메시지 창이 나타나며 복호화가 허용되지 않습니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q5. 마우스 우클릭 복호화 메뉴를 선택했는데도 파일이 복호화되지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>문서를 편집중인 경우, 복호화 과정에서 문서의 훼손이 발생할 수 있어 편집 중 복호화는 지원하지 않습니다.</li>
											<li>문서가 열려있는지 확인하신 후, 문서를 닫고 복호화를 시도해 주십시오.</li>
											<li>SPK 최신 버전에서는 이에 대한 안내 메시지가 표시됩니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q6. 개인정보가 없는 파일인데도 파일생성 및 편집 시 자동으로 암호화가 됩니다.</div>
									<div class="contents">
										<ul>
											<li>SPK AD(중요 정보 유출방지 기술) 제품을 도입하신 사업자는 문서 보안 기능(DRM)이 함께 설치되어 문서 생성 및 편집 시 자동으로 암호화가 이루어 집니다. 또한 관리자 권한으로 사용자의 실시간 감시(강제사용)및 검출처리유형이 암호화로 설정되었을 경우 문서 이동 및 복사 시 개인정보를 실시간으로 검사하여 자동으로 암호화가 이루어 질 수 있습니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q7. 기존 문서를 마우스 우클릭하여 수동으로 암호화 처리하면 사내에서도 파일이 열리지 않음 (수동 암호화를 처리한 본인만 볼 수 있음)</div>
									<div class="contents">
										<ul>
											<li>기본적으로 암호화 된 문서를 열어 볼 수 있는 환경은 클라이언트가 설치되어 있고 실행중인 상태의 같은 조직내 PC에서만 암호화된 파일을 열어볼 수 있습니다.</li>
											<li>암호화는 중요 문서가 임의로 외부 유출 시 클라이언트가 설치되어 있지 않은 PC에서 파일을 열어 볼 수 없도록 하는게 목적 입니다.</li>
											<li class="comment" style="margin-top: 10px;">현재 SPK는 윈 XP, 윈 2K, 윈 비스타, 윈7 에서, Active DLP(문서보안) 기능을 제공하고 있습니다.</li>
											<li class="comment">단, SPK의 개인정보 검출 및 쉘(마우스) 메뉴 암/복호화는 윈8 에서도 가능합니다. 혹시 열리지 않는 PC가 윈8 은 아니신지 확인 부탁 드립니다.</li>
											<li class="comment">윈8 에 대한 A-DLP(문서보안) 기능은 올해 3/4분기 안에 지원해 드릴 예정입니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q8. 암호화된 한글파일에서 마우스 우클릭 으로 ”한글문서(Hwp) 인쇄(P)”를 선택하여 출력 시 인쇄문서에 글자 깨짐 현상이 발생 됩니다.</div>
									<div class="contents">
										<ul>
											<li>암호화된 문서를 출력 할 경우 해당 문서를 열어서 출력 시에만 정상 출력 됩니다.</li>
										</ul>
									</div>
								</div>
							</div>
							<h3>오류 메세지</h3>
							<div>
								<div class="category">
									<div class="title">Q1. SPK 실행 시, “업데이트 오류” 메시지가 나타납니다.</div>
									<div class="contents">
										<ul>
											<li>클라이언트와 업데이트 서버간 통신이 이뤄지지 못했거나, 프로그램이 사용 중 일 수 있습니다.</li>
											<li>SPK를 종료하지 않고 다시 바탕화면 아이콘을 실행했거나 편집기 등이 실행 중 일 수 있으니 SPK 및 문서편집기를 모두 종료한 후 재 시도해 주시기 바랍니다.</li>
											<li>인터넷은 정상작동 되지만 업데이트 오류 메시지가  발생시 SPK 기술지원 팀에 연락 바랍니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q2. PDF 문서를 여는 과정에서 “지원되지 않는 파일 형식이거나 파일이 손상되었으므로 ‘파일이름.pdf’를 열 수 없었습니다.” 라는 메시지가 표시되며 열리지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>PDF 파일은 Acrobat 6.x/7.x/8.x/9.x/X[10.x]/XI[11.x] 버전만을 지원합니다. 혹시 PC에 타 PDF 뷰어(별 PDF, ezPDF 등)가 설치되어 있다면 기존 뷰어 삭제 후  Acrobat 뷰어로 재 설치 해 주시기 바랍니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q3. 클라이언트 PC 화면에 “강제 검사 확인에 문제가 생겼습니다.” 라는 문구가 나타나는 오류</div>
									<div class="contents">
										<ul>
											<li>클라이언트와 서버간 강제검사 여부를 체크하는 중에 나타나는 문제로, 점검시점 당시 네트워크 상태에 따라 발생될 수 있습니다.</li>
											<li>내부 네트워크 점검 후 동일 증상 발생시  SPK 기술지원 팀에 연락 바랍니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q4. 제품설치 시 “ADLP모듈이 존재하지 않습니다” 라는 메시지가 나타나는 오류</div>
									<div class="contents">
										<ul>
											<li>정상적으로 설치 후 재부팅을 실행하지 않고 SPK를 바로 실행하였을 때 나타나는 문제 입니다. 재부팅 후 SPK실행해주세요.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q5. 신규로 추가된 인력이 있어 사용자 등록 후 클라이언트 설치 시 “등록되지 않는 사업자”라는 메시지가 나타나는 오류</div>
									<div class="contents">
										<ul>
											<li>신규 사용자 등록 및 클라이언트 신규 설치 시 입력해야 되는 사업자ID 입력 오류입니다.</li>
											<li>사업자ID를 대ㆍ소문자를 구분하오니 사업자ID를 다시 학인해 주세요.</li>
										</ul>
									</div>
								</div>
							</div>
							<h3>기타 질문</h3>
							<div>
								<div class="category">
									<div class="title">Q1. 개인정보를 검출 할 수 있는 파일형식은 어떤게 있나요?</div>
									<div class="contents">
										<ul>
											<li>SPK는 문서/압축 파일은 물론 이미지파일 내 개인정보를 검출 할 수 있습니다.
												<ul class="sub-contents">
													<li>- Word Processor : MS Word, 한글(Hwp), Open Office Witter, PDF</li>
													<li>- Spread Sheet : MS Excel, MS Project, Open Office Calc</li>
													<li>- Presentation : MS PowerPoint, Open Office Impress</li>
													<li>- Text : ANSI, ANSII, RTF, Unicode Text, UTF-8, HTML, XTML</li>
													<li>- 압축파일 : LZH, RAR, ZIP, TAR, CAB, ISO, 7-zip</li>
													<li>- 이미지파일 : BMP, JPG, GIF, TIFF, PNG</li>
												</ul>
											</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q2. 개인정보 검사화면의 빠른검사와 일반검사의 차이는 뭔가요?</div>
									<div class="contents">
										<ul>
											<li>빠른검사는 개인정보 검사 시 파일의 확장자만을 확인하여 문서/이미지 파일만 빠르게 검사를 진행합니다. 따라서 파일의 확장자를 예를 들어 실행파일(*.exe)로 변경할 경우 검사대상에서 제외되어 검사가 진행됩니다.</li>
											<li>일반검사는 빠른검사를 체크하지 않을 경우 검사되며 문서/이미지/압축 파일을 선택하여 검사를 진행 할 수 있습니다. 일반검사의 경우 파일의 확장자가 변경되었을 경우에도 파일의 속성값을 확인하여 진행되므로 좀 더 정확한 개인정보검사를 진행하실 수 있습니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q3. 관리자 페이지에서 사용자 정책 변경 후 변경된 정책이 반영되지 않습니다.</div>
									<div class="contents">
										<ul>
											<li>SPK의 정책 및 업데이트는 사용자 로그인시점에 서버에서 정책 및 업데이트 파일 등 정보를 확인하므로, 다음번 로그인 시에 정책이 반영됩니다. 보통의 경우 익일 컴퓨터 부팅 시 자동으로 업데이트가 이루어 집니다.  즉시 사용자 정책 및 업데이트를 원하실 경우 로그오프 및 재 로그인이 필요합니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q4. 관리자 페이지의 글자 깨짐 오류 문의</div>
									<div class="contents">
										<ul>
											<li>관리자 페이지가 정상적으로 동작하기 위해서 권장하는 브라우저는 IE 버전 9 이상,  Chrome 최신버전입니다.</li>
											<li>특히 윈 XP의 경우, IE 버전 8 까지 밖에 설치가 불가능하여 정상적인 관리자 기능을 모두 이용하기 어려울 수 있습니다.</li>
											<li>관리자는 제한된 인원으로 관리되므로 가급적 Chrome 최신버전을 이용해 주시길 부탁 드립니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q5. 제어판에서 사용자가 임의로 프로그램 삭제가 가능한가요?</div>
									<div class="contents">
										<ul>
											<li>현재는 사용자가 임의로 프로그램을 종료할 수 없도록 강제종료 방지기능만 제공되고 있으며, 사용자가 프로그램을 삭제하는 경우는 가능합니다.</li>
											<li>사용자가 클라이언트를 삭제하면 관리자 페이지 에서 프로그램 삭제 여부를 확인 가능합니다.</li>
											<li class="comment" style="margin-top: 10px;">현재 당사 SPK는 개인정보 포함, 중요정보의 문서보안(유출방지)을 기본으로 모든 중요 문서는 암호화되도록 하는 상황을 지향하고 있습니다. 만약 SPK가 정상 동작하지 않을 경우 정상적인 업무가 불가능하여 사용자가 강제로 사용하게 되는 프로그램입니다.</li>
										</ul>
									</div>
								</div>
								<div class="seperator"></div>
								<div class="category">
									<div class="title">Q6. Safe.PrivacyKeeper 제품삭제는 어떻게 하나요?</div>
									<div class="contents">
										<ul>
											<li>우선 사용중인 SPK를 종료합니다.</li>
											<li>사용자 PC의 “제어판 &gt; 프로그램 &gt; 프로그램 및 기능 &gt; Safe.PrivacyKeeper”를 선택하여 제거버튼을 클릭하여 삭제합니다.</li>
											<li>프로그램 삭제 후 재부팅을 실행하면 “C:\Program Files\Safe.PrivacyKeeper” 폴더가 제거 됩니다.</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="ui-layout-south">
		<%@ include file ="/bottom.jsp"%>
	</div>
</body>
</html>