<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>user list</title>
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/demo.css">
	<script type="text/javascript" src="../resources/admin/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="../resources/admin/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="../resources/admin/easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		var table;
		
		// retrieve dataList and display it in datagrid
	    $('#dataList').datagrid({ 
	        title:'user list', 
	        iconCls:'icon-more',
	        border: true, 
	        collapsible:false,
	        fit: true,		//auto fit size 
	        method: "post",
	        // url: use &t and time to avoid browser cachine
	        url:"get_list&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,
	        pagination:true,
	        rownumbers:true, 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},   
 		        {field:'username',title:'username',width:150},
 		        {field:'password',title:'password',width:100},
	 		]], 
	        toolbar: "#toolbar"
	    }); 
		
	    // pagination
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,	// defaut page size
	        pageList: [10,20,30,50,100],	//optional page size 
	        beforePageText: 'page', 
	        afterPageText: ' of {pages}', 
	        displayMsg: 'current rows from {from} to {to}, total {total} rows', 
	    });
	    
	    // buttons: add, edit and delete
	    $("#add").click(function(){
	    	table = $("#addTable");
	    	$("#addDialog").dialog("open");
	    });
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.number;
            	});
            	$.messager.confirm("消息提醒", "将删除与user相关的所有数据，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "TeacherServlet?method=DeleteTeacher",
							data: {ids: ids,numbers:numbers},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("消息提醒","删除失败!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	    
	  	// dialog of adding
	    $("#addDialog").dialog({
	    	title: "add an user",
	    	width: 450,
	    	height: 200,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [				
	    		{
					text:'confirm',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("warning message","form incomplete","warning");
							return;
						} else{
							var data = $("#addForm").serialize();
							$.ajax({
								type: "post",
								url: "add",
								data: data,
								dataType:'json',
								success: function(data){
									if(data.type == "success"){
										$.messager.alert("message","add a user successfully","info");
										$("#addDialog").dialog("close");
										// empty old form
										$("#add_username").textbox('setValue', "");
										$("#add_password").textbox('setValue', "");
										//reload datagrid
							  			$('#dataList').datagrid("reload");										
									} else{
										$.messager.alert("message","adding fail","warning");
										return;
									}
								}
							});
						}
					}
				},				
			],
			onClose: function(){
				// empty form
				$("#add_username").textbox('setValue', "");
				$("#add_password").textbox('setValue', "");	
			}
	    });
	  	
	  	//编辑信息
	  	$("#editDialog").dialog({
	  		title: "修改user信息",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
				{
					text:'设置课程',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						$("#chooseCourseDialog").dialog("open");
					}
				},
	    		{
					text:'提交',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							var chooseCourse = [];
							$(table).find(".chooseTr").each(function(){
								var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
								var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
								var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
								var course = gradeid+"_"+clazzid+"_"+courseid;
								chooseCourse.push(course);
							});
							var id = $("#dataList").datagrid("getSelected").id;
							var number = $("#edit_number").textbox("getText");
							var name = $("#edit_name").textbox("getText");
							var sex = $("#edit_sex").textbox("getText");
							var phone = $("#edit_phone").textbox("getText");
							var qq = $("#edit_qq").textbox("getText");
							var data = {id:id, number:number, name:name,sex:sex,phone:phone,qq:qq,course:chooseCourse};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=EditTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("消息提醒","修改成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//清空原表格数据
										$("#edit_number").textbox('setValue', "");
										$("#edit_name").textbox('setValue', "");
										$("#edit_sex").textbox('setValue', "男");
										$("#edit_phone").textbox('setValue', "");
										$("#edit_qq").textbox('setValue', "");
										$(table).find(".chooseTr").remove();
										
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("消息提醒","修改失败!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#edit_name").textbox('setValue', "");
						$("#edit_phone").textbox('setValue', "");
						$("#edit_qq").textbox('setValue', "");
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_number").textbox('setValue', selectRow.number);
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_sex").textbox('setValue', selectRow.sex);
				$("#edit_phone").textbox('setValue', selectRow.phone);
				$("#edit_qq").textbox('setValue', selectRow.qq);
				$("#edit_photo").attr("src", "PhotoServlet?method=GetPhoto&type=3&number="+selectRow.number);
				
				var courseList = selectRow.courseList;
				
				for(var i = 0;i < courseList.length;i++){
					var gradeId = courseList[i].grade.id;
					var gradeName = courseList[i].grade.name;
					var clazzId = courseList[i].clazz.id;
					var clazzName = courseList[i].clazz.name;
					var courseId = courseList[i].course.id;
					var courseName = courseList[i].course.name;
					//添加到表格显示
					var tr = $("<tr class='chooseTr'><td>课程:</td></tr>");
					
		    		var gradeTd = $("<td></td>");
		    		var gradeInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='gradeid' />").val(gradeName).attr("gradeId", gradeId);
		    		$(gradeInput).appendTo(gradeTd);
		    		$(gradeTd).appendTo(tr);
		    		
		    		var clazzTd = $("<td></td>");
		    		var clazzInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='clazzid' />").val(clazzName).attr("clazzId", clazzId);
		    		$(clazzInput).appendTo(clazzTd);
		    		$(clazzTd).appendTo(tr);
		    		
		    		var courseTd = $("<td></td>");
		    		var courseInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='courseid' />").val(courseName).attr("courseId", courseId);
		    		$(courseInput).appendTo(courseTd);
		    		$(courseTd).appendTo(tr);
		    		
		    		var removeTd = $("<td></td>");
		    		var removeA = $("<a href='javascript:;' class='easyui-linkbutton removeBtn'></a>").attr("data-options", "iconCls:'icon-remove'");
		    		$(removeA).appendTo(removeTd);
		    		$(removeTd).appendTo(tr);
		    		
		    		$(tr).appendTo(table);
		    		
		    		//解析
		    		$.parser.parse($(table).find(".chooseTr :last"));
					
				}
				
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_phone").textbox('setValue', "");
				$("#edit_qq").textbox('setValue', "");
				
				$(table).find(".chooseTr").remove();
			}
	    });	    
	});
	</script>
</head>

<body>
	<!-- data list -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 	    
	</table> 
	<!-- toolbar -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">edit</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">delete</a></div>
	</div>
	
	<!-- form of adding users-->
	<div id="addDialog" style="padding: 10px;">
   		<form id="addForm" method="post">
	    	<table id="addTable">
	    		<tr>
	    			<td style="width:40px">username:</td>
	    			<td>
	    				<!-- data-options: must be filled or print missing msg -->
	    				<input id="add_username"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="username" data-options="required:true, validType:'repeat', missingMessage:'Please enter username!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>password:</td>
	    			<td><input id="add_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" name="password" data-options="required:true, missingMessage:'Please enter password!'" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- 修改窗口 -->
	<div id="editDialog" style="padding: 10px">
		<div style=" position: absolute; margin-left: 560px; width: 250px; height: 300px; border: 1px solid #EEF4FF">
	    	<img id="edit_photo" alt="照片" style="max-width: 200px; max-height: 400px;" title="照片" src="" />
	    </div>   
    	<form id="editForm" method="post">
	    	<table id="editTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:40px">工号:</td>
	    			<td colspan="3"><input id="edit_number" data-options="readonly: true" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'请输入工号'" /></td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>性别:</td>
	    			<td><select id="edit_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="男">男</option><option value="女">女</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>电话:</td>
	    			<td><input id="edit_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="phone" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>QQ:</td>
	    			<td colspan="4"><input id="edit_qq" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="qq" validType="number" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	
</body>
</html>