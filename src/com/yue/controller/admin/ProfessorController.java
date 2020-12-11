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

import com.yue.entity.admin.Professor;
import com.yue.page.Page;
import com.yue.service.admin.ProfessorService;


@RequestMapping("/professor")
@Controller
public class ProfessorController {
	
	@Autowired
	public ProfessorService professorService;
	
	/*
	 *  display page
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("professor/list");
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
		ret.put("rows", professorService.findList(queryMap));
		ret.put("total", professorService.getTotal(queryMap));
		return ret;
	}
	
	/*
	 *  add
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Professor professor){
		Map<String, String> ret = new HashMap<String, String>();
		if(professor == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		// Allow duplicate
		if(professorService.add(professor) <= 0){
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
	public Map<String, String> edit(Professor professor){
		Map<String, String> ret = new HashMap<String, String>();
		if(professor == null){
			ret.put("type", "error");
			ret.put("msg", "invalid input from front-end");
			return ret;
		}
		if(professorService.edit(professor) <= 0){
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
		if(professorService.delete(idsString) <= 0){
			ret.put("type", "error");
			ret.put("msg", "deletion fail");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "deletion success");
		return ret;
	}
}
