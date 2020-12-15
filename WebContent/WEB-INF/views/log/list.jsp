<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>log list</title>
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/demo.css">
	<script type="text/javascript" src="../resources/admin/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="../resources/admin/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="../resources/admin/easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	function add0(m){return m<10?'0'+m:m }
	function format(shijianchuo){
	//shijianchuo是整数，否则要parseInt转换
		var time = new Date(shijianchuo);
		var y = time.getFullYear();
		var m = time.getMonth()+1;
		var d = time.getDate();
		var h = time.getHours();
		var mm = time.getMinutes();
		var s = time.getSeconds();
		return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
	}
	
	$(function() {	
		var table;		
		// retrieve dataList and display it in datagrid
	    $('#dataList').datagrid({ 
	        title:'log list', 
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
 		        {field:'id',title:'id',width:50, sortable: true},   
 		        {field:'content',title:'content',width:400, sortable: true},
 		    	{field:'time',title:'time',width:200, sortable: true, formatter:function(value,row,index){
 					return format(value);
 				}},
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
	    
	    // delete function
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
	    
	  	// search function
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('reload',{
	  			content:$("#search-content").textbox('getValue')
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
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">delete</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		By content：<input id="search-content" class="easyui-textbox" />
		<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">search</a>
	</div>
</body>
</html>