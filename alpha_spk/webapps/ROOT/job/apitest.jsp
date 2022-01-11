<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Command 테스트</title>
<style>
.list-table { margin: 0; padding: 0; width: 100%; border: none; overflow: hidden; white-space: nowrap; table-layout: fixed; }
.list-table th { margin: 0; padding: 3px 5px; overflow: hidden; font-weight: normal; white-space: nowrap; cursor: pointer; }
.list-table tr { height: 18px; line-height: 18px; color: #444; }
.list-table tr.list_even { background-color: #f4f4f4; }
.list-table tr.list_odd { background-color: transparent; }
.list-table tr.list_text_over { background-color: #e7f4f9; color: #a32403; cursor: pointer; }
.list-table td { padding: 3px 5px; text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }

</style>
<script type="text/javascript" src="/js/jquery-ui-1.10.3/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
<!--
	function sendRequestChangeUserPassword() {
		$.ajax({
			type : "POST",
			url : "/ChangeUserPassword",
			data: $.param({ CompanyId:"COM_1", UserId:"User01", Password:"CQBPvPvoN6XtIq1agXzXt1Lgl+DnyjrdE4n7ngjOGDs=" }),
			dataType: "json",
			cache: false,
			success :  function(data) {
				$("#errorcode").text("오류 코드: " + data.errorcode);
				$("#errormsg").text("오류 메시지: " + data.errormsg);
			}, error: function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR.responseText); 
			} 
		});
	};
//-->
</script>
</head>
<body>
<a href="javascript:sendRequestChangeUserPassword()">사용자 비밀번호 변경 요청</a>&emsp;
<hr style='margin:20px 0'/>
<div id='errorcode'></div>
<div id='errormsg'></div>
<div id='totalrecordcount' style="margin-top:10px;"></div>
<div id="record-list" style="margin-top:10px;">
	<table class="list-table">
		<thead>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>
</body>
</html>