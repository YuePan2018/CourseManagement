package com.yue.service.admin.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yue.dao.admin.StudentDao;
import com.yue.entity.admin.Student;
import com.yue.service.admin.StudentService;

@Service
public class StudentServiceImpl implements StudentService {
	@Autowired
	private StudentDao studentDao;

	@Override
	public int add(Student student) {		
		return studentDao.add(student);
	}

	@Override
	public List<Student> findList(Map<String, Object> queryMap) {
		return studentDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return studentDao.getTotal(queryMap);
	}

	@Override
	public int edit(Student student) {
		return studentDao.edit(student);
	}

	@Override
	public int delete(String str) {
		return studentDao.delete(str);
	}

	@Override
	public Student findByID(Long id) {
		return studentDao.findByID(id);
	}

}
