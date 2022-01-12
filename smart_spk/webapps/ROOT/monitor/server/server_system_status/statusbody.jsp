<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.spk.system.*" %>
<%
HashMap<String, String> cpuInfo = CpuInfo.getCpuInfo();
HashMap<String, String> osInfo = OsInfo.getOsInfo();
ArrayList<HashMap<String, String>> fsInfoList = FileSystemInfo.getFileSystemInfoList();
HashMap<String, HashMap<String, String>> memoryInfo = MemoryInfo.getMemoryInfo();
%>
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$( document).tooltip();

		$('#dialog:ui-dialog').dialog('destroy');

<% if ("darkness".equals((String)session.getAttribute("THEMENAME"))) { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"light-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } else { %>
		$('.inner-center .ui-layout-content').mCustomScrollbar({ theme:"dark-2", scrollButtons:{ enable:true }, scrollInertia:0, advanced:{ autoScrollOnFocus: false, updateOnContentResize: true, updateOnBrowserResize: true } });
<% } %>

		$(document).on("mouseenter", ".list-table th", function() { if (typeof $(this).attr('id') != typeof undefined) { if (!$(this).hasClass('ui-state-hover')) { $(this).addClass('ui-state-hover'); } $(this).css({'cursor': 'pointer'}); } else { $(this).css({'cursor': 'default'}); }; });
		$(document).on("mouseleave", ".list-table th", function() { if ($(this).hasClass('ui-state-hover')) { $(this).removeClass('ui-state-hover'); }; $(this).css({'cursor': 'default'}); });
		$(document).on("mouseenter", ".list-table tbody tr", function() { $(this).addClass('list_text_over'); });
		$(document).on("mouseleave", ".list-table tbody tr", function() { $(this).removeClass('list_text_over'); });
	});
//-->
</script>

<div class="inner-center">
	<div class="pane-header">시스템 정보</div>
	<div class="ui-layout-content" style="padding: 20px;">
		<div class="category-title">하드웨어 정보</div>
		<div class="category-contents">
			<div class="field-line">
				<div class="field-title">공급사</div>
				<div class="field-value"><span><%=cpuInfo.get("vendor")%></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">모델명</div>
				<div class="field-value"><span><%=cpuInfo.get("model")%></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">클럭수</div>
				<div class="field-value"><span><%=cpuInfo.get("speed")%> MHz</span></div>
			</div>
			<div class="field-line">
				<div class="field-title">코어수</div>
				<div class="field-value"><span><%=cpuInfo.get("total_cores")%></span></div>
			</div>
		</div>
		<div class="category-title" style="margin-top: 10px;">OS 정보</div>
		<div class="category-contents">
			<div class="field-line">
				<div class="field-title">정보</div>
				<div class="field-value"><span><%=osInfo.get("description")%> (<%=osInfo.get("arch")%>)</span></div>
			</div>
			<div class="field-line">
				<div class="field-title">버전</div>
				<div class="field-value"><span><%=osInfo.get("version")%></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">패치</div>
				<div class="field-value"><span><%=osInfo.get("patch_level")%></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">공급사</div>
				<div class="field-value"><span><%=osInfo.get("vendor")%></span></div>
			</div>
			<div class="field-line">
				<div class="field-title">데이타 모델</div>
				<div class="field-value"><span><%=osInfo.get("data_model")%></span></div>
			</div>
		</div>
		<div class="category-title" style="margin-top: 10px;">파일 시스템 정보</div>
		<div class="category-contents">
			<table class="list-table">
			<thead>
			<tr>
				<th class="ui-state-default">DEV 명</th>
				<th class="ui-state-default" width="10%">전체 크기</th>
				<th class="ui-state-default" width="10%">사용중</th>
				<th class="ui-state-default" width="10%">사용 가능</th>
				<th class="ui-state-default" width="10%">사용비율</th>
				<th class="ui-state-default">Mounted on</th>
				<th class="ui-state-default">유형</th>
			</tr>
			</thead>
			<tbody>
			<%
				String lineStyle = "";
				for (int i=0; i<fsInfoList.size(); i++) {
					if (i%2 != 0)
						lineStyle = "list_even";
					else
						lineStyle = "list_odd";
			%>
			<tr class="<%=lineStyle%>">
				<td><%=fsInfoList.get(i).get("dev_name")%></td>
				<td style="text-align: right;"><%=fsInfoList.get(i).get("total")%></td>
				<td style="text-align: right;"><%=fsInfoList.get(i).get("used")%></td>
				<td style="text-align: right;"><%=fsInfoList.get(i).get("avail")%></td>
				<td style="text-align: right;"><%=fsInfoList.get(i).get("use_percent")%>%</td>
				<td><%=fsInfoList.get(i).get("mounted_on")%></td>
				<td><%=fsInfoList.get(i).get("type")%></td>
			</tr>
			<%
				}
			%>
			</tbody>
			</table>
		</div>
		<div class="category-title" style="margin-top: 10px;">메모리 정보</div>
		<div class="category-contents">
			<table class="list-table">
			<thead>
			<tr>
				<th class="ui-state-default"></th>
				<th class="ui-state-default">전체 크기</th>
				<th class="ui-state-default">사용중</th>
				<th class="ui-state-default">사용 가능</th>
			</tr>
			</thead>
			<tbody>
			<tr class="list_odd">
				<td>메모리</td>
				<td style="text-align: right;"><%=memoryInfo.get("memory").get("total")%></td>
				<td style="text-align: right;"><%=memoryInfo.get("memory").get("used")%></td>
				<td style="text-align: right;"><%=memoryInfo.get("memory").get("free")%></td>
			</tr>
			<tr class="list_even">
				<td>버퍼/캐쉬</td>
				<td style="text-align: right;">-</td>
				<td style="text-align: right;"><%=memoryInfo.get("actual").get("used")%></td>
				<td style="text-align: right;"><%=memoryInfo.get("actual").get("free")%></td>
			</tr>
			<tr class="list_odd">
				<td>스왑</td>
				<td style="text-align: right;"><%=memoryInfo.get("swap").get("total")%></td>
				<td style="text-align: right;"><%=memoryInfo.get("swap").get("used")%></td>
				<td style="text-align: right;"><%=memoryInfo.get("swap").get("free")%></td>
			</tr>
			<tr class="list_even">
				<td>RAM</td>
				<td style="text-align: right;"><%=memoryInfo.get("ram").get("total")%> MB</td>
				<td style="text-align: right;">-</td>
				<td style="text-align: right;">-</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>
</div>
