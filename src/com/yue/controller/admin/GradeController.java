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

import com.yue.entity.admin.Grade;
import com.yue.page.Page;
import com.yue.service.admin.GradeService;


@RequestMapping("/grade")
@Controller
public class GradeController {
	
	@Autowired
	public GradeService gradeService;
	
	/*
	 *  display grade page
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("grade/list");
		return model;
	}
	
	/*
	 *  get grade list from mysql
	 *  find list by pagination and pattern search of gradename 
	 */
	@RequestMapping(value="/get_list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(Page page){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", page.getOffset());
		queryMap.put("rows", page.getRows());
		ret.put("rows", gradeService.findList(queryMap));
		ret.put("total", gradeService.getTotal(queryMap));
		return ret;
	}
	
	/*
	 *  add a grade
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Grade grade){
		Map<String, String> ret = new HashMap<String, String>();
		if(grade == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		// check duplicate (cid,sid)
		Grade existedGrade = gradeService.findByCidAndSid(grade.getCid(), grade.getSid());
		if(existedGrade != null){
			ret.put("type", "error");
			ret.put("msg", "grade exists, please choose another (cid,sid)");
			return ret;
		}
		// catch foreign key exception
		int num = -1;
		try {
			num = gradeService.add(grade);
		} catch (Exception e) {
			ret.put("type", "error");
			ret.put("msg", "Foreign Key Fail: (cid,sid)");
			return ret;
		}		
		if(num <= 0){
			ret.put("type", "error");
			ret.put("msg", "mysql adding fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "add success");
		return ret;
	}
	
	/*
	 *  edit a grade
	 */
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Grade grade){
		Map<String, String> ret = new HashMap<String, String>();
		if(grade == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		// no need to check duplicate or exception, because only edit grade.grade
		if(gradeService.edit(grade) <= 0){
			ret.put("type", "error");
			ret.put("msg", "MySql editing fail: no selected id");
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
		if(gradeService.delete(idsString) <= 0){
			ret.put("type", "error");
			ret.put("msg", "deletion fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "deletion success");
		return ret;
	}
}
