package com.yue.controller.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yue.entity.admin.User;
import com.yue.page.Page;
import com.yue.service.admin.UserService;


@RequestMapping("/user")
@Controller
public class UserController {
	
	@Autowired
	public UserService userService;
	
	/*
	 *  display user page
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("user/list");
		return model;
	}
	
	/*
	 *  get user list from mysql
	 *  find list by pagination and pattern search of username 
	 */
	@RequestMapping(value="/get_list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(
			@RequestParam(value="username",required=false,defaultValue="") String username,
			HttpServletRequest request,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		User curUser= (User) request.getSession().getAttribute("admin");
		// if current user is not administrator, find current user instead of user list 
		if (!curUser.getRole().equals("admin")) {
			List<User> list = new ArrayList<>();
			list.add(userService.findByID(curUser.getId()));
			ret.put("rows", list);
			return ret;
		}
		queryMap.put("username", "%"+username+"%");
		queryMap.put("offset", page.getOffset());
		queryMap.put("rows", page.getRows());
		ret.put("rows", userService.findList(queryMap));
		ret.put("total", userService.getTotal(queryMap));
		return ret;
	}
	
	/*
	 *  add a user
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(User user){
		Map<String, String> ret = new HashMap<String, String>();
		if(user == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		User existedUser = userService.findByUsername(user.getUsername());
		if(existedUser != null){
			ret.put("type", "error");
			ret.put("msg", "username exists, please choose another one");
			return ret;
		}
		if(userService.add(user) <= 0){
			ret.put("type", "error");
			ret.put("msg", "mysql adding fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "add a user successfully");
		return ret;
	}
	
	/*
	 *  edit a user
	 */
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(User user){
		Map<String, String> ret = new HashMap<String, String>();
		if(user == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		User existUser = userService.findByUsername(user.getUsername());
		/*
		 * Allowed: not change username (existUser != null && user.getId() == existUser.getId())
		 * Allowed: change username without duplicate (existUser == null)
		 * Not allowed:  change username with duplicate (existUser != null && user.getId() != existUser.getId())
		 */
		if(existUser != null){
			if(user.getId() != existUser.getId()){
				ret.put("type", "error");
				ret.put("msg", "username exists, please choose another one");
				return ret;
			}			
		}
		if(userService.edit(user) <= 0){
			ret.put("type", "error");
			ret.put("msg", "MySql editing fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "edit a user successfully!");
		return ret;
	}
	
	/*
	 * delete multiple rows
	 */	
	@RequestMapping(value="/delete",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(
			@RequestParam(value="ids[]",required=true) Long[] ids
		){
		Map<String, String> ret = new HashMap<String, String>();
		if(ids == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		String idsString = "";
		for(Long id:ids){
			idsString += id + ",";
		}
		// remove ","
		idsString = idsString.substring(0,idsString.length()-1);
		if(userService.delete(idsString) <= 0){
			ret.put("type", "error");
			ret.put("msg", "deletion fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "deletion success");
		return ret;
	}
}
