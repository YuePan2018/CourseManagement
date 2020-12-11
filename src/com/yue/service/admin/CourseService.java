package com.yue.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.Course;

@Service
public interface CourseService {
	public List<Course> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Course course);
	public int edit(Course course);
	public int delete(String str);
}
