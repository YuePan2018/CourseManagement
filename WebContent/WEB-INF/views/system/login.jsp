<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- modified and saved from an open source h-ui template https://www.mycodes.net/190/10098.htm -->
<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
  <title>Login Page</title>
  <meta name="description" content="particles.js is a lightweight JavaScript library for creating particles.">
  <meta name="author" content="Vincent Garreau">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link rel="stylesheet" media="screen" href="../resources/admin/login/css/style.css">
  <link rel="stylesheet" type="text/css" href="../resources/admin/login/css/reset.css">
<body>

<div id="particles-js">
		<div class="login" style="display: block;">
			<div class="login-top">
				Login
			</div>
			<div class="login-center clearfix">
				<div class="login-center-img"><img src="../resources/admin/login/images/name.png"></div>
				<div class="login-center-input">
					<input type="text" name="username" id="username" value="" placeholder="enter username here" onfocus="this.placeholder=&#39;&#39;" onblur="this.placeholder=&#39;enter username here&#39;">
					<div class="login-center-input-text">username</div>
				</div>
			</div>
			<div class="login-center clearfix">
				<div class="login-center-img"><img src="../resources/admin/login/images/password.png"></div>
				<div class="login-center-input">
					<input type="password" name="password" id="password" value="" placeholder="enter password here" onfocus="this.placeholder=&#39;&#39;" onblur="this.placeholder=&#39;enter password here&#39;">
					<div class="login-center-input-text">password</div>
				</div>
			</div>
			<div class="login-button">
				Login
			</div>
		</div>
		<div class="sk-rotating-plane"></div>
<canvas class="particles-js-canvas-el" width="1147" height="952" style="width: 100%; height: 100%;"></canvas></div>

<!-- scripts -->
<script src="../resources/admin/login/js/particles.min.js"></script>
<script src="../resources/admin/login/js/app.js"></script>
<script src="../resources/admin/login/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
	function hasClass(elem, cls) {
	  cls = cls || '';
	  if (cls.replace(/\s/g, '').length == 0) return false; //当cls没有参数时，返回false
	  return new RegExp(' ' + cls + ' ').test(' ' + elem.className + ' ');
	}
	 
	function addClass(ele, cls) {
	  if (!hasClass(ele, cls)) {
	    ele.className = ele.className == '' ? cls : ele.className + ' ' + cls;
	  }
	}
	 
	function removeClass(ele, cls) {
	  if (hasClass(ele, cls)) {
	    var newClass = ' ' + ele.className.replace(/[\t\r\n]/g, '') + ' ';
	    while (newClass.indexOf(' ' + cls + ' ') >= 0) {
	      newClass = newClass.replace(' ' + cls + ' ', ' ');
	    }
	    ele.className = newClass.replace(/^\s+|\s+$/g, '');
	  }
	}
	// login jquery
	document.querySelector(".login-button").onclick = function(){
			var username = $("#username").val();
			var password = $("#password").val();
			if(username == '' || username == 'undefined'){
				alert("please enter username！");
				return;
			}
			if(password == '' || password == 'undefined'){
				alert("please enter password！");
				return;
			}				
			
			addClass(document.querySelector(".login"), "active")
			addClass(document.querySelector(".sk-rotating-plane"), "active")
			document.querySelector(".login").style.display = "none"
			$.ajax({
				url:'login',
				data:{username:username,password:password},
				type:'post',
				dataType:'json',
				success:function(data){
					if(data.type == 'success'){
						window.parent.location = 'index';
					}else{
						removeClass(document.querySelector(".login"), "active");
						removeClass(document.querySelector(".sk-rotating-plane"), "active");
						document.querySelector(".login").style.display = "block";
						alert(data.msg);
					}
				}
			});
			return;
	}
</script>
</body></html>