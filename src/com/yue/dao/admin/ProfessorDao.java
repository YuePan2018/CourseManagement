package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.Professor;

@Repository
public interface ProfessorDao {
	public Professor findById(Long id);
	public List<Professor> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Professor professor);
	public int edit(Professor professor);
	public int delete(String str);
}
