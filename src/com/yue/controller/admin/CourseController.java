package com.yue.controller.admin;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yue.entity.admin.Course;
import com.yue.page.Page;
import com.yue.service.admin.CourseService;


@RequestMapping("/course")
@Controller
public class CourseController {
	
	@Autowired
	public CourseService courseService;
	
	/*
	 *  display page
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("course/list");
		return model;
	}
	
	/*
	 *  get list from mysql
	 *  find list by pagination and pattern search of name 
	 */
	@RequestMapping(value="/get_list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(
			@RequestParam(value="title",required=false,defaultValue="") String title,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("title", "%"+title+"%");
		queryMap.put("offset", page.getOffset());
		queryMap.put("rows", page.getRows());
		ret.put("rows", courseService.findList(queryMap));
		ret.put("total", courseService.getTotal(queryMap));
		return ret;
	}
	
	/*
	 *  add
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Course course){
		Map<String, String> ret = new HashMap<String, String>();
		if(course == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		// Allow duplicate
		int num = -1;
		try {
			num = courseService.add(course);
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "Foreign Key Fail: pid from professor");
			return ret;
		}		
		if(num <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add Fail: mysql can't find such id, please refresh list");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "add success");
		return ret;
		
	}
	
	/*
	 *  edit
	 */
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Course course){
		Map<String, String> ret = new HashMap<String, String>();
		if(course == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		int num = -1;
		try {
			num = courseService.edit(course);
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "Foreign Key Fail: pid from professor");
			return ret;
		}
		if(num <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit Fail: mysql can't find such id, please refresh list");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "edit success!");
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
		if(courseService.delete(idsString) <= 0){
			ret.put("type", "error");
			ret.put("msg", "deletion fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "deletion success");
		return ret;
	}
}
