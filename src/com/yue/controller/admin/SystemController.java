package com.yue.controller.admin;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yue.entity.admin.User;
import com.yue.service.admin.UserService;

/*
 * SpringMVC Controller
 * 
 */

@Controller
@RequestMapping("/system")
public class SystemController {
	
	@Autowired
	private UserService userService;
	
	// super admin page (from login page)
	@RequestMapping(value= "/super_admin",method=RequestMethod.GET)
	public ModelAndView superAdmin(ModelAndView model) {
		model.setViewName("system/super_admin");
		model.addObject("name","data from MyBatis");
		return model;
	}

	// welcome page
	@RequestMapping(value="/welcome",method=RequestMethod.GET)
	public ModelAndView welcome(ModelAndView model){
		model.setViewName("system/welcome");
		return model;
	}
	
	// log in page
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public ModelAndView login(ModelAndView model){
		model.setViewName("system/login");
		return model;
	}
	
	/* 
	 * Authentication
	 * return value is in json
	 */
	@RequestMapping(value="/login",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> loginAct(User user, HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		/* user is the username and password from login page, 
		 * but "userInDB" is the corresponding user information in database 
		 */
		User userInDB = userService.findByUsername(user.getUsername());
		if(userInDB == null){
			ret.put("type", "error");
			ret.put("msg", "user not exists");
			return ret;
		}
		if(!userInDB.getPassword().equals(user.getPassword())){
			ret.put("type", "error");
			ret.put("msg", "wrong password");
			return ret;
		}
		
		// store login information in session
		request.getSession().setAttribute("admin", userInDB);	
		// return data to jsp 
		ret.put("type", "success");
		ret.put("msg", "login success");
		return ret;
	}
	
	/*
	 * logout
	 */
	@RequestMapping(value = "/login_out",method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request){
		request.getSession().setAttribute("user", null);
		return "redirect:login";
	}
}
