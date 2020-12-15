<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	        url:"get_list?t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,
	        pagination:true,
	        rownumbers:true, 
	        sortName:'id',
	        sortOrder:'asc', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},   
 		        {field:'username',title:'username',width:150, sortable: true},
 		        {field:'password',title:'password',width:100},
 		    	{field:'role',title:'role',width:150, sortable: true},
 		    	{field:'roleID',title:'roleID',width:150},
	 		]], 
	        toolbar: "#toolbar"
	    }); 
		
	    // pagination
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,	// defaut page size
	        pageList: [5,10,20,30,50],	//optional page size 
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
            	$.messager.alert("message", "please select one row", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("message", "please select rows", "warning");
            } else{
            	// get an array of ids as data
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("message", "deleting all selected rows, please confirm", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "delete",
							data: {ids: ids},
							dataType:'json',
							success: function(data){
								if(data.type == "success"){
									$.messager.alert("message",data.msg,"info");
									// reload
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("message",data.msg,"warning");
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
										$.messager.alert("message",data.msg,"info");
										$("#addDialog").dialog("close");
										// empty old form
										$("#add_username").textbox('setValue', "");
										$("#add_password").textbox('setValue', "");
										$("#add_roleID").textbox('setValue', "");
										//reload datagrid
							  			$('#dataList').datagrid("reload");										
									} else{
										$.messager.alert("message",data.msg,"warning");
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
				$("#add_roleID").textbox('setValue', "");
			}
	    });
	  	
	  	// dialog of editing
	  	$("#editDialog").dialog({
	  		title: "edit user",
	    	width: 350,
	    	height: 200,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'submit',
					plain: true,
					iconCls:'icon-edit',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("message","invalid input","warning");
							return;
						} else{
							var data = $("#editForm").serialize();
							$.ajax({
								type: "post",
								url: "edit",
								data: data,
								dataType:'json',
								success: function(data){
									if(data.type == "success"){
										$.messager.alert("message",data.msg,"info");
										$("#editDialog").dialog("close");										
										//reload
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");										
									} else{
										$.messager.alert("message",data.msg,"warning");
										return;
									}
								}
							});
						}
					}
				}, 				
			],
			// load selected username to form before edit 
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				// load hidden id and username to form before editing				
				$("#edit-id").val(selectRow.id);
				$("#edit_username").textbox('setValue', selectRow.username);
				$("#edit_password").textbox('setValue', selectRow.password);
				$("#edit_roleID").textbox('setValue', selectRow.roleID);
			},
	    });	  	
	  	// search function
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('reload',{
	  			username:$("#search-username").textbox('getValue')
	  		});
	  	});
	});
	</script>
</head>

<body>
	<!-- data list -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 	    
	</table> 
	<!-- toolbar: add, edit, delete, search -->
	<div id="toolbar">
		<!-- only administrator can add, delete and search -->
		<c:if test="${admin.role == 'admin'}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">edit</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${admin.role == 'admin'}">
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">delete</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		By username：<input id="search-username" class="easyui-textbox" />
		<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">search</a>
		</c:if>
	</div>
	
	<!-- form of adding-->
	<div id="addDialog" style="padding: 10px;">
   		<form id="addForm" method="post">
	    	<table id="addTable">
	    		<tr>
	    			<td style="width:40px">username:</td>
	    			<td>
	    				<!-- data-options: must be filled or print missing msg -->
	    				<input id="add_username"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="username" data-options="required:true, missingMessage:'Please enter a username!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>password:</td>
	    			<td><input id="add_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" name="password" data-options="required:true, missingMessage:'Please enter a password!'" /></td>
	    		</tr>
	    		<tr>
	    			<td>role</td>
	    			<td>
	    				<select id="add_role"  class="easyui-combobox" style="width: 200px;" name="role" data-options="required:true, missingMessage:'please select a role'">
	    					<option value="student">student</option>
	    					<option value="professor">professor</option>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>roleID:</td>
	    			<td><input id="add_roleID" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="roleID" data-options="required:false" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- form of edit -->
	<div id="editDialog" style="padding: 10px">		 
    	<form id="editForm" method="post">
    		<!-- get id from selected row but hide it -->
    		<input type="hidden" name="id" id="edit-id">
	    	<table id="editTable" >
	    		<tr>
	    			<td style="width:40px">username:</td>
	    			<td>
	    				<!-- data-options: must be filled or print missing msg -->
	    				<input id="edit_username"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="username" data-options="required:true, missingMessage:'Please enter a username!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>password:</td>
	    			<td><input id="edit_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" name="password" data-options="required:true, missingMessage:'Please enter a password!'" /></td>
	    		</tr>
	    		<c:if test="${admin.role == 'admin'}">
	    		<tr>
	    			<td>roleID:</td>
	    			<td><input id="edit_roleID" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="roleID" data-options="required:false" /></td>
	    		</tr>
	    		</c:if>
	    		<c:if test="${admin.role != 'admin'}">
	    		<tr>
	    			<td>roleID:</td>
	    			<td><input id="edit_roleID" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="roleID" data-options="required:false" readonly="true"/></td>
	    		</tr>
	    		</c:if>
	    	</table>	    	
	    </form>
	</div>
	
	
</body>
</html>