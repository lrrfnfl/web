/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.41
 * Generated at: 2021-09-30 05:19:03 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.onestop_005fsea;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_005facastar_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');

	String companyId = request.getParameter("cid");
	String initPwd = request.getParameter("init_pwd");

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ko\" lang=\"ko\">\r\n");
      out.write("<head>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n");
      out.write("\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE9\" />\r\n");
      out.write("\t<meta http-equiv=\"Expires\" content=\"-1\" />\r\n");
      out.write("\t<meta http-equiv=\"Pragma\" content=\"no-cache\" />\r\n");
      out.write("\t<meta http-equiv=\"Cache-Control\" content=\"No-Cache\" />\r\n");
      out.write("\t<title>SECUDOG 원스탑설치가이드</title>\r\n");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/jquery-ui-1.10.3/js/jquery-1.9.1.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/js/scrollbar/jquery.mCustomScrollbar.css\" media=\"all\" />\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/scrollbar/jquery.mCustomScrollbar.concat.min.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/commparam.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\t<link href=\"./style/style.css\" rel='stylesheet' type='text/css'/>\r\n");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\">\r\n");
      out.write("\t<!--\r\n");
      out.write("\t\tvar paramCompanyId = '");
      out.print(request.getParameter("cid"));
      out.write("';\r\n");
      out.write("\r\n");
      out.write("\t\t$(document).ready(function() {\r\n");
      out.write("\r\n");
      out.write("\t\t\tif ((paramCompanyId == 'null') || (paramCompanyId.length == 0)) {\r\n");
      out.write("\t\t\t\t$('#error-message').text('입력된 사업장 정보가 없습니다. 자세한 사항은 담당자에게 문의하세요.');\r\n");
      out.write("\t\t\t\t$('#error-page').show();\r\n");
      out.write("\t\t\t\t$('#main-page').hide();\r\n");
      out.write("\t\t\t} else {\r\n");
      out.write("\t\t\t\tloadCompanyInfo(paramCompanyId);\r\n");
      out.write("\t\t\t\tloadUserList(paramCompanyId);\r\n");
      out.write("// \t\t\t\t$('#error-page').hide();\r\n");
      out.write("// \t\t\t\t$('#main-page').show();\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\t\t$('#btn-searchuser').click( function () {\r\n");
      out.write("\t\t\t\tloadUserList(paramCompanyId);\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\r\n");
      out.write("\t\t\t$(document).on('change', 'input[type=\"radio\"][name=\"selectuser\"]', function() { $(\"#userid\").text($(this).filter(':checked').val()); $(\"#userpwd\").text(\"");
      out.print(initPwd);
      out.write("\"); closeUserId(); });\r\n");
      out.write("\r\n");
      out.write("\t\t\t$('.id-search-table-container').mCustomScrollbar({ theme:\"dark-2\", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });\r\n");
      out.write("\t\t});\r\n");
      out.write("\r\n");
      out.write("\t\topenUserId = function() {\r\n");
      out.write("\t\t\t$('.user-id-container').addClass(\"active\");\r\n");
      out.write("\t\t\t$('.layer').show();\r\n");
      out.write("\t\t};\r\n");
      out.write("\r\n");
      out.write("\t\tcloseUserId = function() {\r\n");
      out.write("\t\t\t$('.user-id-container').removeClass(\"active\");\r\n");
      out.write("\t\t\t$('.layer').hide(); \r\n");
      out.write("\t\t};\r\n");
      out.write("\r\n");
      out.write("\t\tloadCompanyInfo = function(companyId) {\r\n");
      out.write("\r\n");
      out.write("\t\t\tvar postData = getRequestCompanyInfoByIdParam(companyId);\r\n");
      out.write("\r\n");
      out.write("\t\t\t$.ajax({\r\n");
      out.write("\t\t\t\ttype: \"POST\",\r\n");
      out.write("\t\t\t\turl: \"/CommandService\",\r\n");
      out.write("\t\t\t\tdata: $.param({sendmsg : postData}),\r\n");
      out.write("\t\t\t\tdataType: \"xml\",\r\n");
      out.write("\t\t\t\tcache: false,\r\n");
      out.write("\t\t\t\tasync: false,\r\n");
      out.write("\t\t\t\tsuccess: function(data, textStatus, jqXHR) {\r\n");
      out.write("\t\t\t\t\tif ($(data).find('errorcode').text() != \"0000\") {\r\n");
      out.write("\t\t\t\t\t\talert(\"사업장 정보 조회 중 오류가 발생하였습니다.\" + $(data).find('errormsg').text());\r\n");
      out.write("\t\t\t\t\t\treturn false;\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t\tif ($(data).find('companyname').text().length > 0) {\r\n");
      out.write("\t\t\t\t\t\t$(\"#companyid\").text(companyId);\r\n");
      out.write("\t\t\t\t\t\t$(\"#companyname\").text($(data).find('companyname').text());\r\n");
      out.write("\t\t\t\t\t\t$('#error-page').hide();\r\n");
      out.write("\t\t\t\t\t\t$('#main-page').show();\r\n");
      out.write("\t\t\t\t\t} else {\r\n");
      out.write("\t\t\t\t\t\t$('#error-message').text('등록된 사업장이 아닙니다. 자세한 사항은 담당자에게 문의하세요.');\r\n");
      out.write("\t\t\t\t\t\t$('#error-page').show();\r\n");
      out.write("\t\t\t\t\t\t$('#main-page').hide();\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t},\r\n");
      out.write("\t\t\t\terror: function(jqXHR, textStatus, errorThrown) {\r\n");
      out.write("\t\t\t\t\tif (jqXHR.status != 0 && jqXHR.readyState != 0) {\r\n");
      out.write("\t\t\t\t\t\tdisplayAlertDialog(\"사업장 정보 조회\", \"사업장 정보 조회 중 오류가 발생하였습니다.\", jqXHR.statusText + \"(\" + jqXHR.status + \")\");\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t};\r\n");
      out.write("\r\n");
      out.write("\t\tloadUserList = function(companyId) {\r\n");
      out.write("\r\n");
      out.write("\t\t\tvar postData = getRequestUserListParam(companyId,\r\n");
      out.write("\t\t\t\tnull,\r\n");
      out.write("\t\t\t\t$(\"#searchusername\").val(),\r\n");
      out.write("\t\t\t\t\"\",\r\n");
      out.write("\t\t\t\t\"\",\r\n");
      out.write("\t\t\t\t\"\",\r\n");
      out.write("\t\t\t\t\"USERNAME\",\r\n");
      out.write("\t\t\t\t\"\",\r\n");
      out.write("\t\t\t\t\"\",\r\n");
      out.write("\t\t\t\t\"\");\r\n");
      out.write("\r\n");
      out.write("\t\t\t$.ajax({\r\n");
      out.write("\t\t\t\ttype: \"POST\",\r\n");
      out.write("\t\t\t\turl: \"/CommandService\",\r\n");
      out.write("\t\t\t\tdata: $.param({sendmsg : postData}),\r\n");
      out.write("\t\t\t\tdataType: \"xml\",\r\n");
      out.write("\t\t\t\tcache: false,\r\n");
      out.write("\t\t\t\tasync: false,\r\n");
      out.write("\t\t\t\tsuccess: function(data, textStatus, jqXHR) {\r\n");
      out.write("\t\t\t\t\tif ($(data).find('errorcode').text() != \"0000\") {\r\n");
      out.write("\t\t\t\t\t\talert(\"사용자 목록 조회 중 오류가 발생하였습니다.\" + $(data).find('errormsg').text());\r\n");
      out.write("\t\t\t\t\t\treturn false;\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t$('#user-list > tbody:last').empty();\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\tvar trContents = '';\r\n");
      out.write("\t\t\t\t\tif ($(data).find('record').length > 0) {\r\n");
      out.write("\t\t\t\t\t\t$(data).find('record').each( function() {\r\n");
      out.write("\t\t\t\t\t\t\tvar userId = $(this).find('userid').text();\r\n");
      out.write("\t\t\t\t\t\t\tvar userName = $(this).find('username').text();\r\n");
      out.write("\t\t\t\t\t\t\tvar deptName = $(this).find('deptname').text();\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\ttrContents = '<tr>';\r\n");
      out.write("\t\t\t\t\t\t\ttrContents += '<td><input type=\"radio\" name=\"selectuser\" value=\"' + userId + '\" /></td>';\r\n");
      out.write("\t\t\t\t\t\t\ttrContents += '<td>' + userName + '</td>';\r\n");
      out.write("\t\t\t\t\t\t\ttrContents += '<td>' + userId + '</td>';\r\n");
      out.write("\t\t\t\t\t\t\ttrContents += '<td>' + deptName + '</td>';\r\n");
      out.write("\t\t\t\t\t\t\ttrContents += '</tr>';\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t$('#user-list > tbody:last').append(trContents);\r\n");
      out.write("\t\t\t\t\t\t});\r\n");
      out.write("\t\t\t\t\t} else {\r\n");
      out.write("\t\t\t\t\t\ttrContents = '<tr>';\r\n");
      out.write("\t\t\t\t\t\ttrContents += '<td colspan=\"4\" align=\"center\"><div style=\"padding: 10px 0; text-align: center;\">등록된 사용자가 없습니다.</div></td>';\r\n");
      out.write("\t\t\t\t\t\ttrContents += '</tr>';\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t$('#user-list > tbody:last').append(trContents);\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t$('.id-search-table-container').mCustomScrollbar('update');\r\n");
      out.write("\t\t\t\t},\r\n");
      out.write("\t\t\t\terror: function(jqXHR, textStatus, errorThrown) {\r\n");
      out.write("\t\t\t\t\tif (jqXHR.status != 0 && jqXHR.readyState != 0) {\r\n");
      out.write("\t\t\t\t\t\tdisplayAlertDialog(\"사용자 목록 조회\", \"사용자 목록 조회 중 오류가 발생하였습니다.\", jqXHR.statusText + \"(\" + jqXHR.status + \")\");\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t};\r\n");
      out.write("\t//-->\r\n");
      out.write("\t</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<!-- error-page s -->\r\n");
      out.write("<div id=\"error-page\" class=\"error-page\" style=\"display:none;\">\r\n");
      out.write("\t<div class=\"error-page-inner\">\r\n");
      out.write("\t\t<div class=\"error-header\">\r\n");
      out.write("\t\t\t<img src=\"images/error.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t<p><span id=\"error-message\"></span></p>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("<!-- error-page e -->\r\n");
      out.write("\r\n");
      out.write("<!-- user-id-container s -->\r\n");
      out.write("<div class=\"layer\" style=\"display:none;\" onclick=\"closeUserId(); return false; \"></div>\r\n");
      out.write("<div class=\"user-id-container\">\r\n");
      out.write("\t<div class=\"user-id-container-inner\">\r\n");
      out.write("\t\t<div class=\"user-id-close\">\r\n");
      out.write("\t\t\t<a href=\"#\" onclick=\"closeUserId(); return false; \">\r\n");
      out.write("\t\t\t\t<img src=\"images/close.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t</a>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<p class=\"id-search-title\">사용자 목록</p>\r\n");
      out.write("\t\t<div class=\"id-search-container\">\r\n");
      out.write("\t\t\t<div class=\"id-search-info\">\r\n");
      out.write("\t\t\t\t<p>1. 본인의 이름과 부서명을 확인 후 선택  [ 이름으로 검색가능 ] </p>\r\n");
      out.write("\t\t\t\t<p>2. 본인 정보 선택 후  이미지로 정보 출력 확인</p>\r\n");
      out.write("\t\t\t\t<p>3. 해당 아이디와 비밀번호 로그인창에 복사 붙여넣기 후 Sign In 클릭</p>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"id-search-wrap\">\r\n");
      out.write("\t\t\t\t<label for=\"\">\r\n");
      out.write("\t\t\t\t\t<span>사용자명</span>\r\n");
      out.write("\t\t\t\t\t<input type=\"text\" id=\"searchusername\" name=\"searchusername\" />\r\n");
      out.write("\t\t\t\t</label> \r\n");
      out.write("\t\t\t\t<span id=\"btn-searchuser\" class=\"search\" style=\"cursor:pointer;\"><a>검색</a></span>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"id-search-table-container\" style=\"height: 120px; overflow:auto;\">\r\n");
      out.write("\t\t\t\t<div class=\"id-search-table\">\r\n");
      out.write("\t\t\t\t\t<table id=\"user-list\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<colgroup>\r\n");
      out.write("\t\t\t\t\t\t\t<col width=\"10%\"/>\r\n");
      out.write("\t\t\t\t\t\t\t<col width=\"30%\"/>\r\n");
      out.write("\t\t\t\t\t\t\t<col width=\"30%\"/>\r\n");
      out.write("\t\t\t\t\t\t\t<col width=\"30%\"/>\r\n");
      out.write("\t\t\t\t\t\t</colgroup>\r\n");
      out.write("\t\t\t\t\t\t<thead>\r\n");
      out.write("\t\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th>선택</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th>사용자명</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th>사용자ID</th>\r\n");
      out.write("\t\t\t\t\t\t\t\t<th>부서</th>\r\n");
      out.write("\t\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t</thead>\r\n");
      out.write("\t\t\t\t\t\t<tbody>\r\n");
      out.write("\t\t\t\t\t\t</tbody>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("<!-- \t\t\t\t<div class=\"paging\"> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">처음</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">이전</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span class=\"present\"><a href=\"#\">1</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">2</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">3</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">4</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">다음</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t\t<span><a href=\"#\">마지막</a></span> -->\r\n");
      out.write("<!-- \t\t\t\t</div> -->\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("<!-- user-id-container e -->\r\n");
      out.write("\r\n");
      out.write("<div id=\"main-page\" class=\"wrap\" style=\"display:none;\">\r\n");
      out.write("\t<div class=\"wrap-inner\">\r\n");
      out.write("\t\t<div class=\"header\">\r\n");
      out.write("\t\t\t<div class=\"header-inner\">\r\n");
      out.write("\t\t\t\t<a href=\"index.html\"><img src=\"images/logo.png\" alt=\"\"/></a>\r\n");
      out.write("\t\t\t\t<span><img src=\"images/header-txt1.png\" alt=\"\"/></span>\r\n");
      out.write("\t\t\t\t<span class=\"position-right\"><img src=\"images/header-txt.png\" alt=\"\"/></span>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div class=\"container\">\r\n");
      out.write("\t\t\t<!-- corp-info s -->\r\n");
      out.write("\t\t\t<div class=\"corp-info\">\r\n");
      out.write("\t\t\t\t<p class=\"block-title\">사업장 정보</p>\r\n");
      out.write("\t\t\t\t<div class=\"corp-table\">\r\n");
      out.write("\t\t\t\t\t<div class=\"corp-row corp-title\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"corp-c1\">사업자명</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"corp-c2\">사업자 ID</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"corp-row\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"corp-c1\"><span id=\"companyname\" /></div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"corp-c2\"><span id=\"companyid\" /></div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<!-- corp-info e -->\r\n");
      out.write("\r\n");
      out.write("\t\t\t<div class=\"download\">\r\n");
      out.write("\t\t\t\t<p class=\"block-title\">설명서 다운로드</p>\r\n");
      out.write("\t\t\t\t<a href=\"/downfiles/manuals/SPK_RK_admin guide.zip\">\r\n");
      out.write("\t\t\t\t\t<img src=\"images/download_admin_guide.png\" alt=\"\" style=\"width: 345px;\" />\r\n");
      out.write("\t\t\t\t</a>\r\n");
      out.write("\t\t\t\t<a href=\"/downfiles/manuals/SPK_RK_user guide.zip\">\r\n");
      out.write("\t\t\t\t\t<img src=\"images/download_user_guide.png\" alt=\"\" style=\"width: 345px; margin-left: 5px;\"/>\r\n");
      out.write("\t\t\t\t</a>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"download\">\r\n");
      out.write("\t\t\t\t<p class=\"block-title\">클라이언트 설치 안내</p>\r\n");
      out.write("\t\t\t\t<a href=\"/downfiles/client/ASO_ACASTAR.exe\">\r\n");
      out.write("\t\t\t\t\t<img src=\"images/download_btn.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t</a>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t<!-- guide-wrap s -->\r\n");
      out.write("\t\t\t<div class=\"guide-wrap\">\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>1</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>클라이언트 다운로드 페이지에서 다운로드 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size1\"><img src=\"images/guide_1.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>2</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>브라우저 하단에서 \"실행\"버튼 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size2\"><img src=\"images/guide_2.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>3</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>설치 시작 알림 \"예\"를 눌러 설치 시작</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size3\"><img src=\"images/guide_3.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>4</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>설치 완료 후 설치 완료 확인 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size3\"><img src=\"images/guide_4.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>5</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>바탕화면에 실행아이콘 생성 확인 후 더블 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size3\"><img src=\"images/guide_5.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>6</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>프로그램 시작시 사업장 아이디 \"<span class=\"corp-id-name\">");
      out.print(request.getParameter("cid"));
      out.write("</span>\"  입력 후 \"확인\" 버튼 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size3\"><img src=\"images/guide_6.png\" /></p>\r\n");
      out.write("\t\t\t\t\t\t<p class=\"corp-id-input\">");
      out.print(request.getParameter("cid"));
      out.write("</p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>7</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>본인 아이디, 비밀번호 입력 후 \" Sign In \" 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"id-search-btn\">\r\n");
      out.write("\t\t\t\t\t\t\t<a href=\"#\" onclick=\"openUserId(); return false; \">\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"images/search.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t\t\t\t</a>\r\n");
      out.write("\t\t\t\t\t\t</p>\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size3\"><img src=\"images/guide_7.png\" /></p>\r\n");
      out.write("\t\t\t\t\t\t<p class=\"user-id-input\"><span id=\"userid\">&nbsp;</span></p>\r\n");
      out.write("\t\t\t\t\t\t<p class=\"user-pw-input\"><span id=\"userpwd\">&nbsp;</span></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>8</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>최초로그인 시 비밀번호 변경 \"확인\" 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size1\"><img src=\"images/guide_8.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>9</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>현재비밀번호 입력 - 새 비밀번호 입력 후 \"설정 저장\" 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size2\"><img src=\"images/guide_9.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"guide-block\">\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-instruction\">\r\n");
      out.write("\t\t\t\t\t\t<div class=\"numbering\">\r\n");
      out.write("\t\t\t\t\t\t\t<span>10</span>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t<div class=\"guide-text\">\r\n");
      out.write("\t\t\t\t\t\t\t<p>시스템설정 - 기본설정 에서 아래의 옵션 <b>모두 체크</b> 후 \"설정 저장\" 클릭</p>\r\n");
      out.write("\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t<div class=\"guide-img\">\r\n");
      out.write("\t\t\t\t\t\t<p class=\"img-size2\"><img src=\"images/guide_10.png\" /></p>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t<div class=\"complete-wrap\">\r\n");
      out.write("\t\t\t\t\t<img src=\"images/complete.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t\t<p>\r\n");
      out.write("\t\t\t\t\t\t<a href=\" https://www.secudog.com:20000\" target=\"_blank\"> \r\n");
      out.write("\t\t\t\t\t\t\t<img src=\"images/link_btn_SPK.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t\t\t</a>\r\n");
      out.write("\t\t\t\t\t\t<a href=\" https://www.secudog.com:12600\" target=\"_blank\"> \r\n");
      out.write("\t\t\t\t\t\t\t<img src=\"images/link_btn_RK.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t\t\t</a>\r\n");
      out.write("\t\t\t\t\t</p>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<!-- guide-wrap e -->\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\r\n");
      out.write("\t\t<!------------------------------------------------------ footer s -->\r\n");
      out.write("\t\t\t<div class=\"footer-wrap\">\r\n");
      out.write("\t\t\t\t<div class=\"footer\">\r\n");
      out.write("\t\t\t\t\t<div class=\"footer-inner\">\r\n");
      out.write("\t\t\t\t\t\t\t<div class=\"footer-left\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<img src=\"images/footer_logo.png\" alt=\"\"/>\r\n");
      out.write("\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t<div class=\"footer-center\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<div class=\"footer-center-sitemap\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<span><a href=\"https://www.secudog.com/secudog/privacy.do\" target=\"_blank\">개인정보취급방침</a></span>   \r\n");
      out.write("\t\t\t\t\t\t\t\t\t<a href=\"https://www.secudog.com/secudog/terms.do\" target=\"_blank\">이용약관</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<a href=\"#\">책임의 한계와 법적고지</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<a href=\"#\">고객서비스헌장</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<a href=\"#\">명의도용 알람서비스</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<a href=\"#\">스팸방지</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t<div class=\"footer-center-info\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t서울시특별시 구로구 디지털로 272(구로동, 한신아이티타워 807호)  |  대표이사 고준용  |  사업자등록번호 : 111-88-01739<br/>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t고객센터 가입문의 국번 없이 070-4048-6034\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t<div class=\"footer-right\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<select name=\"\" title=\"\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<option value=\"\" selected=\"selected\">관련사이트바로가기</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<option value=\"\">-</option>\r\n");
      out.write("\t\t\t\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t<!------------------------------------------------------ footer e -->\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}