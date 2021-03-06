/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.41
 * Generated at: 2021-10-14 05:23:07 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.text.SimpleDateFormat;
import com.spk.common.constant.CommonConstant;
import com.spk.error.*;
import com.spk.type.*;
import com.spk.util.Util;
import com.spk.util.DbUtil;

public final class down_005fsea_jsp extends org.apache.jasper.runtime.HttpJspBase
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

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1")) {
		response.setHeader("Cache-Control","no-cache");
	}

	String oemString = "";
	String webTitleString = CommonConstant.SERVER_TITLE;
	String imageTitle = "main_logo_spk.png";
	/*************************************************************************
	 * ?????? ?????? ?????? ??????
	 ************************************************************************/
	 HashMap<String, String> mapServerConfig = DbUtil.getServerConfig(session);
	if (!mapServerConfig.isEmpty()) {
		if ("MEDISAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			oemString = "MEDISAFER";
			webTitleString = CommonConstant.MEDISAFER_SERVER_TITLE;
			imageTitle = "main_logo_medisafer.png";
		} else if ("BIZSAFER".equals(mapServerConfig.get("oem").toUpperCase())) {
			oemString = "BIZSAFER";
			webTitleString = CommonConstant.BIZSAFER_SERVER_TITLE;
			imageTitle = "main_logo_bizsafer.png";
		}
	}

	/*************************************************************************
	 * ????????? ???????????? ?????? ????????? ???????????? ??????
	 ************************************************************************/
// 	if (!DbUtil.isSAAccessableAddress(Util.getClientIpAddr(request), session)) {
// 		response.sendRedirect("/login/error_accessdenied.jsp");
// 	}

      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html lang=\"ko\">\r\n");
      out.write("<head>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n");
      out.write("\t<meta http-equiv=\"Expires\" content=\"-1\" />\r\n");
      out.write("\t<meta http-equiv=\"Pragma\" content=\"no-cache\" />\r\n");
      out.write("\t<meta http-equiv=\"Cache-Control\" content=\"No-Cache\" />\r\n");
      out.write("\t<title>");
      out.print(webTitleString);
      out.write("</title>\r\n");
      out.write("\r\n");
 if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { 
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/darkness.css\" media=\"all\" />\r\n");
 } else { 
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/default.css\" media=\"all\" />\r\n");
 } 
      out.write("\r\n");
      out.write("\r\n");
 if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { 
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/js/jquery-ui-1.10.3/themes/darkness/jquery.ui.all.css\" media=\"all\" />\r\n");
 } else { 
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css\" media=\"all\" />\r\n");
 } 
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/jquery-ui-1.10.3/js/jquery-1.9.1.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\">\r\n");
      out.write("\t<!--\r\n");
      out.write("\t\t$(document).ready(function() {\r\n");
      out.write("\t\t\t$('#btnDownload').click( function () {\r\n");
      out.write("\t\t\t\tlocation.href=\"/downfiles/client/ASO_SPK_ASP_SEA.exe\";\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t});\r\n");
      out.write("\t//-->\r\n");
      out.write("\t</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body style=\"background-color: #1e1f23;\">\r\n");
      out.write("\t<div class=\"centered-main\">\r\n");
      out.write("\t\t<div class=\"download-container\">\r\n");
      out.write("\t\t\t<div class=\"main_logo\"><img src=\"/images/");
      out.print(imageTitle);
      out.write("\" /></div>\r\n");
      out.write("\t\t\t<div style=\"margin-top: 45px;\">\r\n");
      out.write("\t\t\t\t<div class=\"field-line\">\r\n");
      out.write("\t\t\t\t\t<div class=\"info-message\">?????? ????????? ????????????<br />?????? ??????????????? ??????????????? ??? ????????????.</div>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t\t<div class=\"button-line\">\r\n");
      out.write("\t\t\t\t<input type=\"button\" id=\"btnDownload\" class=\"download-button\" value=\"?????? ???????????? ????????????\" style=\"width: 370px;\"/>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
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
