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

import com.yue.entity.admin.Student;
import com.yue.page.Page;
import com.yue.service.admin.StudentService;


@RequestMapping("/student")
@Controller
public class StudentController {
	
	@Autowired
	public StudentService studentService;
	
	/*
	 *  display page
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("student/list");
		return model;
	}
	
	/*
	 *  get list from mysql
	 *  find list by pagination and pattern search of name 
	 */
	@RequestMapping(value="/get_list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(
			@RequestParam(value="name",required=false,defaultValue="") String name,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", "%"+name+"%");
		queryMap.put("offset", page.getOffset());
		queryMap.put("rows", page.getRows());
		ret.put("rows", studentService.findList(queryMap));
		ret.put("total", studentService.getTotal(queryMap));
		return ret;
	}
	
	/*
	 *  add
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Student student){
		Map<String, String> ret = new HashMap<String, String>();
		if(student == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		// Allow duplicate
		if(studentService.add(student) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Constraint Fail");
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
	public Map<String, String> edit(Student student){
		Map<String, String> ret = new HashMap<String, String>();
		if(student == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		Student existed = studentService.findById(student.getId());
		if(existed == null){
			ret.put("type", "error");
			ret.put("msg", "id not exists, please choose another one");
			return ret;
					
		}
		if(studentService.edit(student) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Constraint Fail");
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
		if(studentService.delete(idsString) <= 0){
			ret.put("type", "error");
			ret.put("msg", "deletion fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "deletion success");
		return ret;
	}
}
