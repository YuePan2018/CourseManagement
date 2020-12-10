package com.yue.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.Student;

@Service
public interface StudentService {
	public Student findById(Long id);
	public List<Student> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Student student);
	public int edit(Student student);
	public int delete(String str);
}
