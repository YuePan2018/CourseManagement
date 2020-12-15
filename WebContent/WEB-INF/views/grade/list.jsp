<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>grade list</title>
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
	        title:'grade list', 
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
 		        {field:'cid',title:'cid',width:150, sortable: true},
 		    	{field:'sid',title:'sid',width:150, sortable: true},
 		    	{field:'grade',title:'grade',width:150, sortable: true},
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
	    	title: "add a grade",
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
					iconCls:'icon-add',
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
										$("#add_cid").textbox('setValue', "");
										$("#add_sid").textbox('setValue', "");
										$("#add_grade").textbox('setValue', "");
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
				$("#add_cid").textbox('setValue', "");
				$("#add_sid").textbox('setValue', "");
				$("#add_grade").textbox('setValue', "");
			}
	    });
	  	
	  	// dialog of editing
	  	$("#editDialog").dialog({
	  		title: "edit grade",
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
			// load selected to form before edit 
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				// load hidden id and grade to form before editing				
				$("#edit-id").val(selectRow.id);
				$("#edit_grade").textbox('setValue', selectRow.grade);
			},
	    });
	 	// search function
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('reload');
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
		<c:if test="${admin.role == 'admin'}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">edit</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">delete</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">reload</a>
	</div>
	
	<!-- form of adding-->
	<div id="addDialog" style="padding: 10px;">
   		<form id="addForm" method="post">
	    	<table id="addTable">
	    		<tr>
	    			<td style="width:40px">cid:</td>
	    			<td>
	    				<!-- data-options: must be filled or print missing msg -->
	    				<input id="add_cid"  class="easyui-numberbox" style="width: 200px; height: 30px;" type="text" name="cid" data-options="required:true, missingMessage:'Please enter a cid!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>sid:</td>
	    			<td><input id="add_sid" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="sid" data-options="required:true, missingMessage:'Please enter a sid!'" /></td>
	    		</tr>
	    		<tr>
	    			<td>grade:</td>
	    			<td><input id="add_grade" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="grade" data-options="required:true, missingMessage:'Please enter a grade!', validType:'length[1,2]'" /></td>
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
	    			<td style="width:40px">grade:</td>
	    			<td>
	    				<!-- data-options: must be filled or print missing msg -->
	    				<input id="edit_grade"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="grade" data-options="required:true, missingMessage:'Please enter a grade!', validType:'length[1,2]'" />
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	
</body>
</html>