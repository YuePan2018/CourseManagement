package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.Course;

@Repository
public interface CourseDao {
	public List<Course> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Course course);
	public int edit(Course course);
	public int delete(String str);
}
