<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" import="java.util.*" import="java.net.*" import="com.spk.util.*" import="org.apache.commons.io.FilenameUtils"%>
<%
	String saveFilename = request.getParameter("savefilename");
	String filePath = request.getParameter("filepath");
	String fileDeleteAfterDownload = request.getParameter("filedeleteafterdownload");

	BufferedInputStream input = null;
	BufferedOutputStream output = null;

	boolean isSuccess = true;
	String errorMsg = "";

	try {
		System.out.println("savefilename=[" + saveFilename + "]");
		System.out.println("filepath=[" + filePath + "]");

		/*********************************************************************
		 * 로그인 상태의 다운로드 요청인지 검사
		 ********************************************************************/
		System.out.println("AdminType=" + (String)session.getAttribute("ADMINTYPE"));

		if (Util.isEmpty((String)session.getAttribute("ADMINTYPE"))) {
			System.out.println("Session is invalid.");
			isSuccess = false;
			errorMsg = "다운로드는 관리자 로그인 후 가능합니다.";
		}

		/*********************************************************************
		 * 입력 파라미터가 유효한지 검사
		 ********************************************************************/
		if (isSuccess) {
			if (Util.isEmpty(saveFilename) || Util.isEmpty(filePath)) {
				System.out.println("Input parameter error.]");
				System.out.println("savefilename=[" + saveFilename + "]");
				System.out.println("filepath=[" + filePath + "]");
				isSuccess = false;
				errorMsg = "입력 파라미터가 유효하지 않습니다.";
			}
		}

		/*********************************************************************
		 * 유효한 다운로드 경로 요청인지 검사
		 ********************************************************************/
		if (isSuccess) {
			ServletContext servletContext = request.getSession().getServletContext();
			String contextDownloadPath = servletContext.getInitParameter("download_path");
			if (!contextDownloadPath.startsWith("/")) contextDownloadPath = "/" + contextDownloadPath;

			if (!filePath.startsWith(contextDownloadPath)) {
				System.out.println("Download path is invalid.");
				System.out.println("filePath=" + filePath);
				System.out.println("contextDownloadPath=" + contextDownloadPath);
				isSuccess = false;
				errorMsg = "다운로드가 불가능한 경로입니다.";
			} else {
				System.out.println("FilenameUtils.getPath(filePath)=" + FilenameUtils.getPath(filePath));
				if (FilenameUtils.getPath(filePath).indexOf(".") > 0) {
					System.out.println("Download path is invalid.");
					System.out.println("filePath=" + filePath);
					System.out.println("contextDownloadPath=" + contextDownloadPath);
					isSuccess = false;
					errorMsg = "다운로드가 불가능한 경로입니다.";
				}
			}
		}

		/*********************************************************************
		 * 다운로드 처리
		 ********************************************************************/
		if (isSuccess) {
			String fpath = getServletContext().getRealPath(filePath);
			if (!Util.isEmpty(fpath)) {
				File file = new File(fpath);
				if (file.exists()) {
					response.reset();
					if (Util.getBrowser(request).equals("Chrome")){
						if (saveFilename.matches(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
							response.setHeader("Content-Disposition", "attachment; filename=\""+new String(saveFilename.getBytes("UTF-8"), "ISO-8859-1")+"\"");
						} else {
							response.setHeader("Content-Disposition", "attachment; filename=\""+saveFilename+"\"");
						}
					} else {
						response.setHeader("Content-Disposition:", Util.getDisposition(saveFilename, Util.getBrowser(request)));
					}
					response.setHeader("Content-Length", ""+ file.length());
					response.setHeader("Content-Transfer-Encoding", "binary");
					response.setHeader("Pragma", "no-cache");
					response.setHeader("Expires", "-1;");

					input = new BufferedInputStream(new FileInputStream(file));
					byte buffer[] = new byte[1024];
					int len = 0;
					out.clear();
					out.flush();
					output = new BufferedOutputStream(response.getOutputStream());
					while ((len = input.read(buffer)) > 0){
						output.write(buffer,0,len);
					}
					input.close();

					if (!"false".equals(fileDeleteAfterDownload)) {
						if (!file.delete())
							System.out.println("Fail to delete a file. [" + fpath + "]");
					}

					isSuccess = true;
				} else {
					System.out.println("File not found. [" + fpath + "]");
					isSuccess = false;
					errorMsg = "요청한 다운로드 파일이 존재하지 않습니다.";
				}
			} else {
				System.out.println("Invalid path. [" + filePath + "]");
				isSuccess = false;
				errorMsg = "다운로드 경로가 유효하지 않습니다.";
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally{
		if (null != input) try { input.close(); } catch (Exception e) { e.printStackTrace(); }
		if (null != output) try { output.close(); } catch (Exception e) { e.printStackTrace(); }
	}

	if (!isSuccess) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />

	<link rel="stylesheet" type="text/css" href="/css/default.css" media="all" />

	<link rel="stylesheet" type="text/css" href="/js/jquery-ui-1.10.3/css/custom-theme/jquery-ui-1.10.3.custom.css" media="all" />
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.js"></script>

	<script type="text/javascript">
	<!--
		$(document).ready(function() {
			$('#div-message').centerToWindow();

			$(window).resize(function() {
				$('#div-message').centerToWindow();
			});
		});

		$.fn.centerToWindow = function() {
			var obj = $(this);
			var obj_width = $(this).outerWidth(true);
			var obj_height = $(this).outerHeight(true);
			var window_width = window.innerWidth ? window.innerWidth : $(window).width();
			var window_height = window.innerHeight ? window.innerHeight : $(window).height();
			obj.css({
				"position" : "fixed",
				"top" : ((window_height / 2) - (obj_height / 2))+"px",
				"left" : ((window_width / 2) - (obj_width / 2))+"px"
			});
		};
	//-->
	</script>
</head>
<body style="background-color: #fff">
	<div id="div-message" class="ui-widget" style="width: 50%; text-align: center; border: 4px double #922727; border-radius: 12px; -webkit-box-shadow:0px 0px 5px 5px #922727; -moz-box-shadow:0px 0px 5px 5px #922727; box-shadow:0px 0px 5px 5px #922727;">
		<div style="margin: 20px auto;">
			<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
				<div style="font-size: 14px;"><strong>다운로드 중 오류가 발생하셨습니다.</strong></div>
				<div style="margin-top: 8px; font-size: 12px;"><span><%=errorMsg%></span></div>
			</div>
		</div>
	</div>
</body>
</html>
<%
	}
%>