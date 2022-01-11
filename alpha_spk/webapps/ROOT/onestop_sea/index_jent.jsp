<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String companyId = request.getParameter("cid");
	String initPwd = request.getParameter("init_pwd");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<title>SECUDOG 원스탑설치가이드</title>

	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>

	<link rel="stylesheet" type="text/css" href="/js/scrollbar/jquery.mCustomScrollbar.css" media="all" />
	<script type="text/javascript" src="/js/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

	<script type="text/javascript" src="/js/commparam.js"></script>

	<link href="./style/style.css" rel='stylesheet' type='text/css'/>

	<script type="text/javascript">
	<!--
		var paramCompanyId = '<%=request.getParameter("cid")%>';

		$(document).ready(function() {

			if ((paramCompanyId == 'null') || (paramCompanyId.length == 0)) {
				$('#error-message').text('입력된 사업장 정보가 없습니다. 자세한 사항은 담당자에게 문의하세요.');
				$('#error-page').show();
				$('#main-page').hide();
			} else {
				loadCompanyInfo(paramCompanyId);
				loadUserList(paramCompanyId);
// 				$('#error-page').hide();
// 				$('#main-page').show();
			}

			$('#btn-searchuser').click( function () {
				loadUserList(paramCompanyId);
			});

			$(document).on('change', 'input[type="radio"][name="selectuser"]', function() { $("#userid").text($(this).filter(':checked').val()); $("#userpwd").text("<%=initPwd%>"); closeUserId(); });

			$('.id-search-table-container').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
		});

		openUserId = function() {
			$('.user-id-container').addClass("active");
			$('.layer').show();
		};

		closeUserId = function() {
			$('.user-id-container').removeClass("active");
			$('.layer').hide(); 
		};

		loadCompanyInfo = function(companyId) {

			var postData = getRequestCompanyInfoByIdParam(companyId);

			$.ajax({
				type: "POST",
				url: "/CommandService",
				data: $.param({sendmsg : postData}),
				dataType: "xml",
				cache: false,
				async: false,
				success: function(data, textStatus, jqXHR) {
					if ($(data).find('errorcode').text() != "0000") {
						alert("사업장 정보 조회 중 오류가 발생하였습니다." + $(data).find('errormsg').text());
						return false;
					}
					if ($(data).find('companyname').text().length > 0) {
						$("#companyid").text(companyId);
						$("#companyname").text($(data).find('companyname').text());
						$('#error-page').hide();
						$('#main-page').show();
					} else {
						$('#error-message').text('등록된 사업장이 아닙니다. 자세한 사항은 담당자에게 문의하세요.');
						$('#error-page').show();
						$('#main-page').hide();
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("사업장 정보 조회", "사업장 정보 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		};

		loadUserList = function(companyId) {

			var postData = getRequestUserListParam(companyId,
				null,
				$("#searchusername").val(),
				"",
				"",
				"",
				"USERNAME",
				"",
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
						alert("사용자 목록 조회 중 오류가 발생하였습니다." + $(data).find('errormsg').text());
						return false;
					}

					$('#user-list > tbody:last').empty();

					var trContents = '';
					if ($(data).find('record').length > 0) {
						$(data).find('record').each( function() {
							var userId = $(this).find('userid').text();
							var userName = $(this).find('username').text();
							var deptName = $(this).find('deptname').text();

							trContents = '<tr>';
							trContents += '<td><input type="radio" name="selectuser" value="' + userId + '" /></td>';
							trContents += '<td>' + userName + '</td>';
							trContents += '<td>' + userId + '</td>';
							trContents += '<td>' + deptName + '</td>';
							trContents += '</tr>';

							$('#user-list > tbody:last').append(trContents);
						});
					} else {
						trContents = '<tr>';
						trContents += '<td colspan="4" align="center"><div style="padding: 10px 0; text-align: center;">등록된 사용자가 없습니다.</div></td>';
						trContents += '</tr>';

						$('#user-list > tbody:last').append(trContents);
					}

					$('.id-search-table-container').mCustomScrollbar('update');
				},
				error: function(jqXHR, textStatus, errorThrown) {
					if (jqXHR.status != 0 && jqXHR.readyState != 0) {
						displayAlertDialog("사용자 목록 조회", "사용자 목록 조회 중 오류가 발생하였습니다.", jqXHR.statusText + "(" + jqXHR.status + ")");
					}
				}
			});
		};
	//-->
	</script>
</head>
<body>
<!-- error-page s -->
<div id="error-page" class="error-page" style="display:none;">
	<div class="error-page-inner">
		<div class="error-header">
			<img src="images/error.png" alt=""/>
			<p><span id="error-message"></span></p>
		</div>
	</div>
</div>
<!-- error-page e -->

<!-- user-id-container s -->
<div class="layer" style="display:none;" onclick="closeUserId(); return false; "></div>
<div class="user-id-container">
	<div class="user-id-container-inner">
		<div class="user-id-close">
			<a href="#" onclick="closeUserId(); return false; ">
				<img src="images/close.png" alt=""/>
			</a>
		</div>
		<p class="id-search-title">사용자 목록</p>
		<div class="id-search-container">
			<div class="id-search-info">
				<p>1. 본인의 이름과 부서명을 확인 후 선택  [ 이름으로 검색가능 ] </p>
				<p>2. 본인 정보 선택 후  이미지로 정보 출력 확인</p>
				<p>3. 해당 아이디와 비밀번호 로그인창에 복사 붙여넣기 후 Sign In 클릭</p>
			</div>
			<div class="id-search-wrap">
				<label for="">
					<span>사용자명</span>
					<input type="text" id="searchusername" name="searchusername" />
				</label> 
				<span id="btn-searchuser" class="search" style="cursor:pointer;"><a>검색</a></span>
			</div>
			<div class="id-search-table-container" style="height: 120px; overflow:auto;">
				<div class="id-search-table">
					<table id="user-list" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="10%"/>
							<col width="30%"/>
							<col width="30%"/>
							<col width="30%"/>
						</colgroup>
						<thead>
							<tr>
								<th>선택</th>
								<th>사용자명</th>
								<th>사용자ID</th>
								<th>부서</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
<!-- 				<div class="paging"> -->
<!-- 					<span><a href="#">처음</a></span> -->
<!-- 					<span><a href="#">이전</a></span> -->
<!-- 					<span class="present"><a href="#">1</a></span> -->
<!-- 					<span><a href="#">2</a></span> -->
<!-- 					<span><a href="#">3</a></span> -->
<!-- 					<span><a href="#">4</a></span> -->
<!-- 					<span><a href="#">다음</a></span> -->
<!-- 					<span><a href="#">마지막</a></span> -->
<!-- 				</div> -->
			</div>
		</div>
	</div>
</div>
<!-- user-id-container e -->

<div id="main-page" class="wrap" style="display:none;">
	<div class="wrap-inner">
		<div class="header">
			<div class="header-inner">
				<a href="index.html"><img src="images/logo.png" alt=""/></a>
				<span><img src="images/header-txt1.png" alt=""/></span>
				<span class="position-right"><img src="images/header-txt.png" alt=""/></span>
			</div>
		</div>
		<div class="container">
			<!-- corp-info s -->
			<div class="corp-info">
				<p class="block-title">사업장 정보</p>
				<div class="corp-table">
					<div class="corp-row corp-title">
						<div class="corp-c1">사업자명</div>
						<div class="corp-c2">사업자 ID</div>
					</div>
					<div class="corp-row">
						<div class="corp-c1"><span id="companyname" /></div>
						<div class="corp-c2"><span id="companyid" /></div>
					</div>
				</div>
			</div>
			<!-- corp-info e -->

			<div class="download">
				<p class="block-title">클라이언트 설치 안내</p>
				<a href="/downfiles/client/ASO_JENT.exe">
					<img src="images/download_btn.png" alt=""/>
				</a>
			</div>

			<!-- guide-wrap s -->
			<div class="guide-wrap">
				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>1</span>
						</div>
						<div class="guide-text">
							<p>클라이언트 다운로드 페이지에서 다운로드 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size1"><img src="images/guide_1.png" /></p>
					</div>
				</div>
				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>2</span>
						</div>
						<div class="guide-text">
							<p>브라우저 하단에서 "실행"버튼 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size2"><img src="images/guide_2.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>3</span>
						</div>
						<div class="guide-text">
							<p>설치 시작 알림 "예"를 눌러 설치 시작</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size3"><img src="images/guide_3.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>4</span>
						</div>
						<div class="guide-text">
							<p>설치 완료 후 설치 완료 확인 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size3"><img src="images/guide_4.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>5</span>
						</div>
						<div class="guide-text">
							<p>바탕화면에 실행아이콘 생성 확인 후 더블 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size3"><img src="images/guide_5.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>6</span>
						</div>
						<div class="guide-text">
							<p>프로그램 시작시 사업장 아이디 "<span class="corp-id-name"><%=request.getParameter("cid")%></span>"  입력 후 "확인" 버튼 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size3"><img src="images/guide_6.png" /></p>
						<p class="corp-id-input"><%=request.getParameter("cid")%></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>7</span>
						</div>
						<div class="guide-text">
							<p>본인 아이디, 비밀번호 입력 후 " Sign In " 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="id-search-btn">
							<a href="#" onclick="openUserId(); return false; ">
								<img src="images/search.png" alt=""/>
							</a>
						</p>
						<p class="img-size3"><img src="images/guide_7.png" /></p>
						<p class="user-id-input"><span id="userid">&nbsp;</span></p>
						<p class="user-pw-input"><span id="userpwd">&nbsp;</span></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>8</span>
						</div>
						<div class="guide-text">
							<p>최초로그인 시 비밀번호 변경 "확인" 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size1"><img src="images/guide_8.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>9</span>
						</div>
						<div class="guide-text">
							<p>현재비밀번호 입력 - 새 비밀번호 입력 후 "설정 저장" 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size2"><img src="images/guide_9.png" /></p>
					</div>
				</div>

				<div class="guide-block">
					<div class="guide-instruction">
						<div class="numbering">
							<span>10</span>
						</div>
						<div class="guide-text">
							<p>시스템설정 - 기본설정 에서 아래의 옵션 <b>모두 체크</b> 후 "설정 저장" 클릭</p>
						</div>
					</div>
					<div class="guide-img">
						<p class="img-size2"><img src="images/guide_10.png" /></p>
					</div>
				</div>

				<div class="complete-wrap">
					<img src="images/complete.png" alt=""/>
					<p>
						<a href=" https://www.secudog.com:20000" target="_blank"> 
							<img src="images/link_btn_SPK.png" alt=""/>
						</a>
						<a href=" https://www.secudog.com:12600" target="_blank"> 
							<img src="images/link_btn_RK.png" alt=""/>
						</a>
					</p>
				</div>

			</div>
			<!-- guide-wrap e -->
		</div>

		<!------------------------------------------------------ footer s -->
			<div class="footer-wrap">
				<div class="footer">
					<div class="footer-inner">
							<div class="footer-left">
								<img src="images/footer_logo.png" alt=""/>
							</div>
							<div class="footer-center">
								<div class="footer-center-sitemap">
									<span><a href="https://www.secudog.com/secudog/privacy.do" target="_blank">개인정보취급방침</a></span>   
									<a href="https://www.secudog.com/secudog/terms.do" target="_blank">이용약관</a>
									<a href="#">책임의 한계와 법적고지</a>
									<a href="#">고객서비스헌장</a>
									<a href="#">명의도용 알람서비스</a>
									<a href="#">스팸방지</a>
								</div>
								<div class="footer-center-info">
									서울시특별시 구로구 디지털로 272(구로동, 한신아이티타워 807호)  |  대표이사 고준용  |  사업자등록번호 : 111-88-01739<br/>
									고객센터 가입문의 국번 없이 070-4048-6034
								</div>
							</div>
							<div class="footer-right">
								<select name="" title="">
									<option value="" selected="selected">관련사이트바로가기</option>
									<option value="">-</option>
								</select>
							</div>
					</div>
				</div>
			</div>
		<!------------------------------------------------------ footer e -->
	</div>
</div>
</body>
</html>