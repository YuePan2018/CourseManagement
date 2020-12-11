package com.yue.service.admin.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yue.dao.admin.CourseDao;
import com.yue.entity.admin.Course;
import com.yue.service.admin.CourseService;

@Service
public class CourseServiceImpl implements CourseService {
	@Autowired
	private CourseDao courseDao;

	@Override
	public int add(Course course) {		
		return courseDao.add(course);
	}

	@Override
	public List<Course> findList(Map<String, Object> queryMap) {
		return courseDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return courseDao.getTotal(queryMap);
	}

	@Override
	public int edit(Course course) {
		return courseDao.edit(course);
	}

	@Override
	public int delete(String str) {
		return courseDao.delete(str);
	}

}
