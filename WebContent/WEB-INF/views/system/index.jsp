<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>CourseManagement</title>
    <link rel="shortcut icon" href="favicon.ico"/>
	<link rel="bookmark" href="favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/default.css" />
    <link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/icon.css" />
    <script type="text/javascript" src="../resources/admin/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="../resources/admin/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src='../resources/admin/easyui/js/outlook2.js'> </script>
    <script type="text/javascript">
    
	 var _menus = {"menus":[
						<c:if test="${admin.role == 'admin'}">
						{"menuid":"1","icon":"","menuname":"User Management",
							"menus":[
									{"menuid":"11","menuname":"user list","icon":"icon-user-teacher","url":"../user/list"}
								]
						},
						</c:if>
						{"menuid":"2","icon":"","menuname":"Student/Professor",
							"menus":[
									{"menuid":"21","menuname":"student list","icon":"icon-user-student","url":"../student/list"},
									{"menuid":"22","menuname":"professor list","icon":"icon-user-teacher","url":"../professor/list"},
								]
						},
						{"menuid":"3","icon":"","menuname":"Course Information",
							"menus":[
									{"menuid":"31","menuname":"course list","icon":"icon-exam","url":"../course/list"},
									{"menuid":"33","menuname":"grade list","icon":"icon-exam","url":"../grade/list"},
								]
						},
				]};


    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
	<noscript>
		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
		    <img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background:  #7f99be;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="float:right; padding-right:20px;" class="head">Hello!&nbsp;<span style="color:black; font-weight:bold;">${admin.username}&nbsp;</span>&nbsp;&nbsp;
        <a href="login_out" id="loginOut">Logout</a></span>
        <span style="padding-left:10px; font-size: 16px; ">Course Information System</span>
    </div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        <div class="footer">Copyright &copy; Yue Pan</div>
    </div>
    <div region="west" hide="true" split="true" title="Menu" style="width:180px;" id="west">
	<div id="nav" class="easyui-accordion" fit="true" border="false"></div>
	
    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
			<jsp:include page="welcome.jsp" />
		</div>
    </div>
	
</body>
</html>