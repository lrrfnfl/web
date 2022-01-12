/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.41
 * Generated at: 2021-09-30 02:35:44 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.HashMap;
import com.spk.common.constant.CommonConstant;
import com.spk.util.Util;
import com.spk.util.DbUtil;

public final class error_jsp extends org.apache.jasper.runtime.HttpJspBase
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

      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ko\" lang=\"ko\">\r\n");
      out.write("<head>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n");
      out.write("\t<meta http-equiv=\"Expires\" content=\"-1\" />\r\n");
      out.write("\t<meta http-equiv=\"Pragma\" content=\"no-cache\" />\r\n");
      out.write("\t<meta http-equiv=\"Cache-Control\" content=\"No-Cache\" />\r\n");
      out.write("\t<title>");
      out.print(webTitle);
      out.write("</title>\r\n");
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/default.css\" media=\"all\" />\r\n");
      out.write("\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css\" media=\"all\" />\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/jquery-ui-1.10.3/js/jquery-1.9.1.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js\"></script>\r\n");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\">\r\n");
      out.write("\t<!--\r\n");
      out.write("\t\tvar g_objDivMessage;\r\n");
      out.write("\r\n");
      out.write("\t\t$(document).ready(function() {\r\n");
      out.write("\t\t\tg_objDivMessage = $('#div-message');\r\n");
      out.write("\t\t\tg_objDivMessage.centerToWindow();\r\n");
      out.write("\r\n");
      out.write("\t\t\t$(window).resize(function() {\r\n");
      out.write("\t\t\t\tg_objDivMessage.centerToWindow();\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t});\r\n");
      out.write("\r\n");
      out.write("\t\t$.fn.centerToWindow = function() {\r\n");
      out.write("\t\t\tvar obj = $(this);\r\n");
      out.write("\t\t\tvar obj_width = $(this).outerWidth(true);\r\n");
      out.write("\t\t\tvar obj_height = $(this).outerHeight(true);\r\n");
      out.write("\t\t\tvar window_width = window.innerWidth ? window.innerWidth : $(window).width();\r\n");
      out.write("\t\t\tvar window_height = window.innerHeight ? window.innerHeight : $(window).height();\r\n");
      out.write("\r\n");
      out.write("\t\t\tobj.css({\r\n");
      out.write("\t\t\t\t\"position\" : \"fixed\",\r\n");
      out.write("\t\t\t\t\"top\" : ((window_height / 2) - (obj_height / 2))+\"px\",\r\n");
      out.write("\t\t\t\t\"left\" : ((window_width / 2) - (obj_width / 2))+\"px\"\r\n");
      out.write("\t\t\t});\r\n");
      out.write("\t\t};\r\n");
      out.write("\t//-->\r\n");
      out.write("\t</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body style=\"background-color: #fff\">\r\n");
      out.write("\t<div id=\"div-message\" class=\"ui-widget\" style=\"width: 50%; text-align: center; border: 4px double #922727; border-radius: 12px; -webkit-box-shadow:0px 0px 5px 5px #922727; -moz-box-shadow:0px 0px 5px 5px #922727; box-shadow:0px 0px 5px 5px #922727;\">\r\n");
      out.write("\t\t<div style=\"margin: 20px auto;\">\r\n");
      out.write("\t\t\t<div class=\"ui-state-error ui-corner-all\" style=\"padding: 0 .7em;\">\r\n");
      out.write("\t\t\t\t<div style=\"font-size: 14px;\"><strong>처리중 오류가 발생하셨습니다.</strong></div>\r\n");
      out.write("\t\t\t\t<div style=\"margin-top: 8px; font-size: 12px;\"><span>자세한 사항은 시스템 관리자에게 문의하시기 바랍니다.</span></div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\r\n");
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
