package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.Student;

@Repository
public interface StudentDao {
	public List<Student> findList(Map<String, Object> queryMap);
	public Student findByID(Long id);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Student student);
	public int edit(Student student);
	public int delete(String str);
}
